== small utils to ease learning urweb

== installation
use vim-addon-manager. This plugin depends on some of its features

provided features:

      * snippets/urweb_project.snippet
      * tag based completion
      * downloading and tagging the standard library (can you call it that way?)
      * compilation action + error format
        (on linux the standalone server can automatically be restarted)
      * toggle .ur .urs files (see vim-addon-toggle-buffer)
      * using snipmate you get many html related snippets (use the fork on my github page)

== setup ctags
add to your ~/.ctags file:

    --langdef=urweb
    --langmap=urweb:.ur,urweb:+.urs
    --regex-urweb=/^[ \t]*val[ \t]+([A-Za-z0-9_]+)/\1/v,function/
    --regex-urweb=/^[ \t]*class[ \t]+([A-Za-z0-9_]+)/\1/c,class/
    --regex-urweb=/^[ \t]*con[ \t]+([A-Za-z0-9_]+)/\1/n,con/
    --regex-urweb=/^[ \t]*view[ \t]+([A-Za-z0-9_]+)/\1/v,view/
    --regex-urweb=/^[ \t]*table[ \t]+([A-Za-z0-9_]+)/\1/t,table/

== why a separate distribution ? ==

Adam Chlipala generiously offered me integrating this code into the main
distrbituion. There are various reasons why I'd like to keep it separate for
now:

  - I copied code from Vim. I'm to lazy to care about all license details
  - It depends on many other .vim files, see dependencies list in
    vim-addon-urweb-addon-info.txt
    So its much more convenient for you installing it and its dependencies using
    vim-addon-manager
  - Its still very experimental and very likely to change. So sending Adam
    Chlipala patches would cause too much overhead.

== How to contribute ? ==
Send patches or ideas. Even if you don't have the skills to implement them
(yet) I'd like to keep a list of them. I can't promise to implement them.
But maybe I can help you getting started a lot faster
