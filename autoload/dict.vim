"===============================================================================
"File: autoload/dict.vim
"Description: An translation tool which uses the youdao openapi
"Last Change: 2015-04-19
"Maintainer: iamcco <ooiss@qq.com>
"Github: http://github.com/iamcco <年糕小豆汤>
"Licence: Vim Licence
"Version: 0.0.6
"===============================================================================

if !exists("g:dict_py_version")
    if has("python")
        let g:dict_py_version = 2
        let s:py_cmd = "py"
    elseif has("python3")
        let g:dict_py_version = 3
        let s:py_cmd = "py3"
    else
        echoerr "Error: dict.vim requires vim has python/python3 features"
        finish
    endif
else
    if g:dict_py_version == 2
        let s:py_cmd = "py"
    else
        let s:py_cmd = "py3"
    endif
endif

"有道openapi key"
if !exists("g:api_key") || !exists("g:keyfrom")
    let g:api_key = "1932136763"
    let g:keyfrom = "aioiyuuko"
endif

"有道openapi
let s:query_url = "http://fanyi.youdao.com/openapi.do?keyfrom=%s&key=%s&type=data&doctype=json&version=1.1&q=%s"

function! dict#Search(args) abort
    let queryWord = substitute(a:args,"^ *\\| *$","","g")
    if queryWord != ''
        call s:DictSearch(queryWord)
    endif
endfunction

function! dict#VSearch() abort
    let vtext = s:DictGetSelctn()
    call dict#Search(vtext)
endfunction

function! dict#DictStatusLine(...) abort
    if bufname('%') == '__dictSearch__'
        let w:airline_section_a = 'Dict'
        let w:airline_section_b = '%{"Result"}'
        let w:airline_section_c = '%{""}'
        let w:airline_section_x = '%{""}'
        let w:airline_section_y = ''
    endif
endfunction

if exists('g:loaded_airline')
    "airline插件statusline集成
    call airline#add_statusline_func('dict#DictStatusLine')
endif

function! s:DictGetSelctn() abort
    let [ln1, col1] = getpos("'<")[1:2]
    let [ln2, col2] = getpos("'>")[1:2]
    let lines = getline(ln1, ln2)
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
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

    nnoremap <silent><buffer> q     :close<CR>
endfunction

function! s:OpenWindow() abort
    exec 'silent keepalt bo split __dictSearch__'
    call s:WinConfig()
endfunction

exec s:py_cmd . ' import vim'
exec s:py_cmd . ' import sys'
exec s:py_cmd . ' cwd = vim.eval("expand(\"<sfile>:p:h\")")'
exec s:py_cmd . ' sys.path.insert(0,cwd)'

function! s:DictSearch(queryWords) abort

    exec s:py_cmd . ' from dictpy import search' . g:dict_py_version
    exec s:py_cmd . ' search' . g:dict_py_version . '.dictSearch()'

endfunction
