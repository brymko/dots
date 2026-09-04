-- packer.nvim
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    
    -- typing
    use { "tpope/vim-commentary" }
    use { "tpope/vim-surround" }
    use { "tpope/vim-repeat" }
    use { "windwp/nvim-autopairs" }
    use { "windwp/nvim-ts-autotag" }

    -- fzf
    use { "junegunn/fzf", run = ":call fzf#install()" }
    use { "junegunn/fzf.vim" }

    -- markdown
    use { "iamcco/markdown-preview.nvim", run = "cd app && yarn install" }

    -- ui
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

    -- language
    use 'nvim-treesitter/nvim-treesitter'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use { 'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
        }
    } 
    use 'L3MON4D3/LuaSnip'
    use 'onsails/lspkind-nvim'
    use "elzr/vim-json"
    use 'github/copilot.vim'

    use "rust-lang/rust.vim" -- autosave + syntax

    -- file telescope
    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }

end) 

local fb_actions = require "telescope._extensions.file_browser.actions"


-- Telescope

require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["jk"] = require("telescope.actions").close,
      },
    },
  },
  extensions = {
    file_browser = {
      cwd_to_path = false,
      grouped = true,
      files = true,
      add_dirs = true,
      depth = 3,
      auto_depth = true,
      select_buffer = false,
      hidden = { file_browser = false, folder_browser = false },
      hide_parent_dir = true,
      collapse_dirs = false,
      prompt_path = false,
      quiet = false,
      dir_icon = "",
      dir_icon_hl = "Default",
      display_stat = { date = true, size = true, mode = true },
      hijack_netrw = false,
      use_fd = true,
      git_status = true,
      mappings = {
        ["i"] = {
          ["<A-c>"] = fb_actions.create,
          ["<S-CR>"] = fb_actions.create_from_prompt,
          ["<A-r>"] = fb_actions.rename,
          ["<A-m>"] = fb_actions.move,
          ["<A-y>"] = fb_actions.copy,
          ["<A-d>"] = fb_actions.remove,
          ["<C-o>"] = fb_actions.open,
          ["<C-g>"] = fb_actions.goto_parent_dir,
          ["<C-e>"] = fb_actions.goto_home_dir,
          ["<C-w>"] = fb_actions.goto_cwd,
          ["<C-t>"] = fb_actions.change_cwd,
          ["<C-f>"] = fb_actions.toggle_browser,
          ["<C-h>"] = fb_actions.toggle_hidden,
          ["<C-s>"] = fb_actions.toggle_all,
          ["jk"] = require("telescope.actions").close,
          ["<bs>"] = function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<bs>", true, false, true), "tn", false)
          end,
        },
        ["n"] = {
          ["c"] = fb_actions.create,
          ["r"] = fb_actions.rename,
          ["m"] = fb_actions.move,
          ["y"] = fb_actions.copy,
          ["d"] = fb_actions.remove,
          ["o"] = fb_actions.open,
          ["g"] = fb_actions.goto_parent_dir,
          ["e"] = fb_actions.goto_home_dir,
          ["w"] = fb_actions.goto_cwd,
          ["t"] = fb_actions.change_cwd,
          ["f"] = fb_actions.toggle_browser,
          ["h"] = fb_actions.toggle_hidden,
          ["s"] = fb_actions.toggle_all,
        },
      },
    },
  },
}

require('telescope').load_extension('file_browser')

-- misc config
vim.g.rustfmt_autosave = 0
vim.g.fzf_buffers_jump = 1

require("nvim-autopairs").setup({
    map_c_w = true,
})

require('nvim-ts-autotag').setup({
    filetypes = {
        'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
        'xml',
        'php',
        'markdown',
        'glimmer','handlebars','hbs',
        'rs',
    } 
})


-- require "nvim-treesitter.configs".setup {
--   highlight = {
--     enable = true, -- false will disable the whole extension
--     disable = { "md" }, -- list of language that will be disabled
--   },
-- }

