let s:i = 0
let s:s = ""
function! s:t_stubreadchar(string)
  let s:i = 0
  let s:s = a:string
  " REDEFINED!
  function! s:readchar()
    let ret = s:s[s:i]
    let s:i += 1
    return ret
  endfunction
endfunction

function! s:t_motionlist(m1, m2)
  return [a:m1, a:m2]
endfunction

function! s:t_builtinmotiongen(keyseq, firstorsecond)
  return a:keyseq
endfunction

function! s:t_builtintextobjectsgen(keyseq, firstorsecond)
  return a:keyseq
endfunction

function! s:t_nullmotionp(motionish)
  return a:motionish == ''
endfunction

" REDEFINED!
function! s:loop(c, acc, m1, sk)
  return s:loopbuiltin(a:c, a:acc, a:m1,
  \ function('s:t_nullmotionp'),
  \ function('s:t_builtinmotiongen'),
  \ function('s:t_builtintextobjectsgen'), a:sk)
endfunction

function! s:t_loopbuiltincall()
  return s:loopbuiltin(s:readchar(), '', '',
  \ function('s:t_nullmotionp'),
  \ function('s:t_builtinmotiongen'),
  \ function('s:t_builtintextobjectsgen'),
  \ function('s:t_motionlist'))
endfunction

function! s:testloopbuiltinfail(input)
  call s:t_stubreadchar(a:input)
  let r = s:t_loopbuiltincall()
  Is 0 r
endfunction

call s:testloopbuiltinfail("ai")
call s:testloopbuiltinfail("ia")

function! s:testloopbuiltin(input, em1, em2)
  call s:t_stubreadchar(a:input)
  let ms = s:t_loopbuiltincall()
  let in = strtrans(a:input)
  echo ms
  execute printf('Isnt ms 0 "%s"', in)
  execute printf('Is ms [a:em1, a:em2] "%s"', in)
endfunction
