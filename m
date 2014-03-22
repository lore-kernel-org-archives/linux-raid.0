From: Marcin Wanat <mwanat@forall.pl>
Subject: Raid10 to Raid0 conversion
Date: Sat, 22 Mar 2014 12:07:50 +0100
Message-ID: <532D6F06.1010901@forall.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

i have 4disc RAID10 on my server and i am trying to grow it to 6 devices.
As direct grow of RAID10 is unavailable so I decided to do it this way:

RAID10->RAID0->Grow RAID0 to 3 devices->RAID0(3 devices)->RAID10(6devices)

But i have problem on the first step. I have degraded my RAID10 array:
# mdadm --detail /dev/md1
/dev/md1:
         Version : 1.1
   Creation Time : Mon Sep  2 12:09:53 2013
      Raid Level : raid10
      Array Size : 1023996928 (976.56 GiB 1048.57 GB)
   Used Dev Size : 511998464 (488.28 GiB 524.29 GB)
    Raid Devices : 4
   Total Devices : 2
     Persistence : Superblock is persistent

     Update Time : Sat Mar 22 13:00:25 2014
           State : clean, degraded
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

          Layout : near=2
      Chunk Size : 512K

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        1       8       17        1      active sync   /dev/sdb1
        2       0        0        2      removed
        4       8       49        3      active sync   /dev/sdd1


And want to change it to RAID0:
# mdadm /dev/md1 --grow --level=0
or:
# mdadm /dev/md1 --grow --raid-devices=2 --level=0

but the result is always the same:
mdadm: /dev/md1: could not set level to raid0

dmesg shows:
md/raid0:md1: All mirrors must be already degraded!
md: md1: raid0 would not accept array

But the array is already degraded... What am I doing wrong ?

I am using Centos 6.5 default version of kernel and mdadm.


PS: I know that it is possible to grow RAID10 by creating new array with 
3 drives and 3 missing and then move data between them, but i am trying 
to grow live system without any offline time.


Regards,
Marcin Wanat
