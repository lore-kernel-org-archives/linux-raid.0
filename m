From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Subject: Re: invalid bitmap file superblock: bad magic
Date: Thu, 8 Mar 2012 19:12:31 +0100
Message-ID: <201203081912.31791.a.miskiewicz@gmail.com>
References: <201203081711.17836.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203081711.17836.a.miskiewicz@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 08 of March 2012, Arkadiusz Mi=C5=9Bkiewicz wrote:
> Hello.
>=20
> I'm trying to create internal bitmap on freshly created
> raid1 array on 3.2.6 kernel.
>=20
> What's going on and how to fix this problem?

Ehm, I just had to wait ew hours and:

[14558.245586] md3: invalid bitmap file superblock: bad magic
[14558.245589] md3: bitmap file superblock:
[14558.245591]          magic: 00000000
[14558.245593]        version: 0
[14558.245594]           uuid: 00000000.00000000.00000000.00000000
[14558.245596]         events: 0
[14558.245598] events cleared: 0
[14558.245599]          state: 00000000
[14558.245601]      chunksize: 0 B
[14558.245602]   daemon sleep: 0s
[14558.245604]      sync size: 0 KB
[14558.245605] max write behind: 0
[17724.265492] mdadm: sending ioctl 1261 to a partition!
[17724.265495] mdadm: sending ioctl 1261 to a partition!
[17724.271631] mdadm: sending ioctl 1261 to a partition!
[17724.271635] mdadm: sending ioctl 1261 to a partition!
[17724.279829] md3: bitmap file is out of date (0 < 24) -- forcing full=
=20
recovery
[17724.279833] created bitmap (7 pages) for device md3


worked... weird.

>=20
> [root@setebos ~]# mdadm /dev/md3 --grow --bitmap=3Dinternal
> mdadm: failed to set internal bitmap.
> [root@setebos ~]# dmesg|tail -n 16
> [10455.564598] mdadm: sending ioctl 1261 to a partition!
> [10455.564601] mdadm: sending ioctl 1261 to a partition!
> [10455.566566] mdadm: sending ioctl 1261 to a partition!
> [10455.566570] mdadm: sending ioctl 1261 to a partition!
> [10455.568480] md3: invalid bitmap file superblock: bad magic
> [10455.568483] md3: bitmap file superblock:
> [10455.568485]          magic: 00000000
> [10455.568487]        version: 0
> [10455.568489]           uuid: 00000000.00000000.00000000.00000000
> [10455.568491]         events: 0
> [10455.568492] events cleared: 0
> [10455.568494]          state: 00000000
> [10455.568495]      chunksize: 0 B
> [10455.568497]   daemon sleep: 0s
> [10455.568498]      sync size: 0 KB
> [10455.568499] max write behind: 0
> [root@setebos ~]# mdadm --detail /dev/md3
> /dev/md3:
>         Version : 1.2
>   Creation Time : Thu Mar  8 13:54:16 2012
>      Raid Level : raid1
>      Array Size : 931760807 (888.60 GiB 954.12 GB)
>   Used Dev Size : 931760807 (888.60 GiB 954.12 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>=20
>     Update Time : Thu Mar  8 18:46:11 2012
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>            Name : rescue:3
>            UUID : 390e347b:c63b1a0e:1ff4f4a5:bc51f5c6
>          Events : 24
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        4        0      active sync   /dev/sda4
>        1       8       20        1      active sync   /dev/sdb4
> [root@setebos ~]# cat /proc/mdstat
> Personalities : [raid1]
> md3 : active raid1 sda4[0] sdb4[1]
>       931760807 blocks super 1.2 [2/2] [UU]
>=20
> md1 : active raid1 sda2[0] sdb2[1]
>       995904 blocks [2/2] [UU]
>=20
> md0 : active raid1 sda1[0] sdb1[1]
>       3999117 blocks super 1.2 [2/2] [UU]
>=20
> md2 : active raid1 sda3[0] sdb3[1]
>       40000754 blocks super 1.2 [2/2] [UU]
>       bitmap: 1/1 pages [4KB], 65536KB chunk
>=20
> unused devices: <none>
> [root@setebos ~]#


--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
