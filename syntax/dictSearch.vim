syn match DictSearchFlag     #_\*_DictSearch\(\(Start\)\|\(End\)\)_\*_# conceal
syn match DictSearchFlag     #_\*_DictResult\(\(Start\)\|\(End\)\)_\*_# conceal
syn match DictSearchFlag     #_\*_DictNoun\(\(Start\)\|\(End\)\)_\*_#   conceal
syn match DictSearchFlag     #_\*_DictWeb\(\(Start\)\|\(End\)\)_\*_#    conceal

syn match DictWTitle         #^.\{2}：#
syn match DictSearch         #\(_\*_DictSearchStart_\*_\)\@<=.*\(_\*_DictSearchEnd_\*_\)\@=#
syn match DictResult         #\(_\*_DictResultStart_\*_\)\@<=.*\(_\*_DictResultEnd_\*_\)\@=#
syn match DictWSecondTitle   #\(_\*_DictNounStart_\*_\)\@<=[a-zA-Z]\{-}\.#
syn match DictWNounTitle     #\(_\*_DictWebStart_\*_\)\@<=.\{-}：#
syn match DictWWebContent    #\(_\*_DictNounStart_\*_\)\@<=.*\(_\*_DictNounEnd_\*_\)\@=# contains=DictWSecondTitle
syn match DictWNounContent   #\(_\*_DictWebStart_\*_\)\@<=.*\(_\*_DictWebEnd_\*_\)\@=#   contains=DictWNounTitle

hi def link DictWTitle       Title
hi def link DictSearch       Type
hi def link DictResult       Keyword
hi def link DictWSecondTitle Question
hi def link DictWNounTitle   Question
hi def link DictWWebContent  Function
hi def link DictWNounContent Function

