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

if !exists('+termguicolors')
  echohl ErrorMsg | echo 'frescoraj-vim-themes relies on having a terminal with 256 colors'
  finish
endif

if exists('g:loaded_custom_themes')
  finish
endif

let g:loaded_custom_themes = 1

if get(g:, 'custom_themes_enabled', 0)
  call frescoraja#init()
endif

" Command mapping {{{
nmap <Plug>CustomizeTheme :CustomizeTheme <C-D>
nmap <Plug>ReloadThemes :ReloadThemes<CR>
nmap <Plug>ReloadColorschemes :ReloadColorschemes<CR>
nmap <Plug>SetTextwidth :SetTextwidth<Space>
nmap <silent> <Plug>DefaultTheme :DefaultTheme<CR>
nmap <silent> <Plug>RefreshTheme :RefreshTheme<CR>
nmap <silent> <Plug>ToggleColumn SetTextwidth!<CR>
nmap <silent> <Plug>NextTheme :NextTheme<CR>
nmap <silent> <Plug>PrevTheme :PrevTheme<CR>
nmap <silent> <Plug>NextColorscheme :NextColorscheme<CR>
nmap <silent> <Plug>PrevColorscheme :PrevColorscheme<CR>
nmap <silent> <Plug>ToggleDark :ToggleDark<CR>
nmap <silent> <Plug>ToggleBackground :ToggleBackground<CR>
nmap <silent> <Plug>Italicize :Italicize!<CR>
nmap <silent> <Plug>GetSyntax :GetSyntaxGroup<CR>

if !&wildcharm | set wildcharm=<C-Z> | endif
execute 'nmap <Plug>Colorize :ColorizeSyntaxGroup ' . nr2char(&wildcharm)

if !hasmapto('<Plug>CustomizeTheme') && empty(maparg('<Nul>', 'n'))
  nmap <unique> <Nul> <Plug>CustomizeTheme
endif

if !hasmapto('<Plug>NextTheme') && empty(maparg('<F9>', 'n'))
  nmap <unique> <F9> <Plug>NextTheme
endif

if !hasmapto('<Plug>PrevTheme') && empty(maparg('<F7>', 'n'))
  nmap <unique> <F7> <Plug>PrevTheme
endif

if !hasmapto('<Plug>NextColorscheme') && empty(maparg('<S-F9>', 'n'))
  nmap <unique> <S-F9> <Plug>NextColorscheme
endif

if !hasmapto('<Plug>PrevColorscheme') && empty(maparg('<S-F7>', 'n'))
  nmap <unique> <S-F7> <Plug>PrevColorscheme
endif

if !hasmapto('<Plug>ReloadThemes') && empty(maparg('<F8>', 'n'))
  nmap <unique> <F8> <Plug>ReloadThemes
endif

if !hasmapto('<Plug>ReloadColorschemes') && empty(maparg('<S-F8>', 'n'))
  nmap <unique> <S-F8> <Plug>ReloadColorschemes
endif
" }}}

" vim: ft=vim fdm=marker fmr={{{,}}} nofen
