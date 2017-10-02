Layout = require "../templates/layout"

Header = require "./header"
Footer = require "../templates/includes/footer"
OverlayProject = require "./overlays/overlay-project"
OverlayVideo = require "./overlays/overlay-video"
Notifications = require "./notifications"

module.exports = (application, content) ->

  Layout

    header: Header(application)
    
    content: content

    footer: Footer(application)
    
    overlayProject: OverlayProject(application)
    overlayVideo: OverlayVideo(application)
    notifications: Notifications(application)
