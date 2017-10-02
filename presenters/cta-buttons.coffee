Observable = require 'o_0'

CtaButtonsTemplate = require "../templates/includes/cta-buttons"
CtaPop = require "./pop-overs/cta-pop"

module.exports = (application) ->

  self =

    hideForPlatforms: Observable false
  
    ctaPop: CtaPop(application)

    toggleCtaPop: ->
      application.ctaPopVisible.toggle()

    hiddenUnlessIsSignedIn: ->
      'hidden' unless application.currentUser().isSignedIn()

    hiddenIfHideForPlatformsMarketing: ->
      if application.getUserPref('hideForPlatformsMarketing') or self.hideForPlatforms()
        'hidden'

    hideForPlatformsMarketing: ->
      self.hideForPlatforms true
      application.updateUserPrefs 'hideForPlatformsMarketing', true

  return CtaButtonsTemplate self
