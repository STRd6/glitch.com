QuestionsTemplate = require "../templates/includes/questions"
QuestionItemPresenter = require './question-item'

Observable = require 'o_0'
_ = require 'underscore'
# randomColor = require 'randomcolor'

animationIteration = 'webkitAnimationiteration oanimationiteration msAnimationiteration animationiteration'
DEFAULT_MAX_QUESTIONS = 3

module.exports = (application, maxQuestions) ->
  console.log "Presented questions"

  self =

    maxQuestions: ->
      maxQuestions or DEFAULT_MAX_QUESTIONS

    kaomoji: Observable '八(＾□＾*)'

    randomKaomoji: ->
      kaomojis = [
        '八(＾□＾*)'
        '(ノ^_^)ノ'
        'ヽ(*ﾟｰﾟ*)ﾉ'
        '♪(┌・。・)┌'
        'ヽ(๏∀๏ )ﾉ'
        'ヽ(^。^)丿'
      ]
      self.kaomoji _.sample kaomojis

    # hiddenIfGotQuestions: ->
    #   'hidden' if application.questions().length
      
    hiddenIfQuestions: ->
      'hidden' if application.questions().length

    hiddenUnlessQuestions: ->
      'hidden' unless application.questions().length

    questions: ->
      application.questions().map (question) ->
        QuestionItemPresenter(application, question)

    animatedUnlessLookingForQuestions: ->
      'animated' unless application.gettingQuestions()


  setInterval ->
    application.getQuestions()
    self.randomKaomoji()
  , 10000

  return QuestionsTemplate self
