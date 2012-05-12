From: nowhere <nowhere@hakkenden.ath.cx>
Subject: mdadm 3.2.4 problem
Date: Sat, 12 May 2012 17:30:16 +0400
Message-ID: <1336829416.20535.10.camel@rybalov.eng.ttk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a RAID5 array, which was created with mdadm 3.2.3
Here is one of its member's superblock:

/dev/sdl:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : cc0fbdd2:0feade15:963fe546:13a072fa
           Name : heimdall:0  (local to host heimdall)
  Creation Time : Sun May  6 10:58:30 2012
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
     Array Size : 13674590720 (13041.11 GiB 14002.78 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 64962294:3699d869:510bef35:9d2fd78d

    Update Time : Sat May 12 17:03:28 2012
       Checksum : df1714ca - correct
         Events : 96

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAA. ('A' == active, '.' == missing)

Some time ago mdadm have been upgraded to 3.2.4

So, today I have replaced failed drive, but could not add it:
mdadm --manage /dev/md0 --add /dev/sdm 
mdadm: add new device failed for /dev/sdm as 8: Invalid argument

And there are lines in dmesg:
md: sdm does not have a valid v1.2 superblock, not importing!
md: md_import_device returned -22

mdadm creates new superblock on sdm:
/dev/sdm:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : cc0fbdd2:0feade15:963fe546:13a072fa
           Name : heimdall:0  (local to host heimdall)
  Creation Time : Sun May  6 10:58:30 2012
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 13674590720 (13041.11 GiB 14002.78 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : ecaaf8af:f41c6ca1:8190b6f8:37b53a06

    Update Time : Sat May 12 16:46:20 2012
       Checksum : 6dabb37a - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAAAAA. ('A' == active, '.' == missing)

New direve's size is equals to other drive's sizes (checked with
blockdev --getsz)

The only difference between superblocks created by diferent mdadm
versions is data offset. Old one has 2048 sector offset, new one -
262144. I think, this leads to available device size to be smaller with
new superblock and inability to add drive to the array.

Downgrading mdadm allowed me to add device into array.

