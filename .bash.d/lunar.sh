llpatch() {
  scp $* lunar-linux.org:/var/ftp/pub/lunar/patches/
}

zlocalapply() {
  CURMOD=`basename $PWD`
  MBDIR=`dirname $PWD | sed -r 's;(.*moonbase-(core|efl|gnome|kde|other|xfce|xorg)).*;\1;'`
  lvu diff $CURMOD | ( cd $MBDIR ; patch -p1)
}

unpack() {
  if [ "$UID" = "0" ]; then
    lget $1
  fi
  lsh "run_details $1; unpack \$SOURCE"
}

# module completion for unpack using existing completion provided by Lunar
complete -F _lunar_comp_modules unpack

mo() {
  local branch repo

  if [ ! -d "$HOME/src/lunar/moonbase" ]; then
    mkdir -p "$HOME/src/lunar/moonbase"
  fi

  pushd "$HOME/src/lunar/moonbase" &> /dev/null

  for repo in core efl gnome kde other xfce xorg gnome3; do
    if [ ! -d $repo ]; then
      git clone git@github.com:lunar-linux/moonbase-${repo}.git $repo
    fi

    pushd $repo &> /dev/null
    branch=$(git rev-parse --abbrev-ref HEAD)
    if [[ -n "$1" && "$1" != "$branch" ]]; then
      git checkout $1
      branch=$1
    fi

    if [ "$branch" == "master" ]; then
      echo "+++ Updating $repo"
      git pull
    else
      echo "+++ Skipping $repo/$branch"
    fi
    popd &> /dev/null
  done
  cat */aliases > aliases
  popd &> /dev/null
}

export -f llpatch zlocalapply mo
