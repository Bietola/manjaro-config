"" pathogen (RIP)
" execute pathogen#infect()

" plug init
call plug#begin('~/.local/share/nvim/plugged')

" plugins
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'hrsh7th/vim-vsnip'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'daveyarwood/vim-alda'
Plug 'calincru/flex-bison-syntax'
Plug 'ron-rs/ron.vim'
Plug 'alx741/vim-hindent'
Plug 'AndrewRadev/dsf.vim'
Plug 'runoshun/vim-alloy'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'masukomi/vim-markdown-folding'
Plug 'rust-lang/rust.vim'
Plug 'tommcdo/vim-exchange'
Plug 'gyim/vim-boxdraw'
Plug 'kana/vim-tabpagecd'
Plug 'Raimondi/delimitMate'
Plug 'szw/vim-tags'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'jpalardy/vim-slime'
Plug 'vim-scripts/DrawIt'
Plug 'AndrewRadev/sideways.vim'
" Plug 'Valloric/YouCompleteMe'
Plug 'majutsushi/tagbar'
Plug 'thaerkh/vim-workspace'
Plug 'godlygeek/tabular'
" Plug 'vim-pandoc/vim-pandoc'
" Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'plasticboy/vim-markdown'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kien/ctrlp.vim'

" programming languages
Plug 'suoto/vim-hdl'
Plug 'vim-perl/vim-perl6'
Plug 'quabug/vim-gdscript'
Plug 'sheerun/vim-polyglot'
"TODO Plug 'vim-syntastic/syntastic'

" colorschemes
Plug 'nightsense/carbonized'
Plug 'JarrodCTaylor/spartan'
Plug 'KKPMW/sacredforest-vim'
Plug 'cocopon/iceberg.vim'

" plug deinit
call plug#end()

" vimrc loading stuff
set exrc

" nvim :terminal suff
if has("nvim")
  tnoremap <ESC><ESC> <C-\><C-n>
  "! tnoremap jk <C-\><C-n> " RIP (need caps lock for ranger)
endif

" window splitting shortcuuts
noremap <C-w>V <C-w>v<C-w><C-l>
noremap <C-w>S <C-w>s<C-w><C-j>
noremap <C-j> <C-w><C-j>
noremap <C-k> <C-w><C-k>
noremap <C-h> <C-w><C-h>
noremap <C-l> <C-w><C-l>

" window splitting options
set diffopt+=vertical

" file loading stuff
:set autowriteall

" operating system detection variables
if !exists("g:os")
if has("win64") || has("win32") || has("win16")
    let g:os = "Windows"
else
    let g:os = substitute(system('uname'), '\n', '', '')
endif
endif

" operating system make configuration
if g:os == "Windows"
set makeprg=mingw32-make
elseif g:os == "Linux"
set makeprg=make
endif

" operating system cmake configurations
if g:os == "Windows"
command -bar -nargs=1 CMake !cmake -G "MinGW Makefiles" <args>
elseif g:os == "Linux"
command -bar -nargs=1 CMake !cmake  <args>
end

" operating system cmake debug configurations
if g:os == "Windows"
command -bar -nargs=1 DMake !cmake -DCMAKE_BUILD_TYPE=Debug -G "MinGW Makefiles" <args>
elseif g:os == "Linux"
command -bar -nargs=1 DMake !cmake -DCMAKE_BUILD_TYPE=Debug <args>
end

" operating system cmake vcpkg configurations
if g:os == "Linux"
command -bar -nargs=1 VCMake !cmake -DCMAKE_TOOLCHAIN_FILE=/usr/pkg/vcpkg/scripts/buildsystems/vcpkg.cmake <args>
end

" ctrl settings
let g:ctrlp_show_hidden = 1

" leader
let mapleader = "ò"

" useful mappings
nnoremap <S-Enter> O<Esc>
nnoremap <CR> o<Esc>
" tabularize quick mapping
nnoremap <leader>tab :Tabularize 
vnoremap <leader>tab :Tabularize 
" sideways mappings
nnoremap <leader>h :SidewaysLeft<CR>
nnoremap <leader>l :SidewaysRight<CR>
" vimrc management
" TODO: Make a boxes related plugin
au filetype vim vnoremap <leader>b :'<,'>!boxes -d vim-box<cr>
au filetype vim nnoremap <leader>bb V:'<,'>!boxes -d vim-box<cr>

" terminal looks
set background=dark
set termguicolors
colorscheme iceberg
set guifont=Consolas:h17

" tab (those akin to windows...) settings and custom commands
au TabEnter * if exists("t:wd") | exe "cd" t:wd | endif
let g:airline_powerline_fonts = 1

" whitespace (tab/backspace) things
set tabstop=4
set shiftwidth=4
set backspace=indent,eol,start

" fancy lines numbers
" turn hybrid line numbers on
" :set number relativenumber
" :set nu rnu
" turn hybrid line numbers off
" :set nonumber norelativenumber
" :set nonu nornu
" toggle hybrid line numbers
" :set number! relativenumber!
" :set nu! rnu!

" default syntax
syntax on
set syntax=cpp
filetype plugin indent on

