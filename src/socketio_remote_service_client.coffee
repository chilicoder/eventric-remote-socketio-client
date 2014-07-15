class SocketIORemoteServiceClient

  initialize: (@_io_client) ->
    @_callbacks = {}
    @_io_client.on 'RPC_Response', (response) =>
      setTimeout =>
        @_handleRpcResponse response
      , 0


  rpc: (payload, callback) ->
    rpcId = @_generateUid()
    console.log rpcId
    payload.rpcId = rpcId
    @_callbacks[rpcId] = callback
    @_io_client.emit 'RPC_Request', payload
    rpcId


  _handleRpcResponse: (response) ->
    if not response.rpcId
      throw new Error 'Missing rpcId in RPC Response'
    if response.rpcId not of @_callbacks
      throw new Error "No callback registered for id #{response.rpcId}"
    @_callbacks[response.rpcId] response.err, response.data
    delete @_callbacks[response.rpcId]


  _generateUid: (separator) ->
    # http://stackoverflow.com/a/12223573
    S4 = ->
      (((1 + Math.random()) * 0x10000) | 0).toString(16).substring 1
    delim = separator or "-"
    S4() + S4() + delim + S4() + delim + S4() + delim + S4() + delim + S4() + S4() + S4()


module.exports = new SocketIORemoteServiceClient