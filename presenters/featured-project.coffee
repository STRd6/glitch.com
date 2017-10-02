FeaturedProjectTemplate = require "../templates/includes/featured-project"

module.exports = (application, project) ->
  self =
    project: project

    projectName: ->
      project.displayName()
    
    src: ->
      project.img()
    
    projectHasLink: ->
      true if project.hasOwnProperty('link')
    
    url: ->
      if self.projectHasLink()
        project.link()
      else
        project.domain()

    showProjectOverlay: (event) ->
      event.preventDefault()
      event.stopPropagation()
      application.getProjects [project.I]
      project.showOverlay application

    click: (event) ->
      unless self.projectHasLink()
        self.showProjectOverlay event
      
  return FeaturedProjectTemplate self
