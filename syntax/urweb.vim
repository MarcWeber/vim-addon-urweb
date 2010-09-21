" Quit when a syntax file was already loaded
if exists("b:current_syntax")
    finish
endif

" This syntax can still be improved a lot
" but it does
" - mark xml sections
" - mark defines ...
" - mark { .. } regions
" so its good enough for me

syn match  Include '{[^}]*}' containedin=xmlTag,xmlTagName,xmlAttrib


" fun, and, view, table, class
syn keyword Statement   case con constraint constraints datatype else end extern fn map functor if include of open let in rec sequence sig signature cookie style task policy struct structure then type val where with
syn keyword Statement   Name Type Unit
syn keyword Keyword     return
syn keyword Include     dml

" this tries to highlight the identifiers after fun, and, class
" Probably there is a smarter way to do it
syn match my_keyword '\%(fun\|view\|table\|and\|class\)\s\+\w*'
syn match my_identifier '\w\+\s\+\zs\w*' containedin=my_keyword contained
syn match Keyword '<-\|->\|<-\|->\|-->\|*\|fn\|=>\|==>\|<>\|<=\|>='

syn keyword Statement  SELECT DISTINCT FROM AS WHERE SQL GROUP ORDER BY HAVING LIMIT OFFSET ALL UNION INTERSECT EXCEPT TRUE FALSE AND OR NOT COUNT AVG SUM MIN MAX ASC DESC INSERT INTO VALUES UPDATE SET DELETE PRIMARY KEY CONSTRAINT UNIQUE CHECK FOREIGN REFERENCES ON NO ACTION CASCADE RESTRICT NULL JOIN INNER OUTER LEFT RIGHT FULL CROSS SELECT1


hi def link my_keyword	  Keyword
hi def link my_identifier Identifier


" copy paste from $VIMRUNTIME/syntax/xml.vim {{{1
" Last Change:	2009-07-13 21:26:55
" [...]
" [...]

