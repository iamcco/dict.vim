#!/usr/bin/env python
#-*- coding:utf-8 -*-

import vim

cData = {
    "errorCode":{
        "0": u"success",
        "20": u"要求翻译的文本过长",
        "30": u"无法进行有效的翻译",
        "40": u"不支持的语言类型",
        "50": u"无效的key",
        "60": u"无词典结果，仅在获取词典结果生效",
        "other": u"查询失败，出现未知错误"
    },
    "vimEncoding": vim.eval("&encoding"),
    "info": (vim.eval("s:query_url"), vim.eval("g:keyfrom"), vim.eval("g:api_key"))
}

def dictShow(searchResult, qw):
    error_code = searchResult["errorCode"]
    if error_code == 0:
        translation = []
        for item in searchResult["translation"]:
            translation.append(item)
        translation = qw + ' ==> ' + '\n'.join(translation)
        try:
            explains = []
            for item in searchResult["basic"]["explains"]:
                explains.append(item)
            explains = " @ " + " ".join(explains)
        except KeyError:
            explains = ''
        print(translation + explains)
    elif error_code == 20:
        print(cData["errorCode"]["20"])
    elif error_code == 30:
        print(cData["errorCode"]["30"])
    elif error_code == 40:
        print(cData["errorCode"]["40"])
    elif error_code == 50:
        print(cData["errorCode"]["50"])
    elif error_code == 60:
        print(cData["errorCode"]["60"])
    else:
        print(cData["errorCode"]["other"])

__all__ = ["cData", "dictShow"]
