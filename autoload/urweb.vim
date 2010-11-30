exec scriptmanager#DefineAndBind('s:c','g:vim_addon_urweb','{}')
" writeable directory so that we can tag the .ur and .urs library files
let s:c['urweb_compiler_sources_dir'] = get(s:c,'urweb_compiler_sources_dir', g:vim_script_manager['plugin_root_dir'].'/urweb-compiler-sources')

" checkout main .urp library files so that they can be tagged
fun! urweb#CheckoutUrwebSources()
  let srcdir = s:c['urweb_compiler_sources_dir']
  if !isdirectory(srcdir)
    if input('trying to checkout urweb compiler sources into '.srcdir.'. ok ? [y/n]') == 'y'
      call mkdir(srcdir.'/archive','p')
      " checking out std ony would suffice. disk is cheap today..
      call scriptmanager2#Checkout(srcdir, {'url': 'http://www.impredicative.com/ur/urweb-20100603.tgz'})
    else
      return ""
    endif
  endif
  return srcdir
endf

fun! urweb#SetUrwebProjectFile(...)
  let old = exists('g:urweb_projectfile') ? g:urweb_projectfile : ""
  if a:0 > 0
    let new_=a:1
  elseif !exists('g:urweb_projectfile')
    let new_=input('specify your .urp file file: ','','customlist,urweb#UrwebProjectFileCompletion')
  else
    let new_ = g:urweb_projectfile
  endif
  if new_ != old
    let g:urweb_projectfile=new_
    call urweb#ProjectFileChanged()
  endif
  return g:urweb_projectfile
endf

fun! urweb#UrwebProjectFileCompletion(ArgLead, CmdLine, CursorPos)
  return filter(split(glob("*.urp"), "\n"),'v:val =~'.string(a:ArgLead))
endf

fun! urweb#ProjectFileChanged()
  " tag lib
  let urwebSources = urweb#CheckoutUrwebSources()
  if urwebSources != ""
    call urweb#TagAndAdd(urwebSources.'/lib','.')
  endif
  let p = urweb#URPContents(g:urweb_projectfile)
  for lib in p.libraries
    call urweb#TagAndAdd(lib,'.')
  endfor
endf

" TODO refactor, shared by vim-addon-ocaml ?
fun! urweb#TagAndAdd(d, pat)
  call vcs_checkouts#ExecIndir([{'d': a:d, 'c': s:c.ctag_recursive.' '.a:pat}])
  exec 'set tags+='.substitute(a:d,',','\\\\,','g').'/tags'
endf


function! urweb#BcAc()
  let pos = col('.') -1
  let line = getline('.')
  return [strpart(line,0,pos), strpart(line, pos, len(line)-pos)]
endfunction

" A)
" name:type completion
" type can be string->string or such (is based on tags and only takes into " account the first line)
"
" assumens your tags have been generated with ctags (which puts uses regex as a cmd)
fun! urweb#UrComplete(findstart, base)
  if a:findstart
    let [bc,ac] = urweb#BcAc()
    let s:match_text = matchstr(bc, '\zs[^()[\]{}\t ]*$')
    let s:start = len(bc)-len(s:match_text)
    return s:start
  else
    let patterns = vim_addon_completion#AdditionalCompletionMatchPatterns(a:base
        \ , "ocaml_completion", { 'match_beginning_of_string': 1})
    let additional_regex = get(patterns, 'vim_regex', "")


    let ar = split(a:base,":",1) + [""]
    for t in taglist('^'.ar[0]) + (ar[0] == "" ? [] : taglist('^'.additional_regex))
      " assuming t.cmd is a regex
      " TODO: take into account if function spawns multiple lines!
      let type = matchstr(t.cmd, '[^=:]*[=:]*\zs.*\ze/')
      if ar[1] != '' && type !~ ar[1] | continue | endif
      " should filter tables, views, class ? For now they occur much less
      " often, so they don't hurt much
      let info = t.kind.' '.type
      call complete_add({'word': t.name, 'menu': info, 'info': info })
    endfor
    return []
  endif
endf

