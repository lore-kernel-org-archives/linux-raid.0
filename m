From: Ed W <lists@wildgooses.com>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 14:21:12 +0100
Message-ID: <4DD66AC8.60804@wildgooses.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD65C18.5090804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD65C18.5090804@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

> If you absolutely insist on using a large expensive RAID card as a JBOD
> card, yeah, there are things you *can* do to keep access to the cache
> and BBU, though they are counter-intuitive.

The main issue with hardware cards is that really you need at least two
of them... At the most inopportune moment the only single one you own
will break and then your entire dataset becomes unavailable...

For sure, anyone with moderate or larger budgets, or a pool of similar
hardware, this becomes a case of simply buying an extra one and stashing
it.  Or at least keeping an eye on when it becomes end of line and
unavailable to buy a new one...


> First off, the LSI 920x series has a 16 port HBA.  You can look it up on
> their site.  SAS+SATA HBA I think.  LSI likes adorning some of their
> HBAs with some inherent RAID capability (their IR mode).  I personally
> prefer the IT mode, but its sometimes hard/impossible to make the switch
> (this is usually for motherboard mounted 'RAID' units). HBAs can be used
> as RAIDs, though the performance is abysmal (c.f. PERC*, lower end LSI
> ... which PERC are rebranded versions of, ...)

This sounds helpful, but I'm not understanding it?

Are you describing the reverse, ie taking a straight HBA card and asking
it to do "hardware raid" of multiple disks?

Or do you mean that performance is dismal even if you make X arrays of 1
disk each in order to access their BB cache?

Or to be really clear - can I take a cheapo PERC6 from ebay, and make it
run 8x disks completely under linux MD Raid, with smartctl access to the
individual disks and BB cache on the card - *with* high performance...
(phew...)



> When you do this, then use mdadm atop this.  We've found, generally, by
> doing this, we can build much faster RAIDs than the LSI 8888 units, and
> comparible to the 9260's in terms of performance across the same number
> of disks, at a lower price.  E.g. mdadm and the MD RAID stack are quite
> good.

What do you think stops the MD Stack being *better* than a 9260?  Also
in very round terms what kind of performance drop do you see from going
to linux MD raid versus a 9260?


> The additional cache doesn't buy you much for this arrangement. Might
> work against you if the card CPU is slow (as most of the hardware RAID
> chips are).

Hopefully not a silly question, but surely the CPU would have to be
extremely slow indeed not to keep up with a sorted bunch of writes that
are being issued to spinning rust drives with multi-ms seek latencies?
Are they really that slow..?

Thanks for your very helpful feedback - much appreciated

Ed W
