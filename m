From: Markus Krainz <ldm@gmx.at>
Subject: Building new RAID5 results in removed and failed devices
Date: Thu, 24 Jun 2010 22:26:33 +0200
Message-ID: <4C23BF79.2070009@gmx.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

1. I delete my old array md0
2. Then I create a new one as md1
3. The new md1 is not ok and shows removed, faulty and spare devices.
5. I tried this serveral times now, but i always get the same issue.

I am at my wits end and would very much appreciate your advice. Thank 
you in advance.

This is what I did:

/dev/ mdadm --stop md0
mdadm: stopped md0

/dev/ mdadm --remove md0

/dev/ mdadm --detail md0
mdadm: md device md0 does not appear to be active.

/dev/ mdadm --zero-superblock /dev/sdd1

/dev/ mdadm --zero-superblock /dev/sdc1
mdadm: Unrecognised md component device - /dev/sdc1

/dev/ mdadm --zero-superblock /dev/sdb1

/dev/ mdadm --create --verbose /dev/md1 --chunk=64 --level=5 
--raid-devices=2 /dev/sdd1 /dev/sdb1
mdadm: layout defaults to left-symmetric
mdadm: size set to 1953511936K
mdadm: array /dev/md1 started.

/dev/ mdadm --detail md1
md1:
         Version : 00.90
   Creation Time : Thu Jun 24 15:17:51 2010
      Raid Level : raid5
      Array Size : 1953511936 (1863.01 GiB 2000.40 GB)
   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Thu Jun 24 17:23:46 2010
           State : clean, degraded, recovering
  Active Devices : 1
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

  Rebuild Status : 36% complete

            UUID : d83aec6d:a71a2345:4cbed0ec:a797be60 (local to host 
d-serv)
          Events : 0.12

     Number   Major   Minor   RaidDevice State
        0       8       49        0      active sync   /dev/sdd1
        2       8       17        1      spare rebuilding   /dev/sdb1

/dev/ mdadm --detail md1
md1:
         Version : 00.90
   Creation Time : Thu Jun 24 15:17:51 2010
      Raid Level : raid5
      Array Size : 1953511936 (1863.01 GiB 2000.40 GB)
   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Thu Jun 24 18:04:28 2010
           State : clean, degraded
  Active Devices : 0
Working Devices : 1
  Failed Devices : 1
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        1       0        0        1      removed

        2       8       17        -      spare   /dev/sdb1
        3       8       49        -      faulty spare   /dev/sdd1
