From: NeilBrown <neilb@suse.de>
Subject: Re: raid6 recovery
Date: Sat, 15 Jan 2011 08:52:51 +1100
Message-ID: <20110115085251.77c8b03b@notabene.brown>
References: <4D3076DA.4020204@smarteye.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D3076DA.4020204@smarteye.se>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?B?Qmr2cm4=?= Englund <be@smarteye.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 14 Jan 2011 17:16:26 +0100 Bj=F6rn Englund <be@smarteye.se> wro=
te:

> Hi.
>=20
> After a loss of communication with a drive in a 10 disk raid6 the dis=
k
> was dropped out of the raid.
>=20
> I added it again with
> mdadm /dev/md16 --add /dev/sdbq1
>=20
> The array resynced and I used the xfs filesystem on top of the raid.
>=20
> After a while I started noticing filesystem errors.
>=20
> I did
> echo check > /sys/block/md16/md/sync_action
>=20
> I got a lot of errors in /sys/block/md16/md/mismatch_cnt
>=20
> I failed and removed the disk I added before from the array.
>=20
> Did a check again (on the 9/10 array)
> echo check > /sys/block/md16/md/sync_action
>=20
> No errors  /sys/block/md16/md/mismatch_cnt
>=20
> Wiped the superblock from /dev/sdbq1 and added it again to the array.
> Let it finish resyncing.
> Did a check and once again a lot of errors.

That is obviously very bad.  After the recovery it may well report a la=
rge
number in mismatch_cnt, but if you then do a 'check' the number should =
go to
zero and stay there.

Did you interrupt the recovery at all, or did it run to completion with=
out
any interference?   What kernel version are you using?

>=20
> The drive now has slot 10 instead of slot 3 which it had before the
> first error.

This is normal.  When you wipes the superblock, md though it was a new =
device
and gave it a new number in the array.  It still filled the same role t=
hough.


>=20
> Examining each device (see below) shows 11 slots and one failed?
> (0, 1, 2, failed, 4, 5, 6, 7, 8, 9, 3) ?

These numbers are confusing, but they are correct and suggest the array=
 is
whole and working.
Newer version of mdadm are less confusing.

I'm afraid I cannot suggest what the root problem is.  It seems like
something seriously wrong with IO to the device, but if that is the cas=
e you
would expect other errors...

NeilBrown


>=20
>=20
> Any idea what is going on?
>=20
> mdadm --version
> mdadm - v2.6.9 - 10th March 2009
>=20
> Centos 5.5
>=20
>=20
> mdadm -D /dev/md16
> /dev/md16:
>         Version : 1.01
>   Creation Time : Thu Nov 25 09:15:54 2010
>      Raid Level : raid6
>      Array Size : 7809792000 (7448.00 GiB 7997.23 GB)
>   Used Dev Size : 976224000 (931.00 GiB 999.65 GB)
>    Raid Devices : 10
>   Total Devices : 10
> Preferred Minor : 16
>     Persistence : Superblock is persistent
>=20
>     Update Time : Fri Jan 14 16:22:10 2011
>           State : clean
>  Active Devices : 10
> Working Devices : 10
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>      Chunk Size : 256K
>=20
>            Name : 16
>            UUID : fcd585d0:f2918552:7090d8da:532927c8
>          Events : 90
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8      145        0      active sync   /dev/sdj1
>        1      65        1        1      active sync   /dev/sdq1
>        2      65       17        2      active sync   /dev/sdr1
>       10      68       65        3      active sync   /dev/sdbq1
>        4      65       49        4      active sync   /dev/sdt1
>        5      65       65        5      active sync   /dev/sdu1
>        6      65      113        6      active sync   /dev/sdx1
>        7      65      129        7      active sync   /dev/sdy1
>        8      65       33        8      active sync   /dev/sds1
>        9      65      145        9      active sync   /dev/sdz1
>=20
>=20
>=20
> mdadm -E /dev/sdj1
> /dev/sdj1:
>           Magic : a92b4efc
>         Version : 1.1
>     Feature Map : 0x0
>      Array UUID : fcd585d0:f2918552:7090d8da:532927c8
>            Name : 16
>   Creation Time : Thu Nov 25 09:15:54 2010
>      Raid Level : raid6
>    Raid Devices : 10
>=20
>  Avail Dev Size : 1952448248 (931.00 GiB 999.65 GB)
>      Array Size : 15619584000 (7448.00 GiB 7997.23 GB)
>   Used Dev Size : 1952448000 (931.00 GiB 999.65 GB)
>     Data Offset : 264 sectors
>    Super Offset : 0 sectors
>           State : clean
>     Device UUID : 5db9c8f7:ce5b375e:757c53d0:04e89a06
>=20
>     Update Time : Fri Jan 14 16:22:10 2011
>        Checksum : 1f17a675 - correct
>          Events : 90
>=20
>      Chunk Size : 256K
>=20
>     Array Slot : 0 (0, 1, 2, failed, 4, 5, 6, 7, 8, 9, 3)
>    Array State : Uuuuuuuuuu 1 failed
>=20
>=20
>=20
> mdadm -E /dev/sdq1
> /dev/sdq1:
>           Magic : a92b4efc
>         Version : 1.1
>     Feature Map : 0x0
>      Array UUID : fcd585d0:f2918552:7090d8da:532927c8
>            Name : 16
>   Creation Time : Thu Nov 25 09:15:54 2010
>      Raid Level : raid6
>    Raid Devices : 10
>=20
>  Avail Dev Size : 1952448248 (931.00 GiB 999.65 GB)
>      Array Size : 15619584000 (7448.00 GiB 7997.23 GB)
>   Used Dev Size : 1952448000 (931.00 GiB 999.65 GB)
>     Data Offset : 264 sectors
>    Super Offset : 0 sectors
>           State : clean
>     Device UUID : fb113255:fda391a6:7368a42b:1d6d4655
>=20
>     Update Time : Fri Jan 14 16:22:10 2011
>        Checksum : 6ed7b859 - correct
>          Events : 90
>=20
>      Chunk Size : 256K
>=20
>     Array Slot : 1 (0, 1, 2, failed, 4, 5, 6, 7, 8, 9, 3)
>    Array State : uUuuuuuuuu 1 failed
>=20
>=20
>  mdadm -E /dev/sdr1
> /dev/sdr1:
>           Magic : a92b4efc
>         Version : 1.1
>     Feature Map : 0x0
>      Array UUID : fcd585d0:f2918552:7090d8da:532927c8
>            Name : 16
>   Creation Time : Thu Nov 25 09:15:54 2010
>      Raid Level : raid6
>    Raid Devices : 10
>=20
>  Avail Dev Size : 1952448248 (931.00 GiB 999.65 GB)
>      Array Size : 15619584000 (7448.00 GiB 7997.23 GB)
>   Used Dev Size : 1952448000 (931.00 GiB 999.65 GB)
>     Data Offset : 264 sectors
>    Super Offset : 0 sectors
>           State : clean
>     Device UUID : afcb4dd8:2aa58944:40a32ed9:eb6178af
>=20
>     Update Time : Fri Jan 14 16:22:10 2011
>        Checksum : 97a7a2d7 - correct
>          Events : 90
>=20
>      Chunk Size : 256K
>=20
>     Array Slot : 2 (0, 1, 2, failed, 4, 5, 6, 7, 8, 9, 3)
>    Array State : uuUuuuuuuu 1 failed
>=20
>=20
> mdadm -E /dev/sdbq1
> /dev/sdbq1:
>           Magic : a92b4efc
>         Version : 1.1
>     Feature Map : 0x0
>      Array UUID : fcd585d0:f2918552:7090d8da:532927c8
>            Name : 16
>   Creation Time : Thu Nov 25 09:15:54 2010
>      Raid Level : raid6
>    Raid Devices : 10
>=20
>  Avail Dev Size : 1952448248 (931.00 GiB 999.65 GB)
>      Array Size : 15619584000 (7448.00 GiB 7997.23 GB)
>   Used Dev Size : 1952448000 (931.00 GiB 999.65 GB)
>     Data Offset : 264 sectors
>    Super Offset : 0 sectors
>           State : clean
>     Device UUID : 93c6ae7c:d8161356:7ada1043:d0c5a924
>=20
>     Update Time : Fri Jan 14 16:22:10 2011
>        Checksum : 2ca5aa8f - correct
>          Events : 90
>=20
>      Chunk Size : 256K
>=20
>     Array Slot : 10 (0, 1, 2, failed, 4, 5, 6, 7, 8, 9, 3)
>    Array State : uuuUuuuuuu 1 failed
>=20
>=20
> and so on for the rest of the drives.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
