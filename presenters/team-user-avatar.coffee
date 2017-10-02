TeamUserTemplate = require "../templates/includes/team-user-avatar" # rename

TeamUserOptionsPop = require "../templates/pop-overs/team-user-options-pop"
TeamUserOptionsPopPresenter = require './pop-overs/team-user-options-pop'

module.exports = (application, user) ->

  self = 

    team: application.team
    teamUserOptionsPopPresenter: TeamUserOptionsPopPresenter application, user

    showTeamUserOptionsPop: (event) ->
      application.closeAllPopOvers()
      event.stopPropagation()
      avatar = $(event.target).closest('.opens-pop-over')
      avatar[0].appendChild TeamUserOptionsPop(self.teamUserOptionsPopPresenter)

    login: ->
      user.login()

    tooltipName: ->
      user.tooltipName()

    style: ->
      backgroundColor: user.color()

    avatarUrl: ->
      user.userAvatarUrl('large')

    alt: ->
      user.alt()

  return TeamUserTemplate self
