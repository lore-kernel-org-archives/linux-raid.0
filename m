From: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Subject: Re: safely removing RAID information?
Date: Mon, 20 Nov 2006 11:02:26 +0100
Message-ID: <20061120100226.GA32016@scavenger.homeip.net>
References: <20061109101909.GA10711@scavenger.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20061109101909.GA10711@scavenger.homeip.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi list.

Anyone got an idea about the problem mentioned below?


Greetings,
	Benjamin

On 09.11.2006 11:19:09, Benjamin Schieder wrote:
> Hi list.
>=20
> I have the following 'leftover setup' from testing:
>=20
> ---snip---
> /dev/hda:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 533fb996:8989f533:2dc6aaa9:74fdd762
>   Creation Time : Sat Jun 24 08:37:43 2006
>      Raid Level : raid5
>     Device Size : 244198464 (232.89 GiB 250.06 GB)
>      Array Size : 488396928 (465.77 GiB 500.12 GB)
>    Raid Devices : 3
>   Total Devices : 3
> Preferred Minor : 0
>=20
>     Update Time : Fri Jul  7 17:49:52 2006
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : c0941be6 - correct
>          Events : 0.1780
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     1      34        0        1      active sync
>=20
>    0     0      33       64        0      active sync
>    1     1      34        0        1      active sync
>    2     2      34       64        2      active sync
> /dev/hda1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 3559ffcf:14eb9889:3826d6c2:c13731d7
>   Creation Time : Fri Jul  7 20:12:10 2006
>      Raid Level : raid1
>     Device Size : 497856 (486.27 MiB 509.80 MB)
>      Array Size : 497856 (486.27 MiB 509.80 MB)
>    Raid Devices : 3
>   Total Devices : 3
> Preferred Minor : 0
>=20
>     Update Time : Thu Nov  9 05:12:56 2006
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 76d7e7e8 - correct
>          Events : 0.1990
>=20
>=20
>       Number   Major   Minor   RaidDevice State
> this     1       3        1        1      active sync   /dev/hda1
>=20
>    0     0       3       65        0      active sync   /dev/hdb1
>    1     1       3        1        1      active sync   /dev/hda1
>    2     2      22        1        2      active sync   /dev/hdc1
>=20
> ---snap---
>=20
> Now, /dev/hda1 (and hda[35678]) are parts of active RAID arrays.
> /dev/hda (whole disk) was part of an array I set up for testing/playing
> around with mdadm. I then created the partitions and set up RAIDs for the=
m.
>=20
> Is it safe to issue the following command now:
>=20
> root@ceres:~# mdadm --zero-superblock /dev/hda
>=20
> or will that nuke my setup along with my precious data?
> My software versions are the following:
>=20
> root@ceres:/usr/src/wip/installer/package/base/installer# mdadm --version
> mdadm - v2.4 - 30 March 2006
> root@ceres:/usr/src/wip/installer/package/base/installer# uname -a
> Linux ceres 2.6.17.7-rock-dragon #2 SMP Wed Aug 30 17:21:35 CEST 2006 i68=
6 GNU/Linux
--=20
Benjamin 'blindCoder' Schieder
Registered Linux User #289529: http://counter.li.org
finger blindcoder@scavenger.homeip.net | gpg --import
--=20
/lusr/bin/brain: received signal: SIGIDIOT

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFFYX0yAsME5O4xgqgRAh8OAKCCniqVtuFK56bFV4/yvw1+4S65rwCdH9sQ
yf4LPdxdTDjMojbHKEYbsn0=
=h0Ew
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