" parse .urp file {{{1
let s:c['f_scan_urp'] = get(s:c, 'f_scan_urp', {'func': funcref#Function('urweb#ParseURP'), 'version' : 2} )
fun! urweb#ParseURP(filename)
  let lines = readfile(a:filename)
  let result = {}

  " executable
  let exeLines = filter(copy(lines), "v:val =~ 'exe\s'")
  let result['exe'] = len(exeLines) > 0 ? matchstr(exeLines[-1], '^\s*exe\s\+\zs.*') : fnamemodify( a:filename, ':t:r').'.exe'

  " libraries
  let p = '^\s*library\s\+\zs.*'
  let result.libraries = map(filter(copy(lines), "v:val =~ ".string(p)),'matchstr(v:val,'.string(p).')')
  return result
endf
fun! urweb#URPContents(filename)
  return cached_file_contents#CachedFileContents(
    \ a:filename, s:c['f_scan_urp'] )
endf

fun! urweb#ExtraUrwebArgs(args)
 let map = {'fastcgi' : 'fcgi',
          \ 'cgi' : 'cgi,
          \ 'standalon' : 'exe
          \ }

 return ['-output'
       \ , fnamemodify(a:args.urp,":r").'.'. map[a:args.target] ]
endf

"compile using urweb {{{1
fun! urweb#CompileRHS(target)
  if a:target !~ 'standalone\|fastcgi\|cgi'
    throw "unvalid target"
  endif

  "TODO error format
  let efm='%f:%l:%c-%m'

  let urp = urweb#SetUrwebProjectFile()
  let exe = urweb#URPContents(urp)['exe']

  let onFinish = 0

  let fargs = {'target': a:target, 'exe': exe, 'urp': urp }
  if a:target == 'fastcgi'
    let extra = ["-protocol", "fastcgi"] + library#Call(s:c.extra_urweb_args, [fargs])
  elseif a:target == 'cgi'
    let extra = ["-protocol", "cgi"]     + library#Call(s:c.extra_urweb_args, [fargs])
  elseif a:target == 'standalone'
    let extra = []
  else
    let extra = []
  endif

  let args = ["urweb"] + extra + [fnamemodify(urp,":r")]
  let args = actions#VerifyArgs(args)

  if a:target == "standalone"
    unlet onFinish
    let port = input("run on port:", 8080)
    let onFinish = funcref#Function('urweb#RestartServer', {'args': [exe, port] })
  endif

  " -l: need login shell for job control
  return "call bg#RunQF(".string(args).", 'c', ".string(efm).", ".string(onFinish).")"
endf

fun! urweb#RestartServer(exe, port, status)
  if 1*a:status == 0
    let cmd = './'. shellescape(a:exe).' -p '.a:port

    if get(s:c,'use_vim_addon_async',0)
      if has_key(s:c, 'urweb_buf')
        " kill
        let ctx = getbufvar(s:c.urweb_buf, 'ctx')
        call ctx.kill()
      endif

      " restart
      let ctx = {'cmd':cmd, 'move_last':1}
      if has_key(s:c, 'urweb_buf')
        let ctx.log_bufnr = s:c.urweb_buf
      endif
      call async_porcelaine#LogToBuffer(ctx)
      let s:c.urweb_buf = bufnr('%')

      exec 'command! KillUrwebApp call getbufvar(g:vim_addon_urweb.urweb_buf, "ctx").kill()'
    else

      " echoing multiple lines is annoying
      let messages = []
      call add(messages,"restarting ".a:exe)

      let pidFile = fnamemodify(a:exe,':r').'.pid'
      let p_e = shellescape(pidFile)
      if filereadable(pidFile)
        call add(messages, "killing server")
        call system('kill -9 `cat '.p_e.'`')
      endif

      exec scriptmanager#DefineAndBind('tmpFile','g:urweb_server_log','tempname()')
      call system(cmd .' &> '.shellescape(tmpFile).' & jobs -p %1 > '.p_e)
      let pid = readfile(pidFile)[0]
      call add(messages," restarted (".pid.", port : ".a:port.')')
      echom join(messages,' - ')
      exec 'command! KillUrwebApp !kill -9 '.pid
    endif
  endif
endf
