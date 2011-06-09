From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: FW: Backup Server RAID Array Event Notification
Date: Thu, 9 Jun 2011 13:35:59 -0500
Message-ID: <9C.33.00666.09211FD4@cdptpa-omtalb.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	After I created a pair of two member RAID1 arrays and then added
them as members to a RAID6 array, I am now getting messages similar to the
following, complaining of "Wrong-level" issues.  When I check the RAID6
array, however, it is clean and both RAID1 members are still there.  When I
check both RAID1 arrays, they show clean with no events.  I am running a
compare between all the data on this machine and its mirror (this is a
backup machine).  So far everything looks good.  What does this imply?  Is
there something about which I should be worried?

-----Original Message-----
From: mdadm_monitor@satx.rr.com [mailto:mdadm_monitor@satx.rr.com] 
Sent: Thursday, June 09, 2011 8:04 AM
To: leslie.rhorer@twtelecom.com; lrhorer@satx.rr.com
Subject: Backup Server RAID Array Event Notification

DeviceDisappeared /dev/md10 Wrong-Level
<message ends>

From mdadm:
Backup:~# mdadm -D /dev/md0

/dev/md0:

        Version : 1.2

  Creation Time : Mon May 31 16:23:10 2010

     Raid Level : raid6

     Array Size : 14651371520 (13972.64 GiB 15003.00 GB)

  Used Dev Size : 1465137152 (1397.26 GiB 1500.30 GB)

   Raid Devices : 12
  Total Devices : 12
    Persistence : Superblock is persistent

    Update Time : Thu Jun  9 13:30:54 2011
          State : active
 Active Devices : 12
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 1024K

           Name : Backup:0  (local to host Backup)
           UUID : 431244d6:45d9635a:e88b3de5:92f30255
         Events : 436289

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd
       4       8       64        4      active sync   /dev/sde
       5       8       80        5      active sync   /dev/sdf
       6       8       96        6      active sync   /dev/sdg
       7       8      112        7      active sync   /dev/sdh
       8       8      128        8      active sync   /dev/sdi
      10       8      144        9      active sync   /dev/sdj
      12       9       11       10      active sync   /dev/md11
      11       9       10       11      active sync   /dev/md10
Backup:~# mdadm -D /dev/md10
/dev/md10:
        Version : 1.2
  Creation Time : Wed Jun  8 00:08:16 2011

     Raid Level : raid0

     Array Size : 1953521664 (1863.02 GiB 2000.41 GB)
   Raid Devices : 2

  Total Devices : 2
    Persistence : Superblock is persistent


    Update Time : Wed Jun  8 00:08:16 2011
          State : clean

 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 1024K

           Name : Backup:10  (local to host Backup)
           UUID : fa1ed617:d80525c4:1df692e8:0116406d
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8      192        0      active sync   /dev/sdm
       1       8      208        1      active sync   /dev/sdn
Backup:~# mdadm -D /dev/md11
/dev/md11:
        Version : 1.2
  Creation Time : Wed Jun  8 00:08:38 2011
     Raid Level : raid0
     Array Size : 1953521664 (1863.02 GiB 2000.41 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Wed Jun  8 00:08:38 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 1024K

           Name : Backup:11  (local to host Backup)
           UUID : 1ac704ee:8f501b33:4caee409:e384eeec
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8      224        0      active sync   /dev/sdo
       1       8      240        1      active sync   /dev/sdp


