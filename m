From: NeilBrown <neilb@suse.de>
Subject: Re: strange status raid 5
Date: Wed, 2 Apr 2014 09:41:42 +1100
Message-ID: <20140402094142.6d1a30ec@notabene.brown>
References: <CADzS=apR=2D=t47wS9PBHzEdeOS96LE-CbTEBxnd9BLj_=f7jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PUT8Em3Gd9a=xh=Jp.cPB0k"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=apR=2D=t47wS9PBHzEdeOS96LE-CbTEBxnd9BLj_=f7jg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: bobzer <bobzer@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/PUT8Em3Gd9a=xh=Jp.cPB0k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Mar 2014 10:08:30 -0400 bobzer <bobzer@gmail.com> wrote:

> Hi,
>=20
> My raid 5 is in a strange state. the mdstat tell me is degraded, but
> when i check the disk that should be in the raid anymore it tell me
> everything is right ... I'm lost
>=20
> #cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdc1[3] sdd1[1]
>      3907021568 blocks super 1.2 level 5, 128k chunk, algorithm 2 [3/2] [=
UU_]
>=20
> unused devices: <none>
>=20
>=20
> so my third disk is unused i check with :
>=20
> #mdadm -D /dev/md0
> /dev/md0:
>        Version : 1.2
>  Creation Time : Sun Mar  4 22:49:14 2012
>     Raid Level : raid5
>     Array Size : 3907021568 (3726.03 GiB 4000.79 GB)
>  Used Dev Size : 1953510784 (1863.01 GiB 2000.40 GB)
>   Raid Devices : 3
>  Total Devices : 2
>    Persistence : Superblock is persistent
>=20
>    Update Time : Sun Mar 30 23:01:35 2014
>          State : clean, degraded
> Active Devices : 2
> Working Devices : 2
> Failed Devices : 0
>  Spare Devices : 0
>=20
>         Layout : left-symmetric
>     Chunk Size : 128K
>           Name : debian:0
>           UUID : bf3c605b:9699aa55:d45119a2:7ba58d56
>         Events : 255801
>=20
>    Number   Major   Minor   RaidDevice State
>       3       8       33        0      active sync   /dev/sdc1
>       1       8       49        1      active sync   /dev/sdd1
>       2       0        0        2      removed
>=20
>=20
> after verify what says the disk i got confuse :
>=20
>=20
> #mdadm --examine /dev/sdb1
> /dev/sdb1:
>          Magic : a92b4efc
>        Version : 1.2
>    Feature Map : 0x0
>     Array UUID : bf3c605b:9699aa55:d45119a2:7ba58d56
>           Name : debian:0
>  Creation Time : Sun Mar  4 22:49:14 2012
>     Raid Level : raid5
>   Raid Devices : 3
>=20
> Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
>     Array Size : 7814043136 (3726.03 GiB 4000.79 GB)
>  Used Dev Size : 3907021568 (1863.01 GiB 2000.40 GB)
>    Data Offset : 2048 sectors
>   Super Offset : 8 sectors
>          State : clean
>    Device UUID : f9059dfb:74af1ab7:bc1465b1:e2ff30ba
>=20
>    Update Time : Sun Jan  5 04:11:41 2014
>  Bad Block Log : 512 entries available at offset 2032 sectors
>       Checksum : 7df1fefc - correct
>         Events : 436
>         Layout : left-symmetric
>     Chunk Size : 128K
>=20
>   Device Role : Active device 2
>   Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)

sdb1 thinks it is OK, but that is normal.  When a device fails the fact that
it is failed isn't recorded on that device, only on the other devices.

>=20
>=20
> so there i tried to re-add the disk that doesn't works
> so i tred to stop the raid and assemble it again but it doesn't work eith=
er
>=20
> #mdadm --stop /dev/md0
> #mdadm --assemble --force /dev/md0 /dev/sd[bcd]1
> mdadm: /dev/md0 has been started with 2 drives (out of 3).
>=20
>=20
> can you help me guys ?

If
   mdadm /dev/md0 --add /dev/sdb1
doesn't work, them run
   mdadm --zero-super /dev/sdb1
first.

>=20
>=20
> Thanks by advance
>=20
> ps: i've got mdadm 3.3-devel i would update it but don't how to do ...

 git clone git://neil.brown.name/mdadm
 cd mdadm
 make
 make install


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

NeilBrown

--Sig_/PUT8Em3Gd9a=xh=Jp.cPB0k
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUztApjnsnt1WYoG5AQKo+A/8D0NwHxGskIGzZgYvCJcLbPMvIaiyPOMc
sr12zjBbyET8kJ7i8NmqBDOB+P62RsasnXXSJIeypUC8HkOab6c46dTUedDYb30Y
ZbQGwdbBqQoN2H3zORFMDWIgKBeAKNHQZjaJwa8FIeadlrAge0pqoZG1jt6pGeHt
U0sgHUEU/iiNyVD6wq4zD+V3Om6VTvSDhOGoo4JZkBv3JaW1W2Qm2nHiL+e1cJx2
zkic5oEJTnrHaY3MWQiuY25d+9KBeISSFp8LzjRxejrqKzqgr/IKgTez6CFZ8htH
5efQ/GP2a6tv64/gzC2ZNz5x5f16PGBO3874aHZ2sqWFtJmUuwyH+ft047qTgqtN
bLWCSkZlAndgukmKGpFr8dOZvDgTTU+WkxnKzYXAcEwLBBrI5vfYsLgK6pfaEGpg
z9r2L0Mx4t60QRxol7EuRSxKeE2PM9d1lQmSk/kMpw6DpgW7EFnoUdIPuvcfnQwO
LJD53ezJwbOPyQtjatJsAZ3EoZb3fDoPDwcaz7r58zi5H7/uQjckEFiJg9kc9erK
HZmz64vDoaaJVoOSRQsNSzzCkgp+O6Z1/LDV8B4L9ot5TPcyCSEa6DXeWHDaaDC7
zXpjftV9tRr2tdohVPxoe3RCKfJxHWp8ChCo3dLBB8RxGkVywmK5wdhYUDvlZxH8
lXaeIFR/Zic=
=oOXU
-----END PGP SIGNATURE-----

--Sig_/PUT8Em3Gd9a=xh=Jp.cPB0k--
