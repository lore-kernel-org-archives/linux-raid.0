From: "Paramasivam, Meenakshisundaram" <mparamas@iupui.edu>
Subject: mdadm RAID6 faulty drive
Date: Mon, 25 Mar 2013 16:02:28 +0000
Message-ID: <B2B36B3006DB4C47A56D6BA19443F5D12DE79EF4@IU-MSSG-MBX110.ads.iu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi,

As a result of extended power outage, the FedoraCore 17 machine with mdadm RAID went down. Bringing it up, I noticed "faulty /dev/sdf" in mdadm -detail. However mdadm -E /dev/sdf shows "State : clean".  Details are shown below. When I tried to add the drive to array, resync fails (I see lots of eSATA bus resets), and I get the same message in mdadm -detail. 

Questions:
1. How can a clean drive be reported faulty?
2. Is there a easy way to mark drive (/dev/sdf) as "assume-clean" and add it?

Please let me know if I should get an exact  replacement drive at this stage, pull out faulty /dev/sdf, and add the new drive to array. Thanks. 

Details:
#mdadm --detail /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Thu Dec 20 13:08:56 2012
     Raid Level : raid6
     Array Size : 11720297472 (11177.35 GiB 12001.58 GB)
  Used Dev Size : 1953382912 (1862.89 GiB 2000.26 GB)
   Raid Devices : 8
  Total Devices : 8
    Persistence : Superblock is persistent

    Update Time : Mon Mar 25 11:37:12 2013
          State : clean, degraded 
 Active Devices : 7
Working Devices : 7
Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : RAIDvol1
           UUID : 8a9eee70:89f2639b:68f5350d:11f444fe
         Events : 1494

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       96        1      active sync   /dev/sdg
       2       8      112        2      active sync   /dev/sdh
       3       8      128        3      active sync   /dev/sdi
       8       8       16        4      active sync   /dev/sdb
       5       8       32        5      active sync   /dev/sdc
       6       8       48        6      active sync   /dev/sdd
       7       8       64        7      active sync   /dev/sde

       9       8       80        -      faulty   /dev/sdf

# mdadm -E /dev/sdf
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x2
     Array UUID : 8a9eee70:89f2639b:68f5350d:11f444fe
           Name : RAIDvol1
  Creation Time : Thu Dec 20 13:08:56 2012
     Raid Level : raid6
   Raid Devices : 8

Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720297472 (11177.35 GiB 12001.58 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
Recovery Offset : 0 sectors
          State : clean
    Device UUID : 0a58fa5c:4d10f401:07dead3a:ec844676

    Update Time : Fri Mar 22 14:25:13 2013
       Checksum : ba455125 - correct
         Events : 1043

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAAA ('A' == active, '.' == missing)
#

Sundar
