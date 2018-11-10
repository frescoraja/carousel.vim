" frescoraja-vim-themes: A vim plugin wrapper for dynamic theme loading and customizing vim appearance.

" Script Info  {{{
"==========================================================================================================
" Name Of File: frescoraja.vim
"  Description: A vim plugin wrapper for dynamic theme loading and customizing vim appearance.
"   Maintainer: David James Carter <fresco.raja at gmail.com>
"      Version: 0.0.1
"
"==========================================================================================================
" }}}

" colorscheme functions {{{

" Script functions {{{
function! s:apply_ale_sign_highlights() abort
  let l:guibg = <SID>get_highlight_attr('LineNr', 'bg', 'gui', 1)
  let l:ctermbg = <SID>get_highlight_attr('LineNr', 'bg', 'cterm', 1)
  highlight clear ALEErrorSign
  highlight clear ALEWarningSign
  highlight clear ALEInfoSign
  execute 'highlight! ALEErrorSign gui=bold cterm=bold guifg=red ctermfg=red ' . l:guibg . ' ' . l:ctermbg
  execute 'highlight! ALEWarningSign gui=bold cterm=bold guifg=yellow ctermfg=yellow ' . l:guibg . ' ' . l:ctermbg
  execute 'highlight! ALEInfoSign gui=bold cterm=bold guifg=#D7AF87 ctermfg=180 ' . l:guibg . ' ' . l:ctermbg
  highlight! ALEError guifg=red ctermfg=red guibg=black ctermbg=black gui=italic cterm=italic
  highlight! ALEWarning guifg=yellow ctermfg=yellow guibg=black ctermbg=black gui=italic cterm=italic
  highlight! ALEInfo guifg=white ctermfg=white guibg=black ctermbg=black gui=italic cterm=italic
endfunction

function! s:apply_consistent_bg() abort
  call <SID>apply_signcolumn_highlights()
  call <SID>apply_ale_sign_highlights()
  call <SID>apply_gitgutter_highlights()
  call <SID>apply_whitespace_highlights()
endfunction

function! s:apply_gitgutter_highlights() abort
  let l:guibg = <SID>get_highlight_attr('LineNr', 'bg', 'gui', 1)
  let l:ctermbg = <SID>get_highlight_attr('LineNr', 'bg', 'cterm', 1)
  highlight clear GitGutterAdd
  highlight clear GitGutterChange
  highlight clear GitGutterDelete
  highlight clear GitGutterChangeDelete
  execute 'highlight! GitGutterAdd guifg=#53D188 ctermfg=36 ' . l:guibg . ' ' . l:ctermbg
  execute 'highlight! GitGutterChange guifg=#5FD7FF ctermfg=81 ' . l:guibg . ' ' . l:ctermbg
  execute 'highlight! GitGutterDelete guifg=#FF005F ctermfg=196 ' . l:guibg . ' ' . l:ctermbg
  execute 'highlight! GitGutterChangeDelete guifg=#AF87FF ctermfg=141 ' . l:guibg . ' ' . l:ctermbg
endfunction

function! s:apply_signcolumn_highlights() abort
  highlight! link SignColumn LineNr
endfunction

function! s:apply_whitespace_highlights() abort
  highlight clear ExtraWhitespace
  highlight! ExtraWhitespace cterm=undercurl ctermfg=red guifg=#d32303
endfunction

function! s:cache_settings() abort
  if exists('g:custom_themes_name')
    let s:custom_themes_index = index(s:loaded_custom_themes, g:custom_themes_name)
  endif
  if exists('g:colors_name')
    let s:colorscheme_index = index(s:loaded_colorschemes, g:colors_name)
  endif
  let s:cached_bg.gui = <SID>get_highlight_attr('Normal', 'bg', 'gui', 0)
  let s:cached_bg.cterm = <SID>get_highlight_attr('Normal', 'bg', 'cterm', 0)
endfunction

