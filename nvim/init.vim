" Basic {{{

" Helper Functions {{{
silent function! IsMacOs()
return has('macunix')
endfunction
silent function! IsLinux()
return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! IsWindows()
return  (has('win32') || has('win64'))
endfunction

if IsWindows()
  let s:nvim_plug_path = '~/AppData/Local/nvim/plugged/'
else
  let s:nvim_plug_path = '~/.local/share/nvim/plugged/'
endif

silent function! CheckPlug(plug_name)
let l:plug_full_path = s:nvim_plug_path . a:plug_name
return isdirectory(expand(l:plug_full_path))
endfunction
" }}}

" }}}

" Plugin List {{{
call plug#begin(s:nvim_plug_path)

" General Plugins {{{

" UI
Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine'

" Coding
Plug 'chiel92/vim-autoformat'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'
Plug 'romainl/vim-qf'
Plug 'tomtom/tcomment_vim'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --all' }
Plug 'w0rp/ale'

" Navigation
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'scrooloose/nerdtree'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'Xuyuanp/nerdtree-git-plugin'

" }}}

" Language Plugins {{{

" CPP
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['cpp'] }

" Go
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': ['go'] }

" }}}

call plug#end()
" }}}

" General {{{
set background=light
if CheckPlug('vim-colorschemes')
  " colorscheme monochrome
  colorscheme Tomorrow-Night-Bright
else
  colorscheme desert
endif
filetype plugin indent on       " Automatically detect file types.
syntax on                       " Syntax highlighting
set history=1024                " Store a ton of history
set mouse=a                     " Automatically enable mouse usage
set mousehide                   " Hide the mouse cursor while typing
set colorcolumn=80              " Highlight 80th column
set cursorline                  " Highlight current line
set showmode                    " Display the current mode
set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set number                      " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Increment search
set hlsearch                    " Highlight search terms
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
" Highlight whitespace
set listchars=tab:›\ ,trail:•,extends:#,nbsp:·
if has('gui_running')
  set guioptions=               " Remove all disturbance
  set guifont='Fira Code':h13,Menlo:h13,Dejavu_Sans_Mono:h13,Consolas:h13
  set guicursor=n-v-c:block-Cursor
  set guicursor+=a:blinkon0
endif
" }}}

" Formatting {{{
set nowrap                    " Do not wrap long lines
set foldenable                " Auto fold code
set textwidth=1024            " Do not break line automatically
set autoindent                " Indent at the same level of the previous line
set shiftwidth=2              " Use indents of 2 spaces
set expandtab                 " Tabs are spaces, not tabs
set tabstop=2                 " An indentation every 2 columns
set softtabstop=2             " Let backspace delete indent
set splitright                " Puts new vsplit windows to the right of the current
set splitbelow                " Puts new split windows to the bottom of the current
augroup filetype_specific     " Fold the vimrc file
  autocmd!
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd FileType python,java setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType markdown setlocal wrap
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Basic key mapping {{{
let mapleader = ','
let maplocalleader = ' '
" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
" Communicating with os clipboard
nnoremap <localleader>y "*y
vnoremap <localleader>y "*y
nnoremap <localleader>d "*d
vnoremap <localleader>d "*d
nnoremap <localleader>p "*p
vnoremap <localleader>p "*p
" Quickly open and reload vimrc file
nnoremap <leader>ev :split $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" Quickly clear highlighting
nnoremap <backspace> :nohl<CR>
" }}}

" Plugin Settings {{{

" airline {{{
if CheckPlug('vim-airline')
  set laststatus=2
endif
" }}}

" ale {{{
if CheckPlug('ale')
  let g:ale_sign_column_always = 1
  nmap <silent> <localleader>j <Plug>(ale_next_wrap)
  nmap <silent> <localleader>k <Plug>(ale_previous_wrap)
  let g:ale_c_build_dir='build'
endif
" }}}

" autoformat {{{
if CheckPlug('vim-autoformat')
  autocmd BufWrite * :Autoformat
  let g:formatdef_my_cpp = '"clang-format -style=file"'
  let g:formatters_cpp = ['my_cpp']
endif
" }}}

" easymotion {{{
if CheckPlug('vim-easymotion')
  map <leader> <Plug>(easymotion-prefix)
  nmap <leader>f <Plug>(easymotion-overwin-f)
  nmap <leader>w <Plug>(easymotion-overwin-w)
endif
" }}}

" fzf {{{
if CheckPlug('fzf.vim')

  nnoremap <localleader>fo :Files<CR>
  nnoremap ; :Buffers<CR>
  nnoremap ' :Ag<CR>

  augroup filetype_fzf
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noshowmode
          \| autocmd BufLeave <buffer> set laststatus=2 showmode
  augroup END
endif
" }}}

" nerdcommenter {{{
if CheckPlug('nerdcommenter')
  let g:NERDSpaceDelims = 1
endif
" }}}

" nerdtree {{{
if CheckPlug('nerdtree')
  nnoremap  <localleader>ft :NERDTreeToggle<CR>
  let NERDTreeShowHidden = 1
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif
" }}}

" supertab {{{
if CheckPlug('supertab')
  let g:SuperTabDefaultCompletionType = "<C-n>"
endif
" }}}

" tagbar {{{
if CheckPlug('tagbar')
  nnoremap <localleader>tt :TagbarToggle<CR>
  let g:tagbar_autofocus = 1
endif
" }}}

" ultisnips {{{
if CheckPlug('ultisnips')
  let g:UltiSnipsExpandTrigger = "<C-j>"
endif
" }}}

" undotree {{{
if CheckPlug('undotree')
  nnoremap <localleader>ut :UndotreeToggle<CR>
endif
" }}}

" youcompleteme {{{
if CheckPlug('YouCompleteMe')
  let g:ycm_global_ycm_extra_conf=expand('<sfile>:p:h') . '/global_extra_conf.py'
  nnoremap gd :YcmCompleter GoTo<CR>
  nnoremap gi :YcmCompleter GetType<CR>
  nnoremap gD :YcmCompleter GetDoc<CR>
endif
" }}}

" }}}

" Language Settings {{{

" CPP {{{
augroup filetype_cpp
  autocmd FileType c,cpp nnoremap <localleader>mb :!cd build && make<CR>
  autocmd FileType c,cpp nnoremap <localleader>mr :!cd build && make run<CR>
  autocmd FileType c,cpp nnoremap <localleader>mt :!cd build && make test<CR>
augroup END
" }}}

" Go {{{
if CheckPlug('vim-go')
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_build_constraints = 1
  let g:go_fmt_command = "goimports"
  augroup filetype_go
    autocmd!
    autocmd FileType go nmap <localleader>mb <Plug>(go-build)
    autocmd FileType go nmap <localleader>mr <Plug>(go-run)
    autocmd FileType go nmap <localleader>mt <Plug>(go-test)
  augroup END
endif
" }}}

" Python {{{
augroup filetype_python
  autocmd!
  autocmd FileType python nnoremap <localleader>mr :!python %<CR>
  autocmd FileType python nnoremap <localleader>mt :!python -m doctest -v %<CR>
augroup END
" }}}

" }}}