" some changes made to adopt
" added the '-' here: matchgroup=xmlTag start=+<[^- /!?<>"']\@=+


  let s:xml_cpo_save = &cpo
  set cpo&vim

  syn case match

  " mark illegal characters
  " syn match xmlError "[<&]"

  " strings (inside tags) aka VALUES
  "
  " EXAMPLE:
  "
  " <tag foo.attribute = "value">
  "                      ^^^^^^^
  syn region  xmlString contained start=+"+ end=+"+ contains=xmlEntity,@Spell display
  syn region  xmlString contained start=+'+ end=+'+ contains=xmlEntity,@Spell display


  " punctuation (within attributes) e.g. <tag xml:foo.attribute ...>
  "                                              ^   ^
  " syn match   xmlAttribPunct +[-:._]+ contained display
  syn match   xmlAttribPunct +[:.]+ contained display

  " no highlighting for xmlEqual (xmlEqual has no highlighting group)
  syn match   xmlEqual +=+ display


  " attribute, everything before the '='
  "
  " PROVIDES: @xmlAttribHook
  "
  " EXAMPLE:
  "
  " <tag foo.attribute = "value">
  "      ^^^^^^^^^^^^^
  "
  syn match   xmlAttrib
      \ +[-'"<]\@<!\<[a-zA-Z:_][-.0-9a-zA-Z0-9:_]*\>\(['">]\@!\|$\)+
      \ contained
      \ contains=xmlAttribPunct,@xmlAttribHook
      \ display


  " namespace spec
  "
  " PROVIDES: @xmlNamespaceHook
  "
  " EXAMPLE:
  "
  " <xsl:for-each select = "lola">
  "  ^^^
  "
  if exists("g:xml_namespace_transparent")
  syn match   xmlNamespace
      \ +\(<\|</\)\@<=[^ /!?<>"':]\+[:]\@=+
      \ contained
      \ contains=@xmlNamespaceHook
      \ transparent
      \ display
  else
  syn match   xmlNamespace
      \ +\(<\|</\)\@<=[^ /!?<>"':]\+[:]\@=+
      \ contained
      \ contains=@xmlNamespaceHook
      \ display
  endif


  " tag name
  "
  " PROVIDES: @xmlTagHook
  "
  " EXAMPLE:
  "
  " <tag foo.attribute = "value">
  "  ^^^
  "
  syn match   xmlTagName
      \ +[<]\@<=[^ /!?<>"']\++
      \ contained
      \ contains=xmlNamespace,xmlAttribPunct,@xmlTagHook
      \ display


  if exists('g:xml_syntax_folding')

      " start tag
      " use matchgroup=xmlTag to skip over the leading '<'
      "
      " PROVIDES: @xmlStartTagHook
      "
      " EXAMPLE:
      "
      " <tag id="whoops">
      " s^^^^^^^^^^^^^^^e
      "
      syn region   xmlTag
          \ matchgroup=xmlTag start=+<[^- /!?<>"']\@=+
          \ matchgroup=xmlTag end=+>+
          \ contained
          \ contains=xmlError,xmlTagName,xmlAttrib,xmlEqual,xmlString,@xmlStartTagHook


      " highlight the end tag
      "
      " PROVIDES: @xmlTagHook
      " (should we provide a separate @xmlEndTagHook ?)
      "
      " EXAMPLE:
      "
      " </tag>
      " ^^^^^^
      "
      syn match   xmlEndTag
          \ +</[^ /!?<>"']\+>+
          \ contained
          \ contains=xmlNamespace,xmlAttribPunct,@xmlTagHook


      " tag elements with syntax-folding.
      " NOTE: NO HIGHLIGHTING -- highlighting is done by contained elements
      "
      " PROVIDES: @xmlRegionHook
      "
      " EXAMPLE:
      "
      " <tag id="whoops">
      "   <!-- comment -->
      "   <another.tag></another.tag>
      "   <empty.tag/>
      "   some data
      " </tag>
      "
      syn region   xmlRegion
          \ start=+<\z([^ /!?<>"']\+\)+
          \ skip=+<!--\_.\{-}-->+
          \ end=+</\z1\_\s\{-}>+
          \ matchgroup=xmlEndTag end=+/>+
          \ fold
          \ contains=xmlTag,xmlEndTag,xmlCdata,xmlRegion,xmlComment,xmlEntity,xmlProcessing,@xmlRegionHook,@Spell
          \ keepend
          \ extend

  else

      " no syntax folding:
      " - contained attribute removed
      " - xmlRegion not defined
      "
      syn region   xmlTag
          \ matchgroup=xmlTag start=+<[^- /!?<>"']\@=+
          \ matchgroup=xmlTag end=+>+
          \ contains=xmlError,xmlTagName,xmlAttrib,xmlEqual,xmlString,@xmlStartTagHook

      syn match   xmlEndTag
          \ +</[^ /!?<>"']\+>+
          \ contains=xmlNamespace,xmlAttribPunct,@xmlTagHook

  endif


  " &entities; compare with dtd
  syn match   xmlEntity                 "&[^; \t]*;" contains=xmlEntityPunct
  syn match   xmlEntityPunct  contained "[&.;]"

  if exists('g:xml_syntax_folding')

      " The real comments (this implements the comments as defined by xml,
      " but not all xml pages actually conform to it. Errors are flagged.
      syn region  xmlComment
          \ start=+<!+
          \ end=+>+
          \ contains=xmlCommentStart,xmlCommentError
          \ extend
          \ fold

  else

      " no syntax folding:
      " - fold attribute removed
      "
      syn region  xmlComment
          \ start=+<!+
          \ end=+>+
          \ contains=xmlCommentStart,xmlCommentError
          \ extend

  endif

  syn match xmlCommentStart   contained "<!" nextgroup=xmlCommentPart
  syn keyword xmlTodo         contained TODO FIXME XXX
  syn match   xmlCommentError contained "[^><!]"
  syn region  xmlCommentPart
      \ start=+--+
      \ end=+--+
      \ contained
      \ contains=xmlTodo,@xmlCommentHook,@Spell


  " CData sections
  "
  " PROVIDES: @xmlCdataHook
  "
  syn region    xmlCdata
      \ start=+<!\[CDATA\[+
      \ end=+]]>+
      \ contains=xmlCdataStart,xmlCdataEnd,@xmlCdataHook,@Spell
      \ keepend
      \ extend

  " using the following line instead leads to corrupt folding at CDATA regions
  " syn match    xmlCdata      +<!\[CDATA\[\_.\{-}]]>+  contains=xmlCdataStart,xmlCdataEnd,@xmlCdataHook
  syn match    xmlCdataStart +<!\[CDATA\[+  contained contains=xmlCdataCdata
  syn keyword  xmlCdataCdata CDATA          contained
  syn match    xmlCdataEnd   +]]>+          contained


  " Processing instructions
  " This allows "?>" inside strings -- good idea?
  syn region  xmlProcessing matchgroup=xmlProcessingDelim start="<?" end="?>" contains=xmlAttrib,xmlEqual,xmlString


  if exists('g:xml_syntax_folding')

      " DTD -- we use dtd.vim here
      syn region  xmlDocType matchgroup=xmlDocTypeDecl
          \ start="<!DOCTYPE"he=s+2,rs=s+2 end=">"
          \ fold
          \ contains=xmlDocTypeKeyword,xmlInlineDTD,xmlString
  else

      " no syntax folding:
      " - fold attribute removed
      "
      syn region  xmlDocType matchgroup=xmlDocTypeDecl
          \ start="<!DOCTYPE"he=s+2,rs=s+2 end=">"
          \ contains=xmlDocTypeKeyword,xmlInlineDTD,xmlString

  endif

  syn keyword xmlDocTypeKeyword contained DOCTYPE PUBLIC SYSTEM
  syn region  xmlInlineDTD contained matchgroup=xmlDocTypeDecl start="\[" end="]" contains=@xmlDTD
  syn include @xmlDTD $VIMRUNTIME/syntax/dtd.vim
  unlet b:current_syntax


  " synchronizing
  " TODO !!! to be improved !!!

  syn sync match xmlSyncDT grouphere  xmlDocType +\_.\(<!DOCTYPE\)\@=+
  " syn sync match xmlSyncDT groupthere  NONE       +]>+

  if exists('g:xml_syntax_folding')
      syn sync match xmlSync grouphere   xmlRegion  +\_.\(<[^ /!?<>"']\+\)\@=+
      " syn sync match xmlSync grouphere  xmlRegion "<[^ /!?<>"']*>"
      syn sync match xmlSync groupthere  xmlRegion  +</[^ /!?<>"']\+>+
  endif

  syn sync minlines=100


  " The default highlighting.
  hi def link xmlTodo		Todo
  hi def link xmlTag		Function
  hi def link xmlTagName	Statement
  hi def link xmlEndTag		Statement
  if !exists("g:xml_namespace_transparent")
      hi def link xmlNamespace	Tag
  endif
  hi def link xmlEntity		Statement
  hi def link xmlEntityPunct	Type

  hi def link xmlAttribPunct	Comment
  hi def link xmlAttrib		Type

  hi def link xmlString		String
  hi def link xmlComment		Comment
  hi def link xmlCommentStart	xmlComment
  hi def link xmlCommentPart	Comment
  hi def link xmlCommentError	Error
  hi def link xmlError		Error

  hi def link xmlProcessingDelim	Comment
  hi def link xmlProcessing	Type

  hi def link xmlCdata		String
  hi def link xmlCdataCdata	Statement
  hi def link xmlCdataStart	Type
  hi def link xmlCdataEnd		Type

  hi def link xmlDocTypeDecl	Function
  hi def link xmlDocTypeKeyword	Statement
  hi def link xmlInlineDTD	Function

  let b:current_syntax = "xml"

  let &cpo = s:xml_cpo_save
  unlet s:xml_cpo_save
" }}}

