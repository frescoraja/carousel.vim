" ALE Plugin Highlighting {{{
function! frescoraja#highlights#ale(guibg, ctermbg) abort
  highlight clear ALEErrorSign
  highlight clear ALEWarningSign
  highlight clear ALEInfoSign
  execute 'highlight! ALEErrorSign guifg=red ctermfg=red ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! ALEWarningSign guifg=yellow ctermfg=yellow ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! ALEInfoSign guifg=#D7AF87 ctermfg=180 ' . a:guibg . ' ' . a:ctermbg
  highlight! ALEError guifg=red ctermfg=red guibg=NONE ctermbg=NONE gui=italic cterm=italic
  highlight! ALEWarning guifg=yellow ctermfg=yellow guibg=NONE ctermbg=NONE gui=italic cterm=italic
  highlight! ALEInfo guifg=white ctermfg=white guibg=NONE ctermbg=NONE gui=italic cterm=italic
endfunction
" }}}

" Conquer of Completion Highlighting {{{
function! frescoraja#highlights#coc(guibg, ctermbg) abort
  execute 'highlight! CocErrorSign guifg=red ctermfg=red ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! CocWarningSign guifg=yellow ctermfg=yellow ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! CocInfoSign guifg=white ctermfg=white ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! CocHintSign guifg=green ctermfg=green ' . a:guibg . ' ' . a:ctermbg
  highlight! CocErrorHighlight gui=italic cterm=italic guifg=red ctermfg=red guibg=black ctermbg=black
  highlight! CocWarningHighlight gui=italic cterm=italic guifg=yellow ctermfg=yellow guibg=black ctermbg=black
  highlight! CocInfoHighlight gui=italic cterm=italic guifg=white ctermfg=white guibg=black ctermbg=black
  highlight! CocHintHighlight gui=italic cterm=italic guifg=green ctermfg=green guibg=black ctermbg=black
  " highlight! CocErrorSign guibg=red ctermbg=red guifg=white ctermfg=white
  " highlight! CocWarningSign guibg=yellow ctermbg=yellow guifg=white ctermfg=white
  " highlight! CocInfoSign guibg=black ctermbg=black guifg=white ctermfg=white
  " highlight! CocHintSign guibg=green ctermbg=green guifg=white ctermfg=white
  " highlight! CocErrorHighlight gui=italic cterm=italic guifg=red ctermfg=red guibg=NONE ctermbg=NONE
  " highlight! CocWarningHighlight gui=italic cterm=italic guifg=yellow ctermfg=yellow guibg=NONE ctermbg=NONE
  " highlight! CocInfoHighlight gui=italic cterm=italic guifg=white ctermfg=white guibg=NONE ctermbg=NONE
  " highlight! CocHintHighlight gui=italic cterm=italic guifg=green ctermfg=green guibg=NONE ctermbg=NONE
endfunction
" }}}

" GitGutter Highlighting {{{
function! frescoraja#highlights#gitgutter(guibg, ctermbg) abort
  highlight clear GitGutterAdd
  highlight clear GitGutterChange
  highlight clear GitGutterDelete
  highlight clear GitGutterChangeDelete
  execute 'highlight! GitGutterAdd guifg=#87D7AF ctermfg=115 ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! GitGutterChange guifg=#AFD7D7 ctermfg=152 ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! GitGutterDelete guifg=#D78787 ctermfg=174 ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! GitGutterChangeDelete guifg=#D7AFAF ctermfg=181 ' . a:guibg . ' ' . a:ctermbg
endfunction
" }}}

" Better Whitespace Highlighting {{{
function! frescoraja#highlights#whitespace() abort
  highlight clear ExtraWhitespace
  highlight! ExtraWhitespace cterm=undercurl ctermfg=red guifg=#D32303
endfunction
" }}}

" Syntax Highlighting {{{
function! frescoraja#highlights#syntax() abort
  call frescoraja#highlights#general()
  call frescoraja#highlights#javascript()
endfunction

function! frescoraja#highlights#general() abort
  highlight! link SignColumn LineNr
endfunction

function! frescoraja#highlights#javascript() abort
  highlight link jsSpecial               Statement
  highlight link jsFuncArgRest           jsSpecial
  highlight link jsDocTags               jsSpecial
  highlight link jsStatic                jsSpecial
  highlight link jsSuper                 jsSpecial
  highlight link jsPrototype             jsSpecial
  highlight link jsArgsObj               jsSpecial
  highlight link jsTemplateVar           jsSpecial
  highlight link jsExceptions            jsSpecial
  highlight link jsFutureKeys            jsSpecial
  highlight link jsBuiltins              jsSpecial
  highlight link jsDecorator             jsSpecial
  highlight link jsHtmlEvents            jsSpecial
  highlight link jsObjectKey             String
  highlight link jsNull                  Constant
  highlight link jsUndefined             Constant
  highlight link jsFunctionKey           Function
  highlight link jsFuncCall              Function
  highlight link jsFuncAssignExpr        Function
  highlight link jsFuncAssignIdent       Function
  highlight link jsClassProperty         Normal
  highlight link jsExportDefault         Include
  highlight link jsGlobalObjects         Special
  highlight jsThis guifg=#F07178 ctermfg=205 gui=italic cterm=italic
endfunction
" }}}

" vim: fdm=marker fmr={{{,}}} fen
