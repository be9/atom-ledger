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

        LedgerProvider = require "./ledger-provider"

        @editorSubscription = atom.workspaceView.eachEditorView (editorView) =>
          @registerProvider(LedgerProvider, editorView)

  registerProvider: (ProviderClass, editorView) ->
    if editorView.editor.getGrammar().name == 'Ledger' and editorView.attached and not editorView.mini
      provider = new ProviderClass editorView
      @autocomplete.registerProviderForEditorView provider, editorView
      @providers.push provider

  deactivate: ->
    @editorSubscription?.off()
    @editorSubscription = null

    @providers.forEach (provider) =>
      @autocomplete.unregisterProvider provider

    @providers = []
