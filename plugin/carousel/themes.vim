" Theme definitions {{{
function! carousel#themes#random() abort
  try
    " check for python support
    if !has('python') && !has('python3')
      throw 'randomized theme selection requires python support.'
    endif
    let l:py_cmd = has('python3') ? 'py3' : 'py'
    let l:available_themes = filter(
          \ copy(g:carousel_cache.themes),
          \ 'v:val !=# "random"'
          \)
    let l:max_idx = len(l:available_themes)
    if l:max_idx > 0
      let l:rand_idx = trim(
            \ execute(l:py_cmd . ' import random; print(random.randint(0,' . (l:max_idx-1) . '))')
            \ )
      let l:theme = l:available_themes[l:rand_idx]
      execute 'call carousel#themes#' . l:theme . '()'
    else
      throw 'no themes in g:carousel_cache'
    endif
  catch
    echohl ErrorMsg | echomsg 'Random theme could not be loaded: ' . v:exception . '. Loading `default` theme.' | echohl None
    call carousel#themes#default()
  endtry
endfunction

function! carousel#themes#default() abort
  set background=dark
  call carousel#initialize_theme(v:false)
  let g:carousel_theme_name = 'default'
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

  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#afterglow() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'afterglow'
  colorscheme afterglow
  highlight! Pmenu guibg=#2A344E
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#allomancer() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'allomancer'
  colorscheme allomancer
  highlight! NonText guifg=#676B78
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#allomancer_nogui() abort
  call carousel#initialize_theme(v:false)
  let g:carousel_theme_name = 'allomancer_nogui'
  colorscheme allomancer
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#apprentice() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'apprentice'
  colorscheme apprentice
  highlight! NonText guifg=#909090
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#ayu_dark() abort
  call carousel#initialize_theme()
  let g:ayucolor = 'dark'
  let g:carousel_theme_name = 'ayu_dark'
  colorscheme ayu
  highlight! NonText guifg=#4F5459
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#ayu_mirage() abort
  call carousel#initialize_theme()
  let g:ayucolor = 'mirage'
  let g:carousel_theme_name = 'ayu_mirage'
  colorscheme ayu
  highlight! NonText guifg=#717783
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#blayu() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'blayu'
  colorscheme blayu
  highlight clear CursorLine
  highlight! ColorColumn guibg=#2A3D4F
  highlight! MatchParen guifg=#AF37D0 guibg=#2E4153 cterm=bold,underline
  highlight! Pmenu guibg=#4f6275
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#candid() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'candid'
  colorscheme candid
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#ceudah() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'ceudah'
  colorscheme ceudah
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#challenger_deep() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'challenger_deep'
  colorscheme challenger_deep
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#chito() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'chito'
  colorscheme chito
  highlight! Normal guibg=#262A37
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#colorsbox_stnight() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'colorsbox_stnight'
  colorscheme colorsbox-stnight
  highlight! NonText guifg=#A08644
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#colorsbox_steighties() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'colorsbox_steighties'
  colorscheme colorsbox-steighties
  highlight! NonText guifg=#AB9B4B
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#dark() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'dark'
  colorscheme dark
  highlight! vimBracket guifg=#AA6A22
  highlight! vimParenSep guifg=#8A3140
  highlight! Pmenu guibg=#6F6F6F
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#deep_space() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'deep_space'
  colorscheme deep-space
  highlight! Normal guibg=#090E18
  highlight! Folded guifg=#525C6D
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#deus() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'deus'
  colorscheme deus
  highlight! Normal guibg=#1C222B
  highlight! NonText guifg=#83A598 guibg=NONE
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#distill() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'distill'
  colorscheme distill
  highlight! ColorColumn guibg=#16181D
  highlight! LineNr guifg=#474B58
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#edar() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'edar'
  colorscheme edar
  highlight! NonText guifg=#5988B5 guibg=NONE
  highlight! Pmenu guibg=#202A3A
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#edge() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'edge'
  let g:edge_style = 'neon'
  colorscheme edge
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#flatcolor() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'flatcolor'
  colorscheme flatcolor
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#forest_night() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'forest_night'
  let g:forest_night_enable_italic = 1
  colorscheme forest-night
  highlight! Normal guibg=#1C2C35
  highlight! LineNr guibg=#27373F guifg=#616C72
  highlight! CursorLineNr guifg=#48B2F0 guibg=#500904
  highlight! CursorLine guibg=#500904
  highlight! Pmenu guibg=#2C3C45
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#glacier() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'glacier'
  colorscheme glacier
  highlight! ColorColumn guibg=#21272D guifg=DarkRed
  highlight! Pmenu guibg=#23292F
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#gotham() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'gotham'
  colorscheme gotham
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#gruvbox() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'gruvbox'
  let g:gruvbox_contrast_light = 1
  if exists('g:gruvbox_contrast_dark')
    unlet g:gruvbox_contrast_dark
  endif
  colorscheme gruvbox
  highlight! NonText ctermfg=12 guifg=#504945
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#gruvbox_hard() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'gruvbox_hard'
  let g:gruvbox_contrast_dark = 'hard'
  if exists('g:gruvbox_contrast_light')
    unlet g:gruvbox_contrast_light
  endif
  colorscheme gruvbox
  highlight! NonText ctermfg=12 guifg=#504945
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#gruvbox8() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'gruvbox8'
  let g:gruvbox_italics = 0
  colorscheme gruvbox8_hard
  highlight! NonText ctermfg=248 guifg=#62605F
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#gruvbox8_soft() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'gruvbox8_soft'
  let g:gruvbox_italics = 0
  colorscheme gruvbox8_soft
  highlight! NonText ctermfg=248 guifg=#62605F
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#gruvbox_material() abort
  call carousel#initialize_theme()
  let g:gruvbox_material_enable_bold = 1
  let g:carousel_theme_name = 'gruvbox_material'
  if exists('g:gruvbox_material_background')
    unlet g:gruvbox_material_background
  endif
  colorscheme gruvbox-material
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#gruvbox_material_hard() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'gruvbox_material_hard'
  let g:gruvbox_material_enable_bold = 1
  let g:gruvbox_material_background='hard'
  colorscheme gruvbox-material
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#gummybears() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'gummybears'
  colorscheme gummybears
  highlight! NonText guifg=#595950
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#hybrid_material() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'hybrid_material'
  let g:enable_bold_font = 1
  colorscheme hybrid_material
  highlight! Normal guibg=#162228
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#hybrid_reverse() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'hybrid_reverse'
  let g:enable_bold_font = 1
  colorscheme hybrid_reverse
  highlight! NonText guifg=#575B61
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#iceberg() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'iceberg'
  colorscheme iceberg
  highlight! NonText guifg=#575B68
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#iceberg_nogui() abort
  call carousel#initialize_theme(v:false)
  let g:carousel_theme_name = 'iceberg_nogui'
  colorscheme iceberg
  highlight! NonText ctermfg=245
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#jellybeans() abort
  call carousel#initialize_theme()
  let g:jellybeans_use_term_italics = 1
  let g:carousel_theme_name = 'jellybeans'
  colorscheme jellybeans
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#kafka() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'kafka'
  colorscheme kafka
  highlight! Pmenu guibg=#4E545F
  highlight! NonText guibg=#6d767d
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#kuroi() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'kuroi'
  colorscheme kuroi
  highlight! LineNr guifg=#575B61
  highlight! NonText guifg=#676B71
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#kuroi_nogui() abort
  call carousel#initialize_theme(v:false)
  let g:carousel_theme_name = 'kuroi_nogui'
  colorscheme kuroi
  highlight! LineNr ctermfg=243
  highlight! NonText ctermfg=245
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#mango() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'mango'
  colorscheme mango
  highlight! Pmenu ctermbg=232 guibg=#1D1D1D
  highlight! NonText guifg=#5D5D5D
  highlight! Folded ctermbg=NONE guibg=NONE
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#maui() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'maui'
  colorscheme maui
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#material() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'material'
  colorscheme material
  highlight! Normal guibg=#162127 ctermbg=233
  highlight! Todo guibg=#000000 guifg=#BD9800 cterm=bold
  highlight! LineNr guifg=#56676E
  highlight! Folded guifg=#546D7A guibg=#121E20
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#material_theme() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'material_theme'
  colorscheme material-theme
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#vim_material() abort
  call carousel#initialize_theme()
  let g:material_style = 'dark'
  let g:carousel_theme_name = 'vim_material'
  colorscheme vim-material
  highlight! ColorColumn guibg=#374349
  highlight! CursorLine cterm=NONE
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#vim_material_oceanic() abort
  call carousel#initialize_theme()
  let g:material_style = 'oceanic'
  let g:carousel_theme_name = 'vim_material_oceanic'
  colorscheme vim-material
  highlight! CursorLine cterm=NONE
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#vim_material_palenight() abort
  call carousel#initialize_theme()
  let g:material_style = 'palenight'
  let g:carousel_theme_name = 'vim_material_palenight'
  colorscheme vim-material
  highlight! TabLine guifg=#676E95 guibg=#191919
  highlight! TabLineFill guifg=#191919
  highlight! TabLineSel guifg=#FFE57F guibg=#676E95
  highlight! ColorColumn guibg=#3A3E4F
  highlight! CursorLine cterm=NONE
  highlight! Normal guibg=#191D2E
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#material_monokai() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'material_monokai'
  let g:materialmonokai_italic = 1
  let g:materialmonokai_custom_lint_indicators = 0
  colorscheme material-monokai
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#miramare() abort
  call carousel#initialize_theme()
  let g:miramare_transparent_background = 0
  let g:miramare_enable_italic = 1
  let g:miramare_enable_bold = 1
  let g:miramare_cursor = 'purple' " doesn't seem to work in iTerm2
  let g:miramare_current_word = 'bold'
  let g:carousel_theme_name = 'miramare'
  let g:miramare_palette = {
        \ 'bg0': ['#221C1E', '235', 'Black'],
        \ 'grey': ['#666666', '245', 'LightGrey']
        \ }
  colorscheme miramare
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#molokai() abort
  call carousel#initialize_theme()
  let g:molokai_original = 1
  let g:rehash256 = 1
  let g:carousel_theme_name = 'molokai'
  colorscheme molokai
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#molokai_dark_nogui() abort
  call carousel#initialize_theme(v:false)
  let g:carousel_theme_name = 'molokai_dark_nogui'
  colorscheme molokai_dark
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#nord() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'nord'
  colorscheme nord
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#plastic() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'plastic'
  colorscheme plastic
  highlight! Comment guifg=#7B828F
  highlight! CursorLine guifg=#8BB2DF
  highlight! CursorLineNr guifg=#FBC29F guibg=#51555B
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#pink_moon() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'pink_moon'
  colorscheme pink-moon
  highlight! NonText guifg=#344451
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#orange_moon() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'orange_moon'
  colorscheme orange-moon
  highlight! NonText guifg=#69666A
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#yellow_moon() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'yellow_moon'
  colorscheme yellow-moon
  highlight! NonText guifg=#69666A
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#neodark() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'neodark'
  colorscheme neodark
  highlight! Normal guibg=#0e1e27
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#neodark_nogui() abort
  call carousel#initialize_theme(v:false)
  let g:carousel_theme_name = 'neodark_nogui'
  colorscheme neodark
  highlight! Normal ctermbg=233
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#night_owl() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'night_owl'
  colorscheme night-owl
  highlight! Folded guibg=#202000 guifg=#BFAF9F
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#oceanicnext() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'oceanicnext'
  colorscheme OceanicNext
  highlight! Normal guibg=#0E1E27
  highlight! LineNr guibg=#0E1E27
  highlight! Identifier guifg=#3590B1
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#oceanicnext2() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'oceanicnext2'
  colorscheme OceanicNext2
  highlight! LineNr guibg=#141E23
  highlight! CursorLineNr guifg=#72C7D1
  highlight! Identifier guifg=#4BB1A7
  highlight! PreProc guifg=#A688F6
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#one() abort
  call carousel#initialize_theme()
  let g:allow_one_italics = 1
  let g:carousel_theme_name = 'one'
  colorscheme one
  highlight! NonText guifg=#61AFEF
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#onedark() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'onedark'
  colorscheme onedark
  highlight! NonText guifg=#D19A66
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#onedarkafterglow() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'onedarkafterglow'
  colorscheme onedarkafterglow
  highlight! NonText guifg=#4B80D8
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#petrel() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'petrel'
  colorscheme petrel
  highlight! Pmenu gui=NONE
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#quantum_light() abort
  call carousel#initialize_theme()
  let g:quantum_black = 0
  let g:carousel_theme_name = 'quantum_light'
  colorscheme quantum
  highlight! LineNr guifg=#627782
  highlight! Folded guifg=#627782
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#quantum_dark() abort
  call carousel#initialize_theme()
  let g:quantum_black = 1
  let g:carousel_theme_name = 'quantum_dark'
  colorscheme quantum
  highlight! LineNr guifg=#627782
  highlight! Folded guifg=#627782
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#spring_night() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'spring_night'
  colorscheme spring-night
  highlight! LineNr guifg=#767f89 guibg=#1d2d42
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#srcery() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'srcery'
  colorscheme srcery
  highlight! NonText gui=NONE guifg=#5C5B59
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#tender() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'tender'
  colorscheme tender
  highlight! Normal guibg=#1F1F1F
  highlight! LineNr guifg=#677889 guibg=#282828
  highlight! NonText guifg=#475869
  highlight! Pmenu guibg=#237EA4
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#thaumaturge() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'thaumaturge'
  colorscheme thaumaturge
  highlight ColorColumn guibg = #2C2936
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#tokyo_metro() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'tokyo_metro'
  colorscheme tokyo-metro
  highlight! NonText guifg=#646980
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#tomorrow_night() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'tomorrow_night'
  colorscheme Tomorrow-Night
  highlight! Normal guibg=#15191A
  highlight! LineNr guibg=#1F2223
  highlight! NonText guifg=#787878
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#two_firewatch() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'two_firewatch'
  colorscheme two-firewatch
  highlight! Normal guibg=#21252D
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#yowish() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'yowish'
  let g:yowish = {
        \ 'term_italic': 1,
        \ 'comment_italic': 1,
        \ }
  colorscheme yowish
  highlight! LineNr guifg=#555555
  highlight! NonText guifg=#757575
  doautocmd User CustomizedTheme
endfunction

function! carousel#themes#znake() abort
  call carousel#initialize_theme()
  let g:carousel_theme_name = 'znake'
  colorscheme znake
  highlight! Normal guifg=#DCCFEE
  highlight! vimCommand guifg=#793A6A
  highlight! vimFuncKey guifg=#A91A7A cterm=bold
  highlight! Comment guifg=#5A5A69
  highlight! ColorColumn guibg=#331022 guifg=#A51F2B
  " highlight! NonText guifg=#8A6044
  doautocmd User CustomizedTheme
endfunction
" }}} end Theme Definitions
