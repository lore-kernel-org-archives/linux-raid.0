From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V4 00/13] MD: a caching layer for raid5/6
Date: Fri, 10 Jul 2015 14:36:56 +1000
Message-ID: <20150710143656.4ee7e647@noble>
References: <cover.1435094582.git.shli@fb.com>
	<20150708115636.6c972269@noble>
	<20150708054344.GA2709238@devbig257.prn2.facebook.com>
	<20150710092119.297fd9e1@noble>
	<20150710040847.GA1408097@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150710040847.GA1408097@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, Kernel-team@fb.com
List-Id: linux-raid.ids

On Thu, 9 Jul 2015 21:08:49 -0700 Shaohua Li <shli@fb.com> wrote:

> On Fri, Jul 10, 2015 at 09:21:19AM +1000, NeilBrown wrote:
> > On Tue, 7 Jul 2015 22:44:02 -0700 Shaohua Li <shli@fb.com> wrote:
> > 
> > > On Wed, Jul 08, 2015 at 11:56:36AM +1000, NeilBrown wrote:
> > > > 
> > > > Hi,
> > > >  I made some time to look at these this morning - sorry for the delay.
> > > > 
> > > >  Having it all broken down with more complete comments helps a lot -
> > > >  thanks.
> > > > 
> > > >  Unfortunately ... it helps confirm that I really don't like this.  It
> > > >  seems much more complex that it should be.  There certainly are a lot
> > > >  of details that need to be carefully considered, but the result needs
> > > >  to be simpler.
> > > > 
> > > >  A big part of my concern is that you choose to avoid making proper use
> > > >  of the current stripe cache.  Your argument is that it is already
> > > >  too complex.  That is probably true but I don't think you decrease
> > > >  total complexity by adding extra bits on the side that themselves are
> > > >  complex in completely different ways.
> > > > 
> > > >  I would like to start small and keep it as simple as possible.  I
> > > >  think the minimum useful functionality is closing the write-hole.
> > > >  Anything else could be done outside raid5 (e.g. bcache), but the
> > > >  write-hole needs integration.  Once that is closed, it may make sense
> > > >  to add more functionality.
> > > > 
> > > >  To do that we need a log, and it was quite sensible for you to put
> > > >  that first in the list of patches.  So let's start with that.
> > > > 
> > > >  I would like to propose a single metadata block format.  This block
> > > >  includes the general RAID5 parameters (both 'old' and 'new' for when a
> > > >  reshape is happening), it includes linkage to find nearby metadata.
> > > >  It includes a list of the data written after the metadata.  And it
> > > >  includes a list of device-addresses of parity blocks which are now safe
> > > >  on the RAID and so any log content is now ignored.
> > > > 
> > > >  The general mechanism for writing to the log is:
> > > >    - collect a list of bios.  As each arrives update the metadata
> > > >      block with index information.
> > > >    - when ready (there are various triggers) write the metadata block
> > > >      with FLUSH/FUA and write all the data blocks normally.  This
> > > >      metadata block plus data/parity blocks is a 'transaction'.
> > > > 
> > > >  We never trigger a log transaction until all writes for the previous
> > > >  transaction have completed. This means that once the metadata block is
> > > >  safe, all previous data must also be safe.  If this imposes too much
> > > >  waiting we could allow a "double-buffer" approach were each metadata
> > > >  block completes the previous-but-one transaction.
> > > > 
> > > >  When all of the previous writes complete we trigger a new log write
> > > >  if there is an outstanding SYNC write, or maybe an outstanding
> > > >  FLUSH/FUA, but otherwise we wait until the metadata block is full, or
> > > >  some amount of time has passed.
> > > > 
> > > >  This one metadata block serves all of the purposes that you
> > > >  identified.  It records where data is, it commits previous writes, and
> > > >  records which stripes are being written to RAID and which have been
> > > >  fully committed.
> > > > 
> > > >  With that log in place, we add the code to "hijack ops_run_io" to
> > > >  write all dirty blocks from the stripe_head to the cache.  This
> > > >  includes the parity of course.  Immediately that data is safe the
> > > >  write requests can be returned and the data is written the the RAID
> > > >  devices.
> > > > 
> > > >  "Recovery" at boot time simply involves:
> > > >   1. find and load first metadata block
> > > >   2. load the "next" metadata block. If it doesn't exist, stop.
> > > >   3. For each parity/data block listed in current block, get the
> > > >      stripe_head and read the block in.
> > > >   4. For each completed stripe listed, find the stripe_head and
> > > >      invalidate it.
> > > >   5. Make the "next" metadata block the current block and goto 2
> > > >   6. Flush out all dirty data in stripe cache.
> > > > 
> > > > 
> > > >  I think that all of this *needs* to use the stripe_cache.
> > > >  Intercepting normal processing between party computation and writing
> > > >  to the RAID devices must involve the stripe_cache.
> > > > 
> > > >  So this is a "simple" start.   Once this is written and agreed and
> > > >  tested and debugged, then we can look at the latency-hiding side of
> > > >  the cache.  I think this should still use the stripe_cache - just
> > > >  schedule the writes to the log a bit earlier.
> > > >  If a case can be made for a separate cache then I'm not completely
> > > >  closed to the idea but I don't really want to think about it until the
> > > >  write-hole closing code is done.
> > > > 
> > > > So:
> > > >   [PATCH V4 01/13] MD: add a new disk role to present cache device
> > > >     probably OK
> > > >   [PATCH V4 02/13] raid5: directly use mddev->queue
> > > >     OK
> > > >   [PATCH V4 03/13] raid5: cache log handling
> > > >     strip this down to a bare minimum.  It needs:
> > > >       -on-disk metadata block format
> > > >       -two or three active transactions which identify a list of bios
> > > >        that are currently in the stripe cache.  As the bio is added,
> > > >        its address info is added to the metadata block.
> > > >       -interface to "add a bio to a transaction" and "record a
> > > >        completed stripe".
> > > >       -timer flush the current transaction if previous one was not
> > > >        empty.
> > > > 
> > > >      I don't think there needs to be a separate superblock in the log.
> > > >      Each device in the array already has an 'md' superblock.  Use e.g
> > > >      the 'recovery_offset' field in there (which is per-device and
> > > >      meaningless for a log) to store the address of the most recent
> > > >      metadata blocks at the time the superblock was written.  Search
> > > >      forward and backward from there to find whole log.  Each metadata
> > > >      block holds everything else that might be useful.
> > > > 
> > > >   [PATCH V4 05/13] raid5: cache reclaim support
> > > >     Just want the "hijack ops_run_io" part of this so that when normal
> > > >     RAID5 processing wants to write a stripe, blocks get diverted to
> > > >     the log first and further processing of the stripe is delayed until
> > > >     those writes complete and the transaction is safe.
> > > > 
> > > >   [PATCH V4 08/13] raid5: cache recovery support
> > > >     Just load all the log into the stripe cache.
> > > > 
> > > > 
> > > > That should be much more manageable and would be a good start towards
> > > > getting all the functionality that you want.
> > > > 
> > > > Feel free to ask questions if I haven't explained things, or if you
> > > > want me to look over the metadata format or whatever.  I tend to answer
> > > > direct questions more quickly than I answer 100kB patchsets :-)
> > > Hi,
> > > 
> > > So we are back to the original point (eg, only fix the write hole issue) after
> > > 3 months development, which is really disappointed. I don't object just fixing
> > > the write hole issue as a start, it's simple which is my arguement of first
> > > post too, and probably a slight change of patch 3 meets the goal. The cache
> > > does significantly increase complexity, which is well known when we move from
> > > 'just fix write hole' to 'fix write hole and do cache'. But the code is right
> > > there, I'm wondering how bad it is. Just because of stripe_cache? I don't see
> > > any significant technical merit stripe_cache is a must-have here. You said the
> > > code is complex. Yes, it is, but it's not because of the new data cache. It's a
> > > simple radix tree and takes less than 20% of the total code. The remaining code
> > > does what any log device should do (write to log, reclaim when log is full,
> > > recovery when log crash). Similar things must be done even stripe_cache is
> > > used. And if we don't use stripe_cache, we don't deeply couple with current
> > > state machine, the new data cache actually brings flexibility (for example, we
> > > can choose not using cache, or we can easily put the cache to NVRAM).
> > 
> > I don't think we are completely back to the start.  The product of
> > recent months isn't just code - it is also your understanding and
> > expertise.   You've explored the problems and understand them.  You
> > could quickly see issues because you have struggled with them already.
> > 
> > I think the principal of "write one to throw away" is a good one - and
> > probably one we don't apply often enough.  The first time you implement
> > something you don't really know what you are doing, so the result is
> > bound to be imperfect.  The second time you have a much better idea of
> > the big picture.
> > 
> > The real big problem that I have with the current proposal is that I
> > just don't understand it.  Maybe that is my failing.  But all the
> > evidence suggests that I'll end up needing to maintain it, so I *have*
> > to understand it.
> > 
> > But let's not assume we are throwing everything away (but equally not
> > promise that we won't) and start with just the first (non trivial)
> > patch.  The log.
> > 
> > I think we do want a log.  I think you have identified the key
> > functionality that the log must provide.  But I think the current
> > layout is too complex.  This is something that will be persistent on
> > storage devices, so we want to get it as "right" as we can, early.
> > It is fairly cheap to throw away a log and start a new one, so fixing
> > design mistakes isn't too hard.  But we do have to support any format
> > we create indefinitely.
> > So simple is best.  Simple is most extensible.
> > 
> > As I said: A single metadata block format, with:
> >  - forward/backward linkage - and probably a link to the "first" block
> >    in the log at the time of writing
> >  - array state data - brieifly
> >  - list of data/parity block addresses and maybe checksums
> >  - list of "completed" stripes
> > 
> > The log is simply these metadata blocks mixed with the data/parity they
> > they describe.
> > Each metadata block commits all previous transactions (or maybe all but
> > the most recent).
> > The current md superblock contains the address of one of these metadata
> > blocks.
> > 
> > Does that seem reasonable?  Does that seem simpler than what you had?
> > Will that meet your perceived need?  It meets mine.
> > If we can do that, I'll apply it and we can move on to the next step.
> 
> My original layout has 3 types of blocks: super block, metadata block for data/parity,
> flush block to list completed stripes.
> 
> Compared to your single metadata block format, your format
> - delete super block. I'm fine with this. The only useful bits in my
>   super block is log tail and seq. we can overload MD superblock
>   recovery_offset/resync_offset to record seq/log tail.
> - merge metadata block and flush block to one metadata block. That is
>   the new metadata block can record a mix of data/parity/'completed'
>   stripes. I don't object to this, it's doable, but don't think this
>   makes things simpler.
> 
> If you insist, we can take this one. The new metadata block can record a
> mix of data/parity/completed stripes, but it can also just record data
> or completed stripes. So I'll change the disk format to cater this, but
> I'll always put 'completed stripes' info into a separate metadata block
> (that is not mixing with data/parity, but we still just have one
> metadata type). That way I only need slight change of current code and
> it works for the new format. We can, if necessary, let the new metadata
> records any mix of data/parity/completed stripes later. Sounds good?

Yes it does.  Having a single sort of metadata block is an important
part of the goal.  How the code actually chooses to use these is a
separate issue that can change harmlessly.

There is also the issue of what action commits a previous transaction.
I'm not sure what you had.  I'm suggesting that each metadata block
commits previous transactions.  Is that a close-enough match to what
you had?

Thanks,
NeilBrown
