From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Add a spare to a poorly defined raid1
Date: Wed, 15 Feb 2012 12:44:38 +0000
Message-ID: <20120215124438.GA18336@cthulhu.home.robinhill.me.uk>
References: <4F3BA338.6030204@cogweb.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F3BA338.6030204@cogweb.net>
Sender: linux-raid-owner@vger.kernel.org
To: David Liontooth <lionteeth@cogweb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Feb 15, 2012 at 05:51:12 +0530, David Liontooth wrote:

>=20
> Not knowing what I was doing, I created a RAID1 with a single drive and=
=20
> a spare, as below.
>=20
> I'd like to add the spare to the array. How do I do this without rebootin=
g?
>=20
> Cheers,
> Dave
>=20
>=20
> # definitions of existing MD arrays
> ARRAY /dev/md0 level=3Draid1 num-devices=3D1=20
> UUID=3D9921faab:5d93510e:0db287f1:dc103b07
>     spares=3D1
>=20
> # mdadm --detail /dev/md0
> /dev/md0:
>          Version : 0.90
>    Creation Time : Fri Jul 18 14:57:40 2008
>       Raid Level : raid1
>       Array Size : 104320 (101.89 MiB 106.82 MB)
>    Used Dev Size : 104320 (101.89 MiB 106.82 MB)
>     Raid Devices : 1
>    Total Devices : 2
> Preferred Minor : 0
>      Persistence : Superblock is persistent
>=20
>      Update Time : Wed Feb 15 03:37:11 2012
>            State : clean
>   Active Devices : 1
> Working Devices : 2
>   Failed Devices : 0
>    Spare Devices : 1
>=20
>             UUID : 9921faab:5d93510e:0db287f1:dc103b07
>           Events : 0.218
>=20
>      Number   Major   Minor   RaidDevice State
>         0       8        1        0      active sync   /dev/sda1
>=20
>         1       8       17        -      spare   /dev/sdb1
>=20

That's a straightforward one - you just need to increase the number of
active members in the array:

    mdadm --grow /dev/md0 -n 2

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk87qLUACgkQShxCyD40xBJTSACeI0XwRPFqacn0L4ER9ctOrBqr
VLQAoNQtPp74AQjNMxlTvS24azF4JeHn
=F3kZ
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
