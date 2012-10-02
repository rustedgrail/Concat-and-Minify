{parser, uglify} = require 'uglify-js'

{clearFileList, addFileToList, replaceRequires} = require './replacer'
exports.clearFileList = clearFileList
exports.addFileToList = addFileToList
exports.replaceRequires = replaceRequires

{requireFiles, hint} = require './fileReader'
exports.requireFiles = requiredFiles
exports.hint = hint

exports.minifiedWrite = (data, stream) ->
  ast = parser.parse data
  ast = uglify.ast_mangle ast, { defines: { DEPLOYED: ['name', 'true'] } }
  ast = uglify.ast_squeeze ast
  stream.write "#{uglify.gen_code(ast)}"

exports.uncompressedWrite = (data, stream) ->
  stream.write "#{data}"
