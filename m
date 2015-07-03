From: "Justin Stephenson" <justin@evensteveninc.com>
Subject: Issue removing failed drive and re adding on raid 6
Date: Fri, 03 Jul 2015 15:44:42 +0000
Message-ID: <em17230779-c755-4dbc-9c40-6a0518cfd840@littlez>
Reply-To: "Justin Stephenson" <justin@evensteveninc.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am running a 7 disk raid 6 array. A disk failed last night during a 
regularly scheduled resync. I tried using mdadm --fail and --remove but 
mdadm froze.

When I rebooted mdadm reports the device as removed.

I replaced the drive, reformatted and repartitioned.

When I try to add the drive back in, mdadm reports that it is an invalid 
argument to re add.

Below is the mdadm --detail and my attempt to remove and add the drive 
/dev/sdf1

It would appear that I did not manage to properly fail and remove the 
drive. Is there a way of doing this after the fact so that I can add the 
new drive?

I would appreciate any input you would have.

Thanks,

- Justin


[root@BigBlue ~]# mdadm --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Wed Jan 15 22:46:32 2014
      Raid Level : raid6
   Used Dev Size : -1
    Raid Devices : 7
   Total Devices : 6
     Persistence : Superblock is persistent

     Update Time : Fri Jul  3 09:22:41 2015
           State : active, degraded, Not Started
  Active Devices : 6
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 128K

            Name : BigBlue:0  (local to host BigBlue)
            UUID : 0849c677:64e4772e:8892d80b:47e0097a
          Events : 15135

     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        1       8       49        1      active sync   /dev/sdd1
        2       8       65        2      active sync   /dev/sde1
        3       0        0        3      removed
        4       8       97        4      active sync   /dev/sdg1
        7       8      113        5      active sync   /dev/sdh1
        6       8       17        6      active sync   /dev/sdb1
[root@BigBlue ~]# mdadm --manage /dev/md0 --remove /dev/sdf1
mdadm: hot remove failed for /dev/sdf1: No such device or address
[root@BigBlue ~]# mdadm --manage /dev/md0 --add /dev/sdf1
mdadm: add new device failed for /dev/sdf1 as 8: Invalid argument