function! s:colorize_group(...) abort
  " a:1 => syntax group name
  " a:2 => syntax color (optional)
  " Default to foreground coloring, unless ColorColumn group specified
  let l:args = split(a:1, '\s')
  if len(l:args) > 1
    let l:group = l:args[0]
    let l:color = l:args[1]
  else
    let l:group = a:1
    let l:color = get(a:, 2, '')
  endif
  let l:fgbg = l:group ==? 'ColorColumn' ? 'bg' : 'fg'
  try
    if !empty(l:color)
      if !&termguicolors
        execute 'highlight ' . l:group . ' cterm' . l:fgbg . '=' . l:color
      else
        let l:hexcolor = matchstr(l:color, '\zs\x\{6}')
        let l:gui = empty(l:hexcolor) ? l:color : '#' . l:hexcolor
        execute 'highlight ' . l:group . ' gui' . l:fgbg . '=' . l:gui
      endif
    else
      let l:cc = g:custom_theme_defaults[tolower(l:group)].cterm
      let l:cg = g:custom_theme_defaults[tolower(l:group)].gui
      execute 'highlight ' . l:group . ' cterm' . l:fgbg . '=' . l:cc . ' gui' . l:fgbg . '=' . l:cg
    endif
  catch
    echohl ErrorMsg | echo v:exception
  endtry
endfunction

function! s:colorscheme_changed() abort
  call <SID>cache_settings()
  call <SID>apply_consistent_bg()
  if exists(':AirlineRefresh')
    AirlineRefresh
  endif
endfunction

function! s:customize_theme(...) abort
  try
    if a:0
      execute 'call frescoraja#' . a:1 . '()'
    else
      echohl ModeMsg | echo g:custom_themes_name
    endif
  catch
    echohl ErrorMsg | echo v:exception
  endtry
endfunction

function! s:cycle_colorschemes(step) abort
  if !exists('s:loaded_colorschemes')
    call <SID>load_colorschemes()
  endif
  if !exists('s:colorscheme_index')
    let s:colorscheme_index = 0
  else
    let s:colorscheme_index = (s:colorscheme_index + a:step) % len(s:loaded_colorschemes)
  endif
  execute 'colorscheme ' . s:loaded_colorschemes[s:colorscheme_index]
endfunction

function! s:cycle_custom_theme(step) abort
  if !exists('s:loaded_custom_themes')
    call <SID>load_custom_themes()
  endif
  if !exists('s:custom_themes_index')
    let s:custom_themes_index = 0
  else
    let s:custom_themes_index = (s:custom_themes_index + a:step) % len(s:loaded_custom_themes)
  endif
  let l:next_theme = s:loaded_custom_themes[s:custom_themes_index]
  execute 'call frescoraja#' . l:next_theme . '()'
endfunction

function! s:finalize_theme() abort
  call <SID>cache_settings()
  call <SID>italicize()
  call <SID>fix_reset_highlighting()
  call <SID>apply_consistent_bg()
endfunction

function! s:fix_reset_highlighting() abort
  " TODO: find broken highlights after switching themes
  if get(g:, 'colors_name', '') =~# 'maui'
    highlight! link vimCommand Statement
  endif
endfunction

function! s:get_highlight_attr(group, term, mode, include_term) abort
  let l:hl_value = synIDattr(synIDtrans(hlID(a:group)), a:term, a:mode)
  if !empty(l:hl_value)
    let l:result = a:include_term ? a:mode . a:term . '=' . l:hl_value : l:hl_value
  else
    let l:result = ''
  endif

  return l:result
endfunction

function! s:get_highlight_value(group, term) abort
   try
    return matchstr(execute('highlight ' . a:group), a:term . '=\zs\S\+')
  catch
    return ''
  endtry
endfunction

function! s:get_syntax_highlighting_under_cursor() abort
  let l:syntax_groups = map(
        \ synstack(line('.'), col('.')),
        \ 'synIDattr(synIDtrans(v:val), "name")')
  let l:current_word = expand('<cword>')
  if empty(l:syntax_groups)
    echohl ErrorMsg |
          \ echo 'No syntax groups defined for "' . l:current_word . '"'
  else
    let l:output = join(l:syntax_groups, ',')
    execute 'echohl ' . l:syntax_groups[-1]
    echo l:current_word . ' => ' . l:output
  endif
endfunction

