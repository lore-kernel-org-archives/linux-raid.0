From: Andrew Burgess <aab@cichlid.com>
Subject: Re: need help with raid6 recovery
Date: Fri, 2 Dec 2005 06:07:04 -0800
Message-ID: <200512021407.jB2E74ae005786@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I tried:

root # mdadm -A /dev/md1 -v --force /dev/sdq1 /dev/sds1 /dev/sdab1 missing /dev/sdaa3 /dev/sdo1 /dev/sdu1 missing
mdadm: looking for devices for /dev/md1
mdadm: no recogniseable superblock
mdadm: /dev/sdq1 has no superblock - assembly aborted

and:

root # mdadm -A /dev/md1 -v --update=summaries --force /dev/sdq1 /dev/sds1 /dev/sdab1 missing /dev/sdaa3 /dev/sdo1 /dev/sdu1 missing
mdadm: looking for devices for /dev/md1
mdadm: no recogniseable superblock
mdadm: /dev/sdq1 has no superblock - assembly aborted

My next idea is to use dd to copy the superblock from a working device to sdq1
and edit it for the correct index.

Any thoughts?

Is there a more automatic way to do this?

Thanks for any help
Andrew


On 2005-12-01 0:05:54, Andrew Burgess aab@cichlid.com said:

> I have an 8 device raid6 array with 3 bad devices. Two
> of the bad devices are recognized as spares belonging to
> the array, the third device, the one that was most recently
> an active sync part of the array somehow losts its superblock.
> 
> I'd like to try running the array with each of the bad devices
> and see which makes an array with the least damaged filesystem.
> One problem is how to add the device without the superblock.
> I want to make sure it goes into position[0] in the array and
> I'm not sure how to specifiy that with mdadm.
> 
> sdq1 is the device without the superblock, sdn1 and sde1 are
> marked as spares but they were in sync recently.
> 
> To add sdq1 as device [0] even though it has no superblock would it be enough
> to specify all the devices in the right order and leave the two that I'm not
> experimenting with as missing?
> 
> mdadm -A /dev/md1 --force /dev/sdq1 /dev/sds1 /dev/sdab1 missing /dev/sdaa3 /dev/sdo1 /dev/sdu1 missing
> 
> And to try each spare in positions [3] and [7] a similar command, even though
> the superblocks on the spares say [8] and [9]?
> 
> I want to avoid md doing any resyncing or recovery until I find the best
> 'bad' device to use.
> 
> Thanks for any help!
> Andrew
> 
> PS This all happened when I upgraded the motherboard and the kernel version
> at the same time, the resulting combination worked badly with my disk controllers
> causing md to think drives were bad when they really weren't. Though how the
> superblock vanished on the one drive is a mystery...
> 
> =======================================================
> 
> root # cat /proc/mdstat
> md1 : inactive sds1[1] sde1[9] sdn1[8] sdu1[6] sdo1[5] sdaa3[4] sdab1[2]
>       2051009792 blocks
> 
> root # mdadm -A /dev/md1
> mdadm: /dev/md1 assembled from 5 drives and 2 spares - not enough to start the array.
> 
> root # mdadm -A -v /dev/md1 2>&1 | grep added
> mdadm: added /dev/sdab1 to /dev/md1 as 2
> mdadm: added /dev/sdaa3 to /dev/md1 as 4
> mdadm: added /dev/sdo1 to /dev/md1 as 5
> mdadm: added /dev/sdu1 to /dev/md1 as 6
> mdadm: added /dev/sdn1 to /dev/md1 as 8
> mdadm: added /dev/sde1 to /dev/md1 as 9
> mdadm: added /dev/sds1 to /dev/md1 as 1
> 
> root # mdadm -E /dev/sde1
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 7fdb1d16:24896504:7df4ea3b:c7f0bf96
>   Creation Time : Sat Nov 12 12:43:57 2005
>      Raid Level : raid6
>     Device Size : 292969216 (279.40 GiB 300.00 GB)
>    Raid Devices : 8
>   Total Devices : 8
> Preferred Minor : 1
> 
>     Update Time : Wed Nov 30 08:12:57 2005
>           State : clean
>  Active Devices : 6
> Working Devices : 8
>  Failed Devices : 2
>   Spare Devices : 2
>        Checksum : 2c0e61a6 - correct
>          Events : 0.930007
> 
> 
>       Number   Major   Minor   RaidDevice State
> this     9       8       65        9      spare   /dev/sde1
> 
>    0     0      65        1        0      active sync   /dev/sdq1
>    1     1      65       33        1      active sync   /dev/sds1
>    2     2      65      177        2      active sync   /dev/sdab1
>    3     3       0        0        3      faulty removed
>    4     4      65      163        4      active sync   /dev/sdaa3
>    5     5       8      225        5      active sync   /dev/sdo1
>    6     6      65       65        6      active sync   /dev/sdu1
>    7     7       0        0        7      faulty removed
>    8     8       8      209        8      spare   /dev/sdn1
>    9     9       8       65        9      spare   /dev/sde1
> 
> root # mdadm -E /dev/sdn1
> /dev/sdn1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 7fdb1d16:24896504:7df4ea3b:c7f0bf96
>   Creation Time : Sat Nov 12 12:43:57 2005
>      Raid Level : raid6
>     Device Size : 292969216 (279.40 GiB 300.00 GB)
>    Raid Devices : 8
>   Total Devices : 8
> Preferred Minor : 1
> 
>     Update Time : Wed Nov 30 08:12:57 2005
>           State : clean
>  Active Devices : 6
> Working Devices : 8
>  Failed Devices : 2
>   Spare Devices : 2
>        Checksum : 2c0e6234 - correct
>          Events : 0.930007
> 
> 
>       Number   Major   Minor   RaidDevice State
> this     8       8      209        8      spare   /dev/sdn1
> 
>    0     0      65        1        0      active sync   /dev/sdq1
>    1     1      65       33        1      active sync   /dev/sds1
>    2     2      65      177        2      active sync   /dev/sdab1
>    3     3       0        0        3      faulty removed
>    4     4      65      163        4      active sync   /dev/sdaa3
>    5     5       8      225        5      active sync   /dev/sdo1
>    6     6      65       65        6      active sync   /dev/sdu1
>    7     7       0        0        7      faulty removed
>    8     8       8      209        8      spare   /dev/sdn1
>    9     9       8       65        9      spare   /dev/sde1
> 
> 
