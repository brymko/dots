-- core 
vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')
vim.opt.number          = true
vim.opt.relativenumber  = false
vim.opt.termguicolors   = true
vim.opt.shiftround      = true
vim.opt.updatetime      = 100
vim.opt.cursorline      = true
vim.opt.splitright      = true
vim.opt.splitbelow      = true
vim.cmd("set diffopt=filler,vertical")
vim.cmd("set background=dark")
vim.opt.hidden          = true
vim.opt.scrolloff       = 5
vim.opt.sidescroll      = 5
vim.opt.showmatch       = true
vim.opt.formatoptions   = "crjql"
vim.opt.wrap            = false

-- tabs
vim.opt.autoindent      = true
vim.opt.tabstop         = 4
vim.opt.shiftwidth      = 4
vim.opt.softtabstop     = 4
vim.opt.expandtab       = true
vim.opt.smarttab        = true
vim.opt.linebreak       = true
vim.opt.breakindent     = true

-- searching 
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.viewoptions = "folds,cursor"
vim.opt.foldmethod = "manual"
vim.opt.foldlevel = 99

vim.opt.backupdir=os.getenv("HOME").."/.config/nvim/.backup//"
vim.opt.directory=os.getenv("HOME").."/.config/nvim/.swap//"
vim.opt.undodir=os.getenv("HOME").."/.config/nvim/.undo//"
vim.opt.viewdir=os.getenv("HOME").."/.config/nvim/.views//"

-- disable some useless standard plugins to save startup time
-- these features have been better covered by plugins
vim.g.loaded_matchit           = 1
vim.g.loaded_logiPat           = 1
vim.g.loaded_rrhelper          = 1
vim.g.loaded_tarPlugin         = 1
vim.g.loaded_gzip              = 1
vim.g.loaded_zipPlugin         = 1
vim.g.loaded_2html_plugin      = 1
vim.g.loaded_shada_plugin      = 1
vim.g.loaded_spellfile_plugin  = 1
vim.g.loaded_netrw             = 1
vim.g.loaded_netrwPlugin       = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_remote_plugins    = 1 

local show_lsp_message = vim.lsp.handlers["window/showMessage"]
vim.lsp.handlers["window/showMessage"] = function(err, result, context, config)
    local client = context and vim.lsp.get_client_by_id(context.client_id)
    local message = result and result.message
    if client
        and client.name == "rust_analyzer"
        and type(message) == "string"
        and message:find("overly long loop turn took", 1, true)
        and message:find("PrimeCaches(", 1, true)
    then
        return
    end
    return show_lsp_message(err, result, context, config)
end

require("plugins")
require("omp").setup()
require("keymaps")

require("bug-report.bug-report").setup()
vim.keymap.set("n", "<leader>br", "<cmd>BugReport<cr>", { desc = "Generate bug report" })
vim.keymap.set("x", "<leader>br", ":<C-U>BugReport<cr>", { desc = "Generate bug report from selection" })

