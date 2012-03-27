" exec vam#DefineAndBind('s:c','g:vim_addon_urweb','{}')
if !exists('g:vim_addon_urweb') | let g:vim_addon_urweb = {} | endif | let s:c = g:vim_addon_urweb

let s:c.ctag_recursive = get(s:c,'ctag_recursive','ctags -R ')
let s:c.extra_urweb_args = get(s:c, 'extra_urweb_args', string(function('urweb#ExtraUrwebArgs')))

let s:c.complete_lhs_tags = get(s:c, 'complete_lhs_tags', '<c-x><c-o>')
let s:c.complete_lhs      = get(s:c, 'complete_lhs', '<c-x><c-u>')


augroup URWEB
  au!

  " for ur and urs file define completions. Customize mappings by overwriting defaults above
  autocmd FileType ur,urs
    \ call vim_addon_completion#InoremapCompletions(s:c, [
       \ { 'setting_keys' : ['complete_lhs'], 'fun': 'urweb#UrComplete'},
       \ { 'setting_keys' : ['complete_lhs_tags'], 'fun': 'htmlcomplete#CompleteTags'}
       \ ] )

  " this may change:
  autocmd BufRead,BufNewFile *.ur  setlocal ft=ur
  autocmd BufRead,BufNewFile *.urs setlocal ft=urs
  autocmd BufRead,BufNewFile *.urp setlocal ft=urp


augroup end

command! -nargs=* -complete=customlist,urweb#UrwebProjectFileCompletion URWEBSetProjectFile call urweb#SetUrwebProjectFile(<f-args>)

call actions#AddAction('run urweb and (re) start web app', {'action': funcref#Function('urweb#CompileRHS', {'args': ['standalone']})})
call actions#AddAction('run urweb fastcgi', {'action': funcref#Function('urweb#CompileRHS', {'args': ['fastcgi']})})
call actions#AddAction('run urweb cgi', {'action': funcref#Function('urweb#CompileRHS', {'args': ['cgi']})})

" toggle .urs <-> .ur
exec vam#DefineAndBind('s:l','g:vim_addon_toggle_buffer','{}')
let s:l['urweb'] = funcref#Function('urweb#ToggleBufferAlternates')
