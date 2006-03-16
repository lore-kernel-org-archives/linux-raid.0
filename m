From: Andre Noll <maan@systemlinux.org>
Subject: Re: A random initramfs script
Date: Fri, 17 Mar 2006 00:46:13 +0100
Message-ID: <20060316234613.GX27173@skl-net.de>
References: <87u0a0so6w.fsf@hades.wkstn.nix> <20060315002527.GO27173@skl-net.de> <87lkvcrtzu.fsf@hades.wkstn.nix> <20060315185750.GP27173@skl-net.de> <87hd5zs9zm.fsf@hades.wkstn.nix> <20060316002330.GT27173@skl-net.de> <87zmjqq14r.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LfQcPIWFRhGivmDw"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87zmjqq14r.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--LfQcPIWFRhGivmDw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07:50, Nix wrote:

> I suppose that if *every* filesystem hanging off / is its own
> fs, using rootfs as your / is not inefficient because there's
> still nothing in it.
>=20
> But it still makes me worry: what if some mad script makes a
> huge file in /? It's happened to me a couple of times, and
> because /var was on a different fs, all that happened was that
> / filled up and nothing bad resulted.

> If / was a ramfs (as rootfs is), you'd run out of memory...

Yes, it's an additional piece of rope, and I already used it to shoot
myself in the foot by doing a backup with "rsync -a /home /mnt" without
mounting /mnt. First the machine went slow, then the OOM killer kicked
in and killed everything. Finally the system was totally unresponsible
and I had to use the "so everything is unusual - boot" thing.

But only root can write to /mnt, and there are much simpler ways for
root to halt the system..

> [ip(8)]
> >> <http://lartc.org/> describes many of its myriad extra features in more
> >> detail.
> >=20
> > All that stuff seems to be fairly old, linux-2.6. isn't mentioned at
> > all and the cvs server doesn't work. Is it still up do date?
>=20
> Well, there's some extra stuff, but it's mostly on the iptables side:
> the advanced routing has mostly been stable since not just 2.4 but 2.2!

So I downloaded iproute2-2.4.7-now-ss020116-try.tar.gz, but there
seems to be a problem with errno.h:

make[1]: Entering directory `/home/work/install/src/iproute2/lib'
gcc -D_GNU_SOURCE -O2 -Wstrict-prototypes -Wall -g -I../include-glibc -I/us=
r/include/db3 -include ../include-glibc/glibc-bugs.h -I/home/install/w/linu=
x/stable/include -I../include -DRESOLVE_HOSTNAMES -c -o libnetlink.o libnet=
link.c
distcc[13445] ERROR: compile
/home/install/w/var/ccache/libnetlink.tmp.p133.13441.i on p133 failed
libnetlink.c: In function `rtnl_dump_filter':
libnetlink.c:149: error: `EINTR' undeclared (first use in this function)
libnetlink.c:149: error: (Each undeclared identifier is reported only once
libnetlink.c:149: error: for each function it appears in.)
libnetlink.c: In function `rtnl_talk':
libnetlink.c:248: error: `EINTR' undeclared (first use in this function)
libnetlink.c: In function `rtnl_listen':
libnetlink.c:350: error: `EINTR' undeclared (first use in this function)
libnetlink.c: In function `rtnl_from_file':
libnetlink.c:416: error: `EINTR' undeclared (first use in this function)
make[1]: *** [libnetlink.o] Error 1
make[1]: Leaving directory `/home/work/install/src/iproute2/lib'
make: *** [all] Error 2

> >> >> mdev is `micro-udev', a 255-line tiny replacement for udev. It's pa=
rt of
> >> >> busybox.
> >> >=20
> >> > Cool. Guess I'll have to update busybox..
> >=20
> > done. The new busybox (from SVN) seems to work fine, just like the
> > old one did. The init script doesn't use mdev yet, but from a first
> > reading this is just a matter of translating /etc/udev/udev.conf
> > to the mdev syntax.
>=20
> You don't need an mdev.conf at all; by default mdev creates a /dev with
> the KERNEL=3D names. All it's needed for is putting things in strange
> places or fiddling permissions, and that's not necessary for a boot
> initramfs :)

Nice, and works like a charm. I just removed udev* from the initramfs.

> (I'd recommend managing the *real* /dev with udev, still; it's vastly
> more flexible...=20

Yes, and it's needed for hotplugable devices anyway.

> but of course it's also about fifty times larger at a
> horrifying 50K plus 70K of rules...
=20
No need for such a huge rules file:

# find  /etc/udev/ -type f -printf '%f %s\n'
udev.conf 768
udev.rules 5200
scsi-model.sh 1326
ide-model.sh 1201

> >> You need SVN uClibc too (if you're using uClibc rather than glibc);
> >> older versions don't maintain the d_type field in the struct dirent, so
> >> mdev's scanning of /sys gets very confused and you end up with an empty
> >> /dev.
> >=20
> > Damn. I just compiled 0.9.28. Guess this one is too old.
>=20
> Yep. Of course the SVN release has broken binary compatibility, so you
> need to rebuild everything that depends on it (probably the
> cross-toolchain too, for safety). I scripted this long ago, of course,
> because it's a bit annoying otherwise...

I tried to built the cross-compilation toolchain with Buildroot,
but it didn't even start building because it couldn't download gcc
=66rom mirrors.rcn.net which appears to be down ATM. Isn't it possible
to change the gcc mirror? I did not find a config option for that.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--LfQcPIWFRhGivmDw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFEGfjFWto1QDEAkw8RArYHAJ4iVyxacZWLl5X1aZBLTITkM4JgRwCgnxk/
+XALjLg8+VOGZm7oRlweC1U=
=9W1r
-----END PGP SIGNATURE-----

--LfQcPIWFRhGivmDw--
