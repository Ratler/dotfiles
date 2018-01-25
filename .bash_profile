# .bash_profile - the per-user bash interactive shell customization file
# you can use this file to customize your bash's behaviour

# note we DO NOT source /etc/profile here, since it has already been
# executed when this file is processed.

# The user is encouraged to enter these values, so we
# put em on top of this file so they are easy to spot:

# export DEFAULTKDE=
# EDITOR=
# LANG=
HOST_TYPE=$(uname -s)

if test -f "/etc/os-release"; then
  if grep -q 'ID=lunar' /etc/os-release; then
    # Now we can set package specific paths and variables:
    for RC in /etc/profile.d/*.rc ; do
      # note we can set the permissions for root-specific scripts:
      [ -r $RC ] && . $RC
    done
  fi

  if grep -q 'ID=arch' /etc/os-release && test -d /etc/profile.d/; then
    for profile in /etc/profile.d/*.sh; do
      test -r "$profile" && . "$profile"
    done
    unset profile
  fi
fi

if [ "$HOST_TYPE" == "Darwin" ]; then
  export LANG="en_US.UTF-8"
  export LC_CTYPE="en_US.UTF-8"
  export CLICOLOR=1
  export LSCOLORS=gxGxcxdxcxegedhbhbacgx

  if type brew &> /dev/null; then
    BREWPREFIX=$(brew --prefix)

    for c in $BREWPREFIX/etc/bash_completion.d/git-completion.bash \
             $BREWPREFIX/etc/bash_completion.d/git-prompt.sh \
             $BREWPREFIX/etc/bash_completion; do
      test -f "$c" && . $c
    done
  fi
else
  eval $(dircolors -b $HOME/.DIR_COLORS)
fi

if type systemctl &> /dev/null && systemctl is-enabled --user emacs &> /dev/null; then
  EDITOR="emacsclient -c"
  alias emacs="$EDITOR"
fi

export EDITOR=${EDITOR:-emacs}
export XDG_CONFIG_HOME=$HOME/.config

# Load all custom bash functions
for func in $HOME/.bash.d/*.sh; do
  . $func
done

# Start the gpg-agent if not already running
if ! pgrep -x -u "${USER}" gpg-agent &> /dev/null; then
  gpg-connect-agent /bye &> /dev/null
fi

export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export PATH+=":$HOME/.git.d"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
