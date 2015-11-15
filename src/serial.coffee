{last} = require 'fnuc'

tasks = {}

module.exports = (name, task) -> new Promise (rs) ->
    run = -> task().then rs, rs
    if prev = tasks[name]
        prev.then run, run
    else
        run()
    tasks[name] = task
