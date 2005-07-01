From: Jacob Madsen <01771@iha.dk>
Subject: Inactive RAID5 and different states
Date: Fri, 1 Jul 2005 21:28:37 +0200
Message-ID: <200507012128.37408.01771@iha.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Xorg recently crashed and I was forced to reset the computer. After booting I 
discovered that partition 'sda10' was missing from an array. I checked the 
logs, since I suspected that 'sda' was faulty, but there was no messages 
about 'sda' at all. So I examined the md device and sda device.
Nothing seemed wrong as far as I could tell (its SATA, so I cant run a 
internal diagnostic on the harddrive, since my kernel doesnt support SMART 
for SATA), so I went on and added 'sda10' back to the array. But nothing 
happened and the array was still marked inactive.
I then stopped the array with 'mdadm -S /dev/md8' and got this in kernel log:
[kernel] md: md8 stopped.

I then executed 'mdadm --assemble --scan'.
This is the entries in /etc/mdadm.conf (two lines):
DEVICE /dev/sda10 /dev/sdb10 /dev/sdc10 /dev/sdd10
ARRAY /dev/md8 level=raid5 num-devices=4 
UUID=fc549abf:0e1662f3:3b60b5c3:7a8e6fc7 
devices=/dev/sda10,/dev/sdb10,/dev/sdc10,/dev/sdd10
And this is from the kernel log:
[kernel] md: bind<sda10>
[kernel] md: bind<sdc10>
[kernel] md: bind<sdd10>
[kernel] md: bind<sdb10>
[kernel] md: kicking non-fresh sda10 from array!
[kernel] md: unbind<sda10>

Since I have no idea what is suddently wrong with 'sda10' I went on and added 
it back to the array 'mdadm /dev/md8 -a /dev/sda10' output: 'mdadm: 
added /dev/sda10'
From kernel log:
[kernel] md: bind<sda10>


Nothing happened and the array is still marked inactive. So my question is, 
was is the difference between the states "stopped" and "inactive" (beside i 
can see the device in /proc/mdstat)? And what is state "non-fresh"?
And finally how can I possible fix this problem?


Thanks in advance!


Output before and after adding the partition back to the array:

Before adding 'sda10' back to the array:
--------------------------------------------------------------
cat /proc/mdstat
Personalities : [raid0] [raid1] [raid5]
md8 : inactive sdb10[1] sdd10[3] sdc10[2]
      409343808 blocks


mdadm --detail /dev/md8
/dev/md8:
        Version : 00.90.01
  Creation Time : Tue Oct 19 20:27:43 2004
     Raid Level : raid5
    Device Size : 136447936 (130.13 GiB 139.72 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 8
    Persistence : Superblock is persistent

    Update Time : Fri Jul  1 17:47:47 2005
          State : active, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : fc549abf:0e1662f3:3b60b5c3:7a8e6fc7
         Events : 0.13581980

    Number   Major   Minor   RaidDevice State
       0       0        0        -      removed
       1       8       26        1      active sync   /dev/sdb10
       2       8       42        2      active sync   /dev/sdc10
       3       8       58        3      active sync   /dev/sdd10


mdadm --examine /dev/sda10
/dev/sda10:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : fc549abf:0e1662f3:3b60b5c3:7a8e6fc7
  Creation Time : Tue Oct 19 20:27:43 2004
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 8

    Update Time : Fri Jul  1 17:47:37 2005
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f781bac2 - correct
         Events : 0.13581977

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       10        0      active sync   /dev/sda10

   0     0       8       10        0      active sync   /dev/sda10
   1     1       8       26        1      active sync   /dev/sdb10
   2     2       8       42        2      active sync   /dev/sdc10
   3     3       8       58        3      active sync   /dev/sdd10


After adding 'sda10' back to the array:
--------------------------------------------------------------
cat /proc/mdstat
Personalities : [raid0] [raid1] [raid5]
md8 : inactive sda10[0] sdb10[1] sdd10[3] sdc10[2]
      545791744 blocks


mdadm --detail /dev/md8
/dev/md8:
        Version : 00.90.01
  Creation Time : Tue Oct 19 20:27:43 2004
     Raid Level : raid5
    Device Size : 136447936 (130.13 GiB 139.72 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 8
    Persistence : Superblock is persistent

    Update Time : Fri Jul  1 17:47:47 2005
          State : active, degraded
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : fc549abf:0e1662f3:3b60b5c3:7a8e6fc7
         Events : 0.13581980

    Number   Major   Minor   RaidDevice State
       0       8       10        0      spare rebuilding   /dev/sda10
       1       8       26        1      active sync   /dev/sdb10
       2       8       42        2      active sync   /dev/sdc10
       3       8       58        3      active sync   /dev/sdd10


mdadm --examine /dev/sda10
/dev/sda10:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : fc549abf:0e1662f3:3b60b5c3:7a8e6fc7
  Creation Time : Tue Oct 19 20:27:43 2004
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 8

    Update Time : Fri Jul  1 17:47:37 2005
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f781bac2 - correct
         Events : 0.13581977

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       10        0      active sync   /dev/sda10

   0     0       8       10        0      active sync   /dev/sda10
   1     1       8       26        1      active sync   /dev/sdb10
   2     2       8       42        2      active sync   /dev/sdc10
   3     3       8       58        3      active sync   /dev/sdd10
