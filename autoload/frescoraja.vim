" frescoraja-vim-themes: A vim plugin wrapper for dynamic theme loading and customizing vim appearance.
"
" Script Info  {{{
"==========================================================================================================
" Name Of File: frescoraja.vim
"  Description: A vim plugin wrapper for dynamic theme loading and customizing vim appearance.
"   Maintainer: David James Carter <fresco.raja at gmail.com>
"      Version: 0.0.1
"
"==========================================================================================================
" }}}

" Script functions {{{
  function! s:apply_non_standard_theming() abort
    call <SID>colorize_comments()
    call <SID>colorize_column()
  endfunction

  function! s:apply_standard_theming() abort
    call <SID>italicize()
    call <SID>style_gutter()
  endfunction

  function! s:colorize_column(...) abort
    if a:0>0
      if (&termguicolors==0)
        execute 'highlight ColorColumn ctermbg='.string(a:1)
      elseif (&termguicolors) && (a:1=~?'\x\{6}$')
        let l:guibg=matchstr(a:1, '\zs\x\{6}')
        execute 'highlight ColorColumn guibg=#'.l:guibg
      endif
    else
      let l:col_color=get(g:, 'column_color_cterm', g:default_column_color_c)
      let l:col_color_gui=get(g:, 'column_color_gui', g:default_column_color_g)
      execute 'highlight ColorColumn ctermbg='.string(l:col_color).' guibg='.l:col_color_gui
    endif
  endfunction

  function! s:colorize_comments(...) abort
    try
      if a:0>0
        if (!&termguicolors)
          execute 'highlight Comment ctermfg='.string(a:1)
        elseif (&termguicolors) && (a:1=~?'\#\?\x\{6}')
          let l:guifg=matchstr(a:1, '\zs\x\{6}')
          execute 'highlight Comment guifg=#'.l:guifg
        endif
      else
        let l:cc=get(g:, 'comments_color_cterm', g:default_comments_color_c)
        let l:cc_gui=get(g:, 'comments_color_gui', g:default_comments_color_g)
        execute 'highlight Comment ctermfg='.string(l:cc).' guifg='.l:cc_gui
      endif
    endtry
  endfunction

  function! s:finalize_theme(...) abort
    let g:airline_theme=get(a:, 1, g:default_airline_theme)
    if exists(':AirlineTheme')
      execute ':AirlineTheme '.g:airline_theme
    endif
    doautocmd User CustomizedTheme
  endfunction

  function! s:fix_reset_highlighting() abort
    " if exists(':CurrentLineWhitespaceOn')
      " :CurrentLineWhitespaceOn
    " endif
    " redefine ExtraWhitespace highlighting
    highlight! ExtraWhitespace cterm=undercurl ctermfg=red guifg=#d32303
    " colorscheme maui doesn't defined vimCommand highlighting
    if g:custom_theme_name=~#'maui'
      highlight link vimCommand Statement
    endif
  endfunction

  function! s:get_highlight_term(group, term) abort
    let output=execute('highlight '.a:group)
    return matchstr(output, a:term.'=\zs\S*')
  endfunction
  function! s:style_gutter() abort
    highlight clear SignColumn
    highlight link SignColumn LineNr
    highlight SignColumn ctermfg=white guifg=white
    highlight link SyntasticWarningSign SignColumn
    highlight link SyntasticErrorSign SignColumn
    highlight SyntasticWarningSign term=standout ctermfg=yellow guifg=yellow
    highlight SyntasticErrorSign term=standout ctermfg=red guifg=red
  endfunction

  function! s:get_syntax_highlighting_under_cursor() abort
      let l:s=synID(line('.'), col('.'), 1)
      let l:syntax_group=synIDattr(l:s, 'name')
      if (empty(l:syntax_group))
        let l:current_word=expand('<cword>')
        echo 'No syntax group defined for "'.l:current_word.'"'
      else
        let l:linked_syntax_group=synIDattr(synIDtrans(l:s), 'name')
        execute 'echohl '.l:syntax_group
        echo l:syntax_group.' => '.l:linked_syntax_group
      endif
  endfunction

  function! s:italicize(...) abort
    let on_or_off=get(a:, 1, 0)
    if (on_or_off)
      let l:italic=<SID>get_highlight_term('Comment', 'cterm')
      if (match(l:italic, 'italic')>=0)
        highlight Comment cterm=none
        highlight htmlArg cterm=none
        highlight Boolean cterm=bold
        highlight Type cterm=bold
        highlight Keyword cterm=bold
        highlight WildMenu cterm=bold
      else
        highlight Comment cterm=italic
        highlight htmlArg cterm=italic
        highlight Boolean cterm=italic,bold
        highlight Type cterm=italic,bold
        highlight Keyword cterm=italic,bold
        highlight WildMenu cterm=italic,bold
      endif
    else
        highlight Comment cterm=italic
        highlight htmlArg cterm=italic
        highlight Boolean cterm=italic,bold
        highlight Type cterm=italic,bold
        highlight Keyword cterm=italic,bold
        highlight WildMenu cterm=italic,bold
    endif
  endfunction

  function! s:refresh_theme() abort
    let l:theme=get(g:, 'custom_theme_name', 'default')
    execute 'call frescoraja#'.l:theme.'()'
  endfunction

  function! s:toggle_dark() abort
    if (&background==?'light')
      set background=dark
    else
      set background=light
    endif
  endfunction

  function! s:toggle_background_transparency() abort
    if (&termguicolors==0)
      let l:term='ctermbg'
    else
      let l:term='guibg'
    endif
    let current_bg=<SID>get_highlight_term('Normal', l:term)
    if !empty(current_bg) && (current_bg!=?'none')
      highlight Normal guibg=NONE ctermbg=none
      highlight LineNr guibg=NONE ctermbg=none
    else
      let l:theme=get(g:, 'custom_theme_name', 'default')
      if l:theme==?'default'
        call frescoraja#default(1)
      else
        execute 'call frescoraja#'.l:theme.'()'
      endif
    endif
  endfunction

  function! s:toggle_column() abort
    if (&colorcolumn>0)
      set colorcolumn=0
    else
      execute 'set colorcolumn='.string(&textwidth)
    endif
  endfunction

  function! s:toggle_textwidth(num) abort
    try
      if(a:num+&textwidth==0)
        let l:t_w=get(g:, 'textwidth', g:default_textwidth)
        execute 'set textwidth='.string(l:t_w)
      else
        let g:textwidth=&textwidth
        execute 'set textwidth='.string(a:num)
      endif
      if (&colorcolumn)
        execute 'set colorcolumn='.string(&textwidth)
      endif
    endtry
  endfunction

  " Custom completion for CustomizeTheme command {{{
    function! s:get_custom_themes(a, l, p) abort
      let l:theme_fn_list=filter(split(execute('function'), '\n'), 'v:val =~? "function frescoraja#'.a:a.'"')
      return sort(map(l:theme_fn_list, function('<SID>shorten_fn_name')))
    endfunction

    function! s:customize_theme(...) abort
      try
        if a:0
          execute 'call frescoraja#'.a:1.'()'
        else
          echohl ErrorMsg | echo g:custom_theme_name
        endif
      catch /.*/
        echohl ErrorMsg | echo 'No theme found with that name'
      endtry
    endfunction

    function! s:shorten_fn_name(idx, fn_name) abort
      return matchstr(a:fn_name, '#\zs\w\+')
    endfunction
  " }}}
