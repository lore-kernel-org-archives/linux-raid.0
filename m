From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Growing RAID5 SSD Array
Date: Thu, 13 Mar 2014 13:49:01 +1100
Message-ID: <53211C9D.8050607@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

About a year ago I setup a RAID5 array with 5 x Intel 480GB SSD's, (with 
a huge amount of help from the list in general, and Stan in particular, 
thanks again). Now I need to grow my array to 6 drives to get a little 
extra storage capacity, and just want to confirm I'm not doing anything 
crazy/stupid, and take the opportunity to re-check what I've got.

So, currently I have 5 x Intel 480GB SSD:
Device Model:     INTEL SSDSC2CW480A3
Serial Number:    CVCV205201PK480DGN
LU WWN Device Id: 5 001517 bb2833c5f
Firmware Version: 400i
User Capacity:    480,103,981,056 bytes [480 GB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ACS-2 revision 3
Local Time is:    Thu Mar 13 13:40:20 2014 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

md1 : active raid5 sdc1[7] sde1[9] sdf1[5] sdd1[8] sda1[6]
       1875391744 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5] 
[UUUUU]

/dev/md1:
         Version : 1.2
   Creation Time : Wed Aug 22 00:47:03 2012
      Raid Level : raid5
      Array Size : 1875391744 (1788.51 GiB 1920.40 GB)
   Used Dev Size : 468847936 (447.13 GiB 480.10 GB)
    Raid Devices : 5
   Total Devices : 5
     Persistence : Superblock is persistent

     Update Time : Thu Mar 13 13:41:03 2014
           State : active
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            Name : san1:1  (local to host san1)
            UUID : 707957c0:b7195438:06da5bc4:485d301c
          Events : 1712560

     Number   Major   Minor   RaidDevice State
        7       8       33        0      active sync   /dev/sdc1
        6       8        1        1      active sync   /dev/sda1
        8       8       49        2      active sync   /dev/sdd1
        5       8       81        3      active sync   /dev/sdf1
        9       8       65        4      active sync   /dev/sde1

One thing I've noticed is that on average, some drives seem to have more 
activity that others (ie, watching the flashing lights), however, the 
below stats from the drives themselves:
/dev/sda
241 Total_LBAs_Written      0x0032   100   100   000    Old_age 
Always       -       845235
242 Total_LBAs_Read         0x0032   100   100   000    Old_age 
Always       -       1725102
/dev/sdb
241 Total_LBAs_Written      0x0032   100   100   000    Old_age 
Always       -       0
242 Total_LBAs_Read         0x0032   100   100   000    Old_age 
Always       -       0
/dev/sdc
241 Total_LBAs_Written      0x0032   100   100   000    Old_age 
Always       -       851335
242 Total_LBAs_Read         0x0032   100   100   000    Old_age 
Always       -       1715159
/dev/sdd
241 Total_LBAs_Written      0x0032   100   100   000    Old_age 
Always       -       804564
242 Total_LBAs_Read         0x0032   100   100   000    Old_age 
Always       -       1670041
/dev/sde
241 Total_LBAs_Written      0x0032   100   100   000    Old_age 
Always       -       719767
242 Total_LBAs_Read         0x0032   100   100   000    Old_age 
Always       -       1577363
/dev/sdf
241 Total_LBAs_Written      0x0032   100   100   000    Old_age 
Always       -       719982
242 Total_LBAs_Read         0x0032   100   100   000    Old_age 
Always       -       1577900

sdb is the new drive obviously, not yet part of the array.

So the drive with the highest writes 851335 and the drive with the 
lowest writes 719982 show a big difference. Perhaps I have a problem 
with the setup/config of my array, or similar?

So, I could simply do the following:
mdadm --manage /dev/md1 --add /dev/sdb1
mdadm --grow /dev/md1 --raid-devices=6

Probably also need to remove the bitmap and re-add the bitmap.

Can anyone suggest if what I am seeing is "normal", and should I just go 
ahead and add the extra disk?

Regards,
Adam
-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
