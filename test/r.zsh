#!zsh

set -e

test="${1:A}"

rtp="${0:A:h:h}"
vimd="${0:A:h:h:h}"
vimtapdir="${vimd}/vimtap"
vimtxtobjuserdir="${vimd}/vim-textobj-user"
( \
  cd "$vimtapdir" && \
  sh ./vtruntest.sh "${vimtxtobjuserdir},$(pwd),${rtp}" "${test}" \
)
