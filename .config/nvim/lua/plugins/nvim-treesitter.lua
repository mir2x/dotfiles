return {
	"nvim-treesitter/nvim-treesitter",
	build = function()
		require("nvim-treesitter.install").update({ with_sync = true })()
	end,

	config = function () 
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "c", "cpp", "java", "python", "javascript", "typescript", "go", "lua", "html", "css", "vim", "vimdoc", "query" },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },  
		})
	end,
}
