From: Rui Santos <rsantos@grupopie.com>
Subject: Re: RAID5 in sync does not populate slots sequentially, shows array
 as (somewhat) faulty
Date: Thu, 06 Mar 2008 14:51:11 +0000
Message-ID: <47D004DF.9050301@grupopie.com>
References: <47CBD62E.7040608@rabbit.us> <47CD279F.2070500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47CD279F.2070500@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: =?ISO-8859-1?Q?Tor_Arne_Vestb=F8?= <torarnv@gmail.com>
List-Id: linux-raid.ids

Tor Arne Vestb=F8 wrote:
> Not sure if this is at all related to your problem, but one of the=20
> things I tried was to shred all the old drives in the system that wer=
e=20
> not going to be part of the array.
>
> /dev/sda system (250GB) <-- shred
> /dev/sdb home (250GB) <-- shred
>
> /dev/sdc raid (750GB)
> /dev/sdd raid (750GB)
> /dev/sde raid (750GB)
> /dev/sdf raid (750GB)
>
> The reason I did this was because /dev/sda and /dev/sdb used to be=20
> part of a RAID1 array, but were now used as system disk and home disk=
=20
> respectively. I was afraid that mdadm would pick up on some of the=20
> lingering RAID superblocks on those disks when reporting, so I=20
> shredded them both using 'shred -n 1' and reinstalled.
>
> Don't know if that affected anything at all for me, since the actual=20
> problem was that I didn't wait for a full resync, but now you know :)
>
> Tor Arne
Hi all,

I have a identical problem. But it didn't went way with the zeroing=20
superblock / shred procedure. I also have no extra discs.
Here is my config:

~# cat /proc/mdstat:
md0 : active raid1 sda1[0] sdc1[2] sdb1[1]
          136508 blocks super 1.0 [3/3] [UUU]
          bitmap: 0/9 pages [0KB], 8KB chunk

md1 : active raid5 sdb2[0] sda2[3] sdc2[1]
          1060096 blocks super 1.0 level 5, 128k chunk, algorithm 2=20
[3/3] [UUU]

md2 : active raid5 sda3[0] sdc3[3] sdb3[1]
          780083968 blocks super 1.0 level 5, 128k chunk, algorithm 2=20
[3/3] [UUU]


