""""""""""""""" CUSTOM SHORTCUTS

" <tab> - auto complete

" F8                                - build      (remember to chmod u+x build.sh on unix)
" F9                                - trim whitespaces (the warning only comes up or goes away after saving)
" F10                               - cycle through .c/.cpp/.cc and .h/.hpp (only .c and .h works for now)
" F12                               - nerdtree
" Ctrl + -                          - resize minus
" Ctrl + 0                          - resize default (h:12)
" Ctrl + =                          - resize plus
" the leader key is ",".
" :CtrlSF {pattern} /path/to/dir

" check how to use the easy-align plugin here: https://github.com/junegunn/vim-easy-align
" vipga, gaip

" OBS: This setup auto converts files to utf-8 LF, be careful when doing line colaborating for projects that uses a different convention

""""""""""""""" HOW TO INSTALL NEOVIM

" how to install it on windows:
"
" 1 - install git, ripgrep (put in your path) and liberation mono
" 2 - put this init.vim on: C:\Users\<user>\AppData\Local\nvim
" 3 - download neovim and put it on your path
" 4 - download neovide and use neovide.exe
"
" OBS: the <user> is hardcoded to LEO, you have change it in the plug.vim download section of this file if you are using other windows machine.
"
" ================================
"
" how to install it on linux:
"
" 1 - install: ttf-liberation git neovim neovide curl xsel xclip ripgrep
" 2 - put this init.vim on ~\.config\nvim
" 3 - use it from neovide
"

""""""""""""""" SOME IDENTATION STUFF

" we should encapsulate these into functions so we can acomodate other identation styles

filetype plugin indent on
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent
set autoindent

set cindent
" set cino+==t0 " this makes identation on switch/case to be close to allman's style
set cino+=t0 " this makes identation on switch/case to be close to allman's style, also the return type in a different line works

" auto closing brakets

inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O


""""""""""""""" PLUGINS BS

" initialization of the plug.vim plugin

if has('win32')
    if empty(glob('C:\Users\LEO\AppData\Local\nvim-data\site\autoload\plug.vim'))
        silent !curl -fLo C:\Users\LEO\AppData\Local\nvim-data\site\autoload\plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        source C:\Users\LEO\AppData\Local\nvim-data\site\autoload\plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
elseif has('unix')
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
        silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        source ~/.local/share/nvim/site/autoload/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endif

" Plugins will be downloaded under the specified directory.
call plug#begin()

" Declare the list of plugins.
Plug 'preservim/nerdtree'
Plug 'junegunn/vim-easy-align'
Plug 'dyng/ctrlsf.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

if has('win32')
    function NERDTreeToggleAndRefresh()
        " silent! :CloseOutOfFocusTerm()
        ccl " closes quickfix window
        :NERDTreeToggle c:\dev
        if g:NERDTree.IsOpen()
            :NERDTreeRefreshRoot
        endif
    endfunction
elseif has('unix')
    function NERDTreeToggleAndRefresh()
        " silent! :CloseOutOfFocusTerm()
        ccl " closes quickfix window
        :NERDTreeToggle ~/dev
        if g:NERDTree.IsOpen()
            :NERDTreeRefreshRoot
        endif
    endfunction
endif

" NERDTree config
map <silent> <F12> :call NERDTreeToggleAndRefresh()<CR>

inoremap <F12> <Esc>:normal<CR> <F12><CR>

" let NERDTreeShowBookmarks=1

" vim-easy-align config
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Use Ripgrep when available
if executable("rg")
	"set grepprg=rg\ --color\ never
    set grepprg=rg
endif

""""""""""""""" BUILD SYSTEM

" OBS: for build/run.sh files on linux to work, you need to chmod u+x <script>.sh first, and of couse put #!/bin/bash on the first line of the script

""" BUILD

set errorformat+=\\\ %#%f(%l\\\,%c):\ %m
set errorformat+=\\\ %#%f(%l)\ :\ %#%t%[A-z]%#\ %m
set errorformat+=\\\ %#%f(%l\\\,%c-%*[0-9]):\ %#%t%[A-z]%#\ %m

