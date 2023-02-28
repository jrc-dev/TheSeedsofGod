import * as bitcoin from '../3rd/bitcoinjs-lib'
import {mnemonicToSeed} from 'web-bip39'
import {to_hex} from './util'

export default def address(mnemonic,derivePath)
	# Define the network
	let network = bitcoin.networks.bitcoin # use networks.testnet for testnet
	
	# Generate a Bip39 seed from the mnemonic
	let seed = await mnemonicToSeed(mnemonic)

	# Generate an extended private key (xprv) from the seed
	let master = bitcoin.bip32.fromSeed(bitcoin.Buffer.from(seed),network)

	# BIP32 extended private key (xprv).
	let xprv = master.toBase58()
	
	# BIP32 extended public key (xpub).
	let xpub = master.neutered().toBase58()

	let privateKey = master.derivePath(derivePath).privateKey
	let privateKeyHex = to_hex(privateKey)

	debugger

	# Get the private key in different formats
	let ecPair = bitcoin.ECPair.fromPrivateKey(privateKey,network,{compressed: yes})
	let privateKeyWIF = ecPair.toWIF()

	let compressedEcpair = bitcoin.ECPair.fromPrivateKey(privateKey,network,{compressed: yes})
	let privateKeyWIFcompressed = compressedEcpair.toWIF()
	
	# Generate a public key
	let publicKey = ecPair.publicKey
	let publicKeyHex = to_hex(publicKey)

	# Generate a P2PKH address
	let p2pkh = bitcoin.payments.p2pkh({ pubkey: publicKey, network })

	# Generate a P2SH segwit address
	let p2sh = bitcoin.payments.p2sh({redeem: bitcoin.payments.p2wpkh({ pubkey: publicKey }),})

	# Generate a Bech32 P2WPKH address
	let p2wpkh = bitcoin.payments.p2wpkh({ pubkey: publicKey })

	# Generate a Bech32 P2WSH address
	let p2wsh = bitcoin.payments.p2wsh({ redeem: p2wpkh })

	# console.log("master: ", master)
	console.log("BIP39 Seed: ",to_hex(bitcoin.Buffer.from(seed)))
	console.log("BIP32 Root Key(prv): ", xprv);
	console.log("BIP32 Root Key(pub): ", xpub);
	# console.log("privateKey: ", privateKey)
	console.log("privateKeyHex: ", privateKeyHex)
	console.log("privateKeyWIF: ", privateKeyWIF)
	console.log("privateKeyWIFcompressed: ", privateKeyWIFcompressed)
	# console.log("publicKey: ", publicKey)
	console.log("publicKeyHex: ", publicKeyHex)
	console.log("p2pkh: ", p2pkh.address)
	console.log("p2sh: ", p2sh.address)
	console.log("p2wpkh: ", p2wpkh.address)
	console.log("p2wsh: ", p2wsh.address)
	const bech32PrivateKey = bitcoin.address.toBech32(privateKey,0,'nsec')
	console.log(bech32PrivateKey);
	const bech32PublicKey = bitcoin.address.toBech32(publicKey,network.bech32,'npub')
	console.log(bech32PublicKey);

	console.log("private key c06e237d1a9030429faf546d87fd478903335528a594227d2b29f46ead6bd7f3");
	console.log("public key b07665c537c8de54647b5f81a4657059eaa1404e3db380c4c1a994cb493eb39c");
	console.log("public key nsec1cphzxlg6jqcy98a023kc0l283ypnx4fg5k2zylft986xattt6lescfgc2j");
	console.log("bech32 public key npub1kpmxt3fher09germt7q6getst842zszw8kecp3xp4x2vkjf7kwwq90xc88");

	return {
		master
		privateKey
		privateKeyHex
		privateKeyWIF
		privateKeyWIFcompressed
		publicKey
		p2pkh
		p2sh
		p2wpkh
		p2wsh
	}


