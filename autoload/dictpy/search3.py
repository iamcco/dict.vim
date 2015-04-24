#!/usr/bin/env python
#-*- coding:utf-8 -*-

import vim
import json
from urllib import request
from dictpy.common import cData,dictShow

def dictSearch():
    queryWords = vim.eval('iconv(a:queryWords, &encoding, "utf-8")')
    initData = cData['info'][1:] + (request.quote(queryWords.encode('utf-8')),)
    queryUrl   = cData['info'][0] % initData
    dataBack   = request.urlopen(queryUrl).read().decode('utf-8')
    dataJson   = json.loads(dataBack)
    dictShow(dataJson, queryWords)

__all__ = ["dictSearch"]
