From: Victor <linux-raid@vitoni.de>
Subject: Re: missing superblock on RAID5
Date: Mon, 13 Oct 2003 19:47:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F8AE51C.3F0A9451@vitoni.de>
References: <3F8ACBD2.CA1B8CBD@vitoni.de> <3F8AD02C.8080606@fantinibakery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Now that you mention it I remember to have read somewhere that suberblocks
are written at the end of _partitions_ and not arrays.

Thanks for enlighten me :)

Maybe another stupid question:
# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Sun May 18 14:19:37 2003
     Raid Level : raid5
     Array Size : 241254336 (230.08 GiB 247.04 GB)
    Device Size : 80418112 (76.69 GiB 82.35 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Oct  8 23:53:50 2003
          State : dirty, no-errors
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0       3       65        0      active sync
/dev/ide/host0/bus0/target1/lun0/part1
       1      22        1        1      active sync
/dev/ide/host0/bus1/target0/lun0/part1
       2      33        1        2      active sync
/dev/ide/host2/bus0/target0/lun0/part1
       3      34        1        3      active sync
/dev/ide/host2/bus1/target0/lun0/part1
           UUID : d8e2995c:dac28dbb:042eb748:bad0f5d6
         Events : 0.52


It says (or at least I think it says) that this array has 5 devices of which
one is faulty. That's not true, it consists only out of 4 devices.

Victor



rob wrote:

> from my sys:
> root@fbc5:/etc # mdadm --query /dev/md3
> /dev/md3: 4.67GiB raid1 2 devices, 0 spares. Use mdadm --detail for more
> detail.
> /dev/md3: No md super block found, not an md component.
>
> root@fbc5:/etc # mdadm --query /dev/sdd5
> /dev/sdd5: is not an md array
> /dev/sdd5: device 1 in 2 device active raid1 md3.  Use mdadm --examine
> for more detail.
>
> so the superblock is not on the /dev/md3 .
>
> query the disk partition to get the superblock
>
> Victor wrote:
>
> >At the time I created the RAID array I thought it had superblocks,
> >however if I use mdadm I get these results:
> >
> ># mdadm --query /dev/md0
> >/dev/md0: 230.08GiB raid5 4 devices, 0 spares. Use mdadm --detail for
> >more detail.
> >/dev/md0: No md super block found, not an md component.
> >
> >If  the array really shouldn't have a superblock, is it possible to add
> >one (maybe marking a device faulty and readding it and repeating this
> >for each device)?
> >
> >
> >Thanks in advance,
> >
> >Victor
> >
> >
> >-
> >To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >


