From: Steve Kwee <skwee@itw.de>
Subject: raid1 boots with one disk only
Date: Fri, 4 Mar 2005 12:03:54 +0000 (UTC)
Message-ID: <loom.20050304T124945-980@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a problem with a simple raid1 2 disk ide sw raid.
When the system boots the raid always comes up in degraded mode with only one
disk running (see 1.). The disks are exactly the same piece of hardware and the
partitions are also identical (see 5.) I have another sw raid on the same
disks that is working fine without this behaviour.

After booting the system I do a 

  mdadm /dev/md1 --add /dev/hda2

to rebuild the array leaving the array in a clean state (see 2., 3.)
But when rebooting the system the raid starts with one disk only again.

mdadm -E results in an error message complaining about a missing superblock
(see 4.) is there a way to rebuild the superblock without destroying the
data ? I did not find a "rebuild superblock only" option in the mdadm manpage.
As all other diagnosis seems fine (see 2., 3.) I wonder if this message is
of any value at all.

Thanks anyone for any help on this.

Kernel version 2.6.8.1-3-386 
mdadm version: mdadm - v1.5.0 - 22 Jan 2004

--------------------------------
1. dmesg
--------------------------------
hda: max request size: 128KiB
hda: 120103200 sectors (61492 MB) w/1916KiB Cache, CHS=65535/16/63, UDMA(33)
 /dev/ide/host0/bus0/target0/lun0: p1 p2 p3
hdc: IBM-DTLA-307060, ATA DISK drive
ide1 at 0x170-0x177,0x376 on irq 15
hdc: max request size: 128KiB
hdc: 120103200 sectors (61492 MB) w/1916KiB Cache, CHS=65535/16/63, UDMA(100)
 /dev/ide/host0/bus1/target0/lun0: p1 p2 p3
md: md1 stopped.
md: bind<hdc2>
raid1: raid set md1 active with 1 out of 2 mirrors
VFS: Can't find ext3 filesystem on dev md1.
VFS: Can't find ext2 filesystem on dev md1.
ReiserFS: md1: found reiserfs format "3.6" with standard journal
ReiserFS: md1: using ordered data mode
ReiserFS: md1: journal params: device md1, size 8192, journal first block 18,
max trans len 1024, max
 batch 900, max commit age 30, max trans age 30
ReiserFS: md1: checking transaction log (md1)
ReiserFS: md1: Using r5 hash to sort names

--------------------------------
2. less /proc/mdstat
--------------------------------
Personalities : [raid1]
md0 : active raid1 hda1[0] hdc1[1]
      97664 blocks [2/2] [UU]

md1 : active raid1 hda2[0] hdc2[1]
      57617216 blocks [2/2] [UU]

unused devices: <none>

--------------------------------
3. mdadm --query --detail /dev/md1
--------------------------------
/dev/md1:
        Version : 00.90.01
  Creation Time : Wed Feb  9 16:46:20 2005
     Raid Level : raid1
     Array Size : 57617216 (54.95 GiB 59.00 GB)
    Device Size : 57617216 (54.95 GiB 59.00 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Mar  4 13:56:50 2005
          State : clean, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       3        2        0      active sync   /dev/hda2
       1      22        2        1      active sync   /dev/hdc2
           UUID : 278cfa5e:1492ad7d:7f2f3de7:c1d1ebbf
         Events : 0.430023

-----------------------------
4.  mdadm -E /dev/md1
-----------------------------
mdadm: No super block found on /dev/md1 (Expected magic a92b4efc, got f1800828)

-----------------------------
5. less /proc/partitions
-----------------------------
major minor  #blocks  name

   3     0   60051600 hda
   3     1      97744 hda1
   3     2   57617280 hda2
   3     3    2336544 hda3
  22     0   60051600 hdc
  22     1      97744 hdc1
  22     2   57617280 hdc2
  22     3    2336544 hdc3
   9     1   57617216 md1
   9     0      97664 md0
 253     0    2336544 dm-0
 253     1    2336544 dm-1
 253     2      97744 dm-2
 253     3   57617280 dm-3
 253     4      97744 dm-4
 253     5   57617280 dm-5



