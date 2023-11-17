syntax on           " enable syntax processing
filetype on         " enable filetype detection

" Spaces & Tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " Insert 4 spaces on a tab
set expandtab       " tabs are spaces, mainly because of python
set autoindent      " automatically indent when creating a new line
set smartindent     " automatically indents based on the file type

" UI Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark     " set dark mode
set number              " show line numbers
set relativenumber      " show relative numbering
set showcmd             " show command in bottom bar
set noshowmode          " hide current mode
filetype indent on      " load filetype-specific indent files
filetype plugin on      " load filetype specific plugin files
set wildmenu            " visual autocomplete for command menu
set showmatch           " highlight matching [{()}]
set laststatus=2        " Show the status line at the bottom
set mouse+=a            " A necessary evil, mouse support
set noerrorbells visualbell t_vb=    " Disable annoying error noises
set signcolumn=yes      " Set sign column so git changes are always visible
set splitbelow          " Open new vertical split bottom
set splitright          " Open new horizontal splits right
set linebreak           " Have lines wrap instead of continue off-screen
set scrolloff=15        " Keep cursor in approximately the middle of the screen
set updatetime=100      " Some plugins require fast updatetime
set ttimeoutlen=0       " No timeout after keystrokes
set ttyfast             " Improve redrawing
set nobackup            " No backup files
set nowritebackup       " No backup files
set encoding=UTF-8      " Text encoding
set cmdheight=2         " More space for displaying messages
set shortmess+=c        " Don't pass messages to ins-completion-menu
set directory=~/.vim/swap/ " Custom directory for swap files

" Buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hidden              " Allows having hidden buffers (not displayed in any window)

" Sensible stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set backspace=indent,eol,start     " Make backspace behave in a more intuitive way
nmap Q <Nop>
" 'Q' in normal mode enters Ex mode. You almost never want this.
" Unbind for tmux
map <C-a> <Nop>
map <C-x> <Nop>

" Searching (/)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase          " Ignore case in searches by default
set smartcase           " But make it case sensitive if an uppercase is entered
" Ignore files for completion
set wildignore+=*/.git/*,*/tmp/*,*.swp

" Undo (u)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set undofile " Maintain undo history between sessions
set undodir=~/.vim/undo/ " Custom directory for undo files

" Folding (zo/zc to open and close folds)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldenable          " enable folding
set foldmethod=syntax   " default fold method
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max

" Movement
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader
let mapleader=" "

" Move vertically by visual line
nnoremap j gj
nnoremap k gk

" Jump to start and end of line using the home row keys
map H ^
map L $

" Split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

