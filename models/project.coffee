cache = {}

Model = require './model'
_ = require 'underscore'
axios = require 'axios'

source = undefined # reference to cancel token
originalUrlPath = "/"
originalQueryString = ""

module.exports = Project = (I={}, self=Model(I)) ->
  
  if cache[I.id]
    return cache[I.id]

  self.defaults I,
    domain: undefined
    id: undefined
    description: undefined
    users: undefined
    showAsGlitchTeam: false

  self.attrObservable Object.keys(I)...
  self.attrObservable "readme", "readmeNotFound", "projectNotFound", "fetched", "displayName"
  self.attrModels 'users', User
  self.attrReader "private"

  self.extend

    name: ->
      self.domain()
  
    editUrl: ->
      if I.line
        "#{EDITOR_URL}#!/#{I.domain}?path=#{I.path}:#{I.line}:#{I.character}"
      else
        "#{EDITOR_URL}#!/#{I.domain}"

    userIsCurrentUser: (application) ->
      userIsCurrentUser = _.find self.users(), (user) ->
        user.id() is application.currentUser().id()
      true if userIsCurrentUser

    avatar: ->
      "#{CDN_URL}/project-avatar/#{self.id()}.png"
        
    getReadme: (application) ->
      CancelToken = axios.CancelToken
      source = CancelToken.source()
      self.readme undefined
      self.readmeNotFound undefined
      self.projectNotFound undefined
      path = "projects/#{self.id()}/readme"
      if application.currentUser()?.persistentToken()
        path += "?token=#{application.currentUser()?.persistentToken()}"
      application.api(source).get path
      .then (response) ->
        self.readme response.data
        application.overlayProject self
      .catch (error) ->
        console.error "getReadme", error
        if error.response.status is 404
          self.readmeNotFound true
        else
          self.projectNotFound true

    showOverlay: (application) ->
      console.log 'showOverlay'
      application.overlayProject self
      self.getReadme application
      originalUrlPath = window.location.pathname
      originalQueryString = window.location.search
      history.replaceState null, "#{self.domain()} – Glitch", "~#{self.domain()}"
      application.overlayProjectVisible true
      document.getElementsByClassName('project-overlay')[0].focus()

    hideOverlay: (application) ->
      source.cancel('Operation canceled by the user.')
      history.replaceState(null, null, originalUrlPath + originalQueryString)

    pushSearchResult: (application) ->
      application.searchResultsProjects.push self
      application.searchResultsProjectsLoaded true

    isPinnedByUser: (application) ->
      pins = application.user().pins().map (pin) ->
        pin.projectId
      _.contains pins, self.id()

    isPinnedByTeam: (application) ->
      pins = application.team().pins().map (pin) ->
        pin.projectId
      _.contains pins, self.id()
      
      
  cache[I.id] = self
  # console.log '💎 project cache', cache

  return self


Project.getProjectsByIds = (api, ids) ->
  NUMBER_OF_PROJECTS_PER_REQUEST = 40
  newProjectIds = ids.filter (id) ->
    project = cache[id]
    !project or !project.fetched()
  # fetch the ids in groups so they fit into max allowable url length
  projectIdGroups = newProjectIds.map (id, index) ->
    if index % NUMBER_OF_PROJECTS_PER_REQUEST is 0 
      newProjectIds.slice(index, index + NUMBER_OF_PROJECTS_PER_REQUEST)       
    else null
  .filter (id) ->
    id
  projectIdGroups.forEach (group) ->
    projectsPath = "projects/byIds?ids=#{group.join(',')}"
    api.get projectsPath
    .then ({data}) ->
      data.forEach (datum) ->
        datum.fetched = true
        Project(datum).update(datum)
      ids.map (id) ->
        Project id: id
    .catch (error) ->
        console.error "getProjectsByIds", error

Project.getProjectOverlay = (application, domain) ->
  projectPath = "projects/#{domain}"
  application.overlayProjectVisible true
  application.api().get projectPath
  .then ({data}) ->
    Project(data).showOverlay application
  .catch (error) ->
    console.error "getProjectOverlay", error

Project.getSearchResults = (application, query) ->
  MAX_RESULTS = 20
  CancelToken = axios.CancelToken
  source = CancelToken.source()
  application.searchResultsUsers []
  application.searchingForProjects true
  searchPath = "projects/search?q=#{query}"
  application.api(source).get searchPath
  .then ({data}) ->
    application.searchingForProjects false
    data = data.slice(0 , MAX_RESULTS)
    if data.length is 0
      application.searchResultsHaveNoProjects true
    data.forEach (datum) ->
      datum.fetched = true
      Project(datum).update(datum).pushSearchResult(application)
  .catch (error) ->
    console.error 'getSearchResults', error


Project._cache = cache

# Circular dependencies must go below module.exports
User = require "./user"
