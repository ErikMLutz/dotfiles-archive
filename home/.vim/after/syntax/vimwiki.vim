if IsVimwikiFile() != 1
	set filetype=markdown
endif
setlocal foldmethod=expr
setlocal foldexpr=MarkdownLevel()  
setlocal expandtab
nnoremap <leader>wc :call ToggleCalendar()<CR>
nnoremap <leader>wn :VimwikiDiaryNextDay<CR>
nnoremap <leader>wp :VimwikiDiaryPrevDay<CR>
" using enter to select items from autocomplete menu without inserting new line
inoremap <buffer><expr> <cr> ((pumvisible())?("\<C-y>"):("\<cr>"))

" Use <TAB> to select the popup menu:
inoremap <buffer><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <buffer><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

