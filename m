From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Tue, 16 Aug 2016 14:44:42 -0500
Message-ID: <CAJvUf-C7CMqUBe+kPaxxTtmvuCXSRes73kMcAnZw7x8=6DNCdw@mail.gmail.com>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Dumitru <doug@easyco.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Doug & linux-raid list,

On Tue, Jul 12, 2016 at 9:10 PM, Doug Dumitru <doug@easyco.com> wrote:
> You might want to try running "perf" on your system while it is degraded and
> see where the thread is churning.  I would love to see those results.  I
> would not be surprised to see that the thread is literally "spinning".  If
> so, then the 100% cpu is probably fixable, but it won't actually help
> performance.

I sat on your email for a while, as the machine in question was (is)
production, and we don't have any useful downtime windows to
experiment.  But now we have a second, identical machine.  It
eventually needs to go into production as well, but for now we have
some time to test.

My understanding of "perf" is that it analyzes an individual process.
Would you be willing to elaborate on how I might use it while the
rebuild is taking place?

> In term of single drive missing performance with short reads, you are mostly
> at the mercy of short read IOPS.  If you array is reading 8K blocks at
> 2GB/sec, this is at 250,000 IOPS and you kill off a drive, it will jump to
> 500,000 IOPS.  Reading from the good drives remains as single reads, but
> read from the missing drives require reads from all of the others (with
> raid-5, all but one).  I am not sure how the recovery thread issues these
> recovery read.  Hopefully, it blasts them at the array with abandon (ie,
> submit all 22 requests concurrently), but the code might be less aggressive
> in deference to hard disks.  SSDs love deep queue depths.

I may be jumping ahead a little, but I wonder if there are tuning
parameters that make sense for an array such as this, given the
read-dominant (effectively WORM) workload?  In particular, things like
block-level read-ahead, IO scheduler, queue depth, etc.  I know the
standard answer for these is "test and see" but we don't have a second
100-machine compute farm to test with.  It's quite hard to simulate
such a workload.

> 1)  Consider a single CPU socket solution, like an E6-1650 v3.  Multi-socked
> CPU introduce NUMA and a whole slew of "interesting" system contention
> issues.

I think that's a good idea, but I wanted to have two identical systems.

> 2)  Use good HBA that are direct connected to the disks.  I like LSI 3008
> and the newer 16-port version, although you need to use only 12 ports with
> 6GBit SATA/SAS to keep from over-running the PCI-e slot bandwidth.

We have three LSI MegaRAID SAS-3 3108 9361-8i controllers per system.
8 ports per card.  Drives are indeed direct-connected.  (Technically
there is a backplane, but it's not an expander, just a pass-through
backplane for neat cabling.)

> 3)  Do everything you can to hammer deep queue depths.

Can you elaborate on that?

> 4)  Setup IRQ affinity so that the HBAs spread their IRQ requests across
> cores.

We have spent a lot of time tuning the NIC IRQs, but have not yet
spent any time on the HBA IRQs.  Will do.

> You can probably mitigate the amount of degradation by lowering the rebuild
> speed, but this will make the rebuild take longer, so you are messed up
> either way.  If the server has "down time" at night, you might lower the
> rebuild to a really small value during the day, and up it at night.

I'll have to discuss with my colleagues, but we have the impression
that the max rebuild speed parameter is more of a hint than an actual
"hard" setting.  That is, we tried to do exactly what you suggest:
defer most rebuild work to after-hours when the load was lighter (and
no one would notice).  But we were unable to stop the rebuild from
basically completely crippling the NFS performance during the day.

"Messed up either way" is indeed the right conclusion here.  But I
think we have some bottleneck somewhere that is artificially hurting,
making things worse than they could/should be.

Thanks again for the thoughtful feedback!

-Matt
