" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" init.vim - cluster (headless Ubuntu) version
" Removed: LaTeX/vimtex, document compilation + viewers, bib mappings,
"          auto-commit autocmds, and desktop/X/mutt hooks.
" Changed: clipboard routed through OSC 52 for use over SSH.
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Bootstrap vim-plug on first launch (needs outbound network).
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'https://github.com/dylnmc/synstack.vim.git' " ctrl-p under word to see syntax
Plug 'preservim/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'jreybert/vimagit'
Plug 'lukesmithxyz/vimling'
Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
Plug 'JuliaEditorSupport/julia-vim'
" markdown
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'dkarter/bullets.vim' " bullets in markdown
let g:bullets_enabled_file_types = [
    \ 'markdown'
    \]
" Remove the + bullet so * always indents as *
let g:bullets_outline_levels = ['ROM', 'ABC', 'num', 'abc', 'rom', 'std-', 'std*']

" lightline
Plug 'itchyny/lightline.vim'
let g:lightline = {
\ 'colorscheme': 'lightline_pink',
\ 'mode_map': {
\ 'n' : '普通的',
\ 'i' : '插入',
\ 'R' : 'R',
\ 'v' : '視覺的',
\ 'V' : 'VL',
\ "\<C-v>": 'VB',
\ 'c' : '命令',
\ 's' : 'S',
\ 'S' : 'SL',
\ "\<C-s>": 'SB',
\ 't': 'T',
\},
\   'active': {
\    'left' :[[ 'mode'],
\             [ 'readonly', 'filename', 'modified' ]],
\    'right':[[ 'filetype', 'percent', 'lineinfo' ], [ 'cocstatus' ]]
\   },
\}
call plug#end()

" lightline colors
let s:base3 = '#ffffff'
let s:base23 = '#ffffff'
let s:base2 = '#ffffff'
let s:base1 = '#ffffff'
let s:base0 = '#ffffff'
let s:base00 = '#862ca0'
let s:base01 = '#862ca0'
let s:base02 = '#906a9b'
let s:base023 = '#862ca0'
let s:base03 = '#002451'
let s:red = '#ff9da4'
let s:orange = '#ffc58f'
let s:yellow = '#ffeead'
let s:green = '#d1f1a9'
let s:cyan = '#99ffff'
let s:blue = '#ebbbff'
let s:magenta = '#87ffff'
let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [ [ s:base023, s:blue ], [ s:base3, s:base01 ] ]
let s:p.normal.right = [ [ s:base02, s:base1 ], [ s:base2, s:base01 ] ]
let s:p.inactive.right = [ [ s:base02, s:base0 ], [ s:base1, s:base01 ] ]
let s:p.inactive.left =  [ [ s:base02, s:base0 ], [ s:base00, s:base03 ] ]
let s:p.insert.left = [ [ s:base023, s:green ], [ s:base3, s:base01 ] ]
let s:p.replace.left = [ [ s:base023, s:orange ], [ s:base3, s:base01 ] ]
let s:p.visual.left = [ [ s:base023, s:magenta ], [ s:base3, s:base01 ] ]
let s:p.normal.middle = [ [ s:base1, s:base02 ] ]
let s:p.inactive.middle = [ [ s:base0, s:base02 ] ]
let s:p.tabline.left = [ [ s:base2, s:base01 ] ]
let s:p.tabline.tabsel = [ [ s:base2, s:base03 ] ]
let s:p.tabline.middle = [ [ s:base01, s:base1 ] ]
let s:p.tabline.right = copy(s:p.normal.right)
let s:p.normal.error = [ [ s:base023, s:red ] ]
let s:p.normal.warning = [ [ s:base023, s:yellow ] ]
let g:lightline#colorscheme#lightline_pink#palette = lightline#colorscheme#fill(s:p)

" for lightline
set runtimepath+=~/.config/nvim/plugged/lightline
" colorscheme
colorscheme vim

set title
set mouse=a " mouse enabled
set hlsearch
set clipboard+=unnamedplus
set noshowmode "showing visual/insert mode
set noruler "don't show the cursor position all the time
set cursorline "emphasize current cursor line
set laststatus=2
set noshowcmd
set ignorecase
set incsearch  " do incremental searching
set history=50 " keep 50 lines of command line history
set backup     " keep a backup file
" tell vim where to put its backup files (this dir must exist)
set backupdir=~/dox/vim_temp
" tell vim where to put swap files
set dir=~/dox/vim_temp
set smartcase " ignore ignorecase if search contains uppercase
set wrap
set wrapmargin=0
set ma

" Over SSH on a headless node: copy out via OSC 52, but never query the
" terminal on paste (that round-trip is what causes the lag/hang).
if !empty($SSH_TTY)
lua << EOF
local osc52 = require('vim.ui.clipboard.osc52')
local function paste()
  return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
end
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = osc52.copy('+'),
    ['*'] = osc52.copy('*'),
  },
  paste = {
    ['+'] = paste,
    ['*'] = paste,
  },
}
EOF
endif

" Some basics:
	nnoremap c "_c
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber
" Enable autocompletion:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
	vnoremap . :normal .<CR>
" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>
" Splits open at the bottom and right (saner than the vim defaults):
	set splitbelow splitright
" source vimrc keybind
	map <leader>sc :source $MYVIMRC<CR>

" Nerd tree
	map <leader>n :NERDTreeToggle<CR>
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
	let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Replace ex mode with gq
	map Q gq

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'wiki': 'markdown','.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	map <leader>v :VimwikiIndex<CR>
	let g:vimwiki_list = [{'path': '~/dox/wiki', 'syntax': 'markdown', 'ext': '.md'}]
	let g:vimwiki_global_ext = 0 " don't set all .md files as vimwiki type
	autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
	au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn} setlocal syntax=markdown
	" open folds by default
	au BufRead * normal zR

" Location list navigation
	map <leader>. :lnext<CR>
	map <leader>, :lprev<CR>

" Save file as sudo on files that require root permission (no-op without sudo)
	cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Automatically deletes all trailing whitespace and newlines at end of file on
" save, and resets cursor position.
	autocmd BufWritePre * let currPos = getpos(".")
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePre * %s/\n\+\%$//e
	autocmd BufWritePre *.[ch] %s/\%$/\r/e " add trailing newline for ANSI C standard
	autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

" Turns off highlighting on the changed bits of code in a diff so the changed
" text stands out and stays readable.
if &diff
    highlight! link DiffText MatchParen
endif

" Function for toggling the bottom statusbar:
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
" nnoremap <leader>h :call ToggleHiddenAll()<CR>

" Make \w toggle through the three wrapping modes.
function ToggleWrap()
 if (&wrap == 1)
   if (&linebreak == 0)
     set linebreak
   else
     set nowrap
   endif
 else
   set wrap
   set nolinebreak
 endif
endfunction

map <leader>w :call ToggleWrap()<CR>

" disable \ww to open vimwiki
	map <leader>ww <Nop>

" Automatically change the current working directory
	set autochdir

" split up line by sentences
	map <leader>ss :s/\.\ /\.\ \r/g<CR>

function! ShowColourSchemeName()
    try
        echo g:colors_name
    catch /^Vim:E121/
        echo "default"
    endtry
endfunction

" Visual selection colors
hi Visual guifg=#000000 guibg=#ff9500 gui=NONE cterm=bold ctermbg=13 ctermfg=15

" truecolor (needs a truecolor-capable terminal + correct terminfo)
set termguicolors
