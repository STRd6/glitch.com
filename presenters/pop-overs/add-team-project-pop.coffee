Observable = require 'o_0'
_ = require 'underscore'

AddTeamProjectTemplate = require "../../templates/pop-overs/add-team-project-pop"

module.exports = (application) ->

  self =
  
    application: application
  
    query: Observable ""
  
    hiddenUnlessAddTeamProjectPopVisible: ->
      'hidden' unless application.addTeamProjectPopVisible()

    stopPropagation: (event) ->
      event.stopPropagation()
    
    hiddenUnlessSearching: ->
      'hidden' unless application.searchingForProjects()

    spacekeyDoesntClosePop: (event) ->
      event.stopPropagation()
      event.preventDefault()      

    search: (event) ->
      query = event.target.value.trim()
      self.query query
      application.searchingForProjects true
      self.searchProjects query

    searchProjects: _.debounce (query) ->
        if query.length
          application.searchProjects(query)
        else
          application.searchingForProjects false
      , 500

    searchResults: ->
      MAX_RESULTS = 5
      if self.query().length
        application.searchResultsProjects().slice(0, MAX_RESULTS)
      else
        []

    hiddenIfNoSearch: ->
      if !self.searchResults().length and !application.searchingForProjects()
        'hidden' 


  return AddTeamProjectTemplate self
