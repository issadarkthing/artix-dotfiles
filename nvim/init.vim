call plug#begin('~/.config/nvim/autoload/plugged')

" manages quoting/parenthesis
Plug 'tpope/vim-surround'

" status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" file explorer
Plug 'scrooloose/nerdtree' |
	\ Plug 'ryanoasis/vim-devicons' |
	\ Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" insert, or delete brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs'

" comment
Plug 'tpope/vim-commentary'

" color highlight
Plug 'chrisbra/colorizer', { 'on': 'ColorHighlight' }

" colorscheme
Plug 'whatyouhide/vim-gotham'

" Vim sugar for the UNIX shell commands that need it the most
" example: :Delete, :Move, :Rename, :Mkdir etc
Plug 'tpope/vim-eunuch'

" fuzzyfind stuff
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" nerdtree icons
" Plug 'ryanoasis/vim-devicons'

" highlight unique character in every word
Plug 'unblevable/quick-scope'

" personal wiki for vim
Plug 'vimwiki/vimwiki', { 'on': 'VimwikiIndex' }

" handles gpg encrypted file
Plug 'jamessan/vim-gnupg'

" add more text object
Plug 'wellle/targets.vim'

" better TS prettier
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

" reorder delimited items
Plug 'machakann/vim-swap'

" grammar check
Plug 'rhysd/vim-grammarous'

" code completion
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" vim latex
Plug 'lervag/vimtex'

" grammar check as well
Plug 'dpelle/vim-LanguageTool'

" auto save
" Plug '907th/vim-auto-save'

" go debugger
Plug 'sebdah/vim-delve', { 'for': 'go' }

" replace a existing text from the register
Plug 'inkarkat/vim-ReplaceWithRegister' 

" auto reload if file has been modified from external
" as if you insert :e! manually
Plug 'djoshea/vim-autoread'

" go plugin
Plug 'fatih/vim-go', { 'for': 'go' }

" help to manage alignment
Plug 'junegunn/vim-easy-align'

" for clojure
" Plug 'tpope/vim-fireplace'
Plug 'vim-scripts/paredit.vim', { 'for': 'clojure' }

Plug 'eraserhd/parinfer-rust', {
			\ 'do': 'cargo build --release',
			\ 'for': 'clojure'}

Plug 'elixir-editors/vim-elixir', { 'for': 'elixir' }

" personal colorscheme
Plug 'issadarkthing/vim-rex'

Plug 'SirVer/ultisnips'

Plug 'tweekmonster/startuptime.vim'

" Plug 'sheerun/vim-polyglot', { 'for': 'typescript' }

call plug#end()


set tabstop=4
set softtabstop=4
set shiftwidth=4
set number

" remap esc key as jk
inoremap jk <esc>
" inoremap <esc> <NOP>

let mapleader = ","
filetype plugin indent on


" colorscheme stuff
colorscheme rex
let g:airline_theme = 'rex'
" enable pointed arrow
let g:airline_powerline_fonts = 1

" enables mouse
set mouse+=a

" toggle color
noremap <leader>co :ColorToggle<cr>

" source vimrc
noremap <leader>v :so ~/.config/nvim/init.vim<cr>

" disable highlight search permanently
set nohlsearch

" group commands together to prevent calling autocmd whenever file is reloaded
augroup personal_preference
	autocmd!
	"vertically center document when entering insert mode
	autocmd InsertEnter * norm zz

	" remove trailing whitespace on save
	"autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

	" automatic shebang insertion
	autocmd BufNewFile *.sh 0put = '#!/bin/bash'

	" open vimwiki when no file specified
	" autocmd VimEnter * if argc() == 0 | execute 'VimwikiIndex' | endif

	" disable auto pair for lisp and clojure files
	autocmd FileType lisp,clojure let b:autopairs_loaded=1 

	" autocmd FileType lisp execute 'set ft=clojure'
	" autocmd BufRead *.clj FireplaceConnect nrepl://localhost:1667 %

	" use clojure syntax for spirit lang
	autocmd BufNewFile,BufRead *.st set filetype=clojure | let b:autopairs_enabled=0

	" disable auto save on vim wiki
	autocmd BufEnter *.wiki let b:auto_save = 0
	
	autocmd BufEnter *.txt call GrammarMappings()
augroup END


" autocompletion
set wildmenu
set wildmode=longest:full,full

" semicolon macro
let @s="A;jk"



" rename file inside vim
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction

noremap <leader>n :call RenameFile()<cr>


" toggle nerd tree
noremap <silent> <C-n> :NERDTreeToggle<CR>

" remap open keybinding in NERDTree
let NERDTreeMapCustomOpen='l'

" remap close dir keybinding in NERDTree
let NERDTreeMapCloseDir='h'


" prevents from creating swapfiles in this dir
au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile

" persistent undo history in one directory
set undodir=~/.vim/undodir
set undofile

" jedi only used for rename in python which YCM doesn't work in python
let g:jedi#completions_enabled = 0


" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" nice fzf window layout
let g:fzf_layout =
			\ {'up':'~90%', 'window': {
			\ 'width': 0.8,
			\ 'height': 0.8,
			\ 'yoffset':0.5,
			\ 'xoffset': 0.5,
			\ 'highlight':
			\ 'Todo',
			\ 'border': 'sharp' } }


" disables arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>


" automatic center when jump to next or previous position
noremap <silent> <C-o> <C-o>zz
noremap <silent> <C-i> <C-i>zz

" remap escape key to exit fzf
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"

" map ripgrep
nnoremap <leader>rg :Rg<CR>

nnoremap q: :q<CR>

" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

highlight QuickScopePrimary guifg='#00C7DF' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#eF5F70' gui=underline ctermfg=81 cterm=underline
let g:qs_max_chars=150


" add relative line jump to jump list
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'gk'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'gj'

" mapping to make movements operate on 1 screen line in wrap mode
function! ScreenMovement(movement)
   if &wrap
      return "g" . a:movement
   else
      return a:movement
   endif
endfunction

onoremap <silent> <expr> j ScreenMovement("j")
onoremap <silent> <expr> k ScreenMovement("k")
onoremap <silent> <expr> 0 ScreenMovement("0")
onoremap <silent> <expr> ^ ScreenMovement("^")
onoremap <silent> <expr> $ ScreenMovement("$")
nnoremap <silent> <expr> j ScreenMovement("j")
nnoremap <silent> <expr> k ScreenMovement("k")
nnoremap <silent> <expr> 0 ScreenMovement("0")
nnoremap <silent> <expr> ^ ScreenMovement("^")
nnoremap <silent> <expr> $ ScreenMovement("$")




noremap <leader>f :Files<cr>
nnoremap <leader>F :GFiles<cr>

" cursorline
"set cursorline
"highlight  CursorLine ctermbg=4 ctermfg=NONE


" Use case insensitive search, except when using capital letters
set ignorecase

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
noremap Y y$

" find in config dir
nnoremap <leader>gc :Files ~/.config<cr>

" find in home directory
nnoremap <leader>gh :Files ~<cr>

" find in history
nnoremap <leader>gH :History<cr>

" treat dash separated words as a word text object"
set iskeyword+=-

" Horizontal splits will automatically be below
set splitbelow

" Vertical splits will automatically be to the right
set splitright

" makes popup menu smaller
set pumheight=10


" opens help window vertically
cabbrev h vert h
" auto center for next and prev occurance
cabbrev cn cn | normal zz
cabbrev cp cn | normal zz

" stop vim-rooter from echoing the project directory
let g:rooter_silent_chdir = 1

" disable whitespace detection
let g:airline#extensions#whitespace#enabled = 0

" edit config
nnoremap <silent> <leader>ec :e ~/.config/nvim/init.vim<cr>

" closes buffer
nnoremap <silent> <leader>bd :bd<cr>

" deletes all buffer except current one
noremap <silent> <leader>bo :%bd!\|e#\|bd#<cr>\|'"


" navigate between buffer
noremap <silent> <C-l> :bnext<CR>
noremap <silent> <C-h> :bprevious<CR>
noremap <silent> <A-w> :b#<CR>


" switch between buffer without saving
set hidden

" remove wrap
set nowrap

