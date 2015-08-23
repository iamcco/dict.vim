"===============================================================================
"File: plugin/dict.vim
"Description: 简单的翻译插件
"Last Change: 2015-04-25
"Maintainer: iamcco <ooiss@qq.com>
"Github: http://github.com/iamcco <年糕小豆汤>
"Licence: Vim Licence
"Version: 1.0.0
"===============================================================================

if !has('python') && !has('python3')
    finish
endif

if !exists('g:debug_dict') && exists('g:loaded_dict')
    finish
endif
let g:loaded_dict= 1

let s:save_cpo = &cpo
set cpo&vim

if !hasmapto('<Plug>DictSearch')
    nmap <silent> <Leader>d <Plug>DictSearch
endif

if !hasmapto('<Plug>DictVSearch')
    vmap <silent> <Leader>d <Plug>DictVSearch
endif

if !hasmapto('<Plug>DictWSearch')
    nmap <silent> <Leader>w <Plug>DictWSearch
endif

if !hasmapto('<Plug>DictWVSearch')
    vmap <silent> <Leader>w <Plug>DictWVSearch
endif

if !hasmapto('<Plug>DictRSearch')
    nmap <silent> <Leader><Leader>r <Plug>DictRSearch
endif

if !hasmapto('<Plug>DictRVSearch')
    vmap <silent> <Leader><Leader>r <Plug>DictRVSearch
endif

nmap <silent> <Plug>DictSearch   :call dict#Search(expand("<cword>"), "simple")<CR>
vmap <silent> <Plug>DictVSearch  :<C-U>call dict#VSearch("simple")<CR>
nmap <silent> <Plug>DictWSearch  :call dict#Search(expand("<cword>"), "complex")<CR>
vmap <silent> <Plug>DictWVSearch :<C-U>call dict#VSearch("complex")<CR>
nmap <silent> <Plug>DictRSearch  viw:<C-U>call dict#VSearch("replace")<CR>
vmap <silent> <Plug>DictRVSearch :<C-U>call dict#VSearch("replace")<CR>

if !exists(':Dict')
    command! -nargs=1 Dict call dict#Search(<q-args>, 'simple')
endif

if !exists(':DictW')
    command! -nargs=1 DictW call dict#Search(<q-args>, 'complex')
endif

let &cpo = s:save_cpo
unlet s:save_cpo
