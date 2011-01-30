From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 00:18:34 +0000
Message-ID: <AANLkTik4MGS7V7ePBgbk+KW-FcBBV7MuYgB7n29RRXF=@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<AANLkTi=SbAM3BXxjH6Mvcn-Tw4b0FYyLjLFqSGuxY1fk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=SbAM3BXxjH6Mvcn-Tw4b0FYyLjLFqSGuxY1fk@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29 January 2011 23:26, CoolCold <coolthecold@gmail.com> wrote:
> You may need to increase stripe cache size
> http://peterkieser.com/2009/11/29/raid-mdraid-stripe_cache_size-vs-wr=
ite-transfer/
>
> On Sun, Jan 30, 2011 at 1:48 AM, Mathias Bur=C3=A9n <mathias.buren@gm=
ail.com> wrote:
>> Hi,
>>
>> I'm wondering if the performance I'm getting is OK or if there's
>> something I can do about it. Also, where the potential bottlenecks
>> are.
>>
>> Setup: 6x2TB HDDs, their performance:
>>
>> /dev/sdb:
>> =C2=A0Timing cached reads: =C2=A0 1322 MB in =C2=A02.00 seconds =3D =
661.51 MB/sec
>> =C2=A0Timing buffered disk reads: 362 MB in =C2=A03.02 seconds =3D 1=
20.06 MB/sec
>>
>> /dev/sdc:
>> =C2=A0Timing cached reads: =C2=A0 1282 MB in =C2=A02.00 seconds =3D =
641.20 MB/sec
>> =C2=A0Timing buffered disk reads: 342 MB in =C2=A03.01 seconds =3D 1=
13.53 MB/sec
>>
>> /dev/sdd:
>> =C2=A0Timing cached reads: =C2=A0 1282 MB in =C2=A02.00 seconds =3D =
640.55 MB/sec
>> =C2=A0Timing buffered disk reads: 344 MB in =C2=A03.00 seconds =3D 1=
14.58 MB/sec
>>
>> /dev/sde:
>> =C2=A0Timing cached reads: =C2=A0 1328 MB in =C2=A02.00 seconds =3D =
664.46 MB/sec
>> =C2=A0Timing buffered disk reads: 350 MB in =C2=A03.01 seconds =3D 1=
16.37 MB/sec
>>
>> /dev/sdf:
>> =C2=A0Timing cached reads: =C2=A0 1304 MB in =C2=A02.00 seconds =3D =
651.55 MB/sec
>> =C2=A0Timing buffered disk reads: 378 MB in =C2=A03.01 seconds =3D 1=
25.62 MB/sec
>>
>> /dev/sdg:
>> =C2=A0Timing cached reads: =C2=A0 1324 MB in =C2=A02.00 seconds =3D =
661.91 MB/sec
>> =C2=A0Timing buffered disk reads: 400 MB in =C2=A03.00 seconds =3D 1=
33.15 MB/sec
>>
>> These are used in a RAID5 setup:
>>
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid5 sdf1[0] sdg1[6] sde1[5] sdc1[3] sdd1[4] sdb1[1]
>> =C2=A0 =C2=A0 =C2=A09751756800 blocks super 1.2 level 5, 64k chunk, =
algorithm 2 [6/6] [UUUUUU]
>>
>> unused devices: <none>
>>
>> /dev/md0:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 1.2
>> =C2=A0Creation Time : Tue Oct 19 08:58:41 2010
>> =C2=A0 =C2=A0 Raid Level : raid5
>> =C2=A0 =C2=A0 Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
>> =C2=A0Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
>> =C2=A0 Raid Devices : 6
>> =C2=A0Total Devices : 6
>> =C2=A0 =C2=A0Persistence : Superblock is persistent
>>
>> =C2=A0 =C2=A0Update Time : Fri Jan 28 14:55:48 2011
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>> =C2=A0Active Devices : 6
>> Working Devices : 6
>> =C2=A0Failed Devices : 0
>> =C2=A0Spare Devices : 0
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
>> =C2=A0 =C2=A0 Chunk Size : 64K
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Name : ion:0 =C2=A0(local to host=
 ion)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : e6595c64:b3ae90b3:f01133ac=
