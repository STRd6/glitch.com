UsersListTemplate = require "../templates/includes/users-list"
UserAvatarTemplate = require "../templates/includes/user-avatar" #

_ = require 'underscore'

module.exports = (projectOrTeam, type) ->
  
  self =
  
    users: ->
      projectOrTeam.users()

    userAvatars: ->
      self.users().map UserAvatarTemplate

    hiddenUnlessShowAsGlitchTeam: ->
      if type is 'team'
        return 'hidden' 

      'hidden' unless projectOrTeam?.showAsGlitchTeam()

    hiddenIfShowAsGlitchTeam: ->
      unless type is 'team'
        'hidden' if projectOrTeam?.showAsGlitchTeam()

  return UsersListTemplate self
