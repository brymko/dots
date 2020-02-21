
" Scripts {{{
function! Preserve(cmd)  "{{{
    let _s=@/
    let l = line(".")
    let c = col(".")

    execute a:cmd

    let @/=_s
    call cursor(l, c)
endfunction "}}}
function! StripTrailingWhiteSpace() " {{{
    call Preserve("%s/\\s\\+$//e")
endfunction " }}}
function! Close() " {{{
    let no_buffers = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    if no_buffers > 1
        bdelete
    else
        quit
    endif
endfunction " }}}
function! EnsureExists(path) " {{{
    if !isdirectory(expand(a:path))
        call mkdir(expand(a:path))
    endif
endfunction "}}}
function! IsVimPlugInstalled() " {{{
    if empty(glob("~/.vim/autoload/plug.vim"))
        " silent! execute '!curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
        " autocmd VimEnter * silent! PlugInstall
        return v:false
    endif
    return v:true
endfunction "}}}
function! RunFile() " {{{
    if(&ft == 'c' || &ft == 'cpp')
        :!make
    elseif (&tf == 'tex')
        :!zathura %:r.pdf >/dev/null 2>&1 &<cr><cr>
    endif
endfunction " }}}
function! ModeCurrent() abort " {{{
    let l:modecurrent = mode()
    let l:modelist = toupper(get(g:currentmode, l:modecurrent, 'V·Block '))
    let l:current_status_mode = l:modelist
    return l:current_status_mode
endfunction " }}}
function! GitBranch() " {{{
  if fugitive#head() == ""
    return '-'
  else
    return fugitive#head()
  endif
endfunction " }}}
function! GetFT() " {{{
  if &filetype == ''
    return '-'
  else
    return toupper(&filetype)
  endif
endfunction " }}}
function! IsCHeader() " {{{
    let ex = expand("%:e")
    let exp = ['h', 'hpp', 'H']
    return index(exp, ex) >= 0
endfunction " }}}
" }}}
"
" Vim Core {{{


"" encodings
set nocompatible
" set t_Co=256
set tgc
set encoding=utf-8

"" graphicals
set background=dark
"set noruler
set number
set showmatch
set diffopt=filler,vertical
set lazyredraw
""set cursorline

" scrolling
"" set wrap
set nowrap
" set wrapmargin=1
set scrolloff=5
set sidescroll=5

"" spaces & tabs
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smarttab
set expandtab
set autoindent

"" misc
filetype plugin on
filetype plugin indent on
set noerrorbells
set history=10000
set t_BE=
set ttyfast

" wildmenu
set wildmenu
set wildignorecase

"" text handling
filetype indent on
syntax on
let skip_defaults_vim=1
set formatoptions-=tcro
set autoread
set textwidth=0 " disable auto enter after end of editor
set backspace=2
set modeline

"" folding
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax

"" searching
set ignorecase
set smartcase
set incsearch
set hlsearch
set path+=**
" * [word], g* [partial word], 
" crtl-o - ctrl-i [go thorugh jump locations]
" [I show lines with matching word under cursor

" marks
" m[a-zA-Z]
" '[a-zA-Z] move to mark, uppercase between files
" backtick for columns in addition to line

" Ctags
" command! MakeTags !ctags -R .
" :tag TAB            - list the known tags
" :tag function_name  - jump to that function
" ctrl-t              - goes to previous spot where you called :tag
" ctrl-]              - calls :tag on the word under the cursor        
" :ptag               - open tag in preview window (also ctrl-w })
" :pclose             - close preview window

" recording macros
" q[a-z]
" @[a-z] play once
" @@ play last
" 5@@ play 5 times
" "[a-z]p print macro


"" Buffers
set splitbelow splitright
set hidden

"" files
call EnsureExists("~/.config/vim/.backup//")
call EnsureExists("~/.config/vim/.swap//")
call EnsureExists("~/.config/vim/.undo//")
call EnsureExists("~/.config/vim/.views//")

set backupdir=~/.config/vim/.backup//
set directory=~/.config/vim/.swap//
set undodir=~/.config/vim/.undo//
set viewdir=~/.config/vim/.views//

set noswapfile
set writebackup
set undofile

" viminfo
let &runtimepath.=',$HOME/.confg/vim'
set viminfo=%,<800,'10,/50,:100,h,f0,n~/.config/vim/.viminfo
"           | |    |   |   |    | |  + viminfo file path
"           | |    |   |   |    | + file marks 0-9,A-Z 0=NOT stored
"           | |    |   |   |    + disable 'hlsearch' loading viminfo
"           | |    |   |   + command-line history saved
"           | |    |   + search history saved
"           | |    + files marks saved
"           | + lines saved each register (old name for <, vi6.2)
"           + save/restore buffer list

" views
" au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup AutoSaveFolds
  autocmd!
  " view files are about 500 bytes
  " bufleave but not bufwinleave captures closing 2nd tab
  " nested is needed by bufwrite* (if triggered via other autocmd)
  autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup end

set viewoptions=folds,cursor
set sessionoptions=folds

