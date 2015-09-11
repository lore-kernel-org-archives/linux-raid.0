From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: raid role number off on one array?
Date: Thu, 10 Sep 2015 22:26:19 -0500
Message-ID: <55F249DB.5010908@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

All,

   This is a follow-up to "Re-add of raid1 drive resulted in strange loss of 
data on Archlinux?" posted 9/1. As a brief background there, running the 4.1.6 
kernel, for some reason on boot, the system never made an attempt to activate 
sda7, part of my raid1 array of the root filesystem. Updates were done before 
the degraded array was discovered. Upon re-add of sda7 to the array, re-sync 
appeared to have completed fine, but on next reboot, the system crashed due to 
some 440 0-byte files in /lib and (and in the kernel module tree). It was as if 
the re-sync corrupted all files in the filesystem that had been updated while 
the array was in degraded mode, rather than properly copying them from sdb7 to 
sda7 to restore the array. I still have no idea how that could occur.

   Now checking my arrays with mdstat I find:

# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sda7[2] sdb7[1]
       52396032 blocks super 1.2 [2/2] [UU]

md3 : active raid1 sda6[0] sdb6[1]
       1047552 blocks super 1.2 [2/2] [UU]

md0 : active raid1 sdb5[1] sda5[0]
       204608 blocks super 1.2 [2/2] [UU]

md2 : active raid1 sdb8[1] sda8[0]
       922944192 blocks super 1.2 [2/2] [UU]
       bitmap: 0/7 pages [0KB], 65536KB chunk

unused devices: <none>

   What has me worried is the "raid role numbers" following md1, e.g.:

md1 : active raid1 sda7[2] sdb7[1]

   My concern is why is sda7 shown as being in role [2] and sdb7 shown in [1]? 
All other arrays are [0][1]. What concerns me is the information at:

http://tldp.org/HOWTO/Software-RAID-HOWTO-6.html

   Specifically discussing an array with n-devices (2 in my case), the howto states:

"Any device with "n" or higher are spare disks. 0,1,..,n-1 are for the working 
array."

   Huh? A spare?

   Checking the detail shows everything is OK, but not knowing more about what 
the significance of the role number, or what it is saying in my case (in light 
of the tldp quote, I thought I would check here to make sure there isn't 
something going on with this array I should be concerned with. Here is the detail:

# mdadm -D /dev/md1
/dev/md1:
         Version : 1.2
   Creation Time : Wed Nov 27 04:35:49 2013
      Raid Level : raid1
      Array Size : 52396032 (49.97 GiB 53.65 GB)
   Used Dev Size : 52396032 (49.97 GiB 53.65 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

     Update Time : Thu Sep 10 21:33:11 2015
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : archiso:1
            UUID : 320d86f7:22999af5:5eeefee1:35cd8970
          Events : 103373

     Number   Major   Minor   RaidDevice State
        2       8        7        0      active sync   /dev/sda7
        1       8       23        1      active sync   /dev/sdb7

   How can sda77 be RaidDevice '0' but Number '2' in the array? This is running on:

Linux phoinix 4.1.6-1-ARCH #1 SMP PREEMPT Mon Aug 17 08:52:28 CEST 2015 x86_64 
GNU/Linux

   What say the experts?


-- 
David C. Rankin, J.D.,P.E.
