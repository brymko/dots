" * [word], g* [partial word], 
"
" [I show lines with matching word under cursor
" Jump to next empty line: }
" Jump to prev empty line: {
"
" Jump to begin of block: [{
" Jump to end of block: ]}
"
" Jump to end of sentence: )
" Jump to beg of sentence: (
"
" Jump to end of section: ]]
" Jump to beg of section: [[
"
" Jump to top of window: H
" Jump to middle: M
" Jump to bottom: L
"
" Jump to matching delim: %
"
" Jump to specified tag: :tag...
" Jump to older tag: <C-t>
" Jump to tag definition: <C-]>

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

" Scripts {{{
function! Preserve(cmd)  "{{{
    let _s=@/
    let l = line(".")
    let c = col(".")

    execute a:cmd

    let @/=_s
    call cursor(l, c)
endfunction "}}}
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
        :!clear; make
    elseif (&ft == 'tex')
        :!clear; zathura %:r.pdf >/dev/null 2>&1 &<cr><cr>
    elseif (&ft == 'rust')
        :!clear; cargo run 
    elseif (&ft == 'python')
        :% w ! python
    elseif (&ft == 'sh')
        :% w ! sh
    endif
endfunction " }}}
" TODO: ReplaceWordInProject
function! ReplaceInProject(...)
    if a:0 > 1
        let what = escape(a:1, '"''')
        let to = escape(a:2, '"''')
        let replace_str = join(["xargs sed -i 's/", what, "/", to, "/'"], "")
        let cmd = join(["!rg -l", what, "|", replace_str], ' ')
        " if this is silent, editor view gets broken
        echo cmd
    endif
endfunction
function! ModeCurrent() abort " {{{
    let l:modecurrent = mode()
    let l:modelist = toupper(get(g:currentmode, l:modecurrent, 'V·Block '))
    let l:current_status_mode = l:modelist
    return l:current_status_mode
endfunction " }}}
" }}}

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
" set showmatch
set diffopt=filler,vertical
" set lazyredraw
set cursorline

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
set timeoutlen=400
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
set foldmethod=manual

"" searching
set ignorecase
set smartcase
set incsearch
set hlsearch
set path+=**

"" Buffers
" :sp -> split, :vs -> vsplit
set splitright splitbelow
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

"" viminfo
let &runtimepath.=',$HOME/.confg/vim'
set viminfo=<800,'10,/50,:100,h,f0,n~/.config/vim/.viminfo
"         | |    |   |   |    | |  + viminfo file path
"         | |    |   |   |    | + file marks 0-9,A-Z 0=NOT stored
"         | |    |   |   |    + disable 'hlsearch' loading viminfo
"         | |    |   |   + command-line history saved
"         | |    |   + search history saved
"         | |    + files marks saved
"         | + lines saved each register (old name for <, vi6.2)
"         + save/restore buffer list

