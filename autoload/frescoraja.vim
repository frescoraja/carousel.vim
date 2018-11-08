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

" colorscheme functions {{{

" Script functions {{{
  function! s:apply_ale_sign_highlights() abort
    let l:guibg=<SID>get_highlight_term('LineNr', 'guibg')
    let l:ctermbg=<SID>get_highlight_term('LineNr', 'ctermbg')
    highlight clear ALEErrorSign
    highlight clear ALEWarningSign
    highlight clear ALEInfoSign
    execute 'highlight! ALEErrorSign guifg=red ctermfg=red '.l:guibg.' '.l:ctermbg
    execute 'highlight! ALEWarningSign guifg=yellow ctermfg=yellow '.l:guibg.' '.l:ctermbg
    execute 'highlight! ALEInfoSign guifg=orange ctermfg=208 '.l:guibg.' '.l:ctermbg
 endfunction

  function! s:apply_gitgutter_highlights() abort
    let l:guibg=<SID>get_highlight_term('LineNr', 'guibg')
    let l:ctermbg=<SID>get_highlight_term('LineNr', 'ctermbg')
    highlight clear GitGutterAdd
    highlight clear GitGutterChange
    highlight clear GitGutterDelete
    highlight clear GitGutterChangeDelete
    execute 'highlight! GitGutterAdd cterm=bold guifg=#53D188 ctermfg=36 '.l:guibg.' '.l:ctermbg
    execute 'highlight! GitGutterChange cterm=bold guifg=#FFF496 ctermfg=226 '.l:guibg.' '.l:ctermbg
    execute 'highlight! GitGutterDelete cterm=bold guifg=#BF304F ctermfg=205 '.l:guibg.' '.l:ctermbg
    execute 'highlight! GitGutterChangeDelete cterm=bold guifg=#F18F4A ctermfg=208 '.l:guibg.' '.l:ctermbg
  endfunction

  function! s:apply_signcolumn_highlights() abort
    highlight! link SignColumn LineNr
  endfunction

  function! s:apply_whitespace_highlights() abort
    highlight clear ExtraWhitespace
    highlight! ExtraWhitespace cterm=undercurl ctermfg=red guifg=#d32303
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
  endfunction

  function! s:colorscheme_changed() abort
    call <SID>cache_settings()
    if exists(':AirlineRefresh')
      AirlineRefresh
    endif
  endfunction

  function! s:cycle_custom_theme(step) abort
    if !exists('s:loaded_custom_themes')
      call <SID>load_custom_themes()
    endif
    if !exists('s:custom_themes_index')
      let s:custom_themes_index=0
    else
      let s:custom_themes_index=(s:custom_themes_index+a:step)%len(s:loaded_custom_themes)
    endif
    let l:next_theme=s:loaded_custom_themes[s:custom_themes_index]
    execute 'call frescoraja#'.l:next_theme.'()'
  endfunction

  function! s:cycle_colorschemes(step) abort
    if !exists('s:loaded_colorschemes')
      call <SID>load_colorschemes()
    endif
    if !exists('s:colorscheme_index')
      let s:colorscheme_index=0
    else
      let s:colorscheme_index=(s:colorscheme_index+a:step)%len(s:loaded_colorschemes)
    endif
    execute 'colorscheme '.s:loaded_colorschemes[s:colorscheme_index]
  endfunction

  function! s:cache_settings() abort
    if !exists('s:loaded_custom_themes')
      call <SID>load_custom_themes()
    endif
    if !exists('s:loaded_colorschemes')
      call <SID>load_colorschemes()
    endif
    if exists('g:custom_themes_name')
      let s:custom_themes_index=index(s:loaded_custom_themes, g:custom_themes_name)
    endif
    if exists('g:colors_name')
      let s:colorscheme_index=index(s:loaded_colorschemes, g:colors_name)
    endif
    let l:term=&termguicolors ? 'guibg' : 'ctermbg'
    let s:cached_bg=<SID>get_highlight_term_value('Normal', l:term)
  endfunction

  function! s:apply_consistent_bg() abort
    call <SID>apply_signcolumn_highlights()
    call <SID>apply_ale_sign_highlights()
    call <SID>apply_gitgutter_highlights()
    call <SID>apply_whitespace_highlights()
  endfunction

  function! s:finalize_theme() abort
    call <SID>cache_settings()
    call <SID>italicize()
    call <SID>fix_reset_highlighting()
    call <SID>apply_consistent_bg()
  endfunction

  function! s:fix_reset_highlighting() abort
    " TODO: find broken highlights after switching themes
    if get(g:, 'colors_name', '')=~#'maui'
        highlight! link vimCommand Statement
    endif
  endfunction

  function! s:get_highlight_term_value(group, term) abort
    try
      let l:output=execute('highlight '.a:group)
      if l:output=~?'links'
        let l:link=matchstr(l:output, 'links to \zs\S\+')
        let l:output=<SID>get_highlight_term_value(l:link, a:term)
      endif
      let l:value=matchstr(l:output, a:term.'=\zs\S*')
      return empty(l:value) ? 'NONE' : l:value
    catch
      return 'NONE'
    endtry
  endfunction

  function! s:get_highlight_term(group, term) abort
    try
      let l:output=execute('highlight '.a:group)
      if l:output=~?'links'
        let l:link=matchstr(l:output, 'links to \zs\S\+')
        let l:output=<SID>get_highlight_term(l:link, a:term)
      endif
      let l:term=matchstr(l:output, '\zs'.a:term.'=\S\+')
      return empty(l:term) ? '' : l:term
    catch
      return ''
    endtry
  endfunction

  function! s:get_syntax_highlighting_under_cursor() abort
      let l:s=synID(line('.'), col('.'), 1)
      let l:syntax_group=synIDattr(l:s, 'name')
      if (empty(l:syntax_group))
        let l:current_word=expand('<cword>')
        echohl ErrorMsg |
              \ echo 'No syntax group defined for "'.l:current_word.'"'
      else
        let l:linked_syntax_group=synIDattr(synIDtrans(l:s), 'name')
        execute 'echohl '.l:syntax_group
        echo l:syntax_group.' => '.l:linked_syntax_group
      endif
  endfunction

  function! s:italicize(...) abort
    if exists('a:2')
      let l:groups=split(a:2, ',')
    else
      let l:groups=['Comment', 'htmlArg', 'WildMenu']
    endif
    let l:bang=get(a:, 1, 0)
    if (l:bang)
      for group in l:groups
        let l:cterm=<SID>get_highlight_term_value(group, 'cterm')
        if l:cterm=~?'italic'
          let l:new_cterms=filter(split(l:cterm, ','), 'v:val !~? "italic"')
          if len(l:new_cterms)
            let l:new_cterm=join(l:new_cterms, ',')
            execute 'highlight '.group.' cterm='.l:new_cterm
          else
            execute 'highlight '.group.' cterm=NONE'
          endif
        else
          let l:new_cterms=join(add(split(l:cterm, ','), 'italic'), ',')
          execute 'highlight '.group.' cterm='.l:new_cterms
        endif
      endfor
    else
      for group in l:groups
        let l:cterm=<SID>get_highlight_term_value(group, 'cterm')
        let l:new_cterms=join(add(split(l:cterm, ','), 'italic'), ',')
        execute 'highlight '.group.' cterm='.l:new_cterms
      endfor
    endif
  endfunction

  function! s:refresh_theme() abort
    let l:theme=get(g:, 'custom_themes_name', '')
    if !empty(l:theme)
      execute 'call frescoraja#'.l:theme.'()'
    endif
  endfunction

  function! s:shape_cursor() abort
    if &term=~?'^\(xterm\)\|\(rxvt\)'
      call <SID>shape_cursor_normal(1)
      call <SID>shape_cursor_insert(5)
      call <SID>shape_cursor_replace(3)
    endif
  endfunction

  function! s:shape_cursor_normal(shape) abort
    let &t_EI="\<Esc>[".a:shape.' q'
  endfunction

  function! s:shape_cursor_insert(shape) abort
    let &t_SI="\<Esc>[".a:shape.' q'
  endfunction

  function! s:shape_cursor_replace(shape) abort
    let &t_SR="\<Esc>[".a:shape.' q'
  endfunction

  function! s:toggle_dark() abort
    if (&background==?'light')
      set background=dark
    else
      set background=light
    endif
  endfunction

  function! s:toggle_background_transparency() abort
    let l:term=&termguicolors==0 ? 'ctermbg' : 'guibg'
    let l:current_bg=<SID>get_highlight_term_value('Normal', l:term)
    if (l:current_bg!=?'NONE')
      let s:cached_bg=l:current_bg
      highlight Normal guibg=NONE ctermbg=NONE
      highlight LineNr guibg=NONE ctermbg=NONE
    else
      let l:bg=get(s:, 'cached_bg', '')
      " if no bg was cached or cached bg is 'none', use default dark settings
      " if termguicolors was changed, cached bg may be invalid, use default dark settings
      if empty(l:bg) || (l:bg==?'none')
        highlight Normal ctermbg=233 guibg=#0f0f0f
        highlight LineNr ctermbg=234 ctermfg=yellow guibg=#1d1d1d guifg=#ff8e00
      else
        execute 'highlight Normal '.l:term.'='.l:bg
      endif
    endif
    call <SID>apply_consistent_bg()
  endfunction

  function! s:toggle_column() abort
    if (&colorcolumn>0)
      set colorcolumn=0
    else
      execute 'set colorcolumn='.string(&textwidth)
    endif
  endfunction

  function! s:toggle_textwidth(num) abort
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
  endfunction

  " Custom completion for CustomizeTheme command {{{
    function! s:get_custom_themes(a, l, p) abort
      if !exists('s:loaded_custom_themes')
        call <SID>load_custom_themes()
      endif
      return filter(copy(s:loaded_custom_themes), 'v:val =~? "'.a:a.'"')
    endfunction

    function! s:customize_theme(...) abort
      try
        if a:0
          execute 'call frescoraja#'.a:1.'()'
        else
          echohl ModeMsg | echo g:custom_themes_name
        endif
      catch /.*/
        echohl ErrorMsg | echo v:exception
      endtry
    endfunction

    function! s:shorten_fn_name(idx, fn_name) abort
      return matchstr(a:fn_name, '#\zs\w\+')
    endfunction
    " }}}

    " Initializer helpers {{{
    function! s:load_custom_themes() abort
      let l:themes=sort(map(
        \ globpath(&runtimepath, 'colors/*.vim', 0, 1),
        \ 'fnamemodify(v:val, ":t:r")'))
      let l:functions=map(filter(split(
        \ execute('function'), "\n"),
        \ 'v:val =~? "frescoraja"'),
        \ function('<SID>shorten_fn_name'))
      let l:custom_themes=[]
      for fname in l:themes
        let l:name=substitute(tolower(fname), '-', '_', 'g')
        let l:matching_fns=filter(copy(l:functions), 'v:val =~? "'.l:name.'"')
        let l:custom_themes+=l:matching_fns
      endfor
      let s:loaded_custom_themes=uniq(sort(l:custom_themes))
    endfunction

    function! s:load_colorschemes() abort
      let s:loaded_colorschemes=uniq(sort(map(
        \ globpath(&runtimepath, 'colors/*.vim', 0, 1),
        \ 'fnamemodify(v:val, ":t:r")')))
    endfunction
  " }}}
