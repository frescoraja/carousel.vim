set encoding=utf-8
scriptencoding utf-8

" Script Info  {{{
"==========================================================================================================
" Name Of File: frescoraja.vim
"  Description: A vim plugin wrapper for dynamic theme loading and customizing vim appearance.
"   Maintainer: David James Carter <fresco.raja at gmail.com>
"      Version: 0.0.1
"
"==========================================================================================================
" }}}

" setup script variables {{{
" determine if inside tmux or Apple Terminal for proper escape sequences (used in shape_cursor functions)
let s:inside_tmux = exists('$TMUX')
let s:inside_terminal = $TERM_PROGRAM ==? 'Apple_Terminal'
" }}}

" Plugin functions {{{

" Script functions {{{
function! s:apply_highlights() abort
  let l:guibg = <SID>get_highlight_attr('LineNr', 'bg', 'gui', 1)
  let l:ctermbg = <SID>get_highlight_attr('LineNr', 'bg', 'cterm', 1)
  if get(g:, 'ale_enabled', 0)
    call frescoraja#highlights#ale(l:guibg, l:ctermbg)
  endif
  if get(g:, 'coc_enabled', 0)
    call frescoraja#highlights#coc(l:guibg, l:ctermbg)
  endif
  if get(g:, 'gitgutter_enabled', 0)
    call frescoraja#highlights#gitgutter(l:guibg, l:ctermbg)
  endif
  if get(g:, 'better_whitespace_enabled', 0)
    call frescoraja#highlights#whitespace()
  endif

  call frescoraja#highlights#syntax()
endfunction

function! s:cache_custom_theme_settings() abort
  if !exists('s:cache.themes')
    call <SID>load_custom_themes()
  endif
  let s:theme_index = index(s:cache.themes, g:custom_themes_name)
  let s:cache.bg.gui = <SID>get_highlight_attr('Normal', 'bg', 'gui', 0)
  let s:cache.bg.cterm = <SID>get_highlight_attr('Normal', 'bg', 'cterm', 0)
endfunction

function! s:colorize_group(...) abort
  " a:1 => syntax group name
  " a:2 => syntax color (optional)
  " Defaults to coloring foreground, unless `ColorColumn` group specified
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
    if !&termguicolors
      execute 'highlight ' . l:group . ' cterm' . l:fgbg . '=' . l:color
    else
      let l:hexcolor = matchstr(l:color, '\zs\x\{6}')
      let l:gui = empty(l:hexcolor) ? l:color : '#' . l:hexcolor
      execute 'highlight ' . l:group . ' gui' . l:fgbg . '=' . l:gui
    endif
  catch
    echohl ErrorMsg | echo v:exception
  endtry
endfunction

function! s:colorscheme_changed() abort
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
    echohl ErrorMsg | echo 'Custom theme could not be found'
  endtry
endfunction

function! s:cycle_colorschemes(step) abort
  if !exists('s:cache.colorschemes')
    call <SID>load_colorschemes()
  endif
  if !exists('s:colorscheme_index')
    let s:colorscheme_index = 0
  else
    let s:colorscheme_index = (s:colorscheme_index + a:step) % len(s:cache.colorschemes)
  endif
  execute 'colorscheme ' . s:cache.colorschemes[s:colorscheme_index]
endfunction

function! s:cycle_custom_theme(step) abort
  if !exists('s:cache.themes')
    call <SID>load_custom_themes()
  endif
  if !exists('s:theme_index')
    let s:theme_index = 0
  else
    let s:theme_index = (s:theme_index + a:step) % len(s:cache.themes)
  endif
  let l:next_theme = s:cache.themes[s:theme_index]
  execute 'call frescoraja#' . l:next_theme . '()'
endfunction

function! s:finalize_theme() abort
  " ColorScheme autocmd already executed, which refreshes AirlineTheme
  call <SID>cache_custom_theme_settings()
  call <SID>italicize()
  call <SID>fix_reset_highlighting()
  call <SID>apply_highlights()
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
  let l:current_char = getline('.')[col('.') - 1]
  let l:current_word = expand('<cword>')
  if (l:current_word !~? l:current_char)
    let l:current_word = l:current_char
  endif
  if empty(l:syntax_groups)
    echohl ErrorMsg |
          \ echo 'No syntax groups defined for "' . l:current_word . '"'
  else
    let l:output = join(l:syntax_groups, ',')
    execute 'echohl ' . l:syntax_groups[-1]
    echo l:current_word . ' => ' . l:output
  endif
