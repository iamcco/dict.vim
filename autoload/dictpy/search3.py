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
from urllib import request
from dictpy.common import cData,dictShow

def dictSearch():
    searchType = vim.eval('a:searchType')
    queryWords = vim.eval('iconv(a:queryWords, &encoding, "utf-8")')
    initData = cData['info'][1:] + (request.quote(queryWords.encode('utf-8')),)
    queryUrl   = cData['info'][0] % initData
    dataBack   = request.urlopen(queryUrl).read().decode('utf-8')
    try:
        dataJson   = json.loads(dataBack)
        dictShow(dataJson, searchType)
    except ValueError:
        print(cData['errorCode']['noQuery'])

__all__ = ['dictSearch']
