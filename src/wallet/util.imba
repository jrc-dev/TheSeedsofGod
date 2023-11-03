# encode as (utf-8) Uint8Array
def utf8ToBytes str
	new TextEncoder().encode(str)

# convert string to bytes
export def to_bytes data
	if typeof data === 'string'
		data = utf8ToBytes(data)
	data

# convert bytes to hex string
export def to_hex hashArray
	const hashHex = Array.from(hashArray).map(do(b) b.toString(16).padStart(2, '0')).join('')
	hashHex