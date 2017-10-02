# _ = require 'underscore'

ProjectItemTemplate = require "../templates/includes/project-item"
UsersListPresenter = require "./users-list"

ProjectOptionsPop = require "../templates/pop-overs/project-options-pop"
ProjectOptionsPopPresenter = require './pop-overs/project-options-pop'

module.exports = (application, project, category) ->

  self = 

    category: category
    project: project

    projectOptionsPopPresenter: ProjectOptionsPopPresenter project, application
    
    usersListPresenter: UsersListPresenter(project)

    projectLink: ->
      if project.isRecentProject
        self.editorLink()
      else
        "/~#{project.domain()}"

    editorLink: ->
      project.editUrl()

    showProject: (event) ->
      event.preventDefault()
      event.stopPropagation()
      project.showOverlay application

    buttonCtaIfCurrentUser: ->
      if project.isRecentProject
        "button-cta"

    projectIsPrivate: ->
      'private-project' if project.private()

    showProjectOptionsPop: (event) ->
      application.closeAllPopOvers()
      event.stopPropagation()
      button = $(event.target).closest('.opens-pop-over')
      button[0].appendChild ProjectOptionsPop(self.projectOptionsPopPresenter)

    visibleIfUserHasProjectOptions: ->
      if application.user().isOnUserPageForCurrentUser(application) or application.team().currentUserIsOnTeam(application)                    
        'visible'

    stopPropagation: (event) ->
      event.stopPropagation()

    togglePinedState: ->
      if application.pageIsTeamPage()
        self.toggleTeamPin()
      else
        self.toggleUserPin()

    toggleUserPin: ->
      if project.isPinnedByUser application
        application.user().removePin application, project.id()
      else
        application.user().addPin application, project.id()

    toggleTeamPin: ->
      if project.isPinnedByTeam application
        application.team().removePin application, project.id()
      else
        console.log 'toggleTeamPin addpin'
        application.team().addPin application, project.id()

    style: ->
      backgroundColor: category.color?()
      borderBottomColor: category.color?()

    maskStyle: ->
      backgroundColor: category.color?()

    avatar: ->
      "#{CDN_URL}/project-avatar/#{project.id()}.png"

  return ProjectItemTemplate self