if has('win32')
    function Build()
        " silent! :CloseOutOfFocusTerm()
        silent! execute ":NERDTreeClose"
        cclose
        wa
        set makeprg=build.bat
        "save the current working directory so we can come back
        let l:starting_directory = getcwd()

        "get the directory of the currently focused file
        let l:curr_directory = expand('%:p:h')
        "move to the current file
        execute "cd " . l:curr_directory

        while 1
            "check if build.bat exists in the current directory
            if filereadable("build.bat")
                "run make and exit
                silent! make
                silent! botright vertical copen 120
                break
            elseif l:curr_directory ==# "/" || l:curr_directory =~# '^[^/]..$'
                "if we've hit the top level directory, break out
                echo "The build.bat file was not found!"
                break
            else
                "move up a directory
                cd ..
                let l:curr_directory = getcwd()
            endif
        endwhile

        " reset directory
        execute "cd " . l:starting_directory
    endfunction
elseif has('unix')
    function Build()
        " silent! :CloseOutOfFocusTerm()
        silent! execute ":NERDTreeClose"
        cclose
        wa
        set makeprg=./build.sh
        "save the current working directory so we can come back
        let l:starting_directory = getcwd()

        "get the directory of the currently focused file
        let l:curr_directory = expand('%:p:h')
        "move to the current file
        execute "cd " . l:curr_directory

        while 1
            "check if build.bat exists in the current directory
            if filereadable("build.sh")
                "run make and exit
                silent! make
                silent! botright vertical copen 120
                break
            elseif l:curr_directory ==# "/" || l:curr_directory =~# '^[^/]..$'
                "if we've hit the top level directory, break out
                echo "The build.sh file was not found!"
                break
            else
                "move up a directory
                cd ..
                let l:curr_directory = getcwd()
            endif
        endwhile

        " reset directory
        execute "cd " . l:starting_directory
    endfunction

endif

set switchbuf=useopen,split

silent! E788
silent! E492

map <silent> <F8> :call Build() <CR>
inoremap <F8> <Esc> :normal<CR> <F8><CR>

""""""""""""""" NEOVIDE STUFF

if exists("g:neovide")
    let g:neovide_scale_factor = 1.0
    map <silent> <C-=> :let g:neovide_scale_factor = g:neovide_scale_factor + 0.1<CR>
    map <silent> <C--> :let g:neovide_scale_factor = g:neovide_scale_factor - 0.1<CR>
    map <silent> <C-0> :let g:neovide_scale_factor = 1<CR>
endif

" to disable neovide's cursor animation:
let g:neovide_cursor_animation_length = 0.00

" disables split and other similar ones animation lenght
let g:neovide_position_animation_lenght = 0.01

""""""""""""""" GENERAL CONFIG

" on both windows and linux you need to install the liberation mono font (install the fonts-liberation package)
set guifont=Liberation\ Mono:h12

if has('win32')
    lang en " by default nvim uses the systemlocale language
endif

syntax on
set encoding=utf-8

set fileformats=unix,dos

autocmd BufWrite * :set ff=unix " auto saves into LF
set viminfofile=~/.vim/viminfo
set clipboard^=unnamed,unnamedplus

let mapleader = ","

set splitright
set textwidth=0 wrapmargin=0 " removes the linesplit limit
set guioptions-=m " removes the menu bar
set guioptions-=T " removes the toolbar
set guioptions-=r " removes the right scrollbar
set guioptions-=L " removes the left scrollbar

set wildmenu " makes the menu on command mode to show
set wildmode=longest:full,full

set nobackup " disable the creation of these stupid files
set nowritebackup
set noswapfile
set noundofile

set cursorline     " highlights the line where the cursor is
set ruler          " shows information
" set number         " these two shows the relative ruler stuff
" set relativenumber " these two shows the relative ruler stuff

set hlsearch
" set shortmess-=S

set backspace=indent,eol,start " backspace behavior

set autoread                   " this is for allowing external programs to modify files open by vim
au CursorHold * checktime

" Remaps the arrow keys to nothing. Learn hjkl!
map <Up> <nop>
map <Down> <nop>
map <Left> <nop>
map <Right> <nop>

" stuff for tab auto completion
inoremap <expr> <Tab> getline('.')[col('.')-2] !~ '^\s\?$' \|\| pumvisible()
            \ ? '<C-N>' : '<Tab>'
inoremap <expr> <S-Tab> pumvisible() \|\| getline('.')[col('.')-2] !~ '^\s\?$'
            \ ? '<C-P>' : '<Tab>'
