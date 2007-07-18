From: Neil Brown <neilb@suse.de>
Subject: Re: how to deal with continuously getting more errors?
Date: Thu, 19 Jul 2007 09:23:15 +1000
Message-ID: <18078.41187.752326.634975@notabene.brown>
References: <98d279bf0707141115m14308e64s50f6517b2e1aef5c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from jeff stern on Saturday July 14
Sender: linux-raid-owner@vger.kernel.org
To: jeff stern <jas.61803+lr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday July 14, jas.61803+lr@gmail.com wrote:
> 
> EXTENDED DESCRIPTION OF PROBLEM
> 
> i first noticed this problem when i downloaded the fedora core 7 .iso,
> and did a checksum on it, and it didn't match. with a little more
> investigating, i found that i could make a copy of any large file on
> disk, and its copy would sometimes match, sometimes not.
> 
> here is a typical session:
> ------------------------------------------------------------------------------------------
> $ cp F-7-i386-DVD.iso F.iso
> $ cmp F-7-i386-DVD.iso F.iso
> F-7-i386-DVD.iso F.iso differ: byte 1033827385, line 3789612
> $ cmp F-7-i386-DVD.iso F.iso
> $ cmp F-7-i386-DVD.iso F.iso
> F-7-i386-DVD.iso F.iso differ: byte 1033827385, line 3789612
> $ cmp F-7-i386-DVD.iso F.iso
> F-7-i386-DVD.iso F.iso differ: byte 8870221, line 37265
> $ cmp F-7-i386-DVD.iso F.iso
> F-7-i386-DVD.iso F.iso differ: byte 8870221, line 37265
> $ _
> ------------------------------------------------------------------------------------------

This clearly indicates a hardware problem.
You tried in /tmp and didn't get this sort of result, so it probably
isn't RAM/CPU.
Next step is to break the raid1, mount each drive as a separate
filesystem and do the same test on each filesystem.
If one works and the other fails, then it must be something specific
to the faulty device.  If they are on the same controller, it must be
drive or cable, so swap cables and try again.
If they are on different controllers, try swapping controllers too.

If both filesystems show the same problem, it must be something
common, maybe the controller.  Try to find an alternate controller to
test with.  Narrow it down to the faulty component, and replace it.

> 
> 
> furthermore, i discovered that there was a way to fix them (i.e.,
> "sync" the drives). however, this fixing procedure came with a caveat.
>  this caveat was something that i should have realized the importance
> of in the first place: that a RAID 1 system with only two drives is
> going to have a problem when repairing. the problem is that when
> sync'ing the drives, whenever a mismatch is found, a decision must be
> made as to which drive has the correct data: drive 1 or drive 2? and
> that apparently, it's just a toss-up, and the repair program just
> picks randomly.
> 
> "WHAAAAT????????????"
> 
> yeap. so, it's really better to either go with RAID 5, or to have a
> RAID 1 system with 3 or more disks.
> 
This is not true at all.
If the difference is due to the drive subsystem returning bad data
(rather than indicating a read error), then no RAID system is safe.
If the difference is due to the kernel writing different data to the
two drives (as happens sometimes on swap or with memory-mapped files),
then both copies of the data are equally correct, and there isn't
really a problem.

NeilBrown
