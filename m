From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Time to  deprecate old RAID formats?
Date: Tue, 23 Oct 2007 02:29:24 +0400
Message-ID: <471D2444.90706@msgid.tls.msk.ru>
References: <18200.49267.763509.924873@stoffel.org>	<Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	<18200.53593.687483.120827@stoffel.org>	<1192810534.1666.68.camel@firewall.xsintricity.com>	<471A0C02.4030407@msgid.tls.msk.ru>	<18202.5687.672431.295590@stoffel.org>	<471A47CC.1070508@msgid.tls.msk.ru> <18205.2688.952701.567195@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18205.2688.952701.567195@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Doug Ledford <dledford@redhat.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Stoffel wrote:

>>>>>> "Michael" == Michael Tokarev <mjt@tls.msk.ru> writes:

>>> If you are going to mirror an existing filesystem, then by definition
>>> you have a second disk or partition available for the purpose.  So you
>>> would merely setup the new RAID1, in degraded mode, using the new
>>> partition as the base.  Then you copy the data over to the new RAID1
>>> device, change your boot setup, and reboot.
> 
> Michael> And you have to copy the data twice as a result, instead of
> Michael> copying it only once to the second disk.
> 
> So?  Why is this such a big deal?  As I see it, there are two seperate
> ways to setup a RAID1 setup, on an OS.
[..]
that was just a tiny nitpick, so to say, about a particular way to
convert existing system into raid1 - not something which's done every
day anyway.  Still, double the time for copying your terabyte-sized
drive is something to consider.

[]
> Michael> automatically activate it, thus making it "busy".  What I'm
> Michael> talking about here is that any automatic activation of
> Michael> anything should be done with extreme care, using smart logic
> Michael> in the startup scripts if at all.
> 
> Ah... but you can also de-active LVM partitions as well if you like.  

Yes, esp. being a newbie user who first installed linux on his PC just
to see that he can't use his disk.. ;)  That was a real situation - I
helped someone who had never heard of LVM and did little of anything
with filesystems/disks before.

> Michael> The Doug's example - in my opinion anyway - shows wrong tools
> Michael> or bad logic in the startup sequence, not a general flaw in
> Michael> superblock location.
> 
> I don't agree completely.  I think the superblock location is a key
> issue, because if you have a superblock location which moves depending
> the filesystem or LVM you use to look at the partition (or full disk)
> then you need to be even more careful about how to poke at things.

Superblock location does not depend on the filesystem.  Raid exports
the "inside" space only, excluding superblocks, to the next level
(filesystem or else).

> This is really true when you use the full disk for the mirror, because
> then you don't have the partition table to base some initial
> guestimates on.  Since there is an explicit Linux RAID partition type,
> as well as an explicit linux filesystem (filesystem is then decoded
> from the first Nk of the partition), you have a modicum of safety.

Speaking of whole disks - first, don't do that (for reasons suitable
for another topic), and second, using the whole disk or partitions
makes no real difference whatsoever to the topic being discussed.

There's just no need for the guesswork, except for the first install
(to automatically recognize existing devices, and to use them after
confirmation), and maybe for rescue systems, which again is a different
topic.

In any case, for a tool that does a guesswork (like libvolume-id, to
create /dev/ symlinks), it's as easy to look at the end of the device
as to the beginning or to any other fixed place - since the tool has
to know the superblock format, it knows superblock location as well).

Maybe "manual guesswork", based on hexdump of first several kilobytes
of data, is a bit more difficult in case where superblock is located
at the end.  But if one has to analyze hexdump, he doesn't care about
raid anymore.

> If ext3 has the superblock in the first 4k of the disk, but you've
> setup the disk to use RAID1 with the LVM superblock at the end of the
> disk, you now need to be careful about how the disk is detected and
> then mounted.

See above.  For tools, it's trivial to distinguish a component of a
raid volume from the volume itself, by looking for superblock at whatever
location.  Including stuff like mkfs, which - like mdadm does - may
warn one about previous filesystem/volume information on the device
in question.

