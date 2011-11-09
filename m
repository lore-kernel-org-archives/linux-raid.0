From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid Problem - Unknown File System Type
Date: Wed, 9 Nov 2011 16:39:33 +0000
Message-ID: <20111109163933.GA26630@cthulhu.home.robinhill.me.uk>
References: <4EBAA68B.6090906@rogers.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4EBAA68B.6090906@rogers.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Colls <william.colls@rogers.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Nov 09, 2011 at 11:12:59AM -0500, William Colls wrote:

>=20
> Environment
>=20
> Kubuntu Linux 10.04.3 LTS
> mdadm 2.6.7.1-1ubuntu15
>=20
> I have two identical disks that were in a raid configuration in another=
=20
> machine (also running 10.04). I removed them from the old machine,=20
> mounted them in a new machine, booted up, and at a terminal prompt as=20
> root issued
>=20
> mdadm --create /dev/md0 --level=3D1 --raid-devices=3D2 /dev/sdb /dev/sdc
>=20
You should have just assembled them. You've now created a new array
instead of just assembling the old one.

> The configuration in the old machine was raid 1.
>=20
> I checked the contents of /proc/mdstat and it confirmed that md0 was=20
> indeed running, with 2 devices, as expected. But it also said it was=20
> resyncing the disks, which I didn't expect.
>=20
> When the reync completed, I was unable to mount /dev/md0p1. Specifying=20
> -t ext3 in the mount command gives the error message "wrong fs, bad=20
> option, bad superblock on /dev/md0p1". Trying mount with no -t gives the=
=20
> error "unknown file type linux_raid_member". Looking at the disks with=20
> Gparted, confims that the system sees the disks, but the filesystem=20
> shows as unknown.
>=20
It would look like the old array was either created with an older mdadm
version (with different defaults) or used some non-default parameter
values.

> The output from mdamd --detail /dev/sdb
>=20
> /dev/sdb:
>            Magic : a92b4efc
>          Version : 00.90.00
>             UUID : 1443e74d:f63f16ab:d527ef8c:7225e0b0
>    Creation Time : Tue Nov  8 13:14:48 2011
>       Raid Level : raid1
>    Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
>       Array Size : 732574464 (698.64 GiB 750.16 GB)
>     Raid Devices : 2
>    Total Devices : 2
> Preferred Minor : 0
>=20
>      Update Time : Tue Nov  8 16:05:42 2011
>            State : clean
>   Active Devices : 2
> Working Devices : 2
>   Failed Devices : 0
>    Spare Devices : 0
>         Checksum : c4195c85 - correct
>           Events : 34
>=20
>=20
>        Number   Major   Minor   RaidDevice State
> this     0       8       16        0      active sync   /dev/sdb
>=20
>     0     0       8       16        0      active sync   /dev/sdb
>     1     1       8       32        1      active sync   /dev/sdc
>=20
> --- end of output
>=20
> Output from mdadm --examine /dev/sdc
>=20
> /dev/sdc:
>            Magic : a92b4efc
>          Version : 00.90.00
>             UUID : 1443e74d:f63f16ab:d527ef8c:7225e0b0
>    Creation Time : Tue Nov  8 13:14:48 2011
>       Raid Level : raid1
>    Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
>       Array Size : 732574464 (698.64 GiB 750.16 GB)
>     Raid Devices : 2
>    Total Devices : 2
> Preferred Minor : 0
>=20
>      Update Time : Tue Nov  8 16:05:42 2011
>            State : clean
>   Active Devices : 2
> Working Devices : 2
>   Failed Devices : 0
>    Spare Devices : 0
>         Checksum : c4195c97 - correct
>           Events : 34
>=20
>=20
>        Number   Major   Minor   RaidDevice State
> this     1       8       32        1      active sync   /dev/sdc
>=20
>     0     0       8       16        0      active sync   /dev/sdb
>     1     1       8       32        1      active sync   /dev/sdc
>=20
> ---- end of output
>=20
> So - am I truly up the creek without a paddle? Is there any way to=20
> recover this array? I have backups of most of it, but it will take a=20
> while to find and restore. And for sure something will be lost.
>=20

Certainly most of the data should be there still. I don't suppose you
have a copy of the mdadm --examine output from the old system at all?

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk66rMUACgkQShxCyD40xBKZ2wCffYyknOTISX0gsUSQ107KnnYh
QUcAni9QyERhl325+pNz+37PjYe7e9kd
=+gmo
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
