IndexTemplate = require "../../templates/pages/index"
LayoutPresenter = require "../layout"
WhatIsGlitchPresenter = require "../what-is-glitch"
CtaButtonsPresenter = require "../cta-buttons"
HeaderPresenter = require "../header"
FeaturedProjectPresenter = require "../featured-project"

module.exports = (application) ->
  console.log "Presented index"
  
  self =
    application: application
    projects: application.projects
    
    user: application.user

    whatIsGlitch: ->
      WhatIsGlitchPresenter(application)

    ctaButtons: ->
      CtaButtonsPresenter(application)

    header: ->
      HeaderPresenter(application)

    currentUser: application.currentUser

#     featuredProjects: ->
#       application.featuredProjects()
      
    featuredProjects: ->
      application.featuredProjects().map (project) ->
        FeaturedProjectPresenter application, project

    randomCategories: ->
      application.categories().filter (category) ->
        category.hasProjects()

    categories: ->
      application.categories()

  content = IndexTemplate(self)

  return LayoutPresenter application, content
