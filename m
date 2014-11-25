From: NeilBrown <neilb@suse.de>
Subject: Re: homehost and 0.90 format
Date: Tue, 25 Nov 2014 14:08:21 +1100
Message-ID: <20141125140821.6ece0afb@notabene.brown>
References: <F1F13E14A610474196571953929C020963C639@ex08.net.ucsf.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/vAIKRc+=S2YthWgAeushWx9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F1F13E14A610474196571953929C020963C639@ex08.net.ucsf.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Boylan, Ross" <Ross.Boylan@ucsf.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/vAIKRc+=S2YthWgAeushWx9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Nov 2014 03:14:34 +0000 "Boylan, Ross" <Ross.Boylan@ucsf.edu>
wrote:

> I am trying to figure out which of my RAID devices is considered home.  I=
 haven't switched machines, but I have several operating systems, with diff=
erent hostnames, on the machine.  0.90 format metadata.
>=20
> Even 2 RAID devices created on the same OS don't seem to have any UUID in=
 common.  i thought that the end of the UUID's would be the same.  For exam=
ple, inhttp://marc.info/?l=3Dlinux-raid&m=3D123999237229707 Neil Brown says=
=20
> > Note that 0.90 metadata does contain homehost information to some
> > extent.  When homehost is set, the last few bytes of the uuid is set
> > from a hash of the homehost name.  That makes it possible to test if a
> > 0.90 array was created for 'this' host, but not to find out what host
> > it was created for.=20
>=20
> mdadm.conf has
> HOMEHOST <system>
>=20
> The 2 UUIDS are
>  8691ad98:af955756:ae5efbfa:dfd20ce6
> 6d89d3b5:19a0acce:319e1a9c:58606385
>=20
> Thanks,
> Ross Boylan

You need to guess-and-test.
e.g.

  mdadm --detail /dev/md7 --homehost=3Dfoo | grep UUID

If it says "(local to host foo)", then "foo" is the correct name.
If not, then try a different name.

NeilBrown


>=20
> Details:
>=20
> root@wheezy4:~# mdadm --detail /dev/md7
> /dev/md7:
>         Version : 0.90
>   Creation Time : Fri Oct  3 17:20:13 2014
>      Raid Level : raid1
>      Array Size : 48828352 (46.57 GiB 50.00 GB)
>   Used Dev Size : 48828352 (46.57 GiB 50.00 GB)
>    Raid Devices : 1
>   Total Devices : 1
> Preferred Minor : 7
>     Persistence : Superblock is persistent
>=20
>     Update Time : Tue Nov  4 17:48:40 2014
>           State : clean=20
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>            UUID : 8691ad98:af955756:ae5efbfa:dfd20ce6
>          Events : 0.1
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       20        0      active sync   /dev/sdb4
> root@wheezy4:~# mdadm --detail /dev/md8
> /dev/md8:
>         Version : 0.90
>   Creation Time : Tue Sep 30 13:27:56 2014
>      Raid Level : raid1
>      Array Size : 970702784 (925.73 GiB 994.00 GB)
>   Used Dev Size : 970702784 (925.73 GiB 994.00 GB)
>    Raid Devices : 2
>   Total Devices : 1
> Preferred Minor : 8
>     Persistence : Superblock is persistent
>=20
>     Update Time : Mon Nov 10 18:16:11 2014
>           State : clean, degraded=20
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>            UUID : 6d89d3b5:19a0acce:319e1a9c:58606385
>          Events : 0.790792
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       19        0      active sync   /dev/sdb3
>        1       0        0        1      removed
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/vAIKRc+=S2YthWgAeushWx9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHPypTnsnt1WYoG5AQLByRAAgNGbZJjVG3DC2R+aIcfPo0iAGZH9HhkU
nijynf4/kX9vL+zWHYBEqBUaTBDNEyawgf820MzcL/H3tWUl84bl5Lfy93fUmL/5
5+bjf/xOboRBqc8uWPhVeTwUnPYMZHjuQQJbprK4mAcuLa9y/LQN8vmrs0wDlEiY
OEGWmOJ3yrlXbH7cWEcnyOo2Sz54xt4hKv2tjKu56CyAQryTL86Ktp4mBe2TPjOW
xtVjFMRr8Jx2Uk3MlFk4q26PwVOWDTL7rjHHVVVeBeeCrYUe1EwrLCSsCtC0rHfS
Qt9iET7LtMeMWtNjOapT1vJ5VgBdWAk5AbNliP2BC3W9fuow38vlzvFqeT8M6DcJ
GSXmRlsnmb0Ps0/wVUBUgGHVo7LuN0QhXDzQkkswHIfLeOrClRvFZGxxXqdupril
KkR/9lRQL+N14YnxHvRsjKeKEbxejioyfGwFUg6oeCTFReVzfOhqDnLZDAw+UgEJ
mAqUO2fUDSmbQladKkjmVM8amyzrXLxpaKyUEruiCpojotz65pfIcke+pCWJcbjs
8Jpn/FCUv62ipvrNzgSSpwte1XF+ALEWVsZZPkhAzhVrz/TzcXSF8Pf6ERn62Er3
2vPI3lI02TA+VuoseJodYTNp0MfvAyZewF6nhYJyTxEFLLb4r22mM2ioAgmlFp08
sdLaPVLsrnQ=
=59Os
-----END PGP SIGNATURE-----

--Sig_/vAIKRc+=S2YthWgAeushWx9--
