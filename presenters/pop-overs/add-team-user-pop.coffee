Observable = require 'o_0'
_ = require 'underscore'

AddTeamUserTemplate = require "../../templates/pop-overs/add-team-user-pop"

module.exports = (application) ->

  self =
  
    application: application
  
    query: Observable ""
  
    # team: application.team
  
    # user: application.currentUser() # temp
    # userResults: Observable []

    hiddenUnlessAddTeamUserPopVisible: ->
      'hidden' unless application.addTeamUserPopVisible()

    stopPropagation: (event) ->
      event.stopPropagation()
    
    hiddenUnlessSearching: ->
      'hidden' unless application.searchingForUsers()

    # visibleIfNoMatches: ->
    #   if application.searchResultsUsersLoaded() and application.searchResultsUsers().length is 0 and !application.searchingForUsers() and self.query()       
    #     'visible'

    spacekeyDoesntClosePop: (event) ->
      event.stopPropagation()
      event.preventDefault()      

    search: (event) ->
      query = event.target.value.trim()
      self.query query
      application.searchingForUsers true
      self.searchUsers query

    searchUsers: _.debounce (query) ->
        if query.length
          application.searchUsers(self.query())
        else
          application.searchingForUsers false
      , 500

    searchResults: ->
      MAX_RESULTS = 5
      if self.query().length
        application.searchResultsUsers().slice(0, MAX_RESULTS)
      else
        []

    hiddenIfNoSearch: ->
      if !self.searchResults().length and !application.searchingForUsers()
        'hidden' 
      
      # console.log application.searchResultsUsers()
      # console.log application.searchResultsUsersLoaded()      
      # self.userResults []
      
  return AddTeamUserTemplate self
