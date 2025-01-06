return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
		local telescope = require("telescope")
    telescope.load_extension("fzf")
		local builtin = require('telescope.builtin')
    local keymap = vim.keymap 

		keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
		keymap.set('n', '<leader>fs', builtin.live_grep, { desc = 'Telescope live grep' })
		keymap.set('n', '<leader>fc', builtin.grep_string, { desc = 'Telescope string search' })
		keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
  end,
}

