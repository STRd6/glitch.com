###
We use a cache to keep an identity map of teams by id.

When constructing a team model Team(...) if it has an id
field it will be cached based on the id. If the id already
exists in the cache the same reference to that model will be
returned.

If the id property is not given the model is not cached.

###

_ = require 'underscore'
axios = require 'axios'

cache = {}
cacheBuster = Math.floor(Math.random() * 1000)

Model = require './model'
Project = require './project'
User = require './user'

module.exports = Team = (I={}, self=Model(I)) ->

  if cache[I.id]
    return cache[I.id]
  
  self.defaults I,
    id: undefined
    name: undefined
    description: ""
    url: undefined
    backgroundColor: undefined
    hasCoverImage: undefined
    coverColor: undefined
    isCategory: false
    fetched: false
    users: []
    projects: []
    isVerified: false
    teamPins: []
    hasAvatarImage: false
    
  self.attrObservable Object.keys(I)...
  
  self.attrModels 'projects', Project
  self.attrModels 'users', User
  self.attrObservable "localCoverImage"
  self.attrObservable "localAvatarImage"

  self.extend
  
    pins: self.teamPins
  
    coverUrl: (size) ->
      size = size or 'large'
      if self.hasCoverImage()
        "https://s3.amazonaws.com/production-assetsbucket-8ljvyr1xczmb/team-cover/#{self.id()}/#{size}?#{cacheBuster}"           
      else
        "https://cdn.glitch.com/55f8497b-3334-43ca-851e-6c9780082244%2Fdefault-cover-wide.svg?1503518400625"

    teamAvatarUrl: (size) ->
      size = size or 'small'
      if self.hasAvatarImage()
        "https://s3.amazonaws.com/production-assetsbucket-8ljvyr1xczmb/team-avatar/#{self.id()}/#{size}?#{cacheBuster}"
      else
        "https://cdn.glitch.com/55f8497b-3334-43ca-851e-6c9780082244%2Fdefault-team-avatar.svg?1503510366819"

    hiddenIfFetched: ->
      'hidden' if self.fetched()

    hiddenUnlessFetched: ->
      'hidden' unless self.fetched()
    
    truncatedDescription: ->
      MAX_CHARACTERS = 140
      if self.description().length > MAX_CHARACTERS
        self.description().substring(0, MAX_CHARACTERS) + "…"
      else
        self.description()

    thanksCount: ->
      if self.users().length
        thanks = 0
        self.users().forEach (user) ->
          thanks = thanks + parseInt user.thanksCount()
        thanks

    teamThanks: ->
      thanksCount = self.thanksCount()
      if thanksCount is 1
        "Thanked once"
      else if thanksCount is 2
        "Thanked twice"
      else
        "Thanked #{thanksCount} times"

    currentUserIsOnTeam: (application) ->
      matchingUser = self.users().filter (user) ->
        user.id() is application.currentUser().id()
      true if matchingUser.length

    updateCoverColor: (application, color) ->
      if color
        self.coverColor color
        self.updateTeam application, 
          coverColor: color

    updateAvatarColor: (application, color) ->
      if color
        self.backgroundColor color
        self.updateTeam application, 
          backgroundColor: color

    updateTeam: (application, updateData) ->
      teamPath = "teams/#{self.id()}"
      application.api().patch teamPath, updateData
      .then ({data}) ->
        console.log 'updatedTeam', data
      .catch (error) ->
        console.error "updateTeam PATCH #{teamPath}", error

    verifiedTooltip: ->
      "Verified to be supportive, helpful people"

    verifiedImage: ->
      "https://cdn.glitch.com/55f8497b-3334-43ca-851e-6c9780082244%2Fverified.svg?1501783108220"

    addPin: (application, projectId) ->
      self.pins.push
        projectId: projectId
      pinPath = "teams/#{self.id()}/pinned-projects/#{projectId}"
      application.api().post pinPath
      .then ({data}) ->
        console.log data
      .catch (error) ->
        console.error 'addPin', error

    removePin: (application, projectId) ->
      newPins = self.pins().filter (pin) ->
        pin.projectId != projectId
      self.pins newPins
      pinPath = "teams/#{self.id()}/pinned-projects/#{projectId}"
      application.api().delete pinPath
      .then ({data}) ->
        console.log data
      .catch (error) ->
        console.error 'removePin', error

    addUser: (application, user) ->
      teamUserPath = "/teams/#{self.id()}/users/#{user.id()}"
      application.api().post teamUserPath
      .then (response) ->
        self.users.push user
        console.log 'added user. team users are now', self.users()
      .catch (error) ->
        console.error 'addUser', error

    removeUser: (application, user) ->
      teamUserPath = "/teams/#{self.id()}/users/#{user.id()}"
      application.api().delete teamUserPath
      .then (response) ->
        newUsers = _.reject self.users(), (removedUser) ->
          removedUser.id() is user.id()
        self.users newUsers
        console.log 'removed user. team users are now', self.users()
      .catch (error) ->
        console.error 'removeUser', error

    addProject: (application, project) ->
      teamProjectPath = "/teams/#{self.id()}/projects/#{project.id()}"
      application.api().post teamProjectPath
      .then (response) ->
        self.projects.push project
        console.log 'added project. team projects are now', self.projects()
      .catch (error) ->
        console.error 'addProject', error

    removeProject: (application, project) ->
      teamProjectPath = "/teams/#{self.id()}/projects/#{project.id()}"
      application.api().delete teamProjectPath
      .then (response) ->
        newProjects = _.reject self.projects(), (removedProject) ->
          removedProject.id() is project.id()
        self.projects newProjects
        console.log 'removed project. team projects are now', self.projects()
      .catch (error) ->
        console.error 'addProject', error

    pushSearchResult: (application) ->
      application.searchResultsTeams.push self
      application.searchResultsTeamsLoaded true


  if I.id
    cache[I.id] = self
  # console.log '👯 team cache', cache

  return self

Team.getTeamById = (application, id) ->
  teamsPath = "teams/#{id}"
  application.api().get teamsPath
  .then ({data}) ->
    application.saveTeam data
  .catch (error) ->
    console.error 'getTeamById', error

Team.getSearchResults = (application, query) ->
  MAX_RESULTS = 20
  CancelToken = axios.CancelToken
  source = CancelToken.source()
  application.searchResultsTeams []
  application.searchingForTeams true
  searchPath = "teams/search?q=#{query}"
  application.api(source).get searchPath
  .then ({data}) ->
    application.searchingForTeams false
    data = data.slice(0 , MAX_RESULTS)
    if data.length is 0
      application.searchResultsHaveNoTeams true
    data.forEach (datum) ->
      datum.fetched = true
      Team(datum).update(datum).pushSearchResult(application)
  .catch (error) ->
    console.log 'getSearchResults', error


Team._cache = cache

# Circular dependencies must go below module.exports
Project = require './project'
Users = require './user'
