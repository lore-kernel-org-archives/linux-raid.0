From: Christian Feddern <rangerone@web.de>
Subject: Raid5 trouble after Upgrade. How to change this magic number in superblock
Date: Wed, 09 Apr 2003 12:18:45 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E93F385.6090603@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello there,

I got a problem with my raid5.
After I updated my linux distribution the following happend:
While booting the autoraid process yells at me:

md: invalid raid superblock magic on md0
md: md0 has invalid sb, not importing
md: no nested devices found
md: autorun done
raid5: switching cache buffer size, 4096 --> 1024


cat /proc/mdstat looks completly ok

lsraid tells me that md0 doesnt have a valid superblock

mdadm --examine tells me that the magic number it reads from superblock 
/dev/md0 is not what was expected.

Strangely: The expected magic number is on the superblock of all four 
raid partitions!!!.

They all look like this:

/dev/hde1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 05527cce:757e81d8:7476d03f:5bfaaa2b
   Creation Time : Fri Jun 28 15:32:11 2002
      Raid Level : raid5
     Device Size : 97685632 (93.16 GiB 100.03 GB)
    Raid Devices : 3
   Total Devices : 4
Preferred Minor : 0

     Update Time : Wed Apr  9 12:01:29 2003
           State : dirty, no-errors
  Active Devices : 3
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 1
        Checksum : 75f13011 - correct
          Events : 0.147

          Layout : left-symmetric
      Chunk Size : 32K

       Number   Major   Minor   RaidDevice State
this     0      33        1        0      active sync   /dev/hde1
    0     0      33        1        0      active sync   /dev/hde1
    1     1      33       65        1      active sync   /dev/hdf1
    2     2      34        1        2      active sync   /dev/hdg1
    3     3      34       65        3        /dev/hdh1

All deviced show this info. But the md0 superblock seems to have a wrong 
magic number.

I can mount /dev/md0 just fine and also read or modify data. This error 
message is just making me nervous.

Can i change the superblock to the valid values again somehow? If yes 
how :)?

Any1 got an idea ?

Thx

Christian


P.S

Here my raidtab file

raiddev /dev/md0
    raid-level       5
    nr-raid-disks    3
    nr-spare-disks   1
    persistent-superblock 1
    parity-algorithm left-symmetric
    chunk-size       32
    device   /dev/hde1
    raid-disk 0
    device   /dev/hdf1
    raid-disk 1
    device   /dev/hdg1
    raid-disk 2
    device   /dev/hdh1
    spare-disk 0

