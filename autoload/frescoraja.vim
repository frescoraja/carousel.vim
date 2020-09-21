set encoding=utf-8
scriptencoding utf-8

" Script Variables {{{

" determine if inside tmux or Apple Terminal for proper escape sequences (used in shape_cursor functions)
let s:inside_tmux = exists('$TMUX')
let s:inside_terminal = $TERM_PROGRAM ==? 'Apple_Terminal'

" theme -> airline theme mapping (only necessary if airline theme name != colorscheme name
let s:airline_theme_mapping = {
      \ 'apply': function('frescoraja#apply_airline_theme'),
      \ 'default': 'jellybeans',
      \ 'allomancer': 'hybrid',
      \ 'allomancer_nogui': 'hybridline',
      \ 'apprentice': 'jellybeans',
      \ 'candid': 'base16_nord',
      \ 'ceudah': 'quantum',
      \ 'chito': 'quantum',
      \ 'colorsbox_stnight': 'base16',
      \ 'colorsbox_steighties': 'quantum',
      \ 'dark': 'zenburn',
      \ 'distill': 'iceberg',
      \ 'edar': 'lucius',
      \ 'flatcolor': 'base16_nord',
      \ 'glacier': 'zenburn',
      \ 'gotham': 'gotham256',
      \ 'gruvbox8': 'gruvbox',
      \ 'gummybears': 'jellybeans',
      \ 'hybrid_material': 'hybrid',
      \ 'hybrid_reverse': 'hybrid',
      \ 'iceberg_nogui': 'iceberg',
      \ 'kafka': 'neodark',
      \ 'kuroi': 'neodark',
      \ 'kuroi_nogui': 'neodark',
      \ 'mango': 'seagull',
      \ 'material_monokai': 'materialmonokai',
      \ 'material_theme': 'material',
      \ 'vim_material': 'material',
      \ 'vim_material_oceanic': 'material',
      \ 'vim_material_palenight': 'material',
      \ 'molokai_dark_nogui': 'molokai',
      \ 'plastic': 'onedark',
      \ 'pink_moon': 'lucius',
      \ 'orange_moon': 'lucius',
      \ 'yellow_moon': 'lucius',
      \ 'neodark_nogui': 'neodark',
      \ 'oceanicnext2': 'oceanicnext',
      \ 'onedarkafterglow': 'onedark',
      \ 'petrel': 'seagull',
      \ 'quantum_light': 'quantum',
      \ 'quantum_dark': 'quantum',
      \ 'thaumaturge': 'violet',
      \ 'tokyo_metro': 'tomorrow',
      \ 'tomorrow_night': 'tomorrow',
      \ 'two_firewatch': 'twofirewatch',
      \ 'znake': 'lucius'
      \ }
" }}}

" Plugin functions {{{

" Script functions {{{
function! frescoraja#apply_airline_theme(theme_name) dict abort
  if exists(':AirlineRefresh')
    let g:airline_theme = has_key(l:self, a:theme_name) ? l:self[a:theme_name] : a:theme_name
    AirlineRefresh
  endif
endfunction

function! frescoraja#apply_highlights() abort
  let l:guibg = frescoraja#get_highlight_attr('LineNr', 'bg', 'gui')
  let l:ctermbg = frescoraja#get_highlight_attr('LineNr', 'bg', 'cterm')
  if get(g:, 'custom_themes_ale_highlights', 1)
    call frescoraja#highlights#ale(l:guibg, l:ctermbg)
  endif
  if get (g:, 'custom_themes_coc_highlights', 1)
    call frescoraja#highlights#coc(l:guibg, l:ctermbg)
    call frescoraja#highlights#gitgutter(l:guibg, l:ctermbg)
  endif
  if get(g:, 'custom_themes_extra_whitespace_highlights', 1)
    call frescoraja#highlights#whitespace()
  endif
  call frescoraja#highlights#syntax()
endfunction

