import { beforeEach, it,expect } from 'vitest'
import { argon_hash } from '../src/wallet/hash-generator'
import wallets from './fixtures/wallets.json'
import { shuffle } from '../src/wallet/shuffle'
import bip39_mnemonic from '../src/wallet/bip39'
import address from '../src/wallet/address'

describe('suite wallet',&) do
	# it("Satoshi wallet is correct?",&) do
	# 	let wallet = wallets[0]
	# 	let result = await argon_hash(wallet.user)
	# 	expect(result.hashHex).toBe wallet.result.hashHex

	# it("Hal Finney wallet is correct?",&) do
	# 	let wallet = wallets[1]
	# 	let result = await argon_hash(wallet.user)
	# 	expect(result.hashHex).toBe wallet.result.hashHex

	# it("Casper wallet is correct?",&) do
	# 	let wallet = wallets[2]
	# 	let result = await argon_hash(wallet.user)
	# 	expect(result.hashHex).toBe wallet.result.hashHex

	# it("Gaspare wallet is correct?",&) do
	# 	let wallet = wallets[3]
	# 	let result = await argon_hash(wallet.user)
	# 	expect(result.hashHex).toBe wallet.result.hashHex

	# it("Gaspare wallet is correct?",&) do
	# 	let wallet = wallets[4]
	# 	let result = await argon_hash(wallet.user)
	# 	expect(result.hashHex).toBe wallet.result.hashHex

	# it("Shuffle using Satoshi hash is correct?",&) do
	# 	const array = ['apple', 'banana', 'cherry', 'date', 'elderberry']
	# 	let wallet = wallets[0]
	# 	let result = shuffle([...array],wallet.result.hashHex)
	# 	expect(result[0]).toEqual array[1]
	# 	expect(result[1]).toEqual array[3]
	# 	expect(result[2]).toEqual array[0]
	# 	expect(result[3]).toEqual array[2]
	# 	expect(result[4]).toEqual array[4]

	# it("Shuffle using Hal Finey hash is correct?",&) do
	# 	const array = ['apple', 'banana', 'cherry', 'date', 'elderberry']
	# 	let wallet = wallets[1]
	# 	let result = shuffle([...array],wallet.result.hashHex)
	# 	expect(result[0]).toEqual array[3]
	# 	expect(result[1]).toEqual array[4]
	# 	expect(result[2]).toEqual array[1]
	# 	expect(result[3]).toEqual array[0]
	# 	expect(result[4]).toEqual array[2]

	it("Jose wallet is correct?",&) do
		const path = "m/85'/0'/0'/0/0"
		let wallet = {
			"user": {
				"language": "english",
				"name": "joserochadocarmo",
				"birthDate": "1986-12-05",
				"email": "jose.rcarmo@gmail.com",
				"pass": '\\Dt.rocha86\\',
				"hashLen": 32,
				"pepperLeft": "c0l0c0l1c0l126",
				"pepperRight": "c15l1c15l126c15l127",
				"selectedCells": [
					{
						"col": 0,
						"row": 0
					},
					{
						"col": 0,
						"row": 1
					},
					{
						"col": 0,
						"row": 126
					},
					{
						"col": 0,
						"row": 127
					},
					{
						"col": 1,
						"row": 0
					},
					{
						"col": 1,
						"row": 1
					},
					{
						"col": 1,
						"row": 126
					},
					{
						"col": 1,
						"row": 127
					},
					{
						"col": 2,
						"row": 0
					},
					{
						"col": 2,
						"row": 1
					},
					{
						"col": 2,
						"row": 126
					},
					{
						"col": 2,
						"row": 127
					},
					{
						"col": 3,
						"row": 0
					},
					{
						"col": 3,
						"row": 1
					},
					{
						"col": 3,
						"row": 126
					},
					{
						"col": 3,
						"row": 127
					},
					{
						"col": 4,
						"row": 0
					},
					{
						"col": 4,
						"row": 1
					},
					{
						"col": 4,
						"row": 126
					},
					{
						"col": 4,
						"row": 127
					},
					{
						"col": 5,
						"row": 0
					},
					{
						"col": 5,
						"row": 1
					},
					{
						"col": 5,
						"row": 126
					},
					{
						"col": 5,
						"row": 127
					},
					{
						"col": 6,
						"row": 0
					},
					{
						"col": 6,
						"row": 1
					},
					{
						"col": 6,
						"row": 126
					},
					{
						"col": 6,
						"row": 127
					},
					{
						"col": 7,
						"row": 0
					},
					{
						"col": 7,
						"row": 1
					},
					{
						"col": 7,
						"row": 126
					},
					{
						"col": 7,
						"row": 127
					},
					{
						"col": 8,
						"row": 0
					},
					{
						"col": 8,
						"row": 1
					},
					{
						"col": 8,
						"row": 126
					},
					{
						"col": 8,
						"row": 127
					},
					{
						"col": 9,
						"row": 0
					},
					{
						"col": 9,
						"row": 1
					},
					{
						"col": 9,
						"row": 126
					},
					{
						"col": 9,
						"row": 127
					},
					{
						"col": 10,
						"row": 0
					},
					{
						"col": 10,
						"row": 1
					},
					{
						"col": 10,
						"row": 126
					},
					{
						"col": 10,
						"row": 127
					},
					{
						"col": 11,
						"row": 0
					},
					{
						"col": 11,
						"row": 1
					},
					{
						"col": 11,
						"row": 126
					},
					{
						"col": 11,
						"row": 127
					},
					{
						"col": 12,
						"row": 0
					},
					{
						"col": 12,
						"row": 1
					},
					{
						"col": 12,
						"row": 126
					},
					{
						"col": 12,
						"row": 127
					},
					{
						"col": 13,
						"row": 0
					},
					{
						"col": 13,
						"row": 1
					},
					{
						"col": 13,
						"row": 126
					},
					{
						"col": 13,
						"row": 127
					},
					{
						"col": 14,
						"row": 0
					},
					{
						"col": 14,
						"row": 1
					},
					{
						"col": 14,
						"row": 126
					},
					{
						"col": 14,
						"row": 127
					},
					{
						"col": 15,
						"row": 0
					},
					{
						"col": 15,
						"row": 1
					},
					{
						"col": 15,
						"row": 126
					},
					{
						"col": 15,
						"row": 127
					}
				]
			}
		}
		const result = await argon_hash(wallet.user)
		const bip39_result = await bip39_mnemonic(wallet.user,result.hash)
		const address_result = address(wallet.mnemonic,path)
		console.log(address_result);
		expect(result.hashHex).toBe wallet.result.hashHex
		
