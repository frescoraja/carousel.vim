set encoding=utf-8
scriptencoding utf-8

" Script Variables {{{

" determine if inside tmux or Apple Terminal for proper escape sequences (used in shape_cursor functions)
let s:inside_tmux = exists('$TMUX')
let s:inside_terminal = $TERM_PROGRAM ==? 'Apple_Terminal'

" theme -> airline theme mapping (only necessary if airline theme name != colorscheme name
let s:airline_theme_mapping = {
      \ 'apply': function('carousel#apply_airline_theme'),
      \ 'default': 'jellybeans',
      \ 'allomancer': 'hybrid',
      \ 'allomancer_nogui': 'hybridline',
      \ 'apprentice': 'jellybeans',
      \ 'candid': 'base16_nord',
      \ 'ceudah': 'quantum',
      \ 'chito': 'quantum',
      \ 'colorsbox_stnight': 'base16',
      \ 'colorsbox_steighties': 'quantum',
      \ 'dark': 'dark_minimal',
      \ 'distill': 'iceberg',
      \ 'edar': 'lucius',
      \ 'flatcolor': 'base16_nord',
      \ 'glacier': 'zenburn',
      \ 'gotham': 'gotham256',
      \ 'gruvbox8': 'gruvbox',
      \ 'gruvbox8_soft': 'gruvbox',
      \ 'gruvbox_hard': 'gruvbox',
      \ 'gruvbox_material_hard': 'gruvbox_material',
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

" Common {{{
function! carousel#apply_airline_theme(theme_name) dict abort
  try
    let g:airline_theme = has_key(l:self, a:theme_name) ? l:self[a:theme_name] : a:theme_name
    AirlineRefresh
  catch
    echohl WarningMsg | echomsg 'airline theme reload attempted but failed: ' . v:exception | echohl None
  endtry
endfunction

function! carousel#apply_highlights() abort
  let l:guibg = carousel#get_highlight_attr('LineNr', 'bg', 'gui')
  let l:ctermbg = carousel#get_highlight_attr('LineNr', 'bg', 'cterm')
  if get(g:, 'carousel_ale_highlights', 1)
    call carousel#highlights#ale(l:guibg, l:ctermbg)
  endif
  if get (g:, 'carousel_coc_highlights', 1)
    call carousel#highlights#coc(l:guibg, l:ctermbg)
    call carousel#highlights#gitgutter(l:guibg, l:ctermbg)
  endif
  if get(g:, 'carousel_extra_whitespace_highlights', 1)
    call carousel#highlights#whitespace()
  endif
  call carousel#highlights#syntax()
endfunction

function! carousel#cache_custom_theme_settings() abort
  if !exists('g:carousel_cache.themes')
    call carousel#load_carousel()
  endif
  let g:carousel_index = index(g:carousel_cache.themes, g:carousel_theme_name)
  let g:carousel_cache.bg.gui = carousel#get_highlight_attr('Normal', 'bg', 'gui')
  let g:carousel_cache.bg.cterm = carousel#get_highlight_attr('Normal', 'bg', 'cterm')
endfunction

function! carousel#colorize_group(...) abort
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

function! carousel#load(...) abort
  try
    if a:0
      execute 'call carousel#themes#' . a:1 . '()'
    else
      echohl WarningMsg | echomsg g:carousel_theme_name | echohl None
    endif
  catch
    echohl ErrorMsg | echomsg 'Carousel theme could not be found' | echohl None
  endtry
endfunction

function! carousel#cycle_colorschemes(step) abort
  if !exists('g:carousel_cache.colorschemes')
    call carousel#load_colorschemes()
  endif
  if !exists('g:colorscheme_index')
    let g:colorscheme_index = 0
  else
    let g:colorscheme_index = (g:colorscheme_index + a:step) % len(g:carousel_cache.colorschemes)
  endif
  execute 'colorscheme ' . g:carousel_cache.colorschemes[g:colorscheme_index]
endfunction

function! carousel#cycle_custom_theme(step) abort
  if !exists('g:carousel_cache.themes')
    call carousel#load_carousel()
  endif
  if !exists('g:carousel_index')
    let g:carousel_index = 0
  else
    let g:carousel_index = (g:carousel_index + a:step) % len(g:carousel_cache.themes)
  endif
  let l:next_theme = g:carousel_cache.themes[g:carousel_index]
  execute 'call carousel#themes#' . l:next_theme . '()'
endfunction

function! carousel#initialize_theme(...) abort
  " reset all highlight groups to defaults
  highlight clear
  " default to termguicolors, if any arg provided notermguicolors
  if a:0 > 0
    set notermguicolors
  else
    set termguicolors
  endif
endfunction

function! carousel#finalize_theme() abort
  call carousel#cache_custom_theme_settings()
  call carousel#italicize()
  call carousel#apply_highlights()
  call s:airline_theme_mapping.apply(g:carousel_theme_name)
  echohl WarningMsg | echomsg 'loaded theme:' g:carousel_theme_name | echohl None
endfunction

function! carousel#get_highlight_attr(group, term, mode) abort
  return synIDattr(synIDtrans(hlID(a:group)), a:term, a:mode)
endfunction

function! carousel#get_highlight_value(group, term) abort
   try
    return matchstr(execute('highlight ' . a:group), a:term . '=\zs\S\+')
  catch
    return ''
  endtry
endfunction

function! carousel#get_syntax_highlighting_under_cursor() abort
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

function! carousel#enable_italics() abort
  set t_ZH=[3m
  set t_ZR=[23m
endfunction

function! carousel#italicize(...) abort
  try
    let l:type = &termguicolors ? 'gui' : 'cterm'
    let l:groups = split(
          \ get(a:, 2, 'Comment,htmlArg'),
          \ ',')
    for l:group in l:groups
      let l:modes = carousel#get_highlight_value(l:group, l:type)
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

function! carousel#reload_default() abort
   execute 'call carousel#themes#' . g:carousel_cache.default_theme . '()'
endfunction

function! carousel#refresh_theme() abort
  let l:theme = get(g:, 'carousel_theme_name', '')
  if !empty(l:theme)
    execute 'call carousel#themes#' . l:theme . '()'
  else
    execute 'call carousel#themes#default()'
  endif
endfunction

function! carousel#TmuxEscape(seq) abort
  let l:tmux_start = "\<Esc>Ptmux;\<Esc>"
  let l:tmux_end   = "\<Esc>\\"

  return l:tmux_start . l:seq . l:tmux_end
endfunction

function! carousel#shape_cursor() abort
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
    let l:normal_cursor  = carousel#TmuxEscape(l:normal_cursor)
    let l:insert_cursor  = carousel#TmuxEscape(l:insert_cursor)
    let l:replace_cursor = carousel#TmuxEscape(l:replace_cursor)
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

function! carousel#toggle_dark() abort
  if &background ==? 'light'
    set background=dark
  else
    set background=light
  endif
endfunction

function! carousel#toggle_background_transparency() abort
  let l:term = &termguicolors == 0 ? 'cterm' : 'gui'
  let l:current_bg = carousel#get_highlight_attr('Normal', 'bg', l:term)
  if empty(l:current_bg)
    " if no bg was cached (or bg was not set) use default dark settings
    " if termguicolors was changed, cached bg may be invalid, use default dark settings
    if empty(g:carousel_cache.bg[l:term])
      if l:term ==? 'gui' | let g:carousel_cache.bg.gui = '#0D0D0D' | endif
      if l:term ==? 'cterm' | let g:carousel_cache.bg.cterm = 233 | endif
    endif

    execute 'highlight Normal ' . l:term . 'bg=' . g:carousel_cache.bg[l:term]
  else
    let g:carousel_cache.bg[l:term] = l:current_bg
    highlight Normal guibg=NONE ctermbg=NONE
    highlight LineNr guibg=NONE ctermbg=NONE
    highlight VertSplit guibg=NONE ctermbg=NONE
    highlight NonText guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  endif
  call carousel#apply_highlights()
endfunction

function! carousel#set_textwidth(bang, ...) abort
  try
    if a:bang && &textwidth
      let g:carousel_cache.textwidth = &textwidth
      setlocal textwidth=0
      setlocal colorcolumn=0
    else
      if exists('a:1')
        let l:new_textwidth = a:1
      elseif exists('g:carousel_cache.textwidth')
        let l:new_textwidth = g:carousel_cache.textwidth
      else
        let l:new_textwidth = 80
      endif
      execute 'setlocal textwidth=' . l:new_textwidth
      execute 'setlocal colorcolumn=' . l:new_textwidth
      let g:carousel_cache.textwidth = l:new_textwidth
    endif
  catch
    echohl ErrorMsg | echomsg v:exception | echohl None
  endtry
endfunction
" }}}

" Custom completion {{{
function! carousel#filter(a, ...) abort
  if !exists('g:carousel_cache.themes')
    call carousel#load_carousel()
  endif

  return filter(copy(g:carousel_cache.themes), 'v:val =~? "' . a:a . '"')
endfunction

function! carousel#get_syntax_groups(a, ...) abort
  return filter(
        \ map(
        \ split(
        \ execute('highlight'), "\n"),
        \ 'matchstr(v:val, ''^\S\+'')'),
        \ 'v:val =~? "' . a:a . '"')
endfunction

function! carousel#list() abort
  if !exists('g:carousel_cache.themes')
    call carousel#load_carousel()
  endif

  return copy(g:carousel_cache.themes)
endfunction
" }}}

" Initialization {{{
function! carousel#load_carousel() abort
  let g:carousel_cache.themes = sort(map(filter(split(
    \ execute('function'), "\n"),
    \ 'v:val =~? "carousel#themes#"'),
    \ 'matchstr(v:val, ''#themes#\zs\w\+'')'))
endfunction

function! carousel#load_colorschemes() abort
  let g:carousel_cache.colorschemes = uniq(sort(map(
    \ globpath(&runtimepath, 'colors/*.vim', 0, 1),
    \ 'fnamemodify(v:val, ":t:r")')))
endfunction

function! carousel#init() abort
  let g:carousel_cache = {
        \ 'bg': {},
        \ 'default_theme': get(g:, 'carousel_theme_name', 'default'),
        \ }

  call carousel#load_carousel()
  call carousel#load_colorschemes()

  if get(g:, 'carousel_italics_enabled', 0)
    call carousel#enable_italics()
  endif

  if get(g:, 'carousel_cursors_enabled', 0)
    call carousel#shape_cursor()
  endif

  execute 'call carousel#themes#' . g:carousel_cache.default_theme . '()'
endfunction
" }}}


" Autoload commands {{{
command! -nargs=? -complete=customlist,carousel#filter
      \ Carousel call carousel#load(<f-args>)
command! -nargs=+ -complete=customlist,carousel#get_syntax_groups
      \ ColorizeSyntaxGroup call carousel#colorize_group(<f-args>)
command! -bang -nargs=? -complete=customlist,carousel#get_syntax_groups
      \ Italicize call carousel#italicize(<bang>0, <f-args>)
command! -nargs=0 CarouselRefresh call carousel#refresh_theme()
command! -bang -nargs=? SetTextwidth call carousel#set_textwidth(<bang>0, <args>)
command! -nargs=0 ToggleBackground call carousel#toggle_background_transparency()
command! -nargs=0 ToggleDark call carousel#toggle_dark()
command! -nargs=0 GetSyntaxGroup call carousel#get_syntax_highlighting_under_cursor()
command! -nargs=0 CarouselDefault call carousel#reload_default()
command! -nargs=0 CarouselReload call carousel#load_carousel()
command! -nargs=0 ColorschemesReload call carousel#load_colorschemes()
command! -nargs=0 CarouselPrev call carousel#cycle_custom_theme(-1)
command! -nargs=0 CarouselNext call carousel#cycle_custom_theme(1)
command! -nargs=0 CarouselRandom call carousel#themes#random()
command! -nargs=0 ColorschemePrev call carousel#cycle_colorschemes(-1)
command! -nargs=0 ColorschemeNext call carousel#cycle_colorschemes(1)
" }}}

" Autogroup commands {{{
augroup carousel
  au!
  autocmd User CustomizedTheme call carousel#finalize_theme()

  " JSONc/JSON5 syntax highlighting (comment support)
  autocmd BufRead coc-settings.json,.eslintrc call carousel#highlights#json()
augroup END
" }}} end autocmds
" }}} end Plugin functions

" vim: fdm=marker fmr={{{,}}} fen sw=2 sts=2 ts=2 et
