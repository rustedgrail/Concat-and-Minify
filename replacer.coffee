fs = require 'fs'
path = require 'path'

filesSeen = {}

exports.clearFilelist = ->
  filesSeen = {}

exports.addFileToList = (file) ->
  filesSeen[file] = true

exports.replaceRequires = (input) ->
  requireRegex = /^\s*require\((.*?)\);/gm
  input.replace requireRegex, (match, p1, offset, string) ->
    output = []
    files = p1.match(/[^'",\s]+/g)
    for file in files
      fullPath = path.join("#{__dirname}/../..", file)
      if !filesSeen[fullPath]
        filesSeen[fullPath] = true
        data = fs.readFileSync(fullPath, 'utf-8')
        output.push "//require('#{file}');\n"
        output.push "#{exports.replaceRequires(data)}"
        output.push "//endRequire;\n"
    output.join ''
