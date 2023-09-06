vim.g.mapleader = ' '


local function nmap(key, cmd)
    vim.api.nvim_set_keymap('n', key, cmd, {noremap=true, silent = true})
end

local function imap(key, cmd)
    vim.api.nvim_set_keymap('i', key, cmd, {noremap=true, silent = true})
end

local function cmap(key, cmd)
    vim.api.nvim_set_keymap('c', key, cmd, {noremap=true, silent = true})
end

local function vmap(key, cmd)
    vim.api.nvim_set_keymap('v', key, cmd, {noremap=true, silent = true})
end

local function maplua(key, txt)
    vim.api.nvim_set_keymap('n', key, ':lua '..txt..'<cr>', {noremap=true, silent = true})
end

-- misc
nmap('<leader>q', ':qa!<CR>')
nmap('<leader>u', ':nohl<CR>')
nmap('<leader>ev', ':vsp $MYVIMRC<CR>')
nmap('<leader>l', ':setlocal list!<CR>')
nmap('<leader>r', ':call RunFile()<CR>')
cmap('sudow', 'w !sudo tee % > /dev/null')
nmap('\\', ':Rg<CR>')
nmap('<leader>8', ':%!xxd -g 1<CR>')
nmap('<leader>9', ':%!xxd -g 1 -r<CR>')

-- movement
imap('jk', '<esc>')
vim.api.nvim_set_keymap("t", "jk", "<C-\\><C-n>", {noremap=true, silent=true})
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", {noremap=true, silent=true})
nmap('j', 'gj')
nmap('k', 'gk')
nmap('w', "W")
nmap('b', "B")

-- window
nmap('<C-h>', '<C-w>h')
nmap('<C-j>', '<C-w>j')
nmap('<C-k>', '<C-w>k')
nmap('<C-l>', '<C-w>l')

imap('<C-h>', '<ESC><C-w>h')
imap('<C-j>', '<ESC><C-w>j')
imap('<C-k>', '<ESC><C-w>k')
imap('<C-l>', '<ESC><C-w>l')

-- these can't be done with mapcmd for some reason
vim.cmd('nnoremap <C-n> :BufferLineCycleNext<CR>')
vim.cmd('nnoremap <C-p> :BufferLineCyclePrev<CR>')
-- mapkey('n', '<C-n>', ':bn')
-- mapkey('n', '<C-p>', ':bp')

-- cmap('bd', 'Bdelete')
-- cmap('bw', 'Bwipeout')

-- visual 
vmap('<', '<gv')
vmap('>', '>gv')

-- copy paste
vmap('<C-c>', '"+y')
imap('<C-v>', '<C-o>"+P')

-- bufferline
nmap('<C-m>', ':BufferLineMoveNext<CR>')
nmap('<C-y>', ':BufferLineMovePrev<CR>')

-- telescope
nmap('<leader>f', ':Telescope file_browser<CR>')

-- LSP
maplua('gd', 'vim.lsp.buf.definition()')
maplua('ga', 'vim.lsp.buf.code_action()')
maplua('[g', 'vim.diagnostic.goto_prev()')
maplua(']g', 'vim.diagnostic.goto_next()')
maplua('gr', 'vim.lsp.buf.references()')
maplua('<leader>rn', 'vim.lsp.buf.rename()')
maplua('gw', 'vim.diagnostic.open_float()')
nmap('<leader>h', ':lua require("lsp-inlayhints").toggle()<CR>')

vim.cmd('set mouse=')

