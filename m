From: NeilBrown <neilb@suse.de>
Subject: Re: Raid10 to Raid0 conversion
Date: Mon, 31 Mar 2014 17:38:07 +1100
Message-ID: <20140331173807.7f539ea9@notabene.brown>
References: <532D6F06.1010901@forall.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/R+MZXyTGW7CwcBI9RD_h/2W"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <532D6F06.1010901@forall.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Marcin Wanat <mwanat@forall.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/R+MZXyTGW7CwcBI9RD_h/2W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 22 Mar 2014 12:07:50 +0100 Marcin Wanat <mwanat@forall.pl> wrote:

> Hi,
>=20
> i have 4disc RAID10 on my server and i am trying to grow it to 6 devices.
> As direct grow of RAID10 is unavailable so I decided to do it this way:

It is  available with latest kernel and mdadm...

>=20
> RAID10->RAID0->Grow RAID0 to 3 devices->RAID0(3 devices)->RAID10(6devices)
>=20
> But i have problem on the first step. I have degraded my RAID10 array:
> # mdadm --detail /dev/md1
> /dev/md1:
>          Version : 1.1
>    Creation Time : Mon Sep  2 12:09:53 2013
>       Raid Level : raid10
>       Array Size : 1023996928 (976.56 GiB 1048.57 GB)
>    Used Dev Size : 511998464 (488.28 GiB 524.29 GB)
>     Raid Devices : 4
>    Total Devices : 2
>      Persistence : Superblock is persistent
>=20
>      Update Time : Sat Mar 22 13:00:25 2014
>            State : clean, degraded
>   Active Devices : 2
> Working Devices : 2
>   Failed Devices : 0
>    Spare Devices : 0
>=20
>           Layout : near=3D2
>       Chunk Size : 512K
>=20
>      Number   Major   Minor   RaidDevice State
>         0       0        0        0      removed
>         1       8       17        1      active sync   /dev/sdb1
>         2       0        0        2      removed
>         4       8       49        3      active sync   /dev/sdd1
>=20
>=20
> And want to change it to RAID0:
> # mdadm /dev/md1 --grow --level=3D0
> or:
> # mdadm /dev/md1 --grow --raid-devices=3D2 --level=3D0
>=20
> but the result is always the same:
> mdadm: /dev/md1: could not set level to raid0
>=20
> dmesg shows:
> md/raid0:md1: All mirrors must be already degraded!
> md: md1: raid0 would not accept array
>=20
> But the array is already degraded... What am I doing wrong ?

I don't think it is you.
What does /sys/block/md1/md/degraded contain?
If it isn't '2', then that is the problem.
Maybe if you stop the array the array and assemble it again it could get th=
at
right.

>=20
> I am using Centos 6.5 default version of kernel and mdadm.

uname -a ; mdadm -V

is more helpful.

NeilBrown


>=20
>=20
> PS: I know that it is possible to grow RAID10 by creating new array with=
=20
> 3 drives and 3 missing and then move data between them, but i am trying=20
> to grow live system without any offline time.
>=20
>=20
> Regards,
> Marcin Wanat
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/R+MZXyTGW7CwcBI9RD_h/2W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUzkNTznsnt1WYoG5AQJvAxAAlGHLSeUoBdKa921IPmXcZn3oEetoMGYJ
4ozLLUXRmTBrXkjXcp4EJ1Ko0KCemycgrGG0k7A8atNrKjrqFwTgic8Aatj3GFCW
E3R++Ttx43lr8Ur59sh8F9Mk6GeOWeaniB8c0gQYeGpDwJtez9CWaMdEA55v3Hvf
A0XLQBRFfJAnITdUpKgNGz6CE+koTrPsKbKtF8p6l8tySakBfzp9EVsVkbJ/8IgZ
ZoxFuZGfbEpYvzthFDQlMGrj5I4grwOPzFuThuxQnpL14kCs0jfqAk69Aeji9BYN
e22EQi7alP9ChShK/q4Haj0SSfgOVGxLtLzM8lNEqByosNIcFusEiZUw/QFkBNZc
nFmv3tFucfK2NB/wyVXYR9bQVxAm72wjbW2Ev3M6Tm/9lENh2mxJwVOCQfDFKkyE
kdVjuzWGH+5QZVZMspLRBJeWg4GvgSPV/GsJoES+qnRK/BvtsMY2zeH47Lmnwr8x
zCdPnm1jFrbVKNoNBJ597UeYDngR2zKjkTxuQ2ksO+zfD2FQqyx5kSs9ExnEWHRQ
TuwFmwknbOYQwfoC3nW4+ROrLzDWiiiMOcZ+addi5T1LaDkikbtcX5vstvF1tTUS
IHnqMVrqaL95egdkSg397MLUXTAkqcs2BCDPPxtUUzSB5hfQSX66DFSWlae4XjUP
g1GToBUy/mU=
=YnST
-----END PGP SIGNATURE-----

--Sig_/R+MZXyTGW7CwcBI9RD_h/2W--
