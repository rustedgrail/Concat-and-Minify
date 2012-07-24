fs = require 'fs'
path = require 'path'
handlebars = require 'handlebars'
uglify = require 'uglify-js'
jsp = uglify.parser
pro = uglify.uglify

readAll = (directory) ->
  retValue = ""
  if fs.existsSync directory
    for file in fs.readdirSync directory
      if file.match(/\.js$/)
        retValue += fs.readFileSync "#{directory}/#{file}", 'utf-8'
  retValue

compile = (directory) ->
  output = []
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
  ast = pro.ast_mangle ast, { defines: { DEVMODE: ['name', 'true'] } }
  ast = pro.ast_squeeze ast
  stream.write ";#{pro.gen_code(ast)}"

exports.uncompressedWrite = (data, stream) ->
  stream.write "#{data}\n"

exports.requiredFiles = ->
  retValue = readAll 'lib'
  retValue += compile 'templates'
  retValue += readAll 'common'
  retValue
