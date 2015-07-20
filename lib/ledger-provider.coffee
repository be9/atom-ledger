_ = require 'underscore-plus'
path = require 'path'
fs = require 'fs'

module.exports =
  selector: '.source.ledger'
  disableForSelector: '.source.ledger .comment'

  getSuggestions: ({editor, prefix, bufferPosition}) ->
    accounts = @getAccountNames(editor)
    prefix = @getPrefix(editor, bufferPosition)
    prefix_low = prefix.toLowerCase()

    filter = (acc, pref) ->
      return acc.toLowerCase().indexOf(pref) >= 0

    suggestions = ({text: a, replacementPrefix: prefix} for a in accounts when filter(a, prefix_low))
    suggestions

  getPrefix: (editor, bufferPosition) ->
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    line.trim()

  getAccountNames: (editor) ->
    text = editor.getText()
    accs = []

    for line in text.split("\n")
      if line.match(/^\s+\S/)
        line = line.replace(/;.*$/, '')
        tokens = line.split(/\s{2,}/)
        a = tokens[1]
        accs.push(a) if a

    unless editor.ledgerCannedAccounts?
      @loadCannedAccounts(editor)

    _.union(_.uniq(accs), editor.ledgerCannedAccounts)

  loadCannedAccounts: (editor) ->
    editor.ledgerCannedAccounts = []
    fn = path.dirname(editor.getPath()) + '/accounts.txt'

    try
      data = fs.readFileSync(fn)
      editor.ledgerCannedAccounts = _.without(_.uniq(data.toString().split("\n")), '')
    catch
      return
