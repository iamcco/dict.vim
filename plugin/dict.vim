"===============================================================================
"File: plugin/dict.vim
"Description: An translation tool which uses the youdao openapi
"Last Change: 2015-04-18
"Maintainer: iamcco <ooiss@qq.com>
"Github: http://github.com/iamcco <年糕小豆汤>
"Licence: Vim Licence
"Version: 0.0.1
"===============================================================================

if !exists("g:debug_dict") && exists("g:loaded_dict") && !has("python")
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

nmap <silent> <Plug>DictSearch :call dict#Search(expand("<cword>"))<CR>
vmap <silent> <Plug>DictVSearch :<C-U>call dict#VSearch()<CR>

if !exists(':Dict')
    command! -nargs=1 Dict call dict#Search(<q-args>)
endif


let &cpo = s:save_cpo
unlet s:save_cpo
