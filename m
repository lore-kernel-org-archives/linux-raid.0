From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: misunderstanding of spare and raid devices?
Date: Thu, 30 Jun 2011 11:58:40 +0100
Message-ID: <20110630105840.GA27551@cthulhu.home.robinhill.me.uk>
References: <4E0C5539.4030000@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E0C5539.4030000@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Karsten =?iso-8859-1?Q?R=F6mke?= <k.roemke@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jun 30, 2011 at 12:51:37 +0200, Karsten R=F6mke wrote:

> Hello,
> I'm searching some hours / minutes to create a raid5 device with 4
> disks and 1 spare:
> I tried first with the opensuse tool but no success as I want, so I
> tried mdadm
>=20
> Try:
>   mdadm --create /dev/md0 --level=3D5 --raid-devices=3D4 --spare-devices=
=3D1
>   /dev/sda3 /dev/sdb2 /dev/sdc5 /dev/sdd5 /dev/sde5
>=20
> leads to
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active (auto-read-only) raid5 sdd5[5](S) sde5[4](S) sdc5[2] sdb2[1]=
 sda3[0]
>        13759296 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>=20
> 2 spares - I don't understand that.
>=20
That's perfectly normal. The RAID5 array is created in degraded mode,
then recovered onto the final disk. That way it becomes available for
use immediately, rather than requiring all the parity to be calculated
before the array is ready. As it's been started in auto-read-only mode
(not sure why though) then it hasn't started recovery yet. Running
"mdadm -w /dev/md0" or mounting the array will kick it into read-write
mode and start the recovery process.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk4MVt8ACgkQShxCyD40xBJp/wCgml3UZfB+thdEBjCyNl0ZF+Kz
SmkAoKFNyEuEcyZYQaGm/pkulUm0W/FW
=Tkue
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
