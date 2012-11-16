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

function! s:loop(c, acc, m1, sk)
  return s:loopbuiltin(a:c, a:acc, a:m1,
  \ function('s:nullmotionp'),
  \ function('s:builtinmotionfn'), function('s:builtintextobjectsfn'), a:sk)
endfunction

" basically just dumped out the quickref.txt
" TODO: /?
" TODO: mapped motions
" TODO: :
" TODO: less ugliness
" XXX: make vim do this (some kind of g@), but I have no clue unfortunately.
function! s:loopbuiltin(c, acc, m1, mpred, genb, gent, sk)
  " Q_lr
  if     a:acc == '' && (a:c ==# '0' || a:c ==# '^')
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  " XXX: [count]
  elseif s:readcountp(a:acc) && s:readcountp(a:c)
    return s:loop(s:readchar(), a:acc . a:c, a:m1, a:sk)
  elseif a:acc =~# 'g$' &&
  \      (a:c ==# '0' || a:c ==# '^' || a:c ==# '$' || a:c ==# 'm')
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  elseif s:readcountp(a:acc) &&
  \      (a:c ==# 'h' || a:c ==# 'l' || a:c ==# '$' || a:c ==# '|' ||
  \       a:c ==# ';' || a:c ==# ',')
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  elseif s:readcountp(a:acc) &&
  \      (a:c ==# 'f' || a:c ==# 'F' || a:c ==# 't' || a:c ==# 'T')
    return s:builtinmaybe(s:readchar(), a:acc . a:c, a:m1, a:mpred, a:genb,
    \  a:gent, a:sk)
  " Q_ud
  elseif a:acc =~# 'g$' &&
  \      (a:c ==# 'g' || a:c ==# 'k' || a:c ==# 'j')
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  elseif s:readcountp(a:acc) &&
  \      (a:c ==# 'k' || a:c ==# 'j' || a:c ==# '-' || a:c ==# '+' ||
  \       a:c ==# '_' || a:c ==# 'G' || a:c ==# '%')
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  " Q_tm
  elseif a:acc =~# 'g$' &&
  \      (a:c ==# 'e' || a:c ==# 'E')
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  elseif (a:acc =~# '\]$' || a:acc =~# '\[$') &&
  \      (a:c ==# ']' || a:c ==# '[' || a:c ==# '(' || a:c ==# '{' ||
  \       a:c ==# 'm' || a:c ==# 'M' || a:c ==# ')' || a:c ==# '}' ||
  \       a:c ==# '#' || a:c ==# '*')
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  elseif s:readcountp(a:acc) &&
  \      (a:c ==# 'w' || a:c ==# 'W' || a:c ==# 'e' || a:c ==# 'E' ||
  \       a:c ==# 'b' || a:c ==# 'B' || a:c ==# ')' || a:c ==# '(' ||
  \       a:c ==# '}' || a:c ==# '{')
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  " g[]
  elseif s:readcountp(a:acc) &&
  \      (a:c ==# 'g' || a:c ==# ']' || a:c ==# '[')
    return s:loop(s:readchar(), a:acc . a:c, a:m1, a:sk)
  " Q_pa
  " TODO: /?
  elseif s:readcountp(a:acc) &&
  \      (a:c ==# 'n' || a:c ==# 'N' || a:c ==# '*' || a:c ==# '#')
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  elseif a:acc =~# 'g$' &&
  \      (a:c ==# '*' || a:c ==# '#' || a:c ==# 'd' || a:c ==# 'D')
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  " Q_ma
  elseif a:acc == '' && (a:c ==# 'm' || a:c ==# '`' || a:c ==# "'")
    return s:loop(s:readchar(), a:acc . a:c, a:m1, a:sk)
  elseif a:acc ==# 'm' && a:c =~# '[a-zA-Z]'
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  elseif a:acc =~# "[`']$" && a:c =~# "[a-zA-Z0-9\\]\[`'\"\<\>.]"
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  elseif s:readcountp(a:acc) && (a:c == "\<C-o>" || a:c == "\<C-i>")
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  " Q_vm
  elseif a:acc == '' && (a:c == '%' || a:c == 'M')
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  elseif s:readcountp(a:acc) && (a:c ==# 'H' || a:c == 'L')
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  elseif a:acc =~# 'g$' && a:c ==# 'o'
    return s:builtinmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent, a:sk)
  " Q_ta
  " XXX: Does it make sense?
  " text-objects
  " XXX: urgh... What is the [count]ed text-object?
  elseif a:acc == '' && (a:c ==# 'i' || a:c ==# 'a')
    return s:loop(s:readchar(), a:acc . a:c, a:m1, a:sk)
  elseif (a:acc ==# 'i' || a:acc ==# 'a') &&
  \      (a:c ==# 'w' || a:c ==# 'W' || a:c ==# 's' || a:c ==# 'p' ||
  \       a:c ==# ']' || a:c ==# '[' ||
  \       a:c ==# ')' || a:c ==# '(' || a:c ==# 'b' ||
  \       a:c ==# '>' || a:c ==# '<' ||
  \       a:c ==# 't' ||
  \       a:c ==# '}' || a:c ==# '{' || a:c ==# 'B' ||
  \       a:c ==# '"' || a:c ==# "'" || a:c ==# '`')
    return s:builtintextobjectsmaybe(a:c, a:acc, a:m1, a:mpred, a:genb, a:gent,
    \ a:sk)
  endif
endfunction

function! s:nullmotionp(motionish)
  return type(a:motionish) != 2
endfunction

function! s:builtinmaybe(c, acc, m1, mpred, genb, gent, sk)
  if a:mpred(a:m1)
    return s:loop(s:readchar(), '', a:genb(a:acc . a:c, 1), a:sk)
  else
    return a:sk(a:m1, a:genb(a:acc . a:c, 2))
  endif
endfunction

function! s:builtinmotionfn(keyseq, firstorsecond)
  let fnname = "s:builtinmotion" . a:firstorsecond
  execute printf("function! %s()\n"
  \ . "  execute \"normal! \" . \"%s\"\n"
  \ . "endfunction\n", fnname, a:keyseq)
  return function(fnname)
endfunction

function! s:builtintextobjectsmaybe(c, acc, m1, mpred, genb, gent, sk)
  let keyseq = 'g@' . a:acc . a:c
  if a:mpred(a:m1)
    return s:loop(s:readchar(), '', a:gent(keyseq, 1), a:sk)
  else
    return a:sk(a:m1, a:gent(keyseq, 2))
  endif
endfunction

function! s:builtintextobjectsfn(keyseq, firstorsecond)
  let fnname = "s:builtintextobjects"
  execute printf("function! %s()\n"
  \ . "  let &operatorfunc='textobj#motionmotion#textobjoperator%d'\n"
  \ . "  execute \"normal! \" . \"%s\"\n"
  \ . "endfunction\n", fnname, a:firstorsecond, a:keyseq)
  return function(fnname)
endfunction

function! textobj#motionmotion#textobjoperator1(_type)
  normal! g`[
endfunction

function! textobj#motionmotion#textobjoperator2(_type)
  normal! g`]
endfunction

function! s:selectraw(m1, m2, proc)
  let cur = getpos('.')
  call a:m1()
  let beg = getpos('.')
  call a:proc(cur, beg, a:m1, a:m2)
  call a:m2()
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
