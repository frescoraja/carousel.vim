" frescoraja-vim-themes: A vim plugin wrapper for dynamic theme loading and customizing vim appearance.
    "
" Script Info  {{{
"==========================================================================================================
" Name Of File: frescoraja.vim
"  Description: A vim plugin wrapper for dynamic theme loading and customizing vim appearance.
"   Maintainer: David Carter <fresco.raja at gmail.com>
"      Version: 0.0.5
"==========================================================================================================
" }}}

if !exists('+termguicolors')
  echohl ErrorMsg | echo 'frescoraj-vim-themes relies on terminal with true color support (termguicolors)'
  finish
endif

if exists('g:loaded_custom_themes')
  finish
endif

let g:loaded_custom_themes = 1

if get(g:, 'custom_themes_enabled', 0)
  call frescoraja#init()

  " Command mapping {{{
  " commands with no arguments:
  nmap <Plug>ReloadThemes :ReloadThemes<CR>
  nmap <Plug>ReloadColorschemes :ReloadColorschemes<CR>
  nmap <Plug>DefaultTheme :DefaultTheme<CR>
  nmap <Plug>RefreshTheme :RefreshTheme<CR>
  nmap <Plug>ToggleColumn :SetTextwidth!<CR>
  nmap <Plug>NextTheme :NextTheme<CR>
  nmap <Plug>PrevTheme :PrevTheme<CR>
  nmap <Plug>RandomTheme :RandomTheme<CR>
  nmap <Plug>NextColorscheme :NextColorscheme<CR>
  nmap <Plug>PrevColorscheme :PrevColorscheme<CR>
  nmap <Plug>ToggleDark :ToggleDark<CR>
  nmap <Plug>ToggleBackground :ToggleBackground<CR>
  nmap <Plug>ToggleItalics :Italicize!<CR>
  nmap <Plug>GetSyntax :GetSyntaxGroup<CR>
  " commands that take arguments:
  nmap <Plug>SetTextwidth :SetTextwidth<Space>
  " commands that take arguments and support auto-completion
  if get(g:, 'custom_themes_completion_enabled', 0)
    if !&wildcharm | set wildcharm=<C-Z> | endif
    execute 'nmap <Plug>CustomizeTheme :CustomizeTheme ' . nr2char(&wildcharm)
    execute 'nmap <Plug>Colorize :ColorizeSyntaxGroup ' . nr2char(&wildcharm)
    execute 'nmap <Plug>Italicize :Italicize! ' . nr2char(&wildcharm)
  else
    nmap <Plug>CustomizeTheme :CustomizeTheme<Space>
    nmap <Plug>Colorize :ColorizeSyntaxGroup<Space>
    nmap <Plug>Italicize :Italicize
  endif

  " add key maps if enabled
  if get(g:, 'custom_themes_mappings_enabled', 0)
    if !hasmapto('<Plug>CustomizeTheme') && empty(maparg('<F5>', 'n'))
      nmap <silent> <unique> <F5> <Plug>CustomizeTheme
    endif
    if !hasmapto('<Plug>PrevTheme') && empty(maparg('<F7>', 'n'))
      nmap <silent> <unique> <F7> <Plug>PrevTheme
    endif
    if !hasmapto('<Plug>NextTheme') && empty(maparg('<F9>', 'n'))
      nmap <silent> <unique> <F9> <Plug>NextTheme
    endif

    if has('nvim') && !exists('$TMUX')
      " Shift + Fn keys in nvim map differently than vim, but not in tmux
      if !hasmapto('<Plug>RandomTheme') && empty(maparg('<F17>', 'n'))
        nmap <silent> <unique> <F17> <Plug>RandomTheme
      endif
      if !hasmapto('<Plug>PrevColorscheme') && empty(maparg('<F19>', 'n'))
        nmap <silent> unique> <F19> <Plug>PrevColorscheme
      endif
      if !hasmapto('<Plug>NextColorscheme') && empty(maparg('<F21>', 'n'))
        nmap <silent> <unique> <F21> <Plug>NextColorscheme
      endif
    else
      if !hasmapto('<Plug>RandomTheme') && empty(maparg('<S-F5>', 'n'))
        nmap <silent> <unique> <S-F5> <Plug>RandomTheme
      endif
      if !hasmapto('<Plug>PrevColorscheme') && empty(maparg('<S-F7>', 'n'))
        nmap <silent> <unique> <S-F7> <Plug>PrevColorscheme
      endif
      if !hasmapto('<Plug>NextColorscheme') && empty(maparg('<S-F9>', 'n'))
        nmap <silent> <unique> <S-F9> <Plug>NextColorscheme
      endif
    endif
  endif
endif
" }}}


" vim: ft=vim fdm=marker fmr={{{,}}} nofen
