axios = require 'axios'

LayoutPresenter = require "../layout"
SearchPageTemplate = require "../../templates/pages/search"

module.exports = (application) ->

  self = 

    application: application
    searchResultsProjects: application.searchResultsProjects
    searchResultsUsers: application.searchResultsUsers
    searchResultsTeams: application.searchResultsTeams
    
    hiddenIfSearchResultsTeamsLoaded: ->
      'hidden' if application.searchResultsTeamsLoaded()      
    
    hiddenIfSearchResultsProjectsLoaded: ->
      'hidden' if application.searchResultsProjectsLoaded()
  
    hiddenIfSearchResultsUsersLoaded: ->
      'hidden' if application.searchResultsUsersLoaded()
  
    hiddenIfSearchResultsHaveNoUsers: ->
      'hidden' if application.searchResultsHaveNoUsers()

    hiddenIfSearchResultsHaveNoProjects: ->
      'hidden' if application.searchResultsHaveNoProjects()
    
    hiddenIfSearchResultsHaveNoTeams: ->
      'hidden' if application.searchResultsHaveNoTeams()      

    hiddenUnlessSearchHasNoResults: ->
      'hidden' unless application.searchResultsHaveNoUsers() and application.searchResultsHaveNoProjects() and application.searchResultsHaveNoTeams()
    

  content = SearchPageTemplate self
        
  return LayoutPresenter application, content
