QuestionsPageTemplate = require "../../templates/pages/questions"
LayoutPresenter = require "../layout"
CtaButtonsPresenter = require "../cta-buttons"
QuestionsPresenter = require "../questions"
CategoriesPresenter = require "../categories"

module.exports = (application) ->
  self =

    application: application

    ctaButtons: ->
      CtaButtonsPresenter(application)

    questions: ->
      QuestionsPresenter application, 12

    categories: ->
      CategoriesPresenter application
      
  content = QuestionsPageTemplate(self)

  return LayoutPresenter application, content
