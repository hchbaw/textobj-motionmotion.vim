" textobj-motionmotion - Text objects for bounds of 2 motions
" Version: 0.0.2.1
" Author: Takeshi Banse <takebi@laafc.net>
" Licence: Public Domain

if exists('g:loaded_textobj_motionmotion')
  finish
endif

call textobj#user#plugin('motionmotion', {
\      '-': {
\        'select-i': 'im',
\        '*select-i-function*': 'textobj#motionmotion#select_i',
\        'select-a': 'am',
\        '*select-a-function*': 'textobj#motionmotion#select_a'
\      }
\    })

let g:loaded_textobj_motionmotion = 1
