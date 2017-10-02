UserOptionsPopTemplate = require "../../templates/pop-overs/user-options-pop"

module.exports = (application) ->

  self =
  
    template: ->
      UserOptionsPopTemplate self

    stopPropagation: (event) ->
      event.stopPropagation()

    hiddenUnlessUserOptionsPopVisible: ->
      'hidden' unless application.userOptionsPopVisible()

    signOut: ->
      analytics.track "Logout"
      analytics.reset()
      localStorage.removeItem('cachedUser')
      location.reload()

    yourProfileLink: ->
      login = application.currentUser().login()
      "/@#{login}"

    yourProfileAvatar: ->
      application.currentUser().avatarUrl()
      
    teams: ->
      application.currentUser().teams() or []

    hiddenUnlesssUserHasTeams: ->
      teams = self.teams().length
      'hidden' unless teams
