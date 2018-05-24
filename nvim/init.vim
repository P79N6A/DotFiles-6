" Basic {{{
let s:enabled_languages = ['cpp', 'python', 'go']

" Helper Functions {{{
silent function! CheckLang(lang)
return (index(s:enabled_languages, a:lang) >=# 0)
endfunction

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
Plug 'neomake/neomake'
Plug 'chiel92/vim-autoformat'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'
Plug 'romainl/vim-qf'
Plug 'tomtom/tcomment_vim'

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
if CheckLang('cpp')
  Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['cpp'] }
  Plug 'vim-scripts/a.vim', { 'for': ['cpp', 'c'] }
  Plug 'Shougo/deoplete-clangx', { 'for': ['cpp', 'c'] }
  Plug 'Shougo/neoinclude.vim', { 'for': ['cpp', 'c'] }
endif

" Go
if CheckLang('go')
  Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': ['go'] }
  Plug 'zchee/deoplete-go', { 'do': 'make', 'for': ['go'] }
endif

" Python
if CheckLang('python')
  Plug 'zchee/deoplete-jedi', { 'for': ['python'] }
  Plug 'davidhalter/jedi-vim', { 'for': ['python'] }
endif

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
  set guifont='Fira Code':h12,Menlo:h12,Dejavu_Sans_Mono:h12,Consolas:h13
  set guicursor=n-v-c:block-Cursor
  set guicursor+=a:blinkon0
else
  let &t_Co = 256
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

" autoformat {{{
if CheckPlug('vim-autoformat')
  autocmd BufWrite * :Autoformat
  let g:formatdef_my_cpp = '"clang-format -style=file"'
  let g:formatters_cpp = ['my_cpp']
endif
" }}}

" deoplete {{{
if CheckPlug('deoplete.nvim')
  let g:deoplete#enable_at_startup = 1
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

  nnoremap <C-p> :Files<CR>
  nnoremap ; :Buffers<CR>
  nnoremap ' :Ag<CR>

  augroup filetype_fzf
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noshowmode
          \| autocmd BufLeave <buffer> set laststatus=2 showmode
  augroup END
endif
" }}}

" neomake {{{
if CheckPlug('neomake')
  call neomake#configure#automake('nrwi', 500)
  let g:neomake_open_list = 2

  let linter = neomake#makers#ft#cpp#clang()
  function linter.fn(jobinfo) abort
    let maker = copy(self)
    if filereadable('.clang')
      let maker.args += split(join(readfile('.clang'), "\n"))
    endif
    return maker
  endfunction

  let g:neomake_cpp_clang_maker = linter
endif
" }}}

" nerdcommenter {{{
if CheckPlug('nerdcommenter')
  let g:NERDSpaceDelims = 1
endif
" }}}

" nerdtree {{{
if CheckPlug('nerdtree')
  nnoremap  <leader>nt :NERDTreeToggle<CR>
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
  nnoremap <leader>tt :TagbarToggle<CR>
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
  nnoremap <leader>ut :UndotreeToggle<CR>
endif
" }}}

" }}}

" Language Settings {{{

" CPP {{{
if CheckLang('cpp')
  augroup filetype_cpp
    autocmd FileType c,cpp nnoremap <leader>r :!cd build && make run<CR>
    autocmd FileType c,cpp nnoremap <leader>t :!cd build && make test<CR>
    autocmd FileType c,cpp nnoremap <leader>b :!cd build && make<CR>
  augroup END
endif
" }}}

" Go {{{
if CheckLang('go')
  if CheckPlug('vim-go')
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_build_constraints = 1
    let g:go_fmt_command = "goimports"
    augroup filetype_go
      autocmd!
      autocmd FileType go nmap gd <Plug>(go-def)
      autocmd FileType go nmap <leader>i <Plug>(go-doc)
      autocmd FileType go nmap <leader>b <Plug>(go-build)
      autocmd FileType go nmap <leader>r <Plug>(go-run)
      autocmd FileType go nmap <leader>t <Plug>(go-test)
      autocmd FileType go nmap <leader>e <Plug>(go-rename)
    augroup END
  endif
endif
" }}}

" Python {{{
if CheckLang('python')
  if CheckPlug('jedi-vim')
    let g:jedi#completions_enabled = 0
    let g:jedi#force_py_version = 3
    let g:jedi#goto_definitions_command = "gd"
    let g:jedi#documentation_command = "<leader>i"
    let g:jedi#rename_command = "<leader>e"
  endif
  augroup filetype_python
    autocmd!
    autocmd FileType python nnoremap <leader>r :!python3 %<CR>
    autocmd FileType python nnoremap <leader>t :!python3 -m doctest -v %<CR>
  augroup END
endif
" }}}

" }}}
