command! -bang -nargs=* Rg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

lua require('init')

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
autocmd BufWinEnter ?* silent! setlocal formatoptions=crjql

augroup web_fmt 
    autocmd!
    autocmd BufWritePost *.go silen! :!goimports -w %:p
    autocmd BufWritePost *.go redraw!
    autocmd BufWritePost *.purs,*.js,*.tsx,*.jsx,*.ts,*.json,*.yaml,*.yml,*.svelte,*.css,*.html silent! :lua vim.lsp.buf.format()
augroup end

au FileType make setlocal noexpandtab
au FileType markdown setlocal tabstop=2
au FileType markdown setlocal shiftwidth=2
au FileType yaml setlocal tabstop=2
au FileType yaml setlocal shiftwidth=2
au FileType toml setlocal commentstring=#\ %s
au FileType python setlocal foldmethod=indent
au FileType typescript setlocal shiftwidth=2
au FileType typescriptreact setlocal shiftwidth=2
au FileType javascript setlocal shiftwidth=2
au FileType javascriptreact setlocal shiftwidth=2

