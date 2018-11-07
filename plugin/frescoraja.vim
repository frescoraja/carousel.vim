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

if exists('g:loaded_custom_themes')
  finish
endif
let g:loaded_custom_themes=1

" default settings for Airline theme, textwidth and comments/colorcolumn colors
let g:default_textwidth = get(g:, 'default_textwidth', &textwidth)
let g:default_comments_color_c = get(g:, 'default_comments_color_c', 59)
let g:default_comments_color_g = get(g:, 'default_comments_color_g', '#658494')
let g:default_column_color_c = get(g:, 'default_column_color_c', 236)
let g:default_column_color_g = get(g:, 'default_column_color_g', '#2a2a2a')
let g:default_airline_theme = get(g: ,'default_airline_theme', g:airline_theme)
let g:custom_themes_name = get(g:, 'custom_themes_name', '')
let g:custom_cursors_enabled = get(g:, 'custom_cursors_enabled', 0)
let init_on_load = get(g:, 'custom_themes_enabled', 0)

if (init_on_load)
  call frescoraja#init()
endif

" Command mapping {{{
nmap <Plug>(customize_theme) :CustomizeTheme <C-d>
nmap <Plug>(refresh_custom_themes) :RefreshCustomThemes<CR>
nmap <Plug>(refresh_colorschemes) :RefreshColorschemes<CR>
nmap <silent> <Plug>(cycle_custom_themes_next) :CycleCustomThemesNext<CR>
nmap <silent> <Plug>(cycle_custom_themes_prev) :CycleCustomThemesPrev<CR>
nmap <silent> <Plug>(cycle_colorschemes_next) :CycleColorschemesNext<CR>
nmap <silent> <Plug>(cycle_colorschemes_prev) :CycleColorschemesPrev<CR>
nmap <Plug>(set_textwidth) :SetTextwidth<Space>
nmap <Plug>(set_column_color) :ColorizeColumn<Space>
nmap <Plug>(set_comments_color) :ColorizeComments<Space>
nmap <silent> <Plug>(reset_theme) :DefaultTheme<CR>
nmap <silent> <Plug>(refresh_theme) :CustomThemeRefresh<CR>
nmap <silent> <Plug>(reset_textwidth) :SetTextwidth 0<CR>
nmap <silent> <Plug>(toggle_column) :ToggleColumn<CR>
nmap <silent> <Plug>(toggle_dark) :ToggleDark<CR>
nmap <silent> <Plug>(toggle_background) :ToggleBackground<CR>
nmap <silent> <Plug>(italicize) :Italicize!<CR>
nmap <silent> <Plug>(get_syntax) :GetSyntaxGroup<CR>
nmap <silent> <Plug>(reset_comments_color) :ColorizeComments<CR>
nmap <silent> <Plug>(reset_column_color) :ColorizeColumn<CR>

if !hasmapto('<Plug>(customize_theme)') && empty(maparg('<Nul>', 'n'))
  nmap <unique> <Nul> <Plug>(customize_theme)
endif

if !hasmapto('<Plug>(cycle_custom_themes_next') && empty(maparg('<F9>', 'n'))
  nmap <unique> <F9> <Plug>(cycle_custom_themes_next)
endif

if !hasmapto('<Plug>(cycle_custom_themes_prev') && empty(maparg('<F7>', 'n'))
  nmap <unique> <F7> <Plug>(cycle_custom_themes_prev)
endif

if !hasmapto('<Plug>(cycle_colorschemes_next') && empty(maparg('<S-F9>', 'n'))
  nmap <unique> <S-F9> <Plug>(cycle_colorschemes_next)
endif

if !hasmapto('<Plug>(cycle_colorschemes_prev') && empty(maparg('<S-F7>', 'n'))
  nmap <unique> <S-F7> <Plug>(cycle_colorschemes_prev)
endif

if !hasmapto('<Plug>(refresh_custom_themes') && empty(maparg('<F8>', 'n'))
  nmap <unique> <F8> <Plug>(refresh_custom_themes)
endif

if !hasmapto('<Plug>(refresh_colorschemes') && empty(maparg('<S-F8>', 'n'))
  nmap <unique> <S-F8> <Plug>(refresh_colorschemes)
endif
" }}}

" vim: ft=vim fdm=marker fmr={{{,}}} nofen
