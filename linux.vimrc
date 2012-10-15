" 不可視文字
set listchars=tab:>-,trail:-,eol:$,extends:>,precedes:<,nbsp:%
" 256色使う
set t_Co=256

colorscheme wombat256mod
" プラグインのロード
filetype off
filetype plugin indent off
NeoBundle 'ujihisa/unite-locate'
NeoBundle 'Lokaltog/vim-powerline'
" GUI
NeoBundleLazy 'tyru/open-browser.vim'
NeoBundleLazy 'basyura/twibill.vim'
NeoBundleLazy 'mattn/webapi-vim'
NeoBundleLazy 'rhysd/TweetVim'
NeoBundleLazy 'yomi322/neco-tweetvim'
NeoBundleLazy 'rhysd/tweetvim-advanced-filter'
filetype plugin indent on     " required!

" プラグインの設定
let g:neocomplcache_ctags_program = '/usr/bin/ctags'
nnoremap <silent>[unite]l :<C-u>UniteWithInput locate<CR>

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8 :