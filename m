From: Hank Barta <hbarta@gmail.com>
Subject: Re: RAID for USB flash drives
Date: Fri, 14 Jan 2011 17:25:29 -0600
Message-ID: <AANLkTi=cOHgdradDDOFTdZ_xOGMXv8qf_n6xxppGA12y@mail.gmail.com>
References: <AANLkTi=kcbanFit5x27ccS_1RChxC=Dn+Hs4Ak+FbKsX@mail.gmail.com>
	<4D237E70.6030104@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D237E70.6030104@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 4, 2011 at 2:09 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:

>
> First up, booting. You'll have to boot off a bare device which may in fact
> be a mirror over 2 or more sticks. Make that your first partition. I think
> it's simpler to make it over all 4. Look up booting from RAID to find out
> how.

I should have read this more carefully. I performed a full install to
a raid0 only to find it incapable of setting up grub. It simply told
me there was a fatal error. :-/ It took me a bit more research before
the reality of your comment sunk in. So I proceeded again and tried to
use the first 100MB of each stick to create a 4 device raid1. For some
reason, the partitioning S/W (Ubuntu 10.04.1 server) didn't like that
and just hung when it tried to discover the disks. Repeatedly. I
finally worked around that by deleting the 100 MB partitions on three
of the four drives and just using the first 100 MB on one of the
drives for a /boot partition. I completed the installation but the
system hung on boot. It just provides a blank screen. Experimenting
with the installation USB drive, it seemed to me that I couldn't even
boot that with all five thumb drives installed. I scaled back to
installation three USB drives, install media on a fourth. I also
figured out which slot I needed to put the install media in so as to
boot. The BIOS - or perhaps some stage in the boot process - gets
confused otherwise.

I've booted a live CD and tried running grub-install from a chroot
with the /boot and / file systems and the command concluded w/out any
errors or warnings. But the system still will not boot. I'm not sure
if this is a grub or a RAID problem or some combination.

Is there something I need to include with grub when the root file
system is on a RAID0?

> Then, as far as I know USB flash sticks have lousy or no wear-levelling
> algorithms and use cheap flash which may not have very many write cycles, so
> given that, I'd either:

Time will tell. I plan to move active directories like /var/log and
/tmp to tmpfs to reduce writes to the USB sticks. The ones I got,
though inexpensive, are from a reputable manufacturer (Mushkin.)
Hopefully they have decent wear leveling. Certainly my benchmarks
produced irregular results which I suspect were a result of wear
leveling delaying writes.


>
> 1. Use RAID-1, 5 or 10 for the rest of the system with ext4 as you suggest,
>
> or 2. Use btrfs for the rest of the system - btrfs is included in Ubuntu
> 10.10 but you may be able to get it for 10.04.
>
> And in either case, make sure there are regular backups of the whole lot to
> your main disc-based array, because those $7 USB sticks could still give you
> problems.

Well... As long as I have the install media and capture any
customization to backup I should be OK.

>
> Or 3. I might just decide to use just one stick to boot the system from (as
> a /boot) and put the rest of the system in an LVM LV, or even a file, on the
> main array, and make sure I had a second stick to start the system from if
> the first one went bad.

I could do something like that. However I don't care to mess with the
main array (the two spinning drives) as recovery of those takes a
while.

I could just install to a single USB (no RAID) and try to migrate the
/ to a RAID once I'm off the install media. I could run from the
single stick (as Steven Haigh) suggested, but I'd like to take
advantage of the speed gains from a RAID0.

I could also use 'debirf' as suggested by Iordan Iordanov, but I
prefer to retain the full (disk based) environment with ease of
installing and updating S/W. I haven't studied debirf but I suspect I
would have to create and install a new image any time I want to update
or install new packages.

Suggestions on how to solve the boot problem would be welcome!

thanks,
hank

-- 
'03 BMW F650CS - hers
'98 Dakar K12RS - "BABY K" grew up.
'93 R100R w/ Velorex 700 (MBD starts...)
'95 Miata - "OUR LC"
polish visor: apply squashed bugs, rinse, repeat
Beautiful Sunny Winfield, Illinois
