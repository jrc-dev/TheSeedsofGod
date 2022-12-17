import './form/form-salt'
import './form/form-pattern'
import './form/form-seed'

tag mnemonic-generator

	page = {
		new: yes
		recover: no
		revalidating: no
		title: do
			let currPage = Object.keys(page).find(do(key) page[key] === yes)
			titles[currPage]
	}

	titles = {
		new: "Generate Mnemonic"
		recover: "Recover Mnemonic"
		revalidating: "Validating Mnemonic"
	}

	def routed params, state
		this.page.new = params.path.includes("new")
		this.page.recover = params.path.includes("recover")
		this.page.revalidating = params.path.includes("revalidating")

	<self>		
		<article>
			<h5> page.title!
			<div[w:98% pb:30px]>
				<div.step-wrapper>
					<div.step .active=(appState.step == 'one')>
						<span> "Salt Fields"
					<div.step .active=(appState.step == 'two')>
						<span> "Memorable Pattern"
					<div.step .active=(appState.step == 'three')>
						<span> "Mnemonic Words"

			<form-salt> if appState.step == 'one'

			<form-pattern> if appState.step == 'two'

			<form-seed> if appState.step == 'three'
