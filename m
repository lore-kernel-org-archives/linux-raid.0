From: Marcin Krol <admin@domeny.pl>
Subject: Re: Deleting mdadm RAID arrays
Date: Wed, 6 Feb 2008 13:03:49 +0100
Message-ID: <200802061303.50017.admin@domeny.pl>
References: <200802051142.19625.admin@domeny.pl> <200802061055.03979.admin@domeny.pl> <18345.36672.51070.986289@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18345.36672.51070.986289@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wednesday 06 February 2008 11:43:12:
> On Wednesday February 6, admin@domeny.pl wrote:
> > 
> > > Maybe the kernel has  been told to forget about the partitions of
> > > /dev/sdb.
> > 
> > But fdisk/cfdisk has no problem whatsoever finding the partitions .
> 
> It is looking at the partition table on disk.  Not at the kernel's
> idea of partitions, which is initialised from that table...

Aha! Thanks for this bit. I get it now.

> What does
> 
>   cat /proc/partitions
> 
> say?

Note: I have reconfigured udev now to associate device names with serial
numbers (below)

% cat /proc/partitions
major minor  #blocks  name

   8     0  390711384 sda
   8     1  390708801 sda1
   8    16  390711384 sdb
   8    17  390708801 sdb1
   8    32  390711384 sdc
   8    33  390708801 sdc1
   8    48  390710327 sdd
   8    49  390708801 sdd1
   8    64  390711384 sde
   8    65  390708801 sde1
   8    80  390711384 sdf
   8    81  390708801 sdf1
   3    64   78150744 hdb
   3    65    1951866 hdb1
   3    66    7815622 hdb2
   3    67    4883760 hdb3
   3    68          1 hdb4
   3    69     979933 hdb5
   3    70     979933 hdb6
   3    71   61536951 hdb7
   9     1  781417472 md1
   9     0  781417472 md0



/dev/disk/by-id % ls -l

total 0
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 ata-ST380023A_3KB0MV22 -> ../../hdb
lrwxrwxrwx 1 root root 10 2008-02-06 13:34 ata-ST380023A_3KB0MV22-part1 -> ../../hdb1
lrwxrwxrwx 1 root root 10 2008-02-06 13:34 ata-ST380023A_3KB0MV22-part2 -> ../../hdb2
lrwxrwxrwx 1 root root 10 2008-02-06 13:34 ata-ST380023A_3KB0MV22-part3 -> ../../hdb3
lrwxrwxrwx 1 root root 10 2008-02-06 13:34 ata-ST380023A_3KB0MV22-part4 -> ../../hdb4
lrwxrwxrwx 1 root root 10 2008-02-06 13:34 ata-ST380023A_3KB0MV22-part5 -> ../../hdb5
lrwxrwxrwx 1 root root 10 2008-02-06 13:34 ata-ST380023A_3KB0MV22-part6 -> ../../hdb6
lrwxrwxrwx 1 root root 10 2008-02-06 13:34 ata-ST380023A_3KB0MV22-part7 -> ../../hdb7
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 ata-WDC_WD4000KD-00N-WD-WMAMY1696130 -> ../../d_6
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 ata-WDC_WD4000KD-00N-WD-WMAMY1696130-part1 -> ../../d_6
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 ata-WDC_WD4000KD-00N-WD-WMAMY1707974 -> ../../d_5
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 ata-WDC_WD4000KD-00N-WD-WMAMY1707974-part1 -> ../../d_5
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 ata-WDC_WD4000KD-00N-WD-WMAMY1795228 -> ../../d_1
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 ata-WDC_WD4000KD-00N-WD-WMAMY1795228-part1 -> ../../d_1
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 ata-WDC_WD4000KD-00N-WD-WMAMY1795364 -> ../../d_3
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 ata-WDC_WD4000KD-00N-WD-WMAMY1795364-part1 -> ../../d_3
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 ata-WDC_WD4000KD-00N-WD-WMAMY1798692 -> ../../d_2
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 ata-WDC_WD4000KD-00N-WD-WMAMY1798692-part1 -> ../../d_2
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 ata-WDC_WD4000KD-00N-WD-WMAMY1800255 -> ../../d_4
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 ata-WDC_WD4000KD-00N-WD-WMAMY1800255-part1 -> ../../d_4
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 scsi-S_WD-WMAMY1696130 -> ../../d_6
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 scsi-S_WD-WMAMY1696130-part1 -> ../../d_6
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 scsi-S_WD-WMAMY1707974 -> ../../d_5
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 scsi-S_WD-WMAMY1707974-part1 -> ../../d_5
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 scsi-S_WD-WMAMY1795228 -> ../../d_1
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 scsi-S_WD-WMAMY1795228-part1 -> ../../d_1
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 scsi-S_WD-WMAMY1795364 -> ../../d_3
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 scsi-S_WD-WMAMY1795364-part1 -> ../../d_3
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 scsi-S_WD-WMAMY1798692 -> ../../d_2
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 scsi-S_WD-WMAMY1798692-part1 -> ../../d_2
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 scsi-S_WD-WMAMY1800255 -> ../../d_4
lrwxrwxrwx 1 root root  9 2008-02-06 13:34 scsi-S_WD-WMAMY1800255-part1 -> ../../d_4

