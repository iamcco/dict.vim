"===============================================================================
"File: autoload/dict.vim
"Description: 简单的翻译插件
"Last Change: 2015-04-25
"Maintainer: iamcco <ooiss@qq.com>
"Github: http://github.com/iamcco <年糕小豆汤>
"Licence: Vim Licence
"Version: 1.0.0
"===============================================================================

if !exists('g:dict_py_version')
    if has('python')
        let g:dict_py_version = 2
        let s:py_cmd = 'py '
    elseif has('python3')
        let g:dict_py_version = 3
        let s:py_cmd = 'py3 '
    else
        echoerr 'Error: dict.vim requires vim has python/python3 features'
        finish
    endif
else
    if g:dict_py_version == 2
        let s:py_cmd = 'py '
    else
        let s:py_cmd = 'py3 '
    endif
endif

"有道openapi key
if !exists('g:api_key') || !exists('g:keyfrom')
    let g:api_key = '1932136763'
    let g:keyfrom = 'aioiyuuko'
endif

"有道openapi
let s:query_url = 'http://fanyi.youdao.com/openapi.do?keyfrom=%s&key=%s&type=data&doctype=json&version=1.1&q=%s'

function! dict#Search(args, searchType) abort
    let queryWord = substitute(a:args,'^ *\\| *$','','g')
    if queryWord != ''
        call s:DictSearch(queryWord, a:searchType)
    endif
endfunction

function! dict#VSearch(searchType) abort
    let vtext = s:DictGetSelctn()
    call dict#Search(vtext, a:searchType)
endfunction

function! dict#DictStatusLine(...) abort
    if bufname('%') == '__dictSearch__'
        let w:airline_section_a = 'Dict'
        let w:airline_section_b = 'Result'
        let w:airline_section_c = ''
        let w:airline_section_x = ''
        let w:airline_section_y = ''
    endif
endfunction

if exists('g:loaded_airline')
    "airline插件statusline集成
    call airline#add_statusline_func('dict#DictStatusLine')
endif

function! s:DictGetSelctn() abort
    let regTmp = @a
    exec "normal gv\"ay"
    let vtext = @a
    let @a = regTmp
    return vtext
endfunction

function! s:WinConfig() abort
    setl filetype=dictSearch
    setl buftype=nofile
    setl bufhidden=hide
    setl noswapfile
    setl noreadonly
    setl nomodifiable
    setl nobuflisted
    setl nolist
    setl nonumber
    setl nowrap
    setl winfixwidth
    setl winfixheight
    setl textwidth=0
    setl nospell
    setl nofoldenable
    setl conceallevel=3
    setl concealcursor=icvn

    nnoremap <silent><buffer> q :close<CR>
endfunction

function! s:OpenWindow() abort
    let cwin = bufwinnr('__dictSearch__')
    if cwin == -1
        silent keepalt bo split __dictSearch__
        call s:WinConfig()
        return winnr()
    else
        return cwin
    endif
endfunction

"python/python3 import init
exec s:py_cmd . 'import vim'
exec s:py_cmd . 'import sys'
exec s:py_cmd . 'cwd = vim.eval("expand(\"<sfile>:p:h\")")'
exec s:py_cmd . 'sys.path.insert(0,cwd)'
exec s:py_cmd . 'from dictpy import search'

function! s:DictSearch(queryWords, searchType) abort

    exec s:py_cmd . 'search.dictSearch()'

endfunction