function! s:italicize(...) abort
  try
    let l:groups = split(
          \ get(a:, 2, 'Comment,htmlArg,WildMenu'),
          \ ',')
    if get(a:, 1, 0)
      for group in l:groups
        let l:cterm = <SID>get_highlight_value(group, 'cterm')
        let l:gui = <SID>get_highlight_value(group, 'gui')
        if (l:cterm =~? 'italic') || (l:gui =~? 'italic')
          let l:modes = join(
                \ filter(
                \ split(l:cterm, ','),
                \ 'v:val !~? "italic"'),
                \ ',')
          if !empty(l:modes)
            let l:new_modes = join(l:modes, ',')
            execute 'highlight ' . group . ' cterm=' . l:new_modes . ' gui=' . l:new_modes
          else
            execute 'highlight ' . group . ' cterm=NONE gui=NONE'
          endif
        else
          let l:new_modes = join(add(split(l:cterm, ','), 'italic'), ',')
          execute 'highlight ' . group . ' cterm=' . l:new_modes . ' gui=' . l:new_modes
        endif
      endfor
    else
      for group in l:groups
        let l:modes = <SID>get_highlight_value(group, 'cterm')
        let l:new_modes = join(add(split(l:modes, ','), 'italic'), ',')
        execute 'highlight ' . group . ' cterm=' . l:new_modes . ' gui=' . l:new_modes
      endfor
    endif
  catch
    echohl ErrorMsg | echo v:exception
  endtry
endfunction

function! s:refresh_theme() abort
  let l:theme = get(g:, 'custom_themes_name', '')
  if !empty(l:theme)
    execute 'call frescoraja#' . l:theme . '()'
  endif
endfunction

function! s:shape_cursor() abort
  " cursor shapes:
  " 1 - block (blinking)
  " 3 - underline (blinking)
  " 5 - vertical line (blinking)
  if &term =~? '^\(xterm\)\|\(rxvt\)'
    call <SID>shape_cursor_normal(1)
    call <SID>shape_cursor_replace(3)
    call <SID>shape_cursor_insert(5)
  endif
endfunction

function! s:shape_cursor_normal(shape) abort
  let &t_EI = "\<Esc>[" . a:shape . ' q'
endfunction

function! s:shape_cursor_insert(shape) abort
  let &t_SI = "\<Esc>[" . a:shape . ' q'
endfunction

function! s:shape_cursor_replace(shape) abort
  let &t_SR = "\<Esc>[" . a:shape . ' q'
endfunction

function! s:toggle_dark() abort
  if &background ==? 'light'
    set background=dark
  else
    set background=light
  endif
endfunction

function! s:toggle_background_transparency() abort
  let l:term = &termguicolors == 0 ? 'cterm' : 'gui'
  let l:current_bg = <SID>get_highlight_attr('Normal', 'bg', l:term, 0)
  if !empty(l:current_bg)
    let s:cached_bg[l:term] = l:current_bg
    highlight Normal guibg=NONE ctermbg=NONE
    highlight LineNr guibg=NONE ctermbg=NONE
  else
    " if no bg was cached use default dark settings
    " if termguicolors was changed, cached bg may be invalid, use default dark settings
    if empty(s:cached_bg[l:term])
      if l:term ==? 'gui' | let s:cached_bg.gui = '#0D0D0D' | endif
      if l:term ==? 'cterm' | let s:cached_bg.cterm = 233 | endif
    endif

    execute 'highlight Normal ' . l:term . 'bg=' . s:cached_bg[l:term]
  endif
  call <SID>apply_consistent_bg()
endfunction

function! s:set_textwidth(bang, ...) abort
  try
    if a:bang && &textwidth
      let g:custom_theme_defaults.textwidth = &textwidth
      set textwidth=0
      set colorcolumn=0
    else
      let l:new_textwidth = get(a:, 1, g:custom_theme_defaults.textwidth)
      let g:custom_theme_defaults.textwidth = l:new_textwidth
      execute 'set textwidth=' . l:new_textwidth
      execute 'set colorcolumn=' . l:new_textwidth
    endif
  catch
    echohl ErrorMsg | echo v:exception
  endtry
endfunction

" Custom completion functions {{{
function! s:get_custom_themes(a, l, p) abort
  if !exists('s:loaded_custom_themes')
    call <SID>load_custom_themes()
  endif

  return filter(
        \ copy(s:loaded_custom_themes), 'v:val =~? "^' . a:a . '"')
