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
eval $(dircolors -b $HOME/.DIR_COLORS)

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

if grep -q 'ID=lunar' /etc/os-release; then
  # Now we can set package specific paths and variables:
  for RC in /etc/profile.d/*.rc ; do
    # note we can set the permissions for root-specific scripts:
    [ -r $RC ] && . $RC
  done
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

if [ "$(uname -s)" == "Linux" ]; then
  export SSH_AUTH_SOCK=${SSH_AUTH_SOCK:-/run/user/1000/gnupg/S.gpg-agent.ssh}
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
