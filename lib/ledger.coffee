_ = require 'underscore-plus'

module.exports =
  editorSubscription: null
  autocomplete: null
  providers: []

  activate: ->
    return unless _.contains(atom.packages.getAvailablePackageNames(), 'autocomplete-plus')

    atom.packages.activatePackage("autocomplete-plus")
      .then (pkg) =>
        @autocomplete = pkg.mainModule
        return unless @autocomplete?

        LedgerProvider = (require './ledger-provider').ProviderClass(@autocomplete.Provider, @autocomplete.Suggestion)

        @editorSubscription = atom.workspace.observeTextEditors (editor) =>
          @registerProvider(LedgerProvider, editor)

  registerProvider: (ProviderClass, editor) ->
    return unless ProviderClass?
    return unless editor?

    editorView = atom.views.getView(editor)
    return unless editorView?

    if editor.getGrammar().name == 'Ledger' and not editorView.mini
      provider = new ProviderClass editor
      @autocomplete.registerProviderForEditor provider, editor
      @providers.push provider

  deactivate: ->
    @editorSubscription?.off()
    @editorSubscription = null

    @providers.forEach (provider) =>
      @autocomplete.unregisterProvider provider

    @providers = []
