From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Fri, 2 Jan 2009 13:37:53 -0800 (PST)
Message-ID: <972681.54986.qm@web30808.mail.mud.yahoo.com>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan> <467705.96388.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan> <344038.60917.qm@web30808.mail.mud.yahoo.com> <alpine.DEB.1.10.0901020708210.3858@p34.internal.lan> <17665.11566.qm@web30804.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021319330.26159@p34.internal.lan> <746863.34803.qm@web30803.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021355370.3485@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

BTW, here is the smart error listing for one of the devices that md seems to refuse to add:

 smartctl -l error  /dev/sdb1
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


It looks like a good disk.

thx
mike




----- Original Message ----
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org; john lists <john4lists@gmail.com>
Sent: Friday, January 2, 2009 10:57:13 AM
Subject: Re: Need urgent help in fixing raid5 array



On Fri, 2 Jan 2009, Mike Myers wrote:

> Well, I can read from sdg1 just fine.  It seems to work ok, at least for a few GB of data.   I'll try this on some of the other disks, but it is possible for to pull the disks out of the backplane and run the SFF-8087 fanout cables direct to each drive and bypass the backplane completely.  It certainly would be easy to do this for the at least the sdo1 drive and see if I can get better results going direct to the disk.  I have moved the disks around the backplane a bit to deal with the issues of the controller failure, so I am pretty sure it's not just one bad slot or the like.
> 
> So you've seen a backplane fail in away that the disks come up fine at boot but have corrupted data transfers across them?  I wonder about the sata cables in that case as well.  I could hook up a pair of PMP's to my SI3132's and bypass the 8077 cables as well.

1. Try by-passing the backplane.
2. Bad cables will usually cause smart identifier UDMA_CRC_Error_Count to
   increase quite high, if it is 0 or close to it, the cable is unlikely the
   issue.
3. I have seem all kinds of weirdness with bad backplanes, drives dropping out
   of the array, drives producing I/O errors, etc.

Justin.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      
