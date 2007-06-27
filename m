From: Simon <simon.xhz@gmail.com>
Subject: spare not becoming active
Date: Wed, 27 Jun 2007 16:34:53 -0400
Message-ID: <4682C9ED.9040503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
  not sure if this is the place to ask, as i'm trying to use and learn raids. So 
i lack some knowledge of the general practice and still having trouble figuring 
out mdadm...

Anyways, the story is simple, i had a raid5 going on 3 usb keys.  The keys are 
partitioned with fdisk to have 1 first ext2 device and a second  raid-autodetect 
device (i didn't know what to choose here, i belive it doesn't matter if i don't 
bood with it...?)

All 3 arrays were active and nice, i decided to make an experiment and pull on 
one (i wasn't sure if it was safe to do, but) and I immediately saw it was 
missing. I removed it, replugged the drive, mounted partition 1, fine, add to 
array, fine.  Array started reconstructing here i think.

Then another drive, that i was suspecting of being faulty died.  I did the same 
remove/add procedure and it was there as spare.

Below are some outputs you'll recognize, my question is, how do you get the 
spare ones to become active again?  And I currently have one active device, 
while I'm supposed to have at least two (to survive on raid5).  So, what about 
the data (i dont care as it was just a test, but) is it completely lost, are 
there chances?

Thanks for any info/pointers!
   Simon

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
[multipath] [faulty]
md0 : active raid5 sdf2[3](S) sde2[4](S) sdd2[5](F) sdc2[1] sdb2[6](F)
       1952128 blocks level 5, 64k chunk, algorithm 2 [3/1] [_U_]
============================================================================
/dev/md0:
         Version : 00.90.03
   Creation Time : Sun Jun 24 09:30:24 2007
      Raid Level : raid5
      Array Size : 1952128 (1906.70 MiB 1998.98 MB)
   Used Dev Size : 976064 (953.35 MiB 999.49 MB)
    Raid Devices : 3
   Total Devices : 5
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Wed Jun 27 16:35:44 2007
           State : clean, degraded
  Active Devices : 1
Working Devices : 3
  Failed Devices : 2
   Spare Devices : 2

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 170691d8:28aaa115:628a7a6d:3715a011
          Events : 0.834

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        1       8       34        1      active sync   /dev/sdc2
        2       0        0        2      removed

        3       8       82        -      spare   /dev/sdf2
        4       8       66        -      spare   /dev/sde2
        5       8       50        -      faulty spare
        6       8       18        -      faulty spare
============================================================================
brw-rw---- 1 root disk 8,  1 Jun 22 23:24 /dev/sda1
brw-rw---- 1 root disk 8, 33 Jun 22 23:24 /dev/sdc1
brw-rw---- 1 root disk 8, 65 Jun 27 14:26 /dev/sde1
brw-rw---- 1 root disk 8, 81 Jun 27 15:14 /dev/sdf1
============================================================================
[dev   9,   0] /dev/md0         170691D8.28AAA115.628A7A6D.3715A011 online
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing
[dev   8,  34] /dev/sdc2        170691D8.28AAA115.628A7A6D.3715A011 good
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing
[dev   8,  82] /dev/sdf2        170691D8.28AAA115.628A7A6D.3715A011 spare
[dev   8,  66] /dev/sde2        170691D8.28AAA115.628A7A6D.3715A011 spare
