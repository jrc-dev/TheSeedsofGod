const { defineConfig } = require('vitest/config');
import {imba} from 'vite-plugin-imba'

module.exports = defineConfig({
    plugins: [imba({ ssr: true })],
	resolve: {
		mainFields: ['require'],
        extensions: ['.cjs','.node.imba','.imba', '.imba1', '.mjs', '.js', '.ts', '.jsx', '.tsx', '.json']
	},
	test: {
		globals: true,
		watch: false,
		include: ["**/*.{test,spec}.{imba,js,mjs,cjs,ts,mts,cts,jsx,tsx}"],
	},
});
