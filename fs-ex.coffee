fs = require 'fs'
fs extends require 'fs.walker'

mkdirp = (path, options = {}, callback) ->
  {dirname, exists} = require 'path'
  if typeof options is 'function'
    callback = options
    options = {}
  mode = options.mode ? 0o755
  console.log 'mkdirp', path
  parent = dirname(path)
  exists parent, (isExists) ->
    completion = (err) ->
      console.log 'competion', err
      return callback(err) if err?
      console.log 'fs.mkdir', path
      fs.mkdir(path, mode, callback)
    if isExists then completion(null)
    else mkdirp parent, options, completion

    
mkdirpSync = (path, options = {}) ->
  {dirname, existsSync} = require 'path'
  mode = options.mode or 0o755
  parent = dirname(path)
  mkdirpSync(parent, options) unless existsSync(parent)
  unless existsSync(path)
    fs.mkdirSync(path, mode)
    
fs.mkdirp = mkdirp
fs.mkdirpSync = mkdirpSync
  
module.exports = fs