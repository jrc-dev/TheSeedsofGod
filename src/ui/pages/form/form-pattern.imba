tag form-pattern

	alphabet = 'abcdefghijklmnopqrstuvwxyz'
	drawing = no
	deleting = no
	selectedCells = new Set!

	def mount
		window.scrollTo(0,0)

	def select_cell elem, cell
		if deleting
			return
		unless elem.classList.contains('selected')
			elem.classList.add('selected') 
			selectedCells.add(JSON.stringify(cell))

	def clear_all
		selectedCells.clear!
		const grid = document.querySelectorAll('div')
		for cell in grid
			cell.classList.remove('selected')

	def clear_cell elem, cell
		selectedCells.delete(JSON.stringify(cell))
		elem.classList.remove('selected')

	# cells_sorted = [{col0,row0},{col4,row3}...] 
	def sort_cells aa,bb
		let a = JSON.parse(aa)
		let b = JSON.parse(bb)
		if a.col !== b.col
			a.col - b.col
		else 
			a.row - b.row
	
	def ctrl_down
		deleting = yes
		$excel.style.cursor='crosshair' if $excel.style.cursor != 'crosshair'

	def ctrl_up
		deleting = no
		$excel.style.cursor='grab' if $excel.style.cursor != 'grab'

	def onclick_step_two e
		e.preventDefault!
		if !$formPattern.checkValidity!
			$formPattern.reportValidity!
			return false

		$btnStepTwo.textContent = "Please wait..."
		$btnStepTwo.setAttribute('aria-busy', yes)

		let orderedCells = Array.from(selectedCells).sort(sort_cells)
		appState.wallet.selectedCells = orderedCells.map(do(a) JSON.parse(a))
		appState.wallet.pepper = appState.wallet.selectedCells.slice(0,3).reduce(pepper,'')
		appState.step = 'three'
		clear_all!

	###
	Pepper is a secret added to password during hashing 
	The first three selected positions on your selected Pattern Grid are your pepper
	Ex: c0l0c0l1c0l2
	###
	def pepper a,b
		a + "c{b.col}l{b.row}"

	css .grid
		d:grid gtc:repeat(16, 1fr) grid-gap:0px 
		bgc:white us:none gc:2
	css .row 
		d:grid
	css .cell
		bgc:white ta:center p:10px bd:1px solid #ccc c:black
		transition: background-color 0.2s ease-in
		@active bgc:amber4 cursor:grabbing
	css .headercell
		ta:center bd:1px solid #ddd
		fw:bold fs:13px bgc:warmer2 c:gray8
		bdb:1px solid #27272a
	css .excel 
		d:grid gtc: 5% 86% jac:center cursor:grab
	css .gridnumbers
		d:grid gc:1 gtr:repeat(128, 1fr) grid-gap:0.5px 
		bgc:white us:none fs:14px mt:22px
	css .selected 
		bgc:amber4
	css .gridletters
		d:grid gc:2 gtc:repeat(16, 1fr) grid-gap:0.5px 
		bgc:white us:none fs:12px

	<self>
		<div[fs:20px c:white pb:10px]> "Pattern Grid"
		<div[fs:md c:gray5 pb:10px]> "Apply a memorable pattern or set of your preferred cell coordinates."

		# Teleports https://imba.io/docs/components/teleports
		<global	
			@keyup.key(17)=ctrl_up
			@keydown.prevent.key(17)=ctrl_down>

		<form$formPattern>
			<fieldset[d:grid]>
				<div$excel.excel
					@mouseleave.left=(drawing=no)
					@mouseup.left=(drawing=no)>
					<div.gridnumbers>
						for x in [1 .. 128]
							<div.headercell> x
					<div.grid>
						for col in [0 ... 16]
							<div.row> 
								<span.headercell> alphabet.charAt(col).toUpperCase!
								for row in [0 ... 128]
									<div.cell 
										@mousedown.left=(drawing=yes)
										@mousemove.if(drawing and !deleting).throttle(10ms)=select_cell(this,{col,row})
										@mousemove.ctrl.if(deleting).throttle(10ms)=clear_cell(this,{col,row})
										@click.ctrl.left=clear_cell(this,{col,row})
										@click.left=select_cell(this,{col,row})>
					<div.gridletters>
						for x in [0 ... 16]
							<div.headercell> alphabet.charAt(x).toUpperCase!
				
				<div[d:flex jc:space-between pt:5px]>
					<small[fs:14px c:amber4 pl:78px]> "Press Ctrl to erase cells."
					<a[ta:right pr:40px] @click=clear_all> "Clear all({selectedCells.size})"

				<label for="cpu">
					<input type="checkbox" id="cpu" name="cpu" required>
					<span[fs:md]>
						"Use my computer's processing power and memory to create a strong hash version of my data."

			<button$btnStepTwo type="submit" @click.prevent=onclick_step_two> "Next →"
