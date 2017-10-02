# _ = require 'underscore'
TeamItemTemplate = require "../templates/includes/team-item"
UsersListPresenter = require "./users-list"

module.exports = (application, team) ->

  self =
    application: application
    team: team

    name: ->
      team.name()

    truncatedDescription: ->
      team.truncatedDescription()

    usersListPresenter: UsersListPresenter(team, 'team')

    url: ->
      team.url()
    
    coverUrl: ->
      team.coverUrl 'small'

    coverColor: ->
      team.coverColor()

    thanks: ->
      team.teamThanks()
    
    users: ->
      team.users()
    
    avatarUrl: ->
      team.teamAvatarUrl()

    hiddenUnlessThanks: ->
      'hidden' unless team.thanksCount() > 0
    
    hiddenUnlessDescription: ->
      'hidden' unless team.description()
  
    verifiedImage: ->
      team.verifiedImage()
  
    verifiedTeamTooltip: ->
      team.verifiedTooltip()
    
    hiddenUnlessVerified: ->
      'hidden' unless team.isVerified()

    style: ->
      backgroundImage: "url('#{self.coverUrl()}')"
      backgroundColor: self.coverColor()

  return TeamItemTemplate self
