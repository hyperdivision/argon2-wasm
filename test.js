const argon2 = require('./')

// const input = Buffer.from('359320f8edc5c8b9148c90cab741f69f1958f1806a997d6949d953ddc26f64bfb1a35e7483f7614dff97a9f9d5528a4a305b77494846ca5099af62b2c2320fc20000000000000000', 'hex')
const string = "a347ae92bce9f80f6f595a4480fc9c2fe7e7d7148d371e9487d75f5c23008ffae065577a928febd9b1973a5a95073acdbeb6a030cfc0d79caa2dc5cd011cef02c08da232d76d52dfbca38ca8dcbd665b17d1665f7cf5fe59772ec909733b24de97d6f58d220b20c60d7c07ec1fd93c52c31020300c6c1facd77937a597c7a6"
const input = Buffer.from(string, 'hex')
const nonce = Buffer.from('5541fbc995d5c197ba290346d2c559dedf405cf97e5f95482143202f9e74f5c2', 'hex')
const key = Buffer.alloc(0)
const ad = Buffer.alloc(0)


const buf = Buffer.from(argon2(input, nonce.subarray(0, 16), key, ad, { memory: 8, passes: 5, outlen: 64}))
console.log(buf.toString('hex'))



// d3bf532267a4c4c10475c37f5d68cb8730311bc5c9c20f9b8d441e0386e9d02b9a761f78c349f9ae7465750f6c8136d8d51aa781adb5f21e673bcf3dbe28aa3419eea9638a9eed36d5225ae6dbc374251b83320304435d1aedf1b66f01b72a0b1d11c5af166129aa002180f4b0f57877eda373e35d39fe2cb7b12fa086405941
