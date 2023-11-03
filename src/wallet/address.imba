import * as bitcoin from '../3rd/bitcoinjs-lib'
import {mnemonicToSeed} from 'web-bip39'
import {to_hex} from './util'
import {nip19} from 'nostr-tools'

export default def address(mnemonic,derivePath)
	const network = bitcoin.networks.bitcoin # use networks.testnet for testnet

	# Generate a Bip39 seed from the mnemonic
	const seed = await mnemonicToSeed(mnemonic)

	# Generate an extended private key (xprv) from the seed
	const master = bitcoin.bip32.fromSeed(bitcoin.Buffer.from(seed),network)

	# BIP32 extended private key (xprv).
	const xprv = master.toBase58()
	
	# BIP32 extended public key (xpub).
	const xpub = master.neutered().toBase58()

	const privateKey = master.derivePath(derivePath).privateKey
	const privateKeyHex = to_hex(privateKey)

	# Get the private key in different formats
	const ecPair = bitcoin.ECPair.fromPrivateKey(privateKey,network,{compressed: yes})
	const privateKeyWIF = ecPair.toWIF()

	const compressedEcpair = bitcoin.ECPair.fromPrivateKey(privateKey,network,{compressed: yes})
	const privateKeyWIFcompressed = compressedEcpair.toWIF()
	
	# Generate a public key
	const publicKey = ecPair.publicKey
	const publicKeyHex = to_hex(publicKey)

	# Generate a P2PKH address
	const p2pkh = bitcoin.payments.p2pkh({ pubkey: publicKey, network })

	# Generate a P2SH segwit address
	const p2sh = bitcoin.payments.p2sh({redeem: bitcoin.payments.p2wpkh({ pubkey: publicKey }),})

	# Generate a Bech32 P2WPKH address
	const p2wpkh = bitcoin.payments.p2wpkh({ pubkey: publicKey })

	# Generate a Nsec address
	const nsec = nip19.nsecEncode(privateKeyHex)

	# Generate a Bech32 P2WSH address
	const p2wsh = bitcoin.payments.p2wsh({ redeem: p2wpkh })

	console.log("mnemonic: ", mnemonic)
	console.log("BIP39 Seed: ",to_hex(bitcoin.Buffer.from(seed)))
	console.log("BIP32 Root Key(prv): ", xprv);
	console.log("BIP32 Root Key(pub): ", xpub);
	# console.log("privateKey: ", privateKey)
	console.log("privateKeyHex: ", privateKeyHex)
	console.log("privateKeyWIF: ", privateKeyWIF)
	console.log("privateKeyWIFcompressed: ", privateKeyWIFcompressed)
	# console.log("publicKey: ", publicKey)
	console.log("publicKeyHex: ", publicKeyHex)
	console.log("nsec: ", nsec)
	
	console.log("p2pkh: ", p2pkh.address)
	console.log("p2sh: ", p2sh.address)
	console.log("p2wpkh: ", p2wpkh.address)
	console.log("p2wsh: ", p2wsh.address)
	console.log("p2wsh: ", bitcoin)
	const bech32PrivateKey = bitcoin.address.toBech32(privateKey,network.bech32,'nsec')
	console.log(bech32PrivateKey);
	const bech32PublicKey = bitcoin.address.toBech32(publicKey,network.bech32,'npub')
	console.log(bech32PublicKey);

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
		p2wsh,
		nsec
	}


