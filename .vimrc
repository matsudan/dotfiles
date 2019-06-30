" Use UFT-8
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set ambiwidth=double

" Set tab/indent behavior
set expandtab
set tabstop=4
set softtabstop=4
set autoindent
set smartindent
set shiftwidth=4

" Highlight dynamically as pattern is typed
set incsearch
" Ignore case of searches
set ignorecase
set smartcase
" Highlight search
set hlsearch

nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

" Set cursor 
set whichwrap=b,s,h,l,<,>,[,],~
" Enable line number
set number
" Highlight current line
set cursorline

nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk

set backspace=indent,eol,start

" Show current mode
set showmode

" command-line completion
set wildmenu

set history=5000

set hidden

" brackets/move settings
set showmatch
source $VIMRUNTIME/macros/matchit.vim

" mouse settings
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
	set ttymouse=sgr
    elseif v:version > 703||v:version is 703 && has('patch632')
    	set ttymouse=sgr
    else
	set ttymouse=xterm2
    endif
endif

" paste settings
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

" Show status line
set laststatus=2

syntax enable