:3f402d20
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 3035769
>>
>> =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice Stat=
e
>> =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 8=
1 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sdf1
>> =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 1=
7 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sdb1
>> =C2=A0 =C2=A0 =C2=A0 4 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 4=
9 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sdd1
>> =C2=A0 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 3=
3 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sdc1
>> =C2=A0 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 6=
5 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sde1
>> =C2=A0 =C2=A0 =C2=A0 6 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 9=
7 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sdg1
>>
>> As you can see they are partitioned. They are all identical like thi=
s:
>>
>> Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
>> 81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 secto=
rs
>> Units =3D sectors of 1 * 512 =3D 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x0e5b3a7a
>>
>> =C2=A0 Device Boot =C2=A0 =C2=A0 =C2=A0Start =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 End =C2=A0 =C2=A0 =C2=A0Blocks =C2=A0 Id =C2=A0System
>> /dev/sdb1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02048 =C2=A0390702=
9167 =C2=A01953513560 =C2=A0 fd =C2=A0Linux raid autodetect
>>
>> On this I run LVM:
>>
>> =C2=A0--- Physical volume ---
>> =C2=A0PV Name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /dev/=
md0
>> =C2=A0VG Name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lvsto=
rage
>> =C2=A0PV Size =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 9.08 =
TiB / not usable 1.00 MiB
>> =C2=A0Allocatable =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 yes (but full)
>> =C2=A0PE Size =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1.00 =
MiB
>> =C2=A0Total PE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A095231=
99
>> =C2=A0Free PE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0
>> =C2=A0Allocated PE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A09523199
>> =C2=A0PV UUID =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 YLEUK=
B-klxF-X3gF-6dG3-DL4R-xebv-6gKQc2
>>
>> On top of the LVM I have:
>>
>> =C2=A0--- Volume group ---
>> =C2=A0VG Name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lvsto=
rage
>> =C2=A0System ID
>> =C2=A0Format =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
lvm2
>> =C2=A0Metadata Areas =C2=A0 =C2=A0 =C2=A0 =C2=A01
>> =C2=A0Metadata Sequence No =C2=A06
>> =C2=A0VG Access =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 read/write
>> =C2=A0VG Status =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 resizable
>> =C2=A0MAX LV =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0
>> =C2=A0Cur LV =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
1
>> =C2=A0Open LV =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1
>> =C2=A0Max PV =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0
>> =C2=A0Cur PV =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
1
>> =C2=A0Act PV =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
1
>> =C2=A0VG Size =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 9.08 =
TiB
>> =C2=A0PE Size =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1.00 =
MiB
>> =C2=A0Total PE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A095231=
99
>> =C2=A0Alloc PE / Size =C2=A0 =C2=A0 =C2=A0 9523199 / 9.08 TiB
>> =C2=A0Free =C2=A0PE / Size =C2=A0 =C2=A0 =C2=A0 0 / 0
>> =C2=A0VG UUID =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Xd0HT=
M-azdN-v9kJ-C7vD-COcU-Cnn8-6AJ6hI
>>
>> And in turn:
>>
>> =C2=A0--- Logical volume ---
>> =C2=A0LV Name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
/dev/lvstorage/storage
>> =C2=A0VG Name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
lvstorage
>> =C2=A0LV UUID =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
9wsJ0u-0QMs-lL5h-E2UA-7QJa-l46j-oWkSr3
>> =C2=A0LV Write Access =C2=A0 =C2=A0 =C2=A0 =C2=A0read/write
>> =C2=A0LV Status =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0avai=
lable
>> =C2=A0# open =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 1
>> =C2=A0LV Size =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
9.08 TiB
>> =C2=A0Current LE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 9523199
>> =C2=A0Segments =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1
>> =C2=A0Allocation =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inherit
>> =C2=A0Read ahead sectors =C2=A0 =C2=A0 auto
>> =C2=A0- currently set to =C2=A0 =C2=A0 1280
>> =C2=A0Block device =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 254:1
>>
>> And on that (sorry) there's the ext4 partition:
>>
>> /dev/mapper/lvstorage-storage on /raid5volume type ext4
>> (rw,noatime,barrier=3D1,nouser_xattr)
>>
>> Here are the numbers:
>>
>> /raid5volume $ time dd if=3D/dev/zero of=3D./bigfile.tmp bs=3D1M cou=
nt=3D8192
>> 8192+0 records in
>> 8192+0 records out
>> 8589934592 bytes (8.6 GB) copied, 94.0967 s, 91.3 MB/s
>>
>> real =C2=A0 =C2=A01m34.102s
>> user =C2=A0 =C2=A00m0.107s
>> sys =C2=A0 =C2=A0 0m54.693s
>>
>> /raid5volume $ time dd if=3D./bigfile.tmp of=3D/dev/null bs=3D1M
>> 8192+0 records in
>> 8192+0 records out
>> 8589934592 bytes (8.6 GB) copied, 37.8557 s, 227 MB/s
>>
>> real =C2=A0 =C2=A00m37.861s
>> user =C2=A0 =C2=A00m0.053s
>> sys =C2=A0 =C2=A0 0m23.608s
>>
>> I saw that the process md0_raid5 spike sometimes on CPU usage. This =
is
>> an Atom @ 1.6GHz, is that what is limiting the results? Here's
>> bonnie++:
>>
>> /raid5volume/temp $ time bonnie++ -d ./ -m ion
>> Writing with putc()...done
>> Writing intelligently...done
>> Rewriting...done
>> Reading with getc()...done
>> Reading intelligently...done
>> start 'em...done...done...done...
>> Create files in sequential order...done.
>> Stat files in sequential order...done.
>> Delete files in sequential order...done.
>> Create files in random order...done.
>> Stat files in random order...done.
>> Delete files in random order...done.
>> Version 1.03e =C2=A0 =C2=A0 =C2=A0 ------Sequential Output------ --S=
equential Input- --Random-
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
-Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
>> Machine =C2=A0 =C2=A0 =C2=A0 =C2=A0Size K/sec %CP K/sec %CP K/sec %C=
P K/sec %CP K/sec %CP =C2=A0/sec %CP
>> ion =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A07G 13726 =C2=A09=
8 148051 =C2=A087 68020 =C2=A041 14547 =C2=A099 286647
>> 61 404.1 =C2=A0 2
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
------Sequential Create------ --------Random Create--------
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
-Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0files =C2=A0/sec %CP=
 =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec=
 %CP
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 16 20707 =C2=
=A099 +++++ +++ 25870 =C2=A099 21242 =C2=A098 +++++ +++ 25630 100
>> ion,7G,13726,98,148051,87,68020,41,14547,99,286647,61,404.1,2,16,207=
07,99,+++++,+++,25870,99,21242,98,+++++,+++,25630,100
>>
>> real =C2=A0 =C2=A020m54.320s
>> user =C2=A0 =C2=A016m10.447s
>> sys =C2=A0 =C2=A0 2m45.543s
>>
>>
>> Thanks in advance,
>> // Mathias
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
>
> --
> Best regards,
> [COOLCOLD-RIPN]
>

