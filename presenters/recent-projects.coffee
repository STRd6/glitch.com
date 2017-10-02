RecentProjectsTemplate = require "../templates/includes/recent-projects"
ProjectItemPresenter = require "./project-item"

module.exports = (application) ->

  self = 

    application: application
    currentUser: application.currentUser()

    style: ->
      backgroundImage: "url('#{application.currentUser().coverUrl('large')}')"
      backgroundColor: application.currentUser().coverColor()
    
    userAvatarStyle: ->
      backgroundColor: application.currentUser().color()
      backgroundImage: "url('#{application.currentUser().userAvatarUrl('large')}')"
    
    userAvatarUrl: ->
      application.currentUser().userAvatarUrl('large')
    
    projects: ->
      projects = application.currentUser().projects()
      if application.currentUser().isAnon()
        projects = projects.slice(0,1)
      else if application.currentUser().isSignedIn()
        projects = projects.slice(0,3)      
      projectIds = projects.map (project) ->
        id: project.id()
      application.getProjects projectIds
      projects.map (project) ->
        project.isRecentProject = true
        category = 
          color: ->
            undefined
        ProjectItemPresenter(application, project, category)

    userAvatarIsAnon: ->
      'anon-user-avatar' if application.currentUser().isAnon()

    toggleSignInPopVisible: (event) ->
      application.signInPopVisibleOnRecentProjects.toggle()
      event.stopPropagation()

    hiddenUnlessSignInPopVisible: ->
      'hidden' unless application.signInPopVisibleOnRecentProjects()

    userLink: ->
      application.currentUser().userLink()

    hiddenIfUserIsFetched: ->
      'hidden' if application.currentUser().fetched()

    hiddenUnlessCurrentUser: ->
      'hidden' unless application.currentUser().id()

  return RecentProjectsTemplate self
