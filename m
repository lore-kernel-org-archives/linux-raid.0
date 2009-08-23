From: =?UTF-8?Q?Lucian_=C8=98andor?= <lucisandor@gmail.com>
Subject: Re: RAID5 reshape past 100%
Date: Sun, 23 Aug 2009 18:39:21 -0400
Message-ID: <c775b4470908231539o4a0ab494vc717146d47219062@mail.gmail.com>
References: <c775b4470908230502o6fa41danf4281ed58f0e82a9@mail.gmail.com>
	<da29e42a203b94c238e8829394b21861.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <da29e42a203b94c238e8829394b21861.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for your reply.

I think I ran into some bug of /proc/mdstat. I am new to all this and
I have no idea about the right number of blocks, but I am suspecting
the number of blocks from mdstat is incorrect. (I hope this is it, for
the sake of my data.)

Apparently the reshaping ended a few minutes ago. Here's the situation =
now:

battlecruiser:~ # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid0] [raid1]
md2 : active raid5 sde8[6] sdc8[0] sdb8[5] sdf8[4] sda8[3] sdd8[1]
      4773231360 blocks super 1.0 level 5, 128k chunk, algorithm 0
[6/6] [UUUUUU]

battlecruiser:~ # mdadm --examine /dev/sda8
/dev/sda8:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : ed7d15cd:1cad6a1c:3b3f4b49:ea68d0c6
           Name : linux:2
  Creation Time : Tue Jul  7 23:37:30 2009
     Raid Level : raid5
   Raid Devices : 6
 Avail Dev Size : 1909292784 (910.42 GiB 977.56 GB)
     Array Size : 9546462720 (4552.11 GiB 4887.79 GB)
  Used Dev Size : 1909292544 (910.42 GiB 977.56 GB)
   Super Offset : 1909293040 sectors
          State : active
    Device UUID : b53ba38b:2c061f4a:3c3c7a8f:480eec39
    Update Time : Sun Aug 23 18:21:49 2009
       Checksum : db057e4d - correct
         Events : 1864669
         Layout : left-asymmetric
     Chunk Size : 128K
    Array Slot : 3 (0, 1, failed, 2, 3, 4, 5)
   Array State : uuUuuu 1 failed