function! frescoraja#cache_custom_theme_settings() abort
  if !exists('g:custom_themes_cache.themes')
    call frescoraja#load_custom_themes()
  endif
  let g:theme_index = index(g:custom_themes_cache.themes, g:custom_themes_name)
  let g:custom_themes_cache.bg.gui = frescoraja#get_highlight_attr('Normal', 'bg', 'gui')
  let g:custom_themes_cache.bg.cterm = frescoraja#get_highlight_attr('Normal', 'bg', 'cterm')
  let g:custom_themes_cache.random_times = 0
endfunction

function! frescoraja#colorize_group(...) abort
  " a:1 => syntax group name
  " a:2 => syntax color (optional)
  " Defaults to coloring foreground, unless `ColorColumn` group specified
  try
    let l:fgbg = a:1 ==? 'ColorColumn' ? 'bg' : 'fg'
    if a:0 == 3 " override fg/bg with arg if provided
      let l:fgbg = a:3
    endif
    let l:hexcolor = matchstr(a:2, '\zs\x\{6}')
    let l:color = empty(l:hexcolor) ? a:2 : '#' . l:hexcolor
    " l:term should be something like 'guifg=#FF11AA' or 'ctermbg=black'
    let l:term = (&termguicolors ? 'gui' : 'cterm') . l:fgbg . '=' . l:color
    execute join(['highlight', a:1, l:term], ' ')
  catch
    echohl ErrorMsg | echomsg v:exception | echohl None
  endtry
endfunction

function! frescoraja#colorscheme_changed() abort
  if get(g:, 'custom_themes_airline_highlights', 1)
    call s:airline_theme_mapping.apply(g:custom_themes_name)
  endif
endfunction

function! frescoraja#customize_theme(...) abort
  try
    if a:0
      execute 'call frescoraja#' . a:1 . '()'
    else
      echohl ModeMsg | echomsg g:custom_themes_name | echohl None
    endif
  catch
    echohl ErrorMsg | echomsg 'Custom theme could not be found' | echohl None
  endtry
endfunction

function! frescoraja#cycle_colorschemes(step) abort
  if !exists('g:custom_themes_cache.colorschemes')
    call frescoraja#load_colorschemes()
  endif
  if !exists('g:colorscheme_index')
    let g:colorscheme_index = 0
  else
    let g:colorscheme_index = (g:colorscheme_index + a:step) % len(g:custom_themes_cache.colorschemes)
  endif
  execute 'colorscheme ' . g:custom_themes_cache.colorschemes[g:colorscheme_index]
endfunction

function! frescoraja#cycle_custom_theme(step) abort
  if !exists('g:custom_themes_cache.themes')
    call frescoraja#load_custom_themes()
  endif
  if !exists('g:theme_index')
    let g:theme_index = 0
  else
    let g:theme_index = (g:theme_index + a:step) % len(g:custom_themes_cache.themes)
  endif
  let l:next_theme = g:custom_themes_cache.themes[g:theme_index]
  execute 'call frescoraja#' . l:next_theme . '()'
endfunction

function! frescoraja#initialize_theme(...) abort
  " reset all highlight groups to defaults
  highlight clear
  " default to termguicolors, if any arg provided notermguicolors
  if a:0 > 0
    set notermguicolors
  else
    set termguicolors
  endif
endfunction

function! frescoraja#finalize_theme() abort
  call frescoraja#cache_custom_theme_settings()
  call frescoraja#italicize()
  call frescoraja#apply_highlights()
  echohl WarningMsg | echomsg 'loaded theme:' g:custom_themes_name | echohl None
endfunction

function! frescoraja#get_highlight_attr(group, term, mode) abort
  return synIDattr(synIDtrans(hlID(a:group)), a:term, a:mode)
endfunction

function! frescoraja#get_highlight_value(group, term) abort
   try
    return matchstr(execute('highlight ' . a:group), a:term . '=\zs\S\+')
  catch
    return ''
  endtry
endfunction

