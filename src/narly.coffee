parseArgs = require 'minimist'
log = require 'bog'

DEFAULT_SECRET = 'myhashsecret'

opts =
    boolean: ['v']
    string:  ['p', 's']
    default:
        p: '7531'
        s: DEFAULT_SECRET

module.exports = ->

    # parse arguments
    argv = parseArgs process.argv[2..], opts

    # maybe turn on debug mode
    log.level 'debug' if argv.v

    # should not use default
    if argv.s == DEFAULT_SECRET
        log.warn "Using default secret (#{DEFAULT_SECRET}). Use -s to set another"

    if argv._.length == 0
        log.error "Must provide a work directory"
        usage = true

    if usage
        process.stderr.write "Usage: narly -p <port> -s <secret> [work dir]\n"
        process.exit 1

    port = parseInt argv.p
    work = argv._[0]
    secret = argv.s

    # wire up the github webhooks
    hook   = require('./webhooks') port, secret

    # the worker keeping track of nar builds
    narler = require('./narler') work

    # wait for tag event and run processing
    hook (ev) -> narler ev.repository.name, ev.ref, ev.ssh_url
