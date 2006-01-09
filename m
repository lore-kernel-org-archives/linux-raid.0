From: "aziro.linux.adm" <aziro.linux.adm@gmail.com>
Subject: RAID5 with 8th SCSI with mdadm -- Is possible one 9th Spare Disk
 after?
Date: Mon, 09 Jan 2006 14:37:38 +0200
Message-ID: <43C25912.50606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

   Hi, Folk
I've bad experience with a two SCSI Seagate 73,4 10K.6 Ultra320 disks
failed one by one in my software RAID5 from 8th SCSI Disks -- Hot Swapable.
 From /var/log/messages i see /dev/sdb1 failed first, and after
/dev/sda1 failed second. RAID5 stop your functionality.
Then i reboot my Fedora Core 3 Linux

#uname -a
Linux server 2.6.9-1.667smp #1 SMP Tue Nov 2 14:59:52 EST 2004 i686 i686
i386 GNU/Linux

and in rescue mode begin with recover procedure.

#mdadm -V
mdadm - v1.6.0 - 4 June 2004

I success made mdadm -A /dev/md0 -f /dev/sd[acdefgh]1, and after
assemble my RAID5 i add failed first /dev/sdb1, mdadm /dev/md0 -a /dev/sdb1.
When, with mdadm create my RAID5 i use all 8 SCSI Disks, but not define
"--spare-devices=1" by --create options.
Is possible to add one more nine SCSI Seagate 73,4 10K.6 Ultra320 disk
like spare one.

And if one from 8th SCSI Disks failed the mdadm will automatic use this
spare for reconstruction.

How can do this if possible with mdadm or if add in /etc/mdadm.conf
something like follows: changes in [2]: spares=1    /dev/sdj1
[1]original /etc/mdadm.conf
# mdadm.conf written out by anaconda
DEVICE /dev/sd[abcdefgh]1
MAILADDR admin@domain.com
ARRAY /dev/md0 super-minor=0
ARRAY /dev/md0 level=raid5 num-devices=8
UUID=656519ce:b6b59cb5:d5a5aaf2:25a61506

devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1,/dev/sdf1,/dev/sdg1,/dev/sdh1
============================================================================
[2]after possible modification /etc/mdadm.conf
# mdadm.conf written out by anaconda
DEVICE /dev/sd[abcdefgh]1
MAILADDR admin@domain.com
ARRAY /dev/md0 super-minor=0
ARRAY /dev/md0 level=raid5 num-devices=9 spare=1
UUID=656519ce:b6b59cb5:d5a5aaf2:25a61506

devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1,/dev/sdf1,/dev/sdg1,/dev/sdh1,/dev/sdj1
============================================================================
Current mdadm -D /dev/md0 is follows:
/dev/md0:
        Version : 00.90.01
  Creation Time : Wed Aug  3 14:37:00 2005
     Raid Level : raid5
     Array Size : 501773440 (478.53 GiB 513.82 GB)
    Device Size : 71681920 (68.36 GiB 73.40 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Jan  6 17:37:48 2006
          State : clean
Active Devices : 8
Working Devices : 8
Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1
       7       8      113        7      active sync   /dev/sdh1
           UUID : 656519ce:b6b59cb5:d5a5aaf2:25a61506
         Events : 0.2120052


Thanks for all answares!
***********************
*  Happy New 2k6 Year !   *
***********************


