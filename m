From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sun, 5 Apr 2009 18:27:37 -0500
Message-ID: <20090405232739.NKY19140.cdptpa-omta03.mail.rr.com@Leslie>
References: <18905.5874.850528.576631@tree.ty.sabi.co.uk>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18905.5874.850528.576631@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Peter Grandi' <pg_lxra@lxra.for.sabi.co.UK>, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Very wise words. Because what the O.P. is trying to do is system
> integration on a medium-large scale

More like a small-medium scale, I would say.  Other than the size of the
array, this is a vary small, very limited system.  It's a motherboard, a
keyboard, a mouse, a power supply, a UPS, a basic non-RAID controller, some
port multipliers, and a bunch of disks.  The desktop system from which I
type this message is more sophisticated / larger in scale.  Its expansion
ports are full, as are its I/O ports.  It just doesn't have a RAID array.

> and yet expects all the
> bits (sw and hw) to snap together.

No, I don't.  Indeed, it has taken over a year and a half of testing and
swapping components (software and hardware) to get to this point.  This is
simply the first problem I have not been able to solve by myself.

> While as you demonstrate to
> know system integration means finding the few combinations of
> sw/hw/fw that actually work, and work together.

Yes, he does, but so do I.  I just need some help finding some diagnostics
which will point to what components are causing the problem.  At this point,
I would guess it's something between the RAID software and reiserfs, but the
data is not yet conclusive, by any means.

> > I'm not really keeping up with things like video editing, but
> > as someone else said XFS was specifically designed for that
> > type of workload.
> 
> JFS not too bad either, and it is fairly robust too.

I'm open to any and all better alternatives, even if they are not part of
the root cause of the problem.  I read a couple of reports, early on, that
gave JFS a black eye.  With so many opinions, it's sometimes hard to sort
out the good from the bad.

> > If I were designing a system like you have for myself, I would
> > get one of the major supported server distros.
> 
> That in my experience does not matter a lot, but it should be
> tried. On one hand their kernels are usually quite a bit behind
> the state of the hw, on the other their kernels tend to have
> lots of useful bug fixes. On balance I am not sure which is more
> important. However I like the API stability of major distributions.

I'll put it on the list.  I can fairly easily create an alternate boot, of
course, and while I don't want to spend all the time to convert the server
softwares unless I am sure this will fix the problem, I should be able to
reproduce the conditions well enough to verify one way or the other.

> > FYI: Some of the major problems going in the last year that
> > make me willing to believe someone is having lots of unrelated
> > issues in trying to build a system like Leslie's.
> 
> All these problems that you list below are typical of system
> integration with lots of moving parts :-). Experiences teaches
> people like you and me that to expect them. And there are people
> at large scale sites that write up about them, for example:

I know that very well.  My professional systems encompass tens of thousands
of miles of fiber plant and tens of thousands of individual hardware
components from more than 200 vendors.  The number that don't talk at all to
one another or do so poorly yet must be employed in the system is appalling.

> > Reiser's main maintainer is in jail, recent versions of
> > OpenSUSE croak if reiser is in use because they exercise code
> > paths with serious bugs. (google "beagle opensuse reiser")
> 
> That the maintainer is in trouble is not so important; but
> ReiserFS has indeed some bugs mostly because it is a bit
> complicated.

Here's what I don't understand.  Given that reiserfs, like virtually any
complex software, is known to have some issues, and given the symptoms I
have encountered point more toward issues at the file system or RAID level
and more away from hardware sources, why are several people basically
yelling at me that it must be a hardware issue?  No, the hardware is not
sophisticated, but then neither is the application.

> Longer ATA/80 wire cables also have had problems for a long
> time. Longer SATA and eSATA cables also problematic. But SAS
> "splitter" cables seem to be usually pretty well shielded.

