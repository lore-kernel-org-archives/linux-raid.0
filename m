From: Piotr Klimek <piotr@klimek.net.pl>
Subject: RAID6 reshape integer problem
Date: Fri, 3 Jan 2014 09:30:16 +0000 (UTC)
Message-ID: <loom.20140103T101338-556@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I was trying to migrate from 5x3TB RAID5 to 6x3TB RAID6 with this command:

$ mdadm --grow /dev/md1 --level=6 --raid-devices=6 --
backup=/home/archiwum/r6.bak

After couple of days reshape stalled on 2147483648 block. I have found that 
this is a bug in mdadm. 2147483648 is max integer on 32 bit system. For now 
situation looks like this:

$ uname -a
Linux backuper 2.6.32-5-686-bigmem #1 SMP Mon Sep 23 23:38:27 UTC 2013 i686 
GNU/Linux

$ mdadm --version
mdadm - v3.1.4 - 31st August 2010

$ cat /proc/mdstat
md1 : active raid6 sdi1[6] sdj1[0] sdk1[5] sdc1[4] sdf1[3] sdh1[1]
      11721054208 blocks super 1.2 level 6, 512k chunk, algorithm 18 [6/5] 
[UUUUU_]
      [==============>......]  reshape = 73.2% (2147483648/2930263552) 
finish=18031577.4min speed=0K/sec

$ mdadm --detail /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Mon Nov 25 11:41:34 2013
     Raid Level : raid6
     Array Size : 11721054208 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 2930263552 (2794.52 GiB 3000.59 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Fri Jan  3 10:26:20 2014
          State : clean, degraded, recovering
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric-6
     Chunk Size : 512K

 Reshape Status : 73% complete
     New Layout : left-symmetric

           Name : backuper:1  (local to host backuper)
           UUID : 5fb40412:f3447bf7:f654d5f1:1bef1e1c
         Events : 4553396

    Number   Major   Minor   RaidDevice State
       0       8      145        0      active sync   /dev/sdj1
       1       8      113        1      active sync   /dev/sdh1
       3       8       81        2      active sync   /dev/sdf1
       4       8       33        3      active sync   /dev/sdc1
       5       8      161        4      active sync   /dev/sdk1
       6       8      129        5      spare rebuilding   /dev/sdi1

What should I do now? Its a production system, of course I have a backups 
but I would like to avoid recovering 8TB data from backups. My idea is to 
cancel reshape, and then do it again with bigger chunk, or upgrade 
mdadm/kernel. 
Thanks in advance for your help.


