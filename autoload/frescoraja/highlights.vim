" ALE Plugin Highlighting {{{
function! frescoraja#highlights#ale(guibg, ctermbg) abort
  execute 'highlight! ALEErrorSign guifg=#C86DA7 ctermfg=red guibg=' . a:guibg . ' ctermbg=' . a:ctermbg
  execute 'highlight! ALEWarningSign guifg=#D4BC81 ctermfg=yellow guibg=' . a:guibg . ' ctermbg=' . a:ctermbg
  execute 'highlight! ALEInfoSign guifg=#AFD890 ctermfg=150 guibg=' . a:guibg . ' ctermbg=' . a:ctermbg
  highlight! ALEError guifg=red ctermfg=red guibg=NONE ctermbg=NONE gui=italic cterm=italic
  highlight! ALEWarning guifg=yellow ctermfg=yellow guibg=NONE ctermbg=NONE gui=italic cterm=italic
  highlight! ALEInfo guifg=white ctermfg=white guibg=NONE ctermbg=NONE gui=italic cterm=italic
endfunction
" }}}

" Conquer of Completion Highlighting {{{
function! frescoraja#highlights#coc() abort
  highlight! CocErrorSign guifg=#9F0B40 ctermfg=125
  highlight! CocWarningSign guifg=#E9AE4F ctermfg=172
  highlight! CocInfoSign guifg=#AACFFF ctermfg=153
  highlight! CocHintSign guifg=#C4F4FA ctermfg=158
  highlight! CocErrorHighlight gui=italic cterm=italic guifg=red ctermfg=red
  highlight! CocWarningHighlight gui=italic cterm=italic guifg=yellow ctermfg=yellow
  highlight! CocInfoHighlight gui=italic cterm=italic guifg=white ctermfg=white
  highlight! CocHintHighlight gui=italic cterm=italic guifg=green ctermfg=green
endfunction
" }}}

" GitGutter Highlighting {{{
function! frescoraja#highlights#gitgutter() abort
  highlight! GitGutterAdd guifg=#76C78F ctermfg=115
  highlight! GitGutterAddLine guifg=#76C78F ctermfg=115
  highlight! GitGutterChange guifg=#8AB2D3 ctermfg=153
  highlight! GitGutterChangeLine guifg=#8AB2D3 ctermfg=153
  highlight! GitGutterDelete guifg=#D78787 ctermfg=174
  highlight! GitGutterDeleteLine guifg=#D78787 ctermfg=174
  highlight! GitGutterChangeDelete guifg=#F8B71C ctermfg=181
  highlight! GitGutterChangeDeleteLine guifg=#F8B71C ctermfg=181
endfunction
" }}}

" Better Whitespace Highlighting {{{
function! frescoraja#highlights#whitespace() abort
  highlight! clear ExtraWhitespace
  highlight! ExtraWhitespace cterm=undercurl ctermfg=red guifg=#D32303
endfunction
" }}}

" Syntax Highlighting {{{
function! frescoraja#highlights#syntax() abort
  call frescoraja#highlights#general()
  if &syntax =~? 'javascript'
    call frescoraja#highlights#javascript()
  endif
endfunction

function! frescoraja#highlights#general() abort
  highlight! clear Error
  highlight! clear ErrorMsg
  highlight! clear SignColumn
  highlight! clear SpecialKey
  highlight! clear VertSplit
  highlight! clear Warning
  highlight! clear WarningMsg
  highlight! Error guifg=red ctermfg=red guibg=NONE ctermbg=NONE
  highlight! link ErrorMsg Error
  highlight! link SignColumn LineNr
  highlight! SpecialKey guifg=#767676 ctermfg=243 guibg=NONE ctermbg=NONE
  highlight! link VertSplit Type
  highlight! Warning guifg=yellow ctermfg=yellow guibg=NONE ctermbg=NONE
  highlight! link WarningMsg Warning
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
  highlight! jsThis guifg=#F07178 ctermfg=205 gui=italic cterm=italic
endfunction
" }}}

" vim: fdm=marker fmr={{{,}}} fen
