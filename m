From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 14/14] MD: use per-cpu counter for writes_pending
Date: Thu, 16 Feb 2017 12:12:11 -0800
Message-ID: <20170216201211.3q7rvvp2p3xxz6ew@kernel.org>
References: <148721992248.7521.17160361058957519076.stgit@noble>
 <148721994322.7521.3431105903303667812.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148721994322.7521.3431105903303667812.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

On Thu, Feb 16, 2017 at 03:39:03PM +1100, Neil Brown wrote:
> The 'writes_pending' counter is used to determine when the
> array is stable so that it can be marked in the superblock
> as "Clean".  Consequently it needs to be updated frequently
> but only checked for zero occasionally.  Recent changes to
> raid5 cause the count to be updated even more often - once
> per 4K rather than once per bio.  This provided
> justification for making the updates more efficient.
> 
> So we replace the atomic counter with a per-cpu array of
> 'long' counters. Incrementing and decrementing is normally
> much cheaper, testing for zero is more expensive.
> 
> To meaningfully be able to test for zero we need to be able
> to block further updates.  This is done by forcing the
> "increment" step to take a spinlock in the rare case that
> another thread is checking if the count is zero.  This is
> done using a new field: "checkers".  "checkers" is the
> number of threads that are currently checking whether the
> count is zero.  It is usually 0, occasionally 1, and it is
> not impossible that it could be higher, though this would be
> rare.
> 
> If, within an rcu_read_locked section, checkers is seen to
> be zero, then the local-cpu counter can be incremented
> freely.  If checkers is not zero, mddev->lock must be taken
> before the increment is allowed.  A decrement is always
> allowed.
> 
> To test for zero, a thread must increment "checkers", call
> synchronize_rcu(), then take mddev->lock.  Once this is done
> no new increments can happen.  A thread may choose to
> perform a quick test-for-zero by summing all the counters
> without holding a lock.  If this is non-zero, the the total
> count is non-zero, or was non-zero very recently, so it is
> safe to assume that it isn't zero.  If the quick check does
> report a zero sum, then it is worth performing the locking
> protocol.
> 
> When the counter is decremented, it is no longer possible to
> immediately test if the result is zero
> (atmic_dec_and_test()).  We don't even really want to
> perform the "quick" tests as that sums over all cpus and is
> work that will most often bring no benefit.
> 
> In the "safemode==2" case, when we want to mark the array as
> "clean" immediately when there are no writes, we perform the
> quick test anyway, and possibly wake the md thread to do the
> full test.  "safemode==2" is only used during shutdown so
> the cost is not problematic.
> 
> When safemode!=2 we always set the timer, rather than only
> when the counter reaches zero.
> 
> If mod_timer() is called to set the timeout to the value it
> already has, mod_timer() has low overhead with no atomic
> operations.  So at worst it will have a noticeable cost once
> per jiffie.  To further reduce the otherhead, we round the
> requests delay to a multiple of ->safemode_delay.  This
> might increase the delay until the timer fires a little, but
> will reduce the overhead of calling mod_timer()
> significantly.  If lots of requests are completing, the
> timer will be updated every 200 milliseconds (by default)
> and never fire.  When it does eventually fire, it will
> schedule the md thread to perform the full test for
> writes_pending==0, and this is quite likely to find '0'.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>

This sounds like a good place to use percpu-refcount. In set_in_sync, we switch
it to atomic, read it, then switch it back to percpu.

Thanks,
Shaohua
