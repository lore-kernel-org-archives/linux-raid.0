From: =?UTF-8?B?0KHQtdGA0LPQtdC5INCg0YvQttC+0LI=?=
        <ryzhovsergey@gmail.com>
Subject: Linux RAID reshaping hang, can somebody help me with this?
Date: Fri, 24 Apr 2020 11:47:24 +0300
Message-ID: <CAMk5DB3QbSaPkPzvwLdZp5HQaca8JYJrTS9ahfvOovFuhusPiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I've RAID-5 on 4 disks.
I've added 1 new drive as spare and run a command to grow array to 5-disks.
In the beginning, everything was fine, but now reshaping very slow -
speed=77K/sec

Kernel is 4.18.0-147.3.1.el8_1.x86_64
mdadm - v4.1 - 2018-10-01

Commands what I used:
mdadm --manage /dev/md3 --add  /dev/sdb
mdadm --grow /dev/md3 --raid-devices=5

There is crypted volume on raid: md3 -> cryptvol -> FS
When I tryed unmount FS, umount command hung, however FS gone from
'df' output.  Also I can't stop cryptvol,  'cryptsetup close' hung.

What I should do to don't lose my raid data?

#  mdadm --detail /dev/md3
/dev/md3:
           Version : 1.2
     Creation Time : Mon Jan 11 14:32:08 2016
        Raid Level : raid5
        Array Size : 5860150272 (5588.67 GiB 6000.79 GB)
     Used Dev Size : 1953383424 (1862.89 GiB 2000.26 GB)
      Raid Devices : 5
     Total Devices : 5
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Fri Apr 24 08:38:20 2020
             State : active, reshaping
    Active Devices : 5
   Working Devices : 5
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : bitmap

    Reshape Status : 56% complete
     Delta Devices : 1, (4->5)

              Name : farm:3  (local to host farm)
              UUID : e3537ea8:892da052:bfb9cb85:93156ade
            Events : 59168

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       4       8       48        1      active sync   /dev/sdd
       3       8       96        2      active sync   /dev/sdg
       5       8       32        3      active sync   /dev/sdc
       6       8       16        4      active sync   /dev/sdb

Regards,
Sergey
