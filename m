From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: component growing in raid5
Date: Thu, 27 Mar 2008 21:44:12 +0100 (MET)
Message-ID: <Pine.GSO.4.64.0803261016550.15900@montezuma.acc.umu.se>
References: <47E5FFB8.5030903@bteam.hu> <47E753C4.7030903@rabbit.us>
 <47E7C609.9000501@bteam.hu> <18408.63715.481333.26215@tree.ty.sabi.co.uk>
 <Pine.GSO.4.64.0803251412000.15900@montezuma.acc.umu.se>
 <18409.23124.77027.214361@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18409.23124.77027.214361@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 25 Mar 2008, Peter Grandi wrote:

> [ ... ]
>
>> I'd agree, a 12-14 disk raid6 is as high that I'd like to
>> go. This is mostly limited by rebuild-times though, you'd
>> preferably stay within a day or two of single-parity "risk".
>
> A day or two? That's quite risky. Never mind that you get awful
> performance for that day or two and/or a risk of data corruption.
> Neil Brown some weeks on this mailing list expressed a very
> cautionary thought:
>
> =ABIt is really best to avoid degraded raid4/5/6 arrays when at all
>  possible. NeilBrown=BB

Yes, I read that mail. I've been meaning to do some real-world testing =
of=20
restarting degraded/rebuilding raid6es from various vendors, including =
MD,=20
but haven't gotten around to it.

Luckily computer crashes are another order of magnitude rarer than disk=
=20
crashes on storage servers in our experience, so raid6 isn't a net loss=
=20
even assuming worst case if you have checksummed data.

Also, this might be the reason that for instance HP's raid cards requir=
e=20
battery-backed cache for raid6, so that there won't be partially update=
d=20
stripes without a "better version" in the cache.

>>> * Large storage pools can only be reasonably built by using
>>> multiple volumes across networks and on top of those some
>>> network/cluster file system, [ ... ]
>
>> Or for that matter an application that can handle multiple
>> storage pools, many of the software that needs really large-scale
>> storage can itself split data store between multiple locations. [
>> ... ]
>
> I imagine that you are thinking here also of more "systematic"
> (library-based) ways of doing it, like SRM/SRB and CASTOR, dCache,
> XrootD, and other grid style stuff.

Yes that's what I work with, and similar solutions in other industries =
(I=20
know the TV folks have systems where the storage is just spread out ove=
r a=20
bunch of servers and filesystems instead of trying to do a cluster=20
filesystem, using a database of some kind to keep track of locations).

>> Funny, my suggestion would definately be raid6 for anything
>> except database(-like) load, that is anything that doesn't ends
>> up as lots of small updates.
>
> But RAID6 is "teh Evil"! Consider the arguments in the usual
> http://WWW.BAARF.com/ or just what happens when you update one
> block in a RAID6 stripe and the RMW and parity recalculation
> required.

I've read through most of baarf.com and I have a hard time seeing it=20
applying. An update to a block is a rare special case and can very well=
=20
take some time.

>> My normal usecase is to store large files
>
> If the requirement is to store them as in a mostly-read-only cache,
> RAID5 is perfectaly adequate; if it is to store them as in writing
> them out, parity RAID is not going to be good unless they are
> written as a whole (full stripe writes) or write rates don't matter.

