fs = require 'fs'
path = require 'path'
handlebars = require 'handlebars'
jshint = require 'jshint'
uglify = require 'uglify-js'
jsp = uglify.parser
pro = uglify.uglify

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

exports.minifiedWrite = (data, stream) ->
  ast = jsp.parse data
  ast = pro.ast_mangle ast, { defines: { DEPLOYED: ['name', 'true'] } }
  ast = pro.ast_squeeze ast
  stream.write "#{pro.gen_code(ast)}"

exports.uncompressedWrite = (data, stream) ->
  stream.write "#{data}"

exports.replaceRequires = (input) ->
  requireRegex = /^\s*require\((.*?)\);/gm
  input.replace requireRegex, (match, p1, offset, string) ->
    output = []
    files = p1.match(/[^'",\s]+/g)
    for file in files
      output.push "\n#{fs.readFileSync(path.join("#{__dirname}/../..", file), 'utf-8')}"
    output.join ''

exports.requiredFiles = (lint) ->
  retValue = "#{readAll 'lib'}\n"
  retValue += "#{compile 'templates'}\n"
  retValue += "#{readAll 'common', lint}\n"
  retValue

exports.hint = (file, config) ->
  jshint.JSHINT file, config
  for error in jshint.JSHINT.data().errors
    console.log "#{error.raw} on #{error.line} of #{error.evidence}"
