local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

  if not vim.loop.fs_stat(pckr_path) then
    vim.fn.system({
      'git',
      'clone',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })
  end

  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require('pckr').add{
  'nvim-treesitter/nvim-treesitter';
  'folke/tokyonight.nvim';
  'ray-x/go.nvim';
  'neovim/nvim-lspconfig';
  'ray-x/starry.nvim';
  'svermeulen/vimpeccable';
  'acro5piano/nvim-format-buffer';
}

local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)
vim.o.mouse = ""

require('starry').setup()
vim.cmd[[colorscheme mariana]] -- tokyonight moonlight

--require('starry').setup({style={name=moonlight}, disable={background=true}})
--require('starry.functions').toggle_style()

--require'lspconfig'.ruff_lsp.setup{}

vim.g.mapleader = " "
require('vimp').nnoremap('<leader>N', function()
    if not vim.opt.number:get() then
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.signcolumn = "number"
    else
      vim.opt.number = false
      vim.opt.relativenumber = false
      vim.opt.signcolumn = "auto"
    end
end)

--require("nvim-format-buffer").setup({
--  verbose = true,
--  format_rules = {
--    { pattern = { "*.go" }, command = "gofmt" }
--  }
--})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.go" },
  callback = function()
    require("nvim-format-buffer").format_whole_file("gofmt")
    print("Formatted!")
  end,
})

-- To do GoFmt on Go file save
--local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
--vim.api.nvim_create_autocmd("BufWritePre", {
--  pattern = "*.go",
--  callback = function()
--    require('go.format').goimports()
--  end,
--  group = format_sync_grp,
--})
--local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
--vim.api.nvim_create_autocmd("BufWritePre", {
--  pattern = "*.go",
--  callback = function()
--   require('go.format').goimports()
--  end,
--  group = format_sync_grp,
--})
