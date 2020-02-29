" Language: DOMjudge checktestdata specification
" Maintainer: Andrew Smith
" License: GPL
" Latest Revision: 29 February 2020

" Ensure that this syntax has not already been defined
if exists('b:current_syntax') && b:current_syntax == 'checktestdata'
    finish
endif


" {{{ Punctuation and errors
syntax sync fromstart
syntax region ctdParen transparent contained start='(' end=')' contains=@ctdTestStatement

syntax match ctdParenError ')'
highlight default link ctdParenError Error
syntax keyword ctdEndError END
highlight default link ctdEndError Error
" }}}

" {{{ Comments
syntax match ctdComment '#.*$'
highlight default link ctdComment Comment
" }}}

" {{{ Literals
" Integers
syntax match ctdIntegerLiteral display '\<\(0\|[1-9][0-9]*\)'
highlight default link ctdIntegerLiteral Number

" Floats
syntax match ctdFloatLiteral display '\<[0-9]\+\(\.[0-9]\+\)\=\([eE][-+]\=[0-9]\+\)\='
highlight default link ctdFloatLiteral Float

" String escape sequences
syntax match ctdStringEscapes display contained '\\[ntrb\\"]'
syntax match ctdStringEscapes display contained '\\[0-7]\{1,3}'
highlight default link ctdStringEscapes SpecialChar
" Strings
syntax region ctdStringLiteral start=/"/ skip=/\\"/ end=/"/ contains=ctdStringEscapes
highlight default link ctdStringLiteral String

" Variables
syntax match ctdVariable display contained '[a-z][0-9a-z]*'
highlight default link ctdVariable Identifier

syntax cluster ctdLiteral contains=ctdIntegerLiteral,ctdFloatLiteral,ctdStringLiteral,ctdStringEscapes,ctdVariable,ctdFunction
syntax cluster ctdComma contains=ctdTestCommandComma,ctdTypeComma,ctdRepeatComma,ctdAssignmentComma
" }}}

" {{{ Operators
" Arithmetic operators
syntax match ctdArithmeticOperators display '[+\-*%/\^]'
highlight default link ctdArithmeticOperators Operator

" Comparison operators
syntax match ctdComparisonOperators display '\(<=\|>=\|<\|>\|==\|!=\)'
highlight default link ctdComparisonOperators Operator

" Boolean operators
syntax match ctdBooleanOperators display '\(!\|&&\|||\)'
highlight default link ctdBooleanOperators Operator

syntax cluster ctdOperator contains=ctdArithmeticOperators,ctdComparisonOperators,ctdBooleanOperators
syntax cluster ctdExprStatement contains=ctdParen,@ctdLiteral,ctdArithmeticOperators,ctdEndError
syntax cluster ctdTestStatement contains=ctdParen,@ctdLiteral,@ctdOperator,ctdEndError,ctdIsEOF,ctdTestCommand
" }}}

" {{{ Test commands
" ISEOF
syntax keyword ctdIsEOF ISEOF
highlight default link ctdIsEOF Boolean

syntax match ctdTestCommandComma display contained ','
highlight default link ctdTestCommandComma Boolean

" MATCH(str)
syntax region ctdMatch contained transparent matchgroup=ctdTestCommand start='\<MATCH(' end=')' contains=ctdStringLiteral,ctdVariable,ctdEndError containedin=ALL
" UNIQUE(a, b)
syntax region ctdUnique contained transparent matchgroup=ctdTestCommand start='\<UNIQUE(' end=')' contains=ctdVariable,ctdTestCommandComma,ctdEndError containedin=ALL
" INARRAY(val, var)
syntax region ctdInArray contained transparent matchgroup=ctdTestCommand start='\<INARRAY(' end=')' contains=@ctdLiteral,ctdTestCommandComma,ctdEndError containedin=ALL

highlight default link ctdTestCommand Boolean
" }}}

" {{{ Literal words
syntax keyword ctdLiteralWords SPACE NEWLINE EOF
highlight default link ctdLiteralWords Keyword
" }}}

