" copied from ftplugin/xml.vim
" XML:  thanks to Johannes Zellner and Akbar Ibrahim
" - case sensitive
" - don't match empty tags <fred/>
" - match <!--, --> style comments (but not --, --)
" - match <!, > inlined dtd's. This is not perfect, as it
"   gets confused for example by
"       <!ENTITY gt ">">
if exists("loaded_matchit")
    let b:match_ignorecase=0
    let old = exists('b:match_words') ? b:match_words.',' : ''
    let b:match_words =
     \  old.
     \  '<:>,' .
     \  '<\@<=!\[CDATA\[:]]>,'.
     \  '<\@<=!--:-->,'.
     \  '<\@<=?\k\+:?>,'.
     \  '<\@<=\([^ \t>/]\+\)\%(\s\+[^>]*\%([^/]>\|$\)\|>\|$\):<\@<=/\1>,'.
     \  '<\@<=\%([^ \t>/]\+\)\%(\s\+[^/>]*\|$\):/>'

     " ur support for
     " 1) struct .. end
     " 2) let .. in .. end
     " 3) sig .. end
     let b:match_words .=
     \  ',\<\%(let\|struct\|sig\)\>:\<in\>:\<end\>'

     " jump to next functions
     let b:match_words .=
     \  ',^\<fun\>:^\<and\|fun\|val\>:DOES_NOT_EXIST'

     " () [] {} <>
     " why do I have to add them ? Shouldn't they be default?
     let b:match_words .=
     \  ',(:),\[:\],{:},<:>'
endif

" this will assign both: omnifunc and completefunc
inoremap <buffer> <C-x><C-u> <c-o>:setlocal omnifunc=urweb#UrComplete<cr><c-x><c-o>

" this is better than having no indentation:
setlocal autoindent
