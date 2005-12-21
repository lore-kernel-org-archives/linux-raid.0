From: Andrew Burgess <aab@cichlid.com>
Subject: Re: hangs with 2.6.15-rc5
Date: Wed, 21 Dec 2005 09:10:43 -0800
Message-ID: <200512211710.jBLHAh2T027517@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>I'm seeing hard system lockups with 2.6.15-rc5 when trying to use a
>RAID-6 array as a PV for LVM2.

>I've got four SATA disks hanging off a Marvell 6081 controller.  The disks
>work great when I access them "raw" (without going through md or dm).
>Nice & fast & reliable.  The disks work great when used "raw" as PVs
>for an LVM2 setup.  And they work great when used in a RAID-6 array.

I've been unable to use either 2.6.14 or 2.6.15 due to bogus scsi errors, not
exactly what you see but you might try 2.6.13.4 which works flawlessly for me,
LVM using raid6 PV's, some of the raid6 devices use some raid1 components.