" ctags and vim-tags settings
let g:vim_tags_auto_generate = 1
let g:vim_tags_directories = [".git/..", ".hg", ".svn", ".bzr", "_darcs", "CVS"]
let g:vim_tags_ignore_files = ['.gitignore', '.svnignore', '.cvsignore']
let g:vim_tags_project_tags_command = "{CTAGS} -R --fields=+l {OPTIONS} {DIRECTORY} 2>/dev/null"

" default path
set path+=../**

" menu options
set wildmenu
set number

" no idea... (should research)
set timeoutlen=10000

" Sensible clipboard behaviour.
set clipboard=unnamedplus

" utility remappings
" imap jk <Esc> " RIP (need caps lock for ranger)

" utility commands
command W      set wrap!
command NoWar  set errorformat^=%-G%f:%l:\ warning:%m
command Tgen   cd .. | !ctags -R | cd build
command Comp   !g++ main.cpp -o Proj
command RCEdit edit $MYVIMRC

command Ex  !./Proj
command Tex !/usr/bin/time ./Proj 

"" netrw settings
" Allow netrw to remove non-empty local directories
let g:netrw_localrmdir='rm -r'
autocmd FileType netrw nnoremap ? :help netrw-quickmap<CR>

" TagBar settings
" TODO: nmap <leader><leader> :TagbarToggle<CR><c-w><c-w>

"" YCM things
" commands
command YCMToggleCompletionTrigger :let g:ycm_auto_trigger=!g:ycm_auto_trigger
" settings
let g:enable_ycm_at_startup = 0
let g:ycm_auto_trigger = 0
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_collect_identifiers_from_tags_files = 1

"""""""""""""""""""""""""""
" async complete settings "
"                         "
"""""""""""""""""""""""""""

" No floating hint box

""""""""""""""""""
" vsnip settings "
"                "
""""""""""""""""""
" All snippets are in this directory.
" TODO: Use `XDG_CONFIG_HOME` in path (set it in `/ect/profile`).
let g:vsnip_snippet_dir = "/home/dincio/.config/nvim/snippets"

" Keybindings.
"! imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand)'         : '<C-j>'
"! imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
"! smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <C-h>   vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <C-h>   vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" TODO: find out better way to do this
" NB. Ultisnips is not compatible with neovim... so we need to use the .vim
" directory
set runtimepath^=~/.vim
let g:UltiSnipsSnippetsDirectories=[$HOME.'/.vim/UltiSnips']

" vim-slime options
let g:slime_target = "neovim"

" delimitMate options
let delimitMate_expand_cr = 1

" markdown mappings  
nnoremap <leader>ft :TableFormat<CR>

" surround mappings and custom settings
nmap s ys
au FileType lilypond let b:surround_45 = "<< \r >>"

" markdown settings  
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_enable_folding = 1

" vim-pandoc settings
"" let g:pandoc#syntax#codeblocks#embeds#langs = ["cpp"]
"let g:pandoc#folding#fold_fenced_codeblocks = 1

" gabrielelana markdown settings
" let g:markdown_enable_folding = 1

" mkdx configuration
" let g:mkdx#settings     = { 'highlight': { 'enable': 1 },
"                         \ 'enter': { 'shift': 1 },
"                         \ 'links': { 'external': { 'enable': 1 } },
"                         \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 },
"                         \ 'fold': { 'enable': 1 } }
" let g:polyglot_disabled = ['markdown'] " for vim-polyglot users, it loads Plasticboy's markdown
"                                       " plugin which unfortunately interferes with mkdx list indentation.

" default formatting settings
set expandtab
set tabstop=4
set shiftwidth=4
set sts=4
set autoindent

" tagbar settings for perl6
let g:tagbar_type_perl6 = {
  \ 'ctagstype' : 'perl6',
  \ 'kinds' : [
    \ 'c:classes',
    \ 'g:grammar',
    \ 'm:methods',
    \ 'o:modules',
    \ 'p:packages',
    \ 'r:roles',
    \ 'u:rules',
    \ 'b:submethods',
    \ 's:subroutines',
    \ 't:tokens'
  \ ]
\ }

" c and cpp formatting settings
au FileType cpp,c set expandtab
au FileType cpp,c set tabstop=4
au FileType cpp,c set shiftwidth=4
au FileType cpp,c set sts=4
au FileType cpp,c set autoindent

" MIPS formatting settings
au FileType asm set expandtab
au FileType asm set tabstop=8
au FileType asm set shiftwidth=8
au FileType asm set sts=8
au FileType asm set autoindent

" basic formatting settings
au FileType basic let b:delimitMate_quotes = "\""

" lisp formatting settings
au FileType lisp let b:delimitMate_quotes = "\""
au FileType lisp set expandtab
au FileType lisp set tabstop=2
au FileType lisp set shiftwidth=2

" haskell formatting settings
au FileType haskell set expandtab
au FileType haskell set tabstop=2
au FileType haskell set shiftwidth=2

" racket formatting settings
au FileType racket let b:delimitMate_quotes = "\""

"asdf formatting settings
au BufRead,BufNewFile *.asd set filetype=lisp

" python3 formatting settings
au FileType python set expandtab
au FileType python set tabstop=4
au FileType python set shiftwidth=4
au FileType python set sts=4
au FileType python set autoindent

""""""""""""""""
" LSP settings "
""""""""""""""""

" LSP Autocompletion with tab.
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

"""""""""""""""""""""""""""""
" Haskell specific settings "
"""""""""""""""""""""""""""""

" Hindent
au filetype haskell let g:hindent_on_save = 0

" utility leader commands
nnoremap <leader>to <C-W>o<C-W>j:term<cr>
nnoremap <leader>tv <C-W>v<C-W>l:term<cr>
nnoremap <leader>tw <leader>to
nnoremap <leader>tt :tabnew<cr>:term<cr>
nnoremap <leader>tn :tabnew<cr>

" quick vimgrep command
command -nargs=1 Vimgrep vimgrep <args> ##
" NB: this initialization is customized for different languages
au filetype c,cpp nnoremap <leader>vi :args ./**<cr>
au filetype c,cpp nnoremap <leader>vg :Vimgrep 
au filetype c,cpp nnoremap <leader>v/ :Vimgrep ///g<cr>

" Lilypond general keybindings
" Compile current file
au filetype lilypond nnoremap <leader>c :w<cr>:!lilypond %<cr>
" View pdf associated with current file
au filetype lilypond nnoremap <leader>v :!zathura %:r.pdf &<cr>
" play selected notes
au filetype lilypond nnoremap <leader>p :set opfunc=LyPlay<CR>g@
" TODO: vmap <silent> <F4> :<C-U>call CountSpaces(visualmode(), 1)<CR>
" function to do heavy lifting
function! LyPlay(type)
    " Get notes specified by the motion
    if a:type == 'line'
        silent exe "normal! '[V']y"
    else
        silent exe "normal! `[v`]y"
    endif

    " Play them
    let lycommand = "!lyplay italiano do \"<->\""
    let lycommand = substitute(lycommand, "<->", @@, "")
    exe lycommand
endfunction


" LSP general keybindings
nnoremap <leader>hv :LspHover<cr>
nnoremap <leader>rf :LspReference<cr>
noremap <leader>rn :LspRename<cr>
noremap <leader>fm :RustFmt<cr>
noremap <leader>er :LspDocumentDiagnostics<cr>
noremap <leader>gd :LspDefinition<cr>
noremap <leader>gr :LspReferences<cr>

"" Sh keybindings
au filetype sh vnoremap <leader>b :'<,'>!boxes -d shell<cr>
au filetype sh nnoremap <leader>bb V:'<,'>!boxes -d shell<cr>
au filetype sh nnoremap <leader>bm vip:'<,'>!boxes -d shell -m<cr>

"" Rust keybindings
" Cargo
au filetype rust nnoremap <leader><leader>r :!cargo run<cr>
au filetype rust nnoremap <leader><leader>t :!cargo test<cr>
" Boxes
au filetype rust vnoremap <leader>b :'<,'>!boxes<cr>
au filetype rust nnoremap <leader>bb V:'<,'>!boxes<cr>
au filetype rust nnoremap <leader>bm vip:'<,'>!boxes -m<cr>
au filetype rust nnoremap <leader>vg :Vimgrep 
" Other useful keybindings
au filetype rust nnoremap <leader>vi :args src/**<cr>

"" C keybindings
au filetype c inoremap <c-c> <esc>:!gcc main.c<cr>i

"" Racket keybindings
" Slime
au filetype racket nnoremap <leader>tt :vsp<cr>:term racket<cr>:echo b:terminal_job_id<cr><c-w><c-l>
au filetype racket nnoremap <leader>fm :LspDocumentFormat<cr>

"" Haskell keybindings
" Slime
au filetype haskell nnoremap <leader>trw :vsp<cr>:term ghci<cr>:echo b:terminal_job_id<cr><c-w><c-l>
au filetype haskell nnoremap <leader>trt :tabnew<cr>:term ghci<cr>:echo b:terminal_job_id<cr>gT
" Comments
au filetype haskell vnoremap <leader>b :'<,'>!boxes -d ada-box<cr>
au filetype haskell vnoremap <leader>bm V:'<,'>!boxes -m<cr>
au filetype haskell nnoremap <leader>bb V:'<,'>!boxes -d ada-box<cr>
" Automatic formatting
au filetype haskell nnoremap <leader>fm :Hindent<cr>
" Tabular
au filetype haskell nnoremap <leader>t= :Tabular /=<cr>

" Git fugitive custom commands
command GA Git A

" Ranger configuration
let g:ranger_replace_netrw = 1 "open ranger when vim open a directory

" Scheme stuff
" Local leader.
autocmd FileType scheme let maplocalleader = "ò"
" TODO: try w/ localleader
nnoremap <leader>a mmggVG:SlimeSend<cr>'m

" Lance stuff
" NB. Lance is an educational language for the Formal Languages course at
" Polimi
autocmd FileType lance set syntax = lua
