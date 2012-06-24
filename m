From: NeilBrown <neilb@suse.de>
Subject: Re: linux-image-2.6.32-5-686: kernel BUG at ...
 build/source_i386_none/drivers/md/raid5.c:2764!
Date: Sun, 24 Jun 2012 18:21:46 +1000
Message-ID: <20120624182146.7d63fbbb@notabene.brown>
References: <20120622121953.GA25149@calhariz.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YV4ylXbyJf_zIWj4bBT+duX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120622121953.GA25149@calhariz.com>
Sender: linux-raid-owner@vger.kernel.org
To: jose.spam@netvisao.pt
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YV4ylXbyJf_zIWj4bBT+duX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Jun 2012 13:19:53 +0100 Jose Manuel dos Santos Calhariz
<jose.spam@netvisao.pt> wrote:

>=20
> In another day during the periodic mdadm RAID check:=20
>  - the linux kernel gave a kernel BUG,=20
>  - tried to kick out a failed disk and=20
>  - stopped accepting I/O to the affected raid. =20
>=20
> The affected programs were in state D.  The only way to recover was to
> do a reboot.  After reboot the problematic disk was replaced.
>=20
> I reported the bug to Debian and is there all the information about it:
>=20
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D675969
>=20
> I was asked to report the BUG here in case someone knows what happened.
>=20
> Here is a summary of the more relevant information:
>=20
> This machine have 2 x RAID6 with 6 disks each, for a total of 12 disks.=20
>=20
> I have 5 systems with a similar setup and only one failed, maybe
> because of the failing disk.  I will use one of the systems to try to
> reproduce the bug, before triyng a new kernel.
>=20
>=20
> The proprietary module is the openafs filesystem v1.6.1 backported
> from Debian testing.
>=20
> The kernel bug is:
>=20
>=20
> build/source_i386_none/drivers/md/raid5.c:2764!

This bug was fixed in 2.6.32.49 and 3.2

http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dcom=
mitdiff;h=3D61d433c479a6ccfed6a7e73e6111ca8fa0348c63

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcommitdi=
ff;h=3D9a3f530f39f4490eaa18b02719fb74ce5f4d2d86

NeilBrown

--Sig_/YV4ylXbyJf_zIWj4bBT+duX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+bOGjnsnt1WYoG5AQIQkw/+N04H/QZvmdzqpiMYlCVbdAXAvVR9HN+K
FH+CRom++y4AdfPmEYLHRiPSvL5vBqm38cVw8ApdtcBqZF3sGLd0Z4p5zPgphIqr
H0T6+YSeYOBwoR73TX2PqCfClxf8orz9dxZJwzFuVClNfk60TDFXbmOZO+RMVnTY
6RDpqKwhuRODo19TjrdVgwiLhbM0qoUEEvWT4dbO7jh0xK9Hzd3oO/SEY6egzzaW
mUD8pvTzrgDNsSB3tymS8h49uMqHoF7NX0p/FRslkM3GDxvBCQ+9pbyZ2ZAn16LE
kkrMTWxYhHr/b5jh3NUFbobj5nfblsr9xoSQ9jl6+7DCEEauriR4IjpztScVAjWO
XtgIY1LNNX7VFq4N2pTcx/slrOBZhxn2kMZ654Ti8h5Fmy92uuBNINL2kp6/+fHn
olmodeTOYckSl37Nf4H98bdQnoky4Pd0g8BlXR/O2q0eVfIRnaoNasVPnsaGLRJP
IV9xkrrH/dc5aj0ShIvSCi3g0DIGyaAK7z0RLK+yW6tnoS3jKrxpQfiiajnTY+I3
2ihG44/SI0/Bx5c+DyfsEAT7S1dVC2mA+HlhXz0JEjZBjjZy2Bl6FOyDxE2Bo401
ZEo7aBoH+Wg5+l7qB6x9TP6FfvCMgMp5385lhMnOUd9c4Yc8aalAX59lg+oU+WCx
S+BZmwM+xlE=
=bThp
-----END PGP SIGNATURE-----

--Sig_/YV4ylXbyJf_zIWj4bBT+duX--
