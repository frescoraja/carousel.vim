let s:none = 'NONE'

function! s:HL(highlight, guifg, guibg, ctermfg, ctermbg, gui)
  execute 'highlight! clear ' . a:highlight
  let l:cmd = 'highlight! ' . a:highlight
  let l:gf = len(a:guifg) ? 'guifg=' . a:guifg : ''
  let l:gb = len(a:guibg) ? 'guibg=' . a:guibg : ''
  let l:cf = len(a:ctermfg) ? 'ctermfg=' . a:ctermfg : ''
  let l:cb = len(a:ctermbg) ? 'ctermbg=' . a:ctermbg : ''
  let l:g = len(a:gui) ? 'gui=' . a:gui : ''
  let l:c = len(a:gui) ? 'cterm=' . a:gui : ''
  execute join([l:cmd, l:gf, l:gb, l:g, l:cf, l:cb, l:c], ' ')
endfunction

" ALE Plugin Highlighting {{{
function! frescoraja#highlights#ale() abort
  call s:HL('ALEErrorSign', '#FF4A64', s:none, '167', s:none, '')
  call s:HL('ALEWarningSign', '#FFFF8F', s:none, '228', s:none, '')
  call s:HL('ALEInfoSign', '#DFF5FF', s:none, '195', s:none, '')
  call s:HL('ALEError', '#FF4A64', s:none, '167', s:none, 'italic')
  call s:HL('ALEWarning', '#FFFF8F', s:none, '228', s:none, 'italic')
  call s:HL('ALEInfo', '#DFF5FF', s:none, '195', s:none, 'italic')
endfunction
" }}}

" Conquer of Completion Highlighting {{{
function! frescoraja#highlights#coc() abort
  call s:HL('CocErrorSign', '#BF3B70', s:none, '125', s:none, '')
  call s:HL('CocErrorHighlight', '#BF3B70', s:none, '125', s:none, 'italic')
  call s:HL('CocWarningSign', '#FF9750', s:none, '215', s:none, '')
  call s:HL('CocWarningHighlight', '#FF9750', s:none, '215', s:none, 'italic')
  call s:HL('CocInfoSign', '#AACFFF', s:none, '153', s:none, '')
  call s:HL('CocInfoHighlight', '#AACFFF', s:none, '153', s:none, 'italic')
  call s:HL('CocHintSign', '#A4F4CA', s:none, '158', s:none, '')
  call s:HL('CocHintHighlight', '#A4F4CA', s:none, '158', s:none, 'italic')
endfunction
" }}}

" GitGutter Highlighting {{{
function! frescoraja#highlights#gitgutter() abort
  call s:HL('GitGutterAdd', '#30C75F', s:none, '115', s:none, '')
  call s:HL('GitGutterChange', '#4A83D3', s:none, '153', s:none, '')
  call s:HL('GitGutterDelete', '#E75737', s:none, '174', s:none, '')
  call s:HL('GitGutterChangeDelete', '#FF9F3F', s:none, '222', s:none, '')
endfunction
" }}}

" Better Whitespace Highlighting {{{
function! frescoraja#highlights#whitespace() abort
  call s:HL('ExtraWhitespace', '#D32303', s:none, 'red', s:none, 'undercurl')
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
  call s:HL('Error', '#FF5F5F', s:none, '203', s:none, 'bold')
  call s:HL('ErrorMsg', '#FF5F5F', s:none, '203', s:none, 'bold')
  call s:HL('Warning', '#FFD700', s:none, '220', s:none, '')
  call s:HL('WarningMsg', '#FFD700', s:none, '220', s:none, '')
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

" vim: fdm=marker fmr={{{,}}} fen
