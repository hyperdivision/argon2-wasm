const argon2 = require('./')

// const input = Buffer.from('359320f8edc5c8b9148c90cab741f69f1958f1806a997d6949d953ddc26f64bfb1a35e7483f7614dff97a9f9d5528a4a305b77494846ca5099af62b2c2320fc20000000000000000', 'hex')
const input = Buffer.from('abcdef', 'hex')
const nonce = Buffer.from('0123456789abcdef', 'hex')
const key = Buffer.alloc(0)
const ad = Buffer.alloc(0)


const buf = Buffer.from(argon2(input, nonce, key, ad))
console.log(buf.toString('hex'))



// d3bf532267a4c4c10475c37f5d68cb8730311bc5c9c20f9b8d441e0386e9d02b9a761f78c349f9ae7465750f6c8136d8d51aa781adb5f21e673bcf3dbe28aa3419eea9638a9eed36d5225ae6dbc374251b83320304435d1aedf1b66f01b72a0b1d11c5af166129aa002180f4b0f57877eda373e35d39fe2cb7b12fa086405941
