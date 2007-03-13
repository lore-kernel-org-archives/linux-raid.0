From: Tomka Gergely <gergely@tomka.hu>
Subject: sw raid0 read bottleneck
Date: Tue, 13 Mar 2007 17:23:14 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0703131713280.18749@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I am currently testing 3ware raid cards. Now i have 15 disks, and on these 
a swraid0. The write speed seems good (700 MBps), but the read performance 
only 350 MBps. Another problem when i try to read with two process, then 
the _sum_ of the read speeds fall back to 200 MBps. So there is a 
bottleneck, or something i need to know, but i dont have ideas. 

The details:

/dev/md0:
        Version : 00.90.03
  Creation Time : Tue Mar 13 16:57:32 2007
     Raid Level : raid0
     Array Size : 7325797440 (6986.43 GiB 7501.62 GB)
   Raid Devices : 15
  Total Devices : 15
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Mar 13 16:57:32 2007
          State : clean
 Active Devices : 15
Working Devices : 15
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

# uname -a
Linux ursula 2.6.18-4-686-bigmem #1 SMP Wed Feb 21 17:30:22 UTC 2007 i686 
GNU/Linux

# xfs_info /mnt/
meta-data=/dev/md0               isize=256    agcount=32, agsize=57232784 
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=1831449088, 
imaxpct=25
         =                       sunit=16     swidth=240 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=983040 blocks=0, rtextents=0

(all software Debian Etch)

four Intel(R) Xeon(TM) CPU 3.00GHz

two 3ware 9590SE-8ML on PCIe

Intel Corporation 5000P Chipset


-- 
Tomka Gergely, gergely@tomka.hu
