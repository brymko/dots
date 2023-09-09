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
    use 'williamboman/nvim-lsp-installer'
    use 'lvimuser/lsp-inlayhints.nvim'
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

require("telescope").setup {
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
vim.g.rustfmt_autosave = 1
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
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
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
            elseif has_words_before() then
                cmp.complete()
            else 
                fallback()
            end
        end, { "i"}),
        ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { "i"}), 
        ['<CR>'] = cmp.mapping.confirm({ select = true }), 
    },
}
 
require("nvim-lsp-installer").setup {}
local capabilities = require('cmp_nvim_lsp').default_capabilities() 
local servers = { 
    {'html', {}},
    {'bashls', {}}, 
    {'pyright', {}},
    {'purescriptls', {}},
    {'cssls', {}},
    {'tailwindcss', {}},
    {'svelte', {}},
    {'tsserver', {}},
    {'clangd', {}},
    {'clojure_lsp', {}},
    {'omnisharp', {}},
}


for _, lsp in pairs(servers) do
    require('lspconfig')[lsp[1]].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            [lsp[1]] = lsp[2],
        },
    }
end 

require'lspconfig'.rust_analyzer.setup{
    settings = {
        ['rust-analyzer'] = {
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
                    "unresolved-proc-macro",
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
        }
    }
}

require('lspconfig').gopls.setup{}

require("lspconfig").elmls.setup {
    on_attach = function(client) 
        if client.config.flags then
            client.config.flags.allow_incremental_sync = true
        end
    end,
    capabilities = capabilities,
    -- WTF??? doing 
    -- root_dir = root_pattern("elm.json") doesn't find the file
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

vim.cmd('highlight! LspInlayHint guibg=NONE guifg=#d8d8d8')
require("lsp-inlayhints").setup {
  inlay_hints = {
    parameter_hints = {
      show = true,
      prefix = "<- ",
      separator = ", ",
      remove_colon_start = false,
      remove_colon_end = true,
    },
    type_hints = {
      -- type and other hints
      show = true,
      prefix = "::",
      separator = ", ",
      remove_colon_start = false,
      remove_colon_end = true,
    },
    only_current_line = false,
    -- separator between types and parameter hints. Note that type hints are
    -- shown before parameter
    labels_separator = " ",
    -- whether to align to the length of the longest line in the file
    max_len_align = false,
    -- padding from the left if max_len_align is true
    max_len_align_padding = 1,
    -- highlight group
    highlight = "LspInlayHint",
  },
  enabled_at_startup = true,
  debug_mode = false,
}

vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspAttach_inlayhints",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require("lsp-inlayhints").on_attach(client, bufnr)
  end,
})

