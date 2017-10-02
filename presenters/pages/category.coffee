CategoryPageTemplate = require "../../templates/pages/category"
LayoutPresenter = require "../layout"
ProjectItemPresenter = require "../project-item"

module.exports = (application) ->

    
  self =

    application: application
    category: application.category

    projectElements: ->
      self.category().projects().map (project) ->
        ProjectItemPresenter(application, project, self.category())

    categories: ->
      application.categories()

    name: ->
      self.category().name()

    avatarUrl: ->
      self.category().avatarUrl()

    description: ->
      self.category().description()

    backgroundColor: ->
      self.category().backgroundColor()

    style: ->
      backgroundColor: self.backgroundColor()

    hiddenIfCategoryProjectsLoaded: ->
      'hidden' if application.categoryProjectsLoaded()
    
  content = CategoryPageTemplate(self)
  return LayoutPresenter application, content

