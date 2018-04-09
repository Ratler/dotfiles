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
    lget systemd
  fi
  lsh "run_details $1; unpack \$SOURCE"
}

# module completion for unpack using existing completion provided by Lunar
complete -F _lunar_comp_modules unpack


export -f llpatch zlocalapply
