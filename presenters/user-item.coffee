# _ = require 'underscore'

UserTemplate = require "../templates/includes/user-item"

module.exports = (application, user) ->

  self =
    application: application
    user: user

    login: ->
      "@" + user.login()

    name: ->
      user.name()

    truncatedDescription: ->
      user.truncatedDescriptionMarkdown()

    coverUrl: ->
      user.coverUrl 'small'

    coverColor: ->
      user.coverColor()

    thanks: ->
      user.userThanks()

    userLink: ->
      user.userLink()

    avatarUrl: ->
      user.userAvatarUrl('large')

    hiddenUnlessThanks: ->
      'hidden' unless user.thanksCount() > 0
    
    hiddenUnlessDescription: ->
      'hidden' unless user.description()
    
    hiddenUnlessName: ->
      'hidden' unless user.name()

    style: ->
      backgroundImage: "url('#{self.coverUrl()}')"
      backgroundColor: self.coverColor()

  return UserTemplate self
