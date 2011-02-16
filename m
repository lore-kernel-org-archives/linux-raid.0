From: NeilBrown <neilb@suse.de>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 08:35:31 +1100
Message-ID: <20110217083531.3090a348@notabene.brown>
References: <20110216212751.51a294aa@notabene.brown>
	<ijgr9p$7v8$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ijgr9p$7v8$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 16:42:26 +0100 David Brown <david@westcontrol.com> wrote:

> On 16/02/2011 11:27, NeilBrown wrote:
> >
> > I all,
> >   I wrote this today and posted it at
> > http://neil.brown.name/blog/20110216044002
> >
> > I thought it might be worth posting it here too...
> >
> > NeilBrown
> >
> 
> 
> The bad block log will be a huge step up for reliability by making 
> failures fine-grained.  Occasional failures are a serious risk, 
> especially with very large disks.  The bad block log, especially 
> combined with the "hot replace" idea, will make md raid a lot safer 
> because you avoid running the array in degraded mode (except for a few 
> stripes).
> 
> When a block is marked as bad on a disk, is it possible to inform the 
> file system that the whole stripe is considered bad?  Then the 
> filesystem will (I hope) add that stripe to its own bad block list, move 
> the data out to another stripe (or block, from the fs's viewpoint), thus 
> restoring the raid redundancy for that data.

There is no in-kernel mechanism to do this.  You could possibly write a tool
which examined the bad-block-lists exported by md, and told a filesystem
about them.

It might be good to have a feature where by when the filesystem requests a
'read', it gets told 'here is the data, but I had trouble getting it so you
should try to save it elsewhere and never write here again'.   If you can
find a filesystem developer interested in using the information I'd be
interested in trying to provide it.


> 
> Can a "hot spare" automatically turn into a "hot replace" based on some 
> criteria (such as a certain number of bad blocks)?  Can the replaced 
> drive then become a "hot spare" again?  It may not be perfect, but it is 
> still better than nothing, and useful if the admin can't replace the 
> drive quickly.

Possibly.  This would be a job for user-space though.  May "mdadm --monitor"
could be given some policy such as you describe.  Then it could activate a
spare as appropriate.

> 
> It strikes me that "hot replace" is much like one of the original disks 
> out of the array and replacing it with a RAID 1 pair using the original 
> disk and a missing second.  The new disk is then added to the pair and 
> they are sync'ed.  Finally, you remove the old disk from the RAID 1 
> pair, then re-assign the drive from the RAID 1 "pair" to the original RAID.

Very much.  However if that process finds an unreadable block, there is
nothing it can do.  By integrating into the parent array, we can easily find
that data from elsewhere.

> 
> I may be missing something, but if I think that using the bad-block list 
> and the non-sync bitmaps, the only thing needed to support hot replace 
> is a way to turn a member drive into a degraded RAID 1 set in an atomic 
> action, and to reverse this action afterwards.  This may also give extra 
> flexibility - it is conceivable that someone would want to keep the RAID 
> 1 set afterwards as a reshape (turning a RAID 5 into a RAID 1+0, for 
> example).

You could do that .... the raid1 resync would need to record bad-blocks in
the new device where badblocks are found in the old device.  Then you need
the parent array to find and reconstruct all those bad blocks.  It would be
do-able.  I'm not sure the complexity of doing it that way is less than the
complexity of directly implementing hot-replace.  But I'll keep it in mind if
the code gets too hairy.

> 
> For your non-sync bitmap, would it make sense to have a two-level 
> bitmap?  Perhaps a coarse bitmap in blocks of 32 MB, with each entry 
> showing a state of in sync, out of sync, partially synced, or never 
> synced.  Partially synced coarse blocks would have their own fine bitmap 
> at the 4K block size (or perhaps a bit bigger - maybe 32K or 64K would 
> fit well with SSD block sizes).  Partially synced and out of sync blocks 
> would be gradually brought into sync when the disks are otherwise free, 
> while never synced blocks would not need to be synced at all.
> 
> This would let you efficiently store the state during initial builds 
> (everything is marked "never synced" until it is used), and rebuilds are 
> done by marking everything as "out of sync" on the new device.  The 
> two-level structure would let you keep fine-grained sync information 
> from file system discards without taking up unreasonable space.

I cannot see that this gains anything.
I need to allocate all the disk space that I might ever need for bitmaps at
the beginning.  There is no sense in which I can allocate some when needed
and free it up later (like there might be in a filesystem).
So whatever granularity I need - the space must be pre-allocated.

Certainly a two-level table might be appropriate for the in-memory copy of
the bitmap.  Maybe even 3 level.  But I think you are talking about storing
data on disk, and I think there - only one bitmap makes sense.

??

NeilBrown

