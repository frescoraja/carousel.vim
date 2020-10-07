" Highlighting {{{

" Helpers {{{
let s:none = 'NONE'
function! frescoraja#highlights#HL(highlight, guifg, guibg, ctermfg, ctermbg, gui) abort
  execute 'highlight! clear ' . a:highlight
  let l:cmd = 'highlight! ' . a:highlight
  let l:gf = empty(a:guifg) ? '' : 'guifg=' . a:guifg
  let l:gb = empty(a:guibg) ? '' : 'guibg=' . a:guibg
  let l:cf = empty(a:ctermfg) ? '' : 'ctermfg=' . a:ctermfg
  let l:cb = empty(a:ctermbg) ? '' : 'ctermbg=' . a:ctermbg
  let l:g = empty(a:gui) ? '' : 'gui=' . a:gui
  let l:c = empty(a:gui) ? '' : 'cterm=' . a:gui
  let l:args = join([l:gf, l:gb, l:g, l:cf, l:cb, l:c], ' ')
  if strlen(l:args) > 5 " any non-empty arg will produce len(l:args) > 5
    execute join([l:cmd, l:gf, l:gb, l:g, l:cf, l:cb, l:c], ' ')
  endif
endfunction

function! frescoraja#highlights#LINK(from, to) abort
  execute 'highlight! clear ' . a:from
  execute 'highlight! link ' . a:from . ' ' . a:to
endfunction

" increase/decrease rgb levels by given step, ie. step: 3, og_color #2f4ac1 => #5f7af1
function! frescoraja#highlights#new_color_by_step(step, og_color) abort
  let l:positive = a:step > 0 ? 1 : -1
  let l:adder_dec = abs(a:step)
  let l:adder = str2nr(l:adder_dec . '0' . l:adder_dec . '0' . l:adder_dec . '0', 16)
  let l:og_col = str2nr(a:og_color[1:], 16)
  let l:sum = l:og_col + (l:positive * l:adder)
  return printf('#%x', l:sum)
endfunction
" }}}

" ALE Plugin Highlighting {{{
function! frescoraja#highlights#ale(guibg, ctermbg) abort
  highlight! clear ALEError ALEWarning ALEInfo ALEStyleError ALEStyleWarning
  call frescoraja#highlights#HL('ALEErrorSign', '#DF0B70', a:guibg, '167', a:ctermbg, '')
  call frescoraja#highlights#HL('ALEErrorSignLineNr', '#DF0B70', a:guibg, '167', a:ctermbg, '')
  call frescoraja#highlights#HL('ALEWarningSign', '#FF9F00', a:guibg, '228', a:ctermbg, '')
  call frescoraja#highlights#HL('ALEWarningSignLineNr', '#FF9F00', a:guibg, '228', a:ctermbg, '')
  call frescoraja#highlights#HL('ALEInfoSign', '#4ABFFF', a:guibg, '195', a:ctermbg, '')
  call frescoraja#highlights#HL('ALEInfoSignLineNr', '#4ABFFF', a:guibg, '195', a:ctermbg, '')
endfunction
" }}}

" Conquer of Completion Highlighting {{{
function! frescoraja#highlights#coc(guibg, ctermbg) abort
  call frescoraja#highlights#HL('CocErrorSign', '#DF0B70', a:guibg, '125', a:ctermbg, '')
  call frescoraja#highlights#HL('CocErrorHighlight', '', '', '', '', 'italic,bold')
  " call frescoraja#highlights#HL('CocErrorHighlight', '#DF0B70', a:guibg, '125', a:ctermbg, 'italic,bold')
  call frescoraja#highlights#HL('CocWarningSign', '#FF9F00', a:guibg, '215', a:ctermbg, '')
  call frescoraja#highlights#HL('CocWarningHighlight', '', '', '', '', 'italic')
  " call frescoraja#highlights#HL('CocWarningHighlight', '#FF9F00', a:guibg, '215', a:ctermbg, 'italic')
  call frescoraja#highlights#HL('CocInfoSign', '#4ABFFF', a:guibg, '153', a:ctermbg, '')
  call frescoraja#highlights#HL('CocInfoHighlight', '', '', '', '', '')
  " call frescoraja#highlights#HL('CocInfoHighlight', '#8ABFFF', a:guibg, '153', a:ctermbg, '')
  call frescoraja#highlights#HL('CocHintSign', '#64BFAA', a:guibg, '158', a:ctermbg, '')
  call frescoraja#highlights#HL('CocHintHighlight', '', '', '', '', '')
  " call frescoraja#highlights#HL('CocHintHighlight', '#D4FFEF', a:guibg, '158', a:ctermbg, '')
endfunction
" }}}

