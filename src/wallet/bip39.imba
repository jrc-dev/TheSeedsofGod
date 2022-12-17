import {
	entropyToMnemonic
	mnemonicToSeed
} from 'web-bip39'
import {wordlist} from '../wallet/wordlists'
import {to_hex} from './util'

export default def bip39_mnemonic wallet, entropy
	# User language defined bip39
	const dictionary = wordlist(wallet.language).file
	# Generate a random mnemonic (24 words)
	const mnemonic = await entropyToMnemonic(entropy,dictionary)
	# Use the mnemonic to generate a seed
	const seedBuffer = await mnemonicToSeed(mnemonic,wallet.pass)
	const seed = to_hex(seedBuffer)
	# Use the seed to generate an HD key object
	# const root = HDKey.fromMasterSeed(seed)
	# Derive the first child HD key from the root
	# const child = root.derive("m/44'/0'/0'/0/0")
	# Use the child HD key to generate a public key and address
	# const pubKey = child.publicKey.toString('hex')
	# const address = child.getAddress().toString('hex')
	# Use the child HD key to generate a private key
	# const privKey = child.privateKey
	
	return {
		mnemonic
		seed
		# address
		# pubKey
		# privKey
	}


