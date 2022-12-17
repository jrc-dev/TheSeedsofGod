import { argon_hash } from '../../wallet/hash-generator'

###
The use of web workers and WebAssembly allows for efficient, parallelized execution of Argon's algorithm 
in the browser, preventing page crashes and providing optimized performance.
###
onmessage = do(e)
	argon_hash(e.data).then(&) do |result|
		postMessage(result)