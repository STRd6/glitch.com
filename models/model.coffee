"use strict"

# A composable data model that serializes cleanly to JSON and provides
# observable properties.

Observable = require "o_0"

defAccessor = (self, attrName) ->
  self[attrName] = (newValue) ->
    if arguments.length > 0
      self.I[attrName] = newValue

      return self
    else
      self.I[attrName]

module.exports = (I={}, self={}) ->
  constructors = {}

  extend self,
    I: I
    
    # Generates a public jQuery style getter / setter method for each String
    # argument
    attrAccessor: (attrNames...) ->
      attrNames.forEach (attrName) ->
        defAccessor(self, attrName)

      return self

    # Generates a public jQuery style getter method for each String argument
    # >     myObject = Model
    # >       r: 255
    # >       g: 0
    # >       b: 100
    # >     myObject.attrAccessor "r", "g", "b"
    # >     myObject.r(254)
    attrReader: (attrNames...) ->
      attrNames.forEach (attrName) ->
        self[attrName] = ->
          I[attrName]

      return self

    # Extends an object with methods from the passed in object
    # >     I =
    # >       x: 30
    # >       y: 40
    # >       maxSpeed: 5
    # >     player = Model(I).extend
    # >       increaseSpeed: ->
    # >         I.maxSpeed += 1
    # >     player.increaseSpeed()
    extend: (objects...) ->
      extend self, objects...

    defaults: (objects...) ->
      for object in objects
        for name of object
          if I[name] is undefined
            I[name] = object[name]

      return self
      
    # Includes a module in this object.
    # A module is a constructor that takes two parameters, I and self
    # >     myObject = Model()
    # >     myObject.include(Bindable)
    # >     myObject.bind "someEvent", ->
    # >       alert("wow. that was easy.")
    include: (modules...) ->
      for Module in modules
        Module(I, self)

      return self

    # Specify any number of attributes as observables which listen to changes
    # when the value is set
    attrObservable: (names...) ->
      names.forEach (name) ->
        self[name] = Observable(I[name])
        self[name].observe (newValue) ->
          I[name] = newValue

      return self

    # Model an attribute as an object
    # >     self.attrDatum("position", Point)
    attrDatum: (name, DataModel) ->
      I[name] = model = DataModel(I[name])
      self[name] = Observable(model)
      self[name].observe (newValue) ->
        I[name] = newValue

      return self

    # Models an array attribute as an observable array of data objects
    attrData: (name, DataModel) ->
      models = (I[name] or []).map (x) ->
        DataModel(x)
      self[name] = Observable(models)
      self[name].observe (newValue) ->
        I[name] = newValue.map (x) ->
          DataModel(x)

      return self

    # Specify an attribute to treat as an observerable model instance
    attrModel: (name, Model) ->
      unless typeof Model is 'function'
        throw new Error "#{Model} is not a function"

      constructors[name] = Model

      model = Model(I[name])
      self[name] = Observable(model)
      self[name].observe (newValue) ->
        I[name] = newValue.I

      return self

    # Observe a list of attribute models.
    # This is the same as attrModel except the attribute is expected to be an
    # array of models
    attrModels: (name, Model) ->
      unless typeof Model is 'function'
        throw new Error "#{Model} is not a function"

      constructors[name] = (data) ->
        (data or []).map (x) ->
          Model(x)

      models = constructors[name](I[name])

      self[name] = Observable(models)
      self[name].observe (newValue) ->
        I[name] = newValue.map (instance) ->
          instance.I

      return self

    # Update all fields with the given raw JSON data
    # This will invoke the constructors for fields declared with
    # `attrModel` and `attrModels`
    update: (data) ->
      # console.log "Update", I, data
      Object.keys(data).forEach (key) ->
        Constructor = constructors[key]

        value = data[key]
        
        if Constructor
          value = Constructor value

        self[key]?(value)

      return self

    # The JSON representation, I, is kept up to date via the observable properites
    toJSON: ->
      I

# Extend an object with the properties of other objects
extend = Object.assign
