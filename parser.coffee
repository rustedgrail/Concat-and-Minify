optparse = require 'optparse'
utilities = require './utilities'

switches = [
  ['-v', '--version NUMBER', 'Version of Widget Core']
  , ['-o', '--output FILENAME', 'Output file for concatenated files']
  , ['-u', '--uncompressed', 'Do not minify or gzip the output']
  , ['-c', '--controller', 'Include common files with the controllers']
  , ['-s', '--start FILENAME', 'Include a file at the start of the output']
  , ['-e', '--end FILENAME', 'Include a file at the end of the output']
  , ['-C', '--config FILENAME', 'use the options of the JSON config file']
]

options =
  output: 'output.js'
  coreFilename: ""
  writeFunction: utilities.minifiedWrite
  controller: false
  startFilename: ""
  endFilename: ""

getVersion = (num) ->
  folder = if num > 1 then "/v#{num}" else ''
  filename = if num == 0 then 'core.uncompressed.js' else 'core-model.uncompressed.js'
  "../widget_core#{folder}/#{filename}"

parser = new optparse.OptionParser(switches)

parser.on 'config', (opt, filename) ->
  config = require "#{process.cwd()}/#{filename}"
  options.output = config.output || options.output
  options.coreFilename = if config.version? then getVersion config.version
  options.writeFunction = if config.uncompressed then utilities.uncompressedWrite else utilities.minifiedWrite
  options.controller = config.controller
  options.startFilename = config.start || options.startFilename
  options.endFilename = config.end || options.endFilename

parser.on 'output', (opt, name) ->
  options.output = name

parser.on 'version', (opt, num) ->
  options.coreFilename = getVersion(num)

parser.on 'uncompressed', ->
  options.writeFunction = utilities.uncompressedWrite

parser.on 'controller', ->
  options.controller = true


parser.on 'start', (opt, name) ->
  options.startFilename = name

parser.on 'end', (opt, name) ->
  options.endFilename = name

parser.parse process.argv[2..]

exports.options = options
