From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm-3.2.5: segfault in "--grow --continue"
Date: Tue, 10 Jul 2012 23:02:05 +1000
Message-ID: <20120710230205.171ee562@notabene.brown>
References: <D6EAEC68-9C5B-4CBF-943C-85ABF3E319BD@tu-dresden.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QVyYN8YqCxE//gGsoXIooBU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D6EAEC68-9C5B-4CBF-943C-85ABF3E319BD@tu-dresden.de>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Hegler <sebastian.hegler@tu-dresden.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/QVyYN8YqCxE//gGsoXIooBU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Jul 2012 12:46:19 +0200 Sebastian Hegler
<sebastian.hegler@tu-dresden.de> wrote:

> Hi!
>=20
> I had to shut down a server with a raid grow operation (cleanly). After s=
ome hassles I got the array assembled again (manually), but it would not co=
ntinue to grow. When trying=20
>=20
> mdadm --grow --continue /dev/md127=20
>=20
> (as per the manpage) I receive a segfault. Compiling from source, and usi=
ng gdb, I see:
>=20
> root@kuiper:~/mdadm-3.2.5# gdb ./mdadm=20
> [SNIP]
> Reading symbols from /root/mdadm-3.2.5/mdadm...done.
> (gdb) set args --grow --continue /dev/md127=20
> (gdb) run=20
> Starting program: /root/mdadm-3.2.5/mdadm --grow --continue /dev/md127=20
>=20
> Program received signal SIGSEGV, Segmentation fault.
> Grow_continue_command (devname=3D0x7fffffffe8cc "/dev/md127", fd=3D7, bac=
kup_file=3D0x0, verbose=3D0) at Grow.c:4118
> 4118		if (verify_reshape_position(content,
> (gdb) bt
> #0  Grow_continue_command (devname=3D0x7fffffffe8cc "/dev/md127", fd=3D7,=
 backup_file=3D0x0, verbose=3D0) at Grow.c:4118
> #1  0x0000000000407ac2 in main (argc=3D4, argv=3D0x7fffffffe678) at mdadm=
.c:1701
>=20
>=20
>=20
> The same bug is present in the git repository, but another location:
>=20
> root@kuiper:~/mdadm.git# gdb ./mdadm=20
> [SNIP]
> Reading symbols from /root/mdadm.git/mdadm...done.
> (gdb) set args --grow --continue /dev/md127=20
> (gdb) run=20
> Starting program: /root/mdadm.git/mdadm --grow --continue /dev/md127=20
>=20
> Program received signal SIGSEGV, Segmentation fault.
> Grow_continue_command (devname=3D0x7fffffffe8d0 "/dev/md127", fd=3D7, bac=
kup_file=3D0x0, verbose=3D0) at Grow.c:4086
> 4086		if (verify_reshape_position(content,
> (gdb) bt
> #0  Grow_continue_command (devname=3D0x7fffffffe8d0 "/dev/md127", fd=3D7,=
 backup_file=3D0x0, verbose=3D0) at Grow.c:4086
> #1  0x0000000000406c39 in main (argc=3D4, argv=3D0x7fffffffe678) at mdadm=
.c:1447
>=20
>=20
> I also filed a bug against Debian's BTS, but I did not receive a bug numb=
er yet. In the meantime, I'd be very happy about any information on how to =
get my RAID array back into growing. I'm not on the list, please CC me.
>=20


--grow --continue should only be needed if the array was assembled with
--freeze-reshape (I think).

Normally, the reshape should continue automatically.

cat /proc/mdstat
mdadm -E ....
mdadm -D ...

would be helpful, maybe together with kernel logs if there are any.

NeilBrown

--Sig_/QVyYN8YqCxE//gGsoXIooBU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/wnzTnsnt1WYoG5AQLBzw//ZJGrs62lRVmcC7sioQ90pMBwsM+9sZfE
JjhQ2Qi1QLD1m0oopsBgOydOMWsAZFQUdtj+B0oCoAuyPotEPGR3cMK82KtlrcFx
C4uqsJHZoaHL+22bVRmxCvJQv1zPZr/aaU829jJOB4Cx1IokwuXrNpErsB9V6Hyb
j25/Gc7mf6/FJZuC84ecJr/Vc8kTBQM3XI/1EbZu25biqnPiCb2XxmtSq8CxjlqX
dY+P14E9JVQ+5UxTClk29+z7iEM1rtZuKDHlXawMA/zmT2bwcseXgKMGLhjH+ZKa
y/LZIejX74oIyIj4m8HThNtSLojQmNIClkhB7IZ+G/umB62TQ2q01RB77QGYVhbk
/mMZOLy8fjCx0BbHWzheQ8vRJJjCb269/h3euAJLRefZAAC6ZJVZmoz1ebS810nT
3CDDXecb36glI7hIM8JosUgqybW1lWJcmL1mxVeikUC8mhep87IOkR3IFoWek/RB
ouV3M5TCDVYNuWoMsAK7QBN+uANQOa92JmmbXorrrClJ/7gb/NSrSo9YgH2AfZfk
7KxOtUUOOg3qh/KfzPurFIZXn/UStqQrxpBH3KpJSQOllnCgnAUAUt0vf/DnO+Nq
KBZyuSDa22pkQdDsGFllq7E8iFIkay3t8c0cavpzRVHnQlW+LgsZ0b3Enn2B50PU
KLfnTvL07hk=
=Xt7M
-----END PGP SIGNATURE-----

--Sig_/QVyYN8YqCxE//gGsoXIooBU--
