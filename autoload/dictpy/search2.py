#!/usr/bin/env python
#-*- coding:utf-8 -*-

import vim
import json
import urllib
from common import cData,dictShow

def dictSearch():
    queryWords = vim.eval('iconv(a:queryWords, &encoding, "utf-8")')
    initData = cData['info'][1:] + (urllib.quote(queryWords),)
    queryWords  = queryWords.decode('utf-8')
    queryUrl   = cData['info'][0] % initData
    dataBack   = urllib.urlopen(queryUrl).read()
    dataJson   = json.loads(dataBack)
    dictShow(dataJson, queryWords)

__all__ = ["dictSearch"]
