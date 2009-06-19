From: Neil Brown <neilb@suse.de>
Subject: Re: Write intent bitmaps
Date: Fri, 19 Jun 2009 12:24:40 +1000
Message-ID: <19002.63208.449137.964133@notabene.brown>
References: <20090608021026139.GMOD14139@cdptpa-omta02.mail.rr.com>
	<18989.6010.582386.812296@fisica.ufpr.br>
	<874oue9cr1.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Goswin von Brederlow on Thursday June 18
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Carlos Carvalho <carlos@fisica.ufpr.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 18, goswin-v-b@web.de wrote:
> carlos@fisica.ufpr.br (Carlos Carvalho) writes:
> 
> > Leslie Rhorer (lrhorer@satx.rr.com) wrote on 7 June 2009 21:10:
> >  >1. The write-intent bitmap seems to be rather similar to a file system
> >  >journal.  Are there any features of the bitmaps which distinguish them from
> >  >a journal, other than the fact they operate at the RAID layer, of course,
> >  >instead of the filesystem layer?
> >
> > The bitmap doesn't have the info to be written, it's just a bit for
> > the whole region. The FS journal has the [journaled part of the] info,
> > which can be fully recovered later if necessary. Don't forget that
> > raid doesn't protect against unclean shutdowns; if the array is taken
> > down during a write, some disks may have the new version of the stripe
> > and others not. When it's resynced the parity will be recalculated
> > from what's on all disks, that is a mix of new and old versions of the
> > stripes. If later a disk fails before the blocks are re-written the
> > not-the-one-you-want parity will be used, and you'll have corruption.
> 
> Can that actualy happen? I would think the raid should refuse to
> reassemble automatically if any one stripe does not have enough blocks
> in sync. Just like when not enough disks are in sync without bitmap.

You would think correctly.  If mdadm cannot be sure that the data is
still good, it will refuse to assemble the array. 
In particular, active degraded raid4/5/6 arrays will not normally be
assembled for you due to the above reason - the could be data
corruption.

If you want to get as whatever data there is there, you can assemble
with "--force".  But in that case be aware that there could be
corruption.
I have never actually heard of anyone doing that and discovering
corruption, but then the nature of the possible corruption is that it
would probably be quite hard to find.

> 
> >  >2. On a RAID5 or RAID6 array, how much of a performance hit might I expect?
> >
> > Depends on the chunk and where the bitmap is. With an internal one the
> > default chunk will cause a BIG hit. Fortunately it's very easy to try
> > different settings with the array live, so you can easily revert when
> > the world suddenly freezes around you... Our arrays are rather busy,
> > so performance is important and I gave up on it. If you can put it on
> > other disks I suppose it's possible to find a chunk size compatible
> > with performance.
> 
> Worst case every write to the raid requires a write to the bitmap. So
> your speed will be ~half. It is not (much) less than half though. You
> could think that the seek to and from the bitmap must slow things down
> even more but worst case is random access, which means there already
> is a seek between each write. The bitmap just adds one write and one
> seek for each write and seek.

I think half-speed would be very very unlikely.  md tries to gather
bitmap updates so that - where possible - it might update several bits
all at once.

I have measured a 10% performance drop.  However it is very dependant
on workload and, and you say, bitmap chunk size.

> 
> The critical part seems to be the size one bit in the bitmap
> covers. If you have 2 writes that are covered by the same bit then the
> bit is only changed once. So the bigger the covered size the less
> bitmap writes. On the other hand the benefits (specifically resyncs)
> decrease with the covered size. Find a balance that works for you.
> 
> >  >3. The threads I have read all speak about the benefits during a power
> >  >failure.  Power failures are not the only source of dirty shutdowns,
> >  >however.  Are there any benefits to a bitmap for recovering a failed array
> >  >or a degraded array?  A resync can take more than a day, and the array is
> >  >vulnerable during that time.
> >
> > That's the benefit and the purpose of the bitmap. Besides being
> > vulnerable during the resync, you also have a BIG performance hit if
> > your array is busy (or the resync takes forever), so it's worth trying.
> 
> As long as the drives work again during reassembly it doesn't matter
> what the cause of the failure was. It will only sync the parts
> indicated by the bitmap. On the other hand if a drive fails and is
> replaced there is no alternative to rewriting all of that drive.
> 
> One benefit of the bitmap during a full resync though is (afaik) that
> the bitmap (better) indicates the amount done already. If the system
> crashes and reboots the resync will resume instead of restart.

When you a rebuilding a drive that had failed, we call that "recovery"
not "resync".
With 0.90 metadata, a recovery will always restart at the beginning.
With 1.x metadata, we checkpoint the recovery so it won't duplicated
very much work.


NeilBrown
