# @deprecated not been used in this project
import {to_bytes} from './util'

###
The pbkdf2 (Password-Based Key Derivation Function 2) algorithm is a cryptographic function that
derives a secure and random key from a password and salt value, using a large number of iterations
and a specified hash algorithm.
###
export default def pbkdf2(hashAlgorithm, password, salt, iterations=2048, byteLength=32)
	const baseKey = await crypto.subtle.importKey('raw', to_bytes(password), 'PBKDF2', false, ['deriveBits'])
	const arrayBuffer = await crypto.subtle.deriveBits({
		name: 'PBKDF2'
		hash: hashAlgorithm
		salt: to_bytes(salt)
		iterations
	}, baseKey, byteLength * 8)
	new Uint8Array(arrayBuffer)