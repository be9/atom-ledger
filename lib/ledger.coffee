provider = require './ledger-provider'

module.exports =
  #activate: -> console.log 'ledger loaded'
  getProvider: -> provider
