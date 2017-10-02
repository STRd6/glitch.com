Observable = require 'o_0'

QuestionItemTemplate = require "../templates/includes/question-item"

MAX_QUESTION_LENGTH = 140
MAX_TAG_LENGTH = 15

module.exports = (application, question) ->
  
  self = 
  
    question: question
  
    fullQuestion: ->
      question.question()

    filteredQuestion: ->
      question = question.question()
      if question.length <= MAX_QUESTION_LENGTH
        question
      else
        truncated = question.substring 0, (MAX_QUESTION_LENGTH - 5)
        truncated + '...'

    filteredTag: (tag) ->
      tag.substring 0, MAX_TAG_LENGTH

    projectUrl: ->
      question.editUrl()

    domain: ->
      question.domain()
    
    outerColor: ->
      backgroundColor: question.colorOuter()
    
    innerColor: ->
      backgroundColor: question.colorInner()

    userAvatar: ->
      question.userAvatar()

    userColor: ->
      question.userColor()

    userLogin: ->
      question.userLogin()

    # tags: ->
    #   console.log "🌙", question.tags()
    #   question.tags()

  return QuestionItemTemplate self