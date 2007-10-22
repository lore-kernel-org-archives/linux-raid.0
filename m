From: "John Stoffel" <john@stoffel.org>
Subject: Re: Time to  deprecate old RAID formats?
Date: Mon, 22 Oct 2007 16:39:28 -0400
Message-ID: <18205.2688.952701.567195@stoffel.org>
References: <18200.49267.763509.924873@stoffel.org>
	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	<18200.53593.687483.120827@stoffel.org>
	<1192810534.1666.68.camel@firewall.xsintricity.com>
	<471A0C02.4030407@msgid.tls.msk.ru>
	<18202.5687.672431.295590@stoffel.org>
	<471A47CC.1070508@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471A47CC.1070508@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: John Stoffel <john@stoffel.org>, Doug Ledford <dledford@redhat.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


[ I was going to reply to this earlier, but the Red Sox and good
weather got into the way this weekend.  ;-]

>>>>> "Michael" == Michael Tokarev <mjt@tls.msk.ru> writes:

Michael> I'm doing a sysadmin work for about 15 or 20 years.

Welcome to the club!  It's a fun career, always something new to
learn. 

>> If you are going to mirror an existing filesystem, then by definition
>> you have a second disk or partition available for the purpose.  So you
>> would merely setup the new RAID1, in degraded mode, using the new
>> partition as the base.  Then you copy the data over to the new RAID1
>> device, change your boot setup, and reboot.

Michael> And you have to copy the data twice as a result, instead of
Michael> copying it only once to the second disk.

So?  Why is this such a big deal?  As I see it, there are two seperate
ways to setup a RAID1 setup, on an OS.

1.  The mirror is built ahead of time and you install onto the
    mirror.  And twice as much data gets written, half to each disk.
    *grin* 

2.  You are encapsulating an existing OS install and you need to do a
    reboot from the un-mirrored OS to the mirrored setup.  So yes, you
    do have to copy the data from the orig to the mirror, reboot, then
    resync back onto the original disk whish has been added into the the
    RAID set.  
	
Neither case is really that big a deal.  And with the RAID super block
at the front of the disk, you don't have to worry about mixing up
which disk is which.  It's not fun when you boot one disk, thinking
it's the RAID disk, but end up booting the original disk.  

>> As Doug says, and I agree strongly, you DO NOT want to have the
>> possibility of confusion and data loss, especially on bootup.  And

Michael> There are different point of views, and different settings
Michael> etc.  For example, I once dealt with a linux user who was
Michael> unable to use his disk partition, because his system (it was
Michael> RedHat if I remember correctly) recognized some LVM volume on
Michael> his disk (it was previously used with Windows) and tried to
Michael> automatically activate it, thus making it "busy".  What I'm
Michael> talking about here is that any automatic activation of
Michael> anything should be done with extreme care, using smart logic
Michael> in the startup scripts if at all.

Ah... but you can also de-active LVM partitions as well if you like.  

Michael> The Doug's example - in my opinion anyway - shows wrong tools
Michael> or bad logic in the startup sequence, not a general flaw in
Michael> superblock location.

I don't agree completely.  I think the superblock location is a key
issue, because if you have a superblock location which moves depending
the filesystem or LVM you use to look at the partition (or full disk)
then you need to be even more careful about how to poke at things.

This is really true when you use the full disk for the mirror, because
then you don't have the partition table to base some initial
guestimates on.  Since there is an explicit Linux RAID partition type,
as well as an explicit linux filesystem (filesystem is then decoded
from the first Nk of the partition), you have a modicum of safety.

If ext3 has the superblock in the first 4k of the disk, but you've
setup the disk to use RAID1 with the LVM superblock at the end of the
disk, you now need to be careful about how the disk is detected and
then mounted.

To the ext3 detection logic, it looks like an ext3 filesystem, to LVM,
it looks like a RAID partition.  Which is correct?  Which is wrong?
How do you tell programmatically?  

That's what I think that all superblocks should be in the SAME
location on the disk and/or partitions if used.  It keeps down
problems like this.  

Michael> Another example is ext[234]fs - it does not touch first 512
Michael> bytes of the device, so if there was an msdos filesystem
Michael> there before, it will be recognized as such by many tools,
Michael> and an attempt to mount it automatically will lead to at
Michael> least scary output and nothing mounted, or in fsck doing
Michael> fatal things to it in worst scenario.  Sure thing the first
Michael> 512 bytes should be just cleared.. but that's another topic.

I would argue that ext[234] should be clearing those 512 bytes.  Why
aren't they cleared  

Michael> Speaking of cases where it was really helpful to have an
Michael> ability to mount individual raid components directly without
Michael> the raid level - most of them was due to one or another
Michael> operator errors, usually together with bugs and/or omissions
Michael> in software.  I don't remember exact scenarious anymore (last
Michael> time it was more than 2 years ago).  Most of the time it was
Michael> one or another sort of system recovery.

In this case, you're only talking about RAID1 mirrors, no other RAID
configuration fits this scenario.  And while this might look to be
helpful, I would strongly argue that it's not, because it's a special
case of the RAID code and can lead to all kinds of bugs and problems
if it's not exercised properly. 

Michael> In almost all machines I maintain, there's a raid1 for the
Michael> root filesystem built of all the drives (be it 2 or 4 or even
Michael> 6 of them) - the key point is to be able to boot off any of
Michael> them in case some cable/drive/controller rearrangement has to
Michael> be done.  Root filesystem is quite small (256 or 512 Mb
Michael> here), and it's not too dynamic either -- so it's not a big
Michael> deal to waste space for it.

