import { beforeEach, it,expect } from 'vitest'
import { argon_hash } from '../src/wallet/hash-generator'
import wallets from './fixtures/wallets.json'
import { shuffle } from '../src/wallet/shuffle.imba'

describe('suite wallet',&) do
	it("Satoshi wallet is correct?",&) do
		let wallet = wallets[0]
		let result = await argon_hash(wallet.user)
		expect(result.hashHex).toBe wallet.result.hashHex

	it("Hal Finney wallet is correct?",&) do
		let wallet = wallets[1]
		let result = await argon_hash(wallet.user)
		expect(result.hashHex).toBe wallet.result.hashHex

	it("Casper wallet is correct?",&) do
		let wallet = wallets[2]
		let result = await argon_hash(wallet.user)
		expect(result.hashHex).toBe wallet.result.hashHex

	it("Gaspare wallet is correct?",&) do
		let wallet = wallets[3]
		let result = await argon_hash(wallet.user)
		expect(result.hashHex).toBe wallet.result.hashHex

	it("Gaspare wallet is correct?",&) do
		let wallet = wallets[4]
		let result = await argon_hash(wallet.user)
		expect(result.hashHex).toBe wallet.result.hashHex

	it("Shuffle using Satoshi hash is correct?",&) do
		const array = ['apple', 'banana', 'cherry', 'date', 'elderberry']
		let wallet = wallets[0]
		let result = shuffle([...array],wallet.result.hashHex)
		expect(result[0]).toEqual array[1]
		expect(result[1]).toEqual array[3]
		expect(result[2]).toEqual array[0]
		expect(result[3]).toEqual array[2]
		expect(result[4]).toEqual array[4]

	it("Shuffle using Hal Finey hash is correct?",&) do
		const array = ['apple', 'banana', 'cherry', 'date', 'elderberry']
		let wallet = wallets[1]
		let result = shuffle([...array],wallet.result.hashHex)
		expect(result[0]).toEqual array[3]
		expect(result[1]).toEqual array[4]
		expect(result[2]).toEqual array[1]
		expect(result[3]).toEqual array[0]
		expect(result[4]).toEqual array[2]
		
