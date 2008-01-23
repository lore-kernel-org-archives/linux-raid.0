From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Problem with raid5 grow/resize (not restripe)
Date: Wed, 23 Jan 2008 02:25:39 +0100
Message-ID: <47969793.9040105@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I can not seem to be able to extend slightly a raid volume of mine. I issue 
the command:

mdadm --grow --size=max /dev/md5

it completes and nothing happens. The kernel log is empty, however the even 
counter on the drive is incremented by +3.

Here is what I have (yes I know that I am resizing only by about 200MB). Why 
am I not able to reach 824.8GiB?

Thank you for your help.



root@Thesaurus:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md5 : active raid5 sda3[4] sdd3[3] sdc3[2] sdb3[1]
       864276480 blocks super 1.1 level 5, 2048k chunk, algorithm 2 [4/4] [UUUU]

md10 : active raid10 sdd2[3] sdc2[2] sdb2[1] sda2[0]
       5353472 blocks 1024K chunks 3 far-copies [4/4] [UUUU]

md1 : active raid1 sdd1[1] sdc1[0] sdb1[3] sda1[2]
       56128 blocks [4/4] [UUUU]

unused devices: <none>
root@Thesaurus:~#



root@Thesaurus:~# mdadm -D /dev/md5
/dev/md5:
         Version : 01.01.03
   Creation Time : Tue Jan 22 03:52:42 2008
      Raid Level : raid5
      Array Size : 864276480 (824.24 GiB 885.02 GB)
   Used Dev Size : 576184320 (274.75 GiB 295.01 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 5
     Persistence : Superblock is persistent

     Update Time : Wed Jan 23 02:21:47 2008
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 2048K

            Name : Thesaurus:Crypta  (local to host Thesaurus)
            UUID : 1decb2d1:ebf16128:a240938a:669b0999
          Events : 5632

     Number   Major   Minor   RaidDevice State
        4       8        3        0      active sync   /dev/sda3
        1       8       19        1      active sync   /dev/sdb3
        2       8       35        2      active sync   /dev/sdc3
        3       8       51        3      active sync   /dev/sdd3
root@Thesaurus:~#



root@Thesaurus:~# fdisk -l /dev/sd[abcd]

Disk /dev/sda: 400.0 GB, 400088457216 bytes
255 heads, 63 sectors/track, 48641 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1           7       56196   fd  Linux raid autodetect
/dev/sda2               8         507     4016250   fd  Linux raid autodetect
/dev/sda3             508       36385   288190035   83  Linux
/dev/sda4           36386       48641    98446320   83  Linux

Disk /dev/sdb: 320.0 GB, 320072933376 bytes
255 heads, 63 sectors/track, 38913 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1           7       56196   fd  Linux raid autodetect
/dev/sdb2               8         507     4016250   fd  Linux raid autodetect
/dev/sdb3             508       36385   288190035   83  Linux
/dev/sdb4           36386       38913    20306160   83  Linux

Disk /dev/sdc: 300.0 GB, 300090728448 bytes
255 heads, 63 sectors/track, 36483 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1           7       56196   fd  Linux raid autodetect
/dev/sdc2               8         507     4016250   fd  Linux raid autodetect
/dev/sdc3             508       36385   288190035   83  Linux
/dev/sdc4           36386       36483      787185   83  Linux

Disk /dev/sdd: 300.0 GB, 300090728448 bytes
255 heads, 63 sectors/track, 36483 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1           7       56196   fd  Linux raid autodetect
/dev/sdd2               8         507     4016250   fd  Linux raid autodetect
/dev/sdd3             508       36385   288190035   83  Linux
/dev/sdd4           36386       36483      787185   83  Linux
root@Thesaurus:~#

