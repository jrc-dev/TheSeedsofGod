# TODO Make all this lazy loading!
import english from 'web-bip39/wordlists/english'
import french from 'web-bip39/wordlists/french'
import italian from 'web-bip39/wordlists/italian'
import japanese from 'web-bip39/wordlists/japanese'
import korean from 'web-bip39/wordlists/korean'
import portuguese from 'web-bip39/wordlists/portuguese'
import spanish from 'web-bip39/wordlists/spanish'
import czech from 'web-bip39/wordlists/czech'
import chineseTraditional from 'web-bip39/wordlists/chinese-traditional'
import chineseSimplified from 'web-bip39/wordlists/chinese-simplified'

const wordlists = {
	english:
		name: "english"
		file: english
	french:
		name: "french"
		file: french
	italian:
		name: "italian"
		file: italian
	japanese:
		name: "japanese"
		file: japanese
	korean:
		name: "korean"
		file: korean
	portuguese:
		name: "portuguese"
		file: portuguese
	spanish:
		name: "spanish"
		file: spanish
	czech: 
		name: "czech"
		file: czech
	"chinese-traditional":
		name: "chinese-traditional"
		file: chineseTraditional
	"chinese-simplified":
		name: "chinese-simplified"
		file: chineseSimplified
}

export def wordlist lang
	wordlists[lang]