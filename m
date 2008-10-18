From: thomas62186218@aol.com
Subject: RAID 0 md device still active after pulled drive
Date: Fri, 17 Oct 2008 20:29:10 -0400
Message-ID: <8CAFECFAC51849A-1CD4-454@FWM-D03.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I have run into a most unusual behavior, where mdadm reports a RAID 0 
array that is missing a drive as "Active".

Environment:
Ubuntu 8.0.4 Hardy 64-bit
mdadm: 2.6.7
Dual socket quad-core CPU Intel server
8GB RAM
8 SATA II drives
LSI SAS1068 controller

Scenario:

1) I have a RAID 0 created from two drives:

md2 : active raid0 sde1[1] sdd1[0]
      488391680 blocks 128k chunks

mdadm -D /dev/md2
/dev/md2:
        Version : 00.90
  Creation Time : Fri Oct 17 14:24:44 2008
     Raid Level : raid0
     Array Size : 488391680 (465.77 GiB 500.11 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Fri Oct 17 14:24:44 2008
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync
       1       8       65        1      active sync

2) Then I monitor the md device.

mdadm --monitor -1 /dev/md2

3) Then I pull out a hard drive from the RAID 0 out of the system. At 
this point, I expect md device to become inactive.

DeviceDisappeared on /dev/md2 Wrong-Level

4) Oddly, no difference is reported in /proc/mdstat:

md2 : active raid0 sde1[1] sdd1[0]
      488391680 blocks 128k chunks


5) So I try to run IO, which fails (obviously).

mkfs /dev/md2
mke2fs 1.40.8 (13-Mar-2008)
Warning: could not erase sector 2: Attempt to write block from 
filesystem resulted in short write
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
30531584 inodes, 122097920 blocks
6104896 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
3727 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
         32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 
2654208,
         4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 
78675968,
        102400000

Warning: could not read block 0: Attempt to read block from filesystem 
resulted in short read
Warning: could not erase sector 0: Attempt to write block from 
filesystem resulted in short write
Writing inode tables: done
Writing superblocks and filesystem accounting information:
Warning, had trouble writing out superblocks.done

This filesystem will be automatically checked every 26 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.


Conclusion: Why does mdadm report a drive failure on RAID 0 but not 
make the md device as Inactive or otherwise failed?


Thanks!
-Thomas