" au FileType ?* setlocal formatoptions-=c formatoptions-=r formatoptions-=o "
" This breaks folds :(
" not only does this breake folds, it also corrupts your view of the file...
" nice, however without vim thinks its appropriate to insert comments when
" pressing enter or o/O. It also auto writes stuff written in comments into
" new lines, which is kinda nice but also totally unexpected
" }}}

" Plugins {{{
if IsVimPlugInstalled()
    call plug#begin('~/.config/vim/plugged')

    if !has('nvim')
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif

    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-fugitive'
    " Plug 'tpope/vim-endwise'
    Plug 'rstacruz/vim-closer'
    " Plug 'cohama/lexima.vim' " could be great with enough configuration
    " Plug 'thirtythreeforty/lessspace.vim " Strip trailing ws version control friendly
    " Plug 'tmux-plugins/vim-tmux'
    " Plug 'mihaifm/bufstop' " needs configuration / stop using :bn :bp
    Plug 'pacha/vem-tabline' 
    
    " Language stuff
    " Plug 'sheerun/vim-polyglot' " get colors from repo for superiore experience
    Plug 'dense-analysis/ale'
    " Plug 'Shougo/deoplete.nvim'
    " Plug 'Shougo/deoplete-clangx'
    " Plug 'deoplete-plugins/deoplete-jedi'
    Plug 'octol/vim-cpp-enhanced-highlight'

    " Plug 'junegunn/fzf', { 'do': './install --bin' }
    " Plug 'junegunn/fzf.vim'

    " colors
    Plug 'ajmwagar/vim-deus'
    Plug 'dracula/vim'
    Plug 'joshdick/onedark.vim'
    Plug 'dikiaap/minimalist'
    Plug 'pacha/vem-dark'

    call plug#end()

    colorscheme minimalist 

    " Plugin conf

    let g:vem_tabline_multiwindow_mode = 1


    let g:ale_sign_column_always = 1
    let g:ale_set_balloons = 1
    let g:ale_completion_enabled = 1
    let g:ale_lint_on_text_changed = 0
    let g:ale_lint_on_insert_leave = 1
    let g:ale_lint_on_enter = 1
    let g:ale_linters_explicit = 1
    let g:ale_completion_delay = 50
    let g:ale_pattern_options_enabled = 1


    " let g:deoplete#enable_at_startup=1
    " highlight Pmenu ctermbg=8 guibg=#606060
    " highlight PmenuSel ctermbg=1 guifg=#dddd00 guibg=#1f82cd
    " highlight PmenuSbar ctermbg=0 guibg=#d6d6d6
    highlight VemTablineNormal           term=reverse cterm=none ctermfg=1 ctermbg=251 guifg=#ffffff guibg=#212333 gui=none
    highlight VemTablineLocation         term=reverse cterm=none ctermfg=239 ctermbg=251 guifg=#666666 guibg=#cdcdcd gui=none
    highlight VemTablineNumber           term=reverse cterm=none ctermfg=239 ctermbg=251 guifg=#666666 guibg=#cdcdcd gui=none
    highlight VemTablineSelected         term=bold    cterm=bold ctermfg=0   ctermbg=255 guifg=#242424 guibg=#ffffff gui=bold
    highlight VemTablineLocationSelected term=bold    cterm=none ctermfg=239 ctermbg=255 guifg=#666666 guibg=#ffffff gui=bold
    highlight VemTablineNumberSelected   term=bold    cterm=none ctermfg=239 ctermbg=255 guifg=#666666 guibg=#ffffff gui=bold
    highlight VemTablineShown            term=reverse cterm=none ctermfg=0   ctermbg=251 guifg=#242424 guibg=#cdcdcd gui=none
    highlight VemTablineLocationShown    term=reverse cterm=none ctermfg=0   ctermbg=251 guifg=#666666 guibg=#cdcdcd gui=none
    highlight VemTablineNumberShown      term=reverse cterm=none ctermfg=0   ctermbg=251 guifg=#666666 guibg=#cdcdcd gui=none
    highlight VemTablineSeparator        term=reverse cterm=none ctermfg=246 ctermbg=251 guifg=#888888 guibg=#cdcdcd gui=none
    highlight VemTablinePartialName      term=reverse cterm=none ctermfg=246 ctermbg=251 guifg=#888888 guibg=#cdcdcd gui=none
    highlight VemTablineTabNormal        term=reverse cterm=none ctermfg=0   ctermbg=251 guifg=#242424 guibg=#4a4a4a gui=none
    highlight VemTablineTabSelected      term=bold    cterm=bold ctermfg=0   ctermbg=255 guifg=#242424 guibg=#ffffff gui=bold
endif

" }}}

" Bindings {{{

" Leader
let mapleader=" "
nnoremap <leader>q :q!<CR>
nnoremap <leader>u :nohl<CR>
nnoremap <leader>lv :so $MYVIMRC<CR>
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>w :call Preserve(":%s/\\s\\+$//e")<CR>
nnoremap <leader>o :setlocal spell! spelllang=en_us<CR>
nnoremap <leader>r :call RunFile()<cr>


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

