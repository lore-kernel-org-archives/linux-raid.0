From: Iruwen <iruwen@gmx.net>
Subject: Disk with backup-file died during reshape
Date: Mon, 26 Aug 2013 13:38:43 +0200
Message-ID: <521B3E43.5050707@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

the disk holding backup-file unfortunately died during an mdadm --grow 
/dev/md0 --level=6 --raid-devices=4 --backup-file=/mnt/backup/md0.bak.
The speed of the reshape dropped to 0K/sec, apart from that the RAID 
seems fine.


Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sda1[4] sdc1[2] sdd1[3] sdb1[1]
       2930271232 blocks super 1.2 level 6, 512k chunk, algorithm 18 
[4/3] [UUU_]
       [==========>..........]  reshape = 53.6% (786497536/1465135616) 
finish=55405950.5min speed=0K/sec

unused devices: <none>


/dev/md0:
         Version : 1.2
   Creation Time : Fri Feb 11 21:10:18 2011
      Raid Level : raid6
      Array Size : 2930271232 (2794.52 GiB 3000.60 GB)
   Used Dev Size : 1465135616 (1397.26 GiB 1500.30 GB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

     Update Time : Mon Aug 26 13:32:09 2013
           State : clean, degraded, recovering
  Active Devices : 3
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric-6
      Chunk Size : 512K

  Reshape Status : 53% complete
      New Layout : left-symmetric

            Name : backup:0  (local to host backup)
            UUID : 832a100a:2996471b:51867bfa:aaf5c38f
          Events : 1053146

     Number   Major   Minor   RaidDevice State
        3       8       49        0      active sync   /dev/sdd1
        1       8       17        1      active sync   /dev/sdb1
        2       8       33        2      active sync   /dev/sdc1
        4       8        1        3      spare rebuilding   /dev/sda1


What's the right thing to do now, is this recoverable? I have backups of 
course and since the RAID is still working I could just copy everything 
off and recreate it, but I'd rather fix this the "right way" than to set 
up a new system.

Thank you,
Iruwen

