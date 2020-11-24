var assert = require('nanoassert')
var wasm = require('./blake2b')({
  imports: {
    debug: {
      log (...args) {
        console.log(...args.map(int => (int >>> 0).toString(16).padStart(8, '0')))
      },
      log_tee (arg) {
        console.log((arg >>> 0).toString(16).padStart(8, '0'))
        return arg
      }
    }
  }
})

var head = 64
var freeList = []

module.exports = blake2b_long
var BYTES_MIN = module.exports.BYTES_MIN = 16
var BYTES_MAX = module.exports.BYTES_MAX = 64
var BYTES = module.exports.BYTES = 32
var KEYBYTES_MIN = module.exports.KEYBYTES_MIN = 16
var KEYBYTES_MAX = module.exports.KEYBYTES_MAX = 64
var KEYBYTES = module.exports.KEYBYTES = 32
var SALTBYTES = module.exports.SALTBYTES = 16
var PERSONALBYTES = module.exports.PERSONALBYTES = 16

function blake2b_long (input, outlen) {
  wasm.memory.fill(0, 0, 64)
  wasm.memory[0] = 64
  wasm.memory[1] = 0
  wasm.memory[2] = 1 // fanout
  wasm.memory[3] = 1 // depth

  const pointer = head
  head += 512
  wasm.memory.set(input, head + 4)

  wasm.exports.blake2b_long(pointer, head, head + input.length + 4, outlen, head + 4 + input.length)

  return wasm.memory.slice(head + 4 + input.length, head + 4 + input.length + outlen)
}

function noop () {}

function hexSlice (buf, start, len) {
  var str = ''
  for (var i = 0; i < len; i++) str += toHex(buf[start + i])
  return str
}

function toHex (n) {
  if (n < 16) return '0' + n.toString(16)
  return n.toString(16)
}
