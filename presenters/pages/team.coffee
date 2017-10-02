Observable = require 'o_0'
_ = require 'underscore'
md = require('markdown-it')
  breaks: true
  linkify: true
  typographer: true

TeamTemplate = require "../../templates/pages/team"
LayoutPresenter = require "../layout"
CtaButtonsPresenter = require "../cta-buttons"
AddTeamUserPopPresenter = require "../pop-overs/add-team-user-pop"
AddTeamProjectPopPresenter = require "../pop-overs/add-team-project-pop"
ProjectsListPresenter = require "../projects-list"
TeamUserPresenter = require "../team-user-avatar"
UserAvatarTemplate = require "../../templates/includes/user-avatar" #
assetUtils = require('../../utils/assets')(application)


module.exports = (application) ->
  self =

    application: application
    team: application.team
    hiddenIfTeamFetched: -> application.team().hiddenIfFetched()
    hiddenUnlessTeamFetched: -> application.team().hiddenUnlessFetched()
    initialTeamDescription: Observable undefined

    verifiedTeamTooltip: ->
      application.team().verifiedTooltip()

    teamUsers: ->
      users = application.team().users()
      if self.currentUserIsOnTeam()
        users.map (user) ->
          TeamUserPresenter application, user
      else
        users.map UserAvatarTemplate

    ctaButtons: ->
      CtaButtonsPresenter(application)

    addTeamUserPop: ->
      AddTeamUserPopPresenter(application)

    addTeamProjectPop: ->
      AddTeamProjectPopPresenter(application)

    coverUrl: ->
      if application.team().localCoverImage()
        application.team().localCoverImage()
      else
        application.team().coverUrl()

    teamProfileStyle: ->
      backgroundColor: application.team().coverColor()
      backgroundImage: "url('#{self.coverUrl()}')"

    teamAvatarStyle: ->
      if application.team().hasAvatarImage()
        backgroundImage: "url('#{self.teamAvatarUrl()}')"
      else
        backgroundColor: application.team().backgroundColor()
      
    teamName: ->
      application.team().name()

    teamThanks: ->
      application.team().teamThanks()

    isVerified: ->
      application.team().isVerified()

    verifiedImage: ->
      application.team().verifiedImage()
      
    hiddenUnlessVerified: ->
      'hidden' unless self.isVerified()

    hiddenUnlessTeamHasThanks: ->
      'hidden' unless application.team().thanksCount() > 0 

    currentUserIsOnTeam: ->
      application.team().currentUserIsOnTeam application

    hiddenUnlessCurrentUserIsOnTeam: ->
      'hidden' unless self.currentUserIsOnTeam application

    hiddenIfCurrentUserIsOnTeam: ->
      'hidden' if self.currentUserIsOnTeam application
        
    description: ->
      text = application.team().description()
      node = document.createElement 'span'
      node.innerHTML = md.render text
      return node

    setInitialTeamDescription: ->
      description = application.team().description()
      node = document.createElement 'span'
      node.innerHTML = md.render description
      if description
        self.initialTeamDescription node

    updateDescription: (event) ->
      text = event.target.textContent
      application.team().description text
      self.updateTeam
        description: text

    updateTeam: _.debounce (data) ->
      application.team().updateTeam application, data
    , 250

    applyDescription: (event) ->
      event.target.innerHTML = md.render application.team().description()
      # application.notifyUserDescriptionUpdated true

    teamAvatarUrl: ->
      if application.team().localAvatarImage()
        application.team().localAvatarImage()
      else
        application.team().teamAvatarUrl 'large'


    hiddenIfNoDescription: ->
      'hidden' if application.team().description().length is 0

    uploadCover: ->
      input = document.createElement "input"
      input.type = 'file'
      input.accept = "image/*"
      input.onchange = (event) ->
        file = event.target.files[0]
        console.log '☔️☔️☔️ input onchange', file
        assetUtils.addCoverFile file
      input.click()
      console.log 'input created: ', input
      return false

    uploadAvatar: ->
      input = document.createElement "input"
      input.type = 'file'
      input.accept = "image/*"
      input.onchange = (event) ->
        file = event.target.files[0]
        console.log '☔️☔️☔️ input onchange', file
        assetUtils.addAvatarFile file
      input.click()
      console.log 'input created: ', input
      return false

    projects: ->
      self.team().projects()
      
    pinnedProjectIds: ->
      self.team().pins().map (pin) ->
        pin.projectId

    recentProjects: ->
      recentProjects = self.projects().filter (project) ->
        !_.contains self.pinnedProjectIds(), project.id()
      ProjectsListPresenter application, "Recent Projects", recentProjects
    
    pinnedProjectsList: ->
      pinnedProjects = self.projects().filter (project) ->
        _.contains self.pinnedProjectIds(), project.id()
      ProjectsListPresenter application, "Pinned Projects", pinnedProjects
    
    hiddenIfNotOnTeamAndNoPins: ->
      if !self.currentUserIsOnTeam() and self.team().pins().length is 0
        'hidden'

    hiddenIfOnTeam: ->
      'hidden' if self.currentUserIsOnTeam()

    toggleAddTeamUserPop: ->
      application.addTeamUserPopVisible.toggle()
      if application.addTeamUserPopVisible()
        $('#team-user-search').focus()
    
    toggleAddTeamProjectPop: ->
      application.addTeamProjectPopVisible.toggle()
      if application.addTeamProjectPopVisible()
        $('#team-project-search').focus()

  application.team.observe (newVal) ->
    if newVal
      self.setInitialTeamDescription()
        
  content = TeamTemplate(self)

  return LayoutPresenter application, content
