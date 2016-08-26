From: travis@subspacefield.org
Subject: Re: bootsect replicated in p1, RAID enclosure suggestions?
Date: Thu, 25 Aug 2016 19:50:12 -0700
Message-ID: <20160826025012.GO32250@subspacefield.org>
References: <20160823050947.GL32250@subspacefield.org>
 <CAJCQCtSY=D-ASQ22km8GJjfju4jUgJSOBTAH5+XveCZq1BvT7w@mail.gmail.com>
 <20160825062501.GN32250@subspacefield.org>
 <CAJCQCtSWOwf6pHD2O7CtaNwF4BDbHO+hh7XrXpcaRsqPkvmFrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJCQCtSWOwf6pHD2O7CtaNwF4BDbHO+hh7XrXpcaRsqPkvmFrQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 25, 2016 at 04:32:12PM -0600, Chris Murphy wrote:
> that's not good, but not unfixable. The mdadm super block starts at
> LBA 8, 4096 bytes from the start of that partition, so it's safe to
> zero the first 4096 bytes. The GPT is mainly in the first three
> sectors so you could just write zeros for a count of 3, although it is
> more complete to zero with a count=8, for the partition, not the whole
> device.

Useful info, thanks.

> Looks like the mdadm super block might have been stepped on by
> something. You'd need to look for some evidence of it using something
> like
> 
> dd if=/dev/sdf1 count=9 2>/dev/null | hexdump -C
> 
> If it's intact it should be at offset x1000 and again just a matter of
> wiping the first 8 sectors, again of the partition, not the whole
> device.

> > Sadly, I can't do a mdadm -D because I can't assemble the RAID.
> > $ sudo mdadm -E /dev/md127
> 
> Again, wrong command, you should use -D for this.

# mdadm -D /dev/md127 
mdadm: md device /dev/md127 does not appear to be active.

> This is not a bug report. There's no reproduce steps, there's no
> evidence of a bug. I'm not experiencing random replacement of mdadm
> superblock data with MBR and GPT signatures.

I realize it's not terribly actionable.  But enough circumstantial
evidence from enough people and one starts looking for things which
can exhibit that behavior.

> That's not really what
> I'd expect of drive or enclosure firmware which by design should be
> partition agnostic, as there's more than one or two valid kinds of
> partitioning. Plus, it'd be scary even if it picked the right one, it
> could clobber a legitimate existing one.

I've had some weird shit, but you're right that it's odd that it'd
write a partition table out to /dev/sdd1 instead of /dev/sdd, that
almost sounds like something that would require the OS to get
involved, to get that offset confused.

> So I'd say it's something else.

Do you have any idea what that could be?  I haven't logged into this
box in months, and nobody else has either.  If it's not USB or drive
firmware, I'm fresh out of ideas.  Repartitioning disks isn't exactly
something most stuff does automatically and without prompting, as it's
pretty dangerous.

> In every case I've seen, it was user error. I haven't heard of things
> putting GPTs in partitions, and in a sense I'd say it's a bug if any
> utility lets a user do that. Nesting GPT's in partitions, bad idea,
> although it *should* be innocuous because it shouldn't be seen/honored
> by anything that doesn't go looking for it because it doesn't belong
> there.

That's entirely possible.  When I had this problem the _first_ few times
I assumed it was the fact I was using raw disks and not partitioned disks.
I had a very similar problem, where something would wipe out the mdlabel,
but only on the last two drives of the array.

In fact, I decided to grep around for /dev/sdd1 and /dev/sde1 which seem
to get trounced (but not /dev/sd[bc]1) and what do you know:

# grep -R /dev/sde1 /etc/
/etc/lvm/cache/.cache:          "/dev/sde1",

That certainly looks promising.  I wonder if you just solved my problem
without hardware upgrade.

> > I've certainly encountered this "GPT outside cylinder 0" on these two
> > drives before,
> 
> Keep in mind cylinders are gone, they don't exist anymore. Drives all
> speak in LBAs now. *shrug* The GPT typically involves LBAs 0, 1 and 2
> at least, more if there are more than 4 partitions.

Shorthand for "before partition 1".

> I don't recognize the above stuff, so I'm not sure what it is. I'd
> usually expect it to be zeros if it's not a boot drive.

It was used as a raw disk in an encrypted RAID before.

> OK it does in fact have a PMBR and GPT in the 1st and 2nd sector of
> this partition. Pretty weird how it got there. There is a UUID
> starting at offset 0x238 so you can look around and see if anything
> else has that UUID or if that UUID ever changed or comes back after
> you fix this. If it's not the same UUID, something is creating it with
> a random UUID each time, which would mean it's not just being copied
> from somewhere.

Got it.  Good idea.

> We kinda expect sdd to have a valid PMBR and GPT though... so that's
> sane. I just don't know what to make of the stuff in LBA 0 before the
> PMBR.

It's just random fill from a previous incarnation.

> It is common. I prefer gdisk, which has a nomenclature similar to
> fdisk. The nomenclature of parted is confusing.

I think somewhere in learning parted and repartitioning all the disks,
I managed to type /dev/sdX1 instead of /dev/sdX when creating the
partitions.

> FWIW it's probably a lot simpler layout if you wanted to do either
> linear or raid0, to just blow away all four drives with hdparm and ATA
> security erase to get rid of all signatures; and then make all of them
> into LVM physical volumes without any partitioning first, and then
> make a logical volume, which by default is linear/concat, or you can
> choose to use raid0 (this is a per logical volume characteristic), and
> then encrypt the LV, and then format the LUKS volume. There's no
> advantage to adding either partitions or mdadm RAIDs if you're going
> to use LVM anyway and this is a Linux only storage enclosure.

Good call, reduces the diversity of layers in the stack too.  Thanks.
-- 
http://www.subspacefield.org/~travis/ | if spammer then john@subspacefield.org
"Computer crime, the glamor crime of the 1970s, will become in the
1980s one of the greatest sources of preventable business loss."
John M. Carroll, "Computer Security", first edition cover flap, 1977
