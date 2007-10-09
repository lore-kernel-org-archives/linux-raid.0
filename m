From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH -mm 0/4] raid5: stripe_queue (+20% to +90% write performance)
Date: Tue, 9 Oct 2007 16:21:11 +1000
Message-ID: <18187.7639.638245.949157@notabene.brown>
References: <20071006170538.23741.75193.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Saturday October 6
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday October 6, dan.j.williams@intel.com wrote:
> Neil,
> 
> Here is the latest spin of the 'stripe_queue' implementation.  Thanks to
> raid6+bitmap testing done by Mr. James W. Laferriere there have been
> several cleanups and fixes since the last release.  Also, the changes
> are now spread over 4 patches to isolate one conceptual change per
> patch.  The most significant cleanup is removing the stripe_head back
> pointer from stripe_queue.  This effectively makes the queuing layer
> independent from the caching layer.

Thanks Dan, and sorry that it has taken such a time for me to take a
serious look at this.
The results seem impressive.  I'll try to do some testing myself, but
firstly: some questions.


1/ Can you explain why this improves the performance more than simply
  doubling the size of the stripe cache?

  The core of what it is doing seems to be to give priority to writing
  full stripes.  We already do that by delaying incomplete stripes.
  Maybe we just need to tune that mechanism a bit?  Maybe release
  fewer partial stripes at a time?

  It seems that the whole point of the stripe_queue structure is to
  allow requests to gather before they are processed so the more
  "deserving" can be processed first, but I cannot see why you need a
  data structure separate from the list_head.

  You could argue that simply doubling the size of the stripe cache
  would be a waste of memory as we only want to use half of it to
  handle active requests - the other half is for requests being built
  up.
  In that case, I don't see a problem with having a pool of pages
  which is smaller that would be needed for the full stripe cache, and
  allocating them to stripe_heads as they become free.

2/ I thought I understood from your descriptions that
   raid456_cache_arbiter would normally be waiting for a free stripe,
   that during this time full stripes could get promoted to io_hi, and
   so when raid456_cache_arbiter finally got a free stripe, it would
   attach it to the most deserving stripe_queue.  However it doesn't
   quite do that.  It chooses the deserving stripe_queue *before*
   waiting for a free stripe_head.  This seems slightly less than
   optimal?

3/ Why create a new workqueue for raid456_cache_arbiter rather than
   use raid5d.  It should be possible to do a non-blocking wait for a
   free stripe_head, in which cache the "find a stripe head and attach
   the most deserving stripe_queue" would fit well into raid5d.

4/ Why do you use an rbtree rather than a hash table to index the
  'stripe_queue' objects?  I seem to recall a discussion about this
  where it was useful to find adjacent requests or something like
  that, but I cannot see that in the current code.
  But maybe rbtrees are a better fit, in which case, should we use
  them for stripe_heads as well???

5/ Then again... It seems to me that a stripe_head will always have a
   stripe_queue pointing to it.  In that case we don't need to index
   the stripe_heads at all any more.  Would that be correct?

6/ What is the point of the do/while loop in
   wait_for_cache_attached_queue?  It seems totally superfluous.

That'll do for now.

NeilBrown
