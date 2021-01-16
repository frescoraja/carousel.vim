" Highlighting {{{

" Helpers {{{
let s:none = 'NONE'
function! carousel#highlights#HL(highlight, guifg, guibg, ctermfg, ctermbg, gui) abort
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

function! carousel#highlights#link(from, to) abort
  execute 'highlight! clear ' . a:from
  execute 'highlight! link ' . a:from . ' ' . a:to
endfunction

" increase/decrease rgb levels by given step, ie. step: 3, og_color #2f4ac1 => #5f7af1
function! carousel#highlights#new_color_by_step(step, og_color) abort
  let l:positive = a:step > 0 ? 1 : -1
  let l:adder_dec = abs(a:step)
  let l:adder = str2nr(l:adder_dec . '0' . l:adder_dec . '0' . l:adder_dec . '0', 16)
  let l:og_col = str2nr(a:og_color[1:], 16)
  let l:sum = l:og_col + (l:positive * l:adder)
  return printf('#%x', l:sum)
endfunction
" }}}

" ALE Plugin Highlighting {{{
function! carousel#highlights#ale(guibg, ctermbg) abort
  highlight! clear ALEError ALEWarning ALEInfo ALEStyleError ALEStyleWarning
  call carousel#highlights#HL('ALEErrorSign', '#DF0B70', a:guibg, '167', a:ctermbg, '')
  call carousel#highlights#HL('ALEErrorSignLineNr', '#DF0B70', a:guibg, '167', a:ctermbg, '')
  call carousel#highlights#HL('ALEWarningSign', '#FF9F00', a:guibg, '228', a:ctermbg, '')
  call carousel#highlights#HL('ALEWarningSignLineNr', '#FF9F00', a:guibg, '228', a:ctermbg, '')
  call carousel#highlights#HL('ALEInfoSign', '#4ABFFF', a:guibg, '195', a:ctermbg, '')
  call carousel#highlights#HL('ALEInfoSignLineNr', '#4ABFFF', a:guibg, '195', a:ctermbg, '')
endfunction
" }}}

" Conquer of Completion Highlighting {{{
function! carousel#highlights#coc(guibg, ctermbg) abort
  call carousel#highlights#HL('CocErrorSign', '#DF0B70', a:guibg, '125', a:ctermbg, '')
  call carousel#highlights#HL('CocErrorHighlight', '', '', '', '', 'italic,bold')
  " call carousel#highlights#HL('CocErrorHighlight', '#DF0B70', a:guibg, '125', a:ctermbg, 'italic,bold')
  call carousel#highlights#HL('CocWarningSign', '#FF9F00', a:guibg, '215', a:ctermbg, '')
  call carousel#highlights#HL('CocWarningHighlight', '', '', '', '', 'italic')
  " call carousel#highlights#HL('CocWarningHighlight', '#FF9F00', a:guibg, '215', a:ctermbg, 'italic')
  call carousel#highlights#HL('CocInfoSign', '#4ABFFF', a:guibg, '153', a:ctermbg, '')
  call carousel#highlights#HL('CocInfoHighlight', '', '', '', '', '')
  " call carousel#highlights#HL('CocInfoHighlight', '#8ABFFF', a:guibg, '153', a:ctermbg, '')
  call carousel#highlights#HL('CocHintSign', '#64BFAA', a:guibg, '158', a:ctermbg, '')
  call carousel#highlights#HL('CocHintHighlight', '', '', '', '', '')
  " call carousel#highlights#HL('CocHintHighlight', '#D4FFEF', a:guibg, '158', a:ctermbg, '')
endfunction
" }}}

" Custom Git Highlighting {{{
function! carousel#highlights#gitgutter(guibg, ctermbg) abort
  call carousel#highlights#HL('FVTDiffAdd', '#10C7AF', a:guibg, '115', a:ctermbg, '')
  call carousel#highlights#HL('FVTDiffChange', '#6AB3DF', a:guibg, '153', a:ctermbg, '')
  call carousel#highlights#HL('FVTDiffDelete', '#D76757', a:guibg, '174', a:ctermbg, '')
  call carousel#highlights#HL('FVTDiffChangeDelete', '#EEA915', a:guibg, '222', a:ctermbg, '')
  call carousel#highlights#HL('CocGitAddedSign', '#10C7AF', a:guibg, '115', a:ctermbg, '')
  call carousel#highlights#HL('CocGitChangedSign', '#6AB3DF', a:guibg, '153', a:ctermbg, '')
  call carousel#highlights#HL('CocGitRemovedSign', '#D76757', a:guibg, '174', a:ctermbg, '')
  call carousel#highlights#HL('CocGitChangeRemovedSign', '#EEA915', a:guibg, '222', a:ctermbg, '')
