From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Suboptimal raid6 linear read speed
Date: Mon, 21 Jan 2013 22:00:16 +0000
Message-ID: <20733.47728.733102.284128@tree.ty.sabi.co.uk>
References: <20130115125507.GA12184@rabbit.us>
	<50F614F7.20104@hardwarefreak.com>
	<20130116025857.GA31112@rabbit.us>
	<50F70DB7.6020104@hardwarefreak.com>
	<alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se>
	<50F90857.3010305@hardwarefreak.com>
	<alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se>
	<50F9D32F.7090606@hardwarefreak.com>
	<alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se>
	<20732.17741.587765.199649@tree.ty.sabi.co.uk>
	<20130121144039.GA4103@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130121144039.GA4103@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... RAID6 vs. RAID10 ... ]

> I am not sure what you are saying... I see raid as a way for
> me to keep a higher layer "online", while some of the physical
> drives fall on the floor. In the case of 4 drives (very
> typical for mom&pop+consultant shops with near-sufficient
> expertise but far-insufficient funds)

If it is literally true that =ABfar-insufficient funds=BB then these
people are making a business bet that they will be lucky.

Something like "with this computing setup I have 1 chance in 10
to go bankrupt in 5 years because of loss of data, but I hope
that I will be one of the 9 that don't and also the business
will last less than 5 years". That's a common business strategy,
and a very defensible one in many cases.

> a raid6 is the more obvious choice as it provides the array
> size of 2xdrives,

Despite my aversion to parity RAID in all its form (as shared
with the BAARF.com supporters), in some cases it does match
particular requirements, and RAID6 4+2 and RAID5 2+1 or 4+1 seem
to be the most plausible, because they have narrow stripes
(minimizing alignment issues) and a decent degree of
redundancy. My notes on this:

  http://www.sabi.co.uk/blog/0709sep.html#070923b
  http://www.sabi.co.uk/blog/12-two.html#120218

To me RAID6 2+2 seems a bit crazy because RAID10 2x(1+1) has
much better (read) speed or RAID10 2x(1+2) has much better
resilience too, for not much higher price in the second case.

But at least it has a decent amount of redundancy, 50% like
RAID10, just distributed differently. I really dislike wide
RAID5 and RAID6 instead because of this:

> with reasonable redundancy (*ANY* 2 drives),

This point has been made to me for decades and I was never able
to understand it because it sounded quite absurd, and then only
relatively recently that it is based on two assumptions, that
probability of failure is independent of RAID set size, and it
is not correlated across drives in the same RAID set.

  http://www.sabi.co.uk/blog/1104Apr.html#110401

Unfortunately once a drive has failed in a RAID set the chances
that more drives will fail are the proportional to the size of
the RAID set, and larger the more similar the RAID set members
and their environment are.

> and reasonable-ish read/write rates in normal operation.

Ahhhhhh but yourself were complaining about that from a 2+2 you
only get 2x sequential transfer read rates, so you can't use
that argument.

[ ... ]

> By the way "normal operation" is what I am basing my
> observation on, because a degraded raid does not run for years
> without being taken care of. If it does - someone is doing it
> wrong.

Wish that were true, but the problem is not "years", it is
"hours"/"days" being incomplete or resyncing, in which a RAID6
gets much more stressed than a RAID10, and usually failures are
very correlated.

When a disk starts failing, it often because of age or design or
vibration, and usually all drives in the same RAID set have the
same age, design or are subject to the same vibrations; or it
fails because of some external power or thermal or mechanical
shock, and as a rule such a shock affects all drives at the same
time; some may fail outright, some may be instead partially
affected, and the stressful incomplete/resyncing load of RAID6
can drive them to fail too.

Sure, a RAID set can work for 2 to 5 years without much of a
problem if one is lucky. As a friend said, it is like saying

  "I did not change the oil in my car for 3 years and it is
  still running, that means I don't need to change it for
  another 3 years".

Sure it can be like that if one has a "golden" engine and uses
it not that much.

Admittedly I have seen cases with 10+2 and 14+2 RAID6 set "work"
for years, but in the better case they were part of a system
with a responsive support team, they were very lightly loaded,
on nearly entirely read-only data, they were well backed up, the
disks had 512B sectors and relatively small and the system
components were pretty high quality "enterprise" ones that fail
relatively rarely.

Also, the workload was mostly running in memory, with occasional
persist/backup style writing, and as to writing RAID5 and RAID6
can work fairly well if they are used mostly for bulk streaming
writes.

> Besides with raid6 the degradation of operational speeds will
> be a contributing factor to repair the array *sooner*.

That does not seem to me like a positive argument...

> Compare to raid10, which has better read characteristics, but
> in order to reach the "any 2 drives" bounty,

But it can also lose more than 2 drives and still work, as long
as they are not in the same pair. That can be pretty valuable.

> one needs to assemble a -l 10 -n 4 -p f3, which isn't... very
> optimal (mom&pop just went from 2xsize to 1.3xsize).

Well at parity of target capacity of 2TB capacity and (single
threaded) read speed you can use a RAID10 of 6x1TB drives
instead of 4x2TB RAID6 drives.

And we are not talking about *huge* amounts of money for a small
RAID set here.

> From your comment above I gather you disagree with this. Can
> you elaborate more on the economics of mom&pop installations,
> and how my assesment is (euphemism) wrong? :)

It is not necessarily wrong, it is that you are comparing two
very different performance envelopes and being hypnotized by
geometry considerations without regard to effective failure
probability and speed.

At least you are using a RAID6 2+2 which has a decent percent of
redundancy, 50% like a RAID10.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
