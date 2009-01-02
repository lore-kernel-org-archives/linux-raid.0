From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Fri, 2 Jan 2009 10:46:13 -0800 (PST)
Message-ID: <746863.34803.qm@web30803.mail.mud.yahoo.com>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan> <467705.96388.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan> <344038.60917.qm@web30808.mail.mud.yahoo.com> <alpine.DEB.1.10.0901020708210.3858@p34.internal.lan> <17665.11566.qm@web30804.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021319330.26159@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

Well, I can read from sdg1 just fine.  It seems to work ok, at least for a few GB of data.   I'll try this on some of the other disks, but it is possible for to pull the disks out of the backplane and run the SFF-8087 fanout cables direct to each drive and bypass the backplane completely.  It certainly would be easy to do this for the at least the sdo1 drive and see if I can get better results going direct to the disk.  I have moved the disks around the backplane a bit to deal with the issues of the controller failure, so I am pretty sure it's not just one bad slot or the like.  

So you've seen a backplane fail in away that the disks come up fine at boot but have corrupted data transfers across them?  I wonder about the sata cables in that case as well.  I could hook up a pair of PMP's to my SI3132's and bypass the 8077 cables as well.

Thx
Mike






----- Original Message ----
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org; john lists <john4lists@gmail.com>
Sent: Friday, January 2, 2009 10:22:29 AM
Subject: Re: Need urgent help in fixing raid5 array



On Fri, 2 Jan 2009, Mike Myers wrote:

> Thanks for the response.  When I try and assemble the array with just 6 disks (the 5 good ones and one of sdo1 or sdg1) I get:
>
> (none):~> mdadm /dev/md1 --assemble /dev/sdf1   /dev/sdh1 /dev/sdj1 /dev/sdk1 /dev/sdo1 /dev/sdd1 --force
> mdadm: /dev/md1 assembled from 5 drives - not enough to start the array.
>
>
> (none):~> mdadm /dev/md1 --assemble /dev/sdf1  /dev/sdg1 /dev/sdh1 /dev/sdj1 /dev/sdk1  /dev/sdd1 --force
> mdadm: /dev/md1 assembled from 5 drives - not enough to start the array.
>
> As for the smart info:
>
> (none):~> smartctl -i /dev/sdo1
> smartctl 5.39 2008-05-08 21:56 [x86_64-unknown-linux-gnu] (local build)
> Copyright (C) 2002-8 by Bruce Allen, http://smartmontools.sourceforge.net
>
> === START OF INFORMATION SECTION ===
> Model Family:     Hitachi Deskstar 7K1000
> Device Model:     Hitachi HDS721010KLA330
> Serial Number:    GTJ000PAG552VC
> Firmware Version: GKAOA70M
> User Capacity:    1,000,204,886,016 bytes
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   7
> ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 1
> Local Time is:    Fri Jan  2 09:32:07 2009 PST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>
> and
>
> (none):~> smartctl -i /dev/sdg1
> smartctl 5.39 2008-05-08 21:56 [x86_64-unknown-linux-gnu] (local build)
> Copyright (C) 2002-8 by Bruce Allen, http://smartmontools.sourceforge.net
>
> === START OF INFORMATION SECTION ===
> Model Family:     Hitachi Deskstar 7K1000
> Device Model:     Hitachi HDS721010KLA330
> Serial Number:    GTA000PAG5R0AA
> Firmware Version: GKAOA70M
> User Capacity:    1,000,204,886,016 bytes
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   7
> ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 1
> Local Time is:    Fri Jan  2 10:04:55 2009 PST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>
>
> When I tried to read the smart data from the sdo1, the drive went offline and I get a controller error!
I would figure out why this happens first and fix it if possible. Backplane?
Cable? Controller?  Btw: The interest bits from smartctl-- need to see
smartctl -a so we can see the statistics for each of the identifiers.

>
>
> Here's what I get talking to sdg1:
>
> (none):~> smartctl -l error  /dev/sdg1
> smartctl 5.39 2008-05-08 21:56 [x86_64-unknown-linux-gnu] (local build)
> Copyright (C) 2002-8 by Bruce Allen, http://smartmontools.sourceforge.net
>
> === START OF READ SMART DATA SECTION ===
> SMART Error Log Version: 1
> ATA Error Count: 1
>        CR = Command Register [HEX]
>        FR = Features Register [HEX]
>        SC = Sector Count Register [HEX]
>        SN = Sector Number Register [HEX]
>        CL = Cylinder Low Register [HEX]
>        CH = Cylinder High Register [HEX]
>        DH = Device/Head Register [HEX]
>        DC = Device Command Register [HEX]
>        ER = Error register [HEX]
>        ST = Status register [HEX]
> Powered_Up_Time is measured from power on, and printed as
> DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
> SS=sec, and sss=millisec. It "wraps" after 49.710 days.
>
> Error 1 occurred at disk power-on lifetime: 6388 hours (266 days + 4 hours)
>  When the command that caused the error occurred, the device was active or idle.
>
>  After command completion occurred, registers were:
>  ER ST SC SN CL CH DH
>  -- -- -- -- -- -- --
>  84 51 00 00 00 00 a0
>
>  Commands leading to the command that caused the error were:
>  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
>  -- -- -- -- -- -- -- --  ----------------  --------------------
>  ec 00 00 00 00 00 a0 08   6d+23:19:44.200  IDENTIFY DEVICE
>  25 00 01 01 00 00 00 04   6d+23:19:44.000  READ DMA EXT
>  25 00 80 be 1b ba ef ff   6d+23:19:42.500  READ DMA EXT
>  25 00 c0 7f 1b ba e0 08   6d+23:19:42.500  READ DMA EXT
>  25 00 40 3f 1b ba e0 08   6d+23:19:30.300  READ DMA EXT
>
>
>
> As for RAID6, well this array started off as a 3 disk RAID5, and then got incrementally grown as capacity needs grew.  I wasn't going to go beyond 7 disks in the raid set, but since you can't reshape raid5 into raid6, and so I would have another few TB of disk available to move the raid set data to.  Since I use XFS, I can't just move off data and then shrink the filesystem to minimize the needs.  md and XFS make it easy to add disks, but very hard to remove them.  :-(
>
> It looks like my best bet is to try and get sd1g back into the raid set somehow, but I don't understand why md isn't assembling it into the set.  Should I try and clone sdo1 to a new disk, or sdg1?  But I am not sure what help that would be if md won't assemble with it.
>
> thx
> mike

As far as re-assembling the array, I would wait for Neil or someone who has
done this a few times but you need to find out why disks are giving I/O errors.

If you run:

dd if=/dev/sda of=/dev/null bs=1M &
dd if=/dev/sdb of=/dev/null bs=1M &

for each disk, can you do that for all disks in the raid array and then
see if any errors occur?  if you flood your system with that much I/O and
it doesnt have any problems I'd say you're good to go, but if you run those
commands and background them/run them simultaenously and drives start dropping
left and right, I'd wonder about the backplane myself..

Justin.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      
