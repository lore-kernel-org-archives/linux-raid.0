From: "David Lethe" <david@santools.com>
Subject: RE: Distributed spares
Date: Thu, 16 Oct 2008 23:09:26 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C024F81A1@34093-C3-EVS3.exchange.rackspace.com>
References: <48F3C2A1.3080607@tmr.com> <18676.28329.93345.30205@notabene.brown> <48F7D32A.4040306@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <48F7D32A.4040306@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Bill Davidsen
> Sent: Thursday, October 16, 2008 6:50 PM
> To: Neil Brown
> Cc: Linux RAID
> Subject: Re: Distributed spares
> 
> Neil Brown wrote:
> > On Monday October 13, davidsen@tmr.com wrote:
> >
> >> Over a year ago I mentioned RAID-5e, a RAID-5 with the spare(s)
> >> distributed over multiple drives. This has come up again, so I
> thought
> >> I'd just mention why, and what advantages it offers.
> >>
> >> By spreading the spare over multiple drives the head motion of
> normal
> >> access is spread over one (or several) more drives. This reduces
> seeks,
> >> improves performance, etc. The benefit reduces as the number of
> drives
> >> in the array gets larger, obviously with four drives using only
> three
> >> for normal operation is slower than four, etc. And by using all the
> >> drives all the time, the chance of a spare being undetected after
> going
> >> bad is reduced.
> >>
> >> This becomes important as array drive counts shrink. Lower cost for
> >> drives ($100/TB!), and attempts to drop power use by using fewer
> drives,
> >> result in an overall drop in drive count, important in serious
> applications.
> >>
> >> All that said, I would really like to bring this up one more time,
> even
> >> if the answer is "no interest."
> >>
> >
> > How are your coding skills?
> >
> > The tricky bit is encoding the new state.
> > We can not longer tell the difference between "optimal" and
> "degraded"
> > based on the number of in-sync devices.  We also need some state
flag
> > to say that the "distributed spare" has been constructed.
> > Maybe that could be encoded in the "layout".
> >
> > We would also need to allow a "recovery" pass to happen without
> having
> > actually added any spares, or having any non-insync devices.  That
> > probably means passing the decision "is a recovery pending" down
into
> > the personality rather than making it in common code.  Maybe have
> some
> > field in the mddev structure which the personality sets if a
recovery
> > is worth trying.  Or maybe just try it anyway after any significant
> > change and if the personality finds nothing can be done it aborts.
> >
> >
> My coding skills are fine, here, but I have to do a lot of planning
> before even considering this.
> Here's why:
>   Say you have a five drive RAID-5e, and you are running happily. A
> drive fails! Now you can rebuild on the spare drive, but the spare
> drive
> must be created on the parts from the remaining functional drives, so
> it
> can't be done pre-failure, the allocation has to be defined after you
> see what you have left. Does that sound ugly and complex? Does to me,
> too. So I'm thinking about this, and doing some reading, but it's not
> quite as simple as I thought.
> > I'm happy to advise on, review, and eventually accept patches.
> >
> 
> Actually what I think I would do is want to build a test bed in
> software
> before trying this in the kernel, then run the kernel part in a
virtual
> machine. I have another idea, which has about 75% of the benefit with
> 10% of the complexity. Since it sounds too good to be true it probably
> is, I'll get back to you after I think about the simpler solution, I
> distrust free lunch algorithms.
> > NeilBrown
> --
> 
> Bill Davidsen <davidsen@tmr.com>
>   "Woe unto the statesman who makes war without a reason that will
> still
>   be valid when the war is over..." Otto von Bismark
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

With all due respect, RAID5E isn't practical.  Too many corner cases
dealing
With performance implications, and where you even just put the parity
block, to insure
That when a disk fails you didn't put yourself into situation where the
Hot spare chunk
is located on the disk drive that just died.  

What about all of those dozens of utilities that need to know about
RAID5E to work properly?
The cynic in me says if they're still having to recall patches (like
today) that deals with mdadm on
Established RAID levels, then RAID5E is going to be much worse.
Algorithms dealing
with drive failures, unrecoverable read/write errors on normal
operations as well as rebuilds, expansions, 
and journalization/optimization are not well understood.  It is new
territory.

If you want multiple distributed spares, just do RAID6, it is better
than RAID5 in that respect, and nobody
Has to re-invent the wheel.  Your "hot spare" is still distributed in
all of the disks, and you can survive multiple
Drive failures.  If your motivation is performance, then buy faster
disks, additional controller(s), 
optimize your storage pools; and tune your md settings to be more
compatible with your filesystem parameters.  
Or even look at your application and see if anything can be done to
reduce the I/O count.   

The fastest I/Os are the ones you eliminate.

David




