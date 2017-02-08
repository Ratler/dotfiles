llpatch () {
  scp $* lunar-linux.org:/var/ftp/pub/lunar/patches/
}

zlocalapply () {
  CURMOD=`basename $PWD`
  MBDIR=`dirname $PWD | sed -r 's;(.*moonbase-(core|efl|gnome|kde|other|xfce|xorg)).*;\1;'`
  lvu diff $CURMOD | ( cd $MBDIR ; patch -p1)
}

export -f llpatch zlocalapply
