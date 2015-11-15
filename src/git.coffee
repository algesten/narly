{converge, nth, I} = require 'fnuc'
syspath = require 'path'
{exec}  = require 'child_process'
log     = require 'bog'
plug    = require './plug'

TIMEOUT = 10 * 60 * 1000 # 10 mins
MAX_BUF = 1024 * 1024    # 1 MB

module.exports = (work) ->

    git = (path, sub, as...) -> new Promise (rs, rj) ->
        cwd = syspath.join(work, path)
        opts = {cwd, timeout:TIMEOUT, maxBuffer:MAX_BUF}
        cmd = "git #{sub} #{as.join(' ')}"
        log.info "#{cwd}:", git
        exec cmd, opts, plug(rs rj)

    clone:    (url) ->      git('.', 'clone', url)
    pull:     (dir) ->      git(dir, 'pull origin')
    checkout: (dir, tag) -> git(dir, 'checkout', tag)
