From: John McMonagle <johnm@advocap.org>
Subject: Raid 1 fails on every reboot?
Date: Sat, 30 Apr 2005 21:59:21 -0500
Message-ID: <42744609.10101@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I cloned a system with 2 drives and 2 raid 1 partitions.

I took a drive out of the old system.
Recreated the raids to get a new uuids.
Partitioned a new drive and added the partitions.
There were a couple other problems that I'm pretty sure was caused by a 
bad sata controller but think I have that under control.

So here is my problem.
Any time I reboot only the partitions on the first drive are active.
If I switch drives it's always the first one that is active.

Here is my mdadm.conf
DEVICE  /dev/sd*
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=647381d7:fb84da16:f43e8c51:3695f234
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=90b9e6d2:c78b1827:77f469ad:0f8997ed

This is all after reboot:
cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sda1[1]
      586240 blocks [2/1] [_U]

md1 : active raid1 sda2[1]
      194771968 blocks [2/1] [_U]

mdadm -E /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 647381d7:fb84da16:f43e8c51:3695f234
  Creation Time : Sat Apr 30 06:02:47 2005
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0

    Update Time : Sat Apr 30 21:47:22 2005
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b8e8e847 - correct
         Events : 0.4509


      Number   Major   Minor   RaidDevice State
this     1       8        1        1      active sync   /dev/sda1

   0     0       0        0        0      removed
   1     1       8        1        1      active sync   /dev/sda1

mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 647381d7:fb84da16:f43e8c51:3695f234
  Creation Time : Sat Apr 30 06:02:47 2005
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Sat Apr 30 21:26:07 2005
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b8e8e1d8 - correct
         Events : 0.4303


      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1

After adding /dev/sdb1 to md0:

cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdb1[0] sda1[1]
      586240 blocks [2/2] [UU]

md1 : active raid1 sda2[1]
      194771968 blocks [2/1] [_U]

unused devices: <none>
mdadm -E /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 647381d7:fb84da16:f43e8c51:3695f234
  Creation Time : Sat Apr 30 06:02:47 2005
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Sat Apr 30 21:51:11 2005
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b8e8e99a - correct
         Events : 0.4551


      Number   Major   Minor   RaidDevice State
this     1       8        1        1      active sync   /dev/sda1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 647381d7:fb84da16:f43e8c51:3695f234
  Creation Time : Sat Apr 30 06:02:47 2005
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Sat Apr 30 21:51:43 2005
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b8e8e9d0 - correct
         Events : 0.4555


      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1


Any Idea what is wrong?

John