battlecruiser:~ # mdadm --detail /dev/md2
/dev/md2:
        Version : 1.00
  Creation Time : Tue Jul  7 23:37:30 2009
     Raid Level : raid5
     Array Size : 4773231360 (4552.11 GiB 4887.79 GB)
  Used Dev Size : 1909292544 (1820.84 GiB 1955.12 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent
    Update Time : Sun Aug 23 18:24:10 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
         Layout : left-asymmetric
     Chunk Size : 128K
           Name : linux:2
           UUID : ed7d15cd:1cad6a1c:3b3f4b49:ea68d0c6
         Events : 1864668
    Number   Major   Minor   RaidDevice State
       0       8       40        0      active sync   /dev/sdc8
       1       8       56        1      active sync   /dev/sdd8
       3       8        8        2      active sync   /dev/sda8
       4       8       88        3      active sync   /dev/sdf8
       5       8       24        4      active sync   /dev/sdb8
       6       8       72        5      active sync   /dev/sde8

battlecruiser:~ # zcat /var/log/messages-20090823.gz | grep md
Aug 22 06:47:47 battlecruiser kernel: md: md2: resync done.
Aug 22 06:49:10 battlecruiser kernel: JBD: barrier-based sync failed
on md2 - disabling barriers
Aug 22 07:02:23 battlecruiser kernel:  CIFS VFS: No response for cmd 50=
 mid 8
Aug 22 15:52:03 battlecruiser kernel: md: bind<sde8>
Aug 22 15:53:37 battlecruiser kernel: md: couldn't update array info. -=
16
Aug 22 15:54:13 battlecruiser kernel: md: reshape of RAID array md2
Aug 22 15:54:13 battlecruiser kernel: md: minimum _guaranteed_  speed:
1000 KB/sec/disk.
Aug 22 15:54:13 battlecruiser kernel: md: using maximum available idle
IO bandwidth (but not more than 200000 KB/sec) for reshape.
Aug 22 15:54:13 battlecruiser kernel: md: using 128k window, over a
total of 954646272 blocks.
Aug 23 07:34:59 battlecruiser kernel: md: couldn't update array info. -=
16

(This last one appears to be the moment when it goes past 100%.)

battlecruiser:~ # cat /var/log/messages | grep md
Aug 23 12:01:45 battlecruiser kernel: EXT3 FS on md2, internal journal
Aug 23 12:01:54 battlecruiser kernel: JBD: barrier-based sync failed
on md2 - disabling barriers
Aug 23 18:12:13 battlecruiser kernel: md: md2: reshape done.

(I thought I disabled barriers manually when booting with grub, but I
cannot remember.)

I am using SuSE 11.1 all upd-to-date; kernel version is 2.6.27.29
default, mdadm is " v3.0-devel2 - 5th November 2008". Since a few
hours ago I mounted the array (reshaping was after that online), but
the strange behavior pre-dates the mount operation.

I did not restore the internal bitmap (am I allowed? am I required?).
I am worried about the persistent error regarding the number of
blocks, the position of the superblock (huge headache, as I have no
idea, except it could be erroneous), and also about the "failed"
status (although that seems a known bug).

I am pondering whether to extend the file system.

Best,
Lucian


2009/8/23 NeilBrown <neilb@suse.de>:
> On Sun, August 23, 2009 10:02 pm, Lucian =C8=98andor wrote:
>> Hi all,
>>
>> I am growing a RAID5 to the sixth disk which used to be spare. When =
I
>> woke up this morning, I found reshape went over 100%.
>>
>> Here are some details:
>
> And very odd details they are!
> Can you tell me exactly what version of mdadm and Linux you are using=
,
> and provide the kernel logs from the time when the reshape started
> and anything else from the kernel logs that might be related to this
> arrays?
>
> Thanks,
> NeilBrown
>
>
>>
>> The newest drive is sde8. Prior to starting the grow operation, I
>> removed the internal bitmap (otherwise grow fails). After starting t=
he
>> reshape I increased speed_limit_min to 500000 and speed_limit_max to
>> 5000000.
>>
>> battlecruiser:~ # cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4] [raid0] [raid1]
>> md2 : active raid5 sde8[6] sdc8[0] sdb8[5] sdf8[4] sda8[3] sdd8[1]
>> =C2=A0 =C2=A0 =C2=A0 3818585088 blocks super 1.0 level 5, 128k chunk=
, algorithm 0
>> [6/6] [UUUUUU]
>> =C2=A0 =C2=A0 =C2=A0 [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D>] =C2=A0reshape =3D106.5% (508767236/477323136)
>> finish=3D39803743.6min speed=3D7148K/sec
>> ..... other RAIDs.....
>> unused devices: <none>
>>
>>
>> battlecruiser:~ # mdadm --detail /dev/md2
>> /dev/md2:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.00
>> =C2=A0 Creation Time : Tue Jul =C2=A07 23:37:30 2009
>> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
>> =C2=A0 =C2=A0 =C2=A0Array Size : 3818585088 (3641.69 GiB 3910.23 GB)
>> =C2=A0 Used Dev Size : 1909292544 (1820.84 GiB 1955.12 GB)
>> =C2=A0 =C2=A0Raid Devices : 6
>> =C2=A0 Total Devices : 6
>> =C2=A0 =C2=A0 Persistence : Superblock is persistent
>> =C2=A0 =C2=A0 Update Time : Sun Aug 23 07:49:05 2009
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
>> =C2=A0Active Devices : 6
>> Working Devices : 6
>> =C2=A0Failed Devices : 0
>> =C2=A0 Spare Devices : 0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-asymmetric
>> =C2=A0 =C2=A0 =C2=A0Chunk Size : 128K
>> =C2=A0 Delta Devices : 1, (5->6)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : linux:2
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : ed7d15cd:1cad6a1c:3b=
3f4b49:ea68d0c6
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 1574658
>> =C2=A0 =C2=A0 Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice Sta=
te
>> =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 40 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sdc8
>> =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 56 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sdd8
>> =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 =C2=A08 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active syn=
c =C2=A0 /dev/sda8
>> =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 88 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sdf8
>> =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 24 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sdb8
>> =C2=A0 =C2=A0 =C2=A0 =C2=A06 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=
=A0 72 =C2=A0 =C2=A0 =C2=A0 =C2=A05 =C2=A0 =C2=A0 =C2=A0active sync =C2=
=A0 /dev/sde8
>>
>>
>> battlecruiser:~ # mdadm --examine /dev/sda8
>> /dev/sda8:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.0
>> =C2=A0 =C2=A0 Feature Map : 0x4
>> =C2=A0 =C2=A0 =C2=A0Array UUID : ed7d15cd:1cad6a1c:3b3f4b49:ea68d0c6
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : linux:2
>> =C2=A0 Creation Time : Tue Jul =C2=A07 23:37:30 2009
>> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
>> =C2=A0 =C2=A0Raid Devices : 6
>> =C2=A0Avail Dev Size : 1909292784 (910.42 GiB 977.56 GB)
>> =C2=A0 =C2=A0 =C2=A0Array Size : 9546462720 (4552.11 GiB 4887.79 GB)
>> =C2=A0 Used Dev Size : 1909292544 (910.42 GiB 977.56 GB)
>> =C2=A0 =C2=A0Super Offset : 1909293040 sectors
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
>> =C2=A0 =C2=A0 Device UUID : b53ba38b:2c061f4a:3c3c7a8f:480eec39
>> =C2=A0 Reshape pos'n : 2557671680 (2439.19 GiB 2619.06 GB)
>> =C2=A0 Delta Devices : 1 (5->6)
>> =C2=A0 =C2=A0 Update Time : Sun Aug 23 07:54:32 2009
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : d2e31480 - correct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 1576210
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-asymmetric
>> =C2=A0 =C2=A0 =C2=A0Chunk Size : 128K
>> =C2=A0 =C2=A0 Array Slot : 3 (0, 1, failed, 2, 3, 4, 5)
>> =C2=A0 =C2=A0Array State : uuUuuu 1 failed
>>
>> battlecruiser:~ # mdadm --examine /dev/sde8
>> /dev/sde8:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : a92b4efc
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 1.0
>> =C2=A0 =C2=A0 Feature Map : 0x4
>> =C2=A0 =C2=A0 =C2=A0Array UUID : ed7d15cd:1cad6a1c:3b3f4b49:ea68d0c6
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Name : linux:2
>> =C2=A0 Creation Time : Tue Jul =C2=A07 23:37:30 2009
>> =C2=A0 =C2=A0 =C2=A0Raid Level : raid5
>> =C2=A0 =C2=A0Raid Devices : 6
>> =C2=A0Avail Dev Size : 1909292784 (910.42 GiB 977.56 GB)
>> =C2=A0 =C2=A0 =C2=A0Array Size : 9546462720 (4552.11 GiB 4887.79 GB)
>> =C2=A0 Used Dev Size : 1909292544 (910.42 GiB 977.56 GB)
>> =C2=A0 =C2=A0Super Offset : 1909293040 sectors
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : clean
>> =C2=A0 =C2=A0 Device UUID : 0829adf4:f920807f:b99e30b9:43010401
>> =C2=A0 Reshape pos'n : 2559514880 (2440.94 GiB 2620.94 GB)
>> =C2=A0 Delta Devices : 1 (5->6)
>> =C2=A0 =C2=A0 Update Time : Sun Aug 23 07:55:13 2009
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Checksum : 6254b335 - correct
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 1576450
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Layout : left-asymmetric
>> =C2=A0 =C2=A0 =C2=A0Chunk Size : 128K
>> =C2=A0 =C2=A0 Array Slot : 6 (0, 1, failed, 2, 3, 4, 5)
>> =C2=A0 =C2=A0Array State : uuuuuU 1 failed
>>
>> I am a bit confused, since according to examine commands, the grow
>> operation is ongoing. Also, some of these commands show the raid as
>> failed, some as clean.
>>
>> What should I do next? I am tempted to restart reshaping, but then
>> maybe examine output is correct.
>>
>> Thanks in advance,
>> Lucian
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
