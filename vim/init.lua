-- require("plugins")

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.api.nvim_command 'packadd packer.nvim'
end 

vim.cmd [[packadd packer.nvim]]
-- vim.cmd 'autocmd BufWritePost init.lua PackerCompile' -- Auto compile when there are changes in plugins.lua 

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
    use { "neoclide/coc.nvim" } 
    use { "mfussenegger/nvim-dap" }
    use { "brymko/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" }  }
end)

-- nvim-dap configurations 
local dap = require("dap")

-- TODO(brymko): this isn't ideal, gotta read some more docs
vim.api.nvim_set_keymap("n", "<Space>b", ":lua require'dap'.toggle_breakpoint()<CR>", {expr = false; noremap = true})
vim.api.nvim_set_keymap("n", "<Space>d", ":lua start_debugger()<CR>", {expr = false; noremap = true})
vim.api.nvim_set_keymap("n", "<Space>c", ":lua require'dap'.continue()<CR>", {expr = false; noremap = true})
-- vim.api.nvim_set_keymap("n", "<M-i>", ":lua require'dap'.step_into()<CR>", {expr = false; noremap = true})
-- vim.api.nvim_set_keymap("n", "<M-n>", ":lua require'dap'.step_over()<CR>", {expr = false; noremap = true})
vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})

function start_debugger() 
    local dap = require("dap")
    dap.continue()
end

dap.adapters.python = {
    type = "executable";
    command = os.getenv("HOME") .. "/.local/share/vimdbg/bin/python";
    args = { "-m", "debugpy.adapter" };
} 

dap.configurations.python = {
    {
        type = 'python';
        request = 'launch';
        name = "Launch file";
        program = "${file}";
        -- i might want ot set `justMyCode` to `false` somewhere here to debug all code ?
        -- use venv if in found
        pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                return cwd .. '/.venv/bin/python'
            else 
                return '/usr/bin/python'
            end
        end;
    },
}

dap.adapters.lldb = {
    type = "executable",
    command = "/usr/bin/lldb-vscode",
    name = "lldb"
}

dap.configurations.rust = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            function split(source, delimiters)
                local elements = {}
                local pattern = '([^'..delimiters..']+)'
                string.gsub(source, pattern, function(value) elements[#elements + 1] = value; end);
                return elements
            end 
            vim.api.nvim_command("!cargo build")
            local cwd = vim.fn.getcwd()
            local proj = split(cwd, "/")
            proj = proj[#proj]
            -- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
            return cwd .. "/target/debug/" .. proj
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},

        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --
        -- Otherwise you might get the following error:
        --
        --    Error on launch: Failed to attach to the target process
        --
        -- But you should be aware of the implications:
        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        runInTerminal = false,
    }, 
}
 
require("dapui").setup({
    icons = {
        expanded = "⯆",
        collapsed = "⯈"
    },
    mappings = {
        expand = "<CR>",
        open = "o",
        remove = "d",
        edit = "e",
    },
    sidebar = {
        open_on_start = true,
        elements = {
            "watches",
            "scopes",
            "stacks",
        },
        width = 30,
        position = "left"
    },
    tray = {
        open_on_start = true,
        elemnts = {
            "repl",
        },
        height = 5,
        position = "top",
        auto_insert = true
    },
})

-- other options

vim.g.border_chars =  {"╭", "─", "╮", "│", "╯", "─", "╰", "│",}


-- colors
function ConstructColour(colour)
  return {gui = colour}
end

local Transparent = ConstructColour("NONE")
local Grey1 = ConstructColour("#262626")
local Grey2 = ConstructColour("#424242")
local Grey3 = ConstructColour("#8B8B8B")
local Grey4 = ConstructColour("#bdbdbd")
local Grey5 = ConstructColour("#F8F8F8")

