From: Neil Bortnak <linux-raid@moro.us>
Subject: Feature Request/Suggestion - "Drive Linking"
Date: Wed, 30 Aug 2006 01:21:07 +0900
Message-ID: <1156868468.5611.102.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Everybody,

I had this major recovery last week after a hardware failure monkeyed
things up pretty badly. About half way though I had a couple of ideas
and I thought I'd suggest/ask them.

1) "Drive Linking": So let's say I have a 6 disk RAID5 array and I have
reason to believe one of the drives will fail (funny noises, SMART
warnings or it's *really* slow compared to the other drives, etc). It
would be nice to put in a new drive, link it to the failing disk so that
it copies all of the data to the new one and mirrors new writes as they
happen.

This way I could get the replacement in and do the resync without
actually having to degrade the array first. When it's done, pulling out
the failing disk automatically breaks the link and everything goes back
to normal. Or, if you break the link in software, it removes the old
disk from the array and wipes out the superblock automatically.

Maybe there is a way to do this already and I just missed it, but I
don't think so. I'm not really keen on degrading the array just in case
the system finds an unrecoverable error on one of the other disks during
the resync and the whole thing comes crashing down in a dual disk
failure. In fact, I'm not keen on degrading the array period.


2) This sort of brings up a subject I'm getting increasingly paranoid
about. It seems to me that if disk 1 develops a unrecoverable error at
block 500 and disk 4 develops one at 55,000 I'm going to get a double
disk failure as soon as one of the bad blocks is read (or some other
system problem ->makes it look like<- some random block is
unrecoverable). Such an error should not bring the whole thing to a
crashing halt. I know I can recover from that sort of error manually,
but yuk.

It seems to me that as arrays get larger and larger, failure mechanisms
better than "wipe out 750G of mirror and put the array in jeopardy
because a single block is unrecoverable" need to be developed. Can bad
block redirection help us add a layer of defense, at least in the short
term? Granted, if the disk block is unrecoverable because all the spares
are used up, the chances are the drive will die off soon anyway, but I'd
rather get one last kick at doing a clean rebuild (maybe a la the disk
linking idea above) before ejecting the drive. The current methods
employed by RAID 1-6 seem a bit crude. Fine for 20 years ago, but
showing it's age with today's increasingly massive data sets.

I'm quite thankful for all the MD work and this isn't a criticism. I'm
merely interested in the problem and wonder at other people's thoughts
on the matter. Maybe we can move from something that paints in large
strokes like RAID 1-6 and look towards an all-new RAID-OMG. I'm
basically thinking it's prudent to apply security's idea of "defense in
depth" to drive safety.


3) So this last rebuild I had to do was for a system with a double disk
failure and no backup (no, not my system as I would have had a backup as
we all know raid doesn't protect against a lot of threats). I managed to
get it done but I ended up writing a lot of offline, userspace
verification and resync tools in perl and C and editing the superblocks
with hexedit.

An extra tool to edit superblock fields would be very keen.

If no one is horrified by the fact I did the other recovery tools in
perl, I would be happy to clean them up and submit them. I wrote one to
verify a given disk's data vs. the other disks and report errors
(optionally fixing them). It also has a range feature so you don't have
to do the whole disk. The other is similar, but I built it for high
speed bulk resyncing from userspace (no need to have RAID in the
kernel).


4) And finally (for today at least), can mdadm do the equivalent of
NetApp's or 3Ware's disk scrubbing? I know I can check an array manually
with a /sys entry, but it would be cool to have mdadm optionally run
these checks and continually rerun them when they were finished for all
the arrays on the system. Just part of it's monitoring duties really.
For someone like me, I only care about data integrity and uptime, not
speed. I heard something like that was going in, but I don't know it's
status.

Thanks!

Neil

