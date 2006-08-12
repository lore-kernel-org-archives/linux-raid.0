From: Jacob Madsen <jacob@mungo.dk>
Subject: Re: Incative RAID5 (it should be active)
Date: Sat, 12 Aug 2006 23:37:03 +0200
Message-ID: <44DE49FF.2030008@mungo.dk>
References: <44DDED65.10500@mungo.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44DDED65.10500@mungo.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Jacob Madsen <jacob@mungo.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey again

here is some additional information:

# mdadm --examine /dev/sda10 /dev/sdb10 /dev/sdc10 /dev/sdd10
/dev/sda10:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : fc549abf:0e1662f3:3b60b5c3:7a8e6fc7
  Creation Time : Tue Oct 19 20:27:43 2004
     Raid Level : raid5
    Device Size : 136447936 (130.13 GiB 139.72 GB)
     Array Size : 409343808 (390.38 GiB 419.17 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 8

    Update Time : Sat Aug 12 06:13:55 2006
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1
       Checksum : fc3ffb29 - correct
         Events : 0.35808971

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       10        1      active sync   /dev/sda10

   0     0       0        0        0      removed
   1     1       8       10        1      active sync   /dev/sda10
   2     2       8       26        2      active sync   /dev/sdb10
   3     3       0        0        3      faulty removed
   4     4       8       58        4      spare   /dev/sdd10
/dev/sdb10:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : fc549abf:0e1662f3:3b60b5c3:7a8e6fc7
  Creation Time : Tue Oct 19 20:27:43 2004
     Raid Level : raid5
    Device Size : 136447936 (130.13 GiB 139.72 GB)
     Array Size : 409343808 (390.38 GiB 419.17 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 8

    Update Time : Sat Aug 12 06:13:55 2006
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1
       Checksum : fc3ffb3b - correct
         Events : 0.35808971

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       26        2      active sync   /dev/sdb10

   0     0       0        0        0      removed
   1     1       8       10        1      active sync   /dev/sda10
   2     2       8       26        2      active sync   /dev/sdb10
   3     3       0        0        3      faulty removed
   4     4       8       58        4      spare   /dev/sdd10
/dev/sdc10:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : fc549abf:0e1662f3:3b60b5c3:7a8e6fc7
  Creation Time : Tue Oct 19 20:27:43 2004
     Raid Level : raid5
    Device Size : 136447936 (130.13 GiB 139.72 GB)
     Array Size : 409343808 (390.38 GiB 419.17 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 8

    Update Time : Sat Aug 12 00:11:10 2006
          State : clean
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1
       Checksum : fc3fa60b - correct
         Events : 0.35808947

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       42        3      active sync   /dev/sdc10

   0     0       0        0        0      removed
   1     1       8       10        1      active sync   /dev/sda10
   2     2       8       26        2      active sync   /dev/sdb10
   3     3       8       42        3      active sync   /dev/sdc10
   4     4       8       58        4      spare   /dev/sdd10
/dev/sdd10:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : fc549abf:0e1662f3:3b60b5c3:7a8e6fc7
  Creation Time : Tue Oct 19 20:27:43 2004
     Raid Level : raid5
    Device Size : 136447936 (130.13 GiB 139.72 GB)
     Array Size : 409343808 (390.38 GiB 419.17 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 8

    Update Time : Sat Aug 12 06:13:55 2006
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1
       Checksum : fc3ffb59 - correct
         Events : 0.35808971

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       58        4      spare   /dev/sdd10

   0     0       0        0        0      removed
   1     1       8       10        1      active sync   /dev/sda10
   2     2       8       26        2      active sync   /dev/sdb10
   3     3       0        0        3      faulty removed
   4     4       8       58        4      spare   /dev/sdd10
