" textobj-motionmotion - Text objects for bounds of 2 motions
" Author: Takeshi Banse <takebi@laafc.net>
" Licence: Public Domain

function! s:readchar()
  let c = getchar()
  if type(c) == type(0)
    let c = nr2char(c)
  endif
  return c
endfunction

function! s:readcountp(s)
  return (a:s == '' || a:s =~ '^\d\+$')
endfunction

" basically just dumped out the quickref.txt
" TODO: text objects
" TODO: /?
" TODO: mapped motions
" TODO: :
" TODO: less ugliness
" XXX: make vim do this (some kind of g@), but I have no clue unfortunately.
function! s:loop(c, acc, motion1, succ)
  " Q_lr
  if     a:acc == '' && (a:c ==# '0' || a:c ==# '^')
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  " XXX: [count]
  elseif s:readcountp(a:acc) && s:readcountp(a:c)
    return s:loop(s:readchar(), a:acc . a:c, a:motion1, a:succ)
  elseif a:acc =~# 'g$' &&
  \      (a:c ==# '0' || a:c ==# '^' || a:c ==# '$' || a:c ==# 'm')
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  elseif s:readcountp(a:acc) &&
  \      (a:c ==# 'h' || a:c ==# 'l' || a:c ==# '$' || a:c ==# '|' ||
  \       a:c ==# ';' || a:c ==# ',')
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  elseif s:readcountp(a:acc) &&
  \      (a:c ==# 'f' || a:c ==# 'F' || a:c ==# 't' || a:c ==# 'T')
    return s:succmaybe(s:readchar(), a:acc . a:c, a:motion1, a:succ)
  " Q_ud
  elseif a:acc =~# 'g$' &&
  \      (a:c ==# 'g' || a:c ==# 'k' || a:c ==# 'j')
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  elseif s:readcountp(a:acc) &&
  \      (a:c ==# 'k' || a:c ==# 'j' || a:c ==# '-' || a:c ==# '+' ||
  \       a:c ==# '_' || a:c ==# 'G' || a:c ==# '%')
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  " Q_tm
  elseif a:acc =~# 'g$' &&
  \      (a:c ==# 'e' || a:c ==# 'E')
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  elseif (a:acc =~# '\]$' || a:acc =~# '\[$') &&
  \      (a:c ==# ']' || a:c ==# '[' || a:c ==# '(' || a:c ==# '{' ||
  \       a:c ==# 'm' || a:c ==# 'M' || a:c ==# ')' || a:c ==# '}' ||
  \       a:c ==# '#' || a:c ==# '*')
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  elseif s:readcountp(a:acc) &&
  \      (a:c ==# 'w' || a:c ==# 'W' || a:c ==# 'e' || a:c ==# 'E' ||
  \       a:c ==# 'b' || a:c ==# 'B' || a:c ==# ')' || a:c ==# '(' ||
  \       a:c ==# '}' || a:c ==# '{')
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  " g[]
  elseif s:readcountp(a:acc) &&
  \      (a:c ==# 'g' || a:c ==# ']' || a:c ==# '[')
    return s:loop(s:readchar(), a:acc . a:c, a:motion1, a:succ)
  " Q_pa
  " TODO: /?
  elseif s:readcountp(a:acc) &&
  \      (a:c ==# 'n' || a:c ==# 'N' || a:c ==# '*' || a:c ==# '#')
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  elseif a:acc =~# 'g$' &&
  \      (a:c ==# '*' || a:c ==# '#' || a:c ==# 'd' || a:c ==# 'D')
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  " Q_ma
  elseif a:acc == '' && (a:c ==# 'm' || a:c ==# '`' || a:c ==# "'")
    return s:loop(s:readchar(), a:acc . a:c, a:motion1, a:succ)
  elseif a:acc ==# 'm' && a:c =~# '[a-zA-Z]'
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  elseif a:acc =~# "[`']$" && a:c =~# "[a-zA-Z0-9\\]\[`'\"\<\>.]"
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  elseif s:readcountp(a:acc) && (a:c == "\<C-o>" || a:c == "\<C-i>")
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  " Q_vm
  elseif a:acc == '' && (a:c == '%' || a:c == 'M')
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  elseif s:readcountp(a:acc) && (a:c ==# 'H' || a:c == 'L')
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  elseif a:acc =~# 'g$' && a:c ==# 'o'
    return s:succmaybe(a:c, a:acc, a:motion1, a:succ)
  " Q_ta
  " XXX: Does it make sense?
  endif
endfunction

function! s:succmaybe(c, acc, motion1, succ)
  if a:motion1 == ''
    return s:loop(s:readchar(), '', a:acc . a:c, a:succ)
  else
    return a:succ(a:motion1, a:acc . a:c)
  endif
endfunction

function! s:selectraw(m1, m2, proc)
  let cur = getpos('.')
  execute "normal! " . a:m1
  let beg = getpos('.')
  call a:proc(cur, beg, a:m1, a:m2)
  execute "normal! " . a:m2
  let end = getpos('.')
  call setpos('.', cur)
  return ['v', beg, end]
endfunction

function! s:setpos1(pos, ...)
  call setpos('.', a:pos)
endfunction

function! s:selectiaux(m1, m2)
  return s:selectraw(a:m1, a:m2, function('s:setpos1'))
endfunction

function! textobj#motionmotion#select_i()
  return s:loop(s:readchar(), '', '', function('s:selectiaux'))
endfunction

function! s:ignore(...)
  return 0
endfunction

function! s:selectaaux(m1, m2)
  return s:selectraw(a:m1, a:m2, function('s:ignore'))
endfunction

function! textobj#motionmotion#select_a()
  return s:loop(s:readchar(), '', '', function('s:selectaaux'))
endfunction
