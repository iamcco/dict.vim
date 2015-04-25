#!/usr/bin/env python
#-*- coding:utf-8 -*-

"""
Last Change: 2015-04-25
Maintainer: iamcco <ooiss@qq.com>
Github: http://github.com/iamcco <年糕小豆汤>
Version: 1.0.0
"""

import vim
import json
import urllib
from common import cData,dictShow

def dictSearch():
    searchType = vim.eval('a:searchType')
    queryWords = vim.eval('iconv(a:queryWords, &encoding, "utf-8")')
    initData = cData['info'][1:] + (urllib.quote(queryWords),)
    queryUrl   = cData['info'][0] % initData
    dataBack   = urllib.urlopen(queryUrl).read()
    try:
        dataJson   = json.loads(dataBack)
        dictShow(dataJson, searchType)
    except ValueError:
        print(cData['errorCode']['noQuery'])

__all__ = ['dictSearch']