" }}}


" Theme functions {{{
function! frescoraja#init() abort
  let l:theme=get(g:, 'custom_theme_name', 'default')
  execute 'call frescoraja#'.l:theme.'()'
endfunction

function! frescoraja#default(...) abort
  colorscheme default
  set background=dark
  let g:custom_theme_name='default'
  let l:has_bg=get(a:, 1, 0)
  " bold, green number on cursor line

  highlight vimBracket ctermfg=green guifg=#33CA5F
  highlight vimParenSep ctermfg=blue guifg=#0486F1
  highlight CursorLineNr cterm=bold ctermfg=50 guifg=Cyan guibg=#232323
  highlight CursorLine cterm=none term=none guibg=NONE
  highlight vimIsCommand ctermfg=red guifg=#DC6532
  highlight link vimOperParen Special

  if (l:has_bg)
    highlight Normal ctermbg=233 guibg=#0f0f0f
    highlight LineNr ctermbg=234 ctermfg=yellow guibg=#1d1d1d guifg=#ff8e00
  endif
  call <SID>apply_non_standard_theming()
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('solarized')
endfunction

function! frescoraja#afterglow() abort
  set termguicolors
  colorscheme afterglow
  let g:custom_theme_name='afterglow'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('afterglow')
endfunction

function! frescoraja#base() abort
  set termguicolors
  colorscheme base
  let g:customize_theme_name='base'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('biogoo')
endfunction

function! frescoraja#blayu() abort
  set termguicolors
  colorscheme blayu
  highlight ColorColumn guibg=#2A3D4F
  highlight CursorLine guifg=#32C6B9
  let g:customize_theme_name='blayu'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('gotham')
endfunction

function! frescoraja#busybee() abort
  set notermguicolors
  colorscheme busybee
  highlight LineNr guifg=#505050 guibg=#101010
  highlight CursorLineNr guifg=#ff9800 guibg=#202020
  let g:customize_theme_name='busybee'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('qwq')
endfunction

function! frescoraja#candypaper() abort
  set notermguicolors
  colorscheme CandyPaper
  let g:custom_theme_name='candypaper'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('deus')
endfunction

function! frescoraja#ceudah() abort
  set termguicolors
  colorscheme ceudah
  let g:custom_theme_name='ceudah'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('quantum')
endfunction

function! frescoraja#dark() abort
  set termguicolors
  colorscheme dark
  let g:custom_theme_name='dark'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('sierra')
endfunction

function! frescoraja#deus() abort
  set termguicolors
  colorscheme deus
  let g:custom_theme_name='deus'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('deus')
endfunction

function! frescoraja#distill() abort
  set termguicolors
  colorscheme distill
  highlight ColorColumn guibg=#16181d
  " seems to be bug in distill??
  " let g:colors_name='distill'
  let g:custom_theme_name='distill'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('jellybeans')
endfunction

function! frescoraja#dracula() abort
  set termguicolors
  colorscheme dracula
  let g:custom_theme_name='dracula'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('dracula')
endfunction

function! frescoraja#edar() abort
  set termguicolors
  colorscheme edar
  let g:custom_theme_name='edar'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('lucius')
endfunction

function! frescoraja#flatcolor() abort
  set termguicolors
  colorscheme flatcolor
  let g:custom_theme_name='flatcolor'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('base16_nord')
endfunction

function! frescoraja#gotham() abort
  set termguicolors
  colorscheme gotham
  let g:custom_theme_name='gotham'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('gotham256')
endfunction

function! frescoraja#gruvbox() abort
  set termguicolors
  let g:gruvbox_contrast_dark='hard'
  let g:gruvbox_italicize_comments=1
  let g:gruvbox_italicize_strings=1
  colorscheme gruvbox
  let g:custom_theme_name='gruvbox'
  call <SID>finalize_theme('gruvbox')
endfunction

function! frescoraja#heroku() abort
  set termguicolors
  colorscheme herokudoc
  let g:custom_theme_name='herokudoc-gvim'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('material')
endfunction

function! frescoraja#hybrid_material() abort
  set termguicolors
  colorscheme hybrid_material
  let g:custom_theme_name='hybrid_material'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('hybrid')
endfunction

function! frescoraja#hybrid_material_nogui() abort
  set notermguicolors
  colorscheme hybrid_material
  let g:custom_theme_name='hybrid_material_nogui'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('hybrid')
endfunction

function! frescoraja#iceberg() abort
  set termguicolors
  colorscheme iceberg
  let g:custom_theme_name='iceberg'
  call <SID>apply_non_standard_theming()
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('lucius')
endfunction

function! frescoraja#jellybeans() abort
  set termguicolors
  let g:jellybeans_use_term_italics=1
  colorscheme jellybeans
  let g:custom_theme_name='jellybeans'
  call <SID>finalize_theme('jellybeans')
endfunction

function! frescoraja#kafka() abort
  set termguicolors
  colorscheme kafka
  let g:custom_theme_name='kafka'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('neodark')
endfunction

function! frescoraja#maui() abort
  set termguicolors
  colorscheme maui
  let g:custom_theme_name='maui'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('jellybeans')
endfunction

function! frescoraja#material() abort
  set termguicolors
  colorscheme material
  let g:colors_name='material'
  let g:custom_theme_name='material'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('material')
endfunction

function! frescoraja#material_dark() abort
  set termguicolors
  colorscheme material
  hi Normal guibg=#162127 ctermbg=233
  let g:colors_name='material'
  let g:custom_theme_name='material_dark'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('material')
endfunction

function! frescoraja#material_bright() abort
  set termguicolors
  let g:material_style='dark'
  colorscheme vim-material
  highlight TabLine guifg=#5D818E guibg=#212121 cterm=italic
  highlight TabLineFill guifg=#212121
  highlight TabLineSel guifg=#FFE57F guibg=#5D818E
  highlight ColorColumn guibg=#374349
  highlight CursorLine cterm=none
  let g:custom_theme_name='material_bright'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('material')
endfunction

function! frescoraja#material_oceanic() abort
  set termguicolors
  let g:material_style='oceanic'
  colorscheme vim-material
  highlight CursorLine cterm=none
  let g:custom_theme_name='material_oceanic'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('material')
endfunction

function! frescoraja#material_palenight() abort
  set termguicolors
  let g:material_style='palenight'
  colorscheme vim-material
  highlight TabLine guifg=#676E95 guibg=#191919 cterm=italic
  highlight TabLineFill guifg=#191919
  highlight TabLineSel guifg=#FFE57F guibg=#676E95
  highlight ColorColumn guibg=#3A3E4F
  highlight CursorLine cterm=none
  let g:custom_theme_name='material_palenight'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('material')
endfunction

function! frescoraja#material_theme() abort
  set termguicolors
  colorscheme material-theme
  let g:custom_theme_name='material_theme'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('material')
endfunction

function! frescoraja#molokai() abort
  set termguicolors
  let g:molokai_original=1
  let g:rehash256=1
  colorscheme molokai
  let g:custom_theme_name='molokai'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('molokai')
endfunction

function! frescoraja#molokai_dark() abort
  set notermguicolors
  colorscheme molokai_dark
  let g:custom_theme_name='molokai_dark'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('molokai')
endfunction

function! frescoraja#moonpink() abort
  set termguicolors
  colorscheme pink-moon
  let g:custom_theme_name='moonpink'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('lucius')
endfunction

function! frescoraja#moonorange() abort
  set termguicolors
  colorscheme orange-moon
  let g:custom_theme_name='moonorange'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('lucius')
endfunction

function! frescoraja#moonyellow() abort
  set termguicolors
  colorscheme yellow-moon
  let g:custom_theme_name='moonyellow'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('lucius')
endfunction

function! frescoraja#neodark() abort
  set termguicolors
  colorscheme neodark
  highlight Normal guibg=#0e1e27
  let g:custom_theme_name='neodark'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('neodark')
endfunction

function! frescoraja#neodark_nogui() abort
  set notermguicolors
  colorscheme neodark
  highlight Normal ctermbg=233
  let g:custom_theme_name='neodark_nogui'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('neodark')
endfunction

function! frescoraja#oceanicnext() abort
  set termguicolors
  colorscheme OceanicNext
  " highlight Statement guifg=#3590b1
  let g:custom_theme_name='oceanicnext'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('oceanicnext')
endfunction

function! frescoraja#oceanicnext2() abort
  set termguicolors
  colorscheme OceanicNext2
  let g:custom_theme_name='oceanicnext2'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('oceanicnext')
endfunction

function! frescoraja#onedark() abort
  set termguicolors
  colorscheme onedark
  highlight Normal guibg=#20242C
  let g:custom_theme_name='onedark'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('onedark')
endfunction

function! frescoraja#quantum_light() abort
  set termguicolors
  let g:quantum_italics=1
  let g:quantum_black=0
  colorscheme quantum
  let g:custom_theme_name='quantum_light'
  call <SID>style_gutter()
  call <SID>finalize_theme('deus')
endfunction

function! frescoraja#quantum_dark() abort
  set termguicolors
  let g:quantum_italics=1
  let g:quantum_black=1
  colorscheme quantum
  let g:custom_theme_name='quantum_dark'
  call <SID>style_gutter()
  call <SID>finalize_theme('murmur')
endfunction

function! frescoraja#spring_night() abort
  set termguicolors
  colorscheme spring-night
  hi LineNr guifg=#767f89 guibg=#1d2d42
  let g:custom_theme_name='spring_night'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('spring_night')
endfunction

function! frescoraja#srcery() abort
  set termguicolors
  colorscheme srcery
  let g:custom_theme_name='srcery'
  call <SID>apply_standard_theming()
  call <SID>finalize_theme('srcery')
endfunction

function! frescoraja#thaumaturge() abort
  set termguicolors
  colorscheme thaumaturge
  highlight ColorColumn guibg=#2c2936
  let g:custom_theme_name='thaumaturge'
  call <SID>finalize_theme('violet')
endfunction

function! frescoraja#znake() abort
  set termguicolors
colorscheme znake
  let g:custom_theme_name='znake'
  call <SID>finalize_theme('badcat')
endfunction
" }}} end Theme Definitions

" Autoload commands {{{
command! -nargs=? -complete=customlist,<SID>get_custom_themes CustomizeTheme call <SID>customize_theme(<f-args>)
command! -nargs=0 RefreshAppearance call <SID>refresh_theme()
command! -nargs=1 SetTextwidth call <SID>toggle_textwidth(<args>)
command! -nargs=? ColorizeColumn call <SID>colorize_column(<args>)
command! -nargs=? ColorizeComments call <SID>colorize_comments(<args>)
command! -nargs=0 ToggleColumn call <SID>toggle_column()
command! -nargs=0 ToggleBackground call <SID>toggle_background_transparency()
command! -nargs=0 ToggleDark call <SID>toggle_dark()
command! -bang -nargs=0 ToggleItalics call <SID>italicize(<bang>0)
command! -nargs=0 GetSyntaxGroup call <SID>get_syntax_highlighting_under_cursor()
command! -nargs=0 DefaultTheme call frescoraja#default()
" }}}


" Autocmds {{{
augroup frescoraja_theme_autocmds
  au!
  autocmd User CustomizedTheme call <SID>fix_reset_highlighting()
augroup END
" }}} end autocmds

