From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Fri, 2 Jan 2009 10:12:42 -0800 (PST)
Message-ID: <17665.11566.qm@web30804.mail.mud.yahoo.com>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan> <467705.96388.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan> <344038.60917.qm@web30808.mail.mud.yahoo.com> <alpine.DEB.1.10.0901020708210.3858@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

Thanks for the response.  When I try and assemble the array with just 6 disks (the 5 good ones and one of sdo1 or sdg1) I get:

(none):~> mdadm /dev/md1 --assemble /dev/sdf1   /dev/sdh1 /dev/sdj1 /dev/sdk1 /dev/sdo1 /dev/sdd1 --force
mdadm: /dev/md1 assembled from 5 drives - not enough to start the array.


(none):~> mdadm /dev/md1 --assemble /dev/sdf1  /dev/sdg1 /dev/sdh1 /dev/sdj1 /dev/sdk1  /dev/sdd1 --force
mdadm: /dev/md1 assembled from 5 drives - not enough to start the array.

As for the smart info:

(none):~> smartctl -i /dev/sdo1
smartctl 5.39 2008-05-08 21:56 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-8 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Hitachi Deskstar 7K1000
Device Model:     Hitachi HDS721010KLA330
Serial Number:    GTJ000PAG552VC
Firmware Version: GKAOA70M
User Capacity:    1,000,204,886,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 1
Local Time is:    Fri Jan  2 09:32:07 2009 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

and 

(none):~> smartctl -i /dev/sdg1
smartctl 5.39 2008-05-08 21:56 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-8 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Hitachi Deskstar 7K1000
Device Model:     Hitachi HDS721010KLA330
Serial Number:    GTA000PAG5R0AA
Firmware Version: GKAOA70M
User Capacity:    1,000,204,886,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 1
Local Time is:    Fri Jan  2 10:04:55 2009 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled


When I tried to read the smart data from the sdo1, the drive went offline and I get a controller error!


Here's what I get talking to sdg1:

(none):~> smartctl -l error  /dev/sdg1
smartctl 5.39 2008-05-08 21:56 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-8 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF READ SMART DATA SECTION ===
SMART Error Log Version: 1
ATA Error Count: 1
        CR = Command Register [HEX]
        FR = Features Register [HEX]
        SC = Sector Count Register [HEX]
        SN = Sector Number Register [HEX]
        CL = Cylinder Low Register [HEX]
        CH = Cylinder High Register [HEX]
        DH = Device/Head Register [HEX]
        DC = Device Command Register [HEX]
        ER = Error register [HEX]
        ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 1 occurred at disk power-on lifetime: 6388 hours (266 days + 4 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  84 51 00 00 00 00 a0

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  ec 00 00 00 00 00 a0 08   6d+23:19:44.200  IDENTIFY DEVICE
  25 00 01 01 00 00 00 04   6d+23:19:44.000  READ DMA EXT
  25 00 80 be 1b ba ef ff   6d+23:19:42.500  READ DMA EXT
  25 00 c0 7f 1b ba e0 08   6d+23:19:42.500  READ DMA EXT
  25 00 40 3f 1b ba e0 08   6d+23:19:30.300  READ DMA EXT



As for RAID6, well this array started off as a 3 disk RAID5, and then got incrementally grown as capacity needs grew.  I wasn't going to go beyond 7 disks in the raid set, but since you can't reshape raid5 into raid6, and so I would have another few TB of disk available to move the raid set data to.  Since I use XFS, I can't just move off data and then shrink the filesystem to minimize the needs.  md and XFS make it easy to add disks, but very hard to remove them.  :-(

It looks like my best bet is to try and get sd1g back into the raid set somehow, but I don't understand why md isn't assembling it into the set.  Should I try and clone sdo1 to a new disk, or sdg1?  But I am not sure what help that would be if md won't assemble with it.

thx
mike



----- Original Message ----
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org; john lists <john4lists@gmail.com>
Sent: Friday, January 2, 2009 4:10:20 AM
Subject: Re: Need urgent help in fixing raid5 array



On Thu, 1 Jan 2009, Mike Myers wrote:

> Ok, the bad MPT board is out, replaced by a SI3132, and I rejiggered the drives around so that all the drives are connected.  It brought me back to the main problem.  md2 is running fine, md1 cannot assemble with only 5 drives out of the 7.
>
> Here is the data you requested:
>
> (none):~ # cat /etc/mdadm.conf
> DEVICE partitions
> ARRAY /dev/md0 level=raid0 UUID=9412e7e1:fd56806c:0f9cc200:95c7ed98
> ARRAY /dev/md3 level=raid0 UUID=67999c69:4a9ca9f9:7d4d6b81:91c98b1f
> ARRAY /dev/md1 level=raid5 UUID=b737af5c:7c0a70a9:99a648a0:7f693c7d
> ARRAY /dev/md2 level=raid5 UUID=e70e0697:a10a5b75:941dd76f:196d9e4e
> #ARRAY /dev/md2 level=raid0 UUID=658369ee:23081b79:c990e3a2:15f38c70
> #ARRAY /dev/md3 level=raid0 UUID=e2c910ae:0052c38e:a5e19298:0d057e34
> MAILADDR root
>
> (md0 and md3 are old arrays that have since been removed - no disks with their uuids are in the system)
>
> (none):~> mdadm -D /dev/md1
> mdadm: md device /dev/md1 does not appear to be active.
>
>
> (none):~> mdadm -D /dev/md2
> /dev/md2:
>        Version : 00.90.03
>  Creation Time : Tue Aug 19 21:31:10 2008
>     Raid Level : raid5
>     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
>  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
>   Raid Devices : 7
>  Total Devices : 7
> Preferred Minor : 2
>    Persistence : Superblock is persistent
>
>    Update Time : Thu Jan  1 21:59:20 2009
>          State : clean
> Active Devices : 7
> Working Devices : 7
> Failed Devices : 0
>  Spare Devices : 0
>
>         Layout : left-symmetric
>     Chunk Size : 128K
>
>           UUID : e70e0697:a10a5b75:941dd76f:196d9e4e
>         Events : 0.1438838
>
>    Number   Major   Minor   RaidDevice State
>       0       8      209        0      active sync   /dev/sdn1
>       1       8      129        1      active sync   /dev/sdi1
>       2       8      177        2      active sync   /dev/sdl1
>       3       8       17        3      active sync   /dev/sdb1
>       4       8       33        4      active sync   /dev/sdc1
>       5       8       65        5      active sync   /dev/sde1
>       6       8      193        6      active sync   /dev/sdm1
>
>
> (md1 is comprised of sdd1 sdf1 sdg1 sdh1 sdj1 sdk1 sdo1)
>

What happens if you use assemble and force with the five good drives
and one or the other of the ones that are not assembling (to assemble in
degraded mode)?

For the two disks that have 'failed' can you show their smart stats, I am
curious to see them.

Worst case which I do not recommend unless it is your last resort is re-create
the array with --assume-clean with the same options you used originally; doing
this though will cause filesystem corruption.

I recommend you switch to RAID-6 with an array that big btw :)

Justin.


      
