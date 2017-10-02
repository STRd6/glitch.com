UserResultTemplate = require "../templates/includes/user-result"

module.exports = (application, user, options) ->

  options = options or {}
  
  self =

    login: ->
      "@" + user.login()

    name: ->
      user.name()

    # truncatedDescription: ->
    #   user.truncatedDescription()
      
    hoverBackground: ->
      backgroundImage: "url('#{user.coverUrl()}')"
      backgroundColor: user.coverColor('small')

    hiddenUnlessName: ->
      'hidden' unless user.name()
    
    addUserToTeam: ->
      console.log application
      console.log self.application
      console.log "adding #{user.name()} to #{application.team().id()}"
      application.team().addUser application, user
      application.closeAllPopOvers()
    
    userResultKey: (event) ->
      ENTER = 13
      console.log event
      if event.keyCode is ENTER
        self.addUserToTeam()    

    avatarUrl: ->
      user.userAvatarUrl('large')

    hiddenUnlessThanks: ->
      "hidden" unless user.thanksCount() > 0

    hiddenUnlessShowingThanks: ->
      'hidden' unless options.showThanks

    thanks: ->
      user.userThanks()
    
    

  return UserResultTemplate self
