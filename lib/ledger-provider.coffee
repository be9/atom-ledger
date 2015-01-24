_ = require 'underscore-plus'
path = require 'path'
fs = require 'fs'

module.exports =
ProviderClass: (Provider, Suggestion)  ->
  class LedgerProvider extends Provider
    wordRegex: /\S+/g

    buildSuggestions: ->
      accounts = @getAccountNames(@editor.getText())

      selection = @editor.getSelection()
      prefix = @prefixOfSelection selection
      return unless prefix.length

      prefix_low = prefix.toLowerCase()

      filter = (acc, pref) ->
        return acc.toLowerCase().indexOf(pref) >= 0

      suggestions = (new Suggestion(this, word: a, label: a, prefix: prefix) \
                     for a in accounts when filter(a, prefix_low))

      if suggestions.length > 0
        suggestions

    getAccountNames: (text) ->
      accs = []

      for line in text.split("\n")
        if line.match(/^\s+\S/)
          line = line.replace(/;.*$/, '')
          tokens = line.split(/\s{2,}/)
          a = tokens[1]

          accs.push(a) if a

      unless @canned_accounts?
        @loadCannedAccounts()

      _.union(_.uniq(accs), @canned_accounts)

    loadCannedAccounts: ->
      @canned_accounts = []
      fn = path.dirname(@editor.getPath()) + '/accounts.txt'

      try
        data = fs.readFileSync(fn)
        @canned_accounts = _.without(_.uniq(data.toString().split("\n")), '')
      catch
        return
