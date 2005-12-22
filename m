From: Andrew Burgess <aab@cichlid.com>
Subject: Re: hangs with 2.6.15-rc5
Date: Thu, 22 Dec 2005 09:03:49 -0800
Message-ID: <200512221703.jBMH3no6012641@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>Andrew Burgess <aab@cichlid.com> wrote:
>> >I'm seeing hard system lockups with 2.6.15-rc5 when trying to use a
>> >RAID-6 array as a PV for LVM2.
>> 
>> >I've got four SATA disks hanging off a Marvell 6081 controller.  The disks
>> >work great when I access them "raw" (without going through md or dm).
>> >Nice & fast & reliable.  The disks work great when used "raw" as PVs
>> >for an LVM2 setup.  And they work great when used in a RAID-6 array.
>> 
>> I've been unable to use either 2.6.14 or 2.6.15 due to bogus scsi errors, not
>> exactly what you see but you might try 2.6.13.4 which works flawlessly for me,
>> LVM using raid6 PV's, some of the raid6 devices use some raid1 components.

>Are you using a Marvell controller?  Do you have MSI enabled by any
>chance?  I had to disable MSI to get it to communicate reliably.

Sorry I should have said. I have 4 3ware controllers, 2 sata, 2 pata...

