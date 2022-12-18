###
State Management
Global state defination https://imba.io/docs/state-management

If you're reading this comment, state management was one of the reasons I hate React, 
Angular, Vue.js... a professor once told me, if it's complicated, it's wrong!

I started my journey looking for the simplest and plain javascript lib/frameword that existed,
I didn't find it, but as a Ruby lover, I found this fantastic framework, 
which brought together everything I like the most, good syntax, simplicity, full stack, and all the architecture 
that already exists for Javascript and Node! Thanks Sindre Aarsaether!
https://www.youtube.com/watch?v=jwoApTLvRdQ
###

# State management in Imba 🤯
let globalAppState = {
	step: 'one'
	initialized: no
	wallet: {
		language: ''
		name: ''
		birthDate: ''
		email: ''
		pass: ''		
		pepperLeft: ''
		pepperRight: ''
		selectedCells:[]
	}
}

# Extending 'element' with a new property for getting an app state value
# Now any tag can use the 'appState' property
extend tag element
	get appState
		globalAppState	