augroup URWEB
  au!
  " this may change:
  autocmd BufRead,BufNewFile *.ur  setlocal ft=ur
  autocmd BufRead,BufNewFile *.urs setlocal ft=urs
  autocmd BufRead,BufNewFile *.urp setlocal ft=urp
augroup end

command! -nargs=* -complete=customlist,urweb#UrwebProjectFileCompletion URWEBSetProjectFile call urweb#SetUrwebProjectFile(<f-args>)


" completion
call vim_addon_completion#RegisterCompletionFunc({
      \ 'description' : 'ur function completion',
      \ 'completeopt' : 'preview,menu,menuone',
      \ 'scope' : 'ur',
      \ 'func': 'urweb#UrComplete'
      \ })

call actions#AddAction('run urweb and (re) start web app', {'action': funcref#Function('urweb#CompileRHS', {'args': ['standalone']})})
call actions#AddAction('run urweb fastcgi', {'action': funcref#Function('urweb#CompileRHS', {'args': ['fastcgi']})})
call actions#AddAction('run urweb cgi', {'action': funcref#Function('urweb#CompileRHS', {'args': ['cgi']})})

" toggle .urs <-> .ur
exec scriptmanager#DefineAndBind('s:l','g:vim_addon_toggle_buffer','{}')
let s:l['urweb_ur'] = funcref#Function('return vim_addon_toggle#Substitute('.string('ur').','.string('urs').')')
let s:l['urweb_urs'] = funcref#Function('return vim_addon_toggle#Substitute('.string('urs').','.string('ur').')')
