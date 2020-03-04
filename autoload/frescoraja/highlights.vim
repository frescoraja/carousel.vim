" Highlighting {{{

" Helpers {{{
let s:none = 'NONE'
function! s:HL(highlight, guifg, guibg, ctermfg, ctermbg, gui)
  execute 'highlight! clear ' . a:highlight
  let l:cmd = 'highlight! ' . a:highlight
  let l:gf = empty(a:guifg) ? '' : 'guifg=' . a:guifg
  let l:gb = empty(a:guibg) ? '' : 'guibg=' . a:guibg
  let l:cf = empty(a:ctermfg) ? '' : 'ctermfg=' . a:ctermfg
  let l:cb = empty(a:ctermbg) ? '' : 'ctermbg=' . a:ctermbg
  let l:g = empty(a:gui) ? '' : 'gui=' . a:gui
  let l:c = empty(a:gui) ? '' : 'cterm=' . a:gui
  execute join([l:cmd, l:gf, l:gb, l:g, l:cf, l:cb, l:c], ' ')
endfunction
" }}}

" ALE Plugin Highlighting {{{
function! frescoraja#highlights#ale(guibg, ctermbg) abort
  call s:HL('ALEErrorSign', '#FF9A94', a:guibg, '167', a:ctermbg, 'bold,italic')
  call s:HL('ALEWarningSign', '#FFEFA4', a:guibg, '228', a:ctermbg, 'bold')
  call s:HL('ALEInfoSign', '#BFCFFF', a:guibg, '195', a:ctermbg, 'italic')
  call s:HL('ALEError', '#FF9F94', a:guibg, '167', a:ctermbg, '')
  call s:HL('ALEWarning', '#FFEFA4', a:guibg, '228', a:ctermbg, '')
  call s:HL('ALEInfo', '#DFE5FF', a:guibg, '195', a:ctermbg, 'reverse')
endfunction
" }}}

" Conquer of Completion Highlighting {{{
function! frescoraja#highlights#coc(guibg, ctermbg) abort
  call s:HL('CocErrorSign', '#FF4BA0', a:guibg, '125', a:ctermbg, 'bold')
  call s:HL('CocErrorHighlight', '#DF0B70', a:guibg, '125', a:ctermbg, '')
  call s:HL('CocWarningSign', '#FFCF80', a:guibg, '215', a:ctermbg, '')
  call s:HL('CocWarningHighlight', '#FF9F00', a:guibg, '215', a:ctermbg, '')
  call s:HL('CocInfoSign', '#4A9FEF', a:guibg, '153', a:ctermbg, '')
  call s:HL('CocInfoHighlight', '#8ABFFF', a:guibg, '153', a:ctermbg, '')
  call s:HL('CocHintSign', '#64BFAA', a:guibg, '158', a:ctermbg, 'italic')
  call s:HL('CocHintHighlight', '#D4FFEF', a:guibg, '158', a:ctermbg, '')
endfunction
" }}}

" GitGutter Highlighting {{{
function! frescoraja#highlights#gitgutter(guibg, ctermbg) abort
  call s:HL('GitGutterAdd', '#10C7AF', a:guibg, '115', a:ctermbg, '')
  call s:HL('GitGutterChange', '#6AB3DF', a:guibg, '153', a:ctermbg, '')
  call s:HL('GitGutterDelete', '#D76757', a:guibg, '174', a:ctermbg, '')
  call s:HL('GitGutterChangeDelete', '#EEA915', a:guibg, '222', a:ctermbg, '')
endfunction
" }}}

" Better Whitespace Highlighting {{{
function! frescoraja#highlights#whitespace() abort
  call s:HL('ExtraWhitespace', '#F32383', s:none, '162', s:none, 'undercurl')
endfunction
" }}}

" Syntax Highlighting {{{
function! frescoraja#highlights#syntax() abort
  call frescoraja#highlights#general()
  call frescoraja#highlights#nontext()
  if &syntax =~? 'javascript'
    call frescoraja#highlights#javascript()
  endif
endfunction

function! frescoraja#highlights#general() abort
  highlight! clear SignColumn
  highlight! clear VertSplit
  highlight! link SignColumn LineNr
  highlight! link VertSplit Type
  call s:HL('Error', '#F00F8F', s:none, '203', s:none, 'bold')
  call s:HL('ErrorMsg', '#F00F8F', s:none, '203', s:none, 'bold')
  call s:HL('Warning', '#FF9780', s:none, '220', s:none, '')
  call s:HL('WarningMsg', '#FF9780', s:none, '220', s:none, '')
endfunction

function! frescoraja#highlights#nontext() abort
  call s:HL('NonText', '', s:none, '', s:none, '')
  call s:HL('SpecialKey', '', s:none, '', s:none, '')
endfunction

function! frescoraja#highlights#javascript() abort
  highlight! link jsSpecial               Statement
  highlight! link jsFuncArgRest           jsSpecial
  highlight! link jsDocTags               jsSpecial
  highlight! link jsStatic                jsSpecial
  highlight! link jsSuper                 jsSpecial
  highlight! link jsPrototype             jsSpecial
  highlight! link jsArgsObj               jsSpecial
  highlight! link jsTemplateVar           jsSpecial
  highlight! link jsExceptions            jsSpecial
  highlight! link jsFutureKeys            jsSpecial
  highlight! link jsBuiltins              jsSpecial
  highlight! link jsDecorator             jsSpecial
  highlight! link jsHtmlEvents            jsSpecial
  highlight! link jsObjectKey             String
  highlight! link jsNull                  Constant
  highlight! link jsUndefined             Constant
  highlight! link jsFunctionKey           Function
  highlight! link jsFuncCall              Function
  highlight! link jsFuncAssignExpr        Function
  highlight! link jsFuncAssignIdent       Function
  highlight! link jsClassProperty         Normal
  highlight! link jsExportDefault         Include
  highlight! link jsGlobalObjects         Special
  call s:HL('jsThis', '#F04158', s:none, '205', s:none, 'italic')
endfunction

" add comment support for jsonc/json5 files
function! frescoraja#highlights#json() abort
  syntax region      jsoncLineComment     start=+\/\/+ end=+$+ keepend
  syntax region      jsoncLineComment     start=+^\s*\/\/+ skip=+\n\s*\/\/+ end=+$+ keepend fold
  syntax region      jsoncComment         start="/\*"  end="\*/" fold

  highlight def link jsoncLineComment     Comment
  highlight def link jsoncComment         Comment
endfunction
" }}}

" }}}

" vim: fdm=marker fmr={{{,}}} fen
