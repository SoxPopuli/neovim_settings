" EXAPunks syntax highlighting
syn case ignore

if exists("b:current_syntax")
    finish
endif


syn match exaNumber '\d\+'
syn match exaNumber '-\d\+'
syn match exaRegister '[XTFM]'
syn match exaHardware '#[a-zA-Z]\+'

syn match exaLabel '[a-zA-Z_]\+' contained

syn match exaTests '.*[\<\>\=].*' contained contains=exaNumber,exaRegister,exaHardware
syn match exaTests 'MRD' contained
syn match exaTests 'EOF' contained

syn keyword exaInstructions LINK ADDI MULI SUBI DIVI SWIZ COPY VOID MAKE nextgroup=exaNumber,exaRegister,exaHardware skipwhite
syn keyword exaInstructions LINK HOST                                    nextgroup=exaNumber,exaRegister,exaHardware skipwhite
syn keyword exaInstructions GRAB FILE SEEK VOID                          nextgroup=exaNumber,exaRegister,exaHardware skipwhite
syn keyword exaLabelInstruction MARK JUMP TJMP FJMP REPL                 nextgroup=exaLabel skipwhite
syn keyword exaTest TEST                                                 nextgroup=exaTests skipwhite
syn keyword exaStandalone MAKE DROP WIPE HALT KILL MODE NOOP 

syn match exaMacro '@REP' nextgroup=exaNumber
syn match exaMacro '@END'
syn match exaMacro '@{.*}' contains=exaNumber

syn match exaComment ";.*$"
syn match exaComment "NOTE .*$"

let b:current_syntax = "exa"

hi def link exaLabelInstruction Statement
hi def link exaTest Function
hi def link exaStandalone Function
hi def link exaInstructions Function

hi def link exaComment Comment
hi def link exaMacro PreProc

hi def link exaNumber Number
hi def link exaRegister Type
hi def link exaHardware String

hi def link exaLabel String
hi def link exaTests Boolean
