" Basic {{{
silent function! OSX()
return has('macunix')
endfunction
silent function! LINUX()
return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
return  (has('win32') || has('win64'))
endfunction

if WINDOWS()
  let s:plugDirPath = '~/AppData/Local/nvim/plugged/'
else
  let s:plugDirPath = '~/.local/share/nvim/plugged/'
endif

silent function! CheckPlug(plugName)
let l:plugPath = s:plugDirPath . a:plugName
return isdirectory(expand(l:plugPath))
endfunction
" }}}

" Plugin List {{{
call plug#begin(s:plugDirPath)

Plug 'airblade/vim-gitgutter'
Plug 'chiel92/vim-autoformat'
Plug 'easymotion/vim-easymotion'
Plug 'ervandew/supertab'
Plug 'flazz/vim-colorschemes'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'
Plug 'scrooloose/nerdtree'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Yggdroot/indentLine'

" C {{{
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['cpp'] }
Plug 'vim-scripts/a.vim', { 'for': ['cpp', 'c'] }
Plug 'zchee/deoplete-clang', { 'do': ':UpdateRemotePlugins', 'for': ['cpp', 'c', 'objc', 'objcpp'] }
" }}}

call plug#end()
" }}}

" General {{{
if CheckPlug('vim-colorschemes')
  " color monochrome
  color Tomorrow-Night-Bright
else
  color desert
endif
set background=dark             " Assume a dark background
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
set foldenable                  " Auto fold code
" Highlight problematic whitespace
set listchars=tab:›\ ,trail:•,extends:#,nbsp:·
" }}}

" Formatting {{{
set nowrap                    " Do not wrap long lines
set textwidth=1024            " Do not break line automatically
set autoindent                " Indent at the same level of the previous line
set shiftwidth=2              " Use indents of 2 spaces
set expandtab                 " Tabs are spaces, not tabs
set tabstop=2                 " An indentation every 2 columns
set softtabstop=2             " Let backspace delete indent
set splitright                " Puts new vsplit windows to the right of the current
set splitbelow                " Puts new split windows to the bottom of the current
autocmd FileType python,java setlocal expandtab shiftwidth=4 softtabstop=4
autocmd FileType markdown setlocal wrap
augroup ft_vim                " Fold the vimrc file
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Basic key mapping {{{
let mapleader = ','         " Map leader key to comma
let maplocalleader = ' '    " Map local leader key to space
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
" }}}

" Plugin Settings {{{

" airline {{{
if CheckPlug('vim-airline')
  set laststatus=2
  let g:airline_left_sep='›'
  let g:airline_right_sep='‹'
endif
" }}}

" ale {{{
if CheckPlug('ale')
  let g:ale_sign_column_always = 1
  let g:ale_sign_warning = '▲'
  let g:ale_sign_error = '✗'
  highlight link ALEWarningSign String
  highlight link ALEErrorSign Title
  nmap <silent> <C-k> <Plug>(ale_previous_wrap)
  nmap <silent> <C-j> <Plug>(ale_next_wrap)
  let g:ale_linters = {'c++': 'clang++'}
endif
" }}}

" autoformat {{{
if CheckPlug('vim-autoformat')
  " Format on save
  au BufWrite * :Autoformat
  let g:formatdef_my_cpp = '"clang-format -sort-includes -style=google"'
  let g:formatters_cpp = ['my_cpp']
endif
" }}}

" deoplete {{{
if CheckPlug('deoplete.nvim')
  let g:deoplete#enable_at_startup = 1
  " deoplete-clang {{{
  if CheckPlug('deoplete-clang')
    if OSX()
      let g:deoplete#sources#clang#libclang_path = '/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
      let g:deoplete#sources#clang#clang_header = '/usr/local/include'
    endif
  endif
  " }}}
endif
" }}}

" easymotion {{{
if CheckPlug('vim-easymotion')
  map <Leader> <Plug>(easymotion-prefix)
  " <Leader>f{char} to move to {char}
  map  <Leader>f <Plug>(easymotion-bd-f)
  nmap <Leader>f <Plug>(easymotion-overwin-f)
  " s{char}{char} to move to {char}{char}
  nmap s <Plug>(easymotion-overwin-f2)
  " Move to line
  map <Leader>L <Plug>(easymotion-bd-jk)
  nmap <Leader>L <Plug>(easymotion-overwin-line)
  " Move to word
  map  <Leader>w <Plug>(easymotion-bd-w)
  nmap <Leader>w <Plug>(easymotion-overwin-w)
endif
" }}}

" fzf {{{
if CheckPlug('fzf')

  function! FzfFindFiles()
    let is_git = system('git status')
    if v:shell_error
      :Files
    else
      :GitFiles
    endif
  endfunction

  nnoremap <silent> <C-p> :call FzfFindFiles()<CR>
  nnoremap ; :Buffers<CR>
  nnoremap ' :Marks<CR>
endif
" }}}

" indentLine {{{
if CheckPlug('indentLine')
  let g:indentLine_char = '│'
endif
" }}}

" insearch.vim {{{
if CheckPlug('incsearch.vim')

  function! s:incsearch_config(...) abort
    return incsearch#util#deepextend(deepcopy({
          \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
          \   'keymap': {
          \     "\<CR>": '<Over>(easymotion)'
          \   },
          \   'is_expr': 0
          \ }), get(a:, 1, {}))
  endfunction

  noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
  noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
  noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1}))
endif
" }}}

" nerdtree {{{
if CheckPlug('nerdtree')
  nnoremap  <leader>nt :NERDTreeToggle<CR>
  let NERDTreeShowHidden=1
  " Close vim if the only window left open is a NERDTree
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif
" }}}

" supertab {{{
if CheckPlug('supertab')
  let g:SuperTabDefaultCompletionType = "<c-n>"
endif
" }}}

" tagbar {{{
if CheckPlug('tagbar')
  nnoremap <Leader>tt :TagbarToggle<Cr>
endif
" }}}

" undotree {{{
if CheckPlug('undotree')
  nnoremap <Leader>ut :UndotreeToggle<Cr>
endif
" }}}

" }}}

