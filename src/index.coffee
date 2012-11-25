###
Helper that takes a potential mongo error and translates it into something more tangible.
###

_ = require 'underscore'
UniquenessValidationError = require './uniqueness-validation-error'
FieldValidationError = require './field-validation-error'

module.exports = (err, resource = null) ->
  return err unless err

  if err.name is "MongoError" # Mongo duplicate key error
    if err.err.indexOf("E11000") >= 0
      return new UniquenessValidationError(resource, [])
      #{"name":"MongoError", "err":"E11000 duplicate key error index: modeista-identity_test.users.$username_1  dup key: { : \"username1\" }", "code":11000, "n":0, "connectionId":953, "ok":1} TYPE object
      #console.log "EEEE: #{JSON.stringify(err)} TYPE #{typeof err}"
  else if err.name is "ValidationError" && !err.status # Mongoose validation error
    xx = []
    for key in _.keys(err.errors || {} )
      e = err.errors[key]
      xx.push
        resource: resource
        field: e.path
        code : e.type
        message: e.message
    return new FieldValidationError(resource, xx)
    #"message":"Validation failed", "name":"ValidationError",
    #"errors":{"name":{"message":"Validator \"required\" failed for path name", "name":"ValidatorError", "path":"name", "type":"required"}}}

  err