endfunction
" }}}

" Better Whitespace Highlighting {{{
function! carousel#highlights#whitespace() abort
  call carousel#highlights#HL('ExtraWhitespace', '#F32383', s:none, '162', s:none, 'undercurl')
endfunction
" }}}

" Syntax Highlighting {{{
function! carousel#highlights#syntax() abort
  call carousel#highlights#general()
  call carousel#highlights#special()
  if &syntax =~? 'javascript'
    call carousel#highlights#javascript()
  endif
endfunction

function! carousel#highlights#general() abort
  call carousel#highlights#link('SignColumn', 'LineNr')
  call carousel#highlights#link('VertSplit', 'Type')
  call carousel#highlights#HL('Error', '#F00F5F', s:none, '203', s:none, 'bold')
  call carousel#highlights#HL('ErrorMsg', '#F00F5F', s:none, '203', s:none, 'bold')
  call carousel#highlights#HL('Warning', '#FFC730', s:none, '220', s:none, '')
  call carousel#highlights#HL('WarningMsg', '#FFC730', s:none, '220', s:none, '')
endfunction

function! carousel#highlights#special() abort
  " clear all highlight attributes for NonText other than guifg
  " If no NonText highlight defined, use Comment guifg attribute but make darker by 3 'steps'
  let l:guifg_nontext = carousel#get_highlight_attr('NonText', 'fg', 'gui')
  if strlen(l:guifg_nontext) < 7
    let l:og_guifg = carousel#get_highlight_attr('Comment', 'fg', 'gui')
    let l:guifg_nontext = carousel#highlights#new_color_by_step(-3, l:og_guifg)
  endif

  call carousel#highlights#HL('NonText', l:guifg_nontext, '', '', '', '')
endfunction

function! carousel#highlights#javascript() abort
  call carousel#highlights#link('jsSpecial', 'Statement')
  call carousel#highlights#link('jsFuncArgRes', 'jsSpecial')
  call carousel#highlights#link('jsDocTag', 'jsSpecial')
  call carousel#highlights#link('jsStatic', 'jsSpecial')
  call carousel#highlights#link('jsSuper', 'jsSpecial')
  call carousel#highlights#link('jsPrototype', 'jsSpecial')
  call carousel#highlights#link('jsArgsObj', 'jsSpecial')
  call carousel#highlights#link('jsTemplateVar', 'jsSpecial')
  call carousel#highlights#link('jsExceptions', 'jsSpecial')
  call carousel#highlights#link('jsFutureKeys', 'jsSpecial')
  call carousel#highlights#link('jsBuiltins', 'jsSpecial')
  call carousel#highlights#link('jsDecorator', 'jsSpecial')
  call carousel#highlights#link('jsHtmlEvents', 'jsSpecial')
  call carousel#highlights#link('jsObjectKey', 'String')
  call carousel#highlights#link('jsNull', 'Constant')
  call carousel#highlights#link('jsUndefined', 'Constant')
  call carousel#highlights#link('jsFunctionKey', 'Function')
  call carousel#highlights#link('jsFuncCall', 'Function')
  call carousel#highlights#link('jsFuncAssignExpr', 'Function')
  call carousel#highlights#link('jsFuncAssignIdent', 'Function')
  call carousel#highlights#link('jsClassProperty', 'Normal')
  call carousel#highlights#link('jsExportDefault', 'Include')
  call carousel#highlights#link('jsGlobalObjects', 'Special')
  call carousel#highlights#HL('jsThis', '#F04158', s:none, '205', s:none, 'italic')
endfunction

" add comment support for jsonc/json5 files
function! carousel#highlights#json() abort
  syntax region      jsoncLineComment     start=+\/\/+ end=+$+ keepend
  syntax region      jsoncLineComment     start=+^\s*\/\/+ skip=+\n\s*\/\/+ end=+$+ keepend fold
  syntax region      jsoncComment         start="/\*"  end="\*/" fold

  highlight def link jsoncLineComment     Comment
  highlight def link jsoncComment         Comment
endfunction
" }}}

" }}}

" vim: fdm=marker fmr={{{,}}} fen
