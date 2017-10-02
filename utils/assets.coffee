# 💭 based on frontend/utils/assets in the editor

S3Uploader = require './s3-uploader'
quantize = require 'quantize'
Observable = require 'o_0'
COVER_SIZES =
  large: 1000
  medium: 700
  small: 450
AVATAR_SIZES =
  large: 300
  medium: 150
  small: 60

blobToImage = (file) ->
  new Promise (resolve, reject) ->
    image = new Image
    image.onload = ->
      resolve image
    image.onerror = reject
    image.src = URL.createObjectURL(file)
    
blobToBase64 = (file) ->
  new Promise (resolve, reject) ->
    reader = new FileReader()
    reader.readAsDataURL file
    reader.onload = ->
      resolve reader.result
    reader.onerror = (error) ->
      reject error

# Reduces the width/height and draws a new image until it reaches
# the final size. It loops by waiting for the onload to fire on the updated
# image and exits as soon as the new width/height are less than or equal to the
# final size.
drawCanvasThumbnail = (image, type, max) ->
  {width, height} = image
  quality = 0.92
  sourceCanvas = document.createElement('canvas')
  sourceCanvas.width = width
  sourceCanvas.height = height
  sourceContext = sourceCanvas.getContext '2d'
  sourceContext.drawImage image, 0, 0, width, height
  while width > max and height > max
    width *= 0.75
    height *= 0.75
    targetCanvas = document.createElement('canvas')
    targetContext = targetCanvas.getContext '2d'
    targetCanvas.width = width
    targetCanvas.height = height
    targetContext.drawImage sourceCanvas, 0, 0, width, height
    sourceCanvas = targetCanvas

  new Promise (resolve, reject) ->
    sourceCanvas.toBlob (blob) ->
      blob.width = width
      blob.height = height
      resolve(blob)
    , type, quality

# Takes an HTML5 File and returns a promise for an HTML5 Blob that is fulfilled
# with a thumbnail for the image. If the image is small enough the original
# blob is returned. Width and height metadata are added to the blob.
resizeImage = (file, size) ->
  max = COVER_SIZES[size] or 1000
  blobToImage(file)
  .then (image) ->
    file.width = image.width
    file.height = image.height
    if image.width < max and image.height < max
      file
    else
      drawCanvasThumbnail(image, file.type, max)

getDominantColor = (image) ->
  {width, height} = image
  PIXELS_FROM_EDGE = 10
  canvas = document.createElement 'canvas'
  canvas.width = width
  canvas.height = height
  context = canvas.getContext '2d'
  context.drawImage image, 0, 0, width, height
  transparentPixels = false
  colors = []
  outlyingColors = []
  outlyingColorsList = JSON.stringify [
      [255,255,255]
      [0,0,0]
    ]
  ###
  Iterate through edge pixels and get the average color, then conditionally
  handle edge colors and transparent images
  ###
  xPixels = [0 .. PIXELS_FROM_EDGE]
  yPixels = [0 .. PIXELS_FROM_EDGE]
  for x in xPixels
    for y in yPixels
      pixelData = context.getImageData(x, y, 1, 1).data
      color = [
        pixelData[0] # r
        pixelData[1] # g
        pixelData[2] # b
        ]
      colorRegExObject = new RegExp "(#{color})", 'g'
      if pixelData[3] < 255 # alpha pixels
        transparentPixels = true
        break
      if outlyingColorsList.match colorRegExObject
        outlyingColors.push color
      else
        colors.push color
  if outlyingColors.length > colors.length
    colors = outlyingColors
  if transparentPixels
    return null
  else
    colorMap = quantize colors, 5
    [r, g, b] = colorMap.palette()[0]
    return "rgb(#{r},#{g},#{b})"


