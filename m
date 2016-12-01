From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Help: RAID5 - Disk failure during upgrade
Date: Thu, 1 Dec 2016 18:32:00 +0000
Message-ID: <58406CA0.4070305@youngman.org.uk>
References: <CAPqb7wrkYKVMKoje7rpZmhd+3BFautqmhugFTbMvsuHxVoazSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPqb7wrkYKVMKoje7rpZmhd+3BFautqmhugFTbMvsuHxVoazSA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Thomas_B=c3=bcschgens?= <sledge@seconet.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/11/16 22:22, Thomas Büschgens wrote:
> Hi there,
> 
> 
> kind of "cry for help" mail to the list.
> 
> 
> I am running a Thecus N7510 NAS with 7 * 4TB diskd (Western Digital)
> in a RAID5 setup. This config was running "smoothly" for about 3 years
> now. Couple of days ago I decided to upgrade to 8TB disks instead.
> 
What sort of WD disk? Reds?
> 
> Following the recommended Thecus procedure I did the following:
> 
> 
> 1. Check SMART on all disks. Fine
> 2. Pull Disk No. 1
> 3. Re-assemble HD-Case with new 8TB disk
> 4. Put new Disk into slot 1
> 
> 
> So far, so good. The array immediatly started the rebuild... and a
> couple of minutes later disk No. 5 failed.
> 
> 
> Hiere the excerpt from the Thecus log:
> 
> 2016-11-28 23:13:09 [N7510] : User admin logged in from 192.168.7.29
> 2016-11-28 22:30:36 [N7510] : The RAID [RAID] on system [N7510] change
> to degrade mode.
> 2016-11-28 22:29:57 [N7510] : Disk 5 on [N7510] has failed.
> 2016-11-28 22:29:56 [N7510] : Disk 5 on [N7510] has failed.
> 2016-11-28 22:29:56 [N7510] : Disk 5 on [N7510] has failed.
> 2016-11-28 22:23:52 [N7510] : The RAID [RAID] on system [N7510] is
> recovering the RAID and rebuilding is in progress.
> 2016-11-28 22:23:43 [N7510] : Disk 1 on [N7510] has been added.
> 2016-11-28 22:17:06 [N7510] : The RAID [RAID] on system [N7510] change
> to degrade mode.
> 2016-11-28 22:17:05 [N7510] : Disk 1 on [N7510] has been removed.
> 
> 
> Disk No. 5 is now marked as a potential spare. The output from "mdadm
> --examine" is attached to the email.
> 
> 
> My basic question is the following: How to proceed.
> 
> 
> Currently I am considering the following options:
> 
> 
> 1. Change back to Disk No. 1 (4TB) - the original one. The disk was
> running smoothly when I changed it

Has the array been "live" while you've been upgrading it - in other
words has the data on it been updated? That'll put a spanner in the
works for this option.

> 2. Option No. 1 - but shutting the system down while doing this
> 3. Pull/Plug Disk No. 5 and see what happens
> 4. Reboot?
> 
Two disks out? The array won't come back after a reboot :-( I notice
however that mdadm says you still have 6 drives, so something doesn't
add up ... 7 drives, no 1 has been removed, no 5 has failed, 6 left???
> 
> I don't think this is a Thecus specific question - rather a
> mdraid-related issue - in terms of finding the correct procedure.
> 
> 
> Any advice / guidance will be appreciated. In case someone needs more
> detailed information I am happy to provide this.
> 
Does the array have space to slot an 8th drive in? Pulling a drive and
putting a replacement in does NOT sound sensible to me - for exactly
this reason! It kills redundancy while the array rebuilds :-(

I'll step back and let the experts tell you how to recover the array (if
you haven't modified the data, sticking the old drive 1 back in should
work), but once you've done that, if you can cope with the downtime I'd
dd the old drives to the new ones, then expand the partitions and raid
after the fact.

Or better, if you can add an eighth disk to the running array, move them
across one by one with an "mdadm --replace". You might need a new mdadm
for that, but it's a LOT safer!
> 
> Thx,
> 
> 
> Tom
> 
Cheers,
Wol
