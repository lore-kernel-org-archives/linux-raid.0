From: NeilBrown <neilb@suse.de>
Subject: Re: invalid bitmap file superblock: bad magic
Date: Fri, 9 Mar 2012 07:00:41 +1100
Message-ID: <20120309070041.558a4ca6@notabene.brown>
References: <201203081711.17836.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kMTthS940dlGTJFGTWwVCIa"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203081711.17836.a.miskiewicz@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arkadiusz =?UTF-8?B?TWnFm2tpZXdpY3o=?= <a.miskiewicz@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kMTthS940dlGTJFGTWwVCIa
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Mar 2012 17:11:17 +0100 Arkadiusz Mi=C5=9Bkiewicz
<a.miskiewicz@gmail.com> wrote:

> Hello.
>=20
> I'm trying to create internal bitmap on freshly created
> raid1 array on 3.2.6 kernel.
>=20
> What's going on and how to fix this problem?

There is a bug in the latest mdadm which causes this.
It is fixed in git, or use a slightly older mdadm.

I notice a subsequent email where it magically started working.  I cannot
explain that - something must have happened to trigger it.

NeilBrown


>=20
> [root@setebos ~]# mdadm /dev/md3 --grow --bitmap=3Dinternal              =
                                                                           =
         =20
> mdadm: failed to set internal bitmap.
> [root@setebos ~]# dmesg|tail -n 16                                       =
                                                                           =
       =20
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
>=20
>=20


--Sig_/kMTthS940dlGTJFGTWwVCIa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1kP6Tnsnt1WYoG5AQLOnA//bfnKsy/Y/jKy/EGDNyfljCtTTR1UcaNB
iVG9oFqtF6oxjlzcOZmq1Zn6QFMYzPndqxUHROu8WBb8MSMwEOS/T/CRFsTn6ZAn
gMiXvQE4js0V21N8F5OgVmFfjk7AJiCmiYkXLw/ailNN1HKpc9mzKVtvoPSTz10u
GxgVlD1mj3D/JkTjABKM5uB+HPtOlJpUPICxuu1xEWWi1AE7KL69I2mK++wSr66v
xZG6MUCPFO+MYuWsoXTXDOi0hIdlozz6Uoz0zfTcfLI7mt9sUVp0Hkh1tSk1lEoe
bkzRE+WNpcD5kpXRKN5DU1VrCBZtYWDCc1+PRB2yg9MbCmhzNHQuhwh3MbfWwsSs
Dn8FlWQsVIgsZoOdbDY5CdN1x+DKeZPXl5H7/rjCDVk2Y4zN+kcsgArD3eVh5Mpf
Dh7ELA6f8S7DzHkMqQ4u2yBYgin0O9qC6EZgXLuNeyKgkyGrRO6uWzJzLDdNoZ8k
zFcp72SSlxByynbv3CnSwmDHiUKanfqr8bikj7imYca8+gqvZenMwEduH8iFEmvF
9ivey413wpFxlBnJy/6uYfehntH/xk4WKIQVx5bF672UUcScn9mkU4zfO3scVuYJ
UL5TXUJXeNd5GjMzAAVgbL+/FTXD8yto3avQuz41+GtR6m7s7bdk9FwB4FYIPL1h
TWqi4M3ILiU=
=DBFv
-----END PGP SIGNATURE-----

--Sig_/kMTthS940dlGTJFGTWwVCIa--