> Michael> Speaking of cases where it was really helpful to have an
> Michael> ability to mount individual raid components directly without
> Michael> the raid level - most of them was due to one or another
> Michael> operator errors, usually together with bugs and/or omissions
> Michael> in software.  I don't remember exact scenarious anymore (last
> Michael> time it was more than 2 years ago).  Most of the time it was
> Michael> one or another sort of system recovery.
> 
> In this case, you're only talking about RAID1 mirrors, no other RAID
> configuration fits this scenario.  And while this might look to be

Definitely.  However, linear - to some extent - can be used partially.
But sure with much less usefulness.

However, raid1 is much more common setup than anything else - IMHO anyway.
It's the cheapest and the most reliable thing for an average user anyway -
it's cheaper to get 2 large drives than to, say, 3 a bit smaller drives.
Yes, raid1 has 1/2 space "wasted", compared with, say, raid5 on top of 3
drives (only 1/3 wasted), but still 3 smallish drives costs more than
2 larger drives.

> helpful, I would strongly argue that it's not, because it's a special
> case of the RAID code and can lead to all kinds of bugs and problems
> if it's not exercised properly. 

I'd say the key here is "if not excercised properly", not the superblock
location...

But we're now discussing somewhat different thing.  It's historical: unix
always allowed to `rm -rf /' (well, almost - there used to be cases when
it wasn't possible to remove a file of a running executable - EBUSY).
For example, windows does not allow one to do such evil things, and alot
of other similar stuff.  And for some strange reason I find unix to be
much more flexible and useful... oh well.  The question here is whenever
an OS should think for/instead of the user or not.  Sure thing, tools
should not be dumb, and mdadm is probably a nice example of an intelligent
tool (i mean mdadm --create, which looks at the devices and warns you if
it thinks there may be something sensible in there).  But what's nice about
it is that when necessary, I'm able to do whatever I want to (and I actually
used `rm -rf /' once, for good.. but that was more for fun than for real,
removing some old test install while running it).

> Michael> Problem occurs - obviously - when something goes wrong.  And
> Michael> most of the time issues we had happened on a remote site,
> Michael> where there was no expirienced operator/sysadmin handy.
> 
> That's why I like Rackable's RMM, I get full serial console access to
> the BIOS and the system.  Very handy.  Or get a PC Weasel PCI card and
> install it into such systems, or a remote KVM, etc.  If you have to
> support remote systems, you need the infrastructure to properly
> support it.  

It isn't always possible.  A situation we've here is - alot of tiny
remote offices all around, in the city and around it, some 100Km away.
There's a single machine in each, who does communication tasks too -
by means of second ethernet card or a dialup modem when a good
connectivity isn't an option for whatever reason.  Maybe it'd be a
good idea to install tiny routers in each location, like e.g
linksys wrts ($80 or so each), but it doesn't buy much really --
because the downtime of servers is very small (for about 10 years
this setup is working at ~60 places, only 3 or 4 times we needed
to go to the place to fix things).

> Michael> For example, when one drive was almost dead, and mdadm tried
> Michael> to bring the array up, machine just hanged for unknown amount
> Michael> of time.  An unexpirienced operator was there.  Instead of
> Michael> trying to teach him how to pass parameter to the initramfs to
> Michael> stop trying to assemble root array and next assembling it
> Michael> manually, I told him to pass "root=/dev/sda1" to the kernel.
> 
> I really don't like this, because you've now broken the RAID from the
> underside and it's not clear which is the clean mirror half now.  

Not clear?  Why, in God's sake??

Well.  One can speculate here about instability of device nodes and
other such things, that after next reboot sda may suddenly switch
its device node with sdb...  But that's irrelevant.  Even if the fs
is mounted readwrite and one component of raid has been modified behind
md code, I can trivially fix things after the fact, even after the next
reboot the md device will come back out of all components, not noticing
some components aren't the same.  Yes, thing will be badly broken in
case i'd change the filesystem significantly when it's mounted on the
component of raid.  But the thing is that I know what's going on, and
I will ensure things will be ok.

> Michael> Root mounts read-only, so it should be a safe thing to do - I
> Michael> only needed root fs and minimal set of services (which are
> Michael> even in initramfs) just for it to boot up to SOME state where
> Michael> I can log in remotely and fix things later.  (no I didn't
> Michael> want to remove the drive yet, I wanted to examine it first,
> Michael> and it turned to be a good idea because the hang was
> Michael> happening only at the beginning of it, and while we tried to
> Michael> install replacement and fill it up with data, there was an
> Michael> unreadable sector found on another drive, so this old but not
> Michael> removed drive was really handy).
> 
> Heh. I can see that but I honestly think this points back to a problem
> LVM/MD have with failing disks, and that is they don't time out
> properly when one half of the mirror is having problems.  

