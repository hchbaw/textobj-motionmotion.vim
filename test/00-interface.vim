runtime! plugin/textobj/motionmotion.vim

Is 1 g:loaded_textobj_motionmotion

for n in ['<Plug>(textobj-motionmotion-a)', '<Plug>(textobj-motionmotion-i)']
  Ok maparg(n,'c')==''
  Ok maparg(n,'i')==''
  Ok maparg(n,'n')==''
  Ok maparg(n,'o')!=''
  Ok maparg(n,'v')!=''
endfor

enew!
put ='./runtime/doc/motion.txt'

normal! 16|
normal yamF/;
Ok @0==#'/doc/' 'select-a'

normal! 16|
normal yimF/2;
Ok @0==#'/doc/' 'select-i'

normal! 16|
normal yim3bt.
Ok @0==#'doc/motion' 'doc sample'


enew!
put ='text_objects'

normal! 2|
normal yimiwf_
Ok @0==#'text_' 'doc sample text-objects i'

normal! 2|
normal yimf_iw
Ok @0==#'_objects' 'doc sample text-objects a'
