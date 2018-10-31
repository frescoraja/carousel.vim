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
let g:default_textwidth = get(g:, 'default_textwidth', 120)
let g:default_comments_color_c = get(g:, 'default_comments_color_c', 59)
let g:default_comments_color_g = get(g:, 'default_comments_color_g', '#658494')
let g:default_column_color_c = get(g:, 'default_column_color_c', 236)
let g:default_column_color_g = get(g:, 'default_column_color_g', '#2a2a2a')
let g:default_airline_theme = get(g: ,'default_airline_theme', g:airline_theme)
let g:custom_themes_name = get(g:, 'custom_themes_name', 'default')
let g:custom_cursors_enabled = get(g:, 'custom_cursors_enabled', 0)
let init_on_load = get(g:, 'custom_themes_enabled', 0)

if (init_on_load)
  call frescoraja#init()
endif

" Command mapping {{{
if !hasmapto('<Plug>(customize_theme)') && maparg('<Nul>', 'n') ==# ''
  nmap <unique> <Nul> <Plug>(customize_theme)
endif

nmap <Plug>(customize_theme) :CustomizeTheme <C-d>
nmap <Plug>(reset_theme) :DefaultTheme<CR>
nmap <Plug>(refresh_theme) :RefreshAppearance<CR>
nmap <Plug>(set_textwidth) :SetTextwidth<Space>
nmap <Plug>(reset_textwidth) :SetTextwidth 0<CR>
nmap <Plug>(toggle_column) :ToggleColumn<CR>
nmap <Plug>(toggle_dark) :ToggleDark<CR>
nmap <Plug>(toggle_background) :ToggleBackground<CR>
nmap <Plug>(toggle_italics) :ToggleItalics!<CR>
nmap <Plug>(get_syntax) :GetSyntaxGroup<CR>
nmap <Plug>(set_column_color) :ColorizeColumn<Space>
nmap <Plug>(set_comments_color) :ColorizeComments<Space>
nmap <Plug>(reset_comments_color) :ColorizeComments<CR>
nmap <Plug>(reset_column_color) :ColorizeColumn<CR>
" }}}

" vim: ft=vim fdm=marker fmr={{{,}}} nofen
