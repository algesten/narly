fs  = require 'fs'

module.exports = (dir) -> new Promise (rs, rj) ->
    fs.stat dir, (err, stat) ->
        if err
            if err.code == 'ENOENT' then rs(false) else rj(err)
        else
            rs stat.isDirectory()
