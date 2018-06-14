alias git="hub"
alias g="hub"
alias gbr="git branch"
alias gco="git checkout"
alias gcam="git commit -a -m "
alias gcm="git commit -m "
alias gp="git pull"
alias gm="git merge"
alias grev="git rev-parse HEAD | cut -c -7"
alias gs="git status -s"

if test -f /usr/share/bash-completion/completions/git; then
  . /usr/share/bash-completion/completions/git
   __git_complete g __git_main
   __git_complete gco _git_checkout
   __git_complete gp _git_pull
   __git_complete gm _git_merge
fi
