From: Craig Haskins <reptile55@gmail.com>
Subject: Raid5 Reshape failed can't assemble array
Date: Sat, 23 Jan 2010 06:44:24 +0800
Message-ID: <4B5A2A48.3070208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I wonder if anyone can help me, one of my drives was kicked during 
reshape (growing from 5 to 6 devices) and after a reboot my array 
refused to start.  It's very similar to the case here 
http://marc.info/?t=125218236000001&r=1&w=2 .  I have followed the steps 
presented in that thread but so far my array refuses to assemble.

I'm running Ubutunu 9.10 which had mdadm v2.7, that segfaulted when 
trying to assemble so I got v3.1.1 but still the assemble isn't working:

 >root@aura:/home/craigh# mdadm -Af --verbose /dev/md0
mdadm: looking for devices for /dev/md0
mdadm: /dev/block/252:0 is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: cannot open device /dev/sdh1: Device or resource busy
mdadm: /dev/sdh1 has wrong uuid.
mdadm: /dev/sdh is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: cannot open device /dev/sdg1: Device or resource busy
mdadm: /dev/sdg1 has wrong uuid.
mdadm: /dev/sdg is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: cannot open device /dev/sdf1: Device or resource busy
mdadm: /dev/sdf1 has wrong uuid.
mdadm: /dev/sdf is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: cannot open device /dev/sde1: Device or resource busy
mdadm: /dev/sde1 has wrong uuid.
mdadm: /dev/sde is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: cannot open device /dev/sdd1: Device or resource busy
mdadm: /dev/sdd1 has wrong uuid.
mdadm: /dev/sdd is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: /dev/sdc1 is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: /dev/sdc is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: /dev/sdb5 is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: /dev/sdb2 is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: /dev/sdb1 is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: /dev/sdb is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: /dev/sda5 is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: /dev/sda2 is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: /dev/sda1 is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1
mdadm: /dev/sda is not one of 
/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1

Not sure why it says uuid is wrong as it is set correctly in the conf

# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md0 level=raid5 num-devices=5
    UUID=be282ff9:764d9beb:74ac4a35:dfcae213
    devices=/dev/sdf1,/dev/sde1,/dev/sdh1,/dev/sdg1,/dev/sdd1,dev/sdc1

# This file was auto-generated on Thu, 12 Nov 2009 01:12:06 +0800
# by mkconf $Id$

and here are details of my array
 >> mdadm -E /dev/sd[cdefgh]1

/dev/sdc1:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : be282ff9:764d9beb:74ac4a35:dfcae213
  Creation Time : Sun Mar 15 05:22:48 2009
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 4883799680 (4657.55 GiB 5001.01 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

  Reshape pos'n : 4156779840 (3964.21 GiB 4256.54 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Jan 18 00:00:51 2010
          State : clean
 Active Devices : 5
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 1
       Checksum : f0ffe91a - correct
         Events : 764121

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       33        6      spare   /dev/sdc1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       49        4      active sync   /dev/sdd1
   5     5       0        0        5      faulty removed
   6     6       8       33        6      spare   /dev/sdc1
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : be282ff9:764d9beb:74ac4a35:dfcae213
  Creation Time : Sun Mar 15 05:22:48 2009
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 4883799680 (4657.55 GiB 5001.01 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

  Reshape pos'n : 4157438400 (3964.84 GiB 4257.22 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Jan 18 00:01:10 2010
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : f1085969 - correct
         Events : 764126

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       49        4      active sync   /dev/sdd1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       49        4      active sync   /dev/sdd1
   5     5       0        0        5      faulty removed
/dev/sde1:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : be282ff9:764d9beb:74ac4a35:dfcae213
  Creation Time : Sun Mar 15 05:22:48 2009
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 4883799680 (4657.55 GiB 5001.01 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

  Reshape pos'n : 4157438400 (3964.84 GiB 4257.22 GB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Jan 18 00:01:10 2010
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : f1085973 - correct
         Events : 764126

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       65        1      active sync   /dev/sde1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       49        4      active sync   /dev/sdd1
   5     5       0        0        5      faulty removed

Any help or ideas appreciated.

Thanks

Craig
