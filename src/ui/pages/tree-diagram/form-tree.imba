import address from '../../../wallet/address'
import initialJson from './initial.imba'
import {draw} from './d3jsTree.js'

tag drag-me
	css
		@touch scale:1.02  zi:2
		@move scale:1.05 rotate:2deg zi:2
		cursor:grab

	def build
		x = y = 0

	def render
		<self[x:{x} y:{y}] @touch.moved.sync(self)>
			<slot>

tag form-tree

	css .badge
		w:24px h:24px rd:2em ta:center ml:10px
		c:gray9 bgc:gray3 fs:sm lh:inherit

	css .button
		d:flex w:fit-content rd:md p:1 
		c:white bgc:gray8 bd:gray4 fs:md
		cursor:pointer

	prop seed
	metadata_json = initialJson
	selectedNode = {}

	def mount
		draw(metadata_json)

	def handle_selected_node d
		selectedNode = d.target.__data__
		if selectedNode.parent
			selectedNode.background = "linear-gradient(to right, {selectedNode.color} 10%, {selectedNode.parent.color} 90%)";
		else
			selectedNode.background = "linear-gradient(to right, {selectedNode.color} 10%, {selectedNode.color} 90%)";
			selectedNode.key = "Master Seed"
		derivePath(selectedNode)

	def derivePath(node)
		let path = "m/85'/0'/{node.depth}'/0/{node.iDepth}"
		# path = "m/44'/1237'/0'/0/0"
		address(seed,path)
		

	<self @onSelectedNode=handle_selected_node>

		<drag-me>
			<svg>
				<g class="weighted-tree">

		<article [bgc:black c:white]>
			<header [bg:{selectedNode.background} fw:bold mb:20px]> selectedNode.key
			
			<div [d:hcl]>
				<div.button>
					<svg fill=gray5 height="22px" width="30px">
						<path d="M17 16a2.99 2.99 0 00-2.816 2H11c-1.654 0-3-1.346-3-3v-3.025A4.954 4.954 0 0011 13h3.184A2.99 2.99 0 0017 15a3 3 0 100-6 2.99 2.99 0 00-2.816 2H11c-1.654 0-3-1.346-3-3v-.184A2.99 2.99 0 0010 5a3 3 0 10-6 0 2.99 2.99 0 002 2.816V15c0 2.757 2.243 5 5 5h3.184A2.99 2.99 0 0017 22a3 3 0 100-6zm0-5a1.001 1.001 0 11-1 1c0-.551.448-1 1-1zM7 4a1.001 1.001 0 11-1 1c0-.551.448-1 1-1zm10 16a1.001 1.001 0 010-2 1.001 1.001 0 010 2z" />
					" Childs "
					<span.badge>
						selectedNode.children.length if selectedNode.children
						selectedNode._children.length if selectedNode._children
						0 if not selectedNode.children and not selectedNode._children

				<div.button>
					<svg fill=gray5 height="22px" width="30px">
						<path d="M17 16a2.99 2.99 0 00-2.816 2H11c-1.654 0-3-1.346-3-3v-3.025A4.954 4.954 0 0011 13h3.184A2.99 2.99 0 0017 15a3 3 0 100-6 2.99 2.99 0 00-2.816 2H11c-1.654 0-3-1.346-3-3v-.184A2.99 2.99 0 0010 5a3 3 0 10-6 0 2.99 2.99 0 002 2.816V15c0 2.757 2.243 5 5 5h3.184A2.99 2.99 0 0017 22a3 3 0 100-6zm0-5a1.001 1.001 0 11-1 1c0-.551.448-1 1-1zM7 4a1.001 1.001 0 11-1 1c0-.551.448-1 1-1zm10 16a1.001 1.001 0 010-2 1.001 1.001 0 010 2z" />
					" Address "
					<span.badge>
						0

			<a href="#" role="button"> "Primary"
			
			<details>
				<summary> 
					<svg class="">
						<path d="M5 4a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v14l-5-2.5L5 18V4Z">
				"I'm hesitant to enter my email into the application!"
				<p> "Using email allows us to individualize(salt) your information during encryption, since in theory, only you easy remember it and use this information! Our encryption is much more than just email."
				<p> "Again: this is an open source, offline application and we do not share your data."
				<p> "Your email helps with encryption, but that's not all we rely on, emails are extremely weak to identification or as password, let's combine it with other stronger factors!"

			
			
				
		
		# <NavigableSeedTree json=metadata_json>
		