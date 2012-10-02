#!/usr/bin/env coffee

fs = require 'fs'
utilities = require './utilities'
path = require 'path'
options = require('./parser').options

if options.lint
  readFunc = (filename) ->
    utilities.hint filename
    utilities.replaceRequires "#{fs.readFileSync(filename, 'utf-8')}\n"
else
  readFunc = (filename) ->
    utilities.replaceRequires "#{fs.readFileSync(filename, 'utf-8')}\n"

output = "//#{JSON.stringify options}\n"

if options.merchant
  dirArray = process.cwd().split '/'
  merchant_id = dirArray[dirArray.length-1]
  output = "if(typeof og_settings === 'undefined') { og_settings = {}; }; og_settings.merchant_id = '#{merchant_id}';\n"

if options.startFilename
  output += readFunc options.startFilename

if options.coreFilename
  output += readFunc options.coreFilename

if options.base
  output += utilities.requiredFiles options.lint

if options.endFilename
  output += readFunc options.endFilename

if options.output
  stream = fs.createWriteStream options.output, {flags: 'w'}
else
  stream = process.stdout

options.writeFunction output, stream