Appropo of nothing, but it was a SAS / infiniband RAID chassis that had the
big problem.  With 5 drives, I was having trouble, so the manufacturer sent
me a new backplane.  That seemed to resolve the issue, but when I went to 6
drives, the array croaked.  I replaced the drive controller (the second time
I replaced it, actually), to no avail. I had to move the drives around until
I could find a stable configuration of used and unused slots in the chassis.
I went to 8 drives without too much trouble, but then when I needed a 9th it
meant I had to put both controllers in the system, but the motherboard only
had 1 PCI Express x 16 slot.  I purchased a motherboard which was supposed
to be compatible with Linux and the controllers, but I couldn't get it to
work under "Etch" and it would not boot "Lenny" at all.  So I got another MB
which was supposed to work according to both the MB and controller folks.
It worked fine with one controller, but never two.  Finally, I gutted the
multilane system and installed a port multiplier system.  I could get 8
drives to be pretty stable, but with ten drives, the number of "failed"
drives jumped to three or four a day.  The RAID array crashed and burned
completely and unrecoverably 3 times.  I moved the drives out of the
external chassis and into the main chassis, and the problems ceased.  This
worked fine for three weeks.  When the new chassis arrived, and I moved the
drives to it.  I don't recall for certain whether I formatted the array as
reiserfs before or after moving the drives, but I did not notice the issue
with the halts until a week or two after moving the drives.

> > Lot of reported problems turn out to be power supplies not
> > designed to carry a Sata load.  Apparently sata drives are
> > very demanding and many "good" power supplies don't cut the
> > mustard.
> 
> That probably does not have much to do with SATA drives. It is
> more like a combination of factors:
> 
>   * Many power supplies are poorly designed or built.
> 
>   * Modern hard disks draw a high peak current on startup, and
>     many people do not realize that PSU rails have different
>     power ratings, and do not stagger power up of many drives.

Since in this case the drive are already spinning long before the system
boots, the start-up currents shouldn't really be an issue, but even if they
are, the supply is rated for more than enough to handle all the drives
starting together.  A bad supply would be another matter, of course.

 
>   * Cooling is often underestimated, with overheating of power
>     and other components, especially in dense configurations.

The array chassis is specifically designed to handle 12 drives.  All the
drives are reporting to be continuously cooler than 46C.  All but two are
cooler than 43C.

> Some of my recommendations:
> 
> * Use as simple a setup as you can. RAID10, no LVM, well tested

I'm using RAID6, because it is more robust, and because I couldn't keep the
array up for more than a few hours under RAID5 with the old chassis.

>   file systems like JFS or XFS (or Lustre for extreme cases).

I'll look into them.

> * Only use not-latest components that are reported to work well
>   with the vintage of sw that you are using, and do extensive
>   web searching as to which vintages of hw/fw/sw seem to work
>   well together.

Well, like I said, this is a pretty plain vanilla system.  The motherboard
is a somewhat new model, and of course the 1T drives have only been out a
year or so.  Other than the softwares related to the servers, everything
else is in the distro.  The servers are both Java based, and in any case I
can shut them down and still readily produce the issue.  There is one
Windows client I run under Wine, but likewise I can shut it down and still
trigger the issue with two successive cp commands.

> * Oversize by a good margin the power supplies and the cooling
>   system, stagger drive startup, and monitor the voltages and
>   the temperatures.

The original controllers supported staggered spin-up, but I don't think this
one does.  Since the drives are external to the main system, I don't think
it really makes much difference.

> * Use disks of many different manufacturers in the same array.

Well, I'm using two different manufacturers, and four different models.

> * Run period tests against silent corruption.

Such as ?

 
> The results can be rewarding; I have setup without too much
> effort storage systems that deliver several hundred MB/s over
> NFS, and a few GB/s over Lustre are also possible (but that
> needs more careful thinking).

The performance of this system is fine.  I haven't done any tuning, but 450
Mbps is much more than necessary, so I'm not inclined to spend any effort on
improving it, unless it will fix this issue.

