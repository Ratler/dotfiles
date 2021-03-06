alias git="hub"
alias g="hub"
alias gbr="git branch"
alias gco="git checkout"
alias gcam="git commit -a -m "
alias gcm="git commit -m "
alias gp="git pull --prune"
alias gup="git pull --rebase --prune"
alias gm="git merge"
alias grev="git rev-parse HEAD | cut -c -7"
alias gs="git status -s"

if test -f /usr/share/bash-completion/completions/git; then
  . /usr/share/bash-completion/completions/git
  _HAVE_GIT=1
elif test -f /usr/local/etc/bash_completion.d/git-completion.bash; then
  . /usr/local/etc/bash_completion.d/git-completion.bash
  _HAVE_GIT=1
fi

if [ "$_HAVE_GIT" -eq 1 ]; then
   __git_complete g __git_main
   __git_complete gco _git_checkout
   __git_complete gp _git_pull
   __git_complete gup _git_pull
   __git_complete gm _git_merge
fi
