#!/usr/bin/env python
#-*- coding:utf-8 -*-

"""
Last Change: 2015-05-22
Maintainer: iamcco <ooiss@qq.com>
Github: http://github.com/iamcco <年糕小豆汤>
Version: 1.0.1
"""

import vim
import json
if vim.eval('g:dict_py_version') == '2':
    import urllib
else:
    from urllib import request as urllib
from dictpy.common import cData,dictShow

def dictSearch():
    isDebug = vim.eval('exists("g:debug_dict")')
    searchType = vim.eval('a:searchType')
    queryWords = vim.eval('iconv(a:queryWords, &encoding, "utf-8")')
    initData = cData['info'][1:] + (urllib.quote(queryWords),)
    queryUrl   = cData['info'][0] % initData
    try:
        dataBack   = urllib.urlopen(queryUrl).read()
    except:
        print(u'查询失败！检查网络是否正常')
        return
    try:
        dataJson   = json.loads(dataBack.decode('utf-8'))
        dictShow(dataJson, searchType)
    except ValueError:
        if isDebug == '1':
            print(u'==================== open api response start ========================')
            print(dataBack)
            print(u'==================== open api response end ==========================')
        print(cData['errorCode']['noQuery'])

__all__ = ['dictSearch']
