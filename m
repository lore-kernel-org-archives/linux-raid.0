From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid10 layout
Date: Wed, 18 Nov 2009 14:04:13 +0000
Message-ID: <20091118140413.GE17713@cthulhu.home.robinhill.me.uk>
References: <20091118133803.GH1863@voyageur.mas.nom.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PGNNI9BzQDUtgA2J"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091118133803.GH1863@voyageur.mas.nom.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--PGNNI9BzQDUtgA2J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Nov 18, 2009 at 02:38:03PM +0100, Erwan MAS wrote:

> Hello ,
>=20
> I use md rai10 in 3 configurations :
> - with 2 devices in f2 layout
> - with 3 devices in f2 layout
> - with 4 devices in f2 layout
>=20
> With the help of ( http://en.wikipedia.org/wiki/Non-standard_RAID_levels#=
Linux_MD_RAID_10 ) ,=20
> i had validated the layout for 2 / 3 devices .
> Aka i read the block on the md device an i compare to each block on each =
physical devices .
>=20
> With my configuration with 4 devices , the comparaison does not work .
>=20
> Can someone explain me how to calculate the position of each chunk ?
>=20
>=20
> My output of my md device :
>=20
> /dev/md2:
>         Version : 00.90.03
>   Creation Time : Sun Jul  5 17:08:11 2009
>      Raid Level : raid10
>      Array Size : 527348736 (502.92 GiB 540.01 GB)
>   Used Dev Size : 263674624 (251.46 GiB 270.00 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 2
>     Persistence : Superblock is persistent
>=20
>     Update Time : Wed Nov 18 14:35:41 2009
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : near=3D1, far=3D2
>      Chunk Size : 256K
>=20
>            UUID : e383a648:2d866213:bef1cd83:48bb11be
>          Events : 0.7603331
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        3        0      active sync   /dev/sda3
>        1       8       35        1      active sync   /dev/sdc3
>        2       8       19        2      active sync   /dev/sdb3
>        3       8       51        3      active sync   /dev/sdd3
>=20
My understanding is that the layout should be (using your ordering):

A C B D
1 2 3 4
5 6 7 8
=2E . . .
=2E . . .
4 1 2 3
8 5 6 7
=2E . . .
=2E . . .

Allowing the loss of A & B, or C & D.

Is this not what you're seeing on-disk?

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--PGNNI9BzQDUtgA2J
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAksD/twACgkQShxCyD40xBLxNACfY3jD6xXleIQx7W6WuDAw8U79
/VcAoNsF3i8nWfmiKMC3wxNaAKkkUl8u
=m7sB
-----END PGP SIGNATURE-----

--PGNNI9BzQDUtgA2J--