Sure, I agree.  I agree 100% here that mirroring your /root partition
across two or more disks is good.  

Michael> Problem occurs - obviously - when something goes wrong.  And
Michael> most of the time issues we had happened on a remote site,
Michael> where there was no expirienced operator/sysadmin handy.

That's why I like Rackable's RMM, I get full serial console access to
the BIOS and the system.  Very handy.  Or get a PC Weasel PCI card and
install it into such systems, or a remote KVM, etc.  If you have to
support remote systems, you need the infrastructure to properly
support it.  

Michael> For example, when one drive was almost dead, and mdadm tried
Michael> to bring the array up, machine just hanged for unknown amount
Michael> of time.  An unexpirienced operator was there.  Instead of
Michael> trying to teach him how to pass parameter to the initramfs to
Michael> stop trying to assemble root array and next assembling it
Michael> manually, I told him to pass "root=/dev/sda1" to the kernel.

I really don't like this, because you've now broken the RAID from the
underside and it's not clear which is the clean mirror half now.  

Michael> Root mounts read-only, so it should be a safe thing to do - I
Michael> only needed root fs and minimal set of services (which are
Michael> even in initramfs) just for it to boot up to SOME state where
Michael> I can log in remotely and fix things later.  (no I didn't
Michael> want to remove the drive yet, I wanted to examine it first,
Michael> and it turned to be a good idea because the hang was
Michael> happening only at the beginning of it, and while we tried to
Michael> install replacement and fill it up with data, there was an
Michael> unreadable sector found on another drive, so this old but not
Michael> removed drive was really handy).

Heh. I can see that but I honestly think this points back to a problem
LVM/MD have with failing disks, and that is they don't time out
properly when one half of the mirror is having problems.  

Michael> Another situation - after some weird crash I had to examine
Michael> the filesystems found on both components - I want to look
Michael> at the filesystems and compare them, WITHOUT messing up
Michael> with raid superblocks (later on I wrote a tiny program to
Michael> save/restore 0.90 superblocks), and without attempting a
Michael> reconstruction attempts.  In fact, this very case - examining
Michael> the contents - is something I've been doing many times for
Michael> one or another reason.  There's just no need to involve
Michael> raid layer here at all, but it doesn't disturb things either
Michael> (in some cases anyway).

This is where a netboot would be my preferred setup, or a LiveCD.
Booting off an OS half like this might seem like a good way to quickly
work around the problem, but I feel like you're breaking the
assumptions of the RAID setup and it's going to bite you worse one
day. 

Michael> Yet another - many times we had to copy an old system to
Michael> a new one - new machine boots with 3 drives in it, 2 new,
Michael> and 3rd (the boot one) from the old machine.  I boot it off
Michael> the non-raided config from the 3rd drive (using only the
Michael> halves of md devices), create new arrays on the 2 new
Michael> drives (note - had I started raid on the 3rd machine, there'd
Michael> be a problem with md device numbering, -- for consistency I
Michael> number all the partitions and raid arrays similarily on all
Michael> machines), and copy data over.  There's no need to do the
Michael> complex procedure of adding components to the existing raid
Michael> arrays, dropping the old drive from them and resizing the
Michael> stuff - because of the latter step (and because there's no
Michael> need to resync in the first place - the 2 new drives are
Michael> new, hence I use --no-resync because they're filled with
Michael> zeros anyway).

Michael> Another case - we had to copy large amount of data from one
Michael> machine to another, from a raid array.  I just pulled off the
Michael> disk (bitmaps=yes, and i remounted the filesystem readonly),
Michael> inserted it into another machine, mounted it - without raid -
Michael> here and did a copy.  Superblock was preserved, and when I
Michael> returned the drive back, everything was ok.

Michael> And so on.  There was countless number of cases like that,
Michael> something I forgot already too.

Michael> Well.  I know about a loop device which has "offset=XXX"
Michael> parameter, so one can actually see and use the "internals"
Michael> component of a raid1 array, even if the superblock is at the
Michael> beginning.  But see above, the very first case - go tell to
Michael> that operator how to do it all ;)

That's the real solution to me, using the loop device with an offset!
I keep forgetting about this too.  And I think it's a key thing. 

>> this leads to the heart of my initial post on this matter, that the
>> confusion of having four different variations of RAID superblocks is
>> bad.  We should deprecate them down to just two, the old 0.90 format,
>> and the new 1.x format at the start of the RAID volume.

Michael> It's confusing for sure.  But see: 0.90 format is the most
Michael> commonly used one, and the most important is that it's
Michael> historical - it was here for many years, many systems are
Michael> using it.  I don't want to come across a situation when, some
Michael> years later, I'll need to grab a data from my old disk and be
Michael> unable to, because 0.90 format isn't supported anymore.

I never said that we should drop *read* support for 0.90 format, I was
just suggesting that we make the 1.0 format with the superblock in the
first 4k of the partition be the default from now on.

Michael> 0.90 has some real limitations (like 26 components at max
Michael> etc), hence 1.x format appeared.  And various flavours of 1.x
Michael> format are all useful too.  For example, if you're concerned
Michael> about safety of your data due to defects(*) in your startup
Michael> scripts, -- use whatever 1.x format which puts the metadata
Michael> at the beginning.  That's just it, I think ;)

This should be the default in my mind, having the new RAID 1.x format
with the first 4k of the partition being the default and only version
of 1.x that's used going forward.  

Michael> (*) Note: software like libvolume-id (part of udev) is able
Michael> to recognize parts of raid 0.90 arrays just fine.


Michael> !DSPAM:471a4837229653661656215!