endfunction

function! s:enable_italics() abort
  set t_ZH=[3m
  set t_ZR=[23m
endfunction

function! s:italicize(...) abort
  try
    let l:groups = split(
          \ get(a:, 2, 'Comment,htmlArg,WildMenu'),
          \ ',')
    if get(a:, 1, 0)
      for l:group in l:groups
        let l:cterm = <SID>get_highlight_value(l:group, 'cterm')
        let l:gui = <SID>get_highlight_value(l:group, 'gui')
        if (l:cterm =~? 'italic') || (l:gui =~? 'italic')
          let l:modes = join(
                \ filter(
                \ split(l:cterm, ','),
                \ 'v:val !~? "italic"'),
                \ ',')
          if !empty(l:modes)
            let l:new_modes = join(l:modes, ',')
            execute 'highlight ' . l:group . ' cterm=' . l:new_modes . ' gui=' . l:new_modes
          else
            execute 'highlight ' . l:group . ' cterm=NONE gui=NONE'
          endif
        else
          let l:new_modes = join(add(split(l:cterm, ','), 'italic'), ',')
          execute 'highlight ' . l:group . ' cterm=' . l:new_modes . ' gui=' . l:new_modes
        endif
      endfor
    else
      for l:group in l:groups
        let l:modes = <SID>get_highlight_value(l:group, 'cterm')
        let l:new_modes = join(add(split(l:modes, ','), 'italic'), ',')
        execute 'highlight ' . l:group . ' cterm=' . l:new_modes . ' gui=' . l:new_modes
      endfor
    endif
  catch
    echohl ErrorMsg | echo v:exception
  endtry
endfunction

function! s:reload_default() abort
  let l:theme = s:cache.default_theme
  if !empty(l:theme)
    execute 'call frescoraja#' . l:theme . '()'
  else
    execute 'colorscheme ' . s:cache.default_colorscheme

    if s:cache.true_color != &termguicolors
      execute 'set ' . (s:cache.true_color ? '' : 'no') . 'termguicolors'
    endif
  endif
endfunction

function! s:refresh_theme() abort
  let l:theme = get(g:, 'custom_themes_name', '')
  if !empty(l:theme)
    execute 'call frescoraja#' . l:theme . '()'
  endif
endfunction

function! s:TmuxEscape(seq) abort
  let l:tmux_start = "\<Esc>Ptmux;\<Esc>"
  let l:tmux_end   = "\<Esc>\\"

  return l:tmux_start . a:seq . l:tmux_end
endfunction

function! s:shape_cursor() abort
  " cursor mode sequences:
  " t_SI = enter Insert Mode
  " t_SR = enter Replace Mode
  " t_EI = enter Normal Mode
  " cursor shapes:
  " 0 - block
  " 1 - vertical line
  " 2 - underline
  let l:normal_cursor  = "\<Esc>]50;CursorShape=0\x7"
  let l:insert_cursor  = "\<Esc>]50;CursorShape=1\x7"
  let l:replace_cursor = "\<Esc>]50;CursorShape=2\x7"

  if s:inside_tmux
    let l:normal_cursor  = <SID>TmuxEscape(l:normal_cursor)
    let l:insert_cursor  = <SID>TmuxEscape(l:insert_cursor)
    let l:replace_cursor = <SID>TmuxEscape(l:replace_cursor)
  elseif s:inside_terminal
    " cursor shapes in Apple_Terminal:
    " 1 - block
    " 3 - underline
    " 5 - vertical line
    let l:normal_cursor  = "\e[1 q"
    let l:insert_cursor  = "\e[5 q"
    let l:replace_cursor = "\e[3 q"
  endif

  let &t_EI = l:normal_cursor
  let &t_SI = l:insert_cursor
  let &t_SR = l:replace_cursor
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
    let s:cache.bg[l:term] = l:current_bg
    highlight Normal guibg=NONE ctermbg=NONE
    highlight LineNr guibg=NONE ctermbg=NONE
  else
    " if no bg was cached use default dark settings
    " if termguicolors was changed, cached bg may be invalid, use default dark settings
    if empty(s:cache.bg[l:term])
      if l:term ==? 'gui' | let s:cache.bg.gui = '#0D0D0D' | endif
      if l:term ==? 'cterm' | let s:cache.bg.cterm = 233 | endif
    endif

    execute 'highlight Normal ' . l:term . 'bg=' . s:cache.bg[l:term]
  endif
  call <SID>apply_highlights()
endfunction

function! s:set_textwidth(bang, ...) abort
  try
    if a:bang && &textwidth
      let s:cache.textwidth = &textwidth
      setlocal textwidth=0
      setlocal colorcolumn=0
    else
      if exists('a:1')
        let l:new_textwidth = a:1
      elseif exists('s:cache.textwidth')
        let l:new_textwidth = s:cache.textwidth
      else
        let l:new_textwidth = 80
      endif
      execute 'setlocal textwidth=' . l:new_textwidth
      execute 'setlocal colorcolumn=' . l:new_textwidth
      let s:cache.textwidth = l:new_textwidth
    endif
  catch
    echohl ErrorMsg | echo v:exception
  endtry
endfunction

" Custom completion functions {{{
function! s:get_custom_themes(a, ...) abort
  if !exists('s:cache.themes')
    call <SID>load_custom_themes()
  endif

  return filter(
        \ copy(s:cache.themes), 'v:val =~? "^' . a:a . '"')
endfunction

function! s:get_syntax_groups(a, ...) abort
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
  for l:fname in l:themes
    let l:name = substitute(tolower(l:fname), '-', '_', 'g')
    let l:matching_fns = filter(copy(l:functions), 'v:val =~? "'.l:name.'"')
    let l:custom_themes += l:matching_fns
  endfor
  let s:cache.themes = uniq(sort(l:custom_themes))
endfunction

function! s:load_colorschemes() abort
  let s:cache.colorschemes = uniq(sort(map(
    \ globpath(&runtimepath, 'colors/*.vim', 0, 1),
    \ 'fnamemodify(v:val, ":t:r")')))
endfunction
" }}}

" }}}

" Theme functions {{{
function! frescoraja#init() abort
  let s:cache = {}
  let s:cache.bg = {}
  let s:cache.default_theme = get(g:, 'custom_themes_name', '')
  let s:cache.default_colorscheme = get(g:, 'colors_name', 'default')

  call <SID>load_custom_themes()
  call <SID>load_colorschemes()

  if get(g:, 'custom_italics_enabled', 0)
    call <SID>enable_italics()
  endif

  if get(g:, 'custom_cursors_enabled')
    call <SID>shape_cursor()
  endif

  if !empty(s:cache.default_theme)
    execute 'call frescoraja#' . s:cache.default_theme . '()'
  endif

  let s:cache.true_color = &termguicolors
endfunction

function! frescoraja#default() abort
  set background=dark
  set notermguicolors
  let g:airline_theme = 'jellybeans'
  let g:custom_themes_name = 'default'

  colorscheme default

  highlight! String ctermfg=13 guifg=#FFA0A0
  highlight! vimBracket ctermfg=green guifg=#33CA5F
  highlight! vimParenSep ctermfg=blue guifg=#0486F1
  highlight! CursorLineNr cterm=bold ctermfg=50 guifg=Cyan guibg=#232323
  highlight! CursorLine cterm=NONE term=NONE guibg=NONE
  highlight! vimIsCommand ctermfg=white guifg=#f1f4cc
  highlight! link vimOperParen Special
  highlight! Comment guifg=#7F7F7F ctermfg=243
  highlight! ColorColumn guibg=#5F0000 ctermbg=52
  highlight! Pmenu ctermbg=white guibg=white ctermfg=237 guifg=#1D1D1D
  highlight! Folded ctermbg=NONE guibg=NONE

  doautocmd User CustomizedTheme
endfunction

function! frescoraja#afterglow() abort
  set termguicolors
  let g:afterglow_blackout = 1
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
  let g:airline_theme = 'base16'
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
  let g:airline_theme = 'zenburn'
  colorscheme dark
  highlight Normal guibg=#181F2C
  highlight vimBracket guifg=#AA6A22
  highlight vimParenSep guifg=#8A3140
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#deep_space() abort
  set termguicolors
  let g:custom_themes_name = 'deep_space'
  let g:airline_theme = 'deep_space'
  colorscheme deep-space
  highlight Normal guibg=#111620
  highlight Folded guifg=#525C6D
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#deus() abort
  set termguicolors
  let g:custom_themes_name = 'deus'
  let g:airline_theme = 'deus'
  colorscheme deus
  highlight Normal guibg=#1C222B
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#distill() abort
  set termguicolors
  let g:custom_themes_name = 'distill'
  let g:airline_theme = 'iceberg'
  colorscheme distill
  highlight! ColorColumn guibg=#16181D
  highlight! LineNr guifg=#474B58
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
  let g:airline_theme = 'iceberg'
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

function! frescoraja#kafka() abort
  set termguicolors
  let g:custom_themes_name = 'kafka'
  let g:airline_theme = 'neodark'
  colorscheme kafka
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#mango() abort
  set notermguicolors
  let g:custom_themes_name = 'mango'
  let g:airline_theme = 'seagull'
  colorscheme mango
  highlight! Pmenu ctermbg=white guibg=white ctermfg=237 guifg=#1D1D1D
  highlight! Folded ctermbg=NONE guibg=NONE
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#maui() abort
  set termguicolors
  let g:custom_themes_name = 'maui'
  let g:airline_theme = 'jellybeans'
  colorscheme maui
  highlight! LineNr guifg=#585858 ctermfg=240
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

function! frescoraja#night_owl() abort
  set termguicolors
  let g:custom_themes_name = 'night_owl'
  let g:airline_theme = 'night_owl'
  colorscheme night-owl
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

function! frescoraja#onedarkafterglow() abort
  set termguicolors
  let g:custom_themes_name = 'onedarkafterglow'
  let g:airline_theme = 'onedark'
  colorscheme onedarkafterglow
  highlight Normal guibg=#080C14
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#quantum_light() abort
  set termguicolors
  let g:quantum_black = 0
  let g:custom_themes_name = 'quantum_light'
  let g:airline_theme = 'quantum'
  colorscheme quantum
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#quantum_dark() abort
  set termguicolors
  let g:quantum_black = 1
  let g:custom_themes_name = 'quantum_dark'
  let g:airline_theme = 'quantum'
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

function! frescoraja#stellarized() abort
  set termguicolors
  let g:custom_themes_name='stellarized'
  let g:airline_theme='stellarized_dark'
  colorscheme stellarized
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#tender() abort
  set termguicolors
  let g:custom_themes_name = 'tender'
  let g:airline_theme = 'tender'
  colorscheme tender
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#thaumaturge() abort
  set termguicolors
  let g:custom_themes_name = 'thaumaturge'
  let g:airline_theme = 'violet'
  colorscheme thaumaturge
  highlight ColorColumn guibg = #2C2936
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#tokyo_metro() abort
  set termguicolors
  let g:custom_themes_name='tokyo_metro'
  let g:airline_theme='tomorrow'
  colorscheme tokyo-metro
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
command! -nargs=0 RefreshTheme call <SID>refresh_theme()
command! -bang -nargs=? SetTextwidth call <SID>set_textwidth(<bang>0, <args>)
command! -nargs=0 ToggleBackground call <SID>toggle_background_transparency()
command! -nargs=0 ToggleDark call <SID>toggle_dark()
command! -nargs=0 GetSyntaxGroup call <SID>get_syntax_highlighting_under_cursor()
command! -nargs=0 DefaultTheme call <SID>reload_default()
command! -nargs=0 ReloadThemes call <SID>load_custom_themes()
command! -nargs=0 ReloadColorschemes call <SID>load_colorschemes()
command! -nargs=0 PrevTheme call <SID>cycle_custom_theme(-1)
command! -nargs=0 NextTheme call <SID>cycle_custom_theme(1)
command! -nargs=0 PrevColorscheme call <SID>cycle_colorschemes(-1)
command! -nargs=0 NextColorscheme call <SID>cycle_colorschemes(1)
" }}}

" Autogroup commands {{{
augroup custom_themes
  au!
  autocmd User CustomizedTheme call <SID>finalize_theme()
  autocmd ColorScheme * call <SID>colorscheme_changed()
augroup END
" }}} end autocmds

" vim: fdm=marker fmr={{{,}}} fen
