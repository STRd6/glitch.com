ProjectResultTemplate = require "../templates/includes/project-result"
UsersListPresenter = require "./users-list"

module.exports = (application, project, options) ->

  options = options or {}
  
  self =

    usersListPresenter: UsersListPresenter(project)
    
    name: ->
      project.name()

    description: ->
      project.description()
    
    addProjectToTeam: ->
      console.log application
      console.log self.application
      console.log "adding #{project.name()} to #{application.team().id()}"
      application.team().addProject application, project
      application.closeAllPopOvers()
    
    projectResultKey: (event) ->
      ENTER = 13
      console.log event
      if event.keyCode is ENTER
        self.addProjectToTeam()    

    avatarUrl: ->
      project.avatar()

  return ProjectResultTemplate self
