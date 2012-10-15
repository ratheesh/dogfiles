" GUI オンリーなプラグインのロード
NeoBundleSource open-browser.vim
NeoBundleSource twibill.vim
NeoBundleSource webapi-vim
NeoBundleSource TweetVim
NeoBundleSource neco-tweetvim
NeoBundleSource tweetvim-advanced-filter

colorscheme molokai
" IM の起動キーを gVim に教える
" set imactivatekey=S-space
set iminsert=2
set vb t_vb=
" フォント設定
set guifont=Migu\ 2M\ 14
set guioptions-=e

let g:openbrowser_open_commands = ['google-chrome', 'xdg-open', 'w3m']
if !exists('g:openbrowser_open_rules')
    let g:openbrowser_open_rules = {}
endif
let g:openbrowser_open_rules['google-chrome'] = "{browser} {shellescape(uri)}"

let g:tweetvim_display_icon = 1
let g:tweetvim_tweet_per_page = 60

command -nargs=1 TweetVimFavorites call call('tweetvim#timeline',['favorites',<q-args>])

nnoremap <silent><Leader>tw :<C-u>tabnew <Bar> TweetVimHomeTimeline<CR>
nnoremap <silent><Leader>tl :<C-u>TweetVimHomeTimeline<CR>
nnoremap <silent><Leader>tm :<C-u>TweetVimMentions<CR>
nnoremap <Leader>ts :<C-u>TweetVimSay<CR>
nnoremap <Leader>tu :<C-u>TweetVimUserTimeline<Space>

augroup TweetVimSetting
    autocmd!
    " マッピング
    " 挿入・通常モードで閉じる
    autocmd FileType tweetvim_say nnoremap <buffer><silent><C-g>    :<C-u>q!<CR>
    autocmd FileType tweetvim_say inoremap <buffer><silent><C-g>    <C-o>:<C-u>q!<CR><Esc>
    " ツイート履歴を <C-l> に
    autocmd FileType tweetvim_say inoremap <buffer><silent><C-l>    <C-o>:<C-u>call unite#sources#tweetvim_tweet_history#start()<CR>
    " <Tab> は neocomplcache で使う
    autocmd FileType tweetvim_say iunmap   <buffer><Tab>
    " 各種アクション
    autocmd FileType tweetvim     nnoremap <buffer>s                :<C-u>TweetVimSay<CR>
    autocmd FileType tweetvim     nmap     <buffer>c                <Plug>(tweetvim_action_in_reply_to)
    autocmd FileType tweetvim     nnoremap <buffer>t                :<C-u>Unite tweetvim -no-start-insert -quick-match<CR>
    autocmd FileType tweetvim     nmap     <buffer><Leader>F        <Plug>(tweetvim_action_remove_favorite)
    autocmd FileType tweetvim     nmap     <buffer><Leader>d        <Plug>(tweetvim_action_remove_status)
    " リロード後はカーソルを画面の中央に
    autocmd FileType tweetvim     nmap     <buffer><Tab>            <Plug>(tweetvim_action_reload)
    autocmd FileType tweetvim     nmap     <buffer><silent>gg       gg<Plug>(tweetvim_action_reload)
    " ページ移動を ff/bb から f/b に
    autocmd FileType tweetvim     nmap     <buffer>f                <Plug>(tweetvim_action_page_next)
    autocmd FileType tweetvim     nmap     <buffer>b                <Plug>(tweetvim_action_page_previous)
    " favstar や web UI で表示
    autocmd FileType tweetvim     nnoremap <buffer><Leader><Leader> :<C-u>call <SID>tweetvim_favstar()<CR>
    autocmd FileType tweetvim     nnoremap <buffer><Leader>u        :<C-u>call <SID>tweetvim_open_home()<CR>
    " 縦移動
    autocmd FileType tweetvim     nnoremap <buffer><silent>j        :<C-u>call <SID>tweetvim_vertical_move("j")<CR>zz
    autocmd FileType tweetvim     nnoremap <buffer><silent>k        :<C-u>call <SID>tweetvim_vertical_move("k")<CR>zz
    " タイムライン各種
    autocmd FileType tweetvim     nnoremap <silent><buffer>gm       :<C-u>TweetVimMentions<CR>
    autocmd FileType tweetvim     nnoremap <silent><buffer>gh       :<C-u>TweetVimHomeTimeline<CR>
    autocmd FileType tweetvim     nnoremap <silent><buffer>gu       :<C-u>TweetVimUserTimeline<Space>
    autocmd FileType tweetvim     nnoremap <silent><buffer>gf       :<C-u>call call('tweetvim#timeline', ['favorites', 'Linda_pp'])<CR>
    " 不要なマップを除去
    autocmd FileType tweetvim     nunmap   <buffer>ff
    autocmd FileType tweetvim     nunmap   <buffer>bb
    " 半自動リロード
    autocmd BufEnter * call <SID>tweetvim_reload()
augroup END

" セパレータを飛ばして移動する
function! s:tweetvim_vertical_move(cmd)
    execute "normal! ".a:cmd
    let end = line('$')
    while getline('.') =~# '^[-~]\+$' && line('.') != end
        execute "normal! ".a:cmd
    endwhile
    " 一番上/下まで来たら次のページに進む
    let line = line('.')
    if line == end
        call feedkeys("\<Plug>(tweetvim_action_page_next)")
    elseif line == 1
        call feedkeys("\<Plug>(tweetvim_action_page_previous)")
    endif
endfunction

" ツイートをリロード
function! s:tweetvim_reload()
    if &filetype ==# "tweetvim"
        call feedkeys("\<Plug>(tweetvim_action_reload)")
    endif
endfunction

function! s:tweetvim_favstar()
    let screen_name = matchstr(getline('.'),'^\s\zs\w\+')
    let route = empty(screen_name) ? 'me' : 'users/'.screen_name

    execute "OpenBrowser http://ja.favstar.fm/".route
endfunction

function! s:open_favstar()
    let username = expand('<cword>')
    if empty(username)
        OpenBrowser http://ja.favstar.fm/me
    else
        execute "OpenBrowser http://ja.favstar.fm/users/" . username
    endif
endfunction
command! OpenFavstar call <SID>open_favstar()

function! s:tweetvim_open_home()
    let username = expand('<cword>')
    if username =~# '^[a-zA-Z0-9_]\+$'
        execute "OpenBrowser https://twitter.com/" . username
    endif
endfunction

if filereadable($HOME.'/.tweetvimrc')
    source $HOME/.tweetvimrc
endif
" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8