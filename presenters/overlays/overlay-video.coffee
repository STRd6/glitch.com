OverlayVideoTemplate = require "../../templates/overlays/overlay-video"

module.exports = (application) ->

  self =     
    application: application
    
    hiddenUnlessOverlayVideoVisible: ->
      "hidden" unless application.overlayVideoVisible()

    stopPropagation: (event) ->
      event.stopPropagation()

  return OverlayVideoTemplate self
