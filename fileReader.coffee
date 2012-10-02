fs = require 'fs'
path = require 'path'
handlebars = require 'handlebars'
jshint = require 'jshint'

exports.requiredFiles = (lint) ->
  retValue = "#{readAll 'lib'}\n"
  retValue += "#{compile 'templates'}\n"
  retValue += "#{readAll 'common', lint}\n"
  retValue

exports.hint = (file, config) ->
  jshint.JSHINT file, config
  for error in jshint.JSHINT.data().errors
    console.log "#{error.raw} on #{error.line} of #{error.evidence}"

readAll = (directory, lint) ->
  retValue = ""
  if fs.existsSync directory
    for file in fs.readdirSync directory
      if file.match(/\.js$/)
        hint("#{directory}/#{file}") if lint
        retValue += fs.readFileSync "#{directory}/#{file}", 'utf-8'
  retValue

compile = (directory) ->
  output = []
  if fs.existsSync directory
    output.push('(function() {\n  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};\n')
    fs.readdirSync(directory).forEach (template) ->
      fullPath = path.join directory, template
      if path.extname(fullPath) == '.html'
        data = fs.readFileSync fullPath, 'utf8'
        template = path.basename template, '.html'

        output.push "templates['#{template}'] = template(#{handlebars.precompile(data)});\n"

    output.push '})();'
  output.join ''

