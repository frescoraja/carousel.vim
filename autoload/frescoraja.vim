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

" colorscheme function mappings {{{

" Script functions {{{
  function! s:apply_airline_theme() abort
    let g:airline_theme=get(g:, 'airline_theme', g:default_airline_theme)
    if exists(':AirlineTheme')
      execute ':AirlineTheme '.g:airline_theme
    endif
  endfunction

  function! s:apply_ale_sign_highlights() abort
    highlight clear ALEErrorSign
    highlight clear ALEWarningSign
    highlight clear ALEInfoSign
    highlight! ALEErrorSign guifg=red ctermfg=red
    highlight! ALEWarningSign guifg=yellow ctermfg=yellow
    highlight! ALEInfoSign guifg=orange ctermfg=208
 endfunction

  function! s:apply_gitgutter_highlights() abort
    highlight clear GitGutterAdd
    highlight clear GitGutterChange
    highlight clear GitGutterDelete
    highlight clear GitGutterChangeDelete
    highlight! GitGutterAdd guifg=#53D188 ctermfg=36
    highlight! GitGutterChange guifg=#FFF496 ctermfg=226
    highlight! GitGutterDelete guifg=#BF304F ctermfg=205
    highlight! GitGutterChangeDelete guifg=#F18F4A ctermfg=208
  endfunction

  function! s:apply_signcolumn_highlights() abort
    highlight clear SignColumn
    highlight SignColumn ctermfg=white guifg=white
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

  function! s:cycle_custom_theme(direction) abort
    let l:theme_index=index(s:theme_list, g:custom_themes_name)
    if a:direction==-1 && l:theme_index==-1
      let l:next_theme_index=len(s:theme_list)-1
    else
      let l:next_theme_index=(l:theme_index+a:direction)%len(s:theme_list)
    endif
    let l:next_theme=s:theme_list[l:next_theme_index]
    execute 'call frescoraja#'.l:next_theme.'()'
  endfunction

  function! s:finalize_theme(...) abort
    let l:no_italics=get(a:, 1, 0)
    if !l:no_italics
      call <SID>italicize()
    endif
    call <SID>apply_signcolumn_highlights()
    call <SID>apply_airline_theme()
    call <SID>apply_ale_sign_highlights()
    call <SID>apply_gitgutter_highlights()
    call <SID>apply_whitespace_highlights()
    call <SID>fix_reset_highlighting()
  endfunction

  function! s:fix_reset_highlighting() abort
    " TODO: find broken highlights after switching themes
    if g:custom_themes_name=~#'maui'
        highlight! link vimCommand Statement
    endif
  endfunction

  function! s:get_highlight_term(group, term) abort
    try
      let output=execute('highlight '.a:group)
      return matchstr(output, a:term.'=\zs\S*')
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
        let l:cterm=<SID>get_highlight_term(group, 'cterm')
        if l:cterm=~?'italic'
          let l:new_cterms=filter(split(l:cterm, ','), 'v:val !~? "italic"')
          if len(l:new_cterms)
            let l:new_cterm=join(l:new_cterms, ',')
            execute 'highlight '.group.' cterm='.l:new_cterm
          else
            execute 'highlight '.group.' cterm=none'
          endif
        else
          let l:new_cterms=join(add(split(l:cterm, ','), 'italic'), ',')
          execute 'highlight '.group.' cterm='.l:new_cterms
        endif
      endfor
    else
      for group in l:groups
        let l:cterm=<SID>get_highlight_term(group, 'cterm')
        let l:new_cterms=join(add(split(l:cterm, ','), 'italic'), ',')
        execute 'highlight '.group.' cterm='.l:new_cterms
      endfor
    endif
  endfunction

  function! s:refresh_theme() abort
    let l:theme=get(g:, 'custom_themes_name', '')
    if !empty(l:theme)
      execute 'call frescoraja#'.l:theme.'()'
    else
      call <SID>apply_airline_theme()
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
      let l:theme=get(g:, 'custom_themes_name', 'default')
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
      let l:matching_themes=filter(copy(s:theme_list), 'v:val =~? "'.a:a.'"')
      return sort(l:matching_themes)
    endfunction

    function! s:customize_theme(...) abort
      try
        if a:0
          execute 'call frescoraja#'.a:1.'()'
        else
          echohl ModeMsg | echo g:custom_themes_name
        endif
      catch /.*/
        echohl ErrorMsg | echo 'No theme found with that name'
      endtry
    endfunction

    function! s:shorten_fn_name(idx, fn_name) abort
      return matchstr(a:fn_name, '#\zs\w\+')
    endfunction
    " }}}

    " Initializer helpers {{{
    function! s:generate_theme_list() abort
      let l:themes=map(split(globpath(&rtp, 'colors/*.vim'), "\n"), function('<SID>getfname'))
      let l:functions=filter(split(execute('function'), "\n"), 'v:val =~? "frescoraja"')
      let l:fn_names=map(l:functions, function('<SID>shorten_fn_name'))
      let l:tmplist=[]
      for fname in l:themes
        let l:name=substitute(tolower(fname), '-', '_', 'g')
        let l:matching_fns=filter(copy(l:fn_names), 'v:val =~? "'.l:name.'"')
        let l:tmplist+=l:matching_fns
      endfor
      let l:tmpmap={}
      for theme in l:tmplist
        let l:tmpmap[theme]=''
      endfor
      let s:theme_list=sort(keys(l:tmpmap))
    endfunction

    function! s:getfname(idx, val) abort
      return matchstr(a:val, '\S*/\zs\S*\ze.vim$')
    endfunction
  " }}}
