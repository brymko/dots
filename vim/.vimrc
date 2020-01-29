
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
function! EnsureExists(path) " {{{
    if !isdirectory(expand(a:path))
        call mkdir(expand(a:path))
    endif
endfunction "}}}
function! EnsureVimPlug() " {{{
    if empty(glob("~/.vim/autoload/plug.vim"))
        silent! execute '!curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
        autocmd VimEnter * silent! PlugInstall
    endif
endfunction "}}}

" }}}

" Vim Core {{{


" encodings
set nocompatible
set t_Co=256
set encoding=utf-8

" graphicals
set noruler
set number
set showmatch
set diffopt=filler,horizontal
"set cursorline
set autoindent

" scrolling
" set wrap
set nowrap
" set wrapmargin=1
set scrolloff=5
set sidescroll=5

" spaces & tabs
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smarttab
set expandtab

" misc
filetype plugin on
filetype plugin indent on
set noerrorbells
set history=10000
set t_BE=
set ttyfast

" text handling
set autoread
set formatoptions-=tcro
set textwidth=0 " disable auto enter after end of editor
set backspace=2
filetype indent on
syntax on
let skip_defaults_vim=1

" folding
set foldenable
set foldlevelstart=-1
set foldnestmax=10
set foldmethod=marker

" searching
set ignorecase
set smartcase
set incsearch
set hlsearch
set path+=**

" Buffers
set splitbelow splitright

" files
call EnsureExists("~/.config/vim/.backup//")
call EnsureExists("~/.config/vim/.swap//")
call EnsureExists("~/.config/vim/.undo//")
call EnsureExists("~/.config/vim/.views//")

set backupdir=~/.config/vim/.backup//
set directory=~/.config/vim/.swap//
set undodir=~/.config/vim/.undo//
set viewdir=~/.config/vim/.views//

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
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview
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

" visual mode
vnoremap < <gv
vnoremap > >gv
vnoremap <C-c> :'<,'> w ! xclip -i -selection clipboard<CR><CR>

" misc
cnoremap sudow w !sudo tee % > /dev/null<CR>

" }}}

" Status Line {{{
au InsertEnter * hi statusline guifg=black guibg=#d349e8 ctermfg=black ctermbg=magenta
au InsertLeave * hi statusline guifg=black guibg=#c5ff00 ctermfg=black ctermbg=cyan

hi statusline guifg=black guibg=#c5ff00 ctermfg=black ctermbg=cyan
hi User1 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#adadad

let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'Visual',
    \ '^v' : 'V·Block',
    \ '^V' : 'V·Block',
    \ ' ^V': 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

set laststatus=2
set noshowmode
set statusline=
"set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode
set statusline+=%1*\ %n\                                 " Buffer number
set statusline+=%1*\ %<%f%m%r%h%w\                       " File path, modified, readonly, helpfile, preview
set statusline+=%3*                                      " Separator
set statusline+=%2*\ %Y                                  " FileType
set statusline+=%3*                                      " Separator
set statusline+=%2*\ %{''.(&fenc!=''?&fenc:&enc).''}     " Encoding
set statusline+=\ %{&ff}                                 " FileFormat
set statusline+=%=                                       " Right Side
set statusline+=%2*\ col:\ %02v\                         " Colomn number
set statusline+=%3*                                      " Separator
set statusline+=%1*\ ln:\ %02l/%L\ (%p%%)\               " Line number / total lines, percentage of document
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode

" }}}

" Plugins {{{

call EnsureVimPlug()
call plug#begin('~/.config/vim/plugged')

"
if !has('nvim')
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
if !has('nvim')

endif

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'rstacruz/vim-closer'
" Plug 'cohama/lexima.vim' " could be great with enough configuration
" Plug 'thirtythreeforty/lessspace.vim " Strip trailing ws version control friendly
Plug 'tmux-plugins/vim-tmux'
Plug 'mihaifm/bufstop' " needs configuration / stop using :bn :bp
"Plug 'sheerun/vim-polyglot'
Plug 'dense-analysis/ale'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/deoplete-clangx'
Plug 'deoplete-plugins/deoplete-jedi'

Plug 'jaredgorski/spacecamp'

call plug#end()

colorscheme spacecamp

" Plugin conf

let g:deoplete#enable_at_startup=1
let g:deoplete#enable_at_startup = 1
highlight Pmenu ctermbg=8 guibg=#606060
highlight PmenuSel ctermbg=1 guifg=#dddd00 guibg=#1f82cd
highlight PmenuSbar ctermbg=0 guibg=#d6d6d6


" }}}

" Languages {{{
" C/C++ {{{
au BufEnter *.c :setlocal commentstring=/*\ %s\ */
au BufEnter *.cpp :setlocal commentstring=/*\ %s\ */
au BufEnter *.cc :setlocal commentstring=/*\ %s\ */
au BufEnter *.h :setlocal commentstring=/*\ %s\ */
au BufEnter *.hpp :setlocal commentstring=/*\ %s\ */

au BufEnter *.c :set foldmethod=syntax
au BufEnter *.cpp :set foldmethod=syntax
au BufEnter *.cc :set foldmethod=syntax
au BufEnter *.h :set foldmethod=syntax
au BufEnter *.hpp :set foldmethod=syntax
" }}}
" Rasi {{{
au BufEnter *.rasi :setlocal commentstring=/*\ %s\ */
"}}}
" Python {{{
au BufEnter *.py :set foldmethod=indent

" }}}
" Make {{{
au FileType make setlocal noexpandtab "dont expandtab on Makefile
" }}}
" Vim {{{
au BufEnter .vimrc :setlocal commentstring=\"\ %s

" }}}
" Shell {{{
au BufEnter *.sh :setlocal commentstring=#\ %s
au BufEnter *.bash :setlocal commentstring=#\ %s

" }}}
" asm {{{
au FileType asm :setlocal commentstring=;\ %s

" }}}
" }}}

