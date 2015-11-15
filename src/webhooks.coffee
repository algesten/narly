createHandler = require 'github-webhook-handler'
http          = require 'http'
log           = require 'bog'

PATH = '/webhook'

module.exports = (port, secret) ->

    # the handler for github webhooks
    handler       = createHandler { path: PATH, secret }

    # start server for handler
    http.createServer (req, res) ->
        handler req, res, (err) ->
            res.statusCode = 404
            res.end 'no such location'
    .listen port

    log.info "Listening to port #{port} and path #{PATH}"

    (callback) -> handler.on 'create', (ev) ->
        if ev.ref_type == 'tag'
            log.info "Tag created #{ev.repository.full_name}: #{ev.ref}"
            callback ev
