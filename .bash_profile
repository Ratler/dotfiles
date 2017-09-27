# .bash_profile - the per-user bash interactive shell customization file
# you can use this file to customize your bash's behaviour

# note we DO NOT source /etc/profile here, since it has already been
# executed when this file is processed.

# The user is encouraged to enter these values, so we
# put em on top of this file so they are easy to spot:

# export DEFAULTKDE=
# EDITOR=
# LANG=
export HISTSIZE=10000
HOST_TYPE=$(uname -s)

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

[ -z "$EDITOR" ] && {
    # an editor has not been set, go find a decent one, the last one
    # found in the row is picked and set.
    [ -x /usr/bin/pico  ] && EDITOR="pico"
    [ -x /usr/bin/nano  ] && EDITOR="nano"
    [ -x /usr/bin/elvis ] && EDITOR="elvis"
    [ -x /usr/bin/vi    ] && EDITOR="vi"
    [ -x /usr/bin/vim   ] && EDITOR="vim"
    [ -x /usr/bin/emacs ] && EDITOR="emacs"
    }

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

export EDITOR
export XDG_CONFIG_HOME=$HOME/.config

# Load all custom bash functions
for func in $HOME/.bash.d/*.sh; do
  . $func
done

# Start the gpg-agent if not already running
if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
  gpg-connect-agent /bye >/dev/null 2>&1
fi

if [ "$HOST_TYPE" == "Linux" ]; then
  export SSH_AUTH_SOCK=${SSH_AUTH_SOCK:-/run/user/1000/gnupg/S.gpg-agent.ssh}
elif [ "$HOST_TYPE" == "Darwin" ]; then
  export SSH_AUTH_SOCK=/Users/$USER/.gnupg/S.gpg-agent.ssh
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
