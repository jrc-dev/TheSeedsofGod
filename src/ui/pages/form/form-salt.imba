tag form-salt

	def onclick_step_one e
		e.preventDefault!
		if !$formWallet.checkValidity!
			$formWallet.reportValidity!
			return false

		appState.step = 'two'
		appState.initialized = yes
		appState.wallet.language = $language.value
		appState.wallet.name = $name.value
		appState.wallet.birthDate = $birthDate.value
		appState.wallet.email = $email.value
		appState.wallet.pass = $pass.value
		$formWallet.reset!

	<self>
		<div[fs:md c:gray4 pb:10px]> "Salt Fields. Please read our {<a href="/faq"> "documentation"} and understand why we ask for personal data here."
		<form$formWallet[fs@lg:18px]>
			<fieldset>
				<label> 
					"Language" 
					<mind-tooltip>
					<help-tooltip>
					<help-tooltip title="Regarding the language(Official BIP39 Word List (mnemonic)) of your seed phrase.">
					<select$language required>
						<option value="" selected> ""
						<option value="english"> "English"
						<option value="portuguese"> "Portuguese"
						<option value="french"> "French"
						<option value="italian"> "Italian"
						<option value="japanese"> "Japanese"
						<option value="korean"> "Korean"
						<option value="spanish"> "Spanish"
						<option value="czech"> "Czech"
						<option value="chinese-traditional"> "Chinese-traditional"
						<option value="chinese-simplified"> "Chinese-simplified"

				<label> 
					"Full name"
					<mind-tooltip>
					<help-tooltip>
					<input$name type="text" minLength=5 required 
						pattern="^[\x21-\x7E]+$" title="Space characters are not allowed" 
						autocomplete="off"
						@keyup=($name.setAttribute('aria-invalid', !$name.checkValidity!)) >

				<label> 
					"Birth date"
					<mind-tooltip>
					<help-tooltip>
					<input$birthDate type="date" required>

				<label>
					"Email"
					<mind-tooltip>
					<help-tooltip>
					<help-tooltip title="Help us to individualize you data during encryption, since in theory, only you easy remember it and use this information.">
					<input$email type="email" autocomplete="off" required @keyup=($email.setAttribute('aria-invalid', !$email.checkValidity!))>
					<small[fs:sm c:gray5]> "We never send or share your email."

				<label>
					"Passphrase or Password (optional)"
					<mind-tooltip>
					<help-tooltip title="Passphrases are longer and more secure than passwords. Typically consist of multiple words, numbers, or other characters.">
					<input$pass type="text" minLength=5 autocomplete="off"
						pattern="^[\x21-\x7E]+$" title="Space characters are not allowed" 
						@keyup=($pass.setAttribute('aria-invalid', !$pass.checkValidity!)) >
				
				<label for="terms">
					<input type="checkbox" id="terms" name="terms" required>
					<span[fs:md]>
						"Sanity check: I'll remember the information provided above, as forgetting it will result in its permanent loss."

			<button$btnStepOne type="submit" @click.prevent=onclick_step_one> "Next →"

tag mind-tooltip
	<self[d:inline-block fs:md]>
		<em[pl:2px] data-tooltip="You must memorize this information!"> "🧠"

tag help-tooltip
	prop title="Salt Field: Protect against duplicate or common passwords and defend against attacks that use precomputed tables."
	<self[d:inline-block fs:md]>
		<em[pl:3px c:gray5] data-placement="right" data-tooltip=title> "?"

