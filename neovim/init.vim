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
" Specify a directory for plugins
call plug#begin(s:plugDirPath)

Plug 'airblade/vim-gitgutter'
Plug 'chiel92/vim-autoformat'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'ervandew/supertab'
Plug 'flazz/vim-colorschemes'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'mbbill/undotree'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'neomake/neomake'
Plug 'scrooloose/nerdtree'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tacahiroy/ctrlp-funky'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Xuyuanp/nerdtree-git-plugin'

" C++ {{{
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['cpp'] }
Plug 'vim-scripts/a.vim', { 'for': ['cpp', 'c'] }
Plug 'zchee/deoplete-clang', { 'do': ':UpdateRemotePlugins', 'for': ['cpp', 'c', 'objc', 'objcpp'] }
" }}}

" Initialize plugin system
call plug#end()
" }}}

" General {{{
set background=light             " Assume a dark background
if CheckPlug('vim-colorschemes')
  color monochrome
  " color Tomorrow-Night-Bright
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
set foldenable                  " Auto fold code
" Highlight problematic whitespace
set listchars=tab:›\ ,trail:•,extends:#,nbsp:·
" }}}

" Formatting {{{
set nowrap                    " Do not wrap long lines
set textwidth=1024            " Do not break line automatically
set autoindent                " Indent at the same level of the previous line
set shiftwidth=4              " Use indents of 4 spaces
set expandtab                 " Tabs are spaces, not tabs
set tabstop=4                 " An indentation every four columns
set softtabstop=4             " Let backspace delete indent
set splitright                " Puts new vsplit windows to the right of the current
set splitbelow                " Puts new split windows to the bottom of the current
autocmd FileType cpp,haskell,scala,ruby,yml,vim setlocal expandtab shiftwidth=2 softtabstop=2
autocmd FileType markdown setlocal wrap
augroup ft_vim                  " Fold the vimrc file
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
nmap <localleader>y "*y
vmap <localleader>y "*y
nmap <localleader>d "*d
vmap <localleader>d "*d
nmap <localleader>p "*p
vmap <localleader>p "*p
" Quickly open and reload vimrc file
nnoremap <leader>ev :split $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" }}}

" Plugin Settings {{{

" nerdtree {{{
if CheckPlug('nerdtree')
  nmap <leader>nt :NERDTreeFind<CR>
  nmap <leader>nT :NERDTree<CR>
  " Close vim if the only window left open is a NERDTree
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  let NERDTreeShowHidden=1
endif
" }}}

" vim-indent-guides {{{
if CheckPlug('vim-indent-guides')
  let g:indent_guides_start_level = 2
  let g:indent_guides_guide_size = 1
  let g:indent_guides_enable_on_vim_startup = 1
endif
" }}}

" neomake {{{
if CheckPlug('neomake')
  " When writing a buffer.
  call neomake#configure#automake('w')
  " When writing a buffer, and on normal mode changes (after 750ms).
  call neomake#configure#automake('nw', 750)
  " When reading a buffer (after 1s), and when writing.
  call neomake#configure#automake('rw', 1000)
endif
" }}}

" vim-easymotion {{{
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

" vim-airline {{{
if CheckPlug('vim-airline')
  set laststatus=2
  let g:airline_left_sep=''
  let g:airline_right_sep=''
endif
" }}}

" deoplete {{{
if CheckPlug('deoplete.nvim')
  let g:deoplete#enable_at_startup = 1
endif
" }}}

" deoplete-clang {{{
if CheckPlug('deoplete-clang')
  if OSX()
    let g:deoplete#sources#clang#libclang_path = '/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
    let g:deoplete#sources#clang#clang_header = '/usr/local/include'
  endif
endif
" }}}

" vim-autoformat {{{
if CheckPlug('vim-autoformat')
  " Format on save
  au BufWrite * :Autoformat
  let g:formatdef_my_cpp = '"clang-format -sort-includes -style=google"'
  let g:formatters_cpp = ['my_cpp']
endif
" }}}

" ctrlp {{{
if CheckPlug('ctrlp.vim')
  let g:ctrlp_working_path_mode = 'ra'
  let g:ctrlp_custom_ignore = {
        \ 'dir': '\v[\/]\.(git|hg|svn|idea|stack-work|cabal-sandbox|vscode)$|\v[\/](tmp|target|build|cmake-build-debug)$',
        \ 'file': '\v\.(exe|so|dll|pyc|swp|swo|zip|png|jpg|gif|jpeg|gz|tar|7z)$|\.DS_Store'
        \ }
  if CheckPlug('ctrlp-funky')
    nnoremap <Leader>fu :CtrlPFunky<Cr>
    " narrow the list down with a word under cursor
    nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
  endif
endif
" }}}

" undotree {{{
if CheckPlug('undotree')
  nnoremap <Leader>ut :UndotreeToggle<Cr>
endif
" }}}

" supertab {{{
if CheckPlug('supertab')
  let g:SuperTabDefaultCompletionType = "<c-n>"
endif
" }}}

" }}}

