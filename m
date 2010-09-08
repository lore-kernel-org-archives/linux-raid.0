From: "George Spelvin" <linux@horizon.com>
Subject: Re: RAID mismatches (and reporting thereof)
Date: 8 Sep 2010 08:35:49 -0400
Message-ID: <20100908123549.5867.qmail@science.horizon.com>
References: <4C875A25.5080301@seoss.co.uk>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C875A25.5080301@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux@horizon.com, tim@seoss.co.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Out of interest, what systems are you seeing mismatches on?  Most of the 
> ones I've seen are on LSI1068* SAS controllers (with SATA drives, but 
> not sure if that counts for anything, don't use many SAS drives) 
> including the Dell SAS5* and SAS6* series.  I suspect there are some 
> corner cases where they corrupt data on disk.  Should open a kernel.org 
> bug really, so that LSI can ignore the issue in public...

MS-7376 ("MSI K9A2 Platinum") motherboard, with 2500 MHz quad-core
Phenom & 8 GiB ECC DDR2.  There are 6 SATA ports, 4 on the SB600 and 2
on a Promise PDC42819:

00:14.1 IDE interface [0101]: ATI Technologies Inc SB600 IDE [1002:438c]
04:00.0 RAID bus controller [0104]: Promise Technology, Inc. PDC42819 [FastTrak TX2650/TX4650] [105a:3f20]

I used to have a different motherboard, with 3x SiI 3132 PCIe adapters:
01:00.0 Mass storage controller [0180]: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller [1095:3132] (rev 01)
02:00.0 Mass storage controller [0180]: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller [1095:3132] (rev 01)

The drives are all ST3400832AS, installed in a SuperMicro SC833 case's
hot-swap bays.

I have a clone machine (same MB, CPU, and RAM, but different case and
ST3750330AS drives) that's giving me no problems.  Thus the recent
decision to swap drives and rebuild the array.
