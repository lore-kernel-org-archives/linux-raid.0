From: Mauricio <raub@afn.org>
Subject: raid is read-only? (debian/sarge)
Date: Fri, 26 Mar 2004 07:11:32 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <a06002005bc89ce38bb27@[10.0.0.10]>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

	I have 2 120GB IDE drives in the second IDE controller of a 
P4 debian/sarge box that I would like to set up as a raid1 array. 
Using info from the following links,

http://www.linuxdevcenter.com/pub/a/linux/2002/12/05/RAID.html
http://en.tldp.org/HOWTO/Software-RAID-HOWTO-5.html

I do

<Note:  I partitioned /dev/hd{c,d} using fdisk, but it seems that was 
not needed>

laurel:/home/debian# mdadm -Cv /dev/md0 -l1 -n2 /dev/hd{c,d}1
mdadm: /dev/hdd1 appears to contain a reiserfs file system
     size = 117210208K
mdadm: size set to 117210112K
Continue creating array? y
mdadm: array /dev/md0 started.
laurel:/home/debian#urel:/home/debian# mdadm --detail --scan
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=a9ad3f4b:ec821a50:da01bd3e:1817087d
    devices=/dev/hdc1,/dev/hdd1
laurel:/home/debian#
laurel:/home/debian# mdadm -E /dev/hdc1
/dev/hdc1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : a9ad3f4b:ec821a50:da01bd3e:1817087d
   Creation Time : Fri Mar 26 05:01:20 2004
      Raid Level : raid1
     Device Size : 117210112 (111.78 GiB 120.02 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0

     Update Time : Fri Mar 26 05:01:20 2004
           State : dirty, no-errors
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : b937ea96 - correct
          Events : 0.1


       Number   Major   Minor   RaidDevice State
this     0      22        1        0      active sync   /dev/hdc1
    0     0      22        1        0      active sync   /dev/hdc1
    1     1      22       65        1      active sync   /dev/hdd1
laurel:/home/debian#

# fdisk /dev/md0
[...]
Disk /dev/md0: 120.0 GB, 120023154688 bytes
2 heads, 4 sectors/track, 29302528 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

     Device Boot      Start         End      Blocks   Id  System
/dev/md0p1               1    29302528   117210110   83  Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.

WARNING: Re-reading the partition table failed with error 22: Invalid argument.
The kernel still uses the old table.
The new table will be used at the next reboot.
Syncing disks.
laurel:/home/debian#
<after rebooting...>
laurel:/# mount -o rw /dev/md0 /mnt
laurel:/# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/hda1              18G  3.5G   14G  21% /
tmpfs                 252M     0  252M   0% /dev/shm
/dev/md0              112G  177M  112G   1% /mnt
laurel:/#

But, when I try to write something to /mnt, I am told it is a 
read-only filesystem:

laurel:/# cd /mnt
laurel:/mnt# touch m
touch: cannot touch `m': Read-only file system
laurel:/mnt#

What am I missing here?
