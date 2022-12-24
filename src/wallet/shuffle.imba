###
Fisher–Yates shuffle Implementation
https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
Shuffle the dictionary list by using seed to generate a unique grid for you using secure PRNG
###
export def shuffle(array, seed)
	# Initialize a counter to use as the index into the seedHex string
	let i = 0
	# Generate a pseudo-random number between 0 and 1
	const random = do
		# Use the next 8 characters of the seed as a hexadecimal number
		const valueHex = seed.substr(i, 8)
		i = (i + 8) % seed.length
		const value = parseInt(valueHex, 16)
		return value / Math.pow(2, 32)
  
	# Use the Fisher–Yates shuffle algorithm to shuffle the array
	for currentIndex in [0 .. array.length - 1]
		# Generate a deterministic(seed) index between currentIndex and the end of the array
		const randomIndex = currentIndex + Math.floor(random! * (array.length - currentIndex))
		# Swap the element at index currentIndex with the element at index randomIndex
		[array[currentIndex], array[randomIndex]] = [array[randomIndex], array[currentIndex]]
	array