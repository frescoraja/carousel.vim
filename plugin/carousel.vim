" Script Info  {{{
"==========================================================================================================
" Name Of File: carousel.vim
"  Description: A vim plugin for dynamic theme-loading and customizing vim appearance.
"   Maintainer: David Carter <fresco.raja at gmail.com>
"      Version: 0.0.9
"==========================================================================================================
" }}}

if !exists('+termguicolors')
  echohl ErrorMsg | echo 'Carousel relies on terminal with true color support (termguicolors)'
  finish
endif

if exists('g:loaded_carousel')
  finish
endif

let g:loaded_carousel = 1

if get(g:, 'carousel_enabled', 0)
  call carousel#init()

  " Plugin Mappings {{{
  " Commands {{{
  " No Args {{{
  nmap <Plug>CarouselReload :CarouselReload<CR>
  nmap <Plug>ColorschemesReload :Colorschemesp<CR>
  nmap <Plug>CarouselDefault :CarouselDefault<CR>
  nmap <Plug>CarourselRefresh :CarouselRefresh<CR>
  nmap <Plug>ToggleColumn :SetTextwidth!<CR>
  nmap <Plug>CarouselNext :CarouselNext<CR>
  nmap <Plug>CarouselPrev :CarouselPrev<CR>
  nmap <Plug>CarouselRandom :CarouselRandom<CR>
  nmap <Plug>ColorschemeNext :ColorschemeNext<CR>
  nmap <Plug>ColorschemePrev :ColorschemePrev<CR>
  nmap <Plug>ToggleDark :ToggleDark<CR>
  nmap <Plug>ToggleBackground :ToggleBackground<CR>
  nmap <Plug>ToggleItalics :Italicize!<CR>
  nmap <Plug>GetSyntax :GetSyntaxGroup<CR>
  " }}} end No Args Commands

  " With Args {{{
  nmap <Plug>SetTextwidth :SetTextwidth<Space>
  if get(g:, 'carousel_completion_enabled', 0)
    if !&wildcharm | set wildcharm=<C-Z> | endif
    execute 'nmap <Plug>Carousel :Carousel ' . nr2char(&wildcharm)
    execute 'nmap <Plug>Colorize :ColorizeSyntaxGroup ' . nr2char(&wildcharm)
    execute 'nmap <Plug>Italicize :Italicize! ' . nr2char(&wildcharm)
  else
    nmap <Plug>Carousel :Carousel<Space>
    nmap <Plug>Colorize :ColorizeSyntaxGroup<Space>
    nmap <Plug>Italicize :Italicize
  endif
  " }}} end Commands with args mappings
  " }}} end Commands

  " Clap Provider {{{
  if get(g:, 'carousel_clap_provider_enabled', 1)
    let g:clap_provider_themes = {
        \ 'source': function('carousel#list'),
        \ 'filter': function('carousel#filter'),
        \ 'sink': function('carousel#load') }
  endif
  " }}}

  " Keymaps {{{
  if get(g:, 'carousel_mappings_enabled', 0)
    if empty(maparg('<F5>', 'n'))
      if exists(':Clap')
        nmap <silent> <F5> :Clap themes<CR>
      else
        if !hasmapto('<Plug>Carousel')
          nmap <F5> <Plug>Carousel
        endif
      endif
    endif
    if !hasmapto('<Plug>CarouselPrev') && empty(maparg('<F7>', 'n'))
      nmap <silent> <F7> <Plug>CarouselPrev
    endif
    if !hasmapto('<Plug>CarouselNext') && empty(maparg('<F9>', 'n'))
      nmap <silent> <F9> <Plug>CarouselNext
    endif
    if has('nvim') && !exists('$TMUX')
      " Shift + Fn keys in nvim map differently than vim, but not in tmux
      if !hasmapto('<Plug>CarouselRandom') && empty(maparg('<F17>', 'n'))
        nmap <silent> <F17> <Plug>CarouselRandom
      endif
      if !hasmapto('<Plug>ColorschemePrev') && empty(maparg('<F19>', 'n'))
        nmap <silent> <F19> <Plug>ColorschemePrev
      endif
      if !hasmapto('<Plug>ColorschemeNext') && empty(maparg('<F21>', 'n'))
        nmap <silent> <F21> <Plug>ColorschemeNext
      endif
    else
      if !hasmapto('<Plug>CarouselRandom') && empty(maparg('<S-F5>', 'n'))
        nmap <silent> <S-F5> <Plug>CarouselRandom
      endif
      if !hasmapto('<Plug>ColorschemePrev') && empty(maparg('<S-F7>', 'n'))
        nmap <silent> <S-F7> <Plug>ColorschemePrev
      endif
      if !hasmapto('<Plug>ColorschemeNext') && empty(maparg('<S-F9>', 'n'))
        nmap <silent> <S-F9> <Plug>ColorschemeNext
      endif
    endif
  endif
  " }}} end Keymaps
  " }}} end Plugin Mappings
endif


" vim: ft=vim fdm=marker fmr={{{,}}} nofen
