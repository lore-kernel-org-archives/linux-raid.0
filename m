From: Craig Hollabaugh <craig@hollabaugh.com>
Subject: RAID5 kicks non-fresh drives
Date: Thu, 25 May 2006 09:38:23 -0600
Message-ID: <1148571503.2772.35.camel@hendrix.hollabaugh.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Folks,

I had two drives fails on a 13 drive RAID5 array with bad-blocks
(confirmed this with external disk scan). I replaced and hot-added new
drives back into array. Resync completed without incident. I moved the
machine back into production and after reboot, the two new drives get
kicked out of array for being non-fresh. Everything I try results in
these two drives always getting kicked out.

Here's what I tried.
	searched and read for at least 10 hours for info on kicking
"non-fresh" 
	hot-adding then rebooting 5 times with same result
		using kernel 2.4.30, 2.6.11.8 and 2.6.16.8. 
		(resync takes 4 hours to complete, so iterations take a while)
	mdadm version is v1.12 
	after the resync before the reboot, manual stopping and starting the
array 
		always in correct operation (no kicking of drives)

My questions are
	1. How does a drive become non-fresh? 
	2. Is the non-fresh status related to 'events'?
	3. How can I determine that all the drives are fresh before a reboot?
	4. 2.4.30 and 2.6.11.8 dmesg output mentions kicking non-fresh drives.
		2.6.16.8 doesn't even consider my new drives, see "after reboot" below
	    After a resync, how can I determine that all my drives are actually
part of the array?
            mdadm -E /dev/sdX1  for each drive shows the same info. 
	5. From everything I've tried, the array looks fine before the reboot.
But no matter
		what I've tried, the drives are kicked upon reboot.   
	6. /proc/mdstat reports "Personalities : [raid5] [raid4]", the array is
raid5, 
		where raid4 come from?

Thanks for reading this and any suggestions you can offer.
Craig

-- 
------------------------------------------------------------
Dr. Craig Hollabaugh, craig@hollabaugh.com, 970 240 0509
Author of Embedded Linux: Hardware, Software and Interfacing
www.embeddedlinuxinterfacing.com




The two drives in question are sdj1 and sdk1.

Here's output after the resync before the reboot

root@vaughan[502]: cat /proc/mdstat
Personalities : [raid5] [raid4]
md0 : active raid5 sdj1[12](S) sdk1[9] sda1[0] sdl1[11] hdc1[10] sdd1[8]
sdh1[7] sdg1[6] sdf1[5] sde1[4] sdi1[3] sdc1[2] sdb1[1]
      1289056384 blocks level 5, 128k chunk, algorithm 2 [12/12]
[UUUUUUUUUUUU]

unused devices: <none>

root@vaughan[501]: mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Thu Jan 16 09:10:52 2003
     Raid Level : raid5
     Array Size : 1289056384 (1229.34 GiB 1319.99 GB)
    Device Size : 117186944 (111.76 GiB 120.00 GB)
   Raid Devices : 12
  Total Devices : 13
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu May 25 05:36:58 2006
          State : clean
 Active Devices : 12
Working Devices : 13
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

           UUID : 4d862825:91140f1a:eb97e7f2:9bfa2403
         Events : 0.2681049

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8      129        3      active sync   /dev/sdi1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1
       7       8      113        7      active sync   /dev/sdh1
       8       8       49        8      active sync   /dev/sdd1
       9       8      161        9      active sync   /dev/sdk1
      10      22        1       10      active sync   /dev/hdc1
      11       8      177       11      active sync   /dev/sdl1

      12       8      145        -      spare   /dev/sdj1

root@vaughan[512]: mdadm -E /dev/sdj1
/dev/sdj1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 4d862825:91140f1a:eb97e7f2:9bfa2403
  Creation Time : Thu Jan 16 09:10:52 2003
     Raid Level : raid5
   Raid Devices : 12
  Total Devices : 13
Preferred Minor : 0

    Update Time : Thu May 25 05:36:58 2006
          State : clean
 Active Devices : 12
Working Devices : 13
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 9943fc98 - correct
         Events : 0.2681049

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this    12       8      145       12      spare   /dev/sdj1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8      129        3      active sync   /dev/sdi1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       8      113        7      active sync   /dev/sdh1
   8     8       8       49        8      active sync   /dev/sdd1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10      22        1       10      active sync   /dev/hdc1
  11    11       8      177       11      active sync   /dev/sdl1
  12    12       8      145       12      spare   /dev/sdj1


------------------------------------------------------------------------------------------------
Now after reboot

root@vaughan[542]: uname -a
Linux vaughan 2.6.16.8 #1 Wed May 24 15:00:27 MDT 2006 i686 GNU/Linux

From dmesg
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdl1 ...
md:  adding sdl1 ...
md:  adding sdi1 ...
md:  adding sdh1 ...
md:  adding sdg1 ...
md:  adding sdf1 ...
md:  adding sde1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md:  adding hdc1 ...
md: created md0

The kernel didn't add sdj or sdk.


root@vaughan[501]: cat /proc/mdstat
Personalities : [raid5] [raid4]
md0 : active raid5 sdl1[11] sdi1[3] sdh1[7] sdg1[6] sdf1[5] sde1[4]
sdd1[8] sdc1[2] sdb1[1] sda1[0] hdc1[10]
      1289056384 blocks level 5, 128k chunk, algorithm 2 [12/11]
[UUUUUUUUU_UU]

unused devices: <none>

root@vaughan[502]: mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Thu Jan 16 09:10:52 2003
     Raid Level : raid5
     Array Size : 1289056384 (1229.34 GiB 1319.99 GB)
    Device Size : 117186944 (111.76 GiB 120.00 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu May 25 05:36:58 2006
          State : clean, degraded
 Active Devices : 11
Working Devices : 11
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           UUID : 4d862825:91140f1a:eb97e7f2:9bfa2403
         Events : 0.2681049

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8      129        3      active sync   /dev/sdi1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1
       7       8      113        7      active sync   /dev/sdh1
       8       8       49        8      active sync   /dev/sdd1
       9       0        0        -      removed
      10      22        1       10      active sync   /dev/hdc1
      11       8      177       11      active sync   /dev/sdl1


 root@vaughan[512]: mdadm -E /dev/sdj1
/dev/sdj1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 4d862825:91140f1a:eb97e7f2:9bfa2403
  Creation Time : Thu Jan 16 09:10:52 2003
     Raid Level : raid5
   Raid Devices : 12
  Total Devices : 13
Preferred Minor : 0

    Update Time : Thu May 25 05:36:58 2006
          State : clean
 Active Devices : 12
Working Devices : 13
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 9943fc98 - correct
         Events : 0.2681049

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this    12       8      145       12      spare   /dev/sdj1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8      129        3      active sync   /dev/sdi1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       8      113        7      active sync   /dev/sdh1
   8     8       8       49        8      active sync   /dev/sdd1
   9     9       8      161        9      active sync   /dev/sdk1
  10    10      22        1       10      active sync   /dev/hdc1
  11    11       8      177       11      active sync   /dev/sdl1
  12    12       8      145       12      spare   /dev/sdj1





