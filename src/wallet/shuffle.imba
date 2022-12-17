import seedrandom from 'seedrandom'

### 
Generate a cryptographically secure PRNG using a seed in JavaScript. 
The generated PRNG can be used to generate random numbers that are cryptographically secure and unpredictable, 
and the PRNG can be seeded with a new value to generate a new sequence of random numbers.
###
export def secureSeedRandom(seed)
	return seedrandom(seed).quick!

###
Fisher–Yates shuffle Implementation
https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
Shuffle the dictionary list by using seed to generate a unique grid for you using secure PRNG
###
export def shuffle(array, seed)
	let temporaryValue
	let randomIndex
	let rand = secureSeedRandom(seed)
	let currentIndex = array.length
	# While there remain elements to shuffle...
	while 0 !== currentIndex
		// Pick a remaining element...
		randomIndex = Math.floor(rand * (currentIndex = currentIndex - 1))
		// And swap it with the current element.
		temporaryValue = array[currentIndex]
		array[currentIndex] = array[randomIndex]
		array[randomIndex] = temporaryValue
	array