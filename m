From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re-add not selecting drive for correct slot?
Date: Thu, 06 Aug 2015 23:09:37 -0600
Message-ID: <1817382.9YhZ7ff5Yl@balsa>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again.

I had a drive disappear off the bus while I was out of town. I just
Pulled it and installed a replacement drive. The problem is that 
another drive was kicked when I pulled the failed drive.

Looking at the array info, it should be re-add'able, the event counts
are very close.

Thinking I'm smarter than I really am, I tried a:
$ mdadm --manage /dev/md0 --re-add /dev/sdb

But that returned with device or resource busy, obviously the
array is still holding onto it. Then I:
$ mdadm --remove /dev/md0 /dev/sdb
$ mdadm --manage /dev/md0 --re-add /dev/sdb

But that just added it as a spare, and wiped the slot/role data that
was once in the --examine output.

After that I tried force assembling, but it refused saying it only found
5 active and 1 spare device which is not enough to start the array.

Is there a way to convince mdadm to assemble this into a working
degraded array?

Also, sdc has a much lower event count than the other drives, is that
normal?

/dev/sdc is the first drive that failed
/dev/sdb is the one that was kicked after

mdstat:
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 sdb[0](F) sdh[7] sdg[5] sdf[4] sde[3] sdd[2] sdc[1](F)
      11720297472 blocks super 1.2 level 5, 512k chunk, algorithm 2 [7/5] [__UUUUU]
      bitmap: 15/15 pages [60KB], 65536KB chunk

mdadm --examine:
 
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : c8032dba:053904e3:1648d92b:0695b265
           Name : mrbig:0  (local to host mrbig)
  Creation Time : Sun Jun 14 14:06:22 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720297472 (11177.35 GiB 12001.58 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c1efb1f8:edd4ab44:c8b95abd:6b1cdbf8

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Aug  6 18:28:32 2015
       Checksum : b1dea42e - correct
         Events : 2053

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A.AAAAA ('A' == active, '.' == missing)

/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : c8032dba:053904e3:1648d92b:0695b265
           Name : mrbig:0  (local to host mrbig)
  Creation Time : Sun Jun 14 14:06:22 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720297472 (11177.35 GiB 12001.58 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 32917d29:916c3a57:41d93b82:6790c6bb

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Aug  6 21:42:20 2015
       Checksum : 7d069e27 - correct
         Events : 2057

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : ..AAAAA ('A' == active, '.' == missing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : c8032dba:053904e3:1648d92b:0695b265
           Name : mrbig:0  (local to host mrbig)
  Creation Time : Sun Jun 14 14:06:22 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720297472 (11177.35 GiB 12001.58 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 7b68d82f:68da74b2:01837fec:ab08918e

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Aug  6 21:42:20 2015
       Checksum : 1baa054d - correct
         Events : 2057

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : ..AAAAA ('A' == active, '.' == missing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : c8032dba:053904e3:1648d92b:0695b265
           Name : mrbig:0  (local to host mrbig)
  Creation Time : Sun Jun 14 14:06:22 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720297472 (11177.35 GiB 12001.58 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 27de04b5:e5eabe72:e7f1ada8:36402334

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Aug  6 21:42:20 2015
       Checksum : c2e131e7 - correct
         Events : 2057

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : ..AAAAA ('A' == active, '.' == missing)
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : c8032dba:053904e3:1648d92b:0695b265
           Name : mrbig:0  (local to host mrbig)
  Creation Time : Sun Jun 14 14:06:22 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720297472 (11177.35 GiB 12001.58 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 001e01c6:7482a410:83a61537:05eb9308

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Aug  6 21:42:20 2015
       Checksum : d49b68ba - correct
         Events : 2057

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : ..AAAAA ('A' == active, '.' == missing)
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : c8032dba:053904e3:1648d92b:0695b265
           Name : mrbig:0  (local to host mrbig)
  Creation Time : Sun Jun 14 14:06:22 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720297472 (11177.35 GiB 12001.58 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : e1553922:dbf9da9f:060762fa:c6786762

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Aug  6 21:42:20 2015
       Checksum : dd2a0649 - correct
         Events : 2057

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : ..AAAAA ('A' == active, '.' == missing)

/dev/sdj: (was /dev/sdc, its installed in a different machine now)
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : c8032dba:053904e3:1648d92b:0695b265
           Name : mrbig:0
  Creation Time : Sun Jun 14 14:06:22 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720297472 (11177.35 GiB 12001.58 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1200 sectors
          State : clean
    Device UUID : 9f42a955:9a978bd1:baf8290b:d397e4f2

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri Jul 31 16:27:56 2015
       Checksum : e389672e - correct
         Events : 101

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)


Distro: Debian Sid
Kernel: 3.16.7-ckt4-3~bpo70+1
Mdadm: v3.2.5 (from debian)

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
