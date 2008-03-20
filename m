From: Pradeep <pradeepjp@yahoo.com>
Subject: mdadm -A erased the superblock ?
Date: Thu, 20 Mar 2008 13:26:07 -0700 (PDT)
Message-ID: <671934.68934.qm@web32802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
    It appears that a 'mdadm -A' command erased the superblocks on my disks.
Could you please take a look and let me know if I did something wrong ?

(I was adding 2 disks that were in a raid 1 set to a new machine running fedora 8.)
Briefly, I issued an 'mdadm --examine /dev/sdd1' command to check the disks in my raid 1
array.
(repeat similar command for /dev/sde1)

Then I issued 'mdadm -A -v -u '400f8c5f:045827ea:f72fe561:698ccea2' /dev/md0'
which errored out because it was looking at /dev/sdd instead of /dev/sdd1

Subsequent mdadm --examine commands show no superblock.

In detail below:

[root@brahma ~]# mdadm --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 400f8c5f:045827ea:f72fe561:698ccea2
  Creation Time : Wed Sep 26 06:15:31 2007
     Raid Level : raid1
  Used Dev Size : 117242240 (111.81 GiB 120.06 GB)
     Array Size : 117242240 (111.81 GiB 120.06 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Fri Feb 29 21:38:49 2008
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e40e8b91 - correct
         Events : 0.4


      Number   Major   Minor   RaidDevice State
this     0       8       33        0      active sync   /dev/sdc1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       49        1      active sync   /dev/sdd1



[root@brahma ~]# mdadm -A -v -u '400f8c5f:045827ea:f72fe561:698ccea2' /dev/md0
mdadm: looking for devices for /dev/md0
mdadm: cannot open device /dev/dm-2: Device or resource busy
mdadm: /dev/dm-2 has wrong uuid.
mdadm: no recogniseable superblock on /dev/dm-1
mdadm: /dev/dm-1 has wrong uuid.
mdadm: cannot open device /dev/dm-0: Device or resource busy
mdadm: /dev/dm-0 has wrong uuid.
mdadm: no RAID superblock on /dev/sde
mdadm: /dev/sde has wrong uuid.
mdadm: no RAID superblock on /dev/sdd
mdadm: /dev/sdd has wrong uuid.
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/sdc has wrong uuid.
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: /dev/sdb1 has wrong uuid.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: /dev/sdb has wrong uuid.
mdadm: cannot open device /dev/sda3: Device or resource busy
mdadm: /dev/sda3 has wrong uuid.
mdadm: cannot open device /dev/sda2: Device or resource busy
mdadm: /dev/sda2 has wrong uuid.
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has wrong uuid.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.
mdadm: 8:65 is identified as a member of /dev/md0, slot 1.
mdadm: 8:49 is identified as a member of /dev/md0, slot 0.
mdadm: failed to add 8:65 to /dev/md0: Invalid argument
mdadm: failed to add 8:49 to /dev/md0: Invalid argument
mdadm: /dev/md0 assembled from 0 drives - not enough to start the array.



[root@brahma ~]#  mdadm --examine /dev/sdd1
mdadm: No md superblock detected on /dev/sdd1.



This is with version mdadm - v2.6.2 - 21st May 2007 on fedora 8.
Please let me know if the information provided is not sufficient.
regards,
-pradeep.




      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs
