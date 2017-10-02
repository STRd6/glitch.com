###
We use a cache to keep an identity map of users by id.

When constructing a user model User(...) if it has an id
field it will be cached based on the id. If the id already
exists in the cache the same reference to that model will be
returned.

If the id property is not given the model is not cached.
###

isuuid = require 'isuuid'
_ = require 'underscore'
axios = require 'axios'
md = require('markdown-it')
  breaks: true
  linkify: true
  typographer: true
.disable(['image'])

Model = require './model'
cache = {}
cacheBuster = Math.floor(Math.random() * 1000)

module.exports = User = (I={}, self=Model(I)) ->

  if cache[I.id]
    return cache[I.id]
  
  self.defaults I,
    id: undefined
    facebookId: undefined
    avatarUrl: undefined
    color: undefined
    hasCoverImage: false
    coverColor: "#1F33D9"
    login: null
    name: null
    description: ""
    initialDescription: ""
    projects: undefined
    teams: undefined
    thanksCount: 0
    fetched: false
    showAsGlitchTeam: false
    persistentToken: null
    pins: []

  self.attrObservable Object.keys(I)...
  self.attrObservable "notFound"
  self.attrObservable "localCoverImage"
  self.attrModels 'projects', Project

  self.extend

    isSignedIn: ->
      true if self.login()

    isAnon: ->
      true unless self.login()

    isAnExperiencedUser: ->
      if self.login() and self.projects().length > 1
        true

    coverUrl: (size) ->
      size = size or 'large'
      if self.hasCoverImage()
        "https://s3.amazonaws.com/production-assetsbucket-8ljvyr1xczmb/user-cover/#{self.id()}/#{size}?#{cacheBuster}"
      else
        "https://cdn.glitch.com/55f8497b-3334-43ca-851e-6c9780082244%2Fdefault-cover-wide.svg?1503518400625"

    userAvatarUrl: (size) ->
      size = size or 'small'
      if self.isAnon()
        "https://cdn.glitch.com/f6949da2-781d-4fd5-81e6-1fdd56350165%2Fanon-user-on-project-avatar.svg"
      else if self.facebookId()
        "https://graph.facebook.com/#{self.facebookId()}/picture?type=#{size}"
      else
        self.avatarUrl()
        # self.avatarUrl size

    isCurrentUser: (application) ->
      true if self.id() is application.currentUser().id()

    isOnUserPageForCurrentUser: (application) ->
      true if application.pageIsUserPage() and self.isCurrentUser(application)

    hiddenIfSignedIn: ->
      'hidden' if self.isSignedIn()

    hiddenUnlessSignedIn: ->
      'hidden' unless self.isSignedIn()

    #
    # hiddenIfAnon: ->
    #   'hidden' if self.isAnon()

    hiddenIfFetched: ->
      'hidden' if self.fetched()

    hiddenUnlessFetched: ->
      'hidden' unless self.fetched()

    tooltipName: ->
      self.login() or "anonymous user"
    
    alt: ->
      "#{I.login} avatar"
    
    style: ->
      backgroundColor: I.color
    
    userLink: ->
      if self.isSignedIn()
        "/@#{I.login}"
      else
        "/user/#{I.id}"

    anonAvatar: ->
      "https://cdn.glitch.com/f6949da2-781d-4fd5-81e6-1fdd56350165%2Fanon-user-on-project-avatar.svg?1488556279399"

    glitchTeamAvatar: ->
      "https://cdn.glitch.com/2bdfb3f8-05ef-4035-a06e-2043962a3a13%2Fglitch-team-avatar.svg"

    updateUser: (application, updateData) ->
      userPath = "users/#{self.id()}"
      application.api().patch userPath, updateData
      .then ({data}) ->
        console.log 'updatedUser'
      .catch (error) ->
        console.error "updateUser PATCH #{userPath}", error

    updateCoverColor: (application, color) ->
      self.coverColor color
      self.updateUser application, 
        coverColor: color

    truncatedDescription: ->
      MAX_CHARACTERS = 140
      if self.description().length > MAX_CHARACTERS
        self.description().substring(0, MAX_CHARACTERS) + "…"
      else
        self.description()

    descriptionMarkdown: ->
      text = self.description()
      node = document.createElement 'span'
      node.innerHTML = md.render text
      return node
    
    truncatedDescriptionMarkdown: ->
      text = self.truncatedDescription()
      node = document.createElement 'span'
      node.innerHTML = md.render text
      return node

    initialDescriptionMarkdown: ->
      text = self.initialDescription()
      node = document.createElement 'span'
      node.innerHTML = md.render text
      return node
    
    pushSearchResult: (application) ->
      application.searchResultsUsers.push self
      application.searchResultsUsersLoaded true

    userThanks: ->
      thanksCount = self.thanksCount()
      if thanksCount is 1
        "Thanked once"
      else if thanksCount is 2
        "Thanked twice"
      else
        "Thanked #{thanksCount} times"

    addPin: (application, projectId) ->
      self.pins.push
        projectId: projectId
      pinPath = "users/#{self.id()}/pinned-projects/#{projectId}"
      application.api().post pinPath
      .then ({data}) ->
        console.log data
      .catch (error) ->
        console.error 'addPin', error

    removePin: (application, projectId) ->
      newPins = self.pins().filter (pin) ->
        pin.projectId != projectId
      self.pins newPins
      pinPath = "users/#{self.id()}/pinned-projects/#{projectId}"
      application.api().delete pinPath
      .then ({data}) ->
        console.log data
      .catch (error) ->
        console.error 'removePin', error


  if I.id
    cache[I.id] = self
  # console.log '☎️ user cache', cache

  return self

User.getUserByLogin = (application, login) ->
  userPath = "users/byLogins?logins=#{login}"
  application.api().get userPath
  .then (response) ->
    if response.data.length
      user = response.data[0]
      application.saveUser user
    else
      application.user().notFound true
  .catch (error) ->
    console.error "getUserByLogin GET #{userPath}", error

User.getUserById = (application, id) ->
  userPath = "users/#{id}"
  application.api().get userPath
  .then ({data}) ->
    if application.currentUser().id() is data.id
      application.saveCurrentUser data
    else
      application.saveUser data
  .catch (error) ->
    console.error "getUserById GET #{userPath}", error
    
User.getUsersById = (api, ids) ->
  team = application.team()
  userIdsToFetch = ids.filter (id) ->
    user = cache[id]
    !user or !user.fetched()
  usersPath = "users/byIds?ids=#{userIdsToFetch.join(',')}"
  api.get usersPath
  .then ({data}) ->
    data.forEach (datum) ->
      datum.fetched = true
      User(datum).update(datum)
    ids.map (id) ->
      User id: id

User.getSearchResults = (application, query) ->
  MAX_RESULTS = 20
  CancelToken = axios.CancelToken
  source = CancelToken.source()
  application.searchResultsUsers []
  application.searchingForUsers true
  searchPath = "users/search?q=#{query}"
  application.api(source).get searchPath
  .then ({data}) ->
    application.searchingForUsers false
    data = data.slice(0 , MAX_RESULTS)
    if data.length is 0
      application.searchResultsHaveNoUsers true
    data.forEach (datum) ->
      datum.fetched = true
      User(datum).update(datum).pushSearchResult(application)
  .catch (error) ->
    console.error 'getSearchResults', error


User._cache = cache

# Circular dependencies must go below module.exports
Project = require './project'