" delete a function if opening brace is on the same line as function name
nnoremap <leader>df Vf{%d


function! LineAtPerc(perc) abort
	let l_start = line('w0')
	let l_end = line('w$')
	return l_start + float2nr((l_end - l_start) * (a:perc / 100.0))
endfunction

" moves cursor 1/4 and 3/4 of the page
nnoremap <silent> <c-k> :call cursor(LineAtPerc(25), 0)<cr>
nnoremap <silent> <c-j> :call cursor(LineAtPerc(75), 0)<cr>

" scratch buffer
nnoremap <silent> <leader>bs :e /tmp/vim-scratch<cr>

" deletes trailing whitespace while preserving cursor
function! StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

" fuzzy line search
nnoremap <leader>l :Lines<cr>

" Don't pass messages to |ins-completion-menu|.
set shortmess=aFc

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" navigate trough quickfix list
nnoremap <silent> ]] :cnext<esc>zz
nnoremap <silent> [[ :cprev<esc>zz

function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

" toggle quickfix and location list
nmap <silent> <space>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <space>c :call ToggleList("Quickfix List", 'c')<CR>


" GoTo code navigation.
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)


" Use K to show documentation in preview window
" nmap <silent> K :call <SID>show_documentation()<CR>

nmap <silent> K :call timer_start(0, "<SID>show_documentation")<CR>

function! s:show_documentation(x)
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>yr <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>yf  <Plug>(coc-format-selected)
nmap <leader>yf  <Plug>(coc-format-selected)

" Apply AutoFix to problem on the current line.
nmap <leader>,  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use jk to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

nnoremap <leader>yi :OR<cr>

" Use tab for trigger completion with characters ahead and navigate.
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" grammar fix
nmap <leader>gmf <Plug>(grammarous-fixit)
nmap <leader>gmn <Plug>(grammarous-move-to-next-error)

let g:languagetool_jar = '/home/terra/Documents/repos/languagetool/languagetool-standalone/target/LanguageTool-5.0-SNAPSHOT/LanguageTool-5.0-SNAPSHOT/languagetool-commandline.jar'
let g:languagetool_lang = 'en-GB'

" Enable all categories
let g:languagetool_enable_categories = 'PUNCTUATION,TYPOGRAPHY,CASING,COLLOCATIONS,CONFUSED_WORDS,CREATIVE_WRITING,GRAMMAR,MISC,MISUSED_TERMS_EU_PUBLICATIONS,NONSTANDARD_PHRASES,PLAIN_ENGLISH,TYPOS,REDUNDANCY,SEMANTICS,TEXT_ANALYSIS,STYLE,GENDER_NEUTRALITY'

" Enable all special rules that cannot be enabled via category
let g:languagetool_enable_rules = 'AND_ALSO,ARE_ABLE_TO,ARTICLE_MISSING,AS_FAR_AS_X_IS_CONCERNED,BEST_EVER,BLEND_TOGETHER,BRIEF_MOMENT,CAN_NOT,CANT_HELP_BUT,COMMA_WHICH,EG_NO_COMMA,ELLIPSIS,EXACT_SAME,HONEST_TRUTH,HOPEFULLY,IE_NO_COMMA,IN_ORDER_TO,I_VE_A,NEGATE_MEANING,PASSIVE_VOICE,PLAN_ENGLISH,REASON_WHY,SENT_START_NUM,SERIAL_COMMA_OFF,SERIAL_COMMA_ON,SMARTPHONE,THREE_NN,TIRED_INTENSIFIERS,ULESLESS_THAT,WIKIPEDIA,WORLD_AROUND_IT'


nnoremap <a-Left>  :vert resize +5<cr>
nnoremap <a-Right> :vert resize -5<cr>
nnoremap <a-Up>    :resize -5<cr>
nnoremap <a-Down>  :resize +5<cr>

let g:tex_flavor = 'latex'
let g:vimtex_quickfix_open_on_warning = 0

let g:vimwiki_list = [{'path': '~/.local/share/nvim/vimwiki', 
					\ 'path_html': '~/.local/share/nvim/vimwiki/html',
					\ 'auto_export': 1}]
let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 1

" change vim wiki heading colors
highlight VimwikiHeader1 ctermfg=3
highlight VimwikiHeader2 ctermfg=2
highlight VimwikiHeader3 ctermfg=1
highlight VimwikiHeader4 ctermfg=6
highlight VimwikiHeader5 ctermfg=28
highlight VimwikiHeader6 ctermfg=130

" enable AutoSave on Vim startup
" let g:auto_save = 1

" do not display the auto-save notification
let g:auto_save_silent = 1

" makes formatted block prettier
let g:vimwiki_conceal_pre = 1

" time out on mapping after three seconds, time out on key codes after a tenth of a second
set timeout timeoutlen=3000 ttimeoutlen=100

" set current highlited on the correct window
nnoremap <c-w>v <c-w>v<c-w>h

set colorcolumn=80

" -------------- vim-go config ---------
" disable vim-go doc
let g:go_doc_keywordprg_enabled = 0

" Highlight commonly used library types (`io.Reader`, etc.). >
let g:go_highlight_extra_types = 1


let g:go_highlight_operators           = 1
let g:go_highlight_functions           = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls      = 1
let g:go_highlight_types               = 1
let g:go_highlight_diagnostic_errors   = 1
let g:go_highlight_diagnostic_warnings = 1
let g:go_highlight_fields              = 1


let g:go_highlight_diagnostic_errors = 0
let g:go_code_completion_enabled     = 0
let g:go_imports_autosave            = 0
let g:go_fmt_autosave                = 0
let g:go_doc_popup_window            = 0
let g:go_gopls_enabled               = 1


" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


let g:asmsyntax = 'nasm'

nnoremap <leader>ep :e ~/Documents/scripts/prelude.clj<cr>
nnoremap <leader>bb :Buffers<cr>
nnoremap <M-`> <C-^>
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap m :w<cr>

let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'•',
                \ 'Staged'    :'+',
                \ 'Untracked' :'*',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'•',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }

let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"


function! GrammarMappings()
	nmap <buffer> <leader>, <Plug>(grammarous-fixit)
	nmap <buffer> <leader>n <Plug>(grammarous-move-to-next-error)
	nmap <buffer> <leader>p <Plug>(grammarous-move-to-previous-error)
	" Disable the grammar rule under the cursor
	nmap <buffer> <leader>d <Plug>(grammarous-remove-error)
	nmap <buffer> <leader>r <Plug>(grammarous-reset)
	nmap <buffer> <leader>a <Plug>(grammarous-fixall)
	nmap <buffer> <leader>q <Plug>(grammarous-close-info-window)
	nmap <buffer> <leader>i <Plug>(grammarous-open-info-window)
endfunction

" set cursorline
" hi CursorLine ctermfg=NONE ctermbg=234
set scrolloff=10

function! ReplaceTabWithSpace()
    set tabstop=4 shiftwidth=4 expandtab
endfunction

