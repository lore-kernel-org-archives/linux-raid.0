From: rrk <rrk@prairie.lakes.com>
Subject: mdadm raid1 creation problem --data
Date: Sat, 12 Jun 2004 02:04:47 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40CAAB0F.5040600@prairie.lakes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

why does it show 3 devices --- 2 active and 1 failed in the superblock info
this data was taken after i changed fstab & grub from /dev/md1 to /dev/hda1
and rebooted fsck ran on auto and no problem found


here is a dump of mdstat

Personalities : [raid1]
read_ahead 1024 sectors
md1 : active raid1 hdc1[1] hda1[0]
      10241280 blocks [2/2] [UU]

md5 : active raid1 hdc5[1] hda5[0]
      3220928 blocks [2/2] [UU]

md6 : active raid1 hdc6[1] hda6[0]
      5630656 blocks [2/2] [UU]

md8 : active raid1 hdc8[1] hda8[0]
      97795584 blocks [2/2] [UU]
*******************************************
fdisk data for hda & hdc

Disk /dev/hda: 120.0 GB, 120000000000 bytes
255 heads, 63 sectors/track, 14589 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hda1   *         1      1275  10241406   fd  Linux raid autodetect
/dev/hda2          1276     14589 106944705    5  Extended
/dev/hda5          1276      1676   3221001   fd  Linux raid autodetect
/dev/hda6          1677      2377   5630751   fd  Linux raid autodetect
/dev/hda7          2378      2414    297171   82  Linux swap
/dev/hda8          2415     14589  97795656   fd  Linux raid autodetect



superblock dump

root@stardoc_fs:/home/rob# mdadm -E /dev/hda1
/dev/hda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : cdbefbc6:eae47c90:4bc54343:35b9dfcc
  Creation Time : Fri Jun 11 06:29:17 2004
     Raid Level : raid1
    Device Size : 10241280 (9.77 GiB 10.49 GB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 1

    Update Time : Fri Jun 11 01:17:41 2004
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 657d168b - correct
         Events : 0.23


      Number   Major   Minor   RaidDevice State
this     0       3        1        0      active sync   /dev/hda1
   0     0       3        1        0      active sync   /dev/hda1
   1     1      22        1        1      active sync   /dev/hdc1


root@stardoc_fs:/home/rob# mdadm -E /dev/hdc1
/dev/hdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : cdbefbc6:eae47c90:4bc54343:35b9dfcc
  Creation Time : Fri Jun 11 06:29:17 2004
     Raid Level : raid1
    Device Size : 10241280 (9.77 GiB 10.49 GB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 1

    Update Time : Fri Jun 11 01:17:41 2004
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 657d16a0 - correct
         Events : 0.23


      Number   Major   Minor   RaidDevice State
this     1      22        1        1      active sync   /dev/hdc1
   0     0       3        1        0      active sync   /dev/hda1
   1     1      22        1        1      active sync   /dev/hdc1


