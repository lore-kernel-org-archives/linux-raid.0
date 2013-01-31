From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Thu, 31 Jan 2013 11:38:20 +0000
Message-ID: <20130131113820.GA20536@cthulhu.home.robinhill.me.uk>
References: <510A4AAE.6000009@evilazrael.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <510A4AAE.6000009@evilazrael.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jan 31, 2013 at 11:42:54 +0100, Christoph Nelles wrote:

> Hi,
>=20
> i hope somebody on this ML can help me.
>=20
> My RAID5 died last night during a rebuild when two drives failed (looks
> like a sata_mv problem). The RAID5 was rebuilding because one of the two
> drives failed before and after running badblocks for 2 days, i re-added
> it to the RAID.
>=20
Probably only one drive failed. If the rebuild was incomplete then a
single drive failure would cause the array to fail. Can you post the
errors? If the issue was a read failure then you'll need to fix that
before the array can be recovered properly.

> The used drives are from /dev/sdb1 to /dev/sdj1 (9 Drives, RAID5), the
> failed drives are sdj1 and sdg1
>
You also seriously need to look at moving to RAID6. Using RAID5 for a
9-drive array is not a good idea, and with 3TB drives it's absolutely
crazy. The odds of a single read error out of the 24TB that needs to be
read to recover a drive are not insignificant.

> The current situation is that I cannot start the RAID. I wanted to try
> readding on of the the drives, so removed it beforehand, making it a
> spare :\ The layout is as follows:
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       33        0      active sync   /dev/sdc1
>        1       0        0        1      removed
>        2       8      113        2      active sync   /dev/sdh1
>        3       8       49        3      active sync   /dev/sdd1
>        4       8      129        4      active sync   /dev/sdi1
>        5       0        0        5      removed
>        6       8       17        6      active sync   /dev/sdb1
>        7       8       81        7      active sync   /dev/sdf1
>        8       8       65        8      active sync   /dev/sde1
>=20
> Re-adding fails with a simple message:
> # mdadm -v /dev/md0 --re-add /dev/sdg1
> mdadm: --re-add for /dev/sdg1 to /dev/md0 is not possible
>=20
> I tried re-adding both failed drives at the same, with the same result.
>=20
That's good anyway - it prevented the loss of the existing metadata
which would definitely have reduced your chances of recovery.

> When examining the drives, sdj1 has the information from before the crash:
>    Device Role : Active device 5
>    Array State : AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> sdg1 looks like this
>    Device Role : spare
>    Array State : A.AAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> The other look like
>    Device Role : Active device 6
>    Array State : A.AAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
=46rom the looks of it, sdg1 was the drive you were originally adding back
into the array, and sdj1 is the drive that failed part-way through the
rebuild?

> So looks that my repair tries made sdg1 a spare :\ I attached the full
> output to this mail.
>=20
> Is there anyway to restart the RAID from the information contained in
> drive sdj1? Perhaps via Incremental Build starting from one drive? Could
> that work? If the RAID wouldn't have been rebuilding before the crash, i
> would just recreate it with --assume-clean.
>=20
The first thing to try should _always_ be a forced assemble. Recreating
the array is very much a last-ditch move and should never be attempted
before asking the list for help (any mismatch in your create command, or
in the mdadm/kernel versions could cause data corruption). Stop the
array, then reassemble with the --force flag. It'll probably restart
with sdj1 added back into the array, and you can then add sdg1 back in
again and restart the rebuild.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEKV6sACgkQShxCyD40xBId4wCfXXUeyGAt66p7oGYe97bEB/18
g3wAoMs2OBX3qR+5GJcGOQLe8flAgCrh
=ZDod
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
