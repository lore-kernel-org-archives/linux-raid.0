From: NeilBrown <neilb@suse.de>
Subject: Re: Recovering data from a shrunk RAID 10 array
Date: Thu, 5 Jun 2014 17:13:11 +1000
Message-ID: <20140605171311.5310e1ec@notabene.brown>
References: <1488530542.30565929.1401886890602.JavaMail.root@telenet.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AKyKNAoT+ij5GKJY7gz6W06"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488530542.30565929.1401886890602.JavaMail.root@telenet.be>
Sender: linux-raid-owner@vger.kernel.org
To: RedShift <redshift@telenet.be>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/AKyKNAoT+ij5GKJY7gz6W06
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Jun 2014 15:01:30 +0200 (CEST) RedShift <redshift@telenet.be> wro=
te:

> Hello all
>=20
>=20
> I'm trying to save data from a QNAP device which utilizes linux software =
RAID.
> The RAID format used is RAID 10. The disks were handed to me after it was
> decided a professional data recovery would cost too much for the data inv=
olved.
> >From what I can tell the following happened (I'm not sure as I wasn't th=
ere):
>=20
> * The original RAID 10 array had 4 disks
> * Array was expanded to 6 disks
> * Filesystem has been resized
> * Array was shrunk or rebuilt with 4 disks (remaining in RAID 10)
> * The filesystem became unmountable.

If this is really what happened (it is seems quite possible given the detai=
ls
below) then the last third of the expanded filesystem no longer exists.

You only hope is to recover what you can from the first two thirds.

If you try to recreate the array at all it can only make things worse.

I would suggest trying to run "fsck" on the device and see what it can
recover, or email ext3-users@redhat.com and ask if they have any suggestion=
s.

NeilBrown


