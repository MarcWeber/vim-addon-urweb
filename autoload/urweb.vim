exec scriptmanager#DefineAndBind('s:c','s:vim_addon_urweb','{}')
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
    new_ = g:urweb_projectfile
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
    call urweb#TagAndAdd(urwebSources.'/lib','**/*.ur*')
  endif
endf

" TODO refactor, shared by vim-addon-ocaml ?
fun! urweb#TagAndAdd(d, pat)
  call vcs_checkouts#ExecIndir([{'d': a:d, 'c': g:vim_haxe_ctags_command_recursive.' '.a:pat}])
  exec 'set tags+='.substitute(a:d,',','\\\\,','g').'/tags'
endf
