"===============================================================================
"File: autoload/dict.vim
"Description: An translation tool which uses the youdao openapi
"Last Change: 2015-04-19
"Maintainer: iamcco <ooiss@qq.com>
"Github: http://github.com/iamcco <年糕小豆汤>
"Licence: Vim Licence
"Version: 0.0.6
"===============================================================================

if !exists("g:api_key") || !exists("g:keyfrom")
    let g:api_key = "1932136763"
    let g:keyfrom = "aioiyuuko"
endif

let s:query_url = "http://fanyi.youdao.com/openapi.do?keyfrom=%s&key=%s&type=data&doctype=json&version=1.1&q=%s"

function! dict#Search(args) abort
    let query_word = substitute(a:args,"^ *\\| *$","","g")
    if query_word != ''
        call s:Dict_query(query_word)
    endif
endfunction

function! dict#VSearch() abort
    let vtext = s:Dict_get_selection()
    call dict#Search(vtext)
endfunction

function! s:Dict_get_selection()
    let [ln1, col1] = getpos("'<")[1:2]
    let [ln2, col2] = getpos("'>")[1:2]
    let lines = getline(ln1, ln2)
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
endfunction

function! s:Dict_query(query_word)
python << END
#-*- coding:utf-8 -*-

import vim
import sys
import json
import urllib2

errorCode = {
    "0": u"success",
    "20": u"要求翻译的文本过长",
    "30": u"无法进行有效的翻译",
    "40": u"不支持的语言类型",
    "50": u"无效的key",
    "60": u"无词典结果，仅在获取词典结果生效",
    "other": u"查询失败，出现未知错误"
}
vimencoding = vim.eval("&encoding")
qw_origin   = vim.eval("a:query_word").decode(vimencoding)
info        = ( vim.eval("s:query_url"), \
                vim.eval("g:keyfrom"), \
                vim.eval("g:api_key"), \
                urllib2.quote(qw_origin.encode('utf-8')))
query_url   = info[0] % info[1:]
data_back   = urllib2.urlopen(query_url)
data_origin = data_back.read()
data_json   = json.loads(data_origin)

def show(info_data, qw):
    error_code = info_data["errorCode"]
    if error_code == 0:
        translation = []
        for item in info_data["translation"]:
            translation.append(item)
        translation = qw + ' ==> ' + '\n'.join(translation)
        try:
            explains = []
            for item in info_data["basic"]["explains"]:
                explains.append(item)
            explains = " @ " + " ".join(explains)
        except KeyError:
            explains = ''
        print translation, explains
    elif error_code == 20:
        print errorCode["20"]
    elif error_code == 30:
        print errorCode["30"]
    elif error_code == 40:
        print errorCode["40"]
    elif error_code == 50:
        print errorCode["50"]
    elif error_code == 60:
        print errorCode["60"]
    else:
        print errorCode["other"]

if __name__ == "__main__":
    show(data_json, qw_origin)

END
endfunction
