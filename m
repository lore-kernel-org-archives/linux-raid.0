From: =?ISO-8859-1?Q?Torbj=F8rn?= Skagestad <torbjorn@itpas.no>
Subject: Re: Undestanding /proc/mdstat with raid10
Date: Tue, 09 Aug 2011 13:27:17 +0200
Message-ID: <1312889237.24693.15.camel@torbjorn>
References: <4E40DE3D.2020005@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-U1kCFUbazby3OI+Z5xhe"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E40DE3D.2020005@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Muniz <sjmuniz@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-U1kCFUbazby3OI+Z5xhe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-08-09 at 04:14 -0300, Sebastian Muniz wrote:
> Hello,
> I have searched a lot trying to answer this.
> I have a raid10 array on an openfiler box.
> Personalities : [raid10]
> md0 : active raid10 sde1[3] sdd1[2] sdc1[1] sdb1[0]
>        181760 blocks super 1.2 64K chunks 2 near-copies [4/4] [UUUU]
>=20
> unused devices: <none>
> Actually this is a Virtualbox machine with the same disk setup. I made 6=
=20
> x 100 Mbytes disks for the test.
>=20
> How can I tell which disks are mirrored?
That depends on the layout of your array. raid10 is not raid1+0
>=20
> My goal is to free the two mirror disks from md0, add two more free=20
> disks, create a new md1 raid5 array, and move the contents from md0 to md=
1
>=20
> Thanks in advance.
> Sebastian
>=20
> PS: in case it is relevant, i am adding the detailed md0 output.
>=20
> [root@of ~]# mdadm --misc --detail /dev/md0
> /dev/md0:
>          Version : 1.2
>    Creation Time : Tue Aug  9 03:01:14 2011
>       Raid Level : raid10
>       Array Size : 181760 (177.53 MiB 186.12 MB)
>    Used Dev Size : 90880 (88.76 MiB 93.06 MB)
>     Raid Devices : 4
>    Total Devices : 4
>      Persistence : Superblock is persistent
>=20
>      Update Time : Tue Aug  9 03:20:06 2011
>            State : clean
>   Active Devices : 4
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 0
>=20
>           Layout : near=3D2
                    ^^^^^^
This layout is described at
http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10

Assuming the info there is correct, mirrored devices are [0,1] and [2,3]

>       Chunk Size : 64K
>=20
>             Name : of:0  (local to host of)
>             UUID : 63b2145a:49030744:41b8f5b4:cb11bc1d
>           Events : 19
>=20
>      Number   Major   Minor   RaidDevice State
>         0       8       17        0      active sync   /dev/sdb1
>         1       8       33        1      active sync   /dev/sdc1
>         2       8       49        2      active sync   /dev/sdd1
>         3       8       65        3      active sync   /dev/sde1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Torbj=C3=B8rn Skagestad
Id=C3=A9 Til Produkt AS
torborn@itpas.no

--=-U1kCFUbazby3OI+Z5xhe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk5BGZUACgkQ4RjLWGFqSIbftACgs4pmH6uYBz889YWRH8xu58U4
qjEAn0iiagODe/0C8AqaTHJ6xK/vYAMs
=WUip
-----END PGP SIGNATURE-----

--=-U1kCFUbazby3OI+Z5xhe--

