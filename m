From: CoolCold <coolthecold@gmail.com>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 02:26:44 +0300
Message-ID: <AANLkTi=SbAM3BXxjH6Mvcn-Tw4b0FYyLjLFqSGuxY1fk@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

You may need to increase stripe cache size
http://peterkieser.com/2009/11/29/raid-mdraid-stripe_cache_size-vs-writ=
e-transfer/

On Sun, Jan 30, 2011 at 1:48 AM, Mathias Bur=E9n <mathias.buren@gmail.c=
om> wrote:
> Hi,
>
> I'm wondering if the performance I'm getting is OK or if there's
> something I can do about it. Also, where the potential bottlenecks
> are.
>
> Setup: 6x2TB HDDs, their performance:
>
> /dev/sdb:
> =A0Timing cached reads: =A0 1322 MB in =A02.00 seconds =3D 661.51 MB/=
sec
> =A0Timing buffered disk reads: 362 MB in =A03.02 seconds =3D 120.06 M=
B/sec
>
> /dev/sdc:
> =A0Timing cached reads: =A0 1282 MB in =A02.00 seconds =3D 641.20 MB/=
sec
> =A0Timing buffered disk reads: 342 MB in =A03.01 seconds =3D 113.53 M=
B/sec
>
> /dev/sdd:
> =A0Timing cached reads: =A0 1282 MB in =A02.00 seconds =3D 640.55 MB/=
sec
> =A0Timing buffered disk reads: 344 MB in =A03.00 seconds =3D 114.58 M=
B/sec
>
> /dev/sde:
> =A0Timing cached reads: =A0 1328 MB in =A02.00 seconds =3D 664.46 MB/=
sec
> =A0Timing buffered disk reads: 350 MB in =A03.01 seconds =3D 116.37 M=
B/sec
>
> /dev/sdf:
> =A0Timing cached reads: =A0 1304 MB in =A02.00 seconds =3D 651.55 MB/=
sec
> =A0Timing buffered disk reads: 378 MB in =A03.01 seconds =3D 125.62 M=
B/sec
>
> /dev/sdg:
> =A0Timing cached reads: =A0 1324 MB in =A02.00 seconds =3D 661.91 MB/=
sec
> =A0Timing buffered disk reads: 400 MB in =A03.00 seconds =3D 133.15 M=
B/sec
>
> These are used in a RAID5 setup:
>
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdf1[0] sdg1[6] sde1[5] sdc1[3] sdd1[4] sdb1[1]
> =A0 =A0 =A09751756800 blocks super 1.2 level 5, 64k chunk, algorithm =
2 [6/6] [UUUUUU]
>
> unused devices: <none>
>
> /dev/md0:
> =A0 =A0 =A0 =A0Version : 1.2
> =A0Creation Time : Tue Oct 19 08:58:41 2010
> =A0 =A0 Raid Level : raid5
> =A0 =A0 Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
> =A0Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
> =A0 Raid Devices : 6
> =A0Total Devices : 6
> =A0 =A0Persistence : Superblock is persistent
>
> =A0 =A0Update Time : Fri Jan 28 14:55:48 2011
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 6
> Working Devices : 6
> =A0Failed Devices : 0
> =A0Spare Devices : 0
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0 =A0 =A0 Name : ion:0 =A0(local to host ion)
> =A0 =A0 =A0 =A0 =A0 UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
> =A0 =A0 =A0 =A0 Events : 3035769
>
> =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> =A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdf1
> =A0 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb1
> =A0 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdd1
> =A0 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sdc1
> =A0 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A04 =A0 =A0 =A0=
active sync =A0 /dev/sde1
> =A0 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A05 =A0 =A0 =A0=
active sync =A0 /dev/sdg1
>
> As you can see they are partitioned. They are all identical like this=
:
>
> Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sector=
s
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x0e5b3a7a
>
> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
> /dev/sdb1 =A0 =A0 =A0 =A0 =A0 =A02048 =A03907029167 =A01953513560 =A0=
 fd =A0Linux raid autodetect