"" views
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

    " comment lines with gc and gcc
    Plug 'tpope/vim-commentary' 
    " yiw / cs]) ... etc
    Plug 'tpope/vim-surround'
    " shellscript if to fi complete
    Plug 'tpope/vim-endwise'
    " auto close brakets on enter 
    Plug 'rstacruz/vim-closer'
    " Plug 'cohama/lexima.vim' " vim-endwise && vim-closer already do this could be great with enough configuration
    Plug 'ap/vim-buftabline'
    
    " Language stuff
    " Plug 'dense-analysis/ale' loaded after settings :/
    Plug 'rust-lang/rust.vim'


    " language colors
    " Plug 'sheerun/vim-polyglot' " get colors from here 
    Plug 'arzg/vim-rust-syntax-ext'
    Plug 'octol/vim-cpp-enhanced-highlight'

    " colortheme
    Plug 'arzg/vim-colors-xcode'

    Plug 'junegunn/fzf', { 'do': './install --bin' }
    Plug 'junegunn/fzf.vim'


    "" Plugin conf
    " 'fzf'
    
    " 'dense-analysis/ale'
    let g:ale_cache_executable_check_failures = 1
    let g:ale_completion_delay = 50
    let g:ale_completion_enabled = 1
    let g:ale_completion_max_suggestions = 10
    let g:ale_echo_cursor = 0
    let g:ale_echo_delay = 9999999999999999999999999999
    let g:ale_fix_on_save = 1
    let g:ale_history_enabled = 0
    let g:ale_lint_delay = 9999999999999999999999999999
    let g:ale_lint_on_enter = 1
    let g:ale_lint_on_save = 1
    let g:ale_lint_on_text_changed = 0
    let g:ale_lint_on_insert_leaver = 0
    let g:ale_linters_explicit = 1
    let g:ale_max_signs = 20


    let g:ale_pattern_options = {
            \ '\.\(h\|hpp\|H\|HPP\)$': { 'ale_linters': { 'cpp': ['clang', 'ccls'], 'c': ['clang', 'ccls'] } },
            \ '\.\(c\|cc\|cpp\|cppm\|cxx\|C\|CC\|CPP\|CPPM\|CXX\)$': { 'ale_linters': { 'cpp': ['clangtidy', 'ccls'], 'c': ['clangtidy', 'ccls'] } },
            \ }
    let g:ale_cpp_ccls_init_options = { 'cache': { 'directory': '/tmp/ccls/cache' } }
    let g:ale_c_ccls_init_options = { 'cache': { 'directory': '/tmp/ccls/cache' } }
    let g:ale_cpp_clangtidy_checks = ['*', '-llvm*', '-modernize-use-trailing-return-type', '-fuchsia-default*']
    let compile_options = '-std=c++2a -Wall -Wextra -Wconversion -Wunreachable-code 
                                \ -Wuninitialized -pedantic -Wvla -Wextra-semi'
    let g:ale_cpp_clang_options = compile_options
    let g:ale_cpp_gcc_options = compile_options

    let g:ale_linters = {
                \ 'rust': ['cargo', 'rls'],
                \}
    let g:ale_fixers = {
                \ 'rust': ['rustfmt'],
                \}

    let g:ale_rust_cargo_avoid_whole_workspace = 1
    let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
    let g:ale_rust_rls_config = {
                        \ 'rust': {
                        \       'clippy_preference': 'on'
                        \   }
                        \ }

    
    " octol/vim-cpp-enhanced-highlight
    let g:cpp_class_scope_highlight = 1
    let g:cpp_member_variable_highlight = 1
    let g:cpp_concepts_highlight = 1
    let g:cpp_posix_standart = 1
    let c_no_curly_error = 1

    Plug 'dense-analysis/ale' 
    call plug#end()
    colorscheme xcodedarkhc
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
nnoremap <leader>t :!clear; cargo run --release<cr>

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
inoremap <C-v> <C-o>:set paste<CR><c-r>=substitute(system('xclip -o -selection clipboard'),'[\r\n]*$','','')<cr><C-o>:set nopaste<cr>

" misc
nnoremap q: <nop>
cnoremap sudow w !sudo tee % > /dev/null<CR>
command -nargs=+ Rp call ReplaceInProject(<f-args>)
nnoremap \ :Rp 

" Plugins
nnoremap gd :ALEGoToDefinition<cr>
nnoremap gtd :ALEGoToTypeDefinition<cr>
nnoremap gr :ALEFindReferences<cr>
nnoremap gh :ALEHover<cr>
nnoremap ga :ALESymbolSearch 
nnoremap gw :ALEDetail<cr>
nnoremap <leader>l :ALEToggle<cr>
nnoremap <C-f> :Rg<cr>


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
    " let statusline .= "%2* %{GitBranch()} %)"               " Current Branch
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
set showcmd
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
" }}}
" Rust {{{
au FileType rust :setlocal commentstring=//\ %s
au FileType rust :set foldmethod=manual


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

