From: James Bromberger <james@rcpt.to>
Subject: Failed RAID1: lsof or raid code: who's lying? :)
Date: Sat, 27 Dec 2003 18:31:50 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031227103150.GA15726@phobe.internal.pelicanmanufacturing.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Hello all,

I have a raid1 based system, consisting of two IDE disks with 
multiple partitions. One disk failed, and was replaced, but the 
partitioning was slightly out. The system came up, but with the arrays
degraded (see below for output). I want to now correct the array, and 
set the partition table of the new disk to the same as the old, so that 
I can once more raidhotadd the new disks's partitions to the running md0. 
And I'd like to do this without a reboot, since the system is in 
Australia, and I am in London (so a trip to the machine room is 
a little expensive and time consuming).

However, different tools suggest different disks really are in use.

Disk setup:two disks, hda and hdc, should be identically partitioned.
Kernel: Debian 2.4.18-5.
Raidtools: 1.00.3-5
lsof: 4.64-1

At boot:
========

...
md: autorun ...
md: considering ide/host0/bus1/target0/lun0/part1 ...
md:  adding ide/host0/bus1/target0/lun0/part1 ...
md: created md0
md: bind<ide/host0/bus1/target0/lun0/part1,1>
md: running: <ide/host0/bus1/target0/lun0/part1>
md: ide/host0/bus1/target0/lun0/part1's event counter: 000000a8
md: RAID level 1 does not need chunksize! Continuing anyway.
md0: max total readahead window set to 124k
md0: 1 data-disks, max readahead per data-disk: 124k
raid1: device ide/host0/bus1/target0/lun0/part1 operational as mirror 0
raid1: md0, not all disks are operational -- trying to recover array
raid1: raid set md0 active with 1 out of 2 mirrors
...

When booted:
============

phobe:/dev# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md5 : active raid1 ide/host0/bus1/target0/lun0/part7[1]
      62037760 blocks [2/1] [_U]
       
md4 : active raid1 ide/host0/bus1/target0/lun0/part6[1]
      97664 blocks [2/1] [_U]
       
md3 : active raid1 ide/host0/bus1/target0/lun0/part5[1]
      4003648 blocks [2/1] [_U]
       
md2 : active raid1 ide/host0/bus1/target0/lun0/part3[1]
      4003712 blocks [2/1] [_U]
       
md1 : active raid1 ide/host0/bus1/target0/lun0/part2[1]
      4003712 blocks [2/1] [_U]
       
md0 : active raid1 ide/host0/bus1/target0/lun0/part1[0]
      4003648 blocks [2/1] [U_]
       
unused devices: <none>
phobe:/dev# lsof /dev/ide/host0/bus1/target0/lun0/part1|head -3
phobe:/dev# lsof /dev/ide/host0/bus0/target0/lun0/part1|head -3
COMMAND     PID     USER   FD   TYPE DEVICE    SIZE  NODE NAME
init          1     root  cwd    DIR    3,1     704     2 /
init          1     root  rtd    DIR    3,1     704     2 /
phobe:/dev# lsof /dev/md/0|head
phobe:/dev# lsof /dev/md0|head
phobe:/dev# mount
/dev/md/0 on / type reiserfs (rw)
proc on /proc type proc (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/md/1 on /usr type reiserfs (rw)
/dev/md/2 on /var type reiserfs (rw)
/dev/md/3 on /home type reiserfs (rw)
/dev/md/5 on /usr/local type reiserfs (rw)



# mdadm --examine /dev/hdc1
/dev/hdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ae51c0d6:91fda153:56d0be02:466815f0
  Creation Time : Sat Sep  1 12:10:16 2001
     Raid Level : raid1
    Device Size : 4003648 (3.82 GiB 4.10 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
                                                                                
    Update Time : Tue Dec 16 11:48:09 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 25f8e38 - correct
         Events : 0.169
                                                                                
                                                                                
      Number   Major   Minor   RaidDevice State
this     0      22        1        0      active sync
/dev/ide/host0/bus1/target0/lun0/part1
   0     0      22        1        0      active sync
/dev/ide/host0/bus1/target0/lun0/part1
   1     1       0        0        1      faulty removed
# mdadm --examine /dev/hda1
mdadm: No super block found on /dev/hda1 (Expected magic a92b4efc, got
00000000)



So, at boot, hdcX was added to the array, and this is the same as what 
mount is showing and what mdstat is showing. Fine. So what I think I need to 
do is set the partitions on the hda disk to be the same as hdc, and 
raidhotadd these. However, lsof indicates that hda has the mounted 
partitions, not hda as I would have expected.

Can anyone tell me what's going on here? Should lsof not be trusted?

Many thanks,
  James
(PS: I am off list, please CC me)
(PPS: any more data required, please ask)
-- 
 James Bromberger <james_AT_rcpt.to> www.james.rcpt.to
 Remainder moved to http://www.james.rcpt.to/james/sig.html

I am in London on UK mobile +44 7952 042920.