function! frescoraja#get_syntax_highlighting_under_cursor() abort
  let l:syntax_groups = reverse(map(
        \ synstack(line('.'), col('.')),
        \ 'synIDattr(synIDtrans(v:val), "name")'))
  let l:current_char = getline('.')[col('.') - 1]
  let l:current_word = expand('<cword>')
  if (l:current_word !~? l:current_char)
    let l:current_word = l:current_char
  endif
  if empty(l:syntax_groups)
    echohl ErrorMsg | echomsg 'No syntax groups defined for "' . l:current_word . '"' | echohl None
  else
    let l:output = join(l:syntax_groups, ',')
    execute 'echohl ' . l:syntax_groups[-1] |
          \ echomsg l:current_word . ' => ' . l:output |
          \ echohl None
  endif
endfunction

function! frescoraja#enable_italics() abort
  set t_ZH=[3m
  set t_ZR=[23m
endfunction

function! frescoraja#italicize(...) abort
  try
    let l:type = &termguicolors ? 'gui' : 'cterm'
    let l:groups = split(
          \ get(a:, 2, 'Comment,htmlArg'),
          \ ',')
    for l:group in l:groups
      let l:modes = frescoraja#get_highlight_value(l:group, l:type)
      if get(a:, 1, 0) && l:modes =~? 'italic'
        let l:modes = filter(
              \ split(l:modes, ','),
              \ 'v:val !~? "italic"')
      else
        let l:modes = add(split(l:modes, ','), 'italic')
      endif
      let l:modes = empty(l:modes) ? 'NONE' : join(l:modes, ',')
      execute 'highlight ' . l:group . ' gui=' . l:modes . ' cterm=' . l:modes
    endfor
  catch
    echohl ErrorMsg | echomsg v:exception | echohl None
  endtry
endfunction

function! frescoraja#reload_default() abort
   execute 'call frescoraja#' . g:custom_themes_cache.default_theme . '()'
endfunction

function! frescoraja#refresh_theme() abort
  let l:theme = get(g:, 'custom_themes_name', '')
  if !empty(l:theme)
    execute 'call frescoraja#' . l:theme . '()'
  endif
endfunction

function! frescoraja#TmuxEscape(seq) abort
  let l:tmux_start = "\<Esc>Ptmux;\<Esc>"
  let l:tmux_end   = "\<Esc>\\"

  return l:tmux_start . a:seq . l:tmux_end
endfunction

function! frescoraja#shape_cursor() abort
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
    let l:normal_cursor  = frescoraja#TmuxEscape(l:normal_cursor)
    let l:insert_cursor  = frescoraja#TmuxEscape(l:insert_cursor)
    let l:replace_cursor = frescoraja#TmuxEscape(l:replace_cursor)
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

function! frescoraja#toggle_dark() abort
  if &background ==? 'light'
    set background=dark
  else
    set background=light
  endif
endfunction

function! frescoraja#toggle_background_transparency() abort
  let l:term = &termguicolors == 0 ? 'cterm' : 'gui'
  let l:current_bg = frescoraja#get_highlight_attr('Normal', 'bg', l:term)
  if empty(l:current_bg)
    " if no bg was cached (or bg was not set) use default dark settings
    " if termguicolors was changed, cached bg may be invalid, use default dark settings
    if empty(g:custom_themes_cache.bg[l:term])
      if l:term ==? 'gui' | let g:custom_themes_cache.bg.gui = '#0D0D0D' | endif
      if l:term ==? 'cterm' | let g:custom_themes_cache.bg.cterm = 233 | endif
    endif

    execute 'highlight Normal ' . l:term . 'bg=' . g:custom_themes_cache.bg[l:term]
  else
    let g:custom_themes_cache.bg[l:term] = l:current_bg
    highlight Normal guibg=NONE ctermbg=NONE
    highlight LineNr guibg=NONE ctermbg=NONE
    highlight VertSplit guibg=NONE ctermbg=NONE
    highlight NonText guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  endif
  call frescoraja#apply_highlights()
endfunction

function! frescoraja#set_textwidth(bang, ...) abort
  try
    if a:bang && &textwidth
      let g:custom_themes_cache.textwidth = &textwidth
      setlocal textwidth=0
      setlocal colorcolumn=0
    else
      if exists('a:1')
        let l:new_textwidth = a:1
      elseif exists('g:custom_themes_cache.textwidth')
        let l:new_textwidth = g:custom_themes_cache.textwidth
      else
        let l:new_textwidth = 80
      endif
      execute 'setlocal textwidth=' . l:new_textwidth
      execute 'setlocal colorcolumn=' . l:new_textwidth
      let g:custom_themes_cache.textwidth = l:new_textwidth
    endif
  catch
    echohl ErrorMsg | echomsg v:exception | echohl None
  endtry
endfunction

" Custom completion functions {{{
function! frescoraja#get_custom_themes(a, ...) abort
  if !exists('g:custom_themes_cache.themes')
    call frescoraja#load_custom_themes()
  endif

  return filter(copy(g:custom_themes_cache.themes), 'v:val =~? "' . a:a . '"')
endfunction

function! frescoraja#get_syntax_groups(a, ...) abort
  return filter(
        \ map(
        \ split(
        \ execute('highlight'), "\n"),
        \ 'matchstr(v:val, ''^\S\+'')'),
        \ 'v:val =~? "' . a:a . '"')
endfunction

function! frescoraja#get_themes_list() abort
  if !exists('g:custom_themes_cache.themes')
    call frescoraja#load_custom_themes()
  endif

  return copy(g:custom_themes_cache.themes)
endfunction
" }}}

" Initialize colorscheme/theme caches {{{
function! frescoraja#load_custom_themes() abort
  let l:themes = sort(map(
    \ globpath(&runtimepath, 'colors/*.vim', 0, 1),
    \ 'fnamemodify(v:val, ":t:r")'))
  let l:functions = map(filter(split(
    \ execute('function'), "\n"),
    \ 'v:val =~? "frescoraja"'),
    \ 'matchstr(v:val, ''#\zs\w\+'')')
  let l:custom_themes = ['random']
  for l:fname in l:themes
    let l:name = substitute(tolower(l:fname), '-', '_', 'g')
    let l:matching_fns = filter(copy(l:functions), 'v:val ==# "'.l:name.'"')
    let l:custom_themes += l:matching_fns
  endfor
  let g:custom_themes_cache.themes = uniq(sort(l:custom_themes))
endfunction

function! frescoraja#load_colorschemes() abort
  let g:custom_themes_cache.colorschemes = uniq(sort(map(
    \ globpath(&runtimepath, 'colors/*.vim', 0, 1),
    \ 'fnamemodify(v:val, ":t:r")')))
endfunction
" }}}

" }}}

" Theme functions {{{
function! frescoraja#init() abort
  let g:custom_themes_cache = {
        \ 'bg': {},
        \ 'default_theme': get(g:, 'custom_themes_name', 'default'),
        \ }

  call frescoraja#load_custom_themes()
  call frescoraja#load_colorschemes()

  if get(g:, 'custom_italics_enabled', 0)
    call frescoraja#enable_italics()
  endif

  if get(g:, 'custom_cursors_enabled', 0)
    call frescoraja#shape_cursor()
  endif

  execute 'call frescoraja#' . g:custom_themes_cache.default_theme . '()'
endfunction

function! frescoraja#random() abort
  try
    " check for python support
    if !has('python') && !has('python3')
      throw 'randomized theme selection requires python support.'
    endif
    let l:py_cmd = has('python3') ? 'py3' : 'py'
    let l:available_themes = filter(
          \ copy(g:custom_themes_cache.themes),
          \ 'v:val !=# "random"'
          \)
    let l:max_idx = len(l:available_themes)
    if l:max_idx > 0
      let l:rand_idx = trim(
            \ execute(l:py_cmd . ' import random; print(random.randint(0,' . (l:max_idx-1) . '))')
            \ )
      let l:theme = l:available_themes[l:rand_idx]
      execute 'call frescoraja#' . l:theme . '()'
    else
      throw 'no themes in g:custom_themes_cache'
    endif
  catch
    echohl ErrorMsg | echomsg 'Random theme could not be loaded: ' . v:exception . '. Loading `default` theme.' | echohl None
    call frescoraja#default()
  endtry
endfunction

function! frescoraja#default() abort
  set background=dark
  call frescoraja#initialize_theme(v:false)
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
  highlight! Pmenu ctermbg=241 guibg=#343434 ctermfg=250 guifg=#ADADAD
  highlight! Folded ctermbg=NONE guibg=NONE
  highlight! NonText ctermfg=green guifg=#008065

  doautocmd User CustomizedTheme
endfunction

function! frescoraja#afterglow() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'afterglow'
  colorscheme afterglow
  highlight! Pmenu guibg=#2A344E
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#allomancer() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'allomancer'
  colorscheme allomancer
  highlight! NonText guifg=#676B78
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#allomancer_nogui() abort
  call frescoraja#initialize_theme(v:false)
  let g:custom_themes_name = 'allomancer_nogui'
  colorscheme allomancer
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#apprentice() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'apprentice'
  colorscheme apprentice
  highlight! NonText guifg=#909090
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#ayu_dark() abort
  call frescoraja#initialize_theme()
  let g:ayucolor = 'dark'
  let g:custom_themes_name = 'ayu_dark'
  colorscheme ayu
  highlight! NonText guifg=#4F5459
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#ayu_mirage() abort
  call frescoraja#initialize_theme()
  let g:ayucolor = 'mirage'
  let g:custom_themes_name = 'ayu_mirage'
  colorscheme ayu
  highlight! NonText guifg=#717783
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#blayu() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'blayu'
  colorscheme blayu
  highlight clear CursorLine
  highlight! ColorColumn guibg=#2A3D4F
  highlight! MatchParen guifg=#AF37D0 guibg=#2E4153 cterm=bold,underline
  highlight! Pmenu guibg=#4f6275
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#candid() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'candid'
  colorscheme candid
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#ceudah() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'ceudah'
  colorscheme ceudah
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#challenger_deep() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'challenger_deep'
  colorscheme challenger_deep
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#chito() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'chito'
  colorscheme chito
  highlight! Normal guibg=#262A37
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#colorsbox_stnight() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'colorsbox_stnight'
  colorscheme colorsbox-stnight
  highlight! NonText guifg=#A08644
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#colorsbox_steighties() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'colorsbox_steighties'
  colorscheme colorsbox-steighties
  highlight! NonText guifg=#AB9B4B
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#dark() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'dark'
  colorscheme dark
  highlight! Normal guibg=#080F1C
  highlight! vimBracket guifg=#AA6A22
  highlight! vimParenSep guifg=#8A3140
  highlight! Pmenu guibg=#6F6F6F
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#deep_space() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'deep_space'
  colorscheme deep-space
  highlight! Normal guibg=#090E18
  highlight! Folded guifg=#525C6D
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#deus() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'deus'
  colorscheme deus
  highlight! Normal guibg=#1C222B
  highlight! NonText guifg=#83A598 guibg=NONE
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#distill() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'distill'
  colorscheme distill
  highlight! ColorColumn guibg=#16181D
  highlight! LineNr guifg=#474B58
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#edar() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'edar'
  colorscheme edar
  highlight! NonText guifg=#5988B5 guibg=NONE
  highlight! Pmenu guibg=#202A3A
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#edge() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'edge'
  let g:edge_style = 'neon'
  colorscheme edge
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#flatcolor() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'flatcolor'
  colorscheme flatcolor
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#forest_night() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'forest_night'
  let g:forest_night_enable_italic = 1
  colorscheme forest-night
  highlight! Normal guibg=#1C2C35
  highlight! LineNr guibg=#27373F guifg=#616C72
  highlight! CursorLineNr guifg=#48B2F0 guibg=#500904
  highlight! CursorLine guibg=#500904
  highlight! Pmenu guibg=#2C3C45
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#glacier() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'glacier'
  colorscheme glacier
  highlight! ColorColumn guibg=#21272D guifg=DarkRed
  highlight! Pmenu guibg=#23292F
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#gotham() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'gotham'
  colorscheme gotham
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#gruvbox() abort
  call frescoraja#initialize_theme()
  let g:gruvbox_contrast_dark = 'hard'
  let g:custom_themes_name = 'gruvbox'
  colorscheme gruvbox
  highlight! NonText ctermfg=12 guifg=#504945
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#gruvbox8() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'gruvbox8'
  colorscheme gruvbox8_soft
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#gruvbox_material() abort
  call frescoraja#initialize_theme()
  let g:gruvbox_material_enable_bold = 1
  let g:gruvbox_material_background='hard'
  let g:custom_themes_name = 'gruvbox_material'
  colorscheme gruvbox-material
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#gummybears() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'gummybears'
  colorscheme gummybears
  highlight! NonText guifg=#595950
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#hybrid_material() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'hybrid_material'
  colorscheme hybrid_material
  highlight! Normal guibg=#162228
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#hybrid_reverse() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'hybrid_reverse'
  colorscheme hybrid_reverse
  highlight! NonText guifg=#575B61
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#iceberg() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'iceberg'
  colorscheme iceberg
  highlight! NonText guifg=#575B68
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#iceberg_nogui() abort
  call frescoraja#initialize_theme(v:false)
  let g:custom_themes_name = 'iceberg_nogui'
  colorscheme iceberg
  highlight! NonText ctermfg=245
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#jellybeans() abort
  call frescoraja#initialize_theme()
  let g:jellybeans_use_term_italics = 1
  let g:custom_themes_name = 'jellybeans'
  colorscheme jellybeans
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#kafka() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'kafka'
  colorscheme kafka
  highlight! Pmenu guibg=#4E545F
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#kuroi() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'kuroi'
  colorscheme kuroi
  highlight! LineNr guifg=#575B61
  highlight! NonText guifg=#676B71
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#kuroi_nogui() abort
  call frescoraja#initialize_theme(v:false)
  let g:custom_themes_name = 'kuroi_nogui'
  colorscheme kuroi
  highlight! LineNr ctermfg=243
  highlight! NonText ctermfg=245
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#mango() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'mango'
  colorscheme mango
  highlight! Pmenu ctermbg=232 guibg=#1D1D1D
  highlight! NonText guifg=#5D5D5D
  highlight! Folded ctermbg=NONE guibg=NONE
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#maui() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'maui'
  colorscheme maui
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#material() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'material'
  colorscheme material
  highlight! Normal guibg=#162127 ctermbg=233
  highlight! Todo guibg=#000000 guifg=#BD9800 cterm=bold
  highlight! LineNr guifg=#56676E
  highlight! Folded guifg=#546D7A guibg=#121E20
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#material_theme() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'material_theme'
  colorscheme material-theme
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#vim_material() abort
  call frescoraja#initialize_theme()
  let g:material_style = 'dark'
  let g:custom_themes_name = 'vim_material'
  colorscheme vim-material
  highlight! ColorColumn guibg=#374349
  highlight! CursorLine cterm=NONE
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#vim_material_oceanic() abort
  call frescoraja#initialize_theme()
  let g:material_style = 'oceanic'
  let g:custom_themes_name = 'vim_material_oceanic'
  colorscheme vim-material
  highlight! CursorLine cterm=NONE
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#vim_material_palenight() abort
  call frescoraja#initialize_theme()
  let g:material_style = 'palenight'
  let g:custom_themes_name = 'vim_material_palenight'
  colorscheme vim-material
  highlight! TabLine guifg=#676E95 guibg=#191919
  highlight! TabLineFill guifg=#191919
  highlight! TabLineSel guifg=#FFE57F guibg=#676E95
  highlight! ColorColumn guibg=#3A3E4F
  highlight! CursorLine cterm=NONE
  highlight! Normal guibg=#191D2E
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#material_monokai() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'material_monokai'
  let g:materialmonokai_italic = 1
  let g:materialmonokai_custom_lint_indicators = 0
  colorscheme material-monokai
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#miramare() abort
  call frescoraja#initialize_theme()
  let g:miramare_transparent_background = 0
  let g:miramare_enable_italic = 1
  let g:miramare_cursor = 'blue'
  let g:miramare_current_word = 'bold'
  let g:custom_themes_name = 'miramare'
  colorscheme miramare
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#molokai() abort
  call frescoraja#initialize_theme()
  let g:molokai_original = 1
  let g:rehash256 = 1
  let g:custom_themes_name = 'molokai'
  colorscheme molokai
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#molokai_dark_nogui() abort
  call frescoraja#initialize_theme(v:false)
  let g:custom_themes_name = 'molokai_dark_nogui'
  colorscheme molokai_dark
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#nord() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'nord'
  colorscheme nord
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#plastic() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'plastic'
  colorscheme plastic
  highlight! Comment guifg=#7B828F
  highlight! CursorLine guifg=#8BB2DF
  highlight! CursorLineNr guifg=#FBC29F guibg=#51555B
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#pink_moon() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'pink_moon'
  colorscheme pink-moon
  highlight! NonText guifg=#344451
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#orange_moon() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'orange_moon'
  colorscheme orange-moon
  highlight! NonText guifg=#69666A
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#yellow_moon() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'yellow_moon'
  colorscheme yellow-moon
  highlight! NonText guifg=#69666A
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#neodark() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'neodark'
  colorscheme neodark
  highlight! Normal guibg=#0e1e27
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#neodark_nogui() abort
  call frescoraja#initialize_theme(v:false)
  let g:custom_themes_name = 'neodark_nogui'
  colorscheme neodark
  highlight! Normal ctermbg=233
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#night_owl() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'night_owl'
  colorscheme night-owl
  highlight! Folded guibg=#202000 guifg=#BFAF9F
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#oceanicnext() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'oceanicnext'
  colorscheme OceanicNext
  highlight! Normal guibg=#0E1E27
  highlight! LineNr guibg=#0E1E27
  highlight! Identifier guifg=#3590B1
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#oceanicnext2() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'oceanicnext2'
  colorscheme OceanicNext2
  highlight! LineNr guibg=#141E23
  highlight! CursorLineNr guifg=#72C7D1
  highlight! Identifier guifg=#4BB1A7
  highlight! PreProc guifg=#A688F6
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#one() abort
  call frescoraja#initialize_theme()
  let g:allow_one_italics = 1
  let g:custom_themes_name = 'one'
  colorscheme one
  highlight! NonText guifg=#61AFEF
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#onedark() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'onedark'
  colorscheme onedark
  highlight! NonText guifg=#D19A66
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#onedarkafterglow() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'onedarkafterglow'
  colorscheme onedarkafterglow
  highlight! NonText guifg=#4B80D8
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#petrel() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'petrel'
  colorscheme petrel
  highlight! Pmenu gui=NONE
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#quantum_light() abort
  call frescoraja#initialize_theme()
  let g:quantum_black = 0
  let g:custom_themes_name = 'quantum_light'
  colorscheme quantum
  highlight! LineNr guifg=#627782
  highlight! Folded guifg=#627782
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#quantum_dark() abort
  call frescoraja#initialize_theme()
  let g:quantum_black = 1
  let g:custom_themes_name = 'quantum_dark'
  colorscheme quantum
  highlight! LineNr guifg=#627782
  highlight! Folded guifg=#627782
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#spring_night() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'spring_night'
  colorscheme spring-night
  highlight! LineNr guifg=#767f89 guibg=#1d2d42
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#srcery() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'srcery'
  colorscheme srcery
  highlight! NonText gui=NONE guifg=#5C5B59
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#tender() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'tender'
  colorscheme tender
  highlight! Normal guibg=#1F1F1F
  highlight! LineNr guifg=#677889 guibg=#282828
  highlight! NonText guifg=#475869
  highlight! Pmenu guibg=#237EA4
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#thaumaturge() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'thaumaturge'
  colorscheme thaumaturge
  highlight ColorColumn guibg = #2C2936
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#tokyo_metro() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'tokyo_metro'
  colorscheme tokyo-metro
  highlight! NonText guifg=#646980
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#tomorrow_night() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'tomorrow_night'
  colorscheme Tomorrow-Night
  highlight! Normal guibg=#15191A
  highlight! LineNr guibg=#1F2223
  highlight! NonText guifg=#787878
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#two_firewatch() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'two_firewatch'
  colorscheme two-firewatch
  highlight! Normal guibg=#21252D
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#yowish() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'yowish'
  let g:yowish = {
        \ 'term_italic': 1,
        \ 'comment_italic': 1,
        \ }
  colorscheme yowish
  highlight! LineNr guifg=#555555
  highlight! NonText guifg=#757575
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#znake() abort
  call frescoraja#initialize_theme()
  let g:custom_themes_name = 'znake'
  colorscheme znake
  highlight! Normal guifg=#DCCFEE
  highlight! vimCommand guifg=#793A6A
  highlight! vimFuncKey guifg=#A91A7A cterm=bold
  highlight! Comment guifg=#5A5A69
  highlight! ColorColumn guibg=#331022 guifg=#A51F2B
  highlight! NonText guifg=#8A6044
  doautocmd User CustomizedTheme
endfunction
" }}} end Theme Definitions

" }}}

" Autoload commands {{{
command! -nargs=? -complete=customlist,frescoraja#get_custom_themes
      \ CustomizeTheme call frescoraja#customize_theme(<f-args>)
command! -nargs=+ -complete=customlist,frescoraja#get_syntax_groups
      \ ColorizeSyntaxGroup call frescoraja#colorize_group(<f-args>)
command! -bang -nargs=? -complete=customlist,frescoraja#get_syntax_groups
      \ Italicize call frescoraja#italicize(<bang>0, <f-args>)
command! -nargs=0 RefreshTheme call frescoraja#refresh_theme()
command! -bang -nargs=? SetTextwidth call frescoraja#set_textwidth(<bang>0, <args>)
command! -nargs=0 ToggleBackground call frescoraja#toggle_background_transparency()
command! -nargs=0 ToggleDark call frescoraja#toggle_dark()
command! -nargs=0 GetSyntaxGroup call frescoraja#get_syntax_highlighting_under_cursor()
command! -nargs=0 DefaultTheme call frescoraja#reload_default()
command! -nargs=0 ReloadThemes call frescoraja#load_custom_themes()
command! -nargs=0 ReloadColorschemes call frescoraja#load_colorschemes()
command! -nargs=0 PrevTheme call frescoraja#cycle_custom_theme(-1)
command! -nargs=0 NextTheme call frescoraja#cycle_custom_theme(1)
command! -nargs=0 RandomTheme call frescoraja#random()
command! -nargs=0 PrevColorscheme call frescoraja#cycle_colorschemes(-1)
command! -nargs=0 NextColorscheme call frescoraja#cycle_colorschemes(1)
" }}}

" Autogroup commands {{{
augroup custom_themes
  au!
  autocmd User CustomizedTheme call frescoraja#finalize_theme()
  autocmd ColorScheme * call frescoraja#colorscheme_changed()

  " JSONc/JSON5 syntax highlighting (comment support)
  autocmd BufRead coc-settings.json,.eslintrc call frescoraja#highlights#json()
augroup END
" }}} end autocmds

" vim: fdm=marker fmr={{{,}}} fen