" {{{ STRLEN
syntax region ctdStrlen contained transparent matchgroup=ctdFunction start='\<STRLEN(' end=')' contains=ctdStringLiteral,ctdVariable,ctdEndError containedin=ALL
highlight default link ctdFunction Function
" }}}

" {{{ Types
syntax match ctdTypeComma display contained ','
highlight default link ctdTypeComma Type

" INT(min, max, name)
syntax region ctdInt transparent matchgroup=ctdType start='\<INT(' end=')' contains=@ctdExprStatement,ctdTypeComma
" STRING(str)
syntax region ctdString transparent matchgroup=ctdType start='\<STRING(' end=')' contains=ctdStringLiteral,ctdVariable,ctdEndError
" REGEX(str, name)
syntax region ctdRegex transparent matchgroup=ctdType start='\<REGEX(' end=')' contains=ctdStringLiteral,ctdVariable,ctdTypeComma,ctdEndError

" {FLOAT,FLOATP}(min, max, mindecimals, maxdecimals, name, option)
syntax region ctdFloat transparent matchgroup=ctdType start='\<\(FLOATP\=\)(' end=')' contains=@ctdExprStatement,ctdTypeComma,ctdFloatOption
syntax keyword ctdFloatOption FIXED SCIENTIFIC
highlight default link ctdFloatOption Label

highlight default link ctdType Type
" }}}

" {{{ Asssertions
syntax region ctdAssertStatement transparent matchgroup=ctdAssertion start='\<ASSERT(' end=')' contains=@ctdTestStatement
highlight default link ctdAssertion Exception
" }}}

" {{{ Loops
syntax match ctdRepeatComma display contained ','
highlight default link ctdRepeatComma Repeat

" {REP,REPI}( ... )
syntax region ctdRepStart transparent matchgroup=ctdRepeat start='\<\(REPI\=\)(' end=')'me=e-1 contains=@ctdExprStatement,ctdRepeatComma nextgroup=ctdLoopBody
" {WHILE,WHILEI}( ... )
syntax region ctdWhileStart transparent matchgroup=ctdRepeat start='\<\(WHILEI\=\)(' end=')'me=e-1 contains=@ctdTestStatement,ctdRepeatComma nextgroup=ctdLoopBody
" ) ... END
syntax region ctdLoopBody contained transparent matchgroup=ctdRepeat start=')' end='\<END\>' contains=ALLBUT,ctdAssignmentOperator,ctdLoopBody,ctdCondBody,ctdCondElse,ctdVariable,@ctdComma

highlight default link ctdRepeat Repeat
" }}}

" {{{ Conditionals
" IF( ... )
syntax region ctdCondStart transparent matchgroup=ctdConditional start='\<IF(' end=')'me=e-1 contains=@ctdTestStatement nextgroup=ctdCondBody
" ) ... END
syntax region ctdCondBody contained transparent matchgroup=ctdConditional start=')' end='\<END\>' contains=ALLBUT,ctdAssignmentOperator,ctdCondBody,ctdLoopBody,ctdVariable,@ctdComma
" ELSE
syntax keyword ctdCondElse ELSE

highlight default link ctdConditional Conditional
highlight default link ctdCondElse Conditional
" }}}

" {{{ Assignment
syntax region ctdSetBlock transparent matchgroup=ctdAssignment start='\<SET(' end=')' contains=@ctdExprStatement,ctdAssignmentOperator,ctdAssignmentComma
syntax region ctdUnsetBlock transparent matchgroup=ctdAssignment start='\<UNSET(' end=')' contains=ctdVariable,ctdEndError,ctdAssignmentComma

syntax match ctdAssignmentOperator display contained '='
syntax match ctdAssignmentComma display contained ','

highlight default link ctdAssignment Define
highlight default link ctdAssignmentOperator Define
highlight default link ctdAssignmentComma Define
" }}}


" Prevent redefinition on reload
if !exists('b:current_syntax')
    let b:current_syntax = 'checktestdata'
endif
