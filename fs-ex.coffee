###!
 * Copyright (c) 2012 Andrew Volkov <hello@vol4ok.net>
 * Copyright (c) 2011 JP Richardson
###
 
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
    
BUF_LENGTH = 64*1024
_buff = new Buffer(BUF_LENGTH)

copyFileSync = (srcFile, destFile) ->
  fdr = fs.openSync(srcFile, 'r')
  fdw = fs.openSync(destFile, 'w')
  bytesRead = 1
  pos = 0
  while bytesRead > 0
    bytesRead = fs.readSync(fdr, _buff, 0, BUF_LENGTH, pos)
    fs.writeSync(fdw,_buff, 0, bytesRead)
    pos += bytesRead
  fs.closeSync(fdr)
  fs.closeSync(fdw)

copyFile = (srcFile, destFile, cb) ->
  fdr = fs.createReadStream(srcFile)
  fdw = fs.createWriteStream(destFile)
  fdr.on 'end', -> cb(null)
  fdr.pipe(fdw)

# TODO
# copyFiles = (src, dst, options = {}, callback) ->
# copyFilesSync = (src, dst, options = {}) ->
#   if fs.statSync(src).isDirectory()
#   fs.walkSync()
#   .on 'file', (path, ctx) ->
#     mkdirpSync(dst + ctx.subpath() + ctx.basename)
# moveFile = ->
# moveFileSync = ->
# rmrf = (path) ->
# rmrfSync = (path) ->

module.exports = fs
exports extends {mkdirp, mkdirpSync, copyFileSync, copyFile}