endfunction

function! s:get_syntax_groups(a, l, p) abort
  return filter(
        \ map(
        \ split(
        \ execute('highlight'), "\n"),
        \ 'matchstr(v:val, ''^\S\+'')'),
        \ 'v:val =~? "' . a:a . '"')
endfunction
" }}}

" Initialize colorscheme/theme caches {{{
function! s:load_custom_themes() abort
  let l:themes = sort(map(
    \ globpath(&runtimepath, 'colors/*.vim', 0, 1),
    \ 'fnamemodify(v:val, ":t:r")'))
  let l:functions = map(filter(split(
    \ execute('function'), "\n"),
    \ 'v:val =~? "frescoraja"'),
    \ 'matchstr(v:val, ''#\zs\w\+'')')
  let l:custom_themes = []
  for fname in l:themes
    let l:name = substitute(tolower(fname), '-', '_', 'g')
    let l:matching_fns = filter(copy(l:functions), 'v:val =~? "'.l:name.'"')
    let l:custom_themes += l:matching_fns
  endfor
  let s:loaded_custom_themes = uniq(sort(l:custom_themes))
endfunction

function! s:load_colorschemes() abort
  let s:loaded_colorschemes = uniq(sort(map(
    \ globpath(&runtimepath, 'colors/*.vim', 0, 1),
    \ 'fnamemodify(v:val, ":t:r")')))
endfunction
" }}}

" }}}

" Theme functions {{{
function! frescoraja#init() abort
  let s:cached_bg = {}

  call <SID>load_custom_themes()
  call <SID>load_colorschemes()

  let l:theme = g:custom_theme_defaults.theme

  if !empty(l:theme)
    execute 'call frescoraja#' . l:theme . '()'
  endif
endfunction

function! frescoraja#default() abort
  set background=dark
  let g:airline_theme = g:custom_theme_defaults.airline
  let g:custom_themes_name = 'default'

  colorscheme default
  highlight! String ctermfg=13 guifg=#FFA0A0
  highlight! vimBracket ctermfg=green guifg=#33CA5F
  highlight! vimParenSep ctermfg=blue guifg=#0486F1
  highlight! CursorLineNr cterm=bold ctermfg=50 guifg=Cyan guibg=#232323
  highlight! CursorLine cterm=NONE term=NONE guibg=NONE
  highlight! vimIsCommand ctermfg=white guifg=#f1f4cc
  highlight! Number term=bold ctermfg=86 guifg=#51AFFF
  highlight! link vimOperParen Special

  doautocmd User CustomizedTheme
  call <SID>colorize_group('ColorColumn')
  call <SID>colorize_group('Comment')
endfunction

function! frescoraja#afterglow() abort
  set termguicolors
  let g:custom_themes_name = 'afterglow'
  let g:airline_theme = 'afterglow'
  colorscheme afterglow
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#ayu() abort
  set termguicolors
  let g:ayucolor = 'dark'
  let g:custom_themes_name = 'ayu'
  let g:airline_theme = 'ayu'
  colorscheme ayu
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#ayu_mirage() abort
  set termguicolors
  let g:ayucolor = 'mirage'
  let g:custom_themes_name = 'ayu_mirage'
  let g:airline_theme = 'ayu_mirage'
  colorscheme ayu
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#blayu() abort
  set termguicolors
  let g:custom_themes_name = 'blayu'
  let g:airline_theme = 'gotham'
  colorscheme blayu
  highlight! CursorLine guifg=#32C6B9
  highlight! ColorColumn guibg=#2A3D4F
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#bold() abort
  set termguicolors
  let g:custom_themes_name = 'bold'
  let g:airline_theme = 'sierra'
  colorscheme bold-contrast
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#busybee() abort
  set notermguicolors
  let g:custom_themes_name = 'busybee'
  let g:airline_theme = 'qwq'
  colorscheme busybee
  highlight! LineNr guifg=#505050 guibg=#101010
  highlight! CursorLineNr guifg=#ff9800 guibg=#202020
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#ceudah() abort
  set termguicolors
  let g:custom_themes_name = 'ceudah'
  let g:airline_theme = 'quantum'
  colorscheme ceudah
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#chito() abort
  set termguicolors
  let g:custom_themes_name = 'chito'
  let g:airline_theme = 'quantum'
  colorscheme chito
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#colorsbox_stnight() abort
  set termguicolors
  let g:custom_themes_name = 'colorsbox_stnight'
  let g:airline_theme = 'afterglow'
  colorscheme colorsbox-stnight
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#colorsbox_steighties() abort
  set termguicolors
  let g:custom_themes_name = 'colorsbox_steighties'
  let g:airline_theme = 'quantum'
  colorscheme colorsbox-steighties
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#dark() abort
  set termguicolors
  let g:custom_themes_name = 'dark'
  let g:airline_theme = 'sierra'
  colorscheme dark
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#deus() abort
  set termguicolors
  let g:custom_themes_name = 'deus'
  let g:airline_theme = 'deus'
  colorscheme deus
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#distill() abort
  set termguicolors
  let g:custom_themes_name = 'distill'
  let g:airline_theme = 'jellybeans'
  colorscheme distill
  highlight! ColorColumn guibg=#16181d
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#edar() abort
  set termguicolors
  let g:custom_themes_name = 'edar'
  let g:airline_theme = 'lucius'
  colorscheme edar
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#flatcolor() abort
  set termguicolors
  let g:custom_themes_name = 'flatcolor'
  let g:airline_theme = 'base16_nord'
  colorscheme flatcolor
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#goldfish() abort
  set termguicolors
  let g:custom_themes_name = 'goldfish'
  let g:airline_theme = 'serene'
  colorscheme goldfish-contrast
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#gotham() abort
  set termguicolors
  let g:custom_themes_name = 'gotham'
  let g:airline_theme = 'gotham256'
  colorscheme gotham
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#gruvbox() abort
  set termguicolors
  let g:gruvbox_contrast_dark = 'hard'
  let g:custom_themes_name = 'gruvbox'
  let g:airline_theme = 'gruvbox'
  colorscheme gruvbox
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#heroku_gvim() abort
  set termguicolors
  let g:custom_themes_name = 'heroku_gvim'
  let g:airline_theme = 'material'
  colorscheme herokudoc-gvim
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#hybrid_material() abort
  set termguicolors
  let g:custom_themes_name = 'hybrid_material'
  let g:airline_theme = 'hybrid'
  colorscheme hybrid_material
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#hybrid_material_nogui() abort
  set notermguicolors
  let g:custom_themes_name = 'hybrid_material_nogui'
  let g:airline_theme = 'hybrid'
  colorscheme hybrid_material
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#iceberg() abort
  set termguicolors
  let g:custom_themes_name = 'iceberg'
  let g:airline_theme = 'iceberg'
  colorscheme iceberg
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#iceberg_nogui() abort
  set notermguicolors
  let g:custom_themes_name = 'iceberg_nogui'
  let g:airline_theme = 'solarized'
  colorscheme iceberg
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#jellybeans() abort
  set termguicolors
  let g:jellybeans_use_term_italics = 1
  let g:custom_themes_name = 'jellybeans'
  let g:airline_theme = 'jellybeans'
  colorscheme jellybeans
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#jumper() abort
  set termguicolors
  let g:custom_themes_name = 'jumper'
  let g:airline_theme = 'base16'
  colorscheme jumper-contrast
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#kafka() abort
  set termguicolors
  let g:custom_themes_name = 'kafka'
  let g:airline_theme = 'neodark'
  colorscheme kafka
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#legacy() abort
  set termguicolors
  let g:custom_themes_name = 'legacy'
  let g:airline_theme = 'ayu'
  colorscheme legacy
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#legacy_dark() abort
  set termguicolors
  let g:custom_themes_name = 'legacy_dark'
  let g:airline_theme = 'zenburn'
  colorscheme legacy-contrast
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#maui() abort
  set termguicolors
  let g:custom_themes_name = 'maui'
  let g:airline_theme = 'jellybeans'
  colorscheme maui
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#material() abort
  set termguicolors
  let g:custom_themes_name = 'material'
  let g:airline_theme = 'material'
  colorscheme material
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#material_dark() abort
  set termguicolors
  let g:custom_themes_name = 'material_dark'
  let g:airline_theme = 'materialmonokai'
  colorscheme material
  highlight! Normal guibg=#162127 ctermbg=233
  highlight! Todo guibg=#000000 guifg=#BD9800 cterm=bold
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#vim_material() abort
  set termguicolors
  let g:material_style = 'dark'
  let g:custom_themes_name = 'vim_material'
  let g:airline_theme = 'material'
  colorscheme vim-material
  highlight! TabLine guifg=#5D818E guibg=#212121 cterm=italic
  highlight! TabLineFill guifg=#212121
  highlight! TabLineSel guifg=#FFE57F guibg=#5D818E
  highlight! ColorColumn guibg=#374349
  highlight! CursorLine cterm=NONE
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#vim_material_oceanic() abort
  set termguicolors
  let g:material_style = 'oceanic'
  let g:custom_themes_name = 'vim_material_oceanic'
  let g:airline_theme = 'material'
  colorscheme vim-material
  highlight! CursorLine cterm=NONE
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#vim_material_palenight() abort
  set termguicolors
  let g:material_style = 'palenight'
  let g:custom_themes_name = 'vim_material_palenight'
  let g:airline_theme = 'material'
  colorscheme vim-material
  highlight! TabLine guifg=#676E95 guibg=#191919 cterm=italic
  highlight! TabLineFill guifg=#191919
  highlight! TabLineSel guifg=#FFE57F guibg=#676E95
  highlight! ColorColumn guibg=#3A3E4F
  highlight! CursorLine cterm=NONE
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#material_theme() abort
  set termguicolors
  let g:custom_themes_name = 'material_theme'
  let g:airline_theme = 'material'
  colorscheme material-theme
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#molokai() abort
  set termguicolors
  let g:molokai_original = 1
  let g:rehash256 = 1
  let g:custom_themes_name = 'molokai'
  let g:airline_theme = 'molokai'
  colorscheme molokai
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#molokai_dark_nogui() abort
  set notermguicolors
  let g:custom_themes_name = 'molokai_dark_nogui'
  let g:airline_theme = 'molokai'
  colorscheme molokai_dark
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#pink_moon() abort
  set termguicolors
  let g:custom_themes_name = 'pink_moon'
  let g:airline_theme = 'lucius'
  colorscheme pink-moon
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#orange_moon() abort
  set termguicolors
  let g:custom_themes_name = 'orange_moon'
  let g:airline_theme = 'lucius'
  colorscheme orange-moon
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#yellow_moon() abort
  set termguicolors
  let g:custom_themes_name = 'yellow_moon'
  let g:airline_theme = 'lucius'
  colorscheme yellow-moon
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#neodark() abort
  set termguicolors
  let g:custom_themes_name = 'neodark'
  let g:airline_theme = 'neodark'
  colorscheme neodark
  highlight! Normal guibg=#0e1e27
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#neodark_nogui() abort
  set notermguicolors
  let g:custom_themes_name = 'neodark_nogui'
  let g:airline_theme = 'neodark'
  colorscheme neodark
  highlight! Normal ctermbg=233
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#oceanicnext() abort
  set termguicolors
  let g:custom_themes_name = 'oceanicnext'
  let g:airline_theme = 'oceanicnext'
  colorscheme OceanicNext
  highlight! Normal guibg=#0E1E27
  highlight! LineNr guibg=#0E1E27
  highlight! Identifier guifg=#3590B1
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#oceanicnext2() abort
  set termguicolors
  let g:custom_themes_name = 'oceanicnext2'
  let g:airline_theme = 'oceanicnext'
  colorscheme OceanicNext2
  highlight! LineNr guibg=#141E23
  highlight! CursorLineNr guifg=#72C7D1
  highlight! Identifier guifg=#4BB1A7
  highlight! PreProc guifg=#A688F6
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#onedark() abort
  set termguicolors
  let g:custom_themes_name = 'onedark'
  let g:airline_theme = 'onedark'
  colorscheme onedark
  highlight! Normal guibg=#20242C
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#quantum_light() abort
  set termguicolors
  let g:quantum_black = 0
  let g:custom_themes_name = 'quantum_light'
  let g:airline_theme = 'deus'
  colorscheme quantum
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#quantum_dark() abort
  set termguicolors
  let g:quantum_black = 1
  let g:custom_themes_name = 'quantum_dark'
  let g:airline_theme = 'murmur'
  colorscheme quantum
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#spring_night() abort
  set termguicolors
  let g:custom_themes_name = 'spring_night'
  let g:airline_theme = 'spring_night'
  colorscheme spring-night
  highlight! LineNr guifg=#767f89 guibg=#1d2d42
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#srcery() abort
  set termguicolors
  let g:custom_themes_name = 'srcery'
  let g:airline_theme = 'srcery'
  colorscheme srcery
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#tender() abort
  set termguicolors
  let g:custom_themes_name = 'tender'
  let g:airline_theme = 'tender'
  colorscheme tender
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#tetra() abort
  set termguicolors
  let g:custom_themes_name = 'tetra'
  let g:airline_theme = 'badcat'
  colorscheme tetra-contrast
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#thaumaturge() abort
  set termguicolors
  let g:custom_themes_name = 'thaumaturge'
  let g:airline_theme = 'violet'
  colorscheme thaumaturge
  highlight ColorColumn guibg = #2c2936
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#zacks() abort
  set termguicolors
  let g:custom_themes_name = 'zacks'
  let g:airline_theme = 'biogoo'
  colorscheme zacks-contrast
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#znake() abort
  set termguicolors
  let g:airline_theme = 'lucius'
  let g:custom_themes_name = 'znake'
  colorscheme znake
  highlight! Normal guifg=#DCCFEE
  highlight! vimCommand guifg=#793A6A
  highlight! vimFuncKey guifg=#A91A7A cterm=bold
  highlight! Comment guifg=#5A5A69
  highlight! ColorColumn guibg=#331022 guifg=#A51F2B
  doautocmd User CustomizedTheme
