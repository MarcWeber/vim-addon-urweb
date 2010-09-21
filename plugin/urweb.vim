augroup URWEB
  autocmd BufRead,BufNewFile *.urp setlocal ft=urweb_project
  " this may change:
  autocmd BufRead,BufNewFile *.ur,*.urs setlocal ft=urweb
augroup end

command! -nargs=* -complete=customlist,haxe#UrwebProjectFileCompletion URWEBSetProjectFile = call urweb#SetUrwebProjectFile(<f-args>)
