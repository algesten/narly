module.exports = (rs, rj) -> (err, v) -> if err then rj(err) else rs(v)