I have no idea why udev can't allocate /dev/d_1p1 to partition 1 on disk d_1. I have
explicitly asked it to do that:

/etc/udev/rules.d % cat z24_disks_domeny.rules


KERNEL=="sd*", SUBSYSTEM=="block", ENV{ID_SERIAL_SHORT}=="WD-WMAMY1795228", NAME="d_1"
KERNEL=="sd*", SUBSYSTEM=="block", ENV{ID_SERIAL_SHORT}=="WD-WMAMY1795228-part1", NAME="d_1p1"

KERNEL=="sd*", SUBSYSTEM=="block", ENV{ID_SERIAL_SHORT}=="WD-WMAMY1798692", NAME="d_2"
KERNEL=="sd*", SUBSYSTEM=="block", ENV{ID_SERIAL_SHORT}=="WD-WMAMY1798692-part1", NAME="d_2p1"

KERNEL=="sd*", SUBSYSTEM=="block", ENV{ID_SERIAL_SHORT}=="WD-WMAMY1795364", NAME="d_3"
KERNEL=="sd*", SUBSYSTEM=="block", ENV{ID_SERIAL_SHORT}=="WD-WMAMY1795364-part1", NAME="d_3p1"

KERNEL=="sd*", SUBSYSTEM=="block", ENV{ID_SERIAL_SHORT}=="WD-WMAMY1800255", NAME="d_4"
KERNEL=="sd*", SUBSYSTEM=="block", ENV{ID_SERIAL_SHORT}=="WD-WMAMY1800255-part1", NAME="d_4p1"

KERNEL=="sd*", SUBSYSTEM=="block", ENV{ID_SERIAL_SHORT}=="WD-WMAMY1707974", NAME="d_5"
KERNEL=="sd*", SUBSYSTEM=="block", ENV{ID_SERIAL_SHORT}=="WD-WMAMY1707974-part1", NAME="d_5p1"

KERNEL=="sd*", SUBSYSTEM=="block", ENV{ID_SERIAL_SHORT}=="WD-WMAMY1696130", NAME="d_6"
KERNEL=="sd*", SUBSYSTEM=="block", ENV{ID_SERIAL_SHORT}=="WD-WMAMY1696130-part1", NAME="d_6p1"


/etc/udev/rules.d % cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active(auto-read-only) raid5 sdc1[0] sde1[3](S) sdd1[1]
      781417472 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]

md1 : active(auto-read-only) raid5 sdf1[0] sdb1[3](S) sda1[1]
      781417472 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]

md0 consists of sdc1, sde1 and sdd1 even though when creating I asked it to 
use d_1, d_2 and d_3 (this is probably written on the particular disk/partition itself,
but I have no idea how to clean this up - mdadm --zero-superblock /dev/d_1
again produces "mdadm: Couldn't open /dev/d_1 for write - not zeroing")


/etc/mdadm % mdadm -Q --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Wed Feb  6 12:24:49 2008
     Raid Level : raid5
     Array Size : 781417472 (745.22 GiB 800.17 GB)
  Used Dev Size : 390708736 (372.61 GiB 400.09 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Feb  6 12:34:00 2008
          State : clean, degraded
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : f83e3541:b5b63f10:a6d4720f:52a5051f
         Events : 0.14

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/d_1
       1       8       49        1      active sync   /dev/d_2
       2       0        0        2      removed

       3       8       65        -      spare   /dev/d_3




-- 
Marcin Krol

