augroup URWEB
  autocmd BufRead,BufNewFile *.urp setlocal ft=urweb_project
  " this may change:
  autocmd BufRead,BufNewFile *.ur,*.urs setlocal ft=urweb
augroup end

command! -nargs=* -complete=customlist,urweb#UrwebProjectFileCompletion URWEBSetProjectFile call urweb#SetUrwebProjectFile(<f-args>)


" completion
call vim_addon_completion#RegisterCompletionFunc({
      \ 'description' : 'ur function completion',
      \ 'completeopt' : 'preview,menu,menuone',
      \ 'scope' : 'urweb',
      \ 'func': 'urweb#UrComplete'
      \ })