" }}}

" Theme functions {{{
function! frescoraja#init() abort
  call <SID>generate_theme_list()
  let l:theme=get(g:, 'custom_themes_name', '')
  if !empty(l:theme)
    execute 'call frescoraja#'.l:theme.'()'
  endif
endfunction

function! frescoraja#default(...) abort
  colorscheme default
  set background=dark
  let g:custom_themes_name='default'
  let l:has_bg=get(a:, 1, 0)

  highlight String ctermfg=13 guifg=#FFA0A0
  highlight vimBracket ctermfg=green guifg=#33CA5F
  highlight vimParenSep ctermfg=blue guifg=#0486F1
  highlight CursorLineNr cterm=bold ctermfg=50 guifg=Cyan guibg=#232323
  highlight CursorLine cterm=none term=none guibg=NONE
  highlight vimIsCommand ctermfg=white guifg=#f1f4cc
  highlight Number term=bold ctermfg=86 guifg=#51AFFF
  highlight link vimOperParen Special

  if (l:has_bg)
    highlight Normal ctermbg=233 guibg=#0f0f0f
    highlight LineNr ctermbg=234 ctermfg=yellow guibg=#1d1d1d guifg=#ff8e00
  endif
  doautocmd User CustomizedTheme
  call <SID>colorize_column()
  call <SID>colorize_comments()
endfunction

