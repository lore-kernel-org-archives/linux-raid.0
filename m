From: Phillip Susi <phillsusi@gmail.com>
Subject: Kernel says there is not a valid superblock, but there is
Date: Mon, 20 Oct 2014 11:09:59 -0400
Message-ID: <544525C7.7000803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When trying to assemble, the kernel complains:

md: md1 stopped.
md: sda2 does not have a valid v1.2 superblock, not importing!
md: md_import_device returned -22
md: sdb2 does not have a valid v1.2 superblock, not importing!
md: md_import_device returned -22

Yet the superblock looks perfectly fine according to mdadm -E:

/dev/sda2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 34e89993:37821273:5498dc63:07233b2c
           Name : devserv2:1
  Creation Time : Mon Jun 16 11:24:00 2014
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 3900907520 (1860.10 GiB 1997.26 GB)
     Array Size : 158334976 (151.00 GiB 162.14 GB)
  Used Dev Size : 316669952 (151.00 GiB 162.14 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 40c38a87:88807f78:5bf71f34:4c9b2215

    Update Time : Mon Oct 20 09:56:25 2014
       Checksum : d2369656 - correct
         Events : 303


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)

/dev/sdb2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 34e89993:37821273:5498dc63:07233b2c
           Name : devserv2:1
  Creation Time : Mon Jun 16 11:24:00 2014
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 3900907520 (1860.10 GiB 1997.26 GB)
     Array Size : 158334976 (151.00 GiB 162.14 GB)
  Used Dev Size : 316669952 (151.00 GiB 162.14 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0fb85e8f:e697a9a0:7bd6eac4:03b8851d

    Update Time : Mon Oct 20 10:08:35 2014
       Checksum : 9b63a13c - correct
         Events : 311


   Device Role : Active device 1
   Array State : .A ('A' == active, '.' == missing)