autocmd CmdwinEnter * inoremap <expr> <buffer> <Tab>
            \ getline('.')[col('.')-2] !~ '^\s\?$' \|\| pumvisible()
            \ ? '<C-X><C-V>' : '<Tab>'

" MOUSE SETTINGS
set mouse=a
map <LeftMouse> <NOP>
map <RightMouse> <NOP>
map <MiddleMouse> <NOP>


" DELETE ALL TRAILING WHITESPACES, use F9 for it

function ShowSpaces(...)
    let @/='\v(\s+$)|( +\ze\t)'
    let oldhlsearch=&hlsearch
    if !a:0
        let &hlsearch=!&hlsearch
    else
        let &hlsearch=a:1
        end
        return oldhlsearch
    endif
endfunction

function TrimSpaces() range
    let oldhlsearch=ShowSpaces(1)
    execute a:firstline.",".a:lastline."substitute ///gec"
    let &hlsearch=oldhlsearch
endfunction

command -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
command -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()
"nnoremap <silent> <F9>     :ShowSpaces 1<CR>
nnoremap <silent> <F9>   :TrimSpaces<CR>
vnoremap <silent> <F9>   :TrimSpaces<CR>

" TOGGLE BETWEEN C/C++ source and header files

function HeaderToggle()
    let filename = expand("%:t")
    if filename =~ ".c"
        execute "e %:r.h"
    else
        execute "e %:r.c"
    endif
endfunction

map <silent> <F10> :call HeaderToggle()<cr>

""""""""""""""" COLORSCHEME

" set background=dark
" colorscheme lunaperche
" colorscheme codedark
" colorscheme quiet
" colorscheme default

" custom color for comments

" hi Comment guifg=#2AAE22
" hi Comment ctermfg=#ABCDEF

" Custom highlights

if has("autocmd")
    " Highlight TODO, FIXME, etc.
    if v:version > 701
        autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|OBS\|BUG\)')
        autocmd Syntax * call matchadd('Debug', '\W\zs\(TODO\|FIXME\|OBS\|BUG\)')
    endif
endif

" custom colorscheme
hi Normal guifg=#ffffff guibg=#1e1e1e
hi Comment guifg=#00ff00
hi Constant guifg=#ffffff
hi Identifier guifg=#ffffff
hi Statement guifg=#ffffff
hi PreProc guifg=#ffffff
hi Type guifg=#ffffff
hi Special guifg=#ffffff
hi Underlined guifg=#ffffff
hi Ignore guifg=#ffffff
hi Error guifg=#ffffff guibg=#ff0000
hi Todo guifg=#ffffff guibg=#0000ff
hi CursorLine guibg=#2e2e2e
hi MatchParen guifg=#ffffff guibg=#8fb3a0
hi NormalNC guifg=#ffffff guibg=#1e1e1e
hi NetrwDir guifg=#ffffffkkk
hi NetrwPlain guifg=#ffffff
hi NetrwExec guifg=#ffffff
hi EndOfBuffer guifg=#ffffff
hi Number guifg=#03f4fc
hi String guifg=#f2ce6b
hi VertSplit guifg=#1e1e1e guibg=#ffffff
hi HorzSplit guifg=#1e1e1e guibg=#ffffff
hi StatusLine guifg=#ffffff guibg=#3a3a3a gui=none
hi StatusLineNC guifg=#888888 guibg=#252525 gui=none
hi QuickFixLine guibg=#3e4d8c guifg=#ffffff gui=none
hi cErrInParen guifg=#ffffff

" to identify stuff: :echo synIDattr(synID(line('.'), col('.'), 1), 'name')

""""""""""""""""" CUSTOM STATUSLINE

function! TrailingWhitespaceCount()
    let l:count = len(filter(getline(1, '$'), 'v:val =~ ''\s$'''))
    return l:count > 0 ? '[' . l:count . ' trailing spaces]' : ''            
endfunction

set laststatus=2
set statusline=
set statusline+=\ %<[%F]%*                              "full path
set statusline+=%m%*                                    "modified flag
set statusline+=%=%5l%*                                 "current line
set statusline+=/%L%*                                   "total lines
set statusline+=%4v\ %*                                 "virtual column number
set statusline+=%y%*                                    "file type
set statusline+=[%{&ff}]%*                              "file format
set statusline+=[%{&fenc}]%*                            "file enconding
set statusline+=\ %{TrailingWhitespaceCount()}          "trailing whitespaces
