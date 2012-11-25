_ = require 'underscore'


module.exports = class UniquenessValidationError extends Error
  constructor: (resource = null, @errors = []) ->
    @name = 'Validation Error'
    @message = "One or more items need some attention."
    @status = 422

    Error.call @, @message
    Error.captureStackTrace @, arguments.callee