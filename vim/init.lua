-- require("plugins")
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.api.nvim_command 'packadd packer.nvim'
end 
 
vim.cmd [[packadd packer.nvim]]
vim.cmd 'autocmd BufWritePost init.lua PackerCompile' -- Auto compile when there are changes in plugins.lua 

require("packer").startup(function()
    use { 'wbthomason/packer.nvim' }
    use { "ap/vim-buftabline" }
    use { "tpope/vim-commentary" }
    use { "tpope/vim-surround" }
    use { "tpope/vim-endwise" }
    use { "rstacruz/vim-closer" }
    use { "tpope/vim-repeat" }
    use { "rust-lang/rust.vim" }
    use { "junegunn/fzf.vim" }
    use { "iamcco/markdown-preview.nvim", run = "cd app && yarn install" }
    -- use { "neovim/nvim-lspconfig" }
    -- use { "nvim-lua/completion-nvim" }
    use { 'neoclide/coc.nvim' } 
end)

-- lspstuff, maybe once more matue
-- require("lspstuff")
-- local nvim_lsp = require('lspconfig')
-- local on_attach = function(client, bufnr)
--     require('completion').on_attach(client)

--     local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--     local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

--     -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

--     -- Mappings
--     local opts = { noremap=true, silent=true }
--     buf_set_keymap('n', ']g', '<cmd> lua vim.lsp.diagnostic.goto_next()<CR>', opts)
--     buf_set_keymap('n', '[g', '<cmd> lua vim.lsp.diagnostic.goto_next()<CR>', opts)
--     buf_set_keymap('n', 'gd', '<cmd> lua vim.lsp.buf.definition()<CR>', opts)
--     buf_set_keymap('n', 'gr', '<cmd> lua vim.lsp.buf.references()<CR>', opts)
--     buf_set_keymap('n', 'ga', '<cmd> lua vim.lsp.buf.code_action()<CR>', opts)
--     buf_set_keymap('n', '<space>rn', '<cmd> lua vim.lsp.buf.rename()<CR>', opts)

--     -- highlight all occurance of symbol in the file
--     -- if client.resolved_capabilities.document_highlight then
--     --     vim.api.nvim_exec([[
--     --     hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
--     --     hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
--     --     hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
--     --     augroup lsp_document_highlight
--     --         autocmd! * <buffer>
--     --         autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
--     --     autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
--     --     augroup END
--     --     ]], false)
--     -- end 

-- end

-- vim.cmd("nnoremap <Leader>h :lua require'lsp_extensions'.inlay_hints()")
-- nvim_lsp.rust_analyzer.setup({
--     on_attach = on_attach,
--     settings = {
--         ["rust-analyzer"] = {
--             checkOnSave = {
--                 command = "clippy"
--             },
--             cargo = {
--                 loadOutDirsFromCheck = true
--             },
--             procMacro = {
--                 enable = true
--             },
--         }
--     }
-- })

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--     vim.lsp.diagnostic.on_publish_diagnostics, {
--         virtual_text = true,
--         signs = true,
--         update_in_insert = false,
--         underline = false,
--     }
-- ) 