local Violet = ConstructColour("#D484FF")
local Blue = ConstructColour("#2f628e")
local Cyan = ConstructColour("#00f1f5")
local Green = ConstructColour("#A9FF68")
local Green2 = ConstructColour("#2f7366")
local GreenDiff = ConstructColour("#0f5346")
local Yellow = ConstructColour("#FFF59D")
local Orange = ConstructColour("#F79000")
local Red = ConstructColour("#F70067")
local RedDiff = ConstructColour("#370000")
local GreenDiff = ConstructColour("#666666")
local FloatBackground = ConstructColour("#132434")
local Background = ConstructColour("NONE")
local Black = ConstructColour("#000000")
local StatusLineGreenBg = ConstructColour("#d349e8")

local function setHighlight(group, args)
  local fg = args[1]
  local bg = Background
  local attrs = "none"
  if type(args[2]) == "table" then
    bg = args[2]
    if type(args[3]) == "string" then
      attrs = args[3]
    end
  elseif type(args[2]) == "string" then
    attrs = args[2]
  end
  vim.cmd("hi " .. group .. " guifg=" .. fg.gui .. " guibg=" .. bg.gui .. " gui=" .. attrs)
end

local function loadHighlights(highlights)
  for group, groupArgs in pairs(highlights) do
    setHighlight(group, groupArgs)
  end
end

local Normal = Grey5
local Border = Grey3
local Decoration = Orange
local Hidden = Grey3
local BuiltIn = Red
local VarName = Grey5
local FuncName = Cyan
local TypeName = Violet
local Key = Cyan
local Val = Violet
local Parameter = Green
local String = Yellow
local Operator = Orange
local Success = Green
local Warning = Yellow
local Info = Cyan
local Error = Red

