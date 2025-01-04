vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap

keymap.set("n", "<leader>ee", vim.cmd.Ex)
keymap.set("n", "<leader>ch", ":nohl<CR>")

keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")
keymap.set("n", "<leader>sq", "<cmd>close<CR>")

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>") 
keymap.set("n", "<leader>tq", "<cmd>tabclose<CR>") 
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>") 
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>") 
