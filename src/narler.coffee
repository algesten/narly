{pipe, converge, nth, flip, iif, converge, I} = require 'fnuc'
isdir = require './isdir'
log   = require 'bog'

ensuredir = converge isdir, nth(0), (check, work) -> unless check
    log.error "#{work} is not a directory"
    process.exit 1

serial = require './serial'

module.exports = (work) ->

    # check that this is indeed a dir
    ensuredir work

    # process should be in that dir
    process.chdir work

    # wrapper for git commands
    git = require('./git') work

    # maybe clone into a new dir if it doesn't
    # already exist
    cloneorpull = do ->
        clone = pipe nth(2), git.clone
        pull  = git.pull
        converge nth(0), (iif isdir, pull, clone), I

    # take the given repo to the given tag
    # (name, tag, url)
    totag = converge cloneorpull, nth(1), git.checkout

    # XXX now make nar call
    runnar = ->

    todo = pipe totag, runnar

    # receive notification of spawning a new build
    # (name, tag, url)
    # :: s, s, s -> build
    (name, tag, url) ->

        # the task for this notification
        task = -> todo name, tag, url

        # queue tasks serially per name
        serial(name, task)