Yes - see above.  "Things works when everything works.  But problem
occurs than something doesn't work as intended - be it hardware,
software bugs or operator errors"- something like that.

But the thing is - the bug - let's assume it was an error handling bug -
prevented the system from operating correctly.  The system provided some
business-critical tasks, and it had to be bought up.  I had a very simple
way to do it, to bring it up to a state when people was able to work with
it as usual, and WHEN to look at bugs/patches/whatever.  Without even
going on-site, after 15-minute phone talk, and within 20 minutes it was
running.

> Michael> Another situation - after some weird crash I had to examine
> Michael> the filesystems found on both components - I want to look
> Michael> at the filesystems and compare them, WITHOUT messing up
> Michael> with raid superblocks (later on I wrote a tiny program to
> Michael> save/restore 0.90 superblocks), and without attempting a
> Michael> reconstruction attempts.  In fact, this very case - examining
> Michael> the contents - is something I've been doing many times for
> Michael> one or another reason.  There's just no need to involve
> Michael> raid layer here at all, but it doesn't disturb things either
> Michael> (in some cases anyway).
> 
> This is where a netboot would be my preferred setup, or a LiveCD.
> Booting off an OS half like this might seem like a good way to quickly
> work around the problem, but I feel like you're breaking the
> assumptions of the RAID setup and it's going to bite you worse one
> day. 

"Be careful when you use force".  You can cut your finger or even
kill yourself or someone else with a sharp knife, but it doesn't mean
we should forbid knifes.

> Michael> Well.  I know about a loop device which has "offset=XXX"
> Michael> parameter, so one can actually see and use the "internals"
> Michael> component of a raid1 array, even if the superblock is at the
> Michael> beginning.  But see above, the very first case - go tell to
> Michael> that operator how to do it all ;)
> 
> That's the real solution to me, using the loop device with an offset!
> I keep forgetting about this too.  And I think it's a key thing. 

Till this very thread, I didn't think about putting loop.ko into
my typical initramfs image... ;)

[]
> I never said that we should drop *read* support for 0.90 format, I was
> just suggesting that we make the 1.0 format with the superblock in the
> first 4k of the partition be the default from now on.

That's probably ok.  Not really sure what it buys us for real (again,
looking at superblock at the end of the device like libvolume-id does
is trivial, but sure, not every "block device guesser" out there
implemented this logic yet.  That to say: there are bugs still in
other components (startup scripts, those guessers, ..) which may
confuse something and your components will be used improperly, and
placing the supeblock at the beginning prevents some of them from
triggering.  Ditto for user by mistake doing evil things - with
superblock in front it becomes FAR less risky for the user -- who
uses force -- to do whatever he wants to, be it accidentially or
for real.

By the way.  The ability to mount/use component device of a raid1
array independently of raid was a key point when I first used it.
The code (circa 1998) was new and buggy, it wasn't part of the
official kernel, and sure I was afraid to use it.  But since I
knew I can always backoff trivially by just removing md layer and
one drive, I went on and deployed this stuff instead of expensive
hardware raid solution.  This in turn allowed us to complete the
project, instead of rolling it back due to lack of money...

> Michael> 0.90 has some real limitations (like 26 components at max
> Michael> etc), hence 1.x format appeared.  And various flavours of 1.x
> Michael> format are all useful too.  For example, if you're concerned
> Michael> about safety of your data due to defects(*) in your startup
> Michael> scripts, -- use whatever 1.x format which puts the metadata
> Michael> at the beginning.  That's just it, I think ;)
> 
> This should be the default in my mind, having the new RAID 1.x format
> with the first 4k of the partition being the default and only version
> of 1.x that's used going forward.  

ok, at least 1.1 should be supported -- v.1 with superblock at the end.
I for one will use it when I come across limitations/whatever of 0.90
format. ;)

Thanks for the reply!

/mjt
