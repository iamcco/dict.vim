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
    searchType = vim.eval('a:searchType')
    queryWords = vim.eval('iconv(a:queryWords, &encoding, "utf-8")')
    initData = cData['info'][1:] + (urllib.quote(queryWords),)
    queryUrl   = cData['info'][0] % initData
    dataBack   = urllib.urlopen(queryUrl).read().decode('utf-8')
    try:
        dataJson   = json.loads(dataBack)
        dictShow(dataJson, searchType)
    except ValueError:
        print(cData['errorCode']['noQuery'])

__all__ = ['dictSearch']