-- For reference elsewhere
loadHighlights(
  {
    Normal = {Normal},
    NormalFloat = {Normal},
    Border = {Border},
    FloatBorder = {Border},
    Decoration = {Orange},
    Hidden = {Grey3},
    BuiltIn = {Red},
    VarName = {Grey5, "bold"},
    FuncName = {Cyan},
    TypeName = {Violet},
    Key = {Cyan},
    Val = {Violet},
    -- String = {Yellow},
    Operator = {Orange},
    Success = {Green},
    Warning = {Yellow},
    Info = {Cyan},
    Error = {Red},
    User1 = {Success, FloatBackground},
    User2 = {Warning, FloatBackground},
    User3 = {Error, FloatBackground},
    User4 = {Grey1, Info},
    -- Vim
    Cursor = {Grey1, Red},
    CursorLine = {Transparent, Grey1},
    CursorColumn = {Transparent, Grey1},
    ColorColumn = {Transparent, Grey1},
    LineNr = {Hidden},
    CursorLineNr = {Success, "bold"},
    VertSplit = {Hidden},
    MatchParen = {Success, "underline"},
    StatusLine = {Normal},
    StatusLineNC = {Hidden},
    IncSearch = {Green, "bold,underline"},
    Search = {Green, Grey1, "bold,underline"},
    Directory = {Cyan},
    Folded = {Grey3},
    WildMenu = {Cyan},
    VisualNOS = {Grey3, Yellow},
    ModeMsg = {Yellow},
    FoldColumn = {Grey4},
    MoreMsg = {Yellow},
    cursorim = {Violet},
    -- Pmenu = {Grey4, FloatBackground},
    -- PmenuSel = {Transparent, Grey3, "bold"},
    -- PMenuSbar = {Transparent, FloatBackground},
    -- PMenuThumb = {Transparent, Grey4},
    Visual = {Transparent, Grey1, "bold"},
    EndOfBuffer = {Grey1},
    Underlined = {Transparent, "underline"},
    SpellBad = {Transparent, "undercurl"},
    SpellCap = {Transparent, "undercurl"},
    SpellLocal = {Transparent, "undercurl"},
    SignColumn = {Key},
    Question = {Info},
    -- TabLineFill = {Grey3},
    NotificationInfo = {Normal, FloatBackground},
    NotificationError = {Error, FloatBackground},
    NotificationWarning = {Warning, FloatBackground},
    -- General
    -- Boolean = {Val},
    -- Character = {Val},
    -- Comment = {Hidden},
    -- Conditional = {BuiltIn},
    -- Constant = {VarName},
    -- Define = {BuiltIn},
    DiffAdd = {Success, GreenDiff},
    DiffChange = {Warning, GreyDiff},
    DiffDelete = {Error, RedDiff},
    DiffText = {Error, RedDiff},
    ErrorMsg = {Error},
    WarningMsg = {Warning},
    -- Float = {Val},
    -- Function = {FuncName},
    -- Identifier = {VarName},
    -- Keyword = {BuiltIn},
    -- Label = {Key},
    -- NonText = {Hidden},
    -- Number = {Val},
    -- PreProc = {Key},
    -- Special = {Cyan},
    -- SpecialKey = {BuiltIn},
    -- Statement = {BuiltIn},
    -- Tag = {Key},
    -- Title = {Normal, "bold"},
    -- Todo = {Normal, "bold"},
    -- Type = {TypeName},
    -- SpecialComment = {Info, "bold"},
    -- Typedef = {TypeName},
    -- PreCondit = {BuiltIn},
    -- Include = {BuiltIn},
    Ignore = {BuiltIn},
    Delimiter = {Decoration},
    Conceal = {Transparent, "bold"},
    -- Viml
    vimContinue = {Decoration},
    vimFunction = {FuncName},
    vimIsCommand = {VarName},
    -- Haskell
    haskellIdentifier = {FuncName},
    haskellDecl = {BuiltIn},
    haskellDeclKeyword = {BuiltIn},
    haskellLet = {BuiltIn},
    -- Vim Fugitive
    diffRemoved = {Error},
    diffAdded = {Success},
    -- HTML
    htmlTagName = {Key},
    htmlSpecialTagName = {BuiltIn},
    htmlTag = {Decoration},
    htmlEndTag = {Decoration},
    htmlArg = {VarName},
    -- Vim Signify
    SignifySignAdd = {Success, "bold"},
    SignifySignDelete = {Error, "bold"},
    SignifySignChange = {Warning, "bold"},
    --Floaterm
    FloatermBorder = {Border},
    -- Coc.nvim
    CocErrorSign = {Error},
    CocWarningSign = {Warning},
    CocInfoSign = {Info},
    CocHintSign = {Info},
    CocHighlightText = {Transparent, "underline"},
    CocCodeLens = {Hidden, "bold"},
    CocListFgGreen = {Green},
    CocListFgRed = {Red},
    CocListFgBlack = {Grey1},
    CocListFgYellow = {Yellow},
    CocListFgBlue = {Cyan},
    CocListFgMagenta = {Violet},
    CocListFgCyan = {Cyan},
    CocListFgWhite = {Grey5},
    CocListFgGrey = {Grey3},
    -- ALE
    ALEWarningSign = {Warning},
    ALEVirtualTextError = {Error},
    ALEVirtualTextWarning = {Warning},
    ALEVirtualTextInfo = {Info},
    -- Markdown
    markdownHeadingDelimiter = {BuiltIn},
    markdownCodeDelimiter = {BuiltIn},
    markdownRule = {BuiltIn},
    markdownUrl = {Key},
    -- Makefile
    makeCommands = {Normal, "bold"},
    -- vim-signature
    SignatureMarkText = {TypeName, "bold"},
    -- Vista.vim
    VistaScope = {TypeName, "bold"},
    VistaTag = {FuncName},
    -- LeaderF
    Lf_hl_popup_window = {Normal, FloatBackground},
    Lf_hl_popup_blank = {Hidden, FloatBackground},
    Lf_hl_popup_inputText = {Key, FloatBackground},
    Lf_hl_cursorline = {Normal, FloatBackground, "bold"},
    -- vim-which-key
    WhichKeySeperator = {BuiltIn},
    WhichKeyFloating = {VarName, FloatBackground, "bold"},
    WhichKeyGroup = {TypeName},
    WhichKey = {VarName},
    WhichKeyDesc = {Info, "bold"},
    -- JSX/TSX
    jsxTagName = {Key},
    jsxComponentName = {TypeName},
    jsxAttrib = {Green},
    -- Javascript
    jsImport = {BuiltIn},
    jsExport = {BuiltIn},
    jsVariableType = {BuiltIn},
    jsAssignmentEqual = {BuiltIn},
    jsParens = {Decoration},
    jsObjectBraces = {Decoration},
    jsFunctionBraces = {Decoration},
    -- vim-jumpmotion
    JumpMotion = {Red, "bold"},
    JumpMotionTail = {Yellow},
    -- TypeScript
    typescriptVariable = {BuiltIn},
    typescriptImport = {BuiltIn},
    typescriptExport = {BuiltIn},
    typescriptCall = {VarName},
    typescriptTypeReference = {TypeName},
    typescriptArrowFunc = {BuiltIn},
    typescriptBraces = {Decoration},
    typescriptMember = {Green},
    typescriptObjectLabel = {Key},
    typescriptStringLiteralType = {TypeName},
    typescriptInterfaceName = {TypeName},
    typescriptFuncType = {VarName},
    typescriptFuncTypeArrow = {BuiltIn},
    --hiPairs
    hiPairs_matchPair = {Success, "bold,underline"},
    hiPairs_unmatchPair = {Error, "bold,underline"},
    --LaTex
    texBeginEndName = {FuncName},
    --YAML
    yamlBlockMappingKey = {Key},
    --ini
    dosiniLabel = {Key},
    dosiniValue = {Val},
    dosiniHeader = {BuiltIn},
    -- Conflict Markers
    ConflictMarkerBegin = {Transparent, Green2},
    ConflictMarkerOurs = {Transparent, Green2},
    ConflictMarkerTheirs = {Transparent, Blue},
    ConflictMarkerEnd = {Transparent, Blue},
    ConflictMarkerCommonAncestorsHunk = {Transparent, Red},
    -- TreeSitter
    TSError = {Error},
    TSComment = {Hidden},
    TSPunctDelimiter = {Decoration},
    TSPunctBracket = {Decoration},
    TSPunctSpecial = {Decoration},
    TSConstant = {VarName},
    TSConstBuiltin = {BuiltIn},
    TSConstMacro = {BuiltIn},
    TSString = {String},
    TSStringRegex = {Operator},
    TSStringEscape = {Operator},
    TSCharacter = {Val},
    TSNumber = {Val},
    TSBoolean = {Val},
    TSFloat = {Val},
    TSFunction = {FuncName},
    TSFuncBuiltin = {BuiltIn},
    TSFuncMacro = {BuiltIn},
    TSParameter = {Green},
    TSParameterReference = {Green},
    TSMethod = {FuncName},
    TSField = {FuncName},
    TSProperty = {Parameter},
    TSTag = {FuncName},
    TSConstructor = {TypeName},
    TSConditional = {BuiltIn},
    TSRepeat = {BuiltIn},
    TSLabel = {Key},
    TSOperator = {Operator},
    TSKeyword = {BuiltIn},
    TSKeywordFunction = {BuiltIn},
    TSException = {Error},
    TSType = {TypeName},
    TSTypeBuiltin = {TypeName},
    TSStructure = {Error},
    TSInclude = {BuiltIn},
    TSAnnotation = {String},
    TSText = {String},
    TSStrong = {Transparent, "bold"},
    TSEmphasis = {Transparent, "bold,underline"},
    TSUnderline = {Transparent, "underline"},
    TSTitle = {BuiltIn},
    TSLiteral = {Decoration},
    TSURI = {Info},
    TSVariable = {VarName},
    TSVariableBuiltin = {BuiltIn},
    TSDefinition = {Transparent, "bold,underline"},
    TSDefinitionUsage = {Transparent, "bold,underline"},
    TSCurrentScope = {Transparent, "bold"},
    -- Golang
    goFunctionCall = {FuncName},
    goVarDefs = {VarName},
    -- Telescope
    TelescopeBorder = {Border},
    -- barbar
    BufferCurrent = {Normal, FloatBackground},
    BufferCurrentMod = {Info, FloatBackground, "bold"},
    BufferCurrentSign = {Info, FloatBackground},
    BufferCurrentTarget = {Info, Grey1, "bold"},
    BufferVisible = {Normal, Grey1, "bold"},
    BufferVisibleMod = {Normal, Grey1, "bold,underline"},
    BufferVisibleSign = {Info, Grey1},
    BufferVisibleTarget = {Error, "bold,underline"},
    BufferInactive = {Grey3, Grey1},
    BufferInactiveMod = {Grey3, Grey1, "underline"},
    BufferInactiveSign = {Grey3, Grey1},
    BufferInactiveTarget = {Error, Grey1, "bold"},
    BufferTabpages = {Info, "bold"},
    BufferTabpageFill = {Grey3},
    -- LSP
    LspDiagnosticsDefaultError = {Error},
    LspDiagnosticsDefaultWarning = {Warning},
    LspDiagnosticsDefaultInformation = {Info},
    LspDiagnosticsDefaultHint = {Hidden},
    -- Lsp saga
    LspFloatWinBorder = {Border},
    ProviderTruncateLine = {Hidden},
    LspSagaFinderSelection = {Green, "bold"},
    LspSagaBorderTitle = {BuiltIn, "bold"},
    TargetWord = {BuiltIn},
    ReferencesCount = {Val},
    DefinitionCount = {Val},
    TargetFileName = {Operator},
    DefinitionIcon = {Decoration},
    ReferencesIcon = {Decoration},
    SagaShadow = {Transparent, Grey1},
    DiagnosticTruncateLine = {Hidden},
    DiagnosticError = {Error},
    DiagnosticWarning = {Warning},
    DiagnosticInformation = {Info},
    DiagnosticHint = {Hidden},
    DefinitionPreviewTitle = {BuiltIn, "bold"},
    LspSagaDiagnosticBorder = {Border},
    LspSagaDiagnosticHeader = {BuiltIn},
    LspSagaDiagnostcTruncateLine = {Hidden},
    LspDiagnosticsFloatingError = {Error},
    LspDiagnosticsFloatingWarn = {Warning},
    LspDiagnosticsFloatingInfor = {Info},
    LspDiagnosticsFloatingHint = {Hidden},
    LspSagaShTruncateLine = {Hidden},
    LspSagaDocTruncateLine = {Hidden},
    LspSagaCodeActionTitle = {BuiltIn},
    LspSagaCodeActionTruncateLine = {Hidden},
    LspSagaCodeActionContent = {Grey4},
    LspSagaRenamePromptPrefix = {Decoration},
    LspSagaRenameBorder = {Border},
    LspSagaHoverBorder = {Border},
    LspSagaSignatureHelpBorder = {Border},
    LspSagaLspFinderBorder = {Border},
    LspSagaCodeActionBorder = {Border},
    LspSagaAutoPreview = {Yellow},
    LspSagaDefPreviewBorder = {Border},
    IndentBlanklineChar = {Grey2},
    IndentBlanklineContextChar = {Key},

    -- LSP Signature
    LspSelectedParam = {Normal, "bold,underline"},
  }
) 

vim.cmd("hi  StatusLine  gui=NONE  guifg=black    guibg=#c5ff00  ctermfg=black  ctermbg=cyan")
