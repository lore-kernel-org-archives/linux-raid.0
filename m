From: "Hans Otto Lunde" <ho@egmont-hs.dk>
Subject: Software raid5 problem on 2.4.24 update from 2.4.18
Date: Fri, 20 Feb 2004 13:58:50 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040220125850.1175.qmail@egmont-hs.dk>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a Redhat server (7.2) with a custom-compiled kernel (2.4.18)
with all necessary modules compiled in running raid5 on /home (etx3)
with 3 20 Gb IBM ide-disks. It's been running fine for years. 

Problem: I would like to upgrade to the newest kernel for security
reasons, but I get the following error when tring to boot kernel 2.4.24
 -------------------------------------------------------------------------
" The superblock could not be read or does not describe a correct ext2
filesystem. If the device is valid and it really contains an ext2
filesystem then the superblock is corrupt and you might try running
e2fsck with an alternate superblock 

e2fsck -b 8193 <device> 

fsck.ext3: invalid argument while trying to open /dev/md0"
 -------------------------------------------------------------------------- 


But the superblock is ok.
Have something changed in recent kernels?
Should I create a new raid with 2.4.24 and put data back from backup or 
what? 

Forgive me if I'm being plain stupid. 

Hans Otto Lunde
Denmark 

Here are some listings done when running 2.4.18 with active /dev/md0. 

[root@ns root]# cat /etc/raidtab
raiddev             /dev/md0
raid-level                  5
nr-raid-disks               3
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
   device          /dev/hdc1
   raid-disk     0
   device          /dev/hde1
   raid-disk     1
   device          /dev/hdg1
   raid-disk     2 

 ------------------------------------------------------------- 

mdadm --misc -E /dev/hdc
/dev/hdc:
         Magic : a92b4efc
       Version : 00.90.00
          UUID : 29f52295:6e5e40bc:f513abc1:c01af7c8
 Creation Time : Mon Oct 30 03:29:09 2000
    Raid Level : raid5
   Device Size : 20066176 (19.13 GiB 20.54 GB)
  Raid Devices : 3
 Total Devices : 3
Preferred Minor : 0 

   Update Time : Wed Mar 13 16:45:20 2002
         State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
 Spare Devices : 0
      Checksum : 6e6dd84b - correct
        Events : 0.147 

        Layout : left-symmetric
    Chunk Size : 128K 

     Number   Major   Minor   RaidDevice State
this     0      22        0        0      active sync   /dev/hdc
  0     0      22        0        0      active sync   /dev/hdc
  1     1      33        0        1      active sync   /dev/hde
  2     2      34        0        2      active sync   /dev/hdg 

 ------------------------------------------------------------- 

mdadm --misc -E /dev/hde
/dev/hde:
         Magic : a92b4efc
       Version : 00.90.00
          UUID : 29f52295:6e5e40bc:f513abc1:c01af7c8
 Creation Time : Mon Oct 30 03:29:09 2000
    Raid Level : raid5
   Device Size : 20066176 (19.13 GiB 20.54 GB)
  Raid Devices : 3
 Total Devices : 2
Preferred Minor : 0 

   Update Time : Fri Mar 22 13:41:30 2002
         State : dirty, no-errors
Active Devices : 1
Working Devices : 1
Failed Devices : 1
 Spare Devices : 0
      Checksum : 6e798a81 - correct
        Events : 0.206 

        Layout : left-symmetric
    Chunk Size : 128K 

     Number   Major   Minor   RaidDevice State
this     1      33        0        1      active sync   /dev/hde
  0     0       0        0        0      faulty removed
  1     1      33        0        1      active sync   /dev/hde
  2     2      34        0        2      faulty   /dev/hdg 

 ------------------------------------------------------------- 

mdadm --misc -E /dev/hdg
/dev/hdg:
         Magic : a92b4efc
       Version : 00.90.00
          UUID : 29f52295:6e5e40bc:f513abc1:c01af7c8
 Creation Time : Mon Oct 30 03:29:09 2000
    Raid Level : raid5
   Device Size : 20066176 (19.13 GiB 20.54 GB)
  Raid Devices : 3
 Total Devices : 2
Preferred Minor : 0 

   Update Time : Fri Mar 22 12:37:16 2002
         State : dirty, no-errors
Active Devices : 2
Working Devices : 2
Failed Devices : 0
 Spare Devices : 0
      Checksum : 6e797b7b - correct
        Events : 0.205 

        Layout : left-symmetric
    Chunk Size : 128K 

     Number   Major   Minor   RaidDevice State
this     2      34        0        2      active sync   /dev/hdg
  0     0       0        0        0      faulty removed
  1     1      33        0        1      active sync   /dev/hde
  2     2      34        0        2      active sync   /dev/hdg 

 ------------------------------------------------------------- 

mdadm --misc -D /dev/md0
/dev/md0:
       Version : 00.90.00
 Creation Time : Fri Mar 29 23:11:20 2002
    Raid Level : raid5
    Array Size : 40131200 (38.27 GiB 41.09 GB)
   Device Size : 20065600 (19.13 GiB 20.54 GB)
  Raid Devices : 3
 Total Devices : 3
Preferred Minor : 0
   Persistence : Superblock is persistent 

   Update Time : Thu Feb  5 00:10:11 2004
         State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
 Spare Devices : 0 

        Layout : left-asymmetric
    Chunk Size : 64K 

   Number   Major   Minor   RaidDevice State
      0      22        1        0      active sync   /dev/hdc1
      1      33        1        1      active sync   /dev/hde1
      2      34        1        2      active sync   /dev/hdg1
          UUID : c7330fe7:a2728c71:411b051f:e93f4d07 

