###
We use a cache to keep an identity map of categories by id.

When constructing a user model Category(...) if it has an id
field it will be cached based on the id. If the id already
exists in the cache the same reference to that model will be
returned.

If the id property is not given the model is not cached.

###

cache = {}

Model = require './model'

module.exports = Category = (I={}, self=Model(I)) ->

  if cache[I.id]
    return cache[I.id]
  
  self.defaults I,
    avatarUrl: undefined
    backgroundColor: undefined
    color: undefined
    description: undefined
    name: undefined
    url: undefined
    projects: []

  self.attrObservable Object.keys(I)...
  
  self.attrModels 'projects', Project
  self.attrObservable "gettingCategory", "fetched"

  self.extend
    hasProjects: ->
      true if self.projects().length

  if I.id
    cache[I.id] = self
  # console.log '☎️ category cache', cache

  return self


Category.getRandomCategories = (application, numberOfCategories, projectsPerCategory) ->
  console.log '🎷🎷🎷 get random categories'
  if numberOfCategories and numberOfProjects
    categoriesPath = "categories/random"
  else if numberOfCategories
    categoriesPath = "categories/random?numCategories=2"
  else if projectsPerCategory
    categoriesPath = "categories/random?projectsPerCategory=2"
  else
    categoriesPath = "categories/random"
  application.api().get categoriesPath
  .then ({data}) ->
    data.map (categoryDatum) ->
      Category(categoryDatum).update(categoryDatum)

Category.getCategories = (application) ->
  console.log '🎷🎷🎷 get categories'
  categoriesPath = "categories"
  application.api().get categoriesPath
  .then ({data}) ->
    data.map (categoryDatum) ->
      Category(categoryDatum).update(categoryDatum)

Category.updateCategory = (application, id) ->
  categoriesPath = "categories/#{id}"
  application.api().get categoriesPath
  .then ({data}) ->
    data.fetched = true
    Category(data).update(data) # .pushSearchResult(application)
    application.getProjects data.projects
    application.categoryProjectsLoaded true


Category._cache = cache

# Circular dependencies must go below module.exports
Project = require './project'
