From: NeilBrown <neilb@suse.de>
Subject: Re: Problem rebuild raid 1 replacement disk
Date: Mon, 20 Feb 2012 20:11:59 +1100
Message-ID: <20120220201159.6cd1633d@notabene.brown>
References: <807765805CA0DF48898D4C016E982BFC065A67CE25@MWLSVEXM002.au.baesystems.com>
	<20120220162915.43b4f451@notabene.brown>
	<807765805CA0DF48898D4C016E982BFC065A6D9BF5@MWLSVEXM002.au.baesystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d5uNDPDr=gcIR6rQFcSMD21"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <807765805CA0DF48898D4C016E982BFC065A6D9BF5@MWLSVEXM002.au.baesystems.com>
Sender: linux-raid-owner@vger.kernel.org
To: "RANSOM, Tony" <tony.ransom@baesystems.com>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/d5uNDPDr=gcIR6rQFcSMD21
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Feb 2012 18:58:22 +1030 "RANSOM, Tony"
<tony.ransom@baesystems.com> wrote:

> Neil,
>=20
> Thanks for the reply:
>=20
>=20
> >What is the output of each of
> >  mdadm -E /dev/sdb
>=20
> root@server2:~# mdadm -E /dev/sdb
> /dev/sdb:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 15e5ad84:82b4dd79:6719eb14:a41dd719
>   Creation Time : Mon Mar 28 23:52:08 2011
>      Raid Level : raid1
>   Used Dev Size : 1953027008 (1862.55 GiB 1999.90 GB)
>      Array Size : 1953027008 (1862.55 GiB 1999.90 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 1
>=20
>     Update Time : Sun Feb 19 15:44:55 2012
>           State : active
>  Active Devices : 1
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 1
>        Checksum : 5e4b8288 - correct
>          Events : 1314601
>=20
>       Number   Major   Minor   RaidDevice State
> this     2       8       16        2      spare   /dev/sdb
>=20
>    0     0       0        0        0      removed
>    1     1       8        3        1      active sync   /dev/sda3
>    2     2       8       16        2      spare   /dev/sdb
>=20
>=20
> >  mdadm -E /dev/sdb3
>=20
> root@server2:~# mdadm -E /dev/sdb3
> /dev/sdb3:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 15e5ad84:82b4dd79:6719eb14:a41dd719
>   Creation Time : Mon Mar 28 23:52:08 2011
>      Raid Level : raid1
>   Used Dev Size : 1953027008 (1862.55 GiB 1999.90 GB)
>      Array Size : 1953027008 (1862.55 GiB 1999.90 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 1
>=20
>     Update Time : Mon Feb 20 18:38:09 2012
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 5e621af4 - correct
>          Events : 1349308
>=20
>=20
>       Number   Major   Minor   RaidDevice State
> this     0       8       19        0      active sync   /dev/sdb3
>=20
>    0     0       8       19        0      active sync   /dev/sdb3
>    1     1       8        3        1      active sync   /dev/sda3
>=20
>=20
>=20
>=20
> >What version of mdadm do you have?
>=20
> root@server2:~# mdadm -V
> mdadm - v2.6.7.1 - 15th October 2008
>=20
> >What is the starting sector of /dev/sdb3?  In particular, is it a multip=
le of
> 64K?
>=20
> 589824
>=20
> Doesn't appear to be. Each sector (according to gdisk is 512 bytes), but =
this is same as sda.
>=20
>=20
> Odd that the system thinks sdb is a spare?
>=20
> Can it be corrected?

Yes.
Somehow both sdb and sdb3 have a superblock for the same array.  Must have
been a typo somewhere I suspect.
You should remove the one you don't want:

  mdadm --zero-superblock /dev/sdb

then it should all work nicely again.

(if the offset is a multiple of 64K you can get the both having exactly the
same superblock (same location on disk).  Newer versions of mdadm try to he=
lp
you catch that case, older versions don't.  But that doesn't seem to be an
issue for you).

NeilBrown

--Sig_/d5uNDPDr=gcIR6rQFcSMD21
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0IOXznsnt1WYoG5AQLmmA/+Nn/EmsVIu11pgo6EFODvGV8Z7nUdHb4H
pKKnfo6W+SJyHUjNAGJogedJFd9I786VteW8vFcnC6GWUepEGIKolLwltwHgPdxO
yl4GYxex6BLarlYvRCCTHJ6D0PsNZ62prulnte0/iFI2xAshRb1TlCOOnWekYJF+
aKObwkFg3njuDMh7jntpfWU1/Q6QlfsR6LgBFKrnokmaWSLSNwuEK04mdcybfI7Q
MJ9IlWJ913QopcMz+Up+ZwKm+Du4Y3C/x78Ml1hncmDNEeuorZY1JuCZJeNraoJ8
e0IT9Mh5zP3SxnwsuOGBQg6+B0NjhX3CInVdGLplNvhip7DYafKuhvP7n8LVvmWh
1t1HwkzUxRU/IvOnkBlqi82T1wiiQmwrjGxC+6nFhtcrofPFmMihBc+B1h4Hvcqm
7ulLyESYM9DMNY4rf4Tmrcl//JZz5rkwENPdqyBNsvzd8dQkUskdFAjG7dWjktzX
7xGTm/OuqLidianLqvqxOPkMFlBvW3gKs7mQAUcKPxaAz1vDgGu8xA0I/NYzMHD3
Mo/qKrWbL9VqSHPOlBwOWfWTYZdmPhfMOYYhy1ex8b9ZeureKpnusxpioiivMOzF
iDAim3NEtEikS4Ai44hunOCXCeGhvIcfaP2qgkJoX2IvWAdPNnNX8cRNvxVPrcrz
9e7VQCMHVvM=
=qtg1
-----END PGP SIGNATURE-----

--Sig_/d5uNDPDr=gcIR6rQFcSMD21--
