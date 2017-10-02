CategoriesTemplate = require "../templates/includes/categories"

module.exports = (application) ->
  self =

    categories: ->
      # console.log "application.cate", application.categories
      application.categories()
  
  return CategoriesTemplate self
