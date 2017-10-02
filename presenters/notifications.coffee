NotificationsTemplate = require "../templates/includes/notifications"

Observable = require "o_0"
animationEnd = 'webkitAnimationEnd oanimationend msAnimationEnd animationend'

module.exports = (application) ->

  # defined as observables in application.coffee
  notificationTypes = [
    "UserDescriptionUpdated"
    "Uploading"
    "UploadFailure"
  ]

  notifications = notificationTypes.map (str) ->
    ".notify#{str}"
  .join(',')

  generateNotifier = (method, application) ->
    ->
      $(notifications).one animationEnd, (event) ->
        application[method] false
      if not application[method]()
        return "hidden"


  self =
    application: application
    
    uploadFilesRemaining: ->
      Math.round (application.uploadFilesRemaining() / 2)

    uploadProgress: ->
      application.uploadProgress()


  for notificationType in notificationTypes
    method = "notify#{notificationType}"
    self[method] = generateNotifier(method, application)

  return NotificationsTemplate self
