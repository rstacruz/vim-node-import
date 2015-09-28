if exists('g:node_import_loaded') | finish | endif
let g:node_import_loaded=1

" TODO: test
" TODO: ..foo => ../foo
" TODO: import { multiple, things }
" TODO: browser = zombie

if maparg("<Plug>(NodeImportExpand)") == ""
  inoremap <silent> <SID>NodeImportExpand <C-R>=node_import#expand('var')<CR>
  imap <script> <Plug>NodeImportExpand <SID>NodeImportExpand
endif

function! node_import#init()
  inoremap <silent> <C-e> <C-R>=node_import#expand('const')<CR>
  inoremap <silent> <C-i> <C-R>=node_import#expand('import')<CR>

  let b:node_import = 1
  let oldmap = maparg('<CR>', 'i')

  if oldmap =~# 'NodeImportExpand'
    " already mapped. maybe the user was playing with `set ft`
  elseif oldmap != ""
    exe "imap <CR> ".oldmap."<Plug>NodeImportExpand"
  else
    imap  <CR> <CR><Plug>NodeImportExpand
  endif
endfunction

function! node_import#expand(mode)
  " supress if it broke off a line (pressed enter not at the end)
  if match(getline('.'), '^\s*$') == -1 | return '' | endif

  let line = getline(line('.') - 1)
  echo line
  let line = substitute(line, '^\s*', '', 'g')
  let line = substitute(line, '\s*$', '', 'g')
  if line !~ ' ' | return '' | endif

  let parts = split(line, ' ')
  let module = s:to_module(parts[1])
  let name = s:to_name(parts[1])
  let semi = s:use_semicolon()
  let cmd = ''

  if parts[0] ==# 'import' || parts[0] ==# 'i'
    if module[1] !=# ''
      let cmd = 'import { ' . name. " } from '" . module[0] . "'" . semi
    else
      let cmd = 'import ' . name . " from '" . module[0] . "'" . semi
    endif
  elseif parts[0] ==# 'vrequire' || parts[0] ==# 'v'
    if module[1] !=# ''
      let cmd = 'var ' . name . " = require('" . module[0] . "')." . module[1] . semi
    else
      let cmd = 'var ' . name . " = require('" . module[0] . "')" . semi
    endi
  elseif parts[0] ==# 'require' || parts[0] ==# 'r'
    if module[1] !=# ''
      let cmd = 'const ' . name . " = require('" . module[0] . "')." . module[1] . semi
    else
      let cmd = 'const ' . name . " = require('" . module[0] . "')" . semi
    endif
  endif

  if cmd ==# ''
    return ''
  else
    return "\<BS>\<C-O>^\"_C" . cmd . "\<CR>"
    return "\<BS>\<C-O>^\<C-O>C" . cmd . "\<C-O>o"
  endif
endfunction

function! s:to_module(file)
  let name = a:file
  let extra = ''

  " ...foo => ../../foo (TODO)
  " let name = substitute(name, '^([\.]{2,})([^/])', '\=submatch(1) . "/" . submatch(2)', 'g')

  " fs.readFile => fs / readFile
  if name =~ '\.[a-zA-Z0-9\-_]\+$'
    let extra = substitute(name, '^.*\.', '', 'g')
    let name = substitute(name, '\.[a-zA-Z0-9\-_]*$', '', 'g')
  endif

  return [ name, extra ]
endfunction

function! s:to_name(file)
  let name = a:file

  " config.js => config
  let name = substitute(name, '\.js$', '', 'g')

  " a/b/c => c
  let name = substitute(name, '^.*/', '', 'g')

  " fs.readFile => readFile
  let name = substitute(name, '^[^\.]*\.', '', 'g')

  " node_foo => nodeFoo
  let name = s:camelize(name)

  return name
endfunction

" Turns a string into camelcase
"
"     s:camelize('hello_world') => 'helloWorld'
"
function! s:camelize(str)
  let str = a:str
  let str = substitute(str, '_\([a-z]\)', '\=toupper(submatch(1))', 'g')
  return str
endfunction

"
" Checks if a semicolon is needed for a given line number
"

function! s:use_semicolon()
  " Only add semicolons if another line has a semicolon.
  let used_semi = search(';$', 'wn') > 0
  if used_semi == "0" | return '' | endif
  return ';'
endfunction
