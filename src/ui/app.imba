import './styles/styles'

import './pages/home'
import './pages/generator'
import './pages/faq'
import './pages/derive'

tag app

	def redefine_store
		window.location.reload! if appState.initialized

	<self.container>
		<header[d:flex jc:center]>
			<img.wing width=45 height=35 src='./styles/imba.svg'>
			<nav[d@lg:inline-flex ai:center p:1rem ta:center width@lg:680px ]>
				<a route-to="/"> "Home"
				<a route-to='/generator' @click=redefine_store> "Generator"
				<a route-to='/derive'> "Derive"
				<a route-to='/faq'> "Faq"

		<main[max-width:1280px width:80% m:0 auto]>
			<home route="/">
			<home route="/home">
			<generator route="/generator">
			<derive route="/derive">
			<faq route="/faq">

		<footer[p:2rem ta:center]>
			css p c:warm1 ws:pre
			css a td:none
			<p>
				'Check out our code at '
				<a href='https://github.com/jrc-dev/TheSeedsofGod' target='_blank'> 'Github.com'
				'.'
			<p>
				'Read out documentation here '
				<a href='/faq' >
					'documentation'
				'.'
