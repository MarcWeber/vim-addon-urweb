" very simple translation of urweb-mode.el

syn keyword Statement   and case class con constraint constraints datatype else end extern fn map fun functor if include of open let in rec sequence sig signature cookie style task policy struct structure table view then type val where with Name Type Unit               

syn keyword PreProc  SELECT DISTINCT FROM AS WHERE SQL GROUP ORDER BY HAVING LIMIT OFFSET ALL UNION INTERSECT EXCEPT TRUE FALSE AND OR NOT COUNT AVG SUM MIN MAX ASC DESC INSERT INTO VALUES UPDATE SET DELETE PRIMARY KEY CONSTRAINT UNIQUE CHECK FOREIGN REFERENCES ON NO ACTION CASCADE RESTRICT NULL JOIN INNER OUTER LEFT RIGHT FULL CROSS SELECT1

" urweb-lident-regexp
syn match  Identifier  '\<[a-z_][A-Za-z0-9_']*\>'
" urweb-cident-regexp
syn match  Delimiter '\<[A-Z][A-Za-z0-9_']*\>'