I ran the benchmark found on the page (except for writes); results:

tripe_cache_size: 256 (1/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 63.4351 s, 271 MB/s
stripe_cache_size: 256 (2/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 59.8224 s, 287 MB/s
stripe_cache_size: 256 (3/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 62.1066 s, 277 MB/s
stripe_cache_size: 512 (1/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 59.6833 s, 288 MB/s
stripe_cache_size: 512 (2/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 60.3497 s, 285 MB/s
stripe_cache_size: 512 (3/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 59.7853 s, 287 MB/s
stripe_cache_size: 768 (1/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 59.5398 s, 288 MB/s
stripe_cache_size: 768 (2/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 60.1769 s, 285 MB/s
stripe_cache_size: 768 (3/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 60.5354 s, 284 MB/s
stripe_cache_size: 1024 (1/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 60.1814 s, 285 MB/s
stripe_cache_size: 1024 (2/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 61.6288 s, 279 MB/s
stripe_cache_size: 1024 (3/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 61.9942 s, 277 MB/s
stripe_cache_size: 2048 (1/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 61.177 s, 281 MB/s
stripe_cache_size: 2048 (2/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 61.3905 s, 280 MB/s
stripe_cache_size: 2048 (3/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 61.0274 s, 281 MB/s
stripe_cache_size: 4096 (1/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 62.607 s, 274 MB/s
stripe_cache_size: 4096 (2/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 63.1505 s, 272 MB/s
stripe_cache_size: 4096 (3/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 61.4747 s, 279 MB/s
stripe_cache_size: 8192 (1/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 62.0839 s, 277 MB/s
stripe_cache_size: 8192 (2/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 62.7944 s, 274 MB/s
stripe_cache_size: 8192 (3/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 61.4443 s, 280 MB/s
stripe_cache_size: 16834 (1/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 61.9554 s, 277 MB/s
stripe_cache_size: 16834 (2/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 63.8002 s, 269 MB/s
stripe_cache_size: 16834 (3/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 62.2772 s, 276 MB/s
stripe_cache_size: 32768 (1/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 62.4692 s, 275 MB/s
stripe_cache_size: 32768 (2/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 61.6707 s, 279 MB/s
stripe_cache_size: 32768 (3/3)
5460+0 records in
5460+0 records out
17175674880 bytes (17 GB) copied, 63.4744 s, 271 MB/s

It looks like a small stripe cache is favoured here.

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
