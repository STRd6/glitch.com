# This client-side CoffeeScript is compiled 
# by express browserify middleware using the
# coffeeify transform

require 'babel-polyfill'

global.FEATURED_PROJECTS = require "./curated/featured"

require "./extensions"

application = require './application'
qs = require 'querystringify'
queryString = qs.parse window.location.search
_ = require 'underscore'

IndexPage = require "./presenters/pages/index"
CategoryPage = require "./presenters/pages/category"
UserPage = require "./presenters/pages/user"
TeamPage = require "./presenters/pages/team"
QuestionsPage = require "./presenters/pages/questions"
SearchPage = require "./presenters/pages/search"
errorPageTemplate = require "./templates/pages/error"

normalizedRoute = route.replace(/^\/|\/$/g, "").toLowerCase()
console.log "#########"
console.log "normalizedRoute is #{normalizedRoute}"
console.log "❓ query strings are", queryString
console.log "🎏 application is", application
console.log "👻 current user is", application.currentUser()
console.log "🌈 isSignedIn", application.currentUser().isSignedIn()
console.log "#########"



# client-side routing:

Promise.resolve()
.then ->
  if document.location.hash.startsWith "#!/"
    document.location = EDITOR_URL + document.location.hash
    return
.then ->
  if normalizedRoute.startsWith "login/"
    application.login normalizedRoute.substring("login/".length), queryString.code
    .then ->
      history.replaceState null, null, "#{baseUrl}/"
      normalizedRoute = ""
.then ->
  currentUserId = application.currentUser().id()
  if currentUserId
    application.getUserById currentUserId
  user = application.currentUser()
  if application.currentUser().isSignedIn()
    analytics.identify user.id(),
      name: user.name()
      login: user.login()
      email: user.email()
      created_at: user.createdAt()

  # index page ✅
  if normalizedRoute is "index.html" or normalizedRoute is ""
    application.getRandomCategories()
    application.getQuestions()
    indexPage = IndexPage application
    document.body.appendChild indexPage


  # questions page ✅
  else if application.isQuestionsUrl(normalizedRoute)
    application.getCategories()
    questionsPage = QuestionsPage application
    document.body.appendChild questionsPage
    # TODO append active projects count to document.title . i.e. Questions (12)
    document.title = "Questions"


  # ~project overlay page ✅
  else if application.isProjectUrl(normalizedRoute)
    projectDomain = application.removeFirstCharacter normalizedRoute
    application.showProjectOverlayPage projectDomain
    application.getRandomCategories()
    indexPage = IndexPage application
    document.body.appendChild indexPage

  
  # user page ✅
  else if application.isUserProfileUrl(normalizedRoute)
    application.pageIsUserPage true
    userLogin = normalizedRoute.substring 1, normalizedRoute.length
    userPage = UserPage(application, userLogin)
    application.getUserByLogin userLogin
    document.body.appendChild userPage
    document.title = decodeURI normalizedRoute


  # anon user page ✅
  else if application.isAnonUserProfileUrl(normalizedRoute)
    application.pageIsUserPage true
    userId = application.anonProfileIdFromUrl normalizedRoute
    userPage = UserPage(application, userId)
    application.getUserById userId
    document.body.appendChild userPage
    document.title = normalizedRoute

    
  # team page ✅
  else if application.isTeamUrl(normalizedRoute)
    application.pageIsTeamPage true
    team = application.getCachedTeamByUrl(normalizedRoute)
    teamPage = TeamPage(application)
    application.getTeamById team.id
    document.body.appendChild teamPage
    document.title = team.name

    
  # search page ✅
  else if application.isSearchUrl(normalizedRoute, queryString)
    application.getRandomCategories()
    query = queryString.q
    application.searchQuery query
    application.searchTeams query
    application.searchUsers query
    application.searchProjects query
    searchPage = SearchPage application
    document.body.appendChild searchPage
    document.title = "Search for #{query}"


  # category page ✅
  else if application.isCategoryUrl(normalizedRoute)
    application.getCategories()
    application.getCategory normalizedRoute
    categoryPage = CategoryPage application
    document.body.appendChild categoryPage
    document.title = application.category().name()    

    
  # lol wut
  else if normalizedRoute is 'wp-login.php'
    location.assign('https://www.youtube.com/embed/DLzxrzFCyOs?autoplay=1')


  # error page ✅
  else
    errorPage = errorPageTemplate application
    document.body.appendChild errorPage
    document.title = "👻 Page not found"
  
.catch (error) ->
  console.error error
  throw error

document.addEventListener "click", (event) ->
  globalclick event
document.addEventListener "keyup", (event) ->
  escapeKey = 27
  tabKey = 9
  if event.keyCode == escapeKey
    application.closeAllPopOvers()
  else if event.keyCode == tabKey
    globalclick event

globalclick = (event) ->
  unless $(event.target).closest('.pop-over, .opens-pop-over, .overlay').length
    application.closeAllPopOvers()
