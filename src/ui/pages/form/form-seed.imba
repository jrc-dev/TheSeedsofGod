import bip39_mnemonic from '../../../wallet/bip39'
const ArgonWorker = import.worker './argon_worker'
const argonWorker = new ArgonWorker!

tag form-seed

	mnemonic = ''
	seed = ''
	hashHex = ''

	def mount
		window.scrollTo(0,0)
		start_hashing!

	def start_hashing
		if !Worker
			window.alert("Browser is incompatible! We need to run web worker...")
		
		argonWorker.onmessage = do(e) # webworker response
			argonWorker.terminate!
			$btn.setAttribute('aria-busy', no)
			$btn.removeAttribute('disabled')
			$btn.textContent = "Let's do it all again"

			let bip39_result = await bip39_mnemonic(appState.wallet,e.data.hash)
			hashHex = e.data.hashHex
			mnemonic = bip39_result.mnemonic
			seed = bip39_result.seed
			imba.commit!

		argonWorker.postMessage(appState.wallet) # Start webworker
		return

	def redefine_store
		window.location.reload!

	<self>
		<h6[c:white]> "Deterministic BIP39 mnemonics"
		<form$formSeed>
			<fieldset[d:flex min-height:250px]>
				
				<mnemonic-result mnemonic=mnemonic seed=seed hashHex=hashHex> if mnemonic
				
				<neo-message> unless mnemonic

			<button$btn type="submit" aria-busy="true" disabled route-to="/generator" @click=redefine_store> "PoW Running…"

			<div[c:amber4 ta:center]> "Repeat all steps several times to ensure same sentence." if mnemonic


tag mnemonic-result
	prop mnemonic

	css .blur 
		filter: blur(2px) filter@hover:none
		transition:filter 0.3s ease
	css .box w:100px ta:left c:white

	def render
		<self>
			<h6[c:amber4 ta:center mx:40px]> "Your BIP39 Mnemonic 24 words"
			<div.blur[d:grid gtc:repeat(3, 1fr) jai:center]>
				for word in mnemonic.split(' ')
					<div.box>
						<span> word
			
			<h6[c:amber4 ta:center my:40px]> "Entropy Hexadecimal"
			<div.blur[d:grid jai:center]>
				<div> <span> hashHex

			<h6[c:amber4 ta:center my:40px]> "BIP39 Seed"
			<div.blur[d:grid jai:center]>
				<div[w:400px]> <span> seed

			<div[c:gray4 fs:14px pt:30px]> "*The seed is protect with a your passphrase."
			<div[c:gray4 fs:14px pt:10px]> "*The conversion of the mnemonic sentence to a binary seed or Bitcoin addresses is completely independent from generating the mnemonic sentence."
			

tag neo-message
	prop info = [
		"Wake up Neo."
		"They want your Bitcoins."
		"But we won't make it easy."
		"As we chat here..."
		"We are using your computing power(...CPU and Memory)."
		"Do you know how they crack Bitcoin wallets?"
		"Mostly by hash function computations(Brute force)!"
		"Passwords tend to have low entropy."
		"GPUs or ASICs can hash more than 150 terahashes per second!"
		"But what if we use a PoW algorithm for hashing?"
		"Let's make the brute force expensive to try."
		"Your personal data (e-mail, name...) are a powerful SALT."
		"Only with them we are already saying to them:"
		"Your rainbow tables are worthless!"
		"But they won't stop."
		"Now they will have to individualized attacks."
		"Do you know Argon2 Neo?"
		"Argon 2 is considered a secure password hashing algorithm."
		"Designed to be slow and difficult to parallelize."
		"Making it difficult to use specialized hardware to crack passwords."
		"This means: resistance to GPU/ASICs cracking attacks!"
		"It's like a cryptographic proof of work."
		"And we're using it right now!"
		"Argon2 it is running as WebAssembly."
		"But to use your processing power..."
		"Without crashing your browser."
		"We use Web Workers!"
		"Web Workers means run web code in background."
		"Wait!"
		"It takes almost 15 minutes hashing."
		"For every attempt to attack your wallet..."
		"The attacker has to spend time, processing and energy!"
		"for a single attack!"
		"Good luck and be safe."
	]
	prop labelIndex = -1
	prop text1 = ""

	def mount
		$interval = setInterval(render.bind(self),6000)

	def unmount
		clearInterval($interval)

	def render
		self.labelIndex = self.labelIndex + 1
		self.labelIndex = (self.labelIndex++) % self.info.length
		self.text1 = self.info[self.labelIndex]
		<self>
			<div.typewriter innerHTML="<p> {text1}">

