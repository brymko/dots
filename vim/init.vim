" Functions {{{
function! Preserve(cmd)
    let _s=@/
    let l = line(".")
    let c = col(".")

    execute a:cmd

    let @/=_s
    call cursor(l, c)
endfunction

function! EnsureExists(path)
    if !isdirectory(expand(a:path))
        call mkdir(expand(a:path), 'p', 0700)
    endif
endfunction

function! RunFile()
    if(&ft == 'c' || &ft == 'cpp')
        :!clear; make
    elseif (&ft == 'tex')
        :!clear; zathura %:r.pdf > /dev/null 2>&1 &<CR><CR>
    elseif (&ft == 'rust')
        :!clear; cargo run
    elseif (&ft == 'python')
        :% w ! python
    elseif (&ft == 'sh')
        :% w ! sh
    endif
endfunction
" }}}

" Keybindings {{{

let mapleader=" "
nnoremap <leader>q :q!<CR>
nnoremap <leader>u :nohl<CR>
nnoremap <leader>lv :so $MYVIMRC<CR>
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>w :call Preserve(":%s/\\s\\+$//e")<CR>
nnoremap <leader>o :setlocal spell! spelllang=en_us<CR>
nnoremap <leader>l :setlocal list!<CR>
nnoremap <leader>r :call RunFile()<CR>
nnoremap <leader>t :!clear; cargo test<CR>
nnoremap <leader><leader> <C-^>

" movement
inoremap jk <esc>
nnoremap j gj
nnoremap k gk
nnoremap E $
nnoremap B ^

" windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

inoremap <C-h> <ESC><C-w>h
inoremap <C-j> <ESC><C-w>j
inoremap <C-k> <ESC><C-w>k
inoremap <C-l> <ESC><C-w>l

nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>

" visual mode
vnoremap < <gv
vnoremap > >gv

" copy paste
vnoremap <C-c> "+y
inoremap <C-v> <space><C-o>"+P

" misc
cnoremap sudow w !sudo tee % > /dev/null<CR>

" }}}

" Vim Core {{{
set tgc
set splitright splitbelow
set number
" set cursorline
set diffopt=filler,vertical
" set lazyredraw
set background=dark
set titlestring=
set hidden

" scrolling
set nowrap
set scrolloff=5
set sidescroll=5

" spaces & tabs
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smarttab
set expandtab
set autoindent

" misc
set timeoutlen=400
set listchars=eol:⏎,tab:>-,trail:·,extends:>,precedes:<,space:␣
set completeopt=menuone,noinsert,noselect

" wildmenu
set wildmenu
set wildignorecase
set wildmode=longest,full

" netrw
let g:netrw_liststyle=3 " tree view


" formating
" TODO: this is retarded, bc ftplugins are executed AFTER the vimrc...
" but on the other hand its not that expensive considering that the view is
" loaded with this callback aswell
autocmd BufWinEnter ?* silent! setlocal formatoptions=crjq 
set autoread
set nomodeline

" searching
set ignorecase
set smartcase
set incsearch
set inccommand=nosplit
set hlsearch
set path+=**

if executable('rg') 
    set grepprg=rg\ --no-heading\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

" Cursor
" TODO: this also is retarded, guibg=#1e1f28 == my terminal bg color, so
" cursorline is effectivly off This is needed bc if there isn't a change in 
" the cursoline color when switching modes, the cursor color won't change 
" WHILE the cursor hasn't moved yet. 
" This seems to be a bug & i'll be better off fixing it
set cursorline
" set guifg to SignColumn to not highlight the current line
hi       CursorLineNr  gui=NONE  guibg=NONE  guifg=NONE                           
hi       CursorLine    gui=NONE  guibg=NONE  guifg=NONE                           
autocmd  InsertEnter   *         hi          CursorLine  gui=NONE  guibg=#1e1f28  guifg=NONE
autocmd  InsertLeave   *         hi          CursorLine  gui=NONE  guibg=NONE     guifg=NONE

" insert mode cursor color
hi iCursor gui=standout guibg=#d349e8
" non-insert mode cursor color
hi nCursor gui=standout guibg=#c5ff00
hi MatchParen gui=inverse guifg=grey guibg=NONE
au VimEnter,VimResume * set guicursor=a:block-blinkon0-nCursor/nCursor,i-r-ci-cr:block-iCursor/iCursor
au VimLeave * set guicursor=

