set nobackup         " Auto backup
set nowritebackup    " Backup overwrite
set noswapfile       " Nerp
set fileformats=unix,dos,mac " Use Unix as the standard file type

" My autocommands {{{
" ---------------
augroup vimrc_general
	autocmd!

	au BufWinLeave ?* mkview            " Save fold
	au BufWinEnter ?* silent! loadview   " load fold

	" Check if file changed when its window is focus, more eager than 'autoread'
	autocmd WinEnter,FocusGained * checktime

	" Update filetype on save if empty
	autocmd BufWritePost * nested
		\ if &l:filetype ==# '' || exists('b:ftdetect')
		\ |   unlet! b:ftdetect
		\ |   filetype detect
		\ | endif

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	autocmd BufReadPost *
		\ if &ft !~ '^git\c' && ! &diff && line("'\"") > 0 && line("'\"") <= line("$")
		\|   execute 'normal! g`"zvzz'
		\| endif

	" Disable paste and/or update diff when leaving insert mode
	autocmd InsertLeave *
		\ if &paste | setlocal nopaste mouse=a | echo 'nopaste' | endif |
		\ if &l:diff | diffupdate | endif

	autocmd FileType help
		\ setlocal iskeyword+=: | setlocal iskeyword+=# | setlocal iskeyword+=-

	autocmd FileType crontab setlocal nobackup nowritebackup

	autocmd FileType vim setlocal foldmethod=marker

	autocmd FileType gitcommit setlocal spell

	autocmd FileType gitcommit,qfreplace setlocal nofoldenable

	autocmd FileType python,pyrex setlocal expandtab tabstop=4
	autocmd FileType sh setlocal expandtab tabstop=2

	" fixes unindenting comments
	autocmd FileType python,pyrex setlocal nosmartindent

	autocmd FileType markdown
				\ setlocal spell expandtab autoindent
				\ formatoptions=tcroqn2 comments=n:>

	if executable('yapf')
		autocmd FileType python setlocal formatprg=yapf
	endif

	autocmd BufNewFile,BufRead *.yapf set filetype=cfg

	" TODO: if winwidth < 80, turn wrap off if it's on
	" TODO: display tabs and buffers in tabline

augroup END
" }}}

let g:python_highlight_all = 1
" au FileType python syn keyword pythonDecorator True None False self
