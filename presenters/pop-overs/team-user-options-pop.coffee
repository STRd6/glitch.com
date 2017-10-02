_ = require 'underscore'

module.exports = (application, user) ->

  self =
  
    application: application
    user: user

    stopPropagation: (event) ->
      event.stopPropagation()

    userCover: ->
      user.coverUrl 'small'
      
    userAvatarBackground: ->
      backgroundColor: user.color()
  
    userLink: ->
      user.userLink()

    removeUser: ->
      application.team().removeUser application, user
    
    name: ->
      user.name()
    
    avatarUrl: ->
      user.userAvatarUrl 'small'
    
    hiddenIfUserIsCurrentUser: ->
      'hidden' if user.isCurrentUser application
    
    hiddenUnlessUserIsCurrentUser: ->
      'hidden' unless user.isCurrentUser application

