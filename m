From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Mon, 9 Jan 2012 13:46:16 +0000
Message-ID: <20234.61352.443686.100881@tree.ty.sabi.co.UK>
References: <20111212115459.GC20730@fi.muni.cz>
	<4EE61EAE.20101@anonymous.org.uk>
	<20120106150823.GX25976@fi.muni.cz>
	<20231.9177.523012.471046@tree.ty.sabi.co.UK>
	<20120106201150.GB13358@fi.muni.cz>
	<4F077BE1.4050408@hardwarefreak.com>
	<20232.21966.952905.343604@tree.ty.sabi.co.UK>
	<4F087211.5020000@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F087211.5020000@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> Stripe alignment is only relevant for parity RAID types, as it
>> is meant to minimize read-modify-write.

> The benefits aren't limited to parity arrays. Tuning the
> stripe parameters yields benefits on RAID0/10 arrays as well,
> mainly by packing a full stripe of data when possible,
> avoiding many partial stripe width writes in the non aligned
> case.

This seems like handwaving gibberish to me, or (being very
generous) a misunderestimating of the general notion that
larger (as opposed to *aligned*) transactions are (sometimes)
of greater benefit than smaller ones.

Note: There is with 'ext' style filesystems the 'stride' which
  is designed to interleave data and metadata so they are likely
  to be on different disks, but that is in some ways the opposite
  to 'sunit'/'swidth' style address/length alignment, and is
  rather more similar to multiple AGs rather than aligning IO on
  RMW-free boundaries.

How can =ABpacking a full stripe of data=BB by itself be of benefit
on RAID0/RAID1/RAID10, if that is in any way different from just
doing larger larger transactions, or if it is different from an
argument about chunk size vs. transaction size?

An single N-wide write (or even a close sequence of N 1-wide
writes) on a RAID0/1/10 will result in optimal N concurrent
writes if that is possible, whether it is address/length aligned
or not. Why would =ABavoiding many partial stripe width writes=AB
have a significant effect in the RAID0 or RAID1 case, given that
there is no RMW problem?

> Granted the gains are workload dependent, but overall you get
> a bump from aligned writes.

Perhaps in a small way because of buffering effects or RAM or
cache alignment effects, but that would be unrelated to the
storage geometry.

>> There is no RMW problem with RAID0, RAID1 or combinations.

> Which is one of the reasons the linear concat over RAID1 pairs
> works very well for some workloads.

But the two are completely unrelated. Your argument was that
'concat' plus AGs works well if the workload is distributed over
different directories in a number similar to the drivers. Concat
plus AGs may work well for special workloads, but RAID0 plus AGs
might work better.

To me 'concat' is just like RAID0 but sillier, regardless of
special cases. It is largely pointless. Please show how 'concat'
is indeed preferable to RAID0 in the general case or any
significant special case.

>> But there is a case for 'sunit'/'swidth' with single flash
>> based SSDs as they do have a RMW-like issue with erase
>> blocks. In other cases whether they are of benefit is rather
>> questionable.

> I'd love to see some documentation supporting this sunit/swidth
> with a single SSD device theory.

You have already read it above: internally SSDs have a big RMW
problem because of (erase) ''flash blocks'' being much larger
(around 512KiB/1MiB) than (''write''/read) ''flash pages'' which
are anyhow rather larger (usually 4KiB/8KiB) than logical 512B
sectors.

RMW avoidance is all that there is to address/length alignment.
It has nothing to do with RAIDness per se and indeed in a
different domain address/length aligned writes work very well
with RAM because it too has a big RMW problem.

Note: the case for RMW address/length aligned writes on single
  SSDs is not clear only because FTL firmware simulates a
  non-RMW device by using something (quite) similar to a
  small-granule log-structured filesystem on top of the flash
  storage and this might "waste" the extra alignment by the
  filesystem.

Same for example as partition alignment: you can easily find on
the web documentation that explain in accessible terms that
having ''parity block'' aligned partitions is good for parity
RAID, and other documentation that explains that ''erase block''
aligned partitions are good for SSDs too, and in both case the
reason is RMW, whether the reason for RMW is parity or erasing.

Those able to do a web search with the relevant keywords and
read documentation can find some mentions of single SSD RMW and
address/length alignment, for example here:

  http://research.cs.wisc.edu/adsl/Publications/ssd-usenix08.pdf
  http://research.microsoft.com/en-us/projects/flashlight/winhec08-ssd.=
pptx
  http://www.cse.ohio-state.edu/hpcs/WWW/HTML/publications/papers/TR-09=
-2.pdf

Mentioned in passing as something pretty obvious, and there are
other similar mentions that come up in web searches because it
is a pretty natural application of thinking about RMW issues.

Now I eagerly await your explanation of the amazing "Hoeppner
effect" by which address/length aligned writes on RAID0/1/10
have significant benefits and of the audacious "Hoeppner
principle" by which 'concat' is as good as RAID0 over the same
disks.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
