From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: How best to re-sync raid1 array? zero superblock on removed disk
 and let it rebuild?
Date: Fri, 28 Aug 2015 04:22:09 -0500
Message-ID: <55E02841.9050701@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

All,

   I had a disc-controller failure on a server running several raid1 arrays. The 
disks are fine, but I have had the root partition come up in degraded mode. What 
is the best way to tell mdraid to resync the disks? Here are the symptoms:

# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sdb7[1]
       52396032 blocks super 1.2 [2/1] [_U]

md3 : active raid1 sdb6[1] sda6[0]
       1047552 blocks super 1.2 [2/2] [UU]

md2 : active raid1 sda8[0] sdb8[1]
       922944192 blocks super 1.2 [2/2] [UU]
       bitmap: 0/7 pages [0KB], 65536KB chunk

md0 : active raid1 sda5[0] sdb5[1]
       204608 blocks super 1.2 [2/2] [UU]

unused devices: <none>

# mdadm --misc --detail /dev/md1
/dev/md1:
         Version : 1.2
   Creation Time : Wed Nov 27 04:35:49 2013
      Raid Level : raid1
      Array Size : 52396032 (49.97 GiB 53.65 GB)
   Used Dev Size : 52396032 (49.97 GiB 53.65 GB)
    Raid Devices : 2
   Total Devices : 1
     Persistence : Superblock is persistent

     Update Time : Fri Aug 28 04:12:18 2015
           State : clean, degraded
  Active Devices : 1
Working Devices : 1
  Failed Devices : 0
   Spare Devices : 0

            Name : archiso:1
            UUID : 320d86f7:22999af5:5eeefee1:35cd8970
          Events : 100308

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        1       8       23        1      active sync   /dev/sdb7

Reading, it looks like one approach is the boot the install media and then zero 
the superblock on /dev/sda7 and then reboot. Will that force a rebuild, or do I 
need to fail and remove the disk first? I was thinking:

# mdadm --zero-superblock /dev/sda7

should set it up for a rebuild without more. Is this a sane approach?

-- 
David C. Rankin, J.D.,P.E.
