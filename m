From: <i.mikic@freenet.de>
Subject: failed raid5
Date: Sun, 20 Oct 2013 20:30:59 +0200
Message-ID: <06B0F993133B448E8F5CC115FB559300@DoenerMobil>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

the raid5 on my Iomega Storecenter ix4 is not starting up anymore.

as far as i can see, 2 of the Memberdisks were switched from active to 
spare.

configuration: 4x 1TB Harddrive, no changes done, error occured while 
running.

the funny thing is, there is an additional raid5 (1GB on each disk) that is 
still running.

waht are the chances the data on the drives is still intact, how can i get 
the
raid running again and how risky is the process (is it neccesary to get 
additional drives for cloning)?

here the mdadm --examine ouput

/dev/sda2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 835af38b:cb4edece:860bf3ca:97c28e09
  Creation Time : Fri Jul 24 08:04:50 2009
     Raid Level : raid5
  Used Dev Size : 975742336 (930.54 GiB 999.16 GB)
     Array Size : 2927227008 (2791.62 GiB 2997.48 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Fri Oct 18 07:51:35 2013
          State : clean
Active Devices : 2
Working Devices : 4
Failed Devices : 2
  Spare Devices : 2
       Checksum : ecc62357 - correct
         Events : 0.1531645

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8       34        4      spare   /dev/sdc2
   5     5       8       50        5      spare   /dev/sdd2
/dev/sdb2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 835af38b:cb4edece:860bf3ca:97c28e09
  Creation Time : Fri Jul 24 08:04:50 2009
     Raid Level : raid5
  Used Dev Size : 975742336 (930.54 GiB 999.16 GB)
     Array Size : 2927227008 (2791.62 GiB 2997.48 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Fri Oct 18 07:51:35 2013
          State : clean
Active Devices : 2
Working Devices : 4
Failed Devices : 2
  Spare Devices : 2
       Checksum : ecc62369 - correct
         Events : 0.1531645

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       18        1      active sync   /dev/sdb2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8       34        4      spare   /dev/sdc2
   5     5       8       50        5      spare   /dev/sdd2
/dev/sdc2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 835af38b:cb4edece:860bf3ca:97c28e09
  Creation Time : Fri Jul 24 08:04:50 2009
     Raid Level : raid5
  Used Dev Size : 975742336 (930.54 GiB 999.16 GB)
     Array Size : 2927227008 (2791.62 GiB 2997.48 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Fri Oct 18 07:51:35 2013
          State : clean
Active Devices : 2
Working Devices : 4
Failed Devices : 2
  Spare Devices : 2
       Checksum : ecc62379 - correct
         Events : 0.1531645

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       34        4      spare   /dev/sdc2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8       34        4      spare   /dev/sdc2
   5     5       8       50        5      spare   /dev/sdd2
/dev/sdd2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 835af38b:cb4edece:860bf3ca:97c28e09
  Creation Time : Fri Jul 24 08:04:50 2009
     Raid Level : raid5
  Used Dev Size : 975742336 (930.54 GiB 999.16 GB)
     Array Size : 2927227008 (2791.62 GiB 2997.48 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Fri Oct 18 07:51:35 2013
          State : clean
Active Devices : 2
Working Devices : 4
Failed Devices : 2
  Spare Devices : 2
       Checksum : ecc6238b - correct
         Events : 0.1531645

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       50        5      spare   /dev/sdd2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8       34        4      spare   /dev/sdc2
   5     5       8       50        5      spare   /dev/sdd2 

