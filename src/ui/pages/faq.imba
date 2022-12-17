tag faq
	<self>
		
		<article route="">
			css p fs:medium c:amber3
			css ol fs:medium c:amber3
				
			<details>
				<summary> "What is this all?"
				<p> "We call this The Seeds of God(TSG Wallet)."
				<p> "Is a convenient and secure way to generate and, if desired, memorize a backup of your Bitcoin seeds."
				<p> "The idea was mix "
					<span[c:white]> "Proof-of-Work algorithm(Argon2)"
					" with the "
					<span[c:white]> "Border Wallet ideas whose is based on the Picture Superiority Effect "
					"by using entropy grid generator (EGG) and involves the use of user-generated patterns applied to a random map of (BIP-39 compliant) seed words."
				<p> "The process is designed to be carried out offline in a secure, air-gapped setting."
				<p> "TSG Wallet solves an issue that many Bitcoiners encounter: how to securely and reliably generate or memorize seed words."
			
			<details>
				<summary> "Is this a Border Wallet or a Brain Wallet?"
				<p> "Both! It's a combination of the two and can be also not deterministic, if you use randomized password or grid(entropically-secured(To be implemented!))."
				<p> "A border wallet is a type of digital wallet that allows users to store and manage their cryptocurrency assets. It is called a 'border' wallet because it allows users to easily and securely transfer funds across national borders."
				<p> "One key difference between a border wallet and a brain wallet is that a border wallet is typically more secure to use, as it does not rely on the user remembering a complex passphrase. In contrast, a brain wallet is generally considered to be less secure, as it is more vulnerable to being hacked or forgotten."
				<p> "But I mixed the best things from both to create this tool."
			
			<details>
				<summary> "Can TSG be hacked?"
				<p> "As all other Bitcoins tools, yes! TSG can be hacked if someone is able to guess your lang,name,date of birth,passphrase, user-pattern and wait the same Argon2 hash configurations. However, this is very difficult to do if you choose a strong, unique passphrase and user-pattern that is not easily guessable. It's also important to remember that you are the only one who knows your passphrase, so it's important to keep it safe and not share it with anyone."
			
			<details>
				<summary> "I intend to use this as a Brain Wallet!"
				
				<details>
					<summary> "What is a brain wallet?"
					<p> "A brain wallet is a cryptocurrency wallet that uses a passphrase to generate private keys. This means that you can store your cryptocurrency securely without having to rely on any external device or service."
					
				<details>
					<summary> "How does a brain wallet work?"
					<p> "A brain wallet uses a piece of software to generate a private key based on a passphrase that you choose. This private key is then used to generate a public key, which can be used to create a cryptocurrency address. You can use this address to receive and spend your cryptocurrency."

				<details>
					<summary> "Is a brain wallet secure?"
					<p> "A brain wallet can be very secure if you choose a strong, unique passphrase that is not easily guessable. It's important to use a different passphrase for each brain wallet you create, and to avoid using easily guessable phrases like dictionary words or personal information."
				
				<details>
					<summary[c:red5]> "Loss of passphrase"
					<p> "One of the biggest risks of using a brain wallet is the possibility of losing or forgetting your passphrase. If this happens, you will lose access to your cryptocurrency and there is no way to recover it. It's important to choose a passphrase that you can remember, but also to make sure it is stored securely in case you need to refer to it in the future."

				<details>
					<summary> "What are the advantages of using a brain wallet?"
					<p> "One of the main advantages of using a brain wallet is that you have complete control over your cryptocurrency. You don't have to rely on any external devices or services, and you can access your cryptocurrency from anywhere as long as you remember your passphrase. This makes brain wallets very convenient and flexible."
					<p> "It is also aimed at people who:"
						<ol>
							<li> "Live in areas of conflict, war zones, etc."
							<li> "regularly travel or move around"
							<li> "have no permanent fixed abode."
			<details>
				<summary> "Why did I create TSG?"
				<p> "I created this tool because I got tired of complex ways to save Bitcoins, all other software I know are complicated, especially for first-time users!"

			<details>
				<summary> "Summarize how to use this application!"
				<p>
					<ol>
						<li> "Go to our GitHub page and download the software source code."
						<li> "If possible, use an offline and air-gapped computer to run the software."
						<li> "Check the sha256 hasg signatures to ensure the software is legitimate and safe."
						<li> "Run the software and follow the prompts to generate your mnemonics."
						<li> "Fill the SALT fields,create a user pattern to secure your wallet. Wait hashing work."
						<li> "You're all set! if you forget anything about the generation steps, it's gone!"

			<details>
				<summary> "Why this wallet uses personal information?"
				<p> "They are stronger SALTs, they interface guide the user to easy remember informations and is used in order to strengthen the hashing of your passphrase and user-pattern. By providing personal information, the tool can generate a more secure seeds, which will make it much harder for hackers and thieves to gain access to your Bitcoins. This add security to protect your funds and give you peace of mind."

			<details>
				<summary> "Again, why on earth does this wallet use personal information?"
				<p> "We know that language,name,email,date of birth are basically public information!"
				<p> "Asking for this information, in addition to being comfortable for the user to remember later(if used as brain wallet) and also not entering this information as a passphrase, this increases the level of hashing when combined with the passphrase and the pattern generated by the user."
				<p> "The real reason to use this information is: to force the hacker not to use the Rainbow Tables and have only as an option, individualized attack, which will be mitigated by your passphrase and user-pattern also with the argon2 to make the process more expensive to just one attempt!"
				<p> 
					<pre[bg:gray7]> 
						<code>
							<div> "let passwordOrPassphrase = 123456;"
							<div> "let salt = englishhalfinney1956-05-04hal@gmail.com;"
							<div> "let passwordWithSalt = password + salt; //Well definitely more harder to break then the password alone"
							<div> "let hash = Argon2(passwordWithSalt); //Hash this for 15 minutes"

				<p> "Argon protects against brute force attacks, making the process more expensive, as it uses energy,time, cpu and memory ram, like a PoW to hash a passwords, the passphrase and the user pattern are the random elements of the step and the salts individualize the attack."

			<details>
				<summary> "Is it safe to enter my data in this application?"
				<p> "It depends on you! But please be aware that this is an open source, offline application and we do not share your data."
				<p> "This application must be used on an offline and air-gapped computer if possible."
				<p> "Try using a new clean operating system, we strongly recommend virtual machine or Tails OS. With Tails OS you can safely run it on a computer that even has a virus."

			<details>
				<summary> "I'm hesitant to enter my email into the application!"
				<p> "Using email allows us to individualize(salt) your information during encryption, since in theory, only you easy remember it and use this information! Our encryption is much more than just email."
				<p> "Again: this is an open source, offline application and we do not share your data."
				<p> "Your email helps with encryption, but that's not all we rely on, emails are extremely weak to identification or as password, let's combine it with other stronger factors!"

			<details>
				<summary> "How does our algorithm work?"
				<img.wing[bg:gray4] height=35 src='../styles/Diagram.svg'>
				<p> "Resume"
				<p>
					<ol>
						<li> "salt: wallet.language + wallet.name + wallet.birthDate + wallet.email"
						<li> "passphrase: wallet.pass"
						<li> "selectedCells = DrawnUserPattern()"
						<li> "pepper = Get3FirstSelectedCells(selectedCells)"
						<li> "hashSeed = Argon2Round1(passphrase + pepper,salt)"
						<li> "Shuffle(Fisher–Yates shuffle) an internal grid of 16x128 using hashSeed (deterministic random) and the Bip039 Official wordlist."
						<li> "let grid = shuffle_grid_using_a_seed(wallet.language,hashSeed)"
						<li> "Using the user selected coodinates(selectedCells) pick referring words at the new shuffled grid"
						<li> "let wordsPattern = pick_words(selectedCells,grid)"
						<li> "With all this new words as result, let use this as stronger password and the hashSeed as a salt and run Argon2 again."
						<li> "lastHash = Argon2Round2(wordsPattern,hashSeed)"
						<li> "yourSeeds = entropyToMnemonic(lastHash,dictionary)"
			
			<details>
				<summary> "What is Argon2?"
				<p> "Argon2 is a secure, efficient, and flexible password-hashing function that protects against dictionary and brute-force attacks by incorporating a salt and adjustable time and memory cost parameters, and supports different output lengths and hashing modes for a wide range of applications."
				<p> "Designed to be slow and difficult to parallelize, hinders the use of specialized hardware to crack passwords,"
					<span[c:white]> " this means: resistance to GPU/ASICs cracking attacks! "
				<p> "For this reason, the creation of your seed words can take up to minutos or hours of processing, this means that for each attempt to crack your seeds it will cost time and energy, not being worth the attempts, combine this with your salt and you break the hacker."

			<details>
				<summary> "Why is Hashing so slow?"
				<p> "To make the mere cracking attempt not worth it, to avoid rainbow tables, to make hackers unhappy."
				<p> "So that the process for just one attempt be expensive, making use of your cpu, memory, processing power, electricity and using the algorithm (Argon2) that avoids parallelism and is slow by design."
				<p> "Argon2 was designed to be slow and difficult to parallelize, hamper the use of specialized hardware to crack passwords,"
					<span[c:white]> " this means: resistance to GPU/ASICs cracking attacks!"
				<p> "We are still choosing a default processing time."


			