" }}}

" Theme functions {{{
function! frescoraja#init() abort
  call <SID>load_custom_themes()
  let l:theme=get(g:, 'custom_themes_name', '')
  if !empty(l:theme)
    execute 'call frescoraja#'.l:theme.'()'
  endif
endfunction

function! frescoraja#default() abort
  set background=dark
  let g:airline_theme='jellybeans'
  let g:custom_themes_name='default'

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
  call <SID>colorize_column()
  call <SID>colorize_comments()
endfunction

function! frescoraja#afterglow() abort
  set termguicolors
  let g:custom_themes_name='afterglow'
  let g:airline_theme='afterglow'
  colorscheme afterglow
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#ayu() abort
  set termguicolors
  let g:ayucolor='dark'
  let g:custom_themes_name='ayu'
  let g:airline_theme='ayu'
  colorscheme ayu
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#ayu_mirage() abort
  set termguicolors
  let g:ayucolor='mirage'
  let g:custom_themes_name='ayu_mirage'
  let g:airline_theme='ayu_mirage'
  colorscheme ayu
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#blayu() abort
  set termguicolors
  let g:custom_themes_name='blayu'
  let g:airline_theme='gotham'
  colorscheme blayu
  highlight! CursorLine guifg=#32C6B9
  highlight! ColorColumn guibg=#2A3D4F
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#busybee() abort
  set notermguicolors
  let g:custom_themes_name='busybee'
  let g:airline_theme='qwq'
  colorscheme busybee
  highlight! LineNr guifg=#505050 guibg=#101010
  highlight! CursorLineNr guifg=#ff9800 guibg=#202020
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#ceudah() abort
  set termguicolors
  let g:custom_themes_name='ceudah'
  let g:airline_theme='quantum'
  colorscheme ceudah
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#chito() abort
  set termguicolors
  let g:custom_themes_name='chito'
  let g:airline_theme='quantum'
  colorscheme chito
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#colorsbox_stnight() abort
  set termguicolors
  let g:custom_themes_name='colorsbox_stnight'
  let g:airline_theme='afterglow'
  colorscheme colorsbox-stnight
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#colorsbox_steighties() abort
  set termguicolors
  let g:custom_themes_name='colorsbox_steighties'
  let g:airline_theme='quantum'
  colorscheme colorsbox-steighties
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#dark() abort
  set termguicolors
  let g:custom_themes_name='dark'
  let g:airline_theme='sierra'
  colorscheme dark
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#deus() abort
  set termguicolors
  let g:custom_themes_name='deus'
  let g:airline_theme='deus'
  colorscheme deus
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#distill() abort
  set termguicolors
  let g:custom_themes_name='distill'
  let g:airline_theme='jellybeans'
  colorscheme distill
  highlight! ColorColumn guibg=#16181d
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#dracula() abort
  set termguicolors
  let g:custom_themes_name='dracula'
  let g:airline_theme='dracula'
  colorscheme dracula
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#edar() abort
  set termguicolors
  let g:custom_themes_name='edar'
  let g:airline_theme='lucius'
  colorscheme edar
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#flatcolor() abort
  set termguicolors
  let g:custom_themes_name='flatcolor'
  let g:airline_theme='base16_nord'
  colorscheme flatcolor
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#gotham() abort
  set termguicolors
  let g:custom_themes_name='gotham'
  let g:airline_theme='gotham256'
  colorscheme gotham
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#gruvbox() abort
  set termguicolors
  let g:gruvbox_contrast_dark='hard'
  let g:custom_themes_name='gruvbox'
  let g:airline_theme='gruvbox'
  colorscheme gruvbox
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#heroku_gvim() abort
  set termguicolors
  let g:custom_themes_name='heroku_gvim'
  let g:airline_theme='material'
  colorscheme herokudoc-gvim
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#hybrid_material() abort
  set termguicolors
  let g:custom_themes_name='hybrid_material'
  let g:airline_theme='hybrid'
  colorscheme hybrid_material
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#hybrid_material_nogui() abort
  set notermguicolors
  let g:custom_themes_name='hybrid_material_nogui'
  let g:airline_theme='hybrid'
  colorscheme hybrid_material
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#iceberg() abort
  set termguicolors
  let g:custom_themes_name='iceberg'
  let g:airline_theme='iceberg'
  colorscheme iceberg
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#iceberg_nogui() abort
  set notermguicolors
  let g:custom_themes_name='iceberg_nogui'
  let g:airline_theme='solarized'
  colorscheme iceberg
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#jellybeans() abort
  set termguicolors
  let g:jellybeans_use_term_italics=1
  let g:custom_themes_name='jellybeans'
  let g:airline_theme='jellybeans'
  colorscheme jellybeans
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#jumper() abort
  set termguicolors
  let g:custom_themes_name='jumper'
  let g:airline_theme='base16'
  colorscheme jumper-contrast
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#kafka() abort
  set termguicolors
  let g:custom_themes_name='kafka'
  let g:airline_theme='neodark'
  colorscheme kafka
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#legacy() abort
  set termguicolors
  let g:custom_themes_name='legacy'
  let g:airline_theme='ayu'
  colorscheme legacy
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#legacy_dark() abort
  set termguicolors
  let g:custom_themes_name='legacy_dark'
  let g:airline_theme='zenburn'
  colorscheme legacy-contrast
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#maui() abort
  set termguicolors
  let g:custom_themes_name='maui'
  let g:airline_theme='jellybeans'
  colorscheme maui
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#material() abort
  set termguicolors
  let g:custom_themes_name='material'
  let g:airline_theme='material'
  colorscheme material
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#material_dark() abort
  set termguicolors
  let g:custom_themes_name='material_dark'
  let g:airline_theme='materialmonokai'
  colorscheme material
  highlight! Normal guibg=#162127 ctermbg=233
  highlight! Todo guibg=#000000 guifg=#BD9800 cterm=bold
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#vim_material() abort
  set termguicolors
  let g:material_style='dark'
  let g:custom_themes_name='vim_material'
  let g:airline_theme='material'
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
  let g:material_style='oceanic'
  let g:custom_themes_name='vim_material_oceanic'
  let g:airline_theme='material'
  colorscheme vim-material
  highlight! CursorLine cterm=NONE
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#vim_material_palenight() abort
  set termguicolors
  let g:material_style='palenight'
  let g:custom_themes_name='vim_material_palenight'
  let g:airline_theme='material'
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
  let g:custom_themes_name='material_theme'
  let g:airline_theme='material'
  colorscheme material-theme
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#molokai() abort
  set termguicolors
  let g:molokai_original=1
  let g:rehash256=1
  let g:custom_themes_name='molokai'
  let g:airline_theme='molokai'
  colorscheme molokai
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#molokai_dark_nogui() abort
  set notermguicolors
  let g:custom_themes_name='molokai_dark_nogui'
  let g:airline_theme='molokai'
  colorscheme molokai_dark
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#pink_moon() abort
  set termguicolors
  let g:custom_themes_name='pink_moon'
  let g:airline_theme='lucius'
  colorscheme pink-moon
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#orange_moon() abort
  set termguicolors
  let g:custom_themes_name='orange_moon'
  let g:airline_theme='lucius'
  colorscheme orange-moon
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#yellow_moon() abort
  set termguicolors
  let g:custom_themes_name='yellow_moon'
  let g:airline_theme='lucius'
  colorscheme yellow-moon
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#neodark() abort
  set termguicolors
  let g:custom_themes_name='neodark'
  let g:airline_theme='neodark'
  colorscheme neodark
  highlight! Normal guibg=#0e1e27
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#neodark_nogui() abort
  set notermguicolors
  let g:custom_themes_name='neodark_nogui'
  let g:airline_theme='neodark'
  colorscheme neodark
  highlight! Normal ctermbg=233
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#oceanicnext() abort
  set termguicolors
  let g:custom_themes_name='oceanicnext'
  let g:airline_theme='oceanicnext'
  colorscheme OceanicNext
  highlight! Normal guibg=#0E1E27
  highlight! LineNr guibg=#0E1E27
  highlight! Identifier guifg=#3590B1
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#oceanicnext2() abort
  set termguicolors
  let g:custom_themes_name='oceanicnext2'
  let g:airline_theme='oceanicnext'
  colorscheme OceanicNext2
  highlight! LineNr guibg=#141E23
  highlight! CursorLineNr guifg=#72C7D1
  highlight! Identifier guifg=#4BB1A7
  highlight! PreProc guifg=#A688F6
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#onedark() abort
  set termguicolors
  let g:custom_themes_name='onedark'
  let g:airline_theme='onedark'
  colorscheme onedark
  highlight! Normal guibg=#20242C
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#quantum_light() abort
  set termguicolors
  let g:quantum_black=0
  let g:custom_themes_name='quantum_light'
  let g:airline_theme='deus'
  colorscheme quantum
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#quantum_dark() abort
  set termguicolors
  let g:quantum_black=1
  let g:custom_themes_name='quantum_dark'
  let g:airline_theme='murmur'
  colorscheme quantum
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#spring_night() abort
  set termguicolors
  let g:custom_themes_name='spring_night'
  let g:airline_theme='spring_night'
  colorscheme spring-night
  highlight! LineNr guifg=#767f89 guibg=#1d2d42
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#srcery() abort
  set termguicolors
  let g:custom_themes_name='srcery'
  let g:airline_theme='srcery'
  colorscheme srcery
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#tender() abort
  set termguicolors
  let g:custom_themes_name='tender'
  let g:airline_theme='tender'
  colorscheme tender
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#tetra() abort
  set termguicolors
  let g:custom_themes_name='tetra'
  let g:airline_theme='badcat'
  colorscheme tetra-contrast
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#thaumaturge() abort
  set termguicolors
  let g:custom_themes_name='thaumaturge'
  let g:airline_theme='violet'
  colorscheme thaumaturge
  highlight ColorColumn guibg=#2c2936
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#zacks() abort
  set termguicolors
  let g:custom_themes_name='zacks'
  let g:airline_theme='biogoo'
  colorscheme zacks-contrast
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#znake() abort
  set termguicolors
  let g:airline_theme='lucius'
  let g:custom_themes_name='znake'
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
command! -nargs=0 CustomThemeRefresh call <SID>refresh_theme()
command! -nargs=1 SetTextwidth call <SID>toggle_textwidth(<args>)
command! -nargs=? ColorizeColumn call <SID>colorize_column(<args>)
command! -nargs=? ColorizeComments call <SID>colorize_comments(<args>)
command! -nargs=0 ToggleColumn call <SID>toggle_column()
command! -nargs=0 ToggleBackground call <SID>toggle_background_transparency()
command! -nargs=0 ToggleDark call <SID>toggle_dark()
command! -bang -nargs=? Italicize call <SID>italicize(<bang>0, <f-args>)
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

if (g:custom_cursors_enabled)
  autocmd custom_themes VimEnter * call <SID>shape_cursor()
endif
" }}} end autocmds

" vim: fdm=marker fmr={{{,}}} fen