nnoremap <C-n> :bn<cr>
nnoremap <C-p> :bp<cr>


" visual mode
vnoremap < <gv
vnoremap > >gv
vnoremap <C-c> :'<,'> w ! xclip -i -selection clipboard<CR><CR>

" misc
cnoremap sudow w !sudo tee % > /dev/null<CR>
cnoremap k call Close()<cr>

" }}}

" Status Line {{{
au InsertEnter * hi statusline guifg=black guibg=#d349e8 ctermfg=black ctermbg=magenta
au InsertLeave * hi statusline guifg=black guibg=#c5ff00 ctermfg=black ctermbg=cyan

hi statusline guifg=black guibg=#c5ff00 ctermfg=black ctermbg=cyan
hi User1 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#adadad
hi Base guibg=#212333 guifg=#212333

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

" These function are only used in statusline generation hence they are here
" and not in the script section

function! LineActive()
    " Set empty statusline and colors
    let statusline = ""
    let statusline .= "%#Base#"
    let statusline .= "%0* %{ModeCurrent()}"                " Mode
    let statusline .= "%2* %{GitBranch()} %)"               " Current Branch
    let statusline .= "%2* %Y "                             " FileType
    let statusline .= "%2* %{''.(&fenc!=''?&fenc:&enc).''}" " Encoding
    let statusline .= "%2* %{&ff} "                         " File format
    let statusline .= "%#Base#"                             " Seperator
    let statusline .= "%="                                  " Right Side
    let statusline .= "%#Base#"                             " Seperator
    let statusline .= "%2* %<%f%m%r%h%w "                   " File paht, modified, readonly, helpfile, preview
    let statusline .= "%0* col: %02v "                      " Column number
    let statusline .= "%0* ln: %02l/%L (%p%%) "             " Line number
    return statusline
endfunction

function! LineInactive()
  let statusline = ""
  let statusline .= "%#Base#"

  return statusline
endfunction

set laststatus=2
set noshowmode

augroup Statusline
    autocmd!
    autocmd WinEnter,BufEnter * setlocal statusline=%!LineActive()
    autocmd WinLeave,BufLeave * setlocal statusline=%!LineInactive()
augroup END

" }}}

" Languages {{{
" view all filetypes via :setfiletype [CRTL-d]
" C/C++ {{{
au FileType c :setlocal commentstring=/*\ %s\ */
au FileType cpp :setlocal commentstring=/*\ %s\ */

au FileType c :set foldmethod=syntax
au FileType cpp :set foldmethod=syntax

" bindings
nnoremap gd :ALEGoToDefinition<cr>
nnoremap gtd :ALEGoToTypeDefinition<cr>
nnoremap gr :ALEFindReferences<cr>
nnoremap gh :ALEHover<cr>
nnoremap ga :ALESymbolSearch 

" if 'octol/vim-cpp-enhanced-highlight' is installed 
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standart = 1
let c_no_curly_error = 1

let compile_options = '-std=c++2a -Wall -Wextra -Wconversion -Wunreachable-code 
                            \ -Wuninitialized -pedantic '
let ccls_options = { 'cache': { 'directory': '/tmp/ccls/cache' } }
let g:ale_pattern_options = {
            \ '\.\(h\|hpp\|H\|HPP\)$': { 'ale_linters': { 'cpp': ['clang', 'ccls'], 'c': ['clang', 'ccls'] } },
            \ '\.\(c\|cc\|cpp\|C\|CC\|CPP\)$': { 'ale_linters': { 'cpp': ['clangtidy', 'ccls'], 'c': ['clangtidy', 'ccls'] } },
            \ }
" if IsCHeader() 
"     let b:ale_linters = { 'cpp': ['clang', 'ccls'], 'c': ['clangtidy', 'ccls'] }
" else
"     let b:ale_linters = { 'cpp': ['clangtidy', 'ccls'], 'c': ['clangtidy', 'ccls'] }
" endif

let g:ale_cpp_clang_options = compile_options
let g:ale_cpp_gcc_options = compile_options
let g:ale_cpp_clangtidy_checks = ['*', '-llvm*', '-modernize-use-trailing-return-type']
let g:ale_cpp_ccls_init_options = ccls_options
let g:ale_c_ccls_init_options = ccls_options

" }}}
" Rasi {{{
au BufEnter *.rasi :setlocal commentstring=/*\ %s\ */
"}}}
" Python {{{
au FileType python :set foldmethod=indent

" }}}
" Make {{{
au FileType make setlocal noexpandtab "dont expandtab on Makefile

" }}}
" Vim {{{
au FileType vim :setlocal commentstring=\"\ %s
au FileType vim :set foldmethod=marker

" }}}
" Shell {{{
au FileType sh :setlocal commentstring=#\ %s
au FileType bash :setlocal commentstring=#\ %s

" }}}
" asm {{{
au FileType asm :setlocal commentstring=;\ %s

" }}}
" }}}

" Credit {{{
" https://www.cs.oberlin.edu/~kuperman/help/vim/makefiles.html
" https://github.com/Riatre/dotfilez/blob/master/.vimrc
" }}}