-- theme
vim.g.sonokai_style = "atlantis"
vim.g.sonokai_enable_italic = false
vim.g.sonokai_disable_italic_comment = true
vim.cmd("colorscheme sonokai")
vim.cmd("hi SpecialComment ctermfg=224 guifg=Orange")
vim.cmd("hi Normal       guibg=#07090c")
vim.cmd("hi NormalNC     guibg=#07090c")
vim.cmd("hi SignColumn   guibg=#07090c")
vim.cmd("hi EndOfBuffer  guibg=#07090c")
vim.cmd("hi CursorLine   guibg=#10141a")
vim.cmd("hi CursorColumn guibg=#10141a")
vim.cmd("hi Visual       guibg=#1f2630")

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
local lspkind = require('lspkind')
local luasnip = require('luasnip')

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end 

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(), 
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
    sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'nvim_lua', priority = 800 },  -- For Neovim Lua API
        { name = 'luasnip', priority = 750 },   -- For snippets
        { name = 'path', priority = 500 },      -- For file paths
        { name = 'buffer', priority = 250, keyword_length = 3 },
    }),
    sorting = {
        priority_weight = 2.0,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            function(...) return cmp_buffer:compare_locality(...) end,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        }
    },
    matching = {
        disallow_fuzzy_matching = false,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = false,
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
            before = function(entry, vim_item)
                -- Show source name in menu
                vim_item.menu = string.format('[%s]', entry.source.name)
                return vim_item
            end
        })
    },
    mapping = {
        ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif has_words_before() then
                cmp.complete()
            else 
                fallback()
            end
        end, { "i", "s" }),
        ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<CR>'] = cmp.mapping.confirm({ 
            select = true,
            behavior = cmp.ConfirmBehavior.Replace 
        }),
        ['<C-e>'] = cmp.mapping.abort(),
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
}


require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "html",
        "bashls",
        "basedpyright",
        "ruff",
        "purescriptls",
        "cssls",
        "tailwindcss",
        "svelte",
        "ts_ls",
        "clangd",
        "clojure_lsp",
        "omnisharp",
        "eslint",
    },
})

-- Global LSP config for all servers (capabilities from cmp)
vim.lsp.config['*'] = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

-- Enable inlay hints on LSP attach
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
    end,
})

-- Simple servers with default config
local servers = {
    'html',
    'bashls',
    'purescriptls',
    'cssls',
    'tailwindcss',
    'svelte',
    'ts_ls',
    'clangd',
    'clojure_lsp',
    'omnisharp',
    'eslint',
    'gopls',
}

vim.lsp.enable(servers)

-- Python: basedpyright (type checking + intellisense) + ruff (linting + formatting)
vim.lsp.config.basedpyright = {
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
            },
        },
    },
}
vim.lsp.enable('basedpyright')

vim.lsp.config.ruff = {
    on_attach = function(client, bufnr)
        -- Disable hover in favor of basedpyright
        client.server_capabilities.hoverProvider = false
    end,
}
vim.lsp.enable('ruff')

-- rust-analyzer with custom settings
vim.lsp.config.rust_analyzer = {
    root_markers = { 'Cargo.toml', 'rust-project.json' },
    cmd = { vim.fn.expand("~/.cargo/bin/rust-analyzer") },
    settings = {
        ['rust-analyzer'] = {
            procMacro = {
                enable = true,
            },
            checkOnSave = true,
            diagnostics = {
                experimental = {
                    enable = true,
                },
                disabled = {
                    "unresolved-proc-macro",
                },
            },
            cargo = {
                -- features = "all",
            },
            lru = {
                capacity = 256
            },
        }
    }
}
vim.lsp.enable('rust_analyzer')

-- elmls with custom settings
vim.lsp.config.elmls = {
    root_markers = { 'elm.json' },
    init_options = {
        elmAnalysisTrigger = "save",
        disableElmLSDiagnostics = true,
        onlyUpdateDiagnosticsOnSave = true,
        elmReviewDiagnostics = "on",
    },
}
vim.lsp.enable('elmls')

-- Inlay hints highlight (used by native vim.lsp.inlay_hint)
vim.cmd('highlight! LspInlayHint guibg=NONE guifg=#909090')

