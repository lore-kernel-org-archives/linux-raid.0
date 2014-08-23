From: Andy Smith <andy@strugglers.net>
Subject: Shrinking number of devices on a RAID-10 (near 2) array
Date: Sat, 23 Aug 2014 16:31:10 +0000
Message-ID: <20140823163110.GE11855@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am aware that for a very long time it was not possible to change
the number of devices in an mdadm RAID-10. But then recently I am
sure I saw threads here alluding to this being possible. e.g.:

    http://marc.info/?l=linux-raid&m=140768923829685&w=2

I have a 6 device RAID-10 near=2 array that I would like to shrink
down to 4 devices.

I have compiled mdadm 3.3.2 and am using kernel 3.16.0.

$ sudo mdadm --detail /dev/md2
/dev/md2:
        Version : 0.90
  Creation Time : Sun Jun  4 08:18:58 2006
     Raid Level : raid10
     Array Size : 471859200 (450.00 GiB 483.18 GB)
  Used Dev Size : 309363520 (295.03 GiB 316.79 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sat Aug 23 15:23:38 2014
          State : active 
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 64K

           UUID : 3905b303:ca604b72:be5949c4:ab051b7a
         Events : 0.312149991

    Number   Major   Minor   RaidDevice State
       0       8       51        0      active sync   /dev/sdd3
       1       8       67        1      active sync   /dev/sde3
       2       8       83        2      active sync   /dev/sdf3
       3       8       19        3      active sync   /dev/sdb3
       4       8       35        4      active sync   /dev/sdc3
       5       8        3        5      active sync   /dev/sda3

$ sudo ./mdadm --grow -n4 /dev/md2 --backup-file /var/tmp/mdadm.backup
mdadm: Cannot set new_data_offset: RAID10 reshape not
       supported on this kernel

Is that not yet possible, then?

(Each device is 320GB so it should all fit with only four of them)

Cheers,
Andy
