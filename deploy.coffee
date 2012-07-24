#!/usr/bin/env coffee

fs = require 'fs'
utilities = require('./utilities')
options = require('./parser').options

output = ""

if options.startFilename
  output += fs.readFileSync(options.startFilename, 'utf-8')

if options.coreFilename
  output += fs.readFileSync(options.coreFilename, 'utf-8')

output += utilities.requiredFiles()

if options.endFilename
  output += fs.readFileSync(options.endFilename, 'utf-8')

if options.controller
  for i in [1..4]
    options.writeFunction output + fs.readFileSync("#{i}/controller.js", 'utf-8'),
      fs.createWriteStream "#{i}/#{options.output}", {flags: 'w'}
else
  options.writeFunction output,
    fs.createWriteStream options.output, {flags: 'w'}
