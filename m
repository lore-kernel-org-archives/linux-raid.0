From: acostoya <adrian@costoya.com>
Subject: Expanding a RAID-5 in use from 3 disks to 6 disks
Date: Thu, 5 Jul 2007 16:01:36 -0700 (PDT)
Message-ID: <11456058.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

I've being trying to set a 6 disk RAID-5 for a few days but it took only 3
disks (the other 3 gave Device busy error); in the meantime, an old server
went out of order so I have to use the incomplete host and it is now online
with user files.

The question is, is there a way to expand my RAID-5 from 3 disks to 6 disks
without losing data?.

Below is the basic information I could collect.

Best Regard,

Adrian Costoya
Metrovision Producciones S.A.
Buenos Aires - Argentina


[root@NAS-1 /]# uname -a
Linux NAS-1 2.6.18-1.2798.fc6xen #1 SMP Mon Oct 16 15:11:19 EDT 2006 i686
i686 i386 GNU/Linux


[root@NAS-1 /]# mdadm -V
mdadm - v2.6.1 - 22nd February 2007


[root@NAS-1 /]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 sdc1[3](S) sdb1[4](S) sde1[0] sda1[5](S) sdd1[2] sdf1[1]
      625137152 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      
unused devices: <none>


[root@NAS-1 /]# mdadm --detail /dev/md0 
/dev/md0:
        Version : 00.90.03
  Creation Time : Tue May 15 12:37:48 2007
     Raid Level : raid5
     Array Size : 625137152 (596.18 GiB 640.14 GB)
  Used Dev Size : 312568576 (298.09 GiB 320.07 GB)
   Raid Devices : 3
  Total Devices : 6
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jul  5 19:17:52 2007
          State : clean
 Active Devices : 3
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 3

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : e5842e95:a8f9aa19:fe6f0d66:a15f32ab
         Events : 0.72

    Number   Major   Minor   RaidDevice State
       0       8       65        0      active sync   /dev/sde1
       1       8       81        1      active sync   /dev/sdf1
       2       8       49        2      active sync   /dev/sdd1

       3       8       33        -      spare   /dev/sdc1
       4       8       17        -      spare   /dev/sdb1
       5       8        1        -      spare   /dev/sda1
[root@NAS-1 /]# 



-- 
View this message in context: http://www.nabble.com/Expanding-a-RAID-5-in-use-from-3-disks-to-6-disks-tf4032761.html#a11456058
Sent from the linux-raid mailing list archive at Nabble.com.

