" ALE Plugin Highlighting {{{
function! frescoraja#highlights#ale(guibg, ctermbg) abort
  execute 'highlight! ALEErrorSign guifg=#FF4A64 ctermfg=167 ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! ALEWarningSign guifg=#FFBA32 ctermfg=178 ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! ALEInfoSign guifg=#DFF5FF ctermfg=195 ' . a:guibg . ' ' . a:ctermbg
  highlight! ALEError guifg=#FF4A64 ctermfg=167 guibg=NONE ctermbg=NONE gui=italic cterm=italic
  highlight! ALEWarning guifg=#FFBA32 ctermfg=178 guibg=NONE ctermbg=NONE gui=italic cterm=italic
  highlight! ALEInfo guifg=#DFF5FF ctermfg=195 guibg=NONE ctermbg=NONE gui=italic cterm=italic
endfunction
" }}}

" Conquer of Completion Highlighting {{{
function! frescoraja#highlights#coc(guibg, ctermbg) abort
  execute 'highlight! CocErrorSign guifg=#9F0B40 ctermfg=125 ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! CocWarningSign guifg=#E9AE4F ctermfg=172 ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! CocInfoSign guifg=#AACFFF ctermfg=153 ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! CocHintSign guifg=#A4F4CA ctermfg=158 ' . a:guibg . ' ' . a:ctermbg
  highlight! CocErrorHighlight gui=italic cterm=italic guifg=#9F0B40 ctermfg=125
  highlight! CocWarningHighlight gui=italic cterm=italic guifg=#E9AE4F ctermfg=172
  highlight! CocInfoHighlight gui=italic cterm=italic guifg=#AACFFF ctermfg=153
  highlight! CocHintHighlight gui=italic cterm=italic guifg=#A4F4CA ctermfg=158
endfunction
" }}}

" GitGutter Highlighting {{{
function! frescoraja#highlights#gitgutter(guibg, ctermbg) abort
  execute 'highlight! GitGutterAdd guifg=#76C78F ctermfg=115 ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! GitGutterChange guifg=#8AB2D3 ctermfg=153 ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! GitGutterDelete guifg=#D78787 ctermfg=174 ' . a:guibg . ' ' . a:ctermbg
  execute 'highlight! GitGutterChangeDelete guifg=#F8B71C ctermfg=181 ' . a:guibg . ' ' . a:ctermbg
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
