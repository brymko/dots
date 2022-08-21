-- packer.nvim
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    -- typing
    use { "tpope/vim-commentary" }
    use { "tpope/vim-surround" }
    use { "windwp/nvim-autopairs" }
    use { "tpope/vim-repeat" }

    -- fzf
    use { "junegunn/fzf.vim" }

    -- markdown
    use { "iamcco/markdown-preview.nvim", run = "cd app && yarn install" }

    -- starup time optimise
    use 'dstein64/vim-startuptime'
    use 'lewis6991/impatient.nvim'
    use 'nathom/filetype.nvim'

    -- ui
    use {'RRethy/vim-hexokinase', run = "make hexokinase" }
    use 'lukas-reineke/indent-blankline.nvim' 
    use {
        'nvim-lualine/lualine.nvim',
        requires = 'kyazdani42/nvim-web-devicons'
    }

    -- buffer
    use {
        'akinsho/bufferline.nvim',
        requires = 'kyazdani42/nvim-web-devicons'
    }
    use 'moll/vim-bbye' -- for more sensible delete buffer cmd

    -- themes (disabled other themes to optimize startup time)
    use 'sainnhe/sonokai'
    -- use 'folke/tokyonight.nvim'
    -- use 'joshdick/onedark.vim'

    -- language
    use 'williamboman/nvim-lsp-installer'
    use 'neovim/nvim-lspconfig'
    use { 'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
        }
    } 
    use 'purescript-contrib/purescript-vim'
    use 'L3MON4D3/LuaSnip'
    use 'onsails/lspkind-nvim'
    use { "elzr/vim-json" }

    use "rust-lang/rust.vim" -- autosave + syntax

    -- file telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = 'nvim-lua/plenary.nvim'
    }

end) 

-- misc config
vim.g.rustfmt_autosave = 1
vim.g.fzf_buffers_jump = 1

require("nvim-autopairs").setup({
    map_c_w = true,
})


-- theme
vim.g.sonokai_style = "atlantis"
vim.g.sonokai_enable_italic = false
vim.g.sonokai_disable_italic_comment = true
vim.cmd("colorscheme sonokai")
vim.cmd("hi SpecialComment ctermfg=224 guifg=Orange")

-- statusline 
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto', -- based on current vim colorscheme
        -- not a big fan of fancy triangle separators
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {},
        show_filename_only = false,
        always_divide_middle = true,
    },
    sections = {
        -- left
        lualine_a = {'mode'},
        lualine_b = {'filetype', 'encoding', 'fileformat'},
        lualine_c = {},
        -- right
        lualine_x = {'branch', 'diff'},
        lualine_y = {'%f%m'}, -- filename, 'filename' component only has the name, not the wole path
        lualine_z = {'progress', 'location'},
    },
    inactive_sections = {
        lualine_a = {'filename'},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
} 

-- bufferline 
require('bufferline').setup {
    options = {
        mode = "buffers",
        numbers = "ordinal",
        close_command = 'bdelete! %d',
        show_close_icon = false,
        diagnostic = false,
        color_icons = true,
    },
    highlights = {
        buffer_selected = {
            italic = false,
        },
        numbers_selected = {
            italic = false,
        },
        diagnostic_selected = {
            italic = false,
        },
        info_selected = {
            italic = false,
        },
        info_diagnostic_selected = {
            italic = false,
        },
        warning_selected = {
            italic = false,
        },
        warning_diagnostic_selected = {
            italic = false,
        },
        error_selected = {
            italic = false,
        },
        error_diagnostic_selected = {
            italic = false,
        },
        duplicate_selected = {
            italic = false,
        },
        duplicate_visible = {
            italic = false,
        },
        duplicate = {
            italic = false,
        },
        pick_selected = {
            italic = false,
        },
        pick_visible = {
            italic = false,
        },
        pick = {
            italic = false,
        }
    }
}

-- lspkind
local lspkind = require('lspkind')
lspkind.init({
    -- DEPRECATED (use mode instead): enables text annotations
    --
    -- default: true
    -- with_text = true,

    -- defines how annotations are shown
    -- default: symbol
    -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
    mode = 'symbol_text',

    -- default symbol map
    -- can be either 'default' (requires nerd-fonts font) or
    -- 'codicons' for codicon preset (requires vscode-codicons font)
    --
    -- default: 'default'
    preset = 'codicons',

    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
        Text = '  ',
        Method = '  ',
        Function = '  ',
        Constructor = '  ',
        Field = '  ',
        Variable = '  ',
        Class = '  ',
        Interface = '  ',
        Module = '  ',
        Property = '  ',
        Unit = '  ',
        Value = '  ',
        Enum = '  ',
        Keyword = '  ',
        Snippet = '  ',
        Color = '  ',
        File = '  ',
        Reference = '  ',
        Folder = '  ',
        EnumMember = '  ',
        Constant = '  ',
        Struct = '  ',
        Event = '  ',
        Operator = '  ',
        TypeParameter = '  ', 
    },
}) 

-- " gray
vim.cmd('highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080')
-- " blue
vim.cmd('highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6')
vim.cmd('highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6')
-- " light blue
vim.cmd('highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE')
vim.cmd('highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE')
vim.cmd('highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE')
-- " pink
vim.cmd('highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0')
vim.cmd('highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0')
-- " front
vim.cmd('highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4')
vim.cmd('highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4')
vim.cmd('highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4 ')



-- LSP/CMP
local cmp = require('cmp')
local cmp_buffer = require('cmp_buffer')
local luasnip = require('luasnip')

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end 

cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(), 
    sources = cmp.config.sources({
        {name = "buffer" }
    })
})

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    }, 
    sources = {
        { name = "buffer" },
        { name = "nvim_lsp" },
    },
    sorting = {
        comparators = {
          function(...) return cmp_buffer:compare_locality(...) end,
          -- The rest of your comparators...
        }
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            before = function(_, vim_item)
                return vim_item
            end 
        })
    },
    mapping = {
        ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else 
                fallback()
            end
        end, { "i", "s", "c" }),
        ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s", "c" }), 
        ["<Tab>"] = cmp.mapping(function(fallback)
            -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item()
                else
                    cmp.confirm()
                end
            else
                fallback()
            end
        end, {"i","s","c",}), 
        ['<CR>'] = cmp.mapping.confirm({ select = true }), 
    },
}
 
require("nvim-lsp-installer").setup {}
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()) 
local servers = { 
    {'html', {}},
    {'rust_analyzer', {
        procMarco = {
            enable = true,
        },
        checkOnSave = {
            command = "clippy",
        },
        diagnostics = {
            experimental = {
                enable = true,
            },
            disabled = {
                "inactive-code",
            },
        },
        cargo = {
            features = "all",
        },
        lru = {
            capacity = 256
        },
        updates = {
        },
    }},
    {'bashls', {}}, 
    {'pyright', {}},
    {'purescriptls', {}},
    -- {'emmet_ls', {}},
    {'cssls', {}},
    {'csharp_ls', {}},
    {'gopls', {}}
}

require('lspconfig').rust_analyzer.setup{}

for _, lsp in pairs(servers) do
    require('lspconfig')[lsp[1]].setup {
        on_attach = on_attach,
        settings = {
            [lsp[1]] = lsp[2],
        },
        capabilities = capabilities,
    }
end 

require("lspconfig").elmls.setup {
    on_attach = function(client) 
        if client.config.flags then
            client.config.flags.allow_incremental_sync = true
        end
    end,
    capabilities = capabilities,
    -- WTF??? doing 
    -- root_dir = root_pattern("elm.json") doesn't the the file
    -- doing this it does
    -- ???????????????????????????????
    root_dir = function(fname) 
        return require('lspconfig').util.root_pattern("elm.json")(fname)
    end,
    init_options = {
        elmAnalysisTrigger = "save",
        disableElmLSDiagnostics = true,
        onlyUpdateDiagnosticsOnSave = true,
        elmReviewDiagnostics = "on",
    },

}

---- nvim-dap configurations 
--local dap = require("dap")

---- TODO(brymko): this isn't ideal, gotta read some more docs
--vim.api.nvim_set_keymap("n", "<Space>b", ":lua require'dap'.toggle_breakpoint()<CR>", {expr = false; noremap = true})
--vim.api.nvim_set_keymap("n", "<Space>d", ":lua start_debugger()<CR>", {expr = false; noremap = true})
--vim.api.nvim_set_keymap("n", "<Space>c", ":lua require'dap'.continue()<CR>", {expr = false; noremap = true})
---- vim.api.nvim_set_keymap("n", "<M-i>", ":lua require'dap'.step_into()<CR>", {expr = false; noremap = true})
---- vim.api.nvim_set_keymap("n", "<M-n>", ":lua require'dap'.step_over()<CR>", {expr = false; noremap = true})
--vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})

--function start_debugger() 
--    local dap = require("dap")
--    dap.continue()
--end

--dap.adapters.python = {
--    type = "executable";
--    command = os.getenv("HOME") .. "/.local/share/vimdbg/bin/python";
--    args = { "-m", "debugpy.adapter" };
--} 

--dap.configurations.python = {
--    {
--        type = 'python';
--        request = 'launch';
--        name = "Launch file";
--        program = "${file}";
--        -- i might want ot set `justMyCode` to `false` somewhere here to debug all code ?
--        -- use venv if in found
--        pythonPath = function()
--            local cwd = vim.fn.getcwd()
--            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
--                return cwd .. '/venv/bin/python'
--            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
--                return cwd .. '/.venv/bin/python'
--            else 
--                return '/usr/bin/python'
--            end
--        end;
--    },
--}

--dap.adapters.lldb = {
--    type = "executable",
--    command = "/usr/bin/lldb-vscode",
--    name = "lldb"
--}

--dap.configurations.rust = {
--    {
--        name = "Launch",
--        type = "lldb",
--        request = "launch",
--        program = function()
--            function split(source, delimiters)
--                local elements = {}
--                local pattern = '([^'..delimiters..']+)'
--                string.gsub(source, pattern, function(value) elements[#elements + 1] = value; end);
--                return elements
--            end 
--            vim.api.nvim_command("!cargo build")
--            local cwd = vim.fn.getcwd()
--            local proj = split(cwd, "/")
--            proj = proj[#proj]
--            -- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
--            return cwd .. "/target/debug/" .. proj
--        end,
--        cwd = '${workspaceFolder}',
--        stopOnEntry = false,
--        args = {},

--        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
--        --
--        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
--        --
--        -- Otherwise you might get the following error:
--        --
--        --    Error on launch: Failed to attach to the target process
--        --
--        -- But you should be aware of the implications:
--        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
--        runInTerminal = false,
--    }, 
--}
 
--require("dapui").setup({
--    icons = {
--        expanded = "⯆",
--        collapsed = "⯈"
--    },
--    mappings = {
--        expand = "<CR>",
--        open = "o",
--        remove = "d",
--        edit = "e",
--    },
--    sidebar = {
--        open_on_start = true,
--        elements = {
--            "watches",
--            "scopes",
--            "stacks",
--        },
--        width = 30,
--        position = "left"
--    },
--    tray = {
--        open_on_start = true,
--        elemnts = {
--            "repl",
--        },
--        height = 5,
--        position = "top",
--        auto_insert = true
--    },
--})