endfunction
" }}} end Theme Definitions

" }}}

" Autoload commands {{{
command! -nargs=? -complete=customlist,<SID>get_custom_themes
      \ CustomizeTheme call <SID>customize_theme(<f-args>)
command! -nargs=1 -complete=customlist,<SID>get_syntax_groups
      \ ColorizeSyntaxGroup call <SID>colorize_group(<f-args>)
command! -bang -nargs=? -complete=customlist,<SID>get_syntax_groups
      \ Italicize call <SID>italicize(<bang>0, <f-args>)
command! -nargs=? ColorizeColumn call <SID>colorize_group('ColorColumn', <f-args>)
command! -nargs=? ColorizeComments call <SID>colorize_group('Comment', <f-args>)
command! -nargs=? ColorizeLineNr call <SID>colorize_group('LineNr', <f-args>)
command! -nargs=0 CustomThemeRefresh call <SID>refresh_theme()
command! -bang -nargs=? SetTextwidth call <SID>set_textwidth(<bang>0, <args>)
command! -nargs=0 ToggleBackground call <SID>toggle_background_transparency()
command! -nargs=0 ToggleDark call <SID>toggle_dark()
command! -nargs=0 GetSyntaxGroup call <SID>get_syntax_highlighting_under_cursor()
command! -nargs=0 DefaultTheme call frescoraja#default()
command! -nargs=0 RefreshCustomThemes call <SID>load_custom_themes()
command! -nargs=0 RefreshColorschemes call <SID>load_colorschemes()
command! -nargs=0 CycleCustomThemesPrev call <SID>cycle_custom_theme(-1)
command! -nargs=0 CycleCustomThemesNext call <SID>cycle_custom_theme(1)
command! -nargs=0 CycleColorschemesPrev call <SID>cycle_colorschemes(-1)
command! -nargs=0 CycleColorschemesNext call <SID>cycle_colorschemes(1)
" }}}

" Autogroup commands {{{
augroup custom_themes
  au!
  autocmd User CustomizedTheme call <SID>finalize_theme()
  autocmd ColorScheme * call <SID>colorscheme_changed()
augroup END

if (g:custom_theme_defaults.cursors)
  autocmd custom_themes VimEnter * call <SID>shape_cursor()
endif
" }}} end autocmds

" vim: fdm=marker fmr={{{,}}} fen
