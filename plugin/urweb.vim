augroup URWEB
  autocmd BufRead,BufNewFile *.urp setlocal ft=urweb_project
augroup end

command! -nargs=* -complete=customlist,haxe#UrwebProjectFileCompletion URWEBSetProjectFile = call urweb#SetUrwebProjectFile(<f-args>)
