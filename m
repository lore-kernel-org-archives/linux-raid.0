From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH V4 00/13] MD: a caching layer for raid5/6
Date: Tue, 7 Jul 2015 22:44:02 -0700
Message-ID: <20150708054344.GA2709238@devbig257.prn2.facebook.com>
References: <cover.1435094582.git.shli@fb.com>
 <20150708115636.6c972269@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150708115636.6c972269@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, Kernel-team@fb.com
List-Id: linux-raid.ids

On Wed, Jul 08, 2015 at 11:56:36AM +1000, NeilBrown wrote:
> 
> Hi,
>  I made some time to look at these this morning - sorry for the delay.
> 
>  Having it all broken down with more complete comments helps a lot -
>  thanks.
> 
>  Unfortunately ... it helps confirm that I really don't like this.  It
>  seems much more complex that it should be.  There certainly are a lot
>  of details that need to be carefully considered, but the result needs
>  to be simpler.
> 
>  A big part of my concern is that you choose to avoid making proper use
>  of the current stripe cache.  Your argument is that it is already
>  too complex.  That is probably true but I don't think you decrease
>  total complexity by adding extra bits on the side that themselves are
>  complex in completely different ways.
> 
>  I would like to start small and keep it as simple as possible.  I
>  think the minimum useful functionality is closing the write-hole.
>  Anything else could be done outside raid5 (e.g. bcache), but the
>  write-hole needs integration.  Once that is closed, it may make sense
>  to add more functionality.
> 
>  To do that we need a log, and it was quite sensible for you to put
>  that first in the list of patches.  So let's start with that.
> 
>  I would like to propose a single metadata block format.  This block
>  includes the general RAID5 parameters (both 'old' and 'new' for when a
>  reshape is happening), it includes linkage to find nearby metadata.
>  It includes a list of the data written after the metadata.  And it
>  includes a list of device-addresses of parity blocks which are now safe
>  on the RAID and so any log content is now ignored.
> 
>  The general mechanism for writing to the log is:
>    - collect a list of bios.  As each arrives update the metadata
>      block with index information.
>    - when ready (there are various triggers) write the metadata block
>      with FLUSH/FUA and write all the data blocks normally.  This
>      metadata block plus data/parity blocks is a 'transaction'.
> 
>  We never trigger a log transaction until all writes for the previous
>  transaction have completed. This means that once the metadata block is
>  safe, all previous data must also be safe.  If this imposes too much
>  waiting we could allow a "double-buffer" approach were each metadata
>  block completes the previous-but-one transaction.
> 
>  When all of the previous writes complete we trigger a new log write
>  if there is an outstanding SYNC write, or maybe an outstanding
>  FLUSH/FUA, but otherwise we wait until the metadata block is full, or
>  some amount of time has passed.
> 
>  This one metadata block serves all of the purposes that you
>  identified.  It records where data is, it commits previous writes, and
>  records which stripes are being written to RAID and which have been
>  fully committed.
> 
>  With that log in place, we add the code to "hijack ops_run_io" to
>  write all dirty blocks from the stripe_head to the cache.  This
>  includes the parity of course.  Immediately that data is safe the
>  write requests can be returned and the data is written the the RAID
>  devices.
> 
>  "Recovery" at boot time simply involves:
>   1. find and load first metadata block
>   2. load the "next" metadata block. If it doesn't exist, stop.
>   3. For each parity/data block listed in current block, get the
>      stripe_head and read the block in.
>   4. For each completed stripe listed, find the stripe_head and
>      invalidate it.
>   5. Make the "next" metadata block the current block and goto 2
>   6. Flush out all dirty data in stripe cache.
> 
> 
>  I think that all of this *needs* to use the stripe_cache.
>  Intercepting normal processing between party computation and writing
>  to the RAID devices must involve the stripe_cache.
> 
>  So this is a "simple" start.   Once this is written and agreed and
>  tested and debugged, then we can look at the latency-hiding side of
>  the cache.  I think this should still use the stripe_cache - just
>  schedule the writes to the log a bit earlier.
>  If a case can be made for a separate cache then I'm not completely
>  closed to the idea but I don't really want to think about it until the
>  write-hole closing code is done.
> 
> So:
>   [PATCH V4 01/13] MD: add a new disk role to present cache device
>     probably OK
>   [PATCH V4 02/13] raid5: directly use mddev->queue
>     OK
>   [PATCH V4 03/13] raid5: cache log handling
>     strip this down to a bare minimum.  It needs:
>       -on-disk metadata block format
>       -two or three active transactions which identify a list of bios
>        that are currently in the stripe cache.  As the bio is added,
>        its address info is added to the metadata block.
>       -interface to "add a bio to a transaction" and "record a
>        completed stripe".
>       -timer flush the current transaction if previous one was not
>        empty.
> 
>      I don't think there needs to be a separate superblock in the log.
>      Each device in the array already has an 'md' superblock.  Use e.g
>      the 'recovery_offset' field in there (which is per-device and
>      meaningless for a log) to store the address of the most recent
>      metadata blocks at the time the superblock was written.  Search
>      forward and backward from there to find whole log.  Each metadata
>      block holds everything else that might be useful.
> 
>   [PATCH V4 05/13] raid5: cache reclaim support
>     Just want the "hijack ops_run_io" part of this so that when normal
>     RAID5 processing wants to write a stripe, blocks get diverted to
>     the log first and further processing of the stripe is delayed until
>     those writes complete and the transaction is safe.
> 
>   [PATCH V4 08/13] raid5: cache recovery support
>     Just load all the log into the stripe cache.
> 
> 
> That should be much more manageable and would be a good start towards
> getting all the functionality that you want.
> 
> Feel free to ask questions if I haven't explained things, or if you
> want me to look over the metadata format or whatever.  I tend to answer
> direct questions more quickly than I answer 100kB patchsets :-)
Hi,

So we are back to the original point (eg, only fix the write hole issue) after
3 months development, which is really disappointed. I don't object just fixing
the write hole issue as a start, it's simple which is my arguement of first
post too, and probably a slight change of patch 3 meets the goal. The cache
does significantly increase complexity, which is well known when we move from
'just fix write hole' to 'fix write hole and do cache'. But the code is right
there, I'm wondering how bad it is. Just because of stripe_cache? I don't see
any significant technical merit stripe_cache is a must-have here. You said the
code is complex. Yes, it is, but it's not because of the new data cache. It's a
simple radix tree and takes less than 20% of the total code. The remaining code
does what any log device should do (write to log, reclaim when log is full,
recovery when log crash). Similar things must be done even stripe_cache is
used. And if we don't use stripe_cache, we don't deeply couple with current
state machine, the new data cache actually brings flexibility (for example, we
can choose not using cache, or we can easily put the cache to NVRAM).

Thanks,
Shaohua