" Some more colors
hi  VertSplit     gui=NONE       guifg=#313238  guibg=#313238            
hi  StatusLineNC  gui=NONE       guifg=#7f8c98  guibg=#313238            
hi  SignColumn    gui=NONE       guifg=#313238  guibg=#313238            
hi  LineNr        gui=NONE       guifg=#50535b  guibg=NONE               
hi  Pmenu         gui=NONE       guifg=#f0f0f0  guibg=#313238            
hi  PmenuSel      gui=bold       guifg=#ffffff  guibg=#ab3b06            
hi  PmenuSbar     gui=NONE       guifg=#313238  guibg=#313238            
hi  PmenuThumb    gui=NONE       guifg=#41434a  guibg=#41434a            
hi  Visual        gui=NONE       guifg=NONE     guibg=grey               
hi  ErrorMsg      gui=NONE       guifg=red      guibg=NONE               
hi  Error         gui=NONE       guifg=white    guibg=#a07033            
hi  ModeMsg       gui=NONE       guifg=red      guibg=NONE               
hi  MoreMsg       gui=None       guifg=magenta  guibg=NONE               
hi  Question      gui=NONE       guifg=#ff7ab2  guibg=NONE               
hi  WarningMsg    gui=NONE       guifg=#ffa14f  guibg=NONE               
hi  IncSearch     gui=NONE       guifg=#292a30  guibg=#fef937            
hi  Search        gui=NONE       guifg=#dfdfe0  guibg=#515453            
hi  DiffAdd       guifg=#acf2e4  guibg=#243330  guisp=NONE     gui=NONE  cterm=NONE
hi  DiffChange    guifg=#ffa14f  guibg=NONE     guisp=NONE     gui=NONE  cterm=NONE
hi  DiffDelete    guifg=#ff8170  guibg=#3b2d2b  guisp=NONE     gui=NONE  cterm=NONE
hi  DiffText      guifg=#ffa14f  guibg=#382e27  guisp=NONE     gui=NONE  cterm=NONE

hi! link diffAdded DiffAdd
hi! link diffBDiffer WarningMsg
hi! link diffChanged DiffChange
hi! link diffCommon WarningMsg
hi! link diffDiffer WarningMsg
hi! link diffFile Directory
hi! link diffIdentical WarningMsg
hi! link diffIndexLine Number
hi! link diffIsA WarningMsg
hi! link diffNoEOL WarningMsg
hi! link diffOnly WarningMsg
hi! link diffRemoved DiffDelete

" Files
call EnsureExists("~/.config/nvim/.backup//")
call EnsureExists("~/.config/nvim/.swap//")
call EnsureExists("~/.config/nvim/.undo//")
call EnsureExists("~/.config/nvim/.views//")

set backupdir=~/.config/nvim/.backup//
set directory=~/.config/nvim/.swap//
set undodir=~/.config/nvim/.undo//
set viewdir=~/.config/nvim/.views//

set swapfile
set nobackup
set nowritebackup
set undofile
set viewoptions=folds,cursor
set foldmethod=manual

augroup AutoSaveFolds
    autocmd!
    autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!
    autocmd BufWinEnter ?* silent! loadview
augroup end

" }}}

" Status Line {{{
au InsertEnter * hi StatusLine gui=NONE guifg=black guibg=#d349e8 ctermfg=black ctermbg=magenta
au InsertLeave * hi StatusLine gui=NONE guifg=black guibg=#c5ff00 ctermfg=black ctermbg=cyan

hi  StatusLine  gui=NONE  guifg=black    guibg=#c5ff00  ctermfg=black  ctermbg=cyan
hi  HSplit      gui=NONE  guifg=#000000  guibg=#000000                 
hi  Base        gui=NONE  guifg=#313333  guibg=#313333                 

hi! link Terminal Normal
hi! link TabLine StatusLineNC
hi! link TabLineFill StatusLineNC
hi! link TabLineSel StatusLine
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC

" These function are only used in statusline generation hence they are here
" and not in the script section