module.exports = (application) ->

  self = 

    getImagePolicy: (assetType) ->
      if assetType is 'avatar'
        if application.pageIsTeamPage()
          self.getTeamAvatarImagePolicy()
      else
        self.getCoverImagePolicy()

    getCoverImagePolicy: ->
      if application.pageIsTeamPage()
        self.getTeamCoverImagePolicy()
      else
        self.getUserCoverImagePolicy()

    getTeamCoverImagePolicy: ->
      policyPath = "teams/#{application.team().id()}/cover/policy"
      application.api().get policyPath
      .then (response) ->
        return response
      .catch (error) ->
        application.notifyUploadFailure true
        console.error 'getTeamCoverImagePolicy', error
    
    getTeamAvatarImagePolicy: ->
      policyPath = "teams/#{application.team().id()}/avatar/policy"
      application.api().get policyPath
      .then (response) ->
        return response
      .catch (error) ->
        application.notifyUploadFailure true
        console.error 'getTeamAvatarImagePolicy', error
    
    getUserCoverImagePolicy: ->
      policyPath = "users/#{application.user().id()}/cover/policy"
      application.api().get policyPath
      .then (response) ->
        return response
      .catch (error) ->
        application.notifyUploadFailure true
        console.error 'getUserCoverImagePolicy', error
        
    generateUploadProgressEventHandler: (uploadData) ->
      ({lengthComputable, loaded, total}) ->
        if lengthComputable
          uploadData.ratio loaded / total
        else
          # Fake progress with each event: 0, 0.5, 0.75, 0.875, ...
          uploadData.ratio (1 + uploadData.ratio()) / 2

    # Returns a promise that will be fulfilled with the url of the uploaded
    # asset or rejected with an error.
    uploadAsset: (file, size, assetType) ->
      size = size or 'original'
      uploadData =
        ratio: Observable 0
      application.pendingUploads.push uploadData
      self.getImagePolicy(assetType)
      .then ({data}) ->
        policy = data
        console.log 'got the policy', policy
        console.log 'uploading', file
        S3Uploader(policy).upload
          key: size
          blob: file
        .progress self.generateUploadProgressEventHandler(uploadData)
      .finally ->
        application.pendingUploads.remove uploadData
      .catch (error) ->
        application.notifyUploadFailure true
        console.error "uploadAsset", error

    uploadResized: (file, size, assetType) ->
      console.log 'uploadResized', size
      resizeImage(file, size)
      .then (blob) ->
        console.log 'uploadCoverSize blob', blob
        self.uploadAsset(blob, size, assetType)      
      .catch (error) ->
        application.notifyUploadFailure true
        console.error 'uploadResized', error

    updateHasCoverImage: () ->
      HAS_COVER_IMAGE = 
        'hasCoverImage': true
      if application.pageIsTeamPage()
        application.team().updateTeam application, HAS_COVER_IMAGE          
      else
        application.user().updateUser application, HAS_COVER_IMAGE

    updateHasAvatarImage: () ->
      HAS_AVATAR_IMAGE = 
        'hasAvatarImage': true
      if application.pageIsTeamPage()
        application.team().updateTeam application, HAS_AVATAR_IMAGE          
      else
        application.user().updateUser application, HAS_AVATAR_IMAGE

    addCoverFile: (file) ->
      self.uploadAsset(file)    
      .then () ->
        self.updateHasCoverImage()
      for size of COVER_SIZES
        self.uploadResized file, size      
      blobToImage(file)
      .then (image) ->
        dominantColor = getDominantColor image
        if application.pageIsTeamPage()
          application.team().localCoverImage image.src
          application.team().hasCoverImage true
          application.team().updateCoverColor application, dominantColor
        else
          application.user().localCoverImage image.src
          application.user().hasCoverImage true
          application.user().updateCoverColor application, dominantColor
      .catch (error) ->
        application.notifyUploadFailure true
        console.error 'addCoverFile', error

    addAvatarFile: (file) ->
      self.uploadAsset file, 'original', 'avatar'
      .then () ->
        self.updateHasAvatarImage()
      for size of AVATAR_SIZES
        self.uploadResized file, size, 'avatar'
      blobToImage(file)
      .then (image) ->
        dominantColor = getDominantColor image
        if application.pageIsTeamPage()
          application.team().localAvatarImage image.src
          application.team().updateAvatarColor application, dominantColor
      .catch (error) ->
        application.notifyUploadFailure true
        console.error 'addAvatarFile', error

