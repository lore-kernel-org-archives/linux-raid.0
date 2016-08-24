From: Chris Murphy <lists@colorremedies.com>
Subject: Re: bootsect replicated in p1, RAID enclosure suggestions?
Date: Wed, 24 Aug 2016 11:15:58 -0600
Message-ID: <CAJCQCtSY=D-ASQ22km8GJjfju4jUgJSOBTAH5+XveCZq1BvT7w@mail.gmail.com>
References: <20160823050947.GL32250@subspacefield.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160823050947.GL32250@subspacefield.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 22, 2016 at 11:09 PM,
<travis+ml-linux-raid@subspacefield.org> wrote:
> Hello all,
>
> So I have an Intel NUC (for low power Linux) plugged via USB into a 4
> bay enclosure doing linear (yeah I know; it's the backup server, the
> primary is raid10).
>
> And every once in a while, this happens (*see end).  The partition 1
> that would normally contain a MD slice ends up being a replica of the
> boot cylinder.  I can't tell if it's the mdraid linear impl, the
> kernel doing something weird, the USB drivers, the enclosure firmware,
> or what.

OK well you don't tell us what the mdadm create command was, there's
no information on the metadata version, no mdadm -E or -D output, etc.
There's really nothing to go on here. So we can't tell what the
problem is either, or what your question is.

>
> Anyway, this happened while I was restoring a Windows machine whose
> root drive suddenly took a nosedive, and it happens every 6 months
> or so.  Today it happened while I was in the middle of recovering
> a Windows machine whose 1TB SSD threw up on C: and totally nuked
> the data.

OK? I don't follow this at all, how it relates to the NUC, how it
relates to the USB drives connected to the NUC.


>
> The last low-power option I tried was an OpenRD Ultimate based around
> ARMv5TE which was basically unsupported by debian by the time I got
> it, and subsequently became ultra-flaky due to what seemed to be RAM
> problems - it was crashing every 3 days with kernel panics, and every
> once in a while would do something worse.

This is definitely superfluous information that just clutters the thread...



> Any recommendations on a low power hardware with a well-supported
> distro, that matches up well with a real backplane and SATA
> connections instead of USB.  The only caveat is that I want to encrypt
> raw disks and it has to not be very noisy - so no rackmount gear
> with 65dB 1" dog whistle fans.  Obviously, whatever backplane must
> be well-supported by the distro.

OK so you just want to give up on the existing setup and you want
advice on a whole new setup? From my perspective you're basically on
three separate threads at this point.


>
> Also, does anyone have experience with cryptsetup on multiple
> partitions?  I can do that but get prompted multiple times and I was
> wondering if anyone knew an easy way to fix the boot time scripts to
> avoid that, only prompting once per unique underlying crypttab.

And now you're on your fourth subject for an entirely new thread that
also has nothing to do with this list. This is probably a distribution
question. On the distribution I use, the thing that prompts for a
passphrase tries that passphrase on all cryptluks devices, so in the
event they share the same passphrase, they're all opened just by
entering the passphrase one time. If the passphrase is entered
incorrectly, now I'm stuck and have to enter the passphrase per LUKS
instance.


>
> And finally, I have a story about buggy drive firmware that you
> might enjoy, especially if you were doing this sort of stuff in
> the 90s as well.  Cheers:

OK...fifth subject and thread.



> # parted /dev/sde
> GNU Parted 2.3

I would start out by using a non-ancient version of parted. This is 6 years old.


> Using /dev/sde
> Welcome to GNU Parted! Type 'help' to view a list of commands.
> (parted) p
> Model: WDC WD40 EFRX-68WT0N0 (scsi)
> Disk /dev/sde: 4001GB
> Sector size (logical/physical): 512B/512B

It's a WDC Red with a physical sector size of 4096B, so it looks like
the USB enclosure is doing the typical thing of masking the try
physical sector size from the kernel. This is better than the opposite
where the enclosure reports the drive as 4096B/4096B logical/physical,
where the drive itself has 512B logical sectors, as this will cause
problems if the drive is ever removed from that enclosure, or put into
one that doesn't report 4096B logical sectors.


> Partition Table: gpt
>
> Number  Start   End     Size    File system  Name        Flags
>  1      1049kB  4001GB  4001GB               Linux RAID  raid
>
> (parted) q
> # parted /dev/sdd1
> GNU Parted 2.3
> Using /dev/sdd1
> Welcome to GNU Parted! Type 'help' to view a list of commands.
> (parted) p
> Model: Unknown (unknown)
> Disk /dev/sdd1: 4001GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
>
> Number  Start   End     Size    File system  Name        Flags
>  1      1049kB  4001GB  4001GB               Linux RAID  raid


It's purely speculation, but it sounds like to me in the history of
one or more drives, the previous signatures weren't removed before the
drive was retasked for its new purpose. That's the folly of not wiping
the signatures in the reverse order they were created, and just
expecting that starting over will wipe those old signatures.

But I think there is a legitimate gripe that parted probably should
not operate on partitions like this. It's not valid to have nested
GPTs like this. And I have no idea if parted is showing you valid or
bogus information. You'd need to do something like:

dd if=/dev/sdd1 count=2 2>/dev/null | hexdump -C

And then we can see if there really is a PMBR and GPT in that first
sector that parted is picking up. But where it could be coming from in
an mdadm linear layout? No idea.

The other thing to check is the end of the partition, because GPT has
a primary and backup. So the 2nd to last sector of sdd1 may have a
backup GPT on it, and possibly something is wrongly restoring it
sometimes.

In any case I would still look to using something much much newer than
parted 2.3, it's basically Pleistocene old, and the version of mdadm
is also likewise old. But this is what happens with LTS releases,
ancient software for which no one except its maintainers remember the
state and history.


-- 
Chris Murphy
