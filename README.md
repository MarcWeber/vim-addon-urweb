== small utils to ease learning urweb

== installation
use http://github.com/MarcWeber/vim-addon-manager
This plugin depends on some of its features. vim-addon-manager will also install some dependencies for you.

provided features:

      * snippets/urweb_project.snippet
      * tag based completion
      * downloading and tagging the standard library (can you call it that way?)
      * compilation action + error format (see vim-addon-actions)
        (on linux the standalone server can automatically be restarted)
      * toggle .ur .urs files (see vim-addon-toggle-buffer)
      * using snipmate you get many html related snippets (use the fork on my github page)
      * matchit suppert for
        - xml tags
        - let in end
        - fu
      * html completion support (same as when editing .html files)

== customization ==

  s:c is bound to global g:vim_addon_urweb - so you can override settings.

  let g:vim_addon_urweb = {}
  let g:vim_addon_urweb.ctag_recursive = 'ctags-svn-wrapped -R '
  let g:vim_addon_urweb.extra_urweb_args = funcref#Function('return ARGS[0].target == "fastcgi" ? ["-output", "yourdir/". fnamemodify(ARGS[0].exe,":r").".fcgi"] : call(function("urweb#ExtraUrwebArgs"),ARGS)')

== setup ctags
add to your ~/.ctags file:

    --langdef=urweb
    --langmap=urweb:.ur,urweb:+.urs
    --regex-urweb=/^[ \t]*val[ \t]+([A-Za-z0-9_]+)/\1/v,function/
    --regex-urweb=/^[ \t]*(fun|and)[ \t]+([A-Za-z0-9_]+)/\2/v,function/
    --regex-urweb=/^[ \t]*class[ \t]+([A-Za-z0-9_]+)/\1/c,class/
    --regex-urweb=/^[ \t]*con[ \t]+([A-Za-z0-9_]+)/\1/n,con/
    --regex-urweb=/^[ \t]*view[ \t]+([A-Za-z0-9_]+)/\1/v,view/
    --regex-urweb=/^[ \t]*table[ \t]+([A-Za-z0-9_]+)/\1/t,table/
    --regex-urweb=/^[ \t]*cookie[ \t]+([A-Za-z0-9_]+)/\1/o,cookie/
    --regex-urweb=/^[ \t]*structure[ \t]+([A-Za-z0-9_]+)/\1/c,structure/

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

== vim-addon-async support ==
Want to see the log of the standalone application?

Put this into your .vimrc:

    let g:vim_addon_urweb = { 'use_vim_addon_async' : 1 }


== How to contribute ? ==
Send patches or ideas. Even if you don't have the skills to implement them
(yet) I'd like to keep a list of them. I can't promise to implement them.
But maybe I can help you getting started a lot faster
