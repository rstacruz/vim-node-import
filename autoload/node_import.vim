if exists('g:node_import_loaded') | finish | endif
let g:node_import_loaded=1

" TODO: test
" TODO: ..foo => ../foo
" TODO: import { multiple, things }
" TODO: browser = zombie

function! node_import#init()
  inoremap <silent> <C-e> <C-R>=node_import#expand('const')<CR>
  inoremap <silent> <C-i> <C-R>=node_import#expand('import')<CR>
endfunction

function! node_import#expand(mode)
  let line = getline('.')
  let line = substitute(line, '^\s*', '', 'g')
  let line = substitute(line, '\s*$', '', 'g')
  if strlen(line) ==# '0' | return '' | endif

  let parts = split(line, ' ')
  let module = s:to_module(parts[0])
  let name = s:to_name(parts[0])
  let semi = s:use_semicolon()

  if a:mode ==# 'import'
    if module[1] !=# ''
      let cmd = 'import { ' . name. " } from '" . module[0] . "'" . semi
    else
      let cmd = 'import ' . name . " from '" . module[0] . "'" . semi
    endif
  elseif a:mode ==# 'var'
    if module[1] !=# ''
      let cmd = 'var ' . name . " = require('" . module[0] . "')." . module[1] . semi
    else
      let cmd = 'var ' . name . " = require('" . module[0] . "')" . semi
    endi
  else
    if module[1] !=# ''
      let cmd = 'const ' . name . " = require('" . module[0] . "')." . module[1] . semi
    else
      let cmd = 'const ' . name . " = require('" . module[0] . "')" . semi
    endif
  endif

  normal ^C
  return '' . cmd . "\n"
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
