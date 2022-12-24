###
This will run inside a web worker.
Argon2-wasm is a Webassembly in C.
###
import argon2 from 'argon2-wasm'
import {wordlist} from './wordlists'
import {shuffle} from './shuffle'
import {to_hex} from './util'

export def argon_hash wallet
	let entropy1 = await argon_round1(wallet)
	let wordsPattern = shuffle_grid(wallet,entropy1)
	let entropy = await argon_round2(wallet,wordsPattern,entropy1)
	entropy

# First round with Argon2
def argon_round1 wallet
	let argon_ops = {
		pass: wallet.pass + wallet.pepperLeft
		salt: wallet.language + wallet.name + wallet.birthDate + wallet.email + wallet.pepperRight
		time: wallet.time || 500
		mem: wallet.mem || 16 * 1024
		parallelism: wallet.parallelism || 4
		hashLen: wallet.hashLen || 32
		type: argon2.types.Argon2id
		distPath: 'dist'
	}
	let result = await argon2.hash(argon_ops)
	result

# Second round with Argon2
def argon_round2 wallet, wordsPattern, { hashHex }
	let argon_ops = {
		pass: wordsPattern
		salt: hashHex
		time: wallet.time || 500
		mem: wallet.mem || 16 * 1024
		parallelism: wallet.parallelism || 4
		hashLen: wallet.hashLen || 32
		type: argon2.types.Argon2id
		distPath: 'dist'
	}
	let result = await argon2.hash(argon_ops)
	result

###
Clone dictionary and shuffle it.
Mount a grid 128x16 with the shuffled dictionary
Based on the selected cells of the user pattern, pick the corresponding words...
###
def shuffle_grid wallet,{ hashHex }
	let dictionary = wordlist(wallet.language).file
	let dictionaryShuffledBySeed = shuffle([...dictionary],hashHex)

	const grid = []
	for i in [0 ... 128]
		grid[i] = []
		for j in [0 ... 16]
			grid[i][j] = dictionaryShuffledBySeed[i * 16 + j]
	
	let wordsPattern = []
	for cell in wallet.selectedCells # Pick all words based on the user pattern 
		wordsPattern.push(grid[cell.row][cell.col])
	return wordsPattern.join(" ")