>
> On this I run LVM:
>
> =A0--- Physical volume ---
> =A0PV Name =A0 =A0 =A0 =A0 =A0 =A0 =A0 /dev/md0
> =A0VG Name =A0 =A0 =A0 =A0 =A0 =A0 =A0 lvstorage
> =A0PV Size =A0 =A0 =A0 =A0 =A0 =A0 =A0 9.08 TiB / not usable 1.00 MiB
> =A0Allocatable =A0 =A0 =A0 =A0 =A0 yes (but full)
> =A0PE Size =A0 =A0 =A0 =A0 =A0 =A0 =A0 1.00 MiB
> =A0Total PE =A0 =A0 =A0 =A0 =A0 =A0 =A09523199
> =A0Free PE =A0 =A0 =A0 =A0 =A0 =A0 =A0 0
> =A0Allocated PE =A0 =A0 =A0 =A0 =A09523199
> =A0PV UUID =A0 =A0 =A0 =A0 =A0 =A0 =A0 YLEUKB-klxF-X3gF-6dG3-DL4R-xeb=
v-6gKQc2
>
> On top of the LVM I have:
>
> =A0--- Volume group ---
> =A0VG Name =A0 =A0 =A0 =A0 =A0 =A0 =A0 lvstorage
> =A0System ID
> =A0Format =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lvm2
> =A0Metadata Areas =A0 =A0 =A0 =A01
> =A0Metadata Sequence No =A06
> =A0VG Access =A0 =A0 =A0 =A0 =A0 =A0 read/write
> =A0VG Status =A0 =A0 =A0 =A0 =A0 =A0 resizable
> =A0MAX LV =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00
> =A0Cur LV =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01
> =A0Open LV =A0 =A0 =A0 =A0 =A0 =A0 =A0 1
> =A0Max PV =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00
> =A0Cur PV =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01
> =A0Act PV =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01
> =A0VG Size =A0 =A0 =A0 =A0 =A0 =A0 =A0 9.08 TiB
> =A0PE Size =A0 =A0 =A0 =A0 =A0 =A0 =A0 1.00 MiB
> =A0Total PE =A0 =A0 =A0 =A0 =A0 =A0 =A09523199
> =A0Alloc PE / Size =A0 =A0 =A0 9523199 / 9.08 TiB
> =A0Free =A0PE / Size =A0 =A0 =A0 0 / 0
> =A0VG UUID =A0 =A0 =A0 =A0 =A0 =A0 =A0 Xd0HTM-azdN-v9kJ-C7vD-COcU-Cnn=
8-6AJ6hI
>
> And in turn:
>
> =A0--- Logical volume ---
> =A0LV Name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/dev/lvstorage/storage
> =A0VG Name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lvstorage
> =A0LV UUID =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A09wsJ0u-0QMs-lL5h-E2UA-7QJa-=
l46j-oWkSr3
> =A0LV Write Access =A0 =A0 =A0 =A0read/write
> =A0LV Status =A0 =A0 =A0 =A0 =A0 =A0 =A0available
> =A0# open =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1
> =A0LV Size =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A09.08 TiB
> =A0Current LE =A0 =A0 =A0 =A0 =A0 =A0 9523199
> =A0Segments =A0 =A0 =A0 =A0 =A0 =A0 =A0 1
> =A0Allocation =A0 =A0 =A0 =A0 =A0 =A0 inherit
> =A0Read ahead sectors =A0 =A0 auto
> =A0- currently set to =A0 =A0 1280
> =A0Block device =A0 =A0 =A0 =A0 =A0 254:1
>
> And on that (sorry) there's the ext4 partition:
>
> /dev/mapper/lvstorage-storage on /raid5volume type ext4
> (rw,noatime,barrier=3D1,nouser_xattr)
>
> Here are the numbers:
>
> /raid5volume $ time dd if=3D/dev/zero of=3D./bigfile.tmp bs=3D1M coun=
t=3D8192
> 8192+0 records in
> 8192+0 records out
> 8589934592 bytes (8.6 GB) copied, 94.0967 s, 91.3 MB/s
>
> real =A0 =A01m34.102s
> user =A0 =A00m0.107s
> sys =A0 =A0 0m54.693s
>
> /raid5volume $ time dd if=3D./bigfile.tmp of=3D/dev/null bs=3D1M
> 8192+0 records in
> 8192+0 records out
> 8589934592 bytes (8.6 GB) copied, 37.8557 s, 227 MB/s
>
> real =A0 =A00m37.861s
> user =A0 =A00m0.053s
> sys =A0 =A0 0m23.608s
>
> I saw that the process md0_raid5 spike sometimes on CPU usage. This i=
s
> an Atom @ 1.6GHz, is that what is limiting the results? Here's
> bonnie++:
>
> /raid5volume/temp $ time bonnie++ -d ./ -m ion
> Writing with putc()...done
> Writing intelligently...done
> Rewriting...done
> Reading with getc()...done
> Reading intelligently...done
> start 'em...done...done...done...
> Create files in sequential order...done.
> Stat files in sequential order...done.
> Delete files in sequential order...done.
> Create files in random order...done.
> Stat files in random order...done.
> Delete files in random order...done.
> Version 1.03e =A0 =A0 =A0 ------Sequential Output------ --Sequential =
Input- --Random-
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0-Per Chr- --Block-- -Rewrite- =
-Per Chr- --Block-- --Seeks--
> Machine =A0 =A0 =A0 =A0Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K=
/sec %CP =A0/sec %CP
> ion =A0 =A0 =A0 =A0 =A0 =A0 =A07G 13726 =A098 148051 =A087 68020 =A04=
1 14547 =A099 286647
> 61 404.1 =A0 2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0------Sequential Create------ =
--------Random Create--------
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0-Create-- --Read--- -Delete-- =
-Create-- --Read--- -Delete--
> =A0 =A0 =A0 =A0 =A0 =A0 =A0files =A0/sec %CP =A0/sec %CP =A0/sec %CP =
=A0/sec %CP =A0/sec %CP =A0/sec %CP
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 16 20707 =A099 +++++ +++ 25870 =A099 =
21242 =A098 +++++ +++ 25630 100
> ion,7G,13726,98,148051,87,68020,41,14547,99,286647,61,404.1,2,16,2070=
7,99,+++++,+++,25870,99,21242,98,+++++,+++,25630,100
>
> real =A0 =A020m54.320s
> user =A0 =A016m10.447s
> sys =A0 =A0 2m45.543s
>
>
> Thanks in advance,
> // Mathias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
