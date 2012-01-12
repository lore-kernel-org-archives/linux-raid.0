From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Thu, 12 Jan 2012 11:58:10 +0000
Message-ID: <20238.51922.396366.919432@tree.ty.sabi.co.UK>
References: <20111212115459.GC20730@fi.muni.cz>
	<4EE61EAE.20101@anonymous.org.uk>
	<20120106150823.GX25976@fi.muni.cz>
	<20231.9177.523012.471046@tree.ty.sabi.co.UK>
	<20120106201150.GB13358@fi.muni.cz>
	<4F077BE1.4050408@hardwarefreak.com>
	<20232.21966.952905.343604@tree.ty.sabi.co.UK>
	<4F087211.5020000@hardwarefreak.com>
	<20234.61352.443686.100881@tree.ty.sabi.co.UK>
	<4F0BB690.4040904@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F0BB690.4040904@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have pulled bits of the original posts to give some context.

[ .... ]

>>>> Stripe alignment is only relevant for parity RAID types, as
>>>> it is meant to minimize read-modify-write. There is no RMW
>>>> problem with RAID0, RAID1 or combinations.

[ ... ]

>>> The benefits aren't limited to parity arrays.  Tuning the
>>> stripe parameters yields benefits on RAID0/10 arrays as
>>> well, mainly by packing a full stripe of data when possible,
>>> avoiding many partial stripe width writes in the non aligned
>>> case. Granted the gains are workload dependent, but overall
>>> you get a bump from aligned writes.

[ ... ]

>>>> But there is a case for 'sunit'/'swidth' with single flash
>>>> based SSDs as they do have a RMW-like issue with erase
>>>> blocks. In other cases whether they are of benefit is
>>>> rather questionable.

>>> I'd love to see some documentation supporting this
>>> sunit/swidth with a single SSD device theory.

[ ... ]

> Yes, I've read such things. I was eluding to the fact that
> there are at least a half dozen different erase block sizes
> and algorithms in use by different SSD manufacturers. There is
> no standard. And not all of them are published. There is no
> reliable way to do such optimization generically.

Well, at least in some cases there are some details on erase
block sizes for some devices, and most contemporary devices seem
to max at 8KiB "flash pages" and 1MiB "flash blocks" (most
contemporary low cost flash SSDs are RAID0-like interleavings of
chips with those parameters).

There is (hopefully) little cost in further alignment so I think
that 16KiB as the 'sunit' and 2MiB as the 'swidth' on single
SSD should cover some further tightening of the requirements.

But as I wrote previously the biggest issue with the expectation
that address/length alignment matters with flash SSDs that do is
the Flash Translation Layer firmware they use that may make
attempts to perform higher level geometry adaptation not so
relevant.

While there isn't any good argument that address/length
alignment matters other than for RMW storage devices, I must say
that because of my estimate that address/length alignment is not
costly, and my intuition that it might help, I specify
address/length alignments on *everything* (even non parity RAID
on non-RMW storage, even single disks on non-RMW storage).

One of the guesses that I have as to that is that it might help
keep free space more contiguous, and thus in general may lead to
lower fragmentation of allocated files (which does not matter a
lot for flash SSDs, but then perhaps the RMW issue matters).
Because probably it leads to allocations being done in bigger
and more aligned chunks that otherwise.

That is a *static* effect at the file system level rather than
the dynamic effects at the array level mentioned in your
(euphemism alert) rather weak arguments as to multithreading or
better scheduling of IO operations at the array level.

Where the cost is mostly that when there is little free space
probably the remaining free space is more fragmented that it
would otherwise have been. But I try to keep at least 15-20%
free space available regardless.
