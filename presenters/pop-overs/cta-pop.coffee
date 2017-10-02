CtaPopTemplate = require "../../templates/pop-overs/cta-pop"

module.exports = (application) ->

  self =

    newProjectLink: "#{EDITOR_URL}#!/new-project"
    newWebsiteLink: "#{EDITOR_URL}#!/remix/hello-website"
    
    trackNewProject: ->
      analytics.track "New Project Clicked",
        projectType: "node app"
      # return true means "follow href"
      return true
    
    trackNewWebsite: ->
      analytics.track "New Project Clicked",
        projectType: "static app"
      # return true means "follow href"
      return true

    hiddenUnlessCtaPopVisible: ->
      'hidden' unless application.ctaPopVisible()

    stopPropagation: (event) ->
      event.stopPropagation()

  return CtaPopTemplate self
