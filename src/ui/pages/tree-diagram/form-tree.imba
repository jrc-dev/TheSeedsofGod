# import {NavigableSeedTree} from 'navigable-seed-tree'
import initialJson from './initial.imba'
import {draw} from './d3jsTree.js'

tag form-tree

	prop seed
	metadata_json = initialJson
	selectedNode = {}

	def build
		x = y = 0
		x1 = y1 = 0

	def mount
		draw(metadata_json)

	def handle_selected_node d
		selectedNode = d.target.__data__
		if selectedNode.parent
			selectedNode.background = "linear-gradient(to right, {selectedNode.color} 10%, {selectedNode.parent.color} 90%)";
		else
			selectedNode.background = "linear-gradient(to right, {selectedNode.color} 10%, {selectedNode.color} 90%)";
			selectedNode.key = "Master Seed"

	<self @onSelectedNode=handle_selected_node>

		<svg [x:{x} y:{y} cursor:grab] @touch.moved.sync(self) >
			<g class="weighted-tree">

		<article [x:{x1} y:{y1} bgc:white c:white] @touch.moved.sync(self)>
			<header [bg:{selectedNode.background} fw:bold]> selectedNode.key
			"Body"
			<footer> "Footer"
				
		
		# <NavigableSeedTree json=metadata_json>
		