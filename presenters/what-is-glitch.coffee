WhatIsGlitchTemplate = require "../templates/includes/what-is-glitch"

module.exports = (application) ->

  self =
    baseUrl: application.normalizedBaseUrl()

    hiddenIfUserIsSignedIn: ->
      'hidden' if application.currentUser().isSignedIn()

    showVideoOverlay: (event) ->
      application.overlayVideoVisible true
      document.getElementsByClassName('video-overlay')[0].focus()
      event.stopPropagation()

  return WhatIsGlitchTemplate self
