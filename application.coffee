Observable = require 'o_0'
_ = require 'underscore'
axios = require 'axios'

cachedCategories = require './cache/categories.json'
cachedTeams = require './cache/teams.json'

Model = require "./models/model"

User = require './models/user'
Project = require './models/project'
Category = require './models/category'
Team = require './models/team'
Question = require './models/question'

cachedUser = 
  if localStorage.cachedUser
    try
      JSON.parse(localStorage.cachedUser)
    catch
      {}


self = Model(
    featuredProjects: FEATURED_PROJECTS
    currentUser: cachedUser
  ).extend

  # overlays
  overlayProjectVisible: Observable false
  overlayProject: Observable undefined
  overlayVideoVisible: Observable false
  
  # pop overs
  signInPopVisibleOnHeader: Observable false
  signInPopVisibleOnRecentProjects: Observable false
  userOptionsPopVisible: Observable false
  ctaPopVisible: Observable false
  addTeamUserPopVisible: Observable false
  addTeamProjectPopVisible: Observable false

  # search
  searchQuery: Observable ""
  searchingForUsers: Observable false
  searchResultsUsers: Observable []
  searchResultsUsersLoaded: Observable false
  searchResultsHaveNoUsers: Observable false

  searchingForProjects: Observable false
  searchResultsProjects: Observable []
  searchResultsProjectsLoaded: Observable false
  searchResultsHaveNoProjects: Observable false

  searchingForTeams: Observable false
  searchResultsTeams: Observable []
  searchResultsTeamsLoaded: Observable false
  searchResultsHaveNoTeams: Observable false
  
  # questions
  questions: Observable []
  gettingQuestions: Observable false

  # pages
  pageIsTeamPage: Observable false
  pageIsUserPage: Observable false
  
  # category page
  category: Observable {}
  categoryProjectsLoaded: Observable false

  # notifications
  notifyUserDescriptionUpdated: Observable false # unused
  notifyUploading: ->
    self.uploadFilesRemaining() > 0
  notifyUploadFailure: Observable false

  # upload status
  pendingUploads: Observable []
  uploadFilesRemaining: ->
    self.pendingUploads().length
  uploadProgress: -> # Integer between 0..100
    pendingUploads = self.pendingUploads()
    numberOfPendingUploads = pendingUploads.length

    progress = pendingUploads.reduce (value, {ratio}) ->
      value + ratio()
    , 0

    (progress / numberOfPendingUploads * 100) | 0
  
  normalizedBaseUrl: ->
    urlLength = baseUrl.length
    lastCharacter = baseUrl.charAt(urlLength-1)
    if baseUrl is ""
      return "/"
    else if lastCharacter is not "/"
      return baseUrl + "/"
    else
      return baseUrl

  closeAllPopOvers: ->
    console.log 'closeAllPopOvers'
    $(".pop-over.disposable, .overlay-background.disposable").remove()
    self.signInPopVisibleOnHeader false
    self.signInPopVisibleOnRecentProjects false
    self.userOptionsPopVisible false
    self.ctaPopVisible false
    self.addTeamUserPopVisible false
    self.addTeamProjectPopVisible false
    self.overlayProjectVisible false
    self.overlayVideoVisible false

  searchProjects: (query) ->
    self.searchResultsProjects []
    Project.getSearchResults application, query

  searchUsers: (query) ->
    self.searchResultsUsers []
    User.getSearchResults application, query

  searchTeams: (query) ->
    self.searchResultsTeams []
    Team.getSearchResults application, query
    
    
  api: (source) ->
    persistentToken = self.currentUser()?.persistentToken()
    if persistentToken
      axios.create  
        baseURL: API_URL
        cancelToken: source?.token
        headers:
          Authorization: persistentToken
    else
      axios.create
        baseURL: API_URL
        cancelToken: source?.token

  storeLocal: (key, value) ->
    try
      window.localStorage[key] = JSON.stringify value
    catch
      console.warn "Could not save to localStorage. (localStorage is disabled in private Safari windows)"

  getLocal: (key) ->
    try
      JSON.parse window.localStorage[key]

  getUserPrefs: ->
    self.getLocal('userPrefs') or {}

  getUserPref: (key) ->
    self.getUserPrefs()[key]

  updateUserPrefs: (key, value) ->
    prefs = self.getUserPrefs()
    prefs[key] = value
    self.storeLocal('userPrefs', prefs)
    
  login: (provider, code) ->
    console.log provider, code
    if provider == "facebook"
      # capitalize for analytics
      provider = "Facebook"
      callbackURL = "#{APP_URL}/login/facebook"
      authURL = "/auth/facebook/#{code}?callbackURL=#{encodeURIComponent callbackURL}"
    else
      provider = "GitHub"
      authURL = "/auth/github/#{code}"
    self.api().post "#{authURL}"
    .then (response) ->
      analytics.track "Signed In",
        provider: provider
      console.log "LOGGED IN", response.data
      self.currentUser User response.data
      self.storeLocal 'cachedUser', response.data

  getUserByLogin: (login) ->
    User.getUserByLogin application, login

  getUserById: (id) ->
    User.getUserById application, id

  getTeamById: (id) ->
    Team.getTeamById application, id

  saveCurrentUser: (userData) ->
    userData.fetched = true
    console.log '👀 current user data is ', userData
    self.currentUser().update(userData)
    teams = self.currentUser().teams().map (datum) ->
      Team(datum)
    self.currentUser().teams teams

  saveUser: (userData) ->
    userData.fetched = true
    userData.initialDescription = userData.description
    console.log '👀 user data is ', userData
    self.user User(userData).update(userData)
    self.getProjects userData.projects

  saveTeam: (teamData) ->
    teamData.fetched = true
    console.log '👀 team data is ', teamData
    self.team Team(teamData).update(teamData)
    self.getProjects teamData.projects

  getProjects: (projectsData) ->
    projectIds = projectsData.map (project) ->
      project.id
    Project.getProjectsByIds(self.api(), projectIds)

  getUsers: (usersData) ->
    userIds = usersData.map (user) ->
      user.id
    User.getUsersById(self.api(), userIds)

  getCategory: (url) ->
    categoryData = _.find cachedCategories, (category) ->
      category.url is url
    self.category Category(categoryData)
    Category.updateCategory application, categoryData.id

  getRandomCategories: (numberOfCategories, projectsPerCategory) ->
    Category.getRandomCategories(self, numberOfCategories, projectsPerCategory)
    .then (categories) ->
      self.categories categories

  getCategories: ->
    Category.getCategories(self)
    .then (categories) -> 
      self.categories categories

  getQuestions: ->
    questions = await Question.getQuestions self
    self.questions questions
    
  fogcreekAge: ->
    FOUNDED = 2001
    current = new Date().getFullYear()
    current - FOUNDED

  showProjectOverlayPage: (domain) ->
    Project.getProjectOverlay(application, domain)

  # client.coffee routing helpers
  # TODO?: move to utils.coffee
  
  removeFirstCharacter: (string) ->
    # ex: ~cool to cool
    firstCharacterPosition = 1
    end = string.length
    string.substring(firstCharacterPosition, end)

  isProjectUrl: (url) ->
    if url.charAt(0) is "~"
      true

  isUserProfileUrl: (url) ->
    if url.charAt(0) is "@"
      true

  isAnonUserProfileUrl: (url) ->
    if url.match(/^(user\/)/g) # matches "user/" at beginning of url
      true
  
  anonProfileIdFromUrl: (url) ->
    url.replace(/^(user\/)/g, '')
  
  isSearchUrl: (url, queryString) ->
    queryStringKeys = _.keys queryString # ['q', 'blah']
    if (url is 'search') and (_.contains queryStringKeys, 'q')
      true

  isCategoryUrl: (url) ->
    true if _.find cachedCategories, (category) ->
      category.url is url

  isTeamUrl: (url) ->
    true if _.find cachedTeams, (team) ->
      team.url is url

  getCachedTeamByUrl: (url) ->
    _.find cachedTeams, (team) ->
      team.url is url

  isQuestionsUrl: (url) ->
    if url is 'questions'
      true

      
self.attrModel "user", User
self.attrModel "currentUser", User
self.attrModels "featuredProjects", Project
self.attrModels "categories", Category
self.attrModel "category", Category
self.attrModel "team", Team
self.attrModel "question", Question

global.application = self
global.API_URL = API_URL
global.EDITOR_URL = EDITOR_URL
global.User = User
global.Project = Project
global.Category = Category
global.Team = Team
global.Question = Question

module.exports = self
