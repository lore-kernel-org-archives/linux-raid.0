From: pg@lxra2.for.sabi.co.uk (Peter Grandi)
Subject: Re: Suboptimal raid6 linear read speed
Date: Sun, 20 Jan 2013 19:28:13 +0000
Message-ID: <20732.17741.587765.199649@tree.ty.sabi.co.uk>
References: <20130115123301.GA11948@rabbit.us>
	<50F55046.7050605@turmel.org>
	<20130115125507.GA12184@rabbit.us>
	<50F614F7.20104@hardwarefreak.com>
	<20130116025857.GA31112@rabbit.us>
	<50F70DB7.6020104@hardwarefreak.com>
	<alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se>
	<50F90857.3010305@hardwarefreak.com>
	<alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se>
	<50F9D32F.7090606@hardwarefreak.com>
	<alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... the original question on 2+2 RAID delivering 2x linear
transfers of 1x linear transfers ... ]

The original question was based on the (euphemism) very peculiar
belief that skipping over P/Q blocks has negligible cost. An
interesting detail is that this might be actually the case with
SSD devices, and perhaps even with flash SSD ones.

[ ... on whether 2+2 RAID6 or 2x(1+1) RAID10 is more likely to
fail and errors during rebuilds ... ]

>> If my math is correct, with a URE rate of 10E14, that's one
>> URE for every ~12.5TB read.  So theoretically one would have
>> to read the entire 2TB drive more than 6 times before hitting
>> the first URE.  So it seems unlikely that one would hit a URE
>> during a mirror rebuild with such a 2TB drive.

> Unlikely yes, but it also means one in 6 rebuilds
> (statistically) will fail with URE. I'm not willing to take
> that chance, thus I use RAID6.  Usually, with scrubbing etc
> I'd imagine that the probability is better than 1 in 6, but
> it's still a substantial risk.

Most of this discussion seems to me based on (euphemism) amusing
misconceptions of failure statistics and failure modes. The UREs
manufacturers quote are baselines "all other things being equal",
and in a steady state, etc. etc.; translating these to actual
failure probabilities and intervals by simple arithmetic is
(euphemism) futile.

In practice what matters is measured failure rates per unit of
time (generally reported as 2-4% per year) and taking into account
common modes of failure and environmental factors such as:

  * Whether all the members of a RAID set are of the same brand
    and model with (nearly) consecutive serial numbers.

  * Whether the same members are all in the same enclosure
    subject to the same electrical, vibration and thermal
    conditions.

  * Whether the very act of rebuilding is likely to increase
    electrical, vibration or thermal stress on the members,
    and/or 

  * What is the age and the age-related robustness to stress of
    the members.

It so happens that the vast majority of RAID sets are built by
people like the (euphemism) contributors to this thread and are
(euphemism) designed to maximize common modes of failure.

It is very convenient to build RAID sets that are all made from
drives of the same brand. model, and with consecutive serial
numbers all drawn from the same shipping carton, all screwed into
the same enclosure with the same power supply, cooling system, and
vibrating in resonance with the same chassis and each other, and
to choose RAID modes like RAID6 which extend the stress of
rebuilding to all members of the set, and on sets with members
mostly of the same age.

But that is the way bankers work, creating phenomenally correlated
risks, because it works very well when things go well, even if it
tends to fail catastrophically, rather than gracefully, when
something fails. But then ideally it has become someone else's
problem :-), otherwise "who could have known" is the eternal
refrain.

As StorageMojo.com pointed out, none of the large scale web
storage infrastructures is based on within-machine RAID; they are
all based on something like distributed chunk mirroring (as a
rule, 3-way) across very different infrastructures. Interesting...

  I once read with great (euphemism) amusement a proposal to
  replace intersite mirroring with intersite erasure codes, which
  seemed based on (euphemism) optimism about latencies.

Getting back to RAID, I feel (euphemism) dismayed when I read
(euphemism) superficialities like:

  "raid6 can lose any random 2 drives, while raid10 can't."

because they are based on the (euphemism) disregard of the very
many differences between the two, and that what matters is the
level of reliability and performance achievable with the same
budget. Because ultimately it is reliability/performance per
budget that matters, not (euphemism) uninformed issues of mere
geometry.

Anyhow if one wants that arbitrary "lose any random 2 drives" goal
regardless of performance or budget, on purely geometric grounds,
it is very easy to setup 2x(1+1+1) RAID10.

And as to the issue of performance/reliability vs. budget that
seems to be so (euphemism) unimportant in most of this thread,
there are some nontrivial issues with comparing a 2+2 RAID6 with a
2x(1+1) RAID10, because of their very different properties under
differently shaped workloads, but some considerations are:

* A 2+2 RAID6 delivers down to half the read "speed" of a 2x(1+1)
  RAID10 when complete (depending on whether single or multi
  threaded), and equivalent or less for many cases of writing
  especially if unaligned.

* On small-transaction workloads RAID6 requires that each
  transaction be complete only when *all* data (for read) blocks
  for reading or all stripe blocks (for writing) have been
  written, and that usually involves 1/2 of the rotational latency
  of the drives of dead time, because the drives are not
  synchronized, and this involves difficult chunk size tradeoffs.
  RAID10 only requires that reads of writes from one member of
  each mirror set be read or written to complete the operation,
  and the RAID0 chunk size matters but less.

* When incomplete, RAID6 can have even worse aggregate transfer
  rates during reading, because of the need for whole stripe
  reads whenever the missing drive supplies a non-P/Q block
  in the stripe, which for a 2+2 RAID6 is 50% of stripes; this
  also means that on an incomplete RAID6 stress (electrical,
  vibration and temperature) becomes worse in a highly
  correlated way exactly at the worst moment, when one drive
  is already missing.

* When rebuilding, RAID6 impacts the speed of *all* drives in
  the RAID set, and also causes greatly increased stress on all
  the drives, making them hotter, vibrate more, and draw more
  current, and all at the same time and in exactly the same way,
  and just after omne of them has failed, and they often are
  all the same brand, model and taken out of the same carton.

So for example try to compare like for like, as much as plausible,
and we want a RAID set with a capacity of 4TB; we would need a
RAID6 set of at least 3+2 or really 4+2 2TB drives, each drive to
be kept half-empty, to get equivalent read speeds in many
workloads to a 2x(1+1) RAID10.

Then if the RAID10 were allowed to have 6x 2TB drives we could
have a set of 2x(1+1+1) drives which would still be faster *and*
rather more resilient than the 4+2 RAID6.

Note: The RAID6 could be 4+2 1TB drives and still deliver 4TB of
  capacity, at a lower, but not proportionally lower cost, but
  it would still suck on unaligned writes, suffer a big impact
  when incomplete (66% of stripes need a full stripe read) or
  rebuilding, and still be likely less reliable than a 2x(1+1+1)
  of 1TB drives.

Again, comparisons between RAID levels and especially parity
RAID and non-parity RAID are very difficult because there are
performance (speed, reliability, value) envelopes are rather
differently shaped, but the issue of:

  "raid6 can lose any random 2 drives, while raid10 can't."

and associated rebuild error probability cannot be discussed in a
(euphemism) simplistic way.

NB: while in general I think that most (euphemism) less informed
people should use only RAID10, there are a few narrow cases where
the rather skewed performance envelopes of RAID5 and even of RAID6
match workload and budget requirements. But it takes apparently
unusual insight to recognize these cases, so just use RAID10 even
if you suspect it is one of those narrow cases.
