From: Shaohua Li <shli@fb.com>
Subject: Re: [RFC] raid5: add a log device to fix raid5/6 write hole issue
Date: Wed, 1 Apr 2015 21:07:50 -0700
Message-ID: <20150402040749.GA4025688@devbig257.prn2.facebook.com>
References: <20150330222459.GA575371@devbig257.prn2.facebook.com>
 <20150402085312.5ea3d518@notabene.brown>
 <20150401234055.GA3375744@devbig257.prn2.facebook.com>
 <20150402111941.104d0633@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150402111941.104d0633@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org, songliubraving@fb.com, Kernel-team@fb.com
List-Id: linux-raid.ids

On Thu, Apr 02, 2015 at 11:19:41AM +1100, NeilBrown wrote:
> On Wed, 1 Apr 2015 16:40:57 -0700 Shaohua Li <shli@fb.com> wrote:
> 
> 
> > >  Your code does avoid write-hole-protection for fill-stripe-writes, and this
> > >  would greatly reduce the  number of block that were written multiple times.
> > >  However I'm not convinced that is correct.
> > >  A reasonable  goal is that if the system crashes while writing to a storage
> > >  device, then reads should return the old data or not new data, not anything
> > >  else.  A crash in the middle of a full-stripe-write to a degraded array
> > >  could result in some block in the stripe appearing to contain data that is
> > >  different to both the old and the new.  If you are going to close the whole,
> > >  I think it should be done properly.
> > 
> > I can do it simpley. But don't think this assumption is true. If you
> > write to a disk range and there is failure, there is nothing guarantee
> > you can either read old data or new data.
> 
> If you write a range of blocks to a normal disk and crash during the write,
> each block will contain either the old data or the new data.
> If you write a range to a degraded RAID5 and crash during the write, you
> cannot make that same guarantee.
> I don't know how important this is, but then I don't really know how
> important any of this is.
> 
> > 
> > > 
> > >  A combined log would "simply" involve writing every data block and  every
> > >  compute parity block (with index information) to the log device.
> > >  Replaying the log would collect data blocks and flush out those in a stripe
> > >  once the parity block(s) for that stripe became available.
> > > 
> > >  I think this would actually turn into a fairly simple logging mechanism.
> > 
> > It's not simple at all. It's unlikely we write data and parity
> > continuously in disk and in the same time. This will make log checkpoint
> > fairly complex.
> 
> I don't see any cause for complexity.  Let me be more explicit.
> 
> I imagine that all data remains in the stripe cache, in memory, until it is
> finally written to the RAID5.  So the stripe cache will need to be quite a
> bit bigger.
> 
> Every time we get a block that we want to write, either a new data block or a
> a computed parity block, we queue it to the log.
> 
> The log works like this:
>  - take the first (e.g.) 256 blocks in the queue, create a header to describe
>    them, write the header with FUA, then write all the data blocks.  If there
>    are fewer than 256, just write what we have.
>  - when the header write completes, all blocks written *previously* are now
>    safe and we can call bio_end_io on data or unlock the stripe for parity.
>  - loop back and write some more blocks.  If there are no blocks to write,
>    write a header which describes an empty set of blocks, and wait for more
>    blocks to appear.

Ok, this is similar.

> Each stripe_head needs to track (roughly) where the relevant blocks were
> written so it can release them when the stripe is written.
> I would conceptually divide the log into 32 regions and keep a 32bit number
> with each stripe.  When a block is assigned to a region in the log, the
> relevant bit is set for the stripe, and a per-region counter is incremented.
> When a stripe completes its write, the region counters for all the bits are 
> cleared.  The log cannot progress into a region which has a non-zero counter.

I like this region idea very much. Previously I thought the combined log
is complex because data and parity are not in adjacent disk location,
and can cause fragement, so make checkpoint complex. The region
effectively solves the problem, but a big size region would still have
the fragement issue. We can divide the disk to a lot of equal sized
regions, the region size could be 4k*raid_disks*2 for example. Each
region is a log for exact one stripe. Write will append data to such
log and write is finished. parity append to the log too and then the
region is considered settled down. The downside is meta will use 1
sector even just several bytes are required and this will produce a lot
of small size IO too.

I'm not enthusiastic to use stripe cache though, we can't keep all data
in stripe cache. What we really need is an index.

Thanks,
Shaohua