function! frescoraja#afterglow() abort
  set termguicolors
  colorscheme afterglow
  let g:custom_themes_name='afterglow'
  let g:airline_theme='afterglow'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#blayu() abort
  set termguicolors
  colorscheme blayu
  highlight ColorColumn guibg=#2A3D4F
  highlight CursorLine guifg=#32C6B9
  let g:custom_themes_name='blayu'
  let g:airline_theme='gotham'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#busybee() abort
  set notermguicolors
  colorscheme busybee
  highlight LineNr guifg=#505050 guibg=#101010
  highlight CursorLineNr guifg=#ff9800 guibg=#202020
  let g:custom_themes_name='busybee'
  let g:airline_theme='qwq'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#candypaper() abort
  set notermguicolors
  colorscheme CandyPaper
  let g:custom_themes_name='candypaper'
  let g:airline_theme='deus'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#ceudah() abort
  set termguicolors
  colorscheme ceudah
  let g:custom_themes_name='ceudah'
  let g:airline_theme='quantum'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#chito() abort
  set termguicolors
  colorscheme chito
  let g:custom_themes_name='chito'
  let g:airline_theme='quantum'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#colorsbox_stnight() abort
  set termguicolors
  colorscheme colorsbox-stnight
  let g:custom_themes_name='colorsbox_stnight'
  let g:airline_theme='afterglow'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#colorsbox_steighties() abort
  set termguicolors
  colorscheme colorsbox-steighties
  let g:custom_themes_name='colorsbox_steighties'
  let g:airline_theme='quantum'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#dark() abort
  set termguicolors
  colorscheme dark
  let g:custom_themes_name='dark'
  let g:airline_theme='sierra'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#deus() abort
  set termguicolors
  colorscheme deus
  let g:custom_themes_name='deus'
  let g:airline_theme='deus'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#distill() abort
  set termguicolors
  colorscheme distill
  highlight ColorColumn guibg=#16181d
  let g:custom_themes_name='distill'
  let g:airline_theme='jellybeans'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#dracula() abort
  set termguicolors
  colorscheme dracula
  let g:custom_themes_name='dracula'
  let g:airline_theme='dracula'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#edar() abort
  set termguicolors
  colorscheme edar
  let g:custom_themes_name='edar'
  let g:airline_theme='lucius'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#flatcolor() abort
  set termguicolors
  colorscheme flatcolor
  let g:custom_themes_name='flatcolor'
  let g:airline_theme='base16_nord'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#gotham() abort
  set termguicolors
  colorscheme gotham
  let g:custom_themes_name='gotham'
  let g:airline_theme='gotham256'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#gruvbox() abort
  set termguicolors
  let g:gruvbox_contrast_dark='hard'
  colorscheme gruvbox
  let g:custom_themes_name='gruvbox'
  let g:airline_theme='gruvbox'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#heroku_gvim() abort
  set termguicolors
  colorscheme herokudoc-gvim
  let g:custom_themes_name='heroku_gvim'
  let g:airline_theme='material'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#hybrid_material() abort
  set termguicolors
  colorscheme hybrid_material
  let g:custom_themes_name='hybrid_material'
  let g:airline_theme='hybrid'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#hybrid_material_nogui() abort
  set notermguicolors
  colorscheme hybrid_material
  let g:custom_themes_name='hybrid_material_nogui'
  let g:airline_theme='hybrid'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#iceberg() abort
  set termguicolors
  colorscheme iceberg
  let g:custom_themes_name='iceberg'
  let g:airline_theme='iceberg'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#iceberg_nogui() abort
  set notermguicolors
  colorscheme iceberg
  let g:custom_themes_name='iceberg_nogui'
  let g:airline_theme='solarized'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#jellybeans() abort
  set termguicolors
  let g:jellybeans_use_term_italics=1
  colorscheme jellybeans
  let g:custom_themes_name='jellybeans'
  let g:airline_theme='jellybeans'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#kafka() abort
  set termguicolors
  colorscheme kafka
  let g:custom_themes_name='kafka'
  let g:airline_theme='neodark'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#maui() abort
  set termguicolors
  colorscheme maui
  let g:custom_themes_name='maui'
  let g:airline_theme='jellybeans'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#material() abort
  set termguicolors
  colorscheme material
  let g:colors_name='material'
  let g:custom_themes_name='material'
  let g:airline_theme='material'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#material_dark() abort
  set termguicolors
  colorscheme material
  highlight Normal guibg=#162127 ctermbg=233
  highlight Todo guibg=#000000 guifg=#BD9800 cterm=bold
  let g:colors_name='material'
  let g:custom_themes_name='material_dark'
  let g:airline_theme='materialmonokai'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#vim_material() abort
  set termguicolors
  let g:material_style='dark'
  colorscheme vim-material
  highlight TabLine guifg=#5D818E guibg=#212121 cterm=italic
  highlight TabLineFill guifg=#212121
  highlight TabLineSel guifg=#FFE57F guibg=#5D818E
  highlight ColorColumn guibg=#374349
  highlight CursorLine cterm=none
  let g:custom_themes_name='vim_material'
  let g:airline_theme='material'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#vim_material_oceanic() abort
  set termguicolors
  let g:material_style='oceanic'
  colorscheme vim-material
  highlight CursorLine cterm=none
  let g:custom_themes_name='vim_material_oceanic'
  let g:airline_theme='material'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#vim_material_palenight() abort
  set termguicolors
  let g:material_style='palenight'
  colorscheme vim-material
  highlight TabLine guifg=#676E95 guibg=#191919 cterm=italic
  highlight TabLineFill guifg=#191919
  highlight TabLineSel guifg=#FFE57F guibg=#676E95
  highlight ColorColumn guibg=#3A3E4F
  highlight CursorLine cterm=none
  let g:custom_themes_name='vim_material_palenight'
  let g:airline_theme='material'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#material_theme() abort
  set termguicolors
  colorscheme material-theme
  let g:custom_themes_name='material_theme'
  let g:airline_theme='material'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#molokai() abort
  set termguicolors
  let g:molokai_original=1
  let g:rehash256=1
  colorscheme molokai
  let g:custom_themes_name='molokai'
  let g:airline_theme='molokai'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#molokai_dark() abort
  set notermguicolors
  colorscheme molokai_dark
  let g:custom_themes_name='molokai_dark'
  let g:airline_theme='molokai'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#pink_moon() abort
  set termguicolors
  colorscheme pink-moon
  let g:custom_themes_name='pink_moon'
  let g:airline_theme='lucius'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#orange_moon() abort
  set termguicolors
  colorscheme orange-moon
  let g:custom_themes_name='orange_moon'
  let g:airline_theme='lucius'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#yellow_moon() abort
  set termguicolors
  colorscheme yellow-moon
  let g:custom_themes_name='yellow_moon'
  let g:airline_theme='lucius'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#neodark() abort
  set termguicolors
  colorscheme neodark
  highlight Normal guibg=#0e1e27
  let g:custom_themes_name='neodark'
  let g:airline_theme='neodark'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#neodark_nogui() abort
  set notermguicolors
  colorscheme neodark
  highlight Normal ctermbg=233
  let g:custom_themes_name='neodark_nogui'
  let g:airline_theme='neodark'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#oceanicnext() abort
  set termguicolors
  colorscheme OceanicNext
  highlight Normal guibg=#0E1E27
  highlight LineNr guibg=#0E1E27
  highlight Identifier guifg=#3590B1
  let g:custom_themes_name='oceanicnext'
  let g:airline_theme='oceanicnext'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#oceanicnext2() abort
  set termguicolors
  colorscheme OceanicNext2
  highlight LineNr guibg=#141E23
  highlight CursorLineNr guifg=#72C7D1
  highlight Identifier guifg=#4BB1A7
  highlight PreProc guifg=#A688F6
  let g:custom_themes_name='oceanicnext2'
  let g:airline_theme='oceanicnext'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#onedark() abort
  set termguicolors
  colorscheme onedark
  highlight Normal guibg=#20242C
  let g:custom_themes_name='onedark'
  let g:airline_theme='onedark'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#quantum_light() abort
  set termguicolors
  let g:quantum_black=0
  colorscheme quantum
  let g:custom_themes_name='quantum_light'
  let g:airline_theme='deus'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#quantum_dark() abort
  set termguicolors
  let g:quantum_black=1
  colorscheme quantum
  let g:custom_themes_name='quantum_dark'
  let g:airline_theme='murmur'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#spring_night() abort
  set termguicolors
  colorscheme spring-night
  hi LineNr guifg=#767f89 guibg=#1d2d42
  let g:custom_themes_name='spring_night'
  let g:airline_theme='spring_night'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#srcery() abort
  set termguicolors
  colorscheme srcery
  let g:custom_themes_name='srcery'
  let g:airline_theme='srcery'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#tender() abort
  set termguicolors
  colorscheme tender
  let g:custom_themes_name='tender'
  let g:airline_theme='tender'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#thaumaturge() abort
  set termguicolors
  colorscheme thaumaturge
  highlight ColorColumn guibg=#2c2936
  let g:custom_themes_name='thaumaturge'
  let g:airline_theme='violet'
  doautocmd User CustomizedTheme
endfunction

function! frescoraja#znake() abort
  set termguicolors
  colorscheme znake
  highlight! Normal guifg=#DCCFEE
  highlight! vimCommand guifg=#793A6A
  highlight! vimFuncKey guifg=#A91A7A cterm=bold
  highlight! Comment guifg=#5A5A69
  highlight! ColorColumn guibg=#331022 guifg=#A51F2B
  let g:custom_themes_name='znake'
  let g:airline_theme='lucius'
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
command! -nargs=0 RefreshThemeList call <SID>generate_theme_list()
command! -nargs=0 CycleCustomThemesPrev call <SID>cycle_custom_theme(-1)
command! -nargs=0 CycleCustomThemesNext call <SID>cycle_custom_theme(1)
" }}}

" Autogroup commands {{{
augroup custom_themes
  au!
  autocmd User CustomizedTheme call <SID>finalize_theme()
augroup END

if (g:custom_cursors_enabled)
  autocmd custom_themes VimEnter * call <SID>shape_cursor()
endif
" }}} end autocmds

" vim: fdm=marker fmr={{{,}}} fen
