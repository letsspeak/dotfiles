set noswapfile
set tabstop=2
set shiftwidth=2
set autoindent
set expandtab
colorscheme molokai
syntax on
set pastetoggle=<C-E>
set number
set ruler
set laststatus=2

"neobundle.vim {{{1
"--------------
" $ mkdir -p ~/.vim/bundle
" $ git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
"--------------
set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" bundles {{{2
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'Shougo/vimshell.vim'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'claco/jasmine.vim'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'clausreinke/typescript-tools'

filetype plugin on
filetype indent on

NeoBundleCheck

call neobundle#end()

" Tab pages  "{{{2
" Fallback  "{{{3

" the prefix key.
noremap <C-t>  <Nop>


" Basic  "{{{3

" Move new tabpage at the last.
nnoremap <silent> <C-t>n  :<C-u>tabnew \| :tabmove<CR>
nnoremap <silent> <C-t>c  :<C-u>tabclose<CR>
nnoremap <silent> <C-t>o  :<C-u>tabonly<CR>
nnoremap <silent> <C-t>i  :<C-u>tabs<CR>

nmap <C-t><C-n>  <C-t>n
nmap <C-t><C-c>  <C-t>c
nmap <C-t><C-o>  <C-t>o
nmap <C-t><C-i>  <C-t>i

nnoremap <silent> <C-t><Space>  :<C-u>TabpageTitle<CR>

nmap <silent> <C-t><C-@>  <C-t><Space>
nmap <silent> <C-t><C-Space>  <C-t><Space>


" Moving around tabpages.  "{{{3

nnoremap <silent> <C-t>k
\ :<C-u>execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>
nnoremap <silent> <C-t>j
\ :<C-u>execute 'tabprevious' v:count1 % tabpagenr('$')<CR>
nnoremap <silent> <C-t>J  :<C-u>tabfirst<CR>
nnoremap <silent> <C-t>K  :<C-u>tablast<CR>

nmap <C-t><C-j>  <C-t>k
nmap <C-t><C-k>  <C-t>j
nmap <C-t><C-t>  <C-t>k

nmap <C-t>h  <C-t>j
nmap <C-t>l  <C-t>k
nmap <C-t><C-h>  <C-t>j
nmap <C-t><C-l>  <C-t>k

function! s:move_window_into_tabpage(target_tabpagenr)  "{{{2
  " Move the current window into a:target_tabpagenr.
  if a:target_tabpagenr <= 0  " ignore invalid number.
    return
  endif
  let original_tabnr = tabpagenr()
  let target_bufnr = bufnr('')
  let window_view = winsaveview()

  if a:target_tabpagenr > tabpagenr('$')
    tabnew
    tabmove  " Move new tabpage at the last.
    execute target_bufnr 'buffer'
    let target_tabpagenr = tabpagenr()
  else
    execute a:target_tabpagenr 'tabnext'
    let target_tabpagenr = a:target_tabpagenr
    if winnr('$') > 1 || bufname(winbufnr(0)) != ''
      SplitTop
    endif
    execute target_bufnr 'buffer'
  endif
  call winrestview(window_view)

  execute original_tabnr 'tabnext'
  if winnr('$') > 1
    close
  else
    let target_tabpagenr -= tabpagenr() < target_tabpagenr
    tabclose
  endif

  execute target_tabpagenr 'tabnext'
endfunction

" This {lhs} overrides the default action (Move cursor to top-left window).
" But I rarely use its {lhs}s, so this mapping is not problematic.
nnoremap <silent> <C-w>t
\ :call <SID>move_window_into_tabpage(<SID>ask_tabpage_number())<CR>
function! s:ask_tabpage_number()
  echon 'Which tabpage to move this window into? '

  let c = nr2char(getchar())
  if c =~# '[0-9]'
    " Convert 0-origin number (typed by user) into 1-origin number (used by
    " Vim's internal functions).  See also 'tabline'.
    return 1 + char2nr(c) - char2nr('0')
  else
    return 0
  endif
endfunction
nmap <C-w><C-t>  <C-w>t

"au FileType c,cpp setlocal comments-=:// comments+=f://
"au FileType c,cpp setlocal comments-=:// comments+=f://
"au FileType conf,rb setlocal comments-=:# comments+=f:#
"au FileType vimrc setlocal comments-=:" comments+=f:"
autocmd FileType * setlocal formatoptions-=ro

au BufRead,BufNewFile,BufReadPre *.coffee set filetype=coffee
au BufRead,BufNewFile *.scala set filetype=scala
	
" インデントを設定
autocmd FileType coffee     setlocal sw=2 sts=2 ts=2 et
" taglistの設定 coffeeを追加
" let g:tlist_coffee_settings = 'coffee;f:function;v:variable'

" QuickRunのcoffee
" let g:quickrun_config['coffee'] = {
"      \'command' : 'coffee',
"      \'exec' : ['%c -cbp %s']
"      \}

"------------------------------------
" vim-coffee-script
"------------------------------------
" 保存時にコンパイル
"autocmd BufWritePost *.coffee silent CoffeeMake! -cb | cwindow | redraw!

"------------------------------------
" jasmine.vim
"------------------------------------
" ファイルタイプを変更
function! JasmineSetting()
  au BufRead,BufNewFile *Helper.js,*Spec.js  set filetype=jasmine.javascript
  au BufRead,BufNewFile *Helper.coffee,*Spec.coffee  set filetype=jasmine.coffee
  au BufRead,BufNewFile,BufReadPre *Helper.coffee,*Spec.coffee  let b:quickrun_config = {'type' : 'coffee'}
  call jasmine#load_snippets()
  map <buffer> <leader>m :JasmineRedGreen<CR>
  command! JasmineRedGreen :call jasmine#redgreen()
  command! JasmineMake :call jasmine#make()
endfunction
au BufRead,BufNewFile,BufReadPre *.coffee,*.js call JasmineSetting()

"------------------------------------
" indent_guides
"------------------------------------
" インデントの深さに色を付ける
let g:indent_guides_start_level=2
let g:indent_guides_auto_colors=0
let g:indent_guides_enable_on_vim_startup=0
let g:indent_guides_color_change_percent=20
let g:indent_guides_guide_size=1
let g:indent_guides_space_guides=1

hi IndentGuidesOdd  ctermbg=235
hi IndentGuidesEven ctermbg=237
au FileType coffee,ruby,javascript,python IndentGuidesEnable
nmap <silent><Leader>ig <Plug>IndentGuidesToggle

au BufNewFile,BufRead *.ejs set filetype=html

" filetpe {{{1
" default {{{2
syntax enable
filetype plugin indent on
set autoindent
set expandtab tabstop< softtabstop=2 shiftwidth=2


" C {{{
autocmd Filetype c setlocal
  \ expandtab
  \ tabstop<
  \ softtabstop=2
  \ shiftwidth=2

" Java {{{
autocmd Filetype java setlocal
  \ expandtab
  \ tabstop<
  \ softtabstop=4
  \ shiftwidth=4


"accelerate.vim

"let g:accelerate_timeout = 90
"
"call accelerate#map('nv', 'e', '<C-u>', 'repeat("\<C-u>", v:count1)')
"call accelerate#map('nv', 'e', '<C-d>', 'repeat("\<C-d>", v:count1)')
" 
"call accelerate#map('nv', '', 'j', 'gj')
"call accelerate#map('nv', '', 'k', 'gk')
"call accelerate#map('nv', '', 'h', 'h')
"call accelerate#map('nv', 'e', 'l', 'foldclosed(line(".")) != -1 ? "zo" : "l"')

"ctrlp

noremap <C-p> :<C-u>CtrlP .<CR>
noremap <C-@> :<C-u>CtrlP ~/<CR>
let g:ctrlp_show_hidden = 1

set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<

noremap <F5> :source ~/.vimrc<CR>
