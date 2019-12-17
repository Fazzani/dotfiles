" Don't try to be vi compatible
set nocompatible

set clipboard=unnamed

" Helps force plugins to load correctly when it is turned back on below
filetype on

" [ -f "/usr/local/opt/fzf" ] && set rtp+=/usr/local/opt/fzf

" TODO: Load plugins here (pathogen or vundle)

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on

" TODO: Pick a leader key
" let mapleader = ","

" Security
set modelines=0

" Show line numbers
set number relativenumber

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

" Remap help key.
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Textmate holdouts

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL

" Color scheme (terminal)
"set t_Co=256
"set background=dark
"let g:solarized_termcolors=256
"let g:solarized_termtrans=1
" put https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim
" in ~/.vim/colors/ and uncomment:
"colorscheme dracula
" " Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'tpope/vim-fugitive'                     " git wrapper
Plug 'airblade/vim-gitgutter'                 " shows a git diff in the gutter
Plug 'vim-airline/vim-airline'                " status/tabline
Plug 'vim-airline/vim-airline-themes'         " status/tabline themes
Plug 'mechatroner/rainbow_csv'                " highlighting columns in csv/tsv files
Plug 'editorconfig/editorconfig-vim'          " editorConfig plugin
Plug 'tpope/vim-surround'                     " quoting/parenthesizing made simple
Plug 'chriskempson/base16-vim'                " color schemes, https://chriskempson.github.io/base16/
Plug 'w0rp/ale'                               " asynchronous lint engine
Plug 'dracula/vim', { 'as': 'dracula' }       " theme
Plug 'scrooloose/nerdtree'
Plug '/usr/local/opt/fzf'                      " for mac only becase fzf installed with brew
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
Plug 'scrooloose/nerdcommenter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'morhetz/gruvbox'
Plug 'ericbn/vim-relativize'
Plug 'mhinz/vim-startify'
Plug 'ryanoasis/vim-devicons'


"Plug 'HerringtonDarkholme/yats.vim' " TS Syntax

call plug#end()
" Initialize plugin system
colorscheme dracula

" autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"let NERDTreeShowHidden=0                " NERDTree on ctrl+n
map <silent> <C-n> :NERDTreeToggle<CR>
let g:NERDTreeQuitOnOpen=1              " close NERDTree after a file is opened
let g:NERDTreeAutoDeleteBuffer = 1        " Automatically delete the buffer of the file you just deleted with NerdTree
let NERDTreeHijackNetrw = 0
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" startify===================================
let g:ascii = [
           \ '                                 ________  __ __        ',
            \ '            __                  /\_____  \/\ \\ \       ',
            \ '    __  __ /\_\    ___ ___      \/___//''/''\ \ \\ \    ',
            \ '   /\ \/\ \\/\ \ /'' __` __`\        /'' /''  \ \ \\ \_ ',
            \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \      /'' /''__  \ \__ ,__\',
            \ '    \ \___/  \ \_\ \_\ \_\ \_\    /\_/ /\_\  \/_/\_\_/  ',
            \ '     \/__/    \/_/\/_/\/_/\/_/    \//  \/_/     \/_/    ',
            \ ]
let g:startify_custom_header = startify#center(g:ascii)


autocmd VimEnter *
            \   if !argc()
            \ |   Startify
            \ |   NERDTree
            \ |   wincmd w
            \ | endif

let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1
let g:webdevicons_enable_ctrlp = 1
let g:WebDevIconsOS = 'Darwin'

" CtrlP
let g:ctrlp_working_path_mode = 'ra'
:map <C-f> :CtrlPBuffer<cr>

map <C-a> <esc>ggVG<CR>
set showtabline=2                       " File tabs allways visible
:nmap <C-S-tab> :tabprevious<cr>
:nmap <C-tab> :tabnext<cr>
:nmap <C-t> :tabnew<cr>
:map <C-t> :tabnew<cr>
:map <C-S-tab> :tabprevious<cr>
:map <C-tab> :tabnext<cr>
:map <C-c> :tabclose<cr>
:imap <C-S-tab> <ESC>:tabprevious<cr>i
:imap <C-tab> <ESC>:tabnext<cr>i
:imap <C-t> <ESC>:tabnew<cr>

" don't use arrowkeys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

 " really, just don't
" inoremap <Up>    <NOP>
" inoremap <Down>  <NOP>
" inoremap <Left>  <NOP>
" inoremap <Right> <NOP>

nnoremap <silent> <F2> :RelativizeToggle<CR>
