import './mnemonic-generator'
import '../commom/store'

tag generator

	def mount
		window.scrollTo(0,0)

	<self>
		<mnemonic-generator route="mnemonic/new">
		<mnemonic-generator route="mnemonic/recover">

		<article route="">
			css p fs:medium c:amber3
			<details>
				<summary> "Introduction"
				<p> "🧠 The Seeds of God(TSG Wallet) is an open source, offline and useful tool for creating secure mnemonic sentence for Bitcoin using PoW algorithm(Argon2)."
				<p[d:flex]> 
					<img.wing width=25 height=30 src='../styles/imba.svg'> 
					"The goal is to be the go-to source for generating seeds for Bitcoin, you have the option to create a deterministic and memorable phrase or to generate a random phrase. Either way, it's a useful resource for creating a secure and easily-remembered backup of your Bitcoin seeds."

			<details>
				<summary> "Mnemonic"
				<p> "🙍‍♂️ A mnemonic is a word, short poem, or sentence that is intended to help you remember words. For Bitcoin, it's an implementation(BIP039) to generate deterministic wallets."
				<p> "🔑 Once you have your mnemonics you can use any current Bitcoin wallet of your choice. The conversion of the mnemonic sentence to a binary seed(...Bitcoin Addresses) is completely independent from generating the mnemonic sentence."

			<details>
				<summary> "Hashing Algorithms"
				<p[c:gray5]> "To help you generate mnemonics we have carefully selected the information that you need to fill out."
				<p> "💾 We don't store or share your information. The information collected is only used to strengthen improve hashing."
				<p> "✏️ Recipe: We use the expensive Argon2 for hashing, Fisher–Yates to shuffle, SALT, Pepper, passphrase and entropy grid generator (EGG). "
					<a href='/faq' > 'How does our algorithm work?'
					'.'
				<p> "💡 It is important that you are able to remember, save and protect information that you use here, at any point in your life!"
			
			<div[d:hflex mx:15]>
				<button[p:15px m:1.5rem] @click.prevent route-to="mnemonic/new"> "Generate Mnemonic"
				<button[p:15px m:1.5rem] @click.prevent route-to="mnemonic/recover"> "Recover Mnemonic" 
