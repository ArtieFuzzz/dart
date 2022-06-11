const ws = require('ws')

// const socket = new ws.WebSocket('wss://www.earth.cluster.ws/ws')
const socket = new ws.WebSocket('ws://127.0.0.1/ws')

socket.on('open' , () => {
  console.log('Socket opened')
  socket.send(JSON.stringify({ message: 'Hello, World!'}))
})

socket.on('message', (data) => {
  console.log('Message %s', data)
})
