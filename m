From: rob <rob@fantinibakery.com>
Subject: Re: missing superblock on RAID5
Date: Mon, 13 Oct 2003 15:57:19 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F8B039F.2070403@fantinibakery.com>
References: <3F8ACBD2.CA1B8CBD@vitoni.de> <3F8AD02C.8080606@fantinibakery.com> <3F8AE51C.3F0A9451@vitoni.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F8AE51C.3F0A9451@vitoni.de>
To: Victor <linux-raid@vitoni.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

that does look strange.  But I've been using software raid for just a 
couple weeks, so don't know a lot about it.

here is same command on our computer. i have only 2 devices.  looks like 
something is up with yours.  do you have another md device you can check 
the command on? 
 


root@fbc5:~ #  mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Tue Sep 30 15:22:45 2003
     Raid Level : raid1
     Array Size : 8337600 (7.95 GiB 8.54 GB)
    Device Size : 8337600 (7.95 GiB 8.54 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Oct 10 08:37:34 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8        6        0      active sync   
/dev/scsi/host0/bus0/target1/lun0/part6
       1       8       22        1      active sync   
/dev/scsi/host0/bus0/target3/lun0/part6
           UUID : 131c021d:7bc1e937:1bea7923:d7eed283
         Events : 0.54



Victor wrote:

>Now that you mention it I remember to have read somewhere that suberblocks
>are written at the end of _partitions_ and not arrays.
>
>Thanks for enlighten me :)
>
>Maybe another stupid question:
># mdadm --detail /dev/md0
>/dev/md0:
>        Version : 00.90.00
>  Creation Time : Sun May 18 14:19:37 2003
>     Raid Level : raid5
>     Array Size : 241254336 (230.08 GiB 247.04 GB)
>    Device Size : 80418112 (76.69 GiB 82.35 GB)
>   Raid Devices : 4
>  Total Devices : 5
>Preferred Minor : 0
>    Persistence : Superblock is persistent
>
>    Update Time : Wed Oct  8 23:53:50 2003
>          State : dirty, no-errors
> Active Devices : 4
>Working Devices : 4
> Failed Devices : 1
>  Spare Devices : 0
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
>    Number   Major   Minor   RaidDevice State
>       0       3       65        0      active sync
>/dev/ide/host0/bus0/target1/lun0/part1
>       1      22        1        1      active sync
>/dev/ide/host0/bus1/target0/lun0/part1
>       2      33        1        2      active sync
>/dev/ide/host2/bus0/target0/lun0/part1
>       3      34        1        3      active sync
>/dev/ide/host2/bus1/target0/lun0/part1
>           UUID : d8e2995c:dac28dbb:042eb748:bad0f5d6
>         Events : 0.52
>
>
>It says (or at least I think it says) that this array has 5 devices of which
>one is faulty. That's not true, it consists only out of 4 devices.
>
>Victor
>  
>