let g:currentmode={
  \'n' : 'Normal ',
  \'no' : 'N·Operator Pending ',
  \'v' : 'Visual ',
  \'V' : 'V·Line ',
  \'^V' : 'V·Block ',
  \'s' : 'Select ',
  \'S': 'S·Line ',
  \'^S' : 'S·Block ',
  \'i' : 'Insert ',
  \'R' : 'Replace ',
  \'Rv' : 'V·Replace ',
  \'c' : 'Command ',
  \'cv' : 'Vim Ex ',
  \'ce' : 'Ex ',
  \'r' : 'Prompt ',
  \'rm' : 'More ',
  \'r?' : 'Confirm ',
  \'!' : 'Shell ',
  \'t' : 'Terminal '
  \}

function! ModeCurrent() abort
    let l:modecurrent = mode()
    let l:modelist = toupper(get(g:currentmode, l:modecurrent, 'V·Block '))
    let l:current_status_mode = l:modelist
    return l:current_status_mode
endfunction

function! LineActive()
    " Set empty statusline and colors
    let statusline = ""
    let statusline .= "%#Base#"
    let statusline .= "%0* %{ModeCurrent()}"                " Mode
    let statusline .= "%2* %Y "                             " FileType
    let statusline .= "%2* %{''.(&fenc!=''?&fenc:&enc).''}" " Encoding
    let statusline .= "%2* %{&ff} "                         " File format
    let statusline .= "%#Base#"                             " Seperator
    let statusline .= "%="                                  " Right Side
    let statusline .= "%#Base#"                             " Seperator
    let statusline .= "%2* %<%f%m%r%h%w "                   " File path, modified, readonly, helpfile, preview
    let statusline .= "%0* col: %02v "                      " Column number
    let statusline .= "%0* ln: %02l/%L (%p%%) "             " Line number
    return statusline
endfunction

function! LineInactive()
  let statusline = ""
  let statusline .= "%#HSplit#"

  return statusline
endfunction

set laststatus=2
set showcmd
set noshowmode

augroup Statusline
    autocmd!
    autocmd WinEnter,BufEnter * setlocal statusline=%!LineActive()
    autocmd WinLeave,BufLeave * setlocal statusline=%!LineInactive()
augroup end

" }}}

" Languages {{{
au FileType make setlocal noexpandtab
au FileType markdown setlocal tabstop=2
au FileType markdown setlocal shiftwidth=2
au FileType yaml setlocal tabstop=2
au FileType yaml setlocal shiftwidth=2

" augroup OnFileSave
"     autocmd!
"     autocmd BufWritePre *.rs
" augroup end

" }}}

" Plugins {{{
execute pathogen#infect()
" plugins are installed in actions.sh
" https://github.com/ap/vim-buftabline/commit/73b9ef5dcb6cdf6488bc88adb382f20bc3e3262a
" https://github.com/tpope/vim-fugitive/commit/bebe504e38d0a20c30d6dd666c4c793b3cc66104 " Git wrapper
" https://github.com/tpope/vim-commentary/commit/f8238d70f873969fb41bf6a6b07ca63a4c0b82b1
" https://github.com/tpope/vim-surround/commit/f51a26d3710629d031806305b6c8727189cd1935
" https://github.com/tpope/vim-endwise/commit/97180a73ad26e1dcc1eebe8de201f7189eb08344
" https://github.com/rstacruz/vim-closer/commit/c61667d27280df171a285b1274dd3cf04cbf78d4
" https://github.com/tpope/vim-repeat/commit/c947ad2b6a16983724a0153bdf7f66d7a80a32ca
" https://github.com/rust-lang/rust.vim/commit/96e79e397126be1a64fb53d8e3656842fe1a4532
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

" https://github.com/neoclide/coc.nvim/commit/5b4b18d2ed2b18870034c7ee853164e1274ab158
" coc-rust-analyzer => Installed via :CocInstall coc-rust-analyzer
" coc-pyright => Installed via :CocInstall coc-pyright
" set cmdheight=2 " not sure how to feel about that
set updatetime=300
" set shortmess+=c " not sure about that either
nnoremap gw :CocCommand rust-analyzer.explainError<cr>
nnoremap ge :CocDiagnostic<cr>
nnoremap ga :CocAction<cr>
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> <C-f> :CocCommand rust-analyzer.openCargoToml<cr>
nnoremap <silent> <leader>h :CocCommand rust-analyzer.toggleInlayHints<cr>

" au CursorHold * silent call CocActionAsync('highlight')
" set signcolumn=yes " for always on sign column

" }}}


