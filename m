From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Howto avoid full re-sync
Date: Fri, 07 Sep 2012 14:41:10 +1000
Message-ID: <50497AE6.2010005@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a MD raid6 with 5 drives, and every now and then one (random)
drive will fail. I've done all sorts of checks, and the drive is
actually working fine, so I suspect an issue with the Linux driver
and/or SATA controller (onboard).

It isn't really relevant to the question, but I'll run through the sata
stuff, in case anyone can point out a simple solution to stop this from
happening (yes, a new server is on the way, but with budgets etc, that
could be some time away. This issue has happened for years, but we are
becoming more active with these failures now).

00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
(rev a1)
00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller
(rev a1)
01:07.0 RAID bus controller: Silicon Image, Inc. Adaptec AAR-1210SA SATA
HostRAID Controller (rev 02)

cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md2 : active raid6 sdh1[5] sdg1[4] sdf1[0] sdd1[6](F) sde1[2] sda1[1]
      5860535808 blocks level 6, 64k chunk, algorithm 2 [5/4] [UUU_U]
      [>....................]  recovery =  1.4% (28663240/1953511936)
finish=486.5min speed=65938K/sec

(As you can see, sdd failed, but the kernel found it again as sdh, so
I've re-added it).

/dev/md2:
        Version : 0.90
  Creation Time : Fri Aug 11 21:45:20 2006
     Raid Level : raid6
     Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Fri Sep  7 14:31:10 2012
          State : clean, degraded, recovering
 Active Devices : 4
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 1% complete

           UUID : e6cfbc82:c23e52da:9cb07c6d:11629c30
         Events : 0.7762116

    Number   Major   Minor   RaidDevice State
       0       8       81        0      active sync   /dev/sdf1
       1       8        1        1      active sync   /dev/sda1
       2       8       65        2      active sync   /dev/sde1
       5       8      113        3      spare rebuilding   /dev/sdh1
       4       8       97        4      active sync   /dev/sdg1

       6       8       49        -      faulty spare


Since I know sdh is actually almost up to date, is there some way to
re-add it, and only have to sync the portions of the disk which have
changed?

Thanks,
Adam

-- 
Adam Goryachev
Website Managers
Ph: +61 2 8304 0000                            adam@websitemanagers.com.au
Fax: +61 2 8304 0001                            www.websitemanagers.com.au

