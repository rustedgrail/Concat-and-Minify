optparse = require 'optparse'
utilities = require './utilities'

switches = [
  ['-v', '--version NUMBER', 'Version of Widget Core']
  , ['-o', '--output FILENAME', 'Output file for concatenated files']
  , ['-u', '--uncompressed', 'Do not minify or gzip the output']
  , ['-s', '--startFilename FILENAME', 'Include a file at the start of the output']
  , ['-e', '--endFilename FILENAME', 'Include a file at the end of the output']
  , ['-C', '--config FILENAME', 'use the options of the JSON config file']
  , ['-l', '--lint', 'Lint the files and output the results']
  , ['-m', '--merchant', 'Include the merchant id at the start of the output']
  , ['-h', '--help', 'This help text']
  , ['-b', '--base', 'Include all files in lib, templates and common folders']
]

options =
  coreFilename: ""
  output: ''
  writeFunction: utilities.minifiedWrite
  controller: false
  startFilename: ""
  endFilename: ""
  lint: false
  merchant: false
  base: false

getVersion = (num) ->
  folder = if num > 1 then "/v#{num}" else ''
  filename = if num == 0 then 'core.uncompressed.js' else 'core-model.uncompressed.js'
  "../widget_core#{folder}/#{filename}"

parser = new optparse.OptionParser(switches)

parser.on 'config', (opt, filename) ->
  options = require "#{process.cwd()}/#{filename}"
  options.coreFilename = if options.version? then getVersion options.version
  options.writeFunction = if options.uncompressed then utilities.uncompressedWrite else utilities.minifiedWrite

parser.on 'help', (opt) ->
  console.log parser

parser.on 1, (name) ->
  options.output = name

parser.on 'output', (opt, name) ->
  options.output = name

parser.on 'version', (opt, num) ->
  options.coreFilename = getVersion(num)

parser.on 'uncompressed', ->
  options.writeFunction = utilities.uncompressedWrite

parser.on 0, (name) ->
  options.startFilename = name

parser.on 'startFilename', (opt, name) ->
  options.startFilename = name

parser.on 'endFilename', (opt, name) ->
  options.endFilename = name

parser.on 'lint', (opt) ->
  options.lint = true

parser.on 'merchant', (opt) ->
  options.merchant = true

parser.on 'base', (opt) ->
  options.base = true

parser.parse process.argv[2..]

exports.options = options
