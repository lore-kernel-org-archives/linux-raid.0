From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH -mm 0/4] raid5: stripe_queue (+20% to +90% write
	performance)
Date: Tue, 09 Oct 2007 15:56:04 -0700
Message-ID: <1191970564.26101.134.camel@dwillia2-linux.ch.intel.com>
References: <20071006170538.23741.75193.stgit@dwillia2-linux.ch.intel.com>
	 <18187.7639.638245.949157@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18187.7639.638245.949157@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, babydr@baby-dragons.com
List-Id: linux-raid.ids

On Mon, 2007-10-08 at 23:21 -0700, Neil Brown wrote:
> On Saturday October 6, dan.j.williams@intel.com wrote:
> > Neil,
> >
> > Here is the latest spin of the 'stripe_queue' implementation.
> Thanks to
> > raid6+bitmap testing done by Mr. James W. Laferriere there have been
> > several cleanups and fixes since the last release.  Also, the
> changes
> > are now spread over 4 patches to isolate one conceptual change per
> > patch.  The most significant cleanup is removing the stripe_head
> back
> > pointer from stripe_queue.  This effectively makes the queuing layer
> > independent from the caching layer.
> 
> Thanks Dan, and sorry that it has taken such a time for me to take a
> serious look at this.

Not a problem, I've actually only recently had some cycles to look at
these patches again myself.

> The results seem impressive.  I'll try to do some testing myself, but
> firstly: some questions.

> 1/ Can you explain why this improves the performance more than simply
>   doubling the size of the stripe cache?

Before I answer here are some quick numbers to quantify the difference
versus simply doubling the size of the stripe cache:

Test Configuration:
mdadm --create /dev/md0 /dev/sd[bcdefghi] -n 8 -l 5 --assume-clean
for i in `seq 1 5`; do dd if=/dev/zero of=/dev/md0 bs=1024k count=2048; done

Average rate taken for 2.6.23-rc9 (1), 2.6.23-rc9 with stripe_cache_size
= 512 (2), 2.6.23-rc9+stripe_queue (3), 2.6.23-rc9+stripe_queue with
stripe_cache_size = 512 (4).

(1): 181MB/s
(2): 252MB/s (+41%)
(3): 330MB/s (+82%)
(4): 352MB/s (+94%)

>   The core of what it is doing seems to be to give priority to writing
>   full stripes.  We already do that by delaying incomplete stripes.
>   Maybe we just need to tune that mechanism a bit?  Maybe release
>   fewer partial stripes at a time?

>   It seems that the whole point of the stripe_queue structure is to
>   allow requests to gather before they are processed so the more
>   "deserving" can be processed first, but I cannot see why you need a
>   data structure separate from the list_head.

>   You could argue that simply doubling the size of the stripe cache
>   would be a waste of memory as we only want to use half of it to
>   handle active requests - the other half is for requests being built
>   up.
>   In that case, I don't see a problem with having a pool of pages
>   which is smaller that would be needed for the full stripe cache, and
>   allocating them to stripe_heads as they become free.

I believe the additional performance is coming from the fact that
delayed stripes are no longer consuming cache space while they wait for
their delay condition to clear, *and* that full stripe writes are
explicitly detected and moved to the front of the line.  This
effectively makes delayed stripes wait longer in some cases which is the
overall goal.

> 2/ I thought I understood from your descriptions that
>    raid456_cache_arbiter would normally be waiting for a free stripe,
>    that during this time full stripes could get promoted to io_hi, and
>    so when raid456_cache_arbiter finally got a free stripe, it would
>    attach it to the most deserving stripe_queue.  However it doesn't
>    quite do that.  It chooses the deserving stripe_queue *before*
>    waiting for a free stripe_head.  This seems slightly less than
>    optimal?

I see, get the stripe first and then go look at io_hi versus io_lo.
Yes, that would prevent some unnecessary io_lo requests from sneaking
into the cache.
> 
> 3/ Why create a new workqueue for raid456_cache_arbiter rather than
>    use raid5d.  It should be possible to do a non-blocking wait for a
>    free stripe_head, in which cache the "find a stripe head and attach
>    the most deserving stripe_queue" would fit well into raid5d.

It seemed necessary to have at least one thread doing a blocking wait on
the stripe cache... but moving this all under raid5d seems possible.
And, it might fix the deadlock condition that Jim is able to create in
his testing with bitmaps.  I have sent him a patch, off-list, to move
all bitmap handling to the stripe_queue which seems to improve
bitmap-write performance, but he still sees cases where raid5d() and
raid456_cache_arbiter() are staring blankly at each other while bonnie++
patiently waits in D state.  A kick
to /sys/block/md3/md/stripe_cache_size gets things going again.

> 4/ Why do you use an rbtree rather than a hash table to index the
>   'stripe_queue' objects?  I seem to recall a discussion about this
>   where it was useful to find adjacent requests or something like
>   that, but I cannot see that in the current code.
>   But maybe rbtrees are a better fit, in which case, should we use
>   them for stripe_heads as well???

If you are referring to the following:
http://marc.info/?l=linux-kernel&m=117740314031101&w=2
...then no, I am not caching the leftmost or rightmost entry to speed
lookups.

I initially did not know how many queues would need to be in play versus
stripe_heads to yield a performance advantage so I picked the rbtree
mainly because it was being used in other 'schedulers'.  As far as
implementing an rbtree for stripe_heads I don't have data around whether
it would be a performance win/loss.
> 
> 5/ Then again... It seems to me that a stripe_head will always have a
>    stripe_queue pointing to it.  In that case we don't need to index
>    the stripe_heads at all any more.  Would that be correct?

I actually cleaned up the code to remove that back reference (sq->sh),
but I could put in back for the purpose of not needing two lookup
mechanisms...  I'll investigate.
> 
> 6/ What is the point of the do/while loop in
>    wait_for_cache_attached_queue?  It seems totally superfluous.

Yes, totally superfluous copy and paste error from the
wait_event_lock_irq macro.

I guess you are looking at the latest state of the code in -mm since
wait_for_cache_attached_queue was renamed to wait_for_inactive_cache in
the current patches.

> That'll do for now.
Yes, should be enough for me to chew on for a while.
> 
> NeilBrown
> 

Thanks,
Dan
