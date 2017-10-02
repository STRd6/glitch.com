CategoryTemplate = require "../templates/includes/category"
ProjectItemPresenter = require "./project-item"

module.exports = (application, category) ->
  category = category
  projects = category.projects

  projectElements = projects.map (project) ->
    ProjectItemPresenter(application, project, category)

  self =

    category: category
    projects: projects

    style: ->
      backgroundColor: category.backgroundColor()

    url: ->
      category.url()

    name: ->
      category.name()
    
    description: ->
      category.description()
    
  self.projects = projectElements

  return CategoryTemplate self