Well, yes, full stripe writes is the normal case. Either a program is=20
writing a file out or you get a file from the network. It is written to=
=20
disk, and there is almost always sufficient write-back done to make it =
(at=20
least) full stripes (unless you have insanely large stripe size so that=
 a=20
few hundred megs won't be enough for a few files).

You'll get a partial update at the file start, unless the filesystem is=
=20
stripe aligned, and one partial update at the end. The vast majority of=
=20
stripes in between (remember, I'm talking about large files, at least a=
=20
couple of hundred megs) will be full stripe writes.

>> and having 60% more disks really costs alot in both purchase and
>> power for the same usable space.
>
> Well, that's the usual argument... A friend of mine who used to be
> a RAID sw developer for a medium vendor calls RAID5 "salesperson's
> RAID" because of this argument.
>
> But look at the alternative, say for a 12-14 disk storage array
> of say 750GB disks, which are currently best price/capacity (not
> necessarily best price/power though), to result in this comparison:

Sounds like a resonable hardware to look at for a building block.

> One RAID10 7x(1+1): 5.25TB usable.
>
>  Well, it has 40% less capacity than the others, but one gets
>  awesome resilience (especially if one has two arrays of 7 drives
>  and the mirror pairs are built across the two) including
>  surviving almost all 2-drive losses and most 3-drive losses, very
>  good read performance (up to 10-14 drives in parallel with '-p
>  f2') and very good write performance (7 drives with '-p n2'), all
>  exploitable in parallel, and very fast rebuild times impacting
>  only one of the drives, so the others have less chance of failing
>  during the rebuild.  Also, there is no real requirement for the
>  file system code to carefully split IO into aligned stripes.
>
> One RAID6 12+2: 9.00TB usable.
>
>  Any 3-drive loss is catastrophic, a 2 or 1 drive loss causes a
>  massive rebuild involving the whole array with the potential not
>  just for terrible performance but extra stress on the other
>  drives, and further drive loss. Write performance is going to be
>  terrible as for every N-blocks written we have to read N+2 blocks
>  and write N+2 blocks, especially bad news if N is small, and we
>  can avoid reading only if N happens to be 12 and aligned, but
>  read performance (if we don't check parity) is going to be pretty
>  good.

=46unny, when I do this, the write performance is typically 20-40% slow=
er=20
than the 14-disk RAID0 on the same disks. Not quite as terrible as you=20
make it out to be.

The performance during rebuilds usually depends on the priority given t=
o=20
the rebuild, some do it slow enough that it isn't really affected, but=20
then it usually takes much longer.

>  Rebuilding after a loss is not not just goint to be slow
>  and risk further losses, but also carries the risk of corruption.

And that's the really big issue to me.

> To me these summaries mean that for rather less than double the
> cost in raw storage (storage is cheap, admittedly cooling/power is
> less cheap) one gets a much better general purpose storage pool
> with RAID10, and one that is almost only suited to large file
> read-only caching in the other case.

So for a bit less than double the cost, I can get the same capability.=20
Perhaps with a little bit of extra performance that I can't make much u=
se=20
of, because I only have 1-2Gbit/s network connection to the host anyway=
=2E

> The single volume property only matters if one wants to build a
> really large (above 5TB) single physical filesystem, and that's not
> something very recommendable, so it does not matter a lot for me.

I wouldn't count "above 5TB" as "really large", if you are aiming for a=
=20
few PBs of aggregated storage the management overhead of sub-5TB storag=
e=20
pools is rather significant. If you substitute that for "over 15TB" I'd=
=20
agree (today, probably not next year :) ).

>> Of course, we'd be more likely to go for a good hardware raid6
>> controller that utilises the extra parity to make a good guess on
>> what data is wrong in the case of silent data corruption on a
>> single disk (unlike Linux software raid).
>
> That's crazy talk. As already argued in another thread, RAID as
> normally understood relies totally on errors being notified.
>
> Otherwise one needs to use proper ECC codes, on reading too (and
> background scrubbing is not good or cheap enough) and that's a
> different type of design.

Oh, but it does work on a background check, on some raid controllers. A=
nd=20
it does identify a parity mismatch, conclude that one of the disks is=20
[likely] wrong and then update data appropriately.

Of course, being storage hardware, you'd be lucky to see any mention of=
=20
this in any logs, when it should be loudly shouted that there were=20
mismatches.

But this works, in practice, today.

>> Unless, of course, you can run ZFS which has proper checksumming
>> so you can know which (if any) data is still good.
>
> ZFS indeed only does checksumming, not full ECC with rebuild.

Oh, but a dual-parity raidz2 (~raid6) you have sufficient parity to=20
rebuild the correct data assuming not more than 2 disks have failed (as=
 in=20
silently returning bad data). You just try to stick the data together i=
n=20
all the different ways until you get one with matching checksum. Then y=
ou=20
can update parity/data as appropriate.

Same goes with n-disk mirrors, you just check until you find at least o=
ne=20
copy with a matching checksum, then update the rest to this data.

/Mattias Wadenstein
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
