#!/usr/bin/env python
#-*- coding:utf-8 -*-

"""
Last Change: 2015-04-25
Maintainer: iamcco <ooiss@qq.com>
Github: http://github.com/iamcco <年糕小豆汤>
Version: 1.0.0
"""

import vim

cData = {
    'errorCode':{
        '0': u'success',
        '20': u'要求翻译的文本过长',
        '30': u'无法进行有效的翻译',
        '40': u'不支持的语言类型',
        '50': u'无效的key',
        '60': u'无词典结果，仅在获取词典结果生效',
        'other': u'查询失败，出现未知错误',
        'noQuery': u"查询失败，有道openapi返回异常"
    },
    'vimEncoding': vim.eval('&encoding'),
    'info': (vim.eval('s:query_url'), vim.eval('g:keyfrom'), vim.eval('g:api_key'))
}

def dealSimple(searchResult):
    qw = searchResult['query']
    translation = searchResult['translation']
    translation = qw + ' ==> ' + '\n'.join(translation)
    try:
        explains = searchResult['basic']['explains']
        explains = ' @ ' + ' '.join(explains)
    except KeyError:
        explains = ''
    print(translation + explains)

def dealComplex(searchResult):
    cwinnr = int(vim.eval('s:OpenWindow()'))    #获取__dictSearch__窗口编号
    vim.command(str(cwinnr) + ' wincmd w')      #跳到__dictSearch__窗口
    cbuf = vim.current.buffer                   #获取当前__dictSearch__的buffer
    vim.command('setl modifiable')
    vim.command('%d _')
    queryStr = searchResult['query'].split('\n')
    queryStr = ( (item[0], item[1].strip()) for item in enumerate(queryStr) if item[1].strip() != '' )
    for eachline in queryStr:
        if eachline[0] == 0:
            cbuf.append(u'查找：_*_DictSearchStart_*_%s_*_DictSearchEnd_*_' % eachline[1])
        else:
            cbuf.append(u'      _*_DictSearchStart_*_%s_*_DictSearchEnd_*_' % eachline[1])
    cbuf.append('')
    tranlas = ( item for item in enumerate(searchResult['translation']) )
    for eachline in tranlas:
        if eachline[0] == 0:
            cbuf.append(u'翻译：_*_DictResultStart_*_%s_*_DictResultEnd_*_' % eachline[1])
        else:
            cbuf.append(u'      _*_DictResultStart_*_%s_*_DictResultEnd_*_' % eachline[1])
    if 'basic' in searchResult and 'explains' in searchResult['basic']:
        cbuf.append('')
        explains = ( item for item in enumerate(searchResult['basic']['explains']) )
        for eachline in explains:
            if eachline[0] == 0:
                cbuf.append(u'解释：_*_DictNounStart_*_%s_*_DictNounEnd_*_' % eachline[1])
            else:
                cbuf.append(u'      _*_DictNounStart_*_%s_*_DictNounEnd_*_' % eachline[1])
    if 'web' in searchResult:
        cbuf.append('')
        webs = ( item for item in enumerate(searchResult['web']) )
        for eachline in webs:
            if eachline[0] == 0:
                cbuf.append(u'网络：_*_DictWebStart_*_%s：%s_*_DictWebEnd_*_' % (eachline[1]['key'], ','.join(eachline[1]['value'])))
            else:
                cbuf.append(u'      _*_DictWebStart_*_%s：%s_*_DictWebEnd_*_' % (eachline[1]['key'], ','.join(eachline[1]['value'])))
    vim.command('0d _')
    vim.command('setl nomodifiable')

def strReplace(searchResult):
    tranlas = '\n'.join(searchResult['translation'])
    tranlas = tranlas.replace('"','\\"').replace("'","\\'")
    vim.command('let regTmp = @a')
    vim.command('let @a = "' + tranlas + '"')
    vim.command('normal gv"ap')
    vim.command("let @a = regTmp")
    vim.command("unlet regTmp")

def dictShow(searchResult, searchType):
    error_code = searchResult['errorCode']
    if error_code == 0:
        if searchType == 'simple':
            dealSimple(searchResult)
        elif searchType == 'replace':
            strReplace(searchResult)
        else:
            dealComplex(searchResult)
    elif error_code == 20:
        print(cData['errorCode']['20'])
    elif error_code == 30:
        print(cData['errorCode']['30'])
    elif error_code == 40:
        print(cData['errorCode']['40'])
    elif error_code == 50:
        print(cData['errorCode']['50'])
    elif error_code == 60:
        print(cData['errorCode']['60'])
    else:
        print(cData['errorCode']['other'])

__all__ = ['cData', 'dictShow']
