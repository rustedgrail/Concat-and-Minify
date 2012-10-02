utilities = require './utilities'

describe 'replacing require with files', ->
  it 'can replace require', ->
    input = "require('bin/deploy/testFile');"
    expect(utilities.replaceRequires(input)).toContain("worked")

  it 'can replace multiple requires', ->
    input = """
            require('bin/deploy/testFile');
            require('bin/deploy/testFile3');
            """
    actual = utilities.replaceRequires input
    expect(actual).toContain('worked')
    expect(actual).toContain('worked3')

  it 'can handle multiple files in 1 require', ->
    input = "require('bin/deploy/testFile', 'bin/deploy/testFile2');"
    actual = utilities.replaceRequires(input)
    expect(actual).toContain 'worked'
    expect(actual).toContain 'worked2'

  it 'preserves what is before and after require', ->
    input = "test;
             require('bin/deploy/testFile'); tset"
    actual = utilities.replaceRequires(input)
    expect(actual).toContain 'test'
    expect(actual).toContain 'tset'

  it 'does not include the comma or quote', ->
    input = "require('bin/deploy/testFile', 'bin/deploy/testFile2');"
    actual = utilities.replaceRequires(input)
    expect(actual).not.toContain ','
    expect(actual).not.toContain "'"

  it 'does not eat the semicolon before the require', ->
    input = """funcCall();
               require('bin/deploy/testFile');
            """
    actual = utilities.replaceRequires(input)
    expect(actual).toContain 'funcCall();'
