From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: What the heck happened to my array? (No apparent data loss).
Date: Mon, 04 Apr 2011 13:59:03 +0800
Message-ID: <4D995E27.3060800@fnarfbargle.com>
References: <4D9876E4.6080501@fnarfbargle.com> <AANLkTi=2GNYdySbCDXmaDC8-8vF8GU9V3Uoy1qByNq58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=2GNYdySbCDXmaDC8-8vF8GU9V3Uoy1qByNq58@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/04/11 23:47, Roberto Spadim wrote:
> what kernel version? more informations about your linux box?

The kernel version and architecture were the first 2 lines of the E-mail 
you top posted over.

What would you like to know about the box? It's a 6 core Phenom-II with 
16G of ram. 2 LSI SAS 9240 controllers configured with 10 x 1TB SATA 
Drives in a RAID-6(md0) & 3 x 750GB SATA drives in a RAID-5(md2).

The boot drives are a pair of 1TB SATA drives in multiple RAID-1's using 
the on-board AMD chipset controller and there is a 64GB SSD on a 
separate PCI-E Marvell 7042m Controller.

The array in question is :

root@srv:~# mdadm --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Sat Jan  8 11:25:17 2011
      Raid Level : raid6
      Array Size : 7814078464 (7452.09 GiB 8001.62 GB)
   Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
    Raid Devices : 10
   Total Devices : 9
     Persistence : Superblock is persistent

     Update Time : Mon Apr  4 13:53:59 2011
           State : clean, degraded, recovering
  Active Devices : 9
Working Devices : 9
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

  Reshape Status : 29% complete
   New Chunksize : 64K

            Name : srv:server  (local to host srv)
            UUID : d00a11d7:fe0435af:07c8d4d6:e3b8e34e
          Events : 429198

     Number   Major   Minor   RaidDevice State
        0       8       32        0      active sync   /dev/sdc
        1       8      176        1      active sync   /dev/sdl
        2       8      192        2      active sync   /dev/sdm
        3       8       80        3      active sync   /dev/sdf
        4       8       16        4      active sync   /dev/sdb
        5       8       96        5      active sync   /dev/sdg
        6       0        0        6      removed
        7       8       64        7      active sync   /dev/sde
        8       8        0        8      active sync   /dev/sda
        9       8      112        9      active sync   /dev/sdh
root@srv:~#

Subsequent investigation has shown sdd has a pending reallocation and I 
can only assume the unidentified IO error was as a result of tripping up 
on that. It still does not explain why all IO to the array froze after 
the drive was kicked.

