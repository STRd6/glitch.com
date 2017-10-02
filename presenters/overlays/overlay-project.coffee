# 🤔 in layout, only render this guy if application.overlayProject
# then can drop the null(?) checks

OverlayProjectTemplate = require "../../templates/overlays/overlay-project"

UsersList = require "../users-list"

Observable = require 'o_0'
_ = require 'underscore'
randomColor = require 'randomcolor'
axios = require 'axios'
markdown = require('markdown-it')({html: true})
  .use(require('markdown-it-sanitizer'))
  
# currentPagePath = "/"

module.exports = (application) ->
  console.log "overlay project presented"

  self = 
    
    application: application
    project: application.overlayProject
    
    projectUsers: ->
      if application.overlayProject()
        UsersList application.overlayProject()
  
    overlayReadme: ->
      readme = self.project()?.readme()
      if readme
        self.mdToNode readme.toString()

    projectDomain: ->
      self.project()?.domain()

    projectId: ->
      self.project()?.id()

    currentUserIsInProject: ->
      self.project()?.userIsCurrentUser application

    hiddenIfCurrentUserInProject: ->
      'hidden' if self.currentUserIsInProject()

    hiddenUnlessCurrentUserInProject: ->
      'hidden' unless self.currentUserIsInProject()
      
    projectAvatar: ->
      if self.project()
        "#{CDN_URL}/project-avatar/#{self.project().id()}.png"
      
    showLink: -> 
      "https://#{self.projectDomain()}.glitch.me"

    editorLink: ->
      "#{EDITOR_URL}#!/#{self.projectDomain()}"

    remixLink: ->
      "#{EDITOR_URL}#!/remix/#{self.projectDomain()}/#{self.projectId()}"
      
    trackRemix: ->
      analytics.track "Click Remix",
        origin: "project overlay"
        baseProjectId: self.projectId()
        baseDomain: self.projectDomain()
      return true

    hiddenUnlessOverlayProjectVisible: ->
      "hidden" unless application.overlayProjectVisible()

    stopPropagation: (event) ->
      event.stopPropagation()
      
    warningIfProjectNotFound: ->
      "warning" if self.project()?.projectNotFound()

    hiddenUnlessProjectNotFound: ->
      'hidden' unless self.project()?.projectNotFound()
    
    hiddenUnlessReadmeNotFound: ->
      'hidden' unless self.project()?.readmeNotFound()

    hiddenIfOverlayReadmeLoaded: ->
      if self.project()?.readme() or self.project()?.projectNotFound() or self.project()?.readmeNotFound()
        'hidden' 
      
    hideOverlay: ->
      self.project().hideOverlay application

    mdToNode: (md) ->
      node = document.createElement 'span'
      node.innerHTML = markdown.render md
      return node

    showReadmeError: ->
      node = document.createElement 'span'
      node.innerHTML = 
      """
        <h1>Couldn't get project info</h1>
        <p>Maybe try another project? Maybe we're too popular right now?</p>
        <p>(シ_ _)シ</p>
      """
      self.overlayReadme node
        
    projectThoughtsMailto: ->
      projectDomain = self.projectDomain()
      projectId = self.projectId()
      support = "customer-service@fogcreek.com"
      subject = "[Glitch] I have feelings about #{projectDomain}"
      body = """
        What do you think of the #{projectDomain} project? 
        Is it great? Should we feature it? Is it malicious?

        Let us know:





        --------------------

        Thanks 💖

        – Glitch Team

        (project id: #{projectId})
      """
      encodeURI "mailto:#{support}?subject=#{subject}&body=#{body}"


  return OverlayProjectTemplate self
