From: NeilBrown <neilb@suse.de>
Subject: Re: tracking parity mismatches to a failing disk
Date: Mon, 4 Jun 2012 14:17:04 +1000
Message-ID: <20120604141704.12dcbd3e@notabene.brown>
References: <4FAAC278.6080303@duke.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WQwYtvYU3rrevWYl2aJTOYq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAAC278.6080303@duke.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Peterson <Michael.Peterson@duke.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WQwYtvYU3rrevWYl2aJTOYq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 09 May 2012 15:16:08 -0400 Michael Peterson
<Michael.Peterson@duke.edu> wrote:

> I'm trying to identify the source of a non-zero mismatch_cnt on a
> six-disk RAID6 md array.  I think I've identified it as /dev/sdf since
> that is the only device with a non-zero value in
> /sys/block/md0/md/dev-sd*/errors.  Is that the right way to track parity
> mismatches back to a disk?
>=20
> OS is CentOS 5.8 -> mdadm 2.6.9

There is a program in the mdadm source distro called "raid6check" which can
possibly help you.

NeilBrown

--Sig_/WQwYtvYU3rrevWYl2aJTOYq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8w2wDnsnt1WYoG5AQLRaRAAk7xWp7GumY5sCzmRMqsYUrjVEwGVG7Kq
JG6OW28EFrXf5fkLC0aePbRjxUjRx0PqZipe2VAYnCVZGijgT/CPr0MgG2WpQr4C
oLzcOu7/A0SoDMez2lXmo7lgpIDQu8JtLPzYgHw6X+tq8ooU/f9FVtgaHu3g7uHr
I8FVid2XoAZBSbqgdjR+mT6lLd7AKtsSzTDnxarXdcLd0Wor2HgMsv1s/8mUsmJz
29bnQpjttXS+mEERYQ7L6XcDfDvcIZ0LDPst26yMCtH3fa3yfX7T1p1q1Lxw5bYp
Z5pC+MaZXn/w3+Ibbg9Y2QbzdwGYHtt/NG22eJOKUHm4GgVNp61uKEMQxsPnsN8W
ivfOBJcbKTqES2t22uljt6pg6vdCKN6aOpMCcCWvjKOy5kZuU+wOs/k/P9QQ9hkx
1camdbHjD+6HWouXx2p8zS7V1lze3Y14S1pRg7vf4lBFvo8NnfHRS8e2OWVyd6HZ
gSdLYcp059G3XvuR5hTI8pUV+QiGodC/bjzW7tAK4KUrY0AQQPGQhSphBfxpwz7x
1szTmljhc2nQPOLpWmnIRQ1ICPVs1MJP4sdesMml5mb+btH4yEtrpyuVFVu9YiaL
zHn/vwGYoP1JLGps9VQk/ju6i1O71yPTZfymGgBG5zdadyI77bdm0RIvlJ+Sd3L+
tuiEKtlO2Yc=
=pwKp
-----END PGP SIGNATURE-----

--Sig_/WQwYtvYU3rrevWYl2aJTOYq--
