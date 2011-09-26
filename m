From: NeilBrown <neilb@suse.de>
Subject: Re:
Date: Mon, 26 Sep 2011 14:52:48 +1000
Message-ID: <20110926145248.6ffc5f02@notabene.brown>
References: <09f356fa46129bd08dd45752c0f736de.squirrel@www.maxstr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gqcV8PL6xEXZ_TcDGMUpH+I"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <09f356fa46129bd08dd45752c0f736de.squirrel@www.maxstr.com>
Sender: linux-raid-owner@vger.kernel.org
To: kenn@kenn.us
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/gqcV8PL6xEXZ_TcDGMUpH+I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Sep 2011 21:23:31 -0700 "Kenn" <kenn@kenn.us> wrote:

> I have a raid5 array that had a drive drop out, and resilvered the wrong
> drive when I put it back in, corrupting and destroying the raid.  I
> stopped the array at less than 1% resilvering and I'm in the process of
> making a dd-copy of the drive to recover the files.

I don't know what you mean by "resilvered".

>=20
> (1) Is there anything diagnostic I can contribute to add more
> wrong-drive-resilvering protection to mdadm?  I have the command history
> showing everything I did, I have the five drives available for reading
> sectors, I haven't touched anything yet.

Yes, report the command history, and any relevant kernel logs, and the outp=
ut
of "mdadm --examine" on all relevant devices.

NeilBrown


>=20
> (2) Can I suggest improvements into resilvering?  Can I contribute code to
> implement them?  Such as resilver from the end of the drive back to the
> front, so if you notice the wrong drive resilvering, you can stop and not
> lose the MBR and the directory format structure that's stored in the first
> few sectors?  I'd also like to take a look at adding a raid mode where
> there's checksum in every stripe block so the system can detect corrupted
> disks and not resilver.  I'd also like to add a raid option where a
> resilvering need will be reported by email and needs to be started
> manually.  All to prevent what happened to me from happening again.
>=20
> Thanks for your time.
>=20
> Kenn Frank
>=20
> P.S.  Setup:
>=20
> # uname -a
> Linux teresa 2.6.26-2-686 #1 SMP Sat Jun 11 14:54:10 UTC 2011 i686 GNU/Li=
nux
>=20
> # mdadm --version
> mdadm - v2.6.7.2 - 14th November 2008
>=20
> # mdadm --detail /dev/md3
> /dev/md3:
>         Version : 00.90
>   Creation Time : Thu Sep 22 16:23:50 2011
>      Raid Level : raid5
>      Array Size : 2930287616 (2794.54 GiB 3000.61 GB)
>   Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
>    Raid Devices : 5
>   Total Devices : 4
> Preferred Minor : 3
>     Persistence : Superblock is persistent
>=20
>     Update Time : Thu Sep 22 20:19:09 2011
>           State : clean, degraded
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>            UUID : ed1e6357:74e32684:47f7b12e:9c2b2218 (local to host tere=
sa)
>          Events : 0.6
>=20
>     Number   Major   Minor   RaidDevice State
>        0      33        1        0      active sync   /dev/hde1
>        1      56        1        1      active sync   /dev/hdi1
>        2       0        0        2      removed
>        3      57        1        3      active sync   /dev/hdk1
>        4      34        1        4      active sync   /dev/hdg1
>=20
>=20


--Sig_/gqcV8PL6xEXZ_TcDGMUpH+I
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOgAUgG5fc6gV+Wb0RAndbAKCAhUUK0WXe9wPWHZqSIK2gPq/vwQCgmGx9
/q4Ar6IDYYMLNW8gImT1yNA=
=aeQ2
-----END PGP SIGNATURE-----

--Sig_/gqcV8PL6xEXZ_TcDGMUpH+I--
