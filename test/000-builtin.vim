let s:i = 0
let s:s = ""
function! s:t_stubreadchar(string)
  let s:i = 0
  let s:s = a:string
  function! s:readchar()
    let ret = s:s[s:i]
    let s:i += 1
    return ret
  endfunction
endfunction

function! s:t_motionlist(m1, m2)
  return [a:m1, a:m2]
endfunction

function! s:testloopfail(input)
  call s:t_stubreadchar(a:input)
  let r = s:loop(s:readchar(), '', '', function('s:t_motionlist'))
  Is 0 r
endfunction

call s:testloopfail("ai")
call s:testloopfail("ia")

function! s:testloop(input, em1, em2)
  call s:t_stubreadchar(a:input)
  let ms = s:loop(s:readchar(), '', '', function('s:t_motionlist'))
  let in = strtrans(a:input)
  execute printf('Isnt ms 0 "%s"', in)
  execute printf('Is ms [a:em1, a:em2] "%s"', in)
endfunction
