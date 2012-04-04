From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 check does not read disk media
Date: Thu, 5 Apr 2012 09:45:55 +1000
Message-ID: <20120405094555.7779a2a6@notabene.brown>
References: <4F7C4B46.2090209@urbanec.net>
	<CADNH=7HbC4M0obMV=nGNVWcH3vJT+nug725om+K7ocvk8=bPxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/U9cX7tGvkV2O0AY2ENKCerw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7HbC4M0obMV=nGNVWcH3vJT+nug725om+K7ocvk8=bPxw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: Peter Urbanec <linux-raid@urbanec.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/U9cX7tGvkV2O0AY2ENKCerw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Apr 2012 14:51:52 +0100 Mathias Bur=C3=A9n <mathias.buren@gmail.c=
om>
wrote:

> On 4 April 2012 14:23, Peter Urbanec <linux-raid@urbanec.net> wrote:
> > I'm running Gentoo kernel 3.3.0 with raid5 on four ICH7 AHCI connected
> > Seagate 2TB 7200RPM disks. I also have two WD 1TB Green disks in raid1 =
on a
> > Sil3114 with a JBOD (non-RAID) BIOS.
> >
> > When I attempt to do a scrub/check on the raid5, the check seems to pro=
ceed
> > without actually reading any data from the disks - the disk activity li=
ghts
> > do not even flicker.
> >
> > Looking at the speed at which the check completes confirms this:
> >
> > # cat /proc/sys/dev/raid/speed_limit_min
> > 10000
> > # cat /proc/sys/dev/raid/speed_limit_max
> > 4000000
> > # echo check > devices/virtual/block/md0/md/sync_action
> > # echo check > devices/virtual/block/md127/md/sync_action
> > ...
> > # cat /proc/mdstat
> > Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4]
> > md127 : active raid1 sdf1[1] sde1[0]
> > =C2=A0 =C2=A0 =C2=A0976760384 blocks [2/2] [UU]
> > =C2=A0 =C2=A0 =C2=A0[>....................] =C2=A0check =3D =C2=A01.7% =
(17387072/976760384)
> > finish=3D380.7min speed=3D41994K/sec
> >
> > md0 : active raid5 sdb[1] sda[0] sdd[4] sdc[2]
> > =C2=A0 =C2=A0 =C2=A05860535808 blocks super 1.2 level 5, 512k chunk, al=
gorithm 2 [4/4]
> > [UUUU]
> > =C2=A0 =C2=A0 =C2=A0[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D>..] =C2=A0check =3D 93.9% (1835359616/1953511936)
> > finish=3D0.8min speed=3D2332893K/sec
> >
> >
> > raid1 runs at about 42MB/s as expected with two WD 1TB Green drives.
> > raid5 runs at well over 2GB/s - not really possible with four Seagate 2=
TB
> > 7200RPM drives.
> >
> > Any ideas on what may be going on there and how to fix it. Let me know
> > what/if more information may be needed.
> >
> > Thanks
> >
> > =C2=A0 =C2=A0Peter Urbanec
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>=20
> FWIW I'm seeing this as well, kernel 3.3.1, but on RAID6. There's a
> message just a few days about this, but no link to a patch.

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcommitdi=
ff;h=3Dc6d2e084c7411f61f2b446d94989e5aaf9879b0f

NeilBrown

>=20
> Mathias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/U9cX7tGvkV2O0AY2ENKCerw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3zdMznsnt1WYoG5AQL8ow//XVVLo9ohQo/RF0JqRC/wqRDhIAmcT/rw
8vzs83su5aNrzPW11RxpvekGsQmr58rqYkaNhh9D4gVqOG2lqFQYOEVlDlujixLr
xP3O7kcQmF0k0AUi1pI7KcaZ6vaoxI1F0HXCtEZIERlyo5npYa3JJ2+K364dadfV
aHUDXQqHQckkD5Yo6L9MmohLCQZbneW6A38Zd46u3wl9udl9WpbffamKdO3WE9xt
aN21JPF4n3TOlq6cKciGp8qalhhjOByYIS8JaIa6U7FxKecm6B2sZ2b+7uQpUIdR
qrFgXAWsPKXOJsXGWxnVvEs4IZp4a80nunm7G3tA030/ZKOJORKR6LxPe5AfYvj4
MkVy9xwneLG9L5mmMGbXsUo2p/XYe6oe9g1q6Gy61u0727uV7m0EKo1PR3Z5n9vY
KPDOtmDotZYRGgPyhmFR1fv5Gp9Zepsbz3cGCzSyJzx3+Bo6bpmjkmyHgiiMMjtl
G0s0M/ouG2Fv1isUTacuz148WGdU6NFcz4OeE8JdaXOvglSExX4AnFwegQP3qKRU
O1LFJ5MBtWaxrR3avvt6JSUlUnFv95wvNVPzpj+v3OHnrwOxI5ZtC89znHlVbFQp
f8MjJ1yl3KvwTCqTeyM3ffLAKVjx6TJ9Vou97XJniU0KaT9oKGRw0843vMoyQGRl
roAJbMegdNI=
=4Vqn
-----END PGP SIGNATURE-----

--Sig_/U9cX7tGvkV2O0AY2ENKCerw--
