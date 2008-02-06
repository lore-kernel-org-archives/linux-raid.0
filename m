From: "Steve Fairbairn" <steve@fairbairn-family.com>
Subject: Disk failure during grow, what is the current state.
Date: Wed, 6 Feb 2008 12:58:55 -0000
Message-ID: <038301c868c0$07afcb30$0603a8c0@meanmachine>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi All,

I was wondering if someone might be willing to confirm what the current
state of my RAID array is, given the following sequence of events (sorry
it's pretty long)....

I had a clean, running /dev/md0 using 5 disks in RAID 5 (sda1, sdb1,
sdc1, sdd1, hdd1).  It had been clean like that for a while.  So last
night I decided it was safe to grow the array into a sixth disk....

[root@space ~]# mdadm /dev/md0 --add /dev/hdi1
mdadm: added /dev/hdi1
[root@space ~]# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Wed Jan  9 18:57:53 2008
     Raid Level : raid5
     Array Size : 1953535744 (1863.04 GiB 2000.42 GB)
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Feb  5 23:55:59 2008
          State : clean
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 382c157a:405e0640:c30f9e9e:888a5e63
         Events : 0.429616

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3      22       65        3      active sync   /dev/hdd1
       4       8       49        4      active sync   /dev/sdd1

       5      56        1        -      spare   /dev/hdi1
[root@space ~]# mdadm --grow /dev/md0 --raid-devices=6
mdadm: Need to backup 1280K of critical section..
mdadm: ... critical section passed.
[root@space ~]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 hdi1[5] sdd1[4] sdc1[2] sdb1[1] sda1[0] hdd1[3]
      1953535744 blocks super 0.91 level 5, 64k chunk, algorithm 2 [6/6]
[UUUUUU]
      [>....................]  reshape =  0.0% (29184/488383936)
finish=2787.4min speed=2918K/sec
      
unused devices: <none>
[root@space ~]# 

OK, so that would take nearly 2 days to complete, so I went to bed happy
about 10 hours ago.

I come to the machine this morning, and I have the following....

[root@space ~]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 hdi1[5] sdd1[6](F) sdc1[2] sdb1[1] sda1[0] hdd1[3]
      1953535744 blocks super 0.91 level 5, 64k chunk, algorithm 2 [6/5]
[UUUU_U]
      
unused devices: <none>
You have new mail in /var/spool/mail/root
[root@space ~]# mdadm -D /dev/md0
/dev/md0:
        Version : 00.91.03
  Creation Time : Wed Jan  9 18:57:53 2008
     Raid Level : raid5
     Array Size : 1953535744 (1863.04 GiB 2000.42 GB)
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Feb  6 05:28:09 2008
          State : clean, degraded
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

  Delta Devices : 1, (5->6)

           UUID : 382c157a:405e0640:c30f9e9e:888a5e63
         Events : 0.470964

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3      22       65        3      active sync   /dev/hdd1
       4       0        0        4      removed
       5      56        1        5      active sync   /dev/hdi1

       6       8       49        -      faulty spare
[root@space ~]# df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/VolGroup00-LogVol00
                      56086828  11219432  41972344  22% /
/dev/hda1               101086     18281     77586  20% /boot
/dev/md0             1922882096 1775670344  69070324  97% /Downloads
tmpfs                   513556         0    513556   0% /dev/shm
[root@space ~]# mdadm /dev/md0 --remove /dev/sdd1
mdadm: cannot find /dev/sdd1: No such file or directory [root@space ~]# 

As you can see, one of the original 5 devices has failed (sdd1) and
automatically removed.  The reshape has stopped, but the new disk seems
to be in and clean which is the bit I don't understand.  The new disk
hasn't been added to the size, so it would seem that md has switched it
to being used as a spare instead (possibly as the grow hadn't
completed?).

How come it seems to have recovered so nicely?
Is there something I can do to check it's integrity?
Was it just so much quicker than 2 days because it switched to only
having to sort out the 1 disk? Would it be safe to run an fsck to check
the integrity of the fs?  I don't want to inadvertently blat the raid
array by 'using' it when it's in a dodgy state.

I have unmounted the drive for the time being, so that it doesn't get
any writes until I know what state it is really in.

Any suggestions gratefully received,

Steve.

No virus found in this outgoing message.
Checked by AVG Free Edition. 
Version: 7.5.516 / Virus Database: 269.19.20/1261 - Release Date:
05/02/2008 20:57
 

