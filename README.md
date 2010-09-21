== small utils to ease learning urweb

== installation
use vim-addon-manager. This plugin depends on some of its features

provided features:

      * snippets/urweb_project.snippet
      * tag files

== setup ctags
add to your ~/.ctags file:

    --langdef=urweb
    --langmap=urweb:.ur,urweb:+.urs
    --regex-urweb=/^[ \t]*val[ \t]+([A-Za-z0-9_]+)/\1/v,function/
    --regex-urweb=/^[ \t]*class[ \t]+([A-Za-z0-9_]+)/\1/c,class/
    --regex-urweb=/^[ \t]*con[ \t]+([A-Za-z0-9_]+)/\1/n,con/
    --regex-urweb=/^[ \t]*view[ \t]+([A-Za-z0-9_]+)/\1/v,view/
    --regex-urweb=/^[ \t]*table[ \t]+([A-Za-z0-9_]+)/\1/t,table/
