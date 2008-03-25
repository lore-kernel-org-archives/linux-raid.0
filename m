From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: component growing in raid5
Date: Tue, 25 Mar 2008 20:02:28 +0000
Message-ID: <18409.23124.77027.214361@tree.ty.sabi.co.uk>
References: <47E5FFB8.5030903@bteam.hu>
	<47E753C4.7030903@rabbit.us>
	<47E7C609.9000501@bteam.hu>
	<18408.63715.481333.26215@tree.ty.sabi.co.uk>
	<Pine.GSO.4.64.0803251412000.15900@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.0803251412000.15900@montezuma.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> even if the ZFS people glibly say otherwise (no 'fsck'
>> ever!).

> The ZFS people provide an fsck, it's called "resilver", which
> checks parity and checksums and update accordingly.

That's why I said "glibly": they have been clever enough to call
it with a different name :-).

[ ... ]

> I'd agree, a 12-14 disk raid6 is as high that I'd like to
> go. This is mostly limited by rebuild-times though, you'd
> preferably stay within a day or two of single-parity "risk".

A day or two? That's quite risky. Never mind that you get awful
performance for that day or two and/or a risk of data corruption.
Neil Brown some weeks on this mailing list expressed a very
cautionary thought:

 =ABIt is really best to avoid degraded raid4/5/6 arrays when at all
  possible. NeilBrown=BB

>> * Large storage pools can only be reasonably built by using
>> multiple volumes across networks and on top of those some
>> network/cluster file system, [ ... ]

> Or for that matter an application that can handle multiple
> storage pools, many of the software that needs really large-scale
> storage can itself split data store between multiple locations. [
> ... ]

I imagine that you are thinking here also of more "systematic"
(library-based) ways of doing it, like SRM/SRB and CASTOR, dCache,
XrootD, and other grid style stuff.

[ ... ]

> Funny, my suggestion would definately be raid6 for anything
> except database(-like) load, that is anything that doesn't ends
> up as lots of small updates.

But RAID6 is "teh Evil"! Consider the arguments in the usual
http://WWW.BAARF.com/ or just what happens when you update one
block in a RAID6 stripe and the RMW and parity recalculation
required.

> My normal usecase is to store large files

If the requirement is to store them as in a mostly-read-only cache,
RAID5 is perfectaly adequate; if it is to store them as in writing
them out, parity RAID is not going to be good unless they are
written as a whole (full stripe writes) or write rates don't matter.

> and having 60% more disks really costs alot in both purchase and
> power for the same usable space.

Well, that's the usual argument... A friend of mine who used to be
a RAID sw developer for a medium vendor calls RAID5 "salesperson's
RAID" because of this argument.

But look at the alternative, say for a 12-14 disk storage array
of say 750GB disks, which are currently best price/capacity (not
necessarily best price/power though), to result in this comparison:

One RAID10 7x(1+1): 5.25TB usable.

  Well, it has 40% less capacity than the others, but one gets
  awesome resilience (especially if one has two arrays of 7 drives
  and the mirror pairs are built across the two) including
  surviving almost all 2-drive losses and most 3-drive losses, very
  good read performance (up to 10-14 drives in parallel with '-p
  f2') and very good write performance (7 drives with '-p n2'), all
  exploitable in parallel, and very fast rebuild times impacting
  only one of the drives, so the others have less chance of failing
  during the rebuild.  Also, there is no real requirement for the
  file system code to carefully split IO into aligned stripes.

One RAID6 12+2: 9.00TB usable.

  Any 3-drive loss is catastrophic, a 2 or 1 drive loss causes a
  massive rebuild involving the whole array with the potential not
  just for terrible performance but extra stress on the other
  drives, and further drive loss. Write performance is going to be
  terrible as for every N-blocks written we have to read N+2 blocks
  and write N+2 blocks, especially bad news if N is small, and we
  can avoid reading only if N happens to be 12 and aligned, but
  read performance (if we don't check parity) is going to be pretty
  good. Rebuilding after a loss is not not just goint to be slow
  and risk further losses, but also carries the risk of corruption.

To me these summaries mean that for rather less than double the
cost in raw storage (storage is cheap, admittedly cooling/power is
less cheap) one gets a much better general purpose storage pool
with RAID10, and one that is almost only suited to large file
read-only caching in the other case.

But wait, one could claim that 12+2 is an unfairly wide RAID6, and
it is a straw man. Then consider these two where the array is split
into multiple RAID volumes, each containing an independent
filesystem:

Two RAID6 4+2: 6TB usable.

  This is a less crazily risky setup than 12+2, but we have lost
  the single volume property, and we have lost quite a bit of
  space, and peak read performance is not going to be awesome
  (4-drive wide per filesystem), but at least there is a better
  chance of putting together an aligned write of just 4 chunks.
  However if the aligned write cannot be materialized, every
  concurrent write to both filesystems will involve reading and
  then writing 2xN+4 blocks. If 3 disks fail, most of the time
  there is no global loss, unless all 3 are in the same half, and
  then only half of the files are lost, and no 2 disk failure
  causes data loss, only large performance loss. We save 2 drives
  too.

Three RAID5 3+1: 6.75TB usable

  This brings down the RAID5 to a more reasonable narrowness (the
  widest I would consider in normal use). Lost single volume
  property, the read speed on each third is not great, but 3 reads
  can process in paralle, 3 disk loss brings at most a third of the
  store, 2 disk loss is only fatal if it happens in the same
  third. Any 1 drive loss causes a performance drop only in one
  filesystem, unaligned writes involve only one parity block, the
  narrow width of the stripe means RMW cycles are going to be less
  frequent. We save 2 drives too.

Now if one wants what parity RAID is good for (mostly read-only
caching of already backed up data), and one has these 3 choices:

  One RAID6 12+2:  14 drives, 9.00TB usable.
  Two RAID6 4+2:   12 drives, 6.00TB usable.
  Three RAID5 3+1: 12 drives, 6.75TB usable.

The three RAID5 one wins for me in terms of simplicity and speed,
unless the single volume is a requirement or there are really very
very few writes other than bulk reloading from backup and the
filesystem is very careful with write alignment etc.

The single volume property only matters if one wants to build a
really large (above 5TB) single physical filesystem, and that's not
something very recommendable, so it does not matter a lot for me.

Overall I still in most cases would prefer 14 drives in one (or
more) RAID10 volumes to 12 drives as 3x(3+1), but the latter
admittedly for mostly read only etc. may well make sense.

> Of course, we'd be more likely to go for a good hardware raid6
> controller that utilises the extra parity to make a good guess on
> what data is wrong in the case of silent data corruption on a
> single disk (unlike Linux software raid).

That's crazy talk. As already argued in another thread, RAID as
normally understood relies totally on errors being notified.

Otherwise one needs to use proper ECC codes, on reading too (and
background scrubbing is not good or cheap enough) and that's a
different type of design.

> Unless, of course, you can run ZFS which has proper checksumming
> so you can know which (if any) data is still good.

ZFS indeed only does checksumming, not full ECC with rebuild.

There are filesystem design that use things like Reed-Solomon codes
for that. IIRC even Microsoft Research has done one for
distributing data across a swarm of desktops.

There is no substitute for end-to-end checksumming (and ECC if
necessary) though... Most people reading list will have
encountered this:

  http://en.Wikipedia.org/wiki/Parchive

and perhaps some will have done a web search bringing up papers
like these for the file system case:

  http://WWW.CS.UTK.edu/~plank/plank/papers/CS-96-332.pdf
  http://WWW.Inf.U-Szeged.HU/~bilickiv/research/LanStore/uos-final.pdf

[ ... ]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
