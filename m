From: Oliver Martin <oliver@volatilevoid.net>
Subject: Rebuild doesn't start
Date: Tue, 11 Aug 2009 01:56:58 +0200
Message-ID: <20090811015658.53da7ca8@ors.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have two raid5 arrays spanning a number of USB drives. Yesterday, I
unintentionally unplugged one of them while connecting another device
to the same hub. The drive I unplugged used to be /dev/sdh, but when I
plugged it back in, it became /dev/sdi. For md0, this didn't matter. I
re-added it and it performed a rebuild* which completed successfully.

md1, which used to consist of sde2 and sdh2, should now contain sde2
and sdi2. For some reason, though, the rebuild doesn't start when I add
sdi2. It seems md doesn't recognize sdi2 as the same device that used
to be sdh2. Is that correct? How can I tell md about the name change?


Thanks,
Oliver

[*] Bitmaps are enabled on both arrays, so I was somewhat surprised
about the full rebuild; isn't that what bitmaps are supposed to prevent?


$ mdadm /dev/md1 -a /dev/sdi2
mdadm: re-added /dev/sdi2

$ cat /proc/mdstat 
[...]
md1 : active raid5 sdi2[0](F) sde2[2]
      488375808 blocks super 1.1 level 5, 64k chunk, algorithm 2 [2/1] [_U]
      bitmap: 0/8 pages [0KB], 32768KB chunk

$ mdadm -D /dev/md1
/dev/md1:
        Version : 1.01
  Creation Time : Sun Apr 12 14:19:47 2009
     Raid Level : raid5
     Array Size : 488375808 (465.75 GiB 500.10 GB)
  Used Dev Size : 488375808 (465.75 GiB 500.10 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Aug 11 01:40:15 2009
          State : active, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : quassel:1  (local to host quassel)
           UUID : e9226e7f:cbdad2a1:481ce05b:9444d71d
         Events : 106

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       2       8       66        1      active sync   /dev/sde2

       0       8      130        -      faulty spare   /dev/sdi2

$ mdadm -E /dev/sde2
/dev/sde2:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : e9226e7f:cbdad2a1:481ce05b:9444d71d
           Name : quassel:1  (local to host quassel)
  Creation Time : Sun Apr 12 14:19:47 2009
     Raid Level : raid5
   Raid Devices : 2

 Avail Dev Size : 976751736 (465.75 GiB 500.10 GB)
     Array Size : 976751616 (465.75 GiB 500.10 GB)
  Used Dev Size : 976751616 (465.75 GiB 500.10 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 0fcc7d6d:0ec92b47:c371f8e6:bd7d2cac

Internal Bitmap : 2 sectors from superblock
    Update Time : Tue Aug 11 01:40:18 2009
       Checksum : 4290b585 - correct
         Events : 108

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 2 (failed, failed, 1)
   Array State : _U 2 failed

$ mdadm -E /dev/sdi2
/dev/sdi2:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : e9226e7f:cbdad2a1:481ce05b:9444d71d
           Name : quassel:1  (local to host quassel)
  Creation Time : Sun Apr 12 14:19:47 2009
     Raid Level : raid5
   Raid Devices : 2

 Avail Dev Size : 976751736 (465.75 GiB 500.10 GB)
     Array Size : 976751616 (465.75 GiB 500.10 GB)
  Used Dev Size : 976751616 (465.75 GiB 500.10 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 5ba69d85:c46d6bb0:bf71606e:2877b067

Internal Bitmap : 2 sectors from superblock
    Update Time : Mon Aug 10 15:32:23 2009
       Checksum : 6db9f21 - correct
         Events : 28

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 0 (failed, failed, 1)
   Array State : _u 2 failed
