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
    use { 'yetone/avante.nvim', 
        requires = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        }
    }
    use({
        'MeanderingProgrammer/render-markdown.nvim',
        after = { 'nvim-treesitter' },
        -- requires = { 'echasnovski/mini.nvim', opt = true }, -- if you use the mini.nvim suite
        -- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
        config = function()
            require('render-markdown').setup({})
        end,
    })

    use "rust-lang/rust.vim" -- autosave + syntax

    -- file telescope
    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }

end) 

-- Avante 
require('avante_lib').load()
require('avante').setup ({
  ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  provider = "claude", -- Recommend using Claude
  auto_suggestions_provider = "copilot", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
  claude = {
    endpoint = "https://api.anthropic.com",
    model = "claude-3-5-sonnet-20241022",
    temperature = 0,
    max_tokens = 4096,
  },
  ---Specify the special dual_boost mode
  ---1. enabled: Whether to enable dual_boost mode. Default to false.
  ---2. first_provider: The first provider to generate response. Default to "openai".
  ---3. second_provider: The second provider to generate response. Default to "claude".
  ---4. prompt: The prompt to generate response based on the two reference outputs.
  ---5. timeout: Timeout in milliseconds. Default to 60000.
  ---How it works:
  --- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
  ---Note: This is an experimental feature and may not work as expected.
  dual_boost = {
    enabled = false,
    first_provider = "openai",
    second_provider = "claude",
    prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
    timeout = 60000, -- Timeout in milliseconds
  },
  behaviour = {
    auto_suggestions = true, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
    minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
  },
  mappings = {
    --- @class AvanteConflictMappings
    diff = {
      ours = "co",
      theirs = "ct",
      all_theirs = "ca",
      both = "cb",
      cursor = "cc",
      next = "]x",
      prev = "[x",
    },
    suggestion = {
      accept = "<M-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
    jump = {
      next = "]]",
      prev = "[[",
    },
    submit = {
      normal = "<CR>",
      insert = "<C-s>",
    },
    sidebar = {
      apply_all = "A",
      apply_cursor = "a",
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
    },
  },
  hints = { enabled = true },
  windows = {
    ---@type "right" | "left" | "top" | "bottom"
    position = "right", -- the position of the sidebar
    wrap = true, -- similar to vim.o.wrap
    width = 30, -- default % based on available width
    sidebar_header = {
      enabled = true, -- true, false to enable/disable the header
      align = "center", -- left, center, right for title
      rounded = true,
    },
    input = {
      prefix = "> ",
      height = 8, -- Height of the input window in vertical layout
    },
    edit = {
      border = "rounded",
      start_insert = true, -- Start insert mode when opening the edit window
    },
    ask = {
      floating = false, -- Open the 'AvanteAsk' prompt in a floating window
      start_insert = true, -- Start insert mode when opening the ask window
      border = "rounded",
      ---@type "ours" | "theirs"
      focus_on_apply = "ours", -- which diff to focus after applying
    },
  },
  highlights = {
    ---@type AvanteConflictHighlights
    diff = {
      current = "DiffText",
      incoming = "DiffAdd",
    },
  },
  --- @class AvanteConflictUserConfig
  diff = {
    autojump = true,
    ---@type string | fun(): any
    list_opener = "copen",
    --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
    --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
    --- Disable by setting to -1.
    override_timeoutlen = 500,
  },
})

local fb_actions = require "telescope._extensions.file_browser.actions"


-- Telescope

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

vim.disagnostic.config({
    virtual_lines=true,
})

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
    {'ts_ls'},
    {'clangd', {}},
    {'clojure_lsp', {}},
    {'omnisharp', {}},
    {'eslint', {}}
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
                -- features = "all",
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

