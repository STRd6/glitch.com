"use strict"

# Extend promises with `finally`
# From: https://github.com/domenic/promises-unwrapping/issues/18
Promise.prototype.finally ?= (callback) ->
  # We don’t invoke the callback in here,
  # because we want then() to handle its exceptions
  this.then(
    # Callback fulfills: pass on predecessor settlement
    # Callback rejects: pass on rejection (=omit 2nd arg.)
    (value) ->
      Promise.resolve(callback())
      .then -> return value
    (reason) ->
      Promise.resolve(callback())
      .then -> throw reason
  )

Promise.prototype._notify ?= (event) ->
  @_progressHandlers.forEach (handler) ->
    try
      handler(event)

Promise.prototype.progress ?= (handler) ->
  @_progressHandlers ?= []
  @_progressHandlers.push handler

  return this

global.ProgressPromise = (fn) ->
  p = new Promise (resolve, reject) ->
    notify = ->
      p._progressHandlers?.forEach (handler) ->
        try
          handler(event)

    fn(resolve, reject, notify)

  p.then = (onFulfilled, onRejected) ->
    result = Promise.prototype.then.call(p, onFulfilled, onRejected)
    # Pass progress through
    p.progress result._notify.bind(result)

    return result

  return p

# https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/includes
includes = (searchElement) ->
  O = Object(this)
  len = parseInt(O.length) or 0
  return false if len is 0

  n = parseInt(arguments[1]) or 0

  if n >= 0
    k = n
  else
    k = len + n
    k = 0 if k < 0

  while (k < len)
    currentElement = O[k]
    if (searchElement is currentElement) or (searchElement != searchElement and currentElement != currentElement) # NaN != NaN
      return true
    k++

  return false

Array.prototype.includes or Object.defineProperty Array.prototype, "includes",
  value: includes

# http://stackoverflow.com/questions/3446170/escape-string-for-use-in-javascript-regex
RegExp.escape ?= (str) ->
  str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&")

Number.MAX_SAFE_INTEGER ?= 9007199254740991

module.exports = {includes}