~# mdadm -D /dev/md{0,1,2}
/dev/md0:
        Version : 01.00.03
  Creation Time : Wed Feb 27 15:38:43 2008
     Raid Level : raid1
     Array Size : 136508 (133.33 MiB 139.78 MB)
  Used Dev Size : 136508 (133.33 MiB 139.78 MB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Mar  6 14:38:08 2008
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

           Name : 0
           UUID : c5e9420d:67e022ae:eaf9fc3e:4949a042
         Events : 20

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
/dev/md1:
        Version : 01.00.03
  Creation Time : Thu Mar  6 13:14:36 2008
     Raid Level : raid5
     Array Size : 1060096 (1035.42 MiB 1085.54 MB)
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Thu Mar  6 14:38:08 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           Name : 1
           UUID : 3e76c555:d423cd7d:b1454b79:f34e6322
         Events : 4

    Number   Major   Minor   RaidDevice State
       0       8       18        0      active sync   /dev/sdb2
       1       8       34        1      active sync   /dev/sdc2
       3       8        2        2      active sync   /dev/sda2
/dev/md2:
        Version : 01.00.03
  Creation Time : Wed Feb 27 15:38:46 2008
     Raid Level : raid5
     Array Size : 780083968 (743.95 GiB 798.81 GB)
  Used Dev Size : 780083968 (371.97 GiB 399.40 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Thu Mar  6 14:38:08 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           Name : 2
           UUID : a55c4f4e:8cba34b7:b5f70bb0:97fd1366
         Events : 5070

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       3       8       35        2      active sync   /dev/sdc3

unused devices: <none>



~# mdadm -E /dev/sd{a1,b1,c1,a2,b2,c2,a3,b3,c3}
/dev/sda1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x1
     Array UUID : c5e9420d:67e022ae:eaf9fc3e:4949a042
           Name : 0
  Creation Time : Wed Feb 27 15:38:43 2008
     Raid Level : raid1
   Raid Devices : 3

  Used Dev Size : 273016 (133.33 MiB 139.78 MB)
     Array Size : 273016 (133.33 MiB 139.78 MB)
   Super Offset : 273024 sectors
          State : clean
    Device UUID : 678a316f:e7a2a641:14c1c3f0:b55d6aae

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Mar  6 14:38:11 2008
       Checksum : c5d6af8b - correct
         Events : 20


    Array Slot : 0 (0, 1, 2)
   Array State : Uuu
/dev/sdb1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x1
     Array UUID : c5e9420d:67e022ae:eaf9fc3e:4949a042
           Name : 0
  Creation Time : Wed Feb 27 15:38:43 2008
     Raid Level : raid1
   Raid Devices : 3

  Used Dev Size : 273016 (133.33 MiB 139.78 MB)
     Array Size : 273016 (133.33 MiB 139.78 MB)
   Super Offset : 273024 sectors
          State : clean
    Device UUID : 17525ff0:fe48f81d:8f28e04c:34901f21

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Mar  6 14:38:11 2008
       Checksum : f227b74c - correct
         Events : 20


    Array Slot : 1 (0, 1, 2)
   Array State : uUu
/dev/sdc1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x1
     Array UUID : c5e9420d:67e022ae:eaf9fc3e:4949a042
           Name : 0
  Creation Time : Wed Feb 27 15:38:43 2008
     Raid Level : raid1
   Raid Devices : 3

  Used Dev Size : 273016 (133.33 MiB 139.78 MB)
     Array Size : 273016 (133.33 MiB 139.78 MB)
   Super Offset : 273024 sectors
          State : clean
    Device UUID : c3e00260:dfa90f02:3c39380b:b090375e

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Mar  6 14:38:11 2008
       Checksum : 4152b803 - correct
         Events : 20


    Array Slot : 2 (0, 1, 2)
   Array State : uuU
/dev/sda2:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x0
     Array UUID : 3e76c555:d423cd7d:b1454b79:f34e6322
           Name : 1
  Creation Time : Thu Mar  6 13:14:36 2008
     Raid Level : raid5
   Raid Devices : 3

  Used Dev Size : 1060264 (517.79 MiB 542.86 MB)
     Array Size : 2120192 (1035.42 MiB 1085.54 MB)
      Used Size : 1060096 (517.71 MiB 542.77 MB)
   Super Offset : 1060272 sectors
          State : clean
    Device UUID : 2bd8b81f:6e38a263:9c1a48f5:81c2cbc8

    Update Time : Thu Mar  6 14:38:11 2008
       Checksum : e9afe694 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 3 (0, 1, failed, 2)
   Array State : uuU 1 failed
/dev/sdb2:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x0
     Array UUID : 3e76c555:d423cd7d:b1454b79:f34e6322
           Name : 1
  Creation Time : Thu Mar  6 13:14:36 2008
     Raid Level : raid5
   Raid Devices : 3

  Used Dev Size : 1060264 (517.79 MiB 542.86 MB)
     Array Size : 2120192 (1035.42 MiB 1085.54 MB)
      Used Size : 1060096 (517.71 MiB 542.77 MB)
   Super Offset : 1060272 sectors
          State : clean
    Device UUID : 18c77f52:4bbbf090:31a3724c:b7cafa3c

    Update Time : Thu Mar  6 14:38:11 2008
       Checksum : 151ee926 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 0 (0, 1, failed, 2)
   Array State : Uuu 1 failed
/dev/sdc2:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x0
     Array UUID : 3e76c555:d423cd7d:b1454b79:f34e6322
           Name : 1
  Creation Time : Thu Mar  6 13:14:36 2008
     Raid Level : raid5
   Raid Devices : 3

  Used Dev Size : 1060264 (517.79 MiB 542.86 MB)
     Array Size : 2120192 (1035.42 MiB 1085.54 MB)
      Used Size : 1060096 (517.71 MiB 542.77 MB)
   Super Offset : 1060272 sectors
          State : clean
    Device UUID : 19fd5caf:ff6a3e82:95c84b1d:8ec60429

    Update Time : Thu Mar  6 14:38:11 2008
       Checksum : 202cf017 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 1 (0, 1, failed, 2)
   Array State : uUu 1 failed
/dev/sda3:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x0
     Array UUID : a55c4f4e:8cba34b7:b5f70bb0:97fd1366
           Name : 2
  Creation Time : Wed Feb 27 15:38:46 2008
     Raid Level : raid5
   Raid Devices : 3

  Used Dev Size : 780083992 (371.97 GiB 399.40 GB)
     Array Size : 1560167936 (743.95 GiB 798.81 GB)
      Used Size : 780083968 (371.97 GiB 399.40 GB)
   Super Offset : 780084248 sectors
          State : active
    Device UUID : 590ac9c2:e4ae82b3:1248d87a:d655dd7c

    Update Time : Thu Mar  6 14:39:49 2008
       Checksum : 4de7b99b - correct
         Events : 5071

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 0 (0, 1, failed, 2)
   Array State : Uuu 1 failed
/dev/sdb3:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x0
     Array UUID : a55c4f4e:8cba34b7:b5f70bb0:97fd1366
           Name : 2
  Creation Time : Wed Feb 27 15:38:46 2008
     Raid Level : raid5
   Raid Devices : 3

  Used Dev Size : 780083992 (371.97 GiB 399.40 GB)
     Array Size : 1560167936 (743.95 GiB 798.81 GB)
      Used Size : 780083968 (371.97 GiB 399.40 GB)
   Super Offset : 780084248 sectors
          State : active
    Device UUID : 9589b278:38932876:414d8879:b9c70fe7

    Update Time : Thu Mar  6 14:39:49 2008
       Checksum : 2f59943e - correct
         Events : 5071

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 1 (0, 1, failed, 2)
   Array State : uUu 1 failed
/dev/sdc3:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x0
     Array UUID : a55c4f4e:8cba34b7:b5f70bb0:97fd1366
           Name : 2
  Creation Time : Wed Feb 27 15:38:46 2008
     Raid Level : raid5
   Raid Devices : 3

  Used Dev Size : 780083992 (371.97 GiB 399.40 GB)
     Array Size : 1560167936 (743.95 GiB 798.81 GB)
      Used Size : 780083968 (371.97 GiB 399.40 GB)
   Super Offset : 780084248 sectors
          State : active
    Device UUID : a8a110fa:75d91ef2:5e0376a7:dad76b1a

    Update Time : Thu Mar  6 14:39:49 2008
       Checksum : 8df7b8ce - correct
         Events : 5071

         Layout : left-symmetric
     Chunk Size : 128K

    Array Slot : 3 (0, 1, failed, 2)
   Array State : uuU 1 failed


As you can see, all of RAID5 devices state that it is failed. On the=20
other hand, the RAID device reports the array as clean. You can also se=
e=20
the discrepancies in the array slots composition.
Anyway, this only happens when I use 1.0 or 1.1 superblock ( didn't try=
=20
1.2 ). If I use the 0.9 superblocks all problems are solved. I'm able t=
o=20
test with one of the arrays, if some test is needed or advised.
I'm using a 2.6.24 x86_64 kernel ( SuSE ) and mdadm v2.6.2 ( also tried=
=20
v2.6.4 with no success ). Also as stated, on this setup, exist only=20
three disk with three partitions ( 0xFD ) each to build three raid arra=
ys.

Thanks for your help,
Rui Santos

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
