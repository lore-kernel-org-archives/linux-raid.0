From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: Swap on RAID1?
Date: Mon, 13 Oct 2003 19:05:17 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031013230517.GV1305@mea-ext.zmailer.org>
References: <200310140012.33121.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200310140012.33121.dusty@strike.wu-wien.ac.at>
To: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Oct 14, 2003 at 12:12:33AM +0200, Hermann Himmelbauer wrote:
> Hi,
> I am considering putting my Swap on a RAID1.
> 
> I am aware that using 2 seperate Swap-Spaces without RAID would
> probably speed things up as Linux distributes the swap.

Actually the swap-out will be slightly SLOWER, than without RAID-1.

However I do use RAID-1 setup extensively in my machines even with
this slow-down of writing to disks (must write to two disks!).
I want to have the added RELIABILITY benefit.

> But what happens if a disk fails and the swap is on this disk?
> I assume Linux would crash? Wouldn't a swap on a RAID prevent
> such a crash?

You will see messages telling that MDnn carrying your swap has
failed to write to one of the disks, and is now running in
degraded mode.  The system will continue to function just fine.
(Until your last RAID-1 sub-disk fails ...)

Actually I tested that "fail a disk -> observe RAID-1 manage it"
just the other day at one machine I am builting presently.

As important as having runtime reliability, I consider bootup
reliability.  Standard bios bootup picks up a disk (or fails),
which can suck major way.

On a hunch (reading kernel driver sources) I did buy HighPoint
RocketRaid card (RR-1520 to be precise), which actually is
_software_raid_, e.g. it is simple two channel Serial-ATA
interface, but with BIOS understanding its own RAID-labels,
and knowing which disks form my bootable RAID-1.

The HighPoint allows machine to boot with degraded disks,
however it does that by demanding operator intervention,
which I am not entirely happy with when considering
systems running at remote sites doing their things...
(Compare with Sun SPARCs booting autonomously.)

Oh yes.  I didn't use HPTRAID as it is in 2.4.22 kernel,
as that doesn't have code to handle disk offlineness.
I allocated lowest cylinder for HPT BIOS raid label
(actually that is mere 512 byte block, not needing
a megabyte or whatever my "cylinder" became), and
then placed usual auto-detect RAID (partition type FD)
slices on the rest of the disk, bound slices in between
two disks with RAID-1 to become my /boot, swap, and root.

> 		Best Regards,
> 		Hermann
> -- 
> x1@aon.at

/Matti Aarnio
