" VIM Configuration
" Init {{{
let mapleader = "," " set leader key 
set modelines=1 " tell vim to read the last line of the file for modes
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

call plug#end()

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
" filetype {{{
filetype indent on
autocmd Filetype xml setlocal tabstop=2 softtabstop=2 shiftwidth=2
" }}}
" closetag {{{ 
let g:closetag_filenames = '*.xml'
" }}}
" gundo {{{
if has('python3')
    let g:gundo_prefer_python3 = 1
endif
" }}}
" ag {{{
let g:ag_working_path_mode="r"
" }}}
" Splitting {{{
set splitbelow
set splitright

nnoremap <leader>j <C-W><C-J>
nnoremap <leader>k <C-W><C-K>
nnoremap <leader>l <C-W><C-L>
nnoremap <leader>h <C-W><C-H>
" }}}
" Color {{{
syntax enable
autocmd VimEnter * SetColors default solarized molokai badwolf koehler
set background=dark
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
" }}}
" Key Mappings {{{
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
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>sz :source ~/.zshrc<CR>

" save session
nnoremap <leader>s :mksession<CR>
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
" }}}
" Searching {{{
set incsearch " search as characters are entered
set hlsearch " highlight matches
" }}}
" Misc {{{
set lazyredraw " redraw only when we need to.
" }}}
" vim:foldmethod=marker:foldlevel=0
