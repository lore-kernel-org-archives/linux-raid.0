From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 20 Oct 2007 22:24:12 +0400
Message-ID: <471A47CC.1070508@msgid.tls.msk.ru>
References: <18200.49267.763509.924873@stoffel.org>	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	<18200.53593.687483.120827@stoffel.org>	<1192810534.1666.68.camel@firewall.xsintricity.com>	<471A0C02.4030407@msgid.tls.msk.ru> <18202.5687.672431.295590@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18202.5687.672431.295590@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Doug Ledford <dledford@redhat.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Stoffel wrote:
>>>>>> "Michael" == Michael Tokarev <mjt@tls.msk.ru> writes:
[]
> Michael> Well, I strongly, completely disagree.  You described a
> Michael> real-world situation, and that's unfortunate, BUT: for at
> Michael> least raid1, there ARE cases, pretty valid ones, when one
> Michael> NEEDS to mount the filesystem without bringing up raid.
> Michael> Raid1 allows that.
> 
> Please describe one such case please.  There have certainly been hacks
> of various RAID systems on other OSes such as Solaris where the VxVM
> and/or Solstice DiskSuite allowed you to encapsulate an existing
> partition into a RAID array.  
> 
> But in my experience (and I'm a professional sysadm... :-) it's not
> really all that useful, and can lead to problems liks those described
> by Doug.  

I'm doing a sysadmin work for about 15 or 20 years.

> If you are going to mirror an existing filesystem, then by definition
> you have a second disk or partition available for the purpose.  So you
> would merely setup the new RAID1, in degraded mode, using the new
> partition as the base.  Then you copy the data over to the new RAID1
> device, change your boot setup, and reboot.
[...]

And you have to copy the data twice as a result, instead of copying
it only once to the second disk.

> As Doug says, and I agree strongly, you DO NOT want to have the
> possibility of confusion and data loss, especially on bootup.  And

There are different point of views, and different settings etc.
For example, I once dealt with a linux user who was unable to
use his disk partition, because his system (it was RedHat if I
remember correctly) recognized some LVM volume on his disk (it
was previously used with Windows) and tried to automatically
activate it, thus making it "busy".  What I'm talking about here
is that any automatic activation of anything should be done with
extreme care, using smart logic in the startup scripts if at
all.

The Doug's example - in my opinion anyway - shows wrong tools
or bad logic in the startup sequence, not a general flaw in
superblock location.

Another example is ext[234]fs - it does not touch first 512
bytes of the device, so if there was an msdos filesystem there
before, it will be recognized as such by many tools, and an
attempt to mount it automatically will lead to at least scary
output and nothing mounted, or in fsck doing fatal things to
it in worst scenario.  Sure thing the first 512 bytes should
be just cleared.. but that's another topic.

Speaking of cases where it was really helpful to have an ability
to mount individual raid components directly without the raid
level - most of them was due to one or another operator errors,
usually together with bugs and/or omissions in software.  I don't
remember exact scenarious anymore (last time it was more than 2
years ago).  Most of the time it was one or another sort of
system recovery.

In almost all machines I maintain, there's a raid1 for the root
filesystem built of all the drives (be it 2 or 4 or even 6 of
them) - the key point is to be able to boot off any of them
in case some cable/drive/controller rearrangement has to be
done.  Root filesystem is quite small (256 or 512 Mb here),
and it's not too dynamic either -- so it's not a big deal to
waste space for it.

Problem occurs - obviously - when something goes wrong.
And most of the time issues we had happened on a remote site,
where there was no expirienced operator/sysadmin handy.

For example, when one drive was almost dead, and mdadm tried
to bring the array up, machine just hanged for unknown amount
of time.  An unexpirienced operator was there.  Instead of
trying to teach him how to pass parameter to the initramfs
to stop trying to assemble root array and next assembling
it manually, I told him to pass "root=/dev/sda1" to the
kernel.  Root mounts read-only, so it should be a safe thing
to do - I only needed root fs and minimal set of services
(which are even in initramfs) just for it to boot up to SOME
state where I can log in remotely and fix things later.
(no I didn't want to remove the drive yet, I wanted to
examine it first, and it turned to be a good idea because
the hang was happening only at the beginning of it, and
while we tried to install replacement and fill it up with
data, there was an unreadable sector found on another
drive, so this old but not removed drive was really handy).

Another situation - after some weird crash I had to examine
the filesystems found on both components - I want to look
at the filesystems and compare them, WITHOUT messing up
with raid superblocks (later on I wrote a tiny program to
save/restore 0.90 superblocks), and without attempting a
reconstruction attempts.  In fact, this very case - examining
the contents - is something I've been doing many times for
one or another reason.  There's just no need to involve
raid layer here at all, but it doesn't disturb things either
(in some cases anyway).

Yet another - many times we had to copy an old system to
a new one - new machine boots with 3 drives in it, 2 new,
and 3rd (the boot one) from the old machine.  I boot it off
the non-raided config from the 3rd drive (using only the
halves of md devices), create new arrays on the 2 new
drives (note - had I started raid on the 3rd machine, there'd
be a problem with md device numbering, -- for consistency I
number all the partitions and raid arrays similarily on all
machines), and copy data over.  There's no need to do the
complex procedure of adding components to the existing raid
arrays, dropping the old drive from them and resizing the
stuff - because of the latter step (and because there's no
need to resync in the first place - the 2 new drives are
new, hence I use --no-resync because they're filled with
zeros anyway).

Another case - we had to copy large amount of data from one
machine to another, from a raid array.  I just pulled off the
disk (bitmaps=yes, and i remounted the filesystem readonly),
inserted it into another machine, mounted it - without raid -
here and did a copy.  Superblock was preserved, and when I
returned the drive back, everything was ok.

And so on.  There was countless number of cases like that,
something I forgot already too.

Well.  I know about a loop device which has "offset=XXX" parameter,
so one can actually see and use the "internals" component of a
raid1 array, even if the superblock is at the beginning.  But
see above, the very first case - go tell to that operator how
to do it all ;)

> this leads to the heart of my initial post on this matter, that the
> confusion of having four different variations of RAID superblocks is
> bad.  We should deprecate them down to just two, the old 0.90 format,
> and the new 1.x format at the start of the RAID volume.

It's confusing for sure.  But see: 0.90 format is the most commonly used
one, and the most important is that it's historical - it was here for
many years, many systems are using it.  I don't want to come across
a situation when, some years later, I'll need to grab a data from my
old disk and be unable to, because 0.90 format isn't supported anymore.

0.90 has some real limitations (like 26 components at max etc), hence
1.x format appeared.  And various flavours of 1.x format are all useful
too.  For example, if you're concerned about safety of your data due to
defects(*) in your startup scripts, -- use whatever 1.x format which puts
the metadata at the beginning.  That's just it, I think ;)

/mjt

(*) Note: software like libvolume-id (part of udev) is able to recognize
parts of raid 0.90 arrays just fine.
