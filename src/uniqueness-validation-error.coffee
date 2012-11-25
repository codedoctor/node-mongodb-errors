_ = require 'underscore'


module.exports = class UniquenessValidationError extends Error
  constructor: (resource = null, fields = []) ->
    @name = 'Validation Error'
    @message = "The value provided already exists"
    @status = 422

    @errors = []

    for field in fields
      @errors.push
        resource: resource
        field: field
        code : 'uniqueness'
        message: "The value provided already exists"


    Error.call @, @message
    Error.captureStackTrace @, arguments.callee