>=20
> The system has been booted with system rescue cd, which automatically sta=
rts
> RAID arrays. This is the output from /proc/mdstat at this point:
>=20
> ---- cat /proc/mdstat
>=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [rai=
d4] [raid10]=20
> md127 : inactive sdd3[5](S) sda3[4](S)
>       3903891200 blocks
>       =20
> md13 : active raid1 sdf4[0] sdd4[5] sda4[4] sdb4[3] sde4[2] sdc4[1]
>       458880 blocks [8/6] [UUUUUU__]
>       bitmap: 48/57 pages [192KB], 4KB chunk
>=20
> md8 : active raid1 sdf2[0] sdd2[5](S) sda2[4](S) sde2[3](S) sdb2[2](S) sd=
c2[1]
>       530048 blocks [2/2] [UU]
>      =20
> md9 : active raid1 sdf1[0] sdd1[5] sda1[4] sde1[3] sdb1[2] sdc1[1]
>       530048 blocks [8/6] [UUUUUU__]
>       bitmap: 65/65 pages [260KB], 4KB chunk
>=20
> md0 : active raid10 sdf3[0] sde3[3] sdb3[2] sdc3[1]
>       3903891200 blocks 64K chunks 2 near-copies [4/4] [UUUU]
>      =20
> unused devices: <none>
>=20
>=20
>=20
> When I try to mount /dev/md0, it fails with this kernel message:
>=20
> [  505.657356] EXT4-fs (md0): bad geometry: block count 1463959104 exceed=
s size of device (975972800 blocks)
>=20
> If I skim /dev/md0 with "more", I do see random text data (the array was =
mainly
> used for logging, so I see a lot of plaintext), so I suspect there is int=
act
> data present.
>=20
> What would be the best course of action here? Recreate the RAID array with
> --assume-clean? I don't have room to create a backup of all the component
> devices, risks known.
>=20
>=20
> I recorded mdadm -E for every component:
>=20
>=20
> ---- mdadm -E /dev/sda3
> /dev/sda3:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : ee50da6d:d084f704:2f17ef00:379899ff
>   Creation Time : Fri May  2 07:16:58 2014
>      Raid Level : raid10
>   Used Dev Size : 1951945472 (1861.52 GiB 1998.79 GB)
>      Array Size : 5855836416 (5584.56 GiB 5996.38 GB)
>    Raid Devices : 6
>   Total Devices : 4
> Preferred Minor : 0
>=20
>     Update Time : Sun May  4 10:22:16 2014
>           State : active
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 2
>   Spare Devices : 0
>        Checksum : 411699c7 - correct
>          Events : 15
>=20
>          Layout : near=3D2
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     4       8       67        4      active sync   /dev/sde3
>=20
>    0     0       8        3        0      active sync   /dev/sda3
>    1     1       0        0        1      faulty removed
>    2     2       8       35        2      active sync   /dev/sdc3
>    3     3       0        0        3      faulty removed
>    4     4       8       67        4      active sync   /dev/sde3
>    5     5       8       83        5      active sync   /dev/sdf3
>=20
>=20
> ---- mdadm -E /dev/sdb3
> /dev/sdb3:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 05b41ebc:0bd1a5ce:4778a22f:da014845
>   Creation Time : Sun May  4 11:04:37 2014
>      Raid Level : raid10
>   Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
>      Array Size : 3903891200 (3723.04 GiB 3997.58 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>=20
>     Update Time : Mon May  5 14:30:00 2014
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : f75212f1 - correct
>          Events : 6
>=20
>          Layout : near=3D2
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     2       8        3        2      active sync   /dev/sda3
>=20
>    0     0       8       19        0      active sync   /dev/sdb3
>    1     1       8       51        1      active sync   /dev/sdd3
>    2     2       8        3        2      active sync   /dev/sda3
>    3     3       8       35        3      active sync   /dev/sdc3
>=20
>=20
> ---- mdadm -E /dev/sdc3
> /dev/sdc3:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 05b41ebc:0bd1a5ce:4778a22f:da014845
>   Creation Time : Sun May  4 11:04:37 2014
>      Raid Level : raid10
>   Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
>      Array Size : 3903891200 (3723.04 GiB 3997.58 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>=20
>     Update Time : Mon May  5 14:30:00 2014
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : f752131f - correct
>          Events : 6
>=20
>          Layout : near=3D2
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     1       8       51        1      active sync   /dev/sdd3
>=20
>    0     0       8       19        0      active sync   /dev/sdb3
>    1     1       8       51        1      active sync   /dev/sdd3
>    2     2       8        3        2      active sync   /dev/sda3
>    3     3       8       35        3      active sync   /dev/sdc3
>=20
>=20
> ---- mdadm -E /dev/sdd3
> /dev/sdd3:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : ee50da6d:d084f704:2f17ef00:379899ff
>   Creation Time : Fri May  2 07:16:58 2014
>      Raid Level : raid10
>   Used Dev Size : 1951945472 (1861.52 GiB 1998.79 GB)
>      Array Size : 5855836416 (5584.56 GiB 5996.38 GB)
>    Raid Devices : 6
>   Total Devices : 4
> Preferred Minor : 0
>=20
>     Update Time : Sun May  4 10:22:16 2014
>           State : active
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 2
>   Spare Devices : 0
>        Checksum : 411699d9 - correct
>          Events : 15
>=20
>          Layout : near=3D2
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     5       8       83        5      active sync   /dev/sdf3
>=20
>    0     0       8        3        0      active sync   /dev/sda3
>    1     1       0        0        1      faulty removed
>    2     2       8       35        2      active sync   /dev/sdc3
>    3     3       0        0        3      faulty removed
>    4     4       8       67        4      active sync   /dev/sde3
>    5     5       8       83        5      active sync   /dev/sdf3
>=20
>=20
> ---- mdadm -E /dev/sde3
> /dev/sde3:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 05b41ebc:0bd1a5ce:4778a22f:da014845
>   Creation Time : Sun May  4 11:04:37 2014
>      Raid Level : raid10
>   Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
>      Array Size : 3903891200 (3723.04 GiB 3997.58 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>=20
>     Update Time : Mon May  5 14:30:00 2014
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : f7521313 - correct
>          Events : 6
>=20
>          Layout : near=3D2
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     3       8       35        3      active sync   /dev/sdc3
>=20
>    0     0       8       19        0      active sync   /dev/sdb3
>    1     1       8       51        1      active sync   /dev/sdd3
>    2     2       8        3        2      active sync   /dev/sda3
>    3     3       8       35        3      active sync   /dev/sdc3
>=20
>   =20
> ---- mdadm -E /dev/sdf3
> /dev/sdf3:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 05b41ebc:0bd1a5ce:4778a22f:da014845
>   Creation Time : Sun May  4 11:04:37 2014
>      Raid Level : raid10
>   Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
>      Array Size : 3903891200 (3723.04 GiB 3997.58 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>=20
>     Update Time : Mon May  5 14:30:00 2014
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : f75212fd - correct
>          Events : 6
>=20
>          Layout : near=3D2
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     0       8       19        0      active sync   /dev/sdb3
>=20
>    0     0       8       19        0      active sync   /dev/sdb3
>    1     1       8       51        1      active sync   /dev/sdd3
>    2     2       8        3        2      active sync   /dev/sda3
>    3     3       8       35        3      active sync   /dev/sdc3
>=20
>   =20
> Thanks,
>=20
> Best regards,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/AKyKNAoT+ij5GKJY7gz6W06
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU5AYhznsnt1WYoG5AQK+dQ/8CAoFoEPHc/LOT7TWMvKaWPbDbxeWOf6U
5EWC3sayq6Tht+SD0lHozUsaOo+jeAhpOHENSuiKlTQ/J+dm93a9VO5xp6Q9FTmJ
F4iSol+c4VvZaMDEoJjntBxWBLDlxl0F938LuA2bcF0YiPqYDkv5C7fENsB0MNLM
SeC6wi39LxF/h3iFRafu5UvGHpwkzYYKvflbvq3BWqEofM4uBEtfUTd1TfKOj4Lp
zjVpVt4LW/u+gb/rFIv5AxHvqtTFsJ8p8mGxBdqZkmfcIM0ku0deahFulONFJ1wC
/zte1k+PbBQXTqRjmyjBOR1j1jZsvCiRBKPw18BInKTCRTRDZd1amLJjB4OrpGBI
NRm2yXNnOZ6UWLLYaiAk248UaRPCqCb/QWkWgTFXJ+abVizFmA8olkPFq2IrP/lg
dzq++5Q+bt6QUP0BBN3xY1mw0tYq9T8Ry/bUQ+yKyz9Jum+Iu7WIzFmIZBuGJ+Yb
Dp3C49EMSRL+SN1U5RQcV1J/BRLrNL1D2FtLZbKr6FgYmVn5gpPYmWsEbG2LpiyZ
LKSzsBKOmpAqfUhlYx4XVzNxKsHSnnys53gSkA4pyuynFFJ4qGU3RhYStugylCu+
+WepdbzTgFd2hTpV6Ajhx9oJGvhyKwzkWN0eceSLYnxtBH13gRYcOVndBMmp1i9x
VIkVf3Dfu1k=
=GHol
-----END PGP SIGNATURE-----

--Sig_/AKyKNAoT+ij5GKJY7gz6W06--
