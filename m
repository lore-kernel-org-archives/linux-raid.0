From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: freshly grown array shrinks after first reboot - major data loss
Date: Thu, 01 Sep 2011 18:16:41 +0200
Message-ID: <4E5FAFE9.3040604@macroscoop.nl>
References: <4E5FA4B5.6010407@macroscoop.nl> <4E5FAEF3.60501@macroscoop.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5FAEF3.60501@macroscoop.nl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

More info:

# gdisk -l /dev/sdk
GPT fdisk (gdisk) version 0.7.2

Partition table scan:
   MBR: protective
   BSD: not present
   APM: not present
   GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdk: 5860533168 sectors, 2.7 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): BEEBC2FD-A959-4292-8115-AEFA06E0978E
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 5860533134
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
    1            2048      5860533134   2.7 TiB     FD00  Linux RAID

# mdadm --examine /dev/sdk1
/dev/sdk1:
           Magic : a92b4efc
         Version : 0.90.03
            UUID : 1bf1b0e2:82d487c5:f6f36a45:766001d1
   Creation Time : Wed Feb  8 23:22:15 2006
      Raid Level : raid5
   Used Dev Size : 782781824 (746.52 GiB 801.57 GB)
      Array Size : 4696690944 (4479.11 GiB 4809.41 GB)
    Raid Devices : 7
   Total Devices : 7
Preferred Minor : 0

     Update Time : Thu Sep  1 18:11:08 2011
           State : clean
  Active Devices : 7
Working Devices : 7
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 7698c20e - correct
          Events : 3157574

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     0       8      161        0      active sync   /dev/sdk1

    0     0       8      161        0      active sync   /dev/sdk1
    1     1       8      177        1      active sync   /dev/sdl1
    2     2       8      193        2      active sync   /dev/sdm1
    3     3       8      145        3      active sync   /dev/sdj1
    4     4       8      209        4      active sync   /dev/sdn1
    5     5       8      225        5      active sync   /dev/sdo1
    6     6       8      129        6      active sync   /dev/sdi1

