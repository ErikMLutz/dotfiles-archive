" VIM Configuration
" Init {{{
let mapleader = "," " set leader key 
set modelines=1 " tell vim to read the last line of the file for modes
let g:sessions_dir = '~/.vim-sessions' " define folder to save sessions to
"}}}
" Install Plugins {{{

" Install vim-plug if it isn't already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify plugins for installation
call plug#begin('~/.vim/plugged')
  Plug 'airblade/vim-gitgutter' " adds modification indicators to gutter
  Plug 'airblade/vim-rooter' " cd's to project root directory on file open
  Plug 'editorconfig/editorconfig-vim'
  Plug 'itchyny/lightline.vim'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-fugitive'
  Plug 'w0rp/ale'
  Plug 'felixhummel/setcolors.vim'
  Plug 'altercation/vim-colors-solarized'
  Plug 'sjl/badwolf'
  Plug 'sjl/gundo.vim'
  Plug 'tomasr/molokai'
  Plug 'alvan/vim-closetag'
  Plug 'Townk/vim-autoclose'
  Plug 'rking/ag.vim'
  Plug 'ajh17/VimCompletesMe'
  Plug 'vimwiki/vimwiki'
  Plug 'mattn/calendar-vim'
  Plug 'godlygeek/tabular'
  Plug 'plasticboy/vim-markdown'
  Plug 'masukomi/vim-markdown-folding'
  Plug 'suan/vim-instant-markdown'
  Plug 'tbabej/taskwiki'
call plug#end()

" }}}
" Configure Plugins {{{
" ag {{{
let g:ag_working_path_mode="r"
" }}}
" calendar-vim {{{
let g:calendar_options = 'nornu'
function! ToggleCalendar()
  execute ":Calendar"
  if exists("g:calendar_open")
    if g:calendar_open == 1
      execute "q"
      unlet g:calendar_open
    else
      g:calendar_open = 1
    end
  else
    let g:calendar_open = 1
  end
endfunction
" }}}
" closetag {{{ 
let g:closetag_filenames = '*.xml'
" }}}
" filetype {{{
filetype indent on
autocmd Filetype xml setlocal tabstop=2 softtabstop=2 shiftwidth=2
" }}}
" fzf {{{
" Configure FZF plugin
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_layout = { 'down': '~25%' }

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:fzf_files_options =
  \ '--preview "head -10 {}"'
" }}}
" gundo {{{
if has('python3')
    let g:gundo_prefer_python3 = 1
endif
" }}}
" lightline {{{
" Configure LightLine plugin
let g:lightline = {
  \   	'colorscheme': 'wombat',
  \     'active': {
  \         'left': [['mode', 'paste' ], ['filename', 'modified']],
  \         'right': [['lineinfo'], ['percent'], ['git']]
  \     },
  \     'component_function': {
  \         'git': 'fugitive#head'
  \     },
  \ }
" }}}
" rooter {{{
let g:rooter_change_directory_for_non_project_files = ''
let g:rooter_manual_only = 1
" }}}
" taskwiki {{{
let g:taskwiki_markup_syntax = 'markdown'
" }}}
" vimwiki {{{
let g:vimwiki_list = [{
	\ 'path':'~/.vimwiki',
	\ 'path_html':'~/.vimwiki/html/',
	\ 'syntax':'markdown',
	\ 'ext':'.md',
	\ 'custom_wiki2html':'vimwiki_markdown',
	\ 'template_ext':'.tpl'}] 
au BufRead,BufNewFile *.wiki set filetype=vimwiki
au BufRead,BufNewFile *.md set filetype=vimwiki
autocmd FileType vimwiki map <leader>wc :call ToggleCalendar()<CR>
au FileType vimwiki set syntax=markdown
" }}}
" vim-markdown {{{
autocmd FileType vimwiki 
    \ set formatoptions-=q |
    \ set formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*\[-*+]\\s\\+
" }}}
" vim-instant-markdown {{{
let g:instant_markdown_autostart = 0
" }}}
" }}}
" tmux {{{
" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" }}}
" Splitting {{{
set splitbelow
set splitright
" }}}
" Color {{{
syntax enable
autocmd VimEnter * SetColors default solarized molokai badwolf koehler
set background=dark
set t_Co=256
colorscheme badwolf
" }}}
" UI {{{
set laststatus=2 " sets status line to always visible, necessary for Lightline 
set noshowmode " hides Insert, Replace, and Visual statuses, already displayed by Lightline
set noruler " hides line information, already displayed by Lightline
set number " show line numbers
set cursorline " highlight current line
set showmatch " highlight matching [{()}]
set wildmenu " visual autocomplete for command menu
set wildmode=full " autofills first full match
if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif
set backspace=2 " allow backspacing over end of lines
set relativenumber " line numbers relative to current line
" }}}
" Key Mappings {{{
" plugins
map ; :Files<CR>
nnoremap <leader>o :NERDTreeToggle<CR>
nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>u :GundoToggle<CR>
nnoremap <leader>a :Ag 

" toggle folder
nnoremap <space> za

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" move to beginning/end of line
nnoremap B ^
nnoremap E $

" $/^ doesn't do anything
nnoremap $ <nop>
nnoremap ^ <nop>

" edit vimrc/zshrc and load vimrc bindings
nnoremap <leader>ev :vsp ~/.vimrc<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>sz :source ~/.zshrc<CR>

" save and restore session
exec 'nnoremap <Leader>ss :mks! ' . g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
exec 'nnoremap <Leader>sr :so ' . g:sessions_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'

" buffer management
nnoremap <leader>l :ls<CR>
nnoremap  <silent>  <leader><tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap  <silent> <leader><s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

" tab navigation
nnoremap <silent> <tab> gt
nnoremap <silent> <s-tab> gT
nnoremap <silent> <leader>t :tabnew<CR>

" split navigation
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>
nnoremap <silent> <C-s> :vsplit<CR>

" saving and exiting
noremap <silent> <leader>q :q!<CR>
nnoremap <silent> <leader>w :w<CR>

" vimwiki
nmap <Leader>wn <Plug>VimwikiDiaryNextDay
nmap <Leader>wp <Plug>VimwikiDiaryPrevDay

" moving lines
nmap ∆ :m +1<CR>
nmap ˚ :m -2<CR>

" using enter to select items from autocomplete menu without inserting new line
inoremap <expr> <cr> ((pumvisible())?("\<C-y>"):("\<cr>"))
" }}}
" Folding {{{
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent
" }}}
" Tabs and Spaces {{{
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
" }}}
" Searching {{{
set incsearch " search as characters are entered
set hlsearch " highlight matches
set ignorecase " case insensitive searches
set smartcase " case sensitive if upper case letters in search
" }}}
" Backups {{{
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup
" }}}
" File Type Specific Settings {{{
" Python {{{
augroup python
	autocmd!
	autocmd Filetype python tnoremap <ESC> <C-\><C-n>
	autocmd Filetype python nnoremap <C-x> :w<CR>:split<CR>:resize 20<CR>:ter python3 %<CR>
augroup END
" }}}
" }}}
" Misc {{{
set lazyredraw " redraw only when we need to.
set clipboard=unnamed " use the default OSX clipboard
" }}}
" vim:foldmethod=marker:foldlevel=0
