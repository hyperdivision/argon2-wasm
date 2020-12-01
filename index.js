var assert = require('nanoassert')
var wasm = require('./argon2')({
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

console.log(wasm)

module.exports = argon2
var BYTES_MIN = module.exports.BYTES_MIN = 16
var BYTES_MAX = module.exports.BYTES_MAX = 64
var BYTES = module.exports.BYTES = 32
var KEYBYTES_MIN = module.exports.KEYBYTES_MIN = 16
var KEYBYTES_MAX = module.exports.KEYBYTES_MAX = 64
var KEYBYTES = module.exports.KEYBYTES = 32
var SALTBYTES = module.exports.SALTBYTES = 16
var PERSONALBYTES = module.exports.PERSONALBYTES = 16

function argon2 (input, nonce, key, ad, opts = {}) {
  if (!opts.passes) opts.passes = 1024
  if (!opts.outlen) opts.outlen = 1024
  if (!opts.memory) opts.memory = 8192

  let head = 8192

  writeUInt32LE(input.length, wasm.memory, 8192)
  wasm.memory.set(input, head)
  wasm.memory.set(input, head + 4)
  head += input.length + 4

  writeUInt32LE(nonce.length, wasm.memory, 8192)
  wasm.memory.set(nonce, head)
  wasm.memory.set(nonce, head + 4)
  head += nonce.length + 4

  writeUInt32LE(key.length, wasm.memory, 8192)
  wasm.memory.set(key, head)
  wasm.memory.set(key, head + 4)
  head += key.length + 4

  writeUInt32LE(ad.length, wasm.memory, 8192)
  wasm.memory.set(ad, head)
  wasm.memory.set(ad, head + 4)
  head += ad.length + 4

  wasm.exports.argon2_init(0, opts.memory, opts.outlen, opts.passes)
  wasm.exports.argon2_hash(0, 8192, head)

  return wasm.memory.slice(8192, 8192 + opts.outlen)
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

function writeUInt32LE (int, buf, offset) {
  if (!offset) offset = 0

  buf[offset] = (int >>> 24) & 0xff
  buf[offset + 1] = (int >>> 16) & 0xff
  buf[offset + 2] = (int >>> 8) & 0xff
  buf[offset + 3] = int  & 0xff

  return buf
}