" Custom Git Highlighting {{{
function! frescoraja#highlights#gitgutter(guibg, ctermbg) abort
  call frescoraja#highlights#HL('FVTDiffAdd', '#10C7AF', a:guibg, '115', a:ctermbg, '')
  call frescoraja#highlights#HL('FVTDiffChange', '#6AB3DF', a:guibg, '153', a:ctermbg, '')
  call frescoraja#highlights#HL('FVTDiffDelete', '#D76757', a:guibg, '174', a:ctermbg, '')
  call frescoraja#highlights#HL('FVTDiffChangeDelete', '#EEA915', a:guibg, '222', a:ctermbg, '')
  call frescoraja#highlights#HL('CocGitAddedSign', '#10C7AF', a:guibg, '115', a:ctermbg, '')
  call frescoraja#highlights#HL('CocGitChangedSign', '#6AB3DF', a:guibg, '153', a:ctermbg, '')
  call frescoraja#highlights#HL('CocGitRemovedSign', '#D76757', a:guibg, '174', a:ctermbg, '')
  call frescoraja#highlights#HL('CocGitChangeRemovedSign', '#EEA915', a:guibg, '222', a:ctermbg, '')
endfunction
" }}}

" Better Whitespace Highlighting {{{
function! frescoraja#highlights#whitespace() abort
  call frescoraja#highlights#HL('ExtraWhitespace', '#F32383', s:none, '162', s:none, 'undercurl')
endfunction
" }}}

" Syntax Highlighting {{{
function! frescoraja#highlights#syntax() abort
  call frescoraja#highlights#general()
  call frescoraja#highlights#special()
  if &syntax =~? 'javascript'
    call frescoraja#highlights#javascript()
  endif
endfunction

function! frescoraja#highlights#general() abort
  call frescoraja#highlights#LINK('SignColumn', 'LineNr')
  call frescoraja#highlights#LINK('VertSplit', 'Type')
  call frescoraja#highlights#HL('Error', '#F00F5F', s:none, '203', s:none, 'bold')
  call frescoraja#highlights#HL('ErrorMsg', '#F00F5F', s:none, '203', s:none, 'bold')
  call frescoraja#highlights#HL('Warning', '#FFC730', s:none, '220', s:none, '')
  call frescoraja#highlights#HL('WarningMsg', '#FFC730', s:none, '220', s:none, '')
endfunction

function! frescoraja#highlights#special() abort
  " clear all highlight attributes for NonText other than guifg
  " If no NonText highlight defined, use Comment guifg attribute but make darker by 3 'steps'
  let l:guifg_nontext = frescoraja#get_highlight_attr('NonText', 'fg', 'gui')
  if strlen(l:guifg_nontext) < 7
    let l:og_guifg = frescoraja#get_highlight_attr('Comment', 'fg', 'gui')
    let l:guifg_nontext = frescoraja#highlights#new_color_by_step(-3, l:og_guifg)
  endif

  call frescoraja#highlights#HL('NonText', l:guifg_nontext, '', '', '', '')
endfunction

function! frescoraja#highlights#javascript() abort
  call frescoraja#highlights#LINK('jsSpecial', 'Statement')
  call frescoraja#highlights#LINK('jsFuncArgRes', 'jsSpecial')
  call frescoraja#highlights#LINK('jsDocTag', 'jsSpecial')
  call frescoraja#highlights#LINK('jsStatic', 'jsSpecial')
  call frescoraja#highlights#LINK('jsSuper', 'jsSpecial')
  call frescoraja#highlights#LINK('jsPrototype', 'jsSpecial')
  call frescoraja#highlights#LINK('jsArgsObj', 'jsSpecial')
  call frescoraja#highlights#LINK('jsTemplateVar', 'jsSpecial')
  call frescoraja#highlights#LINK('jsExceptions', 'jsSpecial')
  call frescoraja#highlights#LINK('jsFutureKeys', 'jsSpecial')
  call frescoraja#highlights#LINK('jsBuiltins', 'jsSpecial')
  call frescoraja#highlights#LINK('jsDecorator', 'jsSpecial')
  call frescoraja#highlights#LINK('jsHtmlEvents', 'jsSpecial')
  call frescoraja#highlights#LINK('jsObjectKey', 'String')
  call frescoraja#highlights#LINK('jsNull', 'Constant')
  call frescoraja#highlights#LINK('jsUndefined', 'Constant')
  call frescoraja#highlights#LINK('jsFunctionKey', 'Function')
  call frescoraja#highlights#LINK('jsFuncCall', 'Function')
  call frescoraja#highlights#LINK('jsFuncAssignExpr', 'Function')
  call frescoraja#highlights#LINK('jsFuncAssignIdent', 'Function')
  call frescoraja#highlights#LINK('jsClassProperty', 'Normal')
  call frescoraja#highlights#LINK('jsExportDefault', 'Include')
  call frescoraja#highlights#LINK('jsGlobalObjects', 'Special')
  call frescoraja#highlights#HL('jsThis', '#F04158', s:none, '205', s:none, 'italic')
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
