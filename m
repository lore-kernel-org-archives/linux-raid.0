From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Problems with raid after reboot.
Date: Tue, 26 Jul 2011 09:37:20 +0100
Message-ID: <20110726083720.GA18521@cthulhu.home.robinhill.me.uk>
References: <CA+taBv-V7HasgHFFaLV+Ppbgv=b-6CvLLkGHh3oN+GAO0wFHxA@mail.gmail.com>
 <CA+taBv-3OxS52vLgOJiruqAnnOh8nsKtTFsPa20X1DEODdVSYA@mail.gmail.com>
 <CA+taBv_yfW_njVX4r7fpAT105fvBeVMBLbU4M+6tTDY7R1yndA@mail.gmail.com>
 <20110725212107.GA6422@cthulhu.home.robinhill.me.uk>
 <CA+taBv8+KZguxmSTe7huntdMrnvANK3VRJKLpwZjXbymJ36-Ag@mail.gmail.com>
 <CA+taBv-sqRpCQ=AzEbXGAA2JZL3F6p8wPHTsnNnJjaqyHJEnmQ@mail.gmail.com>
 <CA+taBv-TWPpnJCxWeK7D-CCG2Xi87Wj3QJ_duU1ozdowzDncqg@mail.gmail.com>
 <CA+taBv_UOKXk0Noh3T_=WYQhb+qCWy33ZmEHCnEKF3uwn7c_uQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+taBv_UOKXk0Noh3T_=WYQhb+qCWy33ZmEHCnEKF3uwn7c_uQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matthew Tice <mjtice@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Jul 25, 2011 at 03:55:02PM -0600, Matthew Tice wrote:

> So now it's syncing:
> # mdadm --detail /dev/md0
> /dev/md0:
>         Version : 00.90
>   Creation Time : Sat Mar 12 21:22:34 2011
>      Raid Level : raid5
>      Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
>   Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>=20
>     Update Time : Mon Jul 25 15:52:29 2011
>           State : clean, degraded, recovering
>  Active Devices : 3
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>  Rebuild Status : 0% complete
>=20
>            UUID : daf06d5a:b80528b1:2e29483d:f114274d (local to host stor=
age)
>          Events : 0.5599
>=20
>     Number   Major   Minor   RaidDevice State
>        4       8       64        0      spare rebuilding   /dev/sde
>        1       8       48        1      active sync   /dev/sdd
>        2       8       32        2      active sync   /dev/sdc
>        3       8       16        3      active sync   /dev/sdb
>=20
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid5 sde[4] sdd[1] sdb[3] sdc[2]
>       2197723392 blocks level 5, 64k chunk, algorithm 2 [4/3] [_UUU]
>       [>....................]  recovery =3D  0.4% (3470464/732574464)
> finish=3D365.0min speed=3D33284K/sec
>=20
> unused devices: <none>
>=20
>=20
> However, it's still failing an fsck - so does order matter when I
> re-assemble the array?  I see conflicting answers online.
>=20
No, order only matters if you're recreating the array (which is a
last-ditch option for if assembly fails). The metadata on each drive
indicates where it should be in the array, so the assembly will use that
to order the drives.

The fsck errors would look to be genuine issues with the filesystem. Was
the array shut down cleanly before you moved it? You did have to force
the assembly initially, which would suggest not (and could point to some
minor corruption). I'm not sure you have much of an option other than to
go through with a fsck & repair any issues now though (if you've got the
space then I'd suggest imaging the array as a backup though).=20

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk4ufL8ACgkQShxCyD40xBLhTACgsPLYPY91Bf4eB8mIjwgLxRqL
1e0AnAodBOgq851d5FM5F8naJpQNgPpS
=FepG
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
