" new age Lua config {{{
lua require('init')
" }}}

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
    elseif (&ft == 'php')
        :% w ! php 
    elseif (&ft == "typescript")
        :% w ! tsc && yarn run run
    elseif (&ft == "javascript")
        :% w ! node - 
    elseif (&ft == "go")
        :GoRun
    endif
endfunction

" }}}

" " Files
call EnsureExists("~/.config/nvim/.backup//")
call EnsureExists("~/.config/nvim/.swap//")
call EnsureExists("~/.config/nvim/.undo//")
call EnsureExists("~/.config/nvim/.views//")

augroup AutoSaveFolds
    autocmd!
    autocmd BufWinLeave,BufLeave,BufWritePost ?* nested silent! mkview!
    autocmd BufWinEnter ?* silent! loadview
augroup end

autocmd BufEnter,BufNew *.purs silent! setlocal filetype=purescript
autocmd BufEnter,BufNew *.purs silent! setlocal tabstop=2
autocmd BufEnter,BufNew *.purs silent! setlocal shiftwidth=2
autocmd BufEnter,BufNew *.purs silent! setlocal softtabstop=2

autocmd BufWinEnter ?* silent! setlocal formatoptions=crjql
  " api.nvim_create_autocmd("BufRead", {
  "   pattern = "*",
  "   once = true,
  "   callback = function()
  "     vim.schedule(handle_group_enter)
  "   end,
  " })

" " Languages {{{
" au FileType make setlocal noexpandtab
" au FileType markdown setlocal tabstop=2
" au FileType markdown setlocal shiftwidth=2
" au FileType yaml setlocal tabstop=2
" au FileType yaml setlocal shiftwidth=2
" au FileType toml setlocal commentstring=#\ %s
" au FileType python setlocal foldmethod=indent

" " }}}

