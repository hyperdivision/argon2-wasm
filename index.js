var assert = require('nanoassert')
const bint = require('bint8array')
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

const TYPES = ['d', 'i', 'id']

// var head = 64
var freeList = []

module.exports = argon2
module.exports.ARGON2I = 1
module.exports.ARGON2ID = 2
module.exports.verify = verify
var ARGON2_VERSION = 0x13
var BYTES_MIN = module.exports.BYTES_MIN = 16
var BYTES_MAX = module.exports.BYTES_MAX = 64
var BYTES = module.exports.BYTES = 32
var KEYBYTES_MIN = module.exports.KEYBYTES_MIN = 16
var KEYBYTES_MAX = module.exports.KEYBYTES_MAX = 64
var KEYBYTES = module.exports.KEYBYTES = 32
var SALTBYTES = module.exports.SALTBYTES = 16
var PERSONALBYTES = module.exports.PERSONALBYTES = 16

function argon2 (input, nonce, key, ad, enc, opts = {}) {
  if (typeof enc === 'object') return argon2(input, nonce, key, ad, 'argon_string', enc)
  if (!opts.passes) opts.passes = 1024
  if (!opts.outlen) opts.outlen = 1024
  if (!opts.memory) opts.memory = 8192

  if (key == null) key = Buffer.alloc(0)
  if (ad == null) ad = Buffer.alloc(0)

  let head = 8192

  writeUInt32LE(input.byteLength, wasm.memory, head)
  wasm.memory.set(input, head + 4)
  head += input.byteLength + 4

  writeUInt32LE(nonce.byteLength, wasm.memory, head)
  wasm.memory.set(nonce, head + 4)
  head += nonce.byteLength + 4

  writeUInt32LE(key.byteLength, wasm.memory, head)
  wasm.memory.set(key, head + 4)
  head += key.byteLength + 4

  writeUInt32LE(ad.byteLength, wasm.memory, head)
  wasm.memory.set(ad, head + 4)
  head += ad.byteLength + 4

  wasm.exports.argon2_init(0, opts.memory, opts.outlen, opts.passes, opts.type)
  wasm.exports.argon2_hash(0, 8192, head)

  const buf = wasm.memory.slice(8192, 8192 + opts.outlen)

  if (enc === 'binary') return buf

  if (enc === 'argon_string') {
    const hash = {
      type: opts.type,
      version: ARGON2_VERSION,
      memory: opts.memory,
      passes: opts.passes,
      lanes: 1,
      salt: nonce,
      digest: buf
    }

    return argonStringEncode(hash)
  }

  try {
    const res = bint.toString(buf, enc)
    return res
  } catch (e) {
    throw new Error(`Unsupported encoding: ${enc}`)
  }
}

function verify (input, password, key, opts = {}) {
  if (typeof key === 'object') return verify(input, password, null, key)
  if (input.slice(0, 7) === '$argon2') input = argonStringDecode(input)

  const res = argon2(password, input.salt, key, input.assocData, 'binary', input)
  return Buffer.compare(res, input.digest) === 0
}

function argonStringEncode (hash) {
  const y = TYPES[hash.type]
  const v = hash.version
  const m = hash.memory
  const t = hash.passes
  const p = hash.lanes

  const data = hash.data ? ',data=' + bint.toString(hash.data, 'base64') : ''
  const salt = bint.toString(hash.salt, 'base64')
  const digest = bint.toString(hash.digest, 'base64')

  return `$argon2${y}$v=${v}$m=${m},t=${t},p=${p}${data}$${salt}$${digest}`
}

function argonStringDecode (string) {
  const form = /\$argon2([id]+)\$v=(\d+)\$m=(\d+),t=(\d+),p=(\d+)(?:,data=(.+))?\$(.+)\$(.+)/

  const [ _, y, v, m, t, p, ad, s, d ] = string.match(form)

  const assocData = ad ? bint.fromString(ad, 'base64') : null
  const salt = bint.fromString(s, 'base64')
  const digest = bint.fromString(d, 'base64')

  return {
    type: TYPES.indexOf(y),
    version: v,
    memory: m,
    passes: t,
    lanes: p,
    outlen: digest.byteLength,
    assocData,
    salt,
    digest
  }
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

  buf[offset] = int  & 0xff
  buf[offset + 1] = (int >>> 8) & 0xff
  buf[offset + 2] = (int >>> 16) & 0xff
  buf[offset + 3] = (int >>> 24) & 0xff

  return buf
}
