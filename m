From: =?ISO-8859-1?Q?Tor_Arne_Vestb=F8?= <torarnv@gmail.com>
Subject: Creating RAID5 with four devices and end up with 5 (one removed and one spare). Why?
Date: Mon, 3 Mar 2008 09:55:45 +0100
Message-ID: <47CBBD11.4020501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I'm trying to build a Linux RAID5 with four (4) 750GB disks, but not 
matter what I do I end up with mdadm listing five (5) devices and 
telling me that one of them is a spare, and another one is 
failed/removed. I've been googling and reading HOWTOs for a week now, 
but can't figure it out. Here's what I do:

monstre:~/buildroot # mdadm --create /dev/md0 --level=5 --raid-devices=4 
/dev/sd[cdef]1

mdadm: /dev/sdc1 appears to contain an ext2fs file system
     size=-2097251968K  mtime=Wed Feb 27 00:26:57 2008
mdadm: /dev/sdc1 appears to be part of a raid array:
     level=raid5 devices=4 ctime=Tue Feb 26 20:47:24 2008
mdadm: /dev/sdd1 appears to be part of a raid array:
     level=raid5 devices=4 ctime=Tue Feb 26 20:47:24 2008
mdadm: /dev/sde1 appears to be part of a raid array:
     level=raid5 devices=4 ctime=Tue Feb 26 20:47:24 2008
mdadm: /dev/sdf1 appears to contain an ext2fs file system
     size=-1560381056K  mtime=Wed Feb 27 00:26:57 2008
mdadm: /dev/sdf1 appears to be part of a raid array:
     level=raid5 devices=4 ctime=Tue Feb 26 20:47:24 2008
Continue creating array? y
mdadm: array /dev/md0 started.

monstre:~/buildroot # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active(auto-read-only) raid5 sdf1[4](S) sde1[2] sdd1[1] sdc1[0]
       2197715712 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]

unused devices: <none>


monstre:~/buildroot # mdadm --detail /dev/md0
/dev/md0:
         Version : 00.90.03
   Creation Time : Tue Feb 26 20:57:46 2008
      Raid Level : raid5
      Array Size : 2197715712 (2095.91 GiB 2250.46 GB)
   Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Tue Feb 26 20:57:46 2008
           State : clean, degraded
  Active Devices : 3
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 8b498455:0ab45ac1:ebf26e3f:56a9fc2f
          Events : 0.1

     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        1       8       49        1      active sync   /dev/sdd1
        2       8       65        2      active sync   /dev/sde1
        3       0        0        3      removed

        4       8       81        -      spare   /dev/sdf1


monstre: # mdadm --examine /dev/sdd1
/dev/sdd1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : a0186556:4ffb5a2a:822f8875:94ae7d2c
   Creation Time : Sun Mar  2 22:52:53 2008
      Raid Level : raid5
   Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
      Array Size : 2197715712 (2095.91 GiB 2250.46 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 0

     Update Time : Sun Mar  2 22:59:54 2008
           State : clean
  Active Devices : 3
Working Devices : 4
  Failed Devices : 1
   Spare Devices : 1
        Checksum : 6b5e8442 - correct
          Events : 0.22

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync   /dev/sdd1

    0     0       8       33        0      active sync   /dev/sdc1
    1     1       8       49        1      active sync   /dev/sdd1
    2     2       8       65        2      active sync   /dev/sde1
    3     3       0        0        3      faulty removed
    4     4       8       81        4      spare   /dev/sdf1

-------------------

So what i don't get is:

1. Why is mdadm --examine listing "3     3       0        0        3 
   faulty removed" and telling me I have a failed device?
2. Why is one of the actual disks (sdf) used as a spare, even though I 
didn't ask for it?

Thanks for any tips or insights which may put me on the right track :)

Tor Arne
