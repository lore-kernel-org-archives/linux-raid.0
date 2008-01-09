From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Wed, 09 Jan 2008 11:28:50 -0700
Message-ID: <1199903330.18882.7.camel@dwillia2-linux.ch.intel.com>
References: <alpine.DEB.0.999999.0712270845150.5207@twinlark.arctic.org>
	 <alpine.DEB.0.999999.0712270938160.5207@twinlark.arctic.org>
	 <Pine.LNX.4.64.0712290842530.21114@twinlark.arctic.org>
	 <e9c3a7c20712291247u7d5f6b76gf44a1770f5cdc2cf@mail.gmail.com>
	 <alpine.DEB.0.999999.0712291248490.5207@twinlark.arctic.org>
	 <e9c3a7c20712291406ve91e0d5h72979a8dbc4c6844@mail.gmail.com>
	 <alpine.DEB.0.999999.0712300922520.20553@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.999999.0712300922520.20553@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Sun, 2007-12-30 at 10:58 -0700, dean gaudet wrote:
> On Sat, 29 Dec 2007, Dan Williams wrote:
> 
> > On Dec 29, 2007 1:58 PM, dean gaudet <dean@arctic.org> wrote: 
> > > On Sat, 29 Dec 2007, Dan Williams wrote: 
> > > 
> > > > On Dec 29, 2007 9:48 AM, dean gaudet <dean@arctic.org> wrote: 
> > > > > hmm bummer, i'm doing another test (rsync 3.5M inodes from another box) on 
> > > > > the same 64k chunk array and had raised the stripe_cache_size to 1024... 
> > > > > and got a hang.  this time i grabbed stripe_cache_active before bumping 
> > > > > the size again -- it was only 905 active.  as i recall the bug we were 
> > > > > debugging a year+ ago the active was at the size when it would hang.  so 
> > > > > this is probably something new. 
> > > > 
> > > > I believe I am seeing the same issue and am trying to track down 
> > > > whether XFS is doing something unexpected, i.e. I have not been able 
> > > > to reproduce the problem with EXT3.  MD tries to increase throughput 
> > > > by letting some stripe work build up in batches.  It looks like every 
> > > > time your system has hung it has been in the 'inactive_blocked' state 
> > > > i.e. > 3/4 of stripes active.  This state should automatically 
> > > > clear... 
> > > 
> > > cool, glad you can reproduce it :) 
> > > 
> > > i have a bit more data... i'm seeing the same problem on debian's 
> > > 2.6.22-3-amd64 kernel, so it's not new in 2.6.24. 
> > > 
> > 
> > This is just brainstorming at this point, but it looks like xfs can 
> > submit more requests in the bi_end_io path such that it can lock 
> > itself out of the RAID array.  The sequence that concerns me is: 
> > 
> > return_io->xfs_buf_end_io->xfs_buf_io_end->xfs_buf_iodone_work->xfs_buf_iorequest->make_request-><hang> 
> > 
> > I need verify whether this path is actually triggering, but if we are 
> > in an inactive_blocked condition this new request will be put on a 
> > wait queue and we'll never get to the release_stripe() call after 
> > return_io().  It would be interesting to see if this is new XFS 
> > behavior in recent kernels.
> 
> 
> i have evidence pointing to d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1
> 
> which was Neil's change in 2.6.22 for deferring generic_make_request 
> until there's enough stack space for it.
> 
> with my git tree sync'd to that commit my test cases fail in under 20 
> minutes uptime (i rebooted and tested 3x).  sync'd to the commit previous 
> to it i've got 8h of run-time now without the problem.
> 
> this isn't definitive of course since it does seem to be timing 
> dependent, but since all failures have occured much earlier than that 
> for me so far i think this indicates this change is either the cause of 
> the problem or exacerbates an existing raid5 problem.
> 
> given that this problem looks like a very rare problem i saw with 2.6.18 
> (raid5+xfs there too) i'm thinking Neil's commit may just exacerbate an 
> existing problem... not that i have evidence either way.
> 
> i've attached a new kernel log with a hang at d89d87965d... and the 
> reduced config file i was using for the bisect.  hopefully the hang 
> looks the same as what we were seeing at 2.6.24-rc6.  let me know.
> 

Dean could you try the below patch to see if it fixes your failure
scenario?  It passes my test case.

Thanks,
Dan

------->
md: add generic_make_request_immed to prevent raid5 hang

From: Dan Williams <dan.j.williams@intel.com>

Commit d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1 reduced stack utilization
by preventing recursive calls to generic_make_request.  However the
following conditions can cause raid5 to hang until 'stripe_cache_size' is
increased:

1/ stripe_cache_active is N stripes away from the 'inactive_blocked' limit
   (3/4 * stripe_cache_size)
2/ a bio is submitted that requires M stripes to be processed where M > N
3/ stripes 1 through N are up-to-date and ready for immediate processing,
   i.e. no trip through raid5d required

This results in the calling thread hanging while waiting for resources to
process stripes N through M.  This means we never return from make_request.
All other raid5 users pile up in get_active_stripe.  Increasing
stripe_cache_size temporarily resolves the blockage by allowing the blocked
make_request to return to generic_make_request.

Another way to solve this is to move all i/o submission to raid5d context.

Thanks to Dean Gaudet for bisecting this down to d89d8796.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 block/ll_rw_blk.c      |   16 +++++++++++++---
 drivers/md/raid5.c     |    4 ++--
 include/linux/blkdev.h |    1 +
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 8b91994..bff40c2 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -3287,16 +3287,26 @@ end_io:
 }
 
 /*
- * We only want one ->make_request_fn to be active at a time,
- * else stack usage with stacked devices could be a problem.
+ * In the general case we only want one ->make_request_fn to be active
+ * at a time, else stack usage with stacked devices could be a problem.
  * So use current->bio_{list,tail} to keep a list of requests
  * submited by a make_request_fn function.
  * current->bio_tail is also used as a flag to say if
  * generic_make_request is currently active in this task or not.
  * If it is NULL, then no make_request is active.  If it is non-NULL,
  * then a make_request is active, and new requests should be added
- * at the tail
+ * at the tail.
+ * However, some stacking drivers, like md-raid5, need to submit
+ * the bio without delay when it may not have the resources to
+ * complete its q->make_request_fn.  generic_make_request_immed is
+ * provided for this explicit purpose.
  */
+void generic_make_request_immed(struct bio *bio)
+{
+	__generic_make_request(bio);
+}
+EXPORT_SYMBOL(generic_make_request_immed);
+
 void generic_make_request(struct bio *bio)
 {
 	if (current->bio_tail) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c857b5a..ffa2be4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -450,7 +450,7 @@ static void ops_run_io(struct stripe_head *sh)
 			    test_bit(R5_ReWrite, &sh->dev[i].flags))
 				atomic_add(STRIPE_SECTORS,
 					&rdev->corrected_errors);
-			generic_make_request(bi);
+			generic_make_request_immed(bi);
 		} else {
 			if (rw == WRITE)
 				set_bit(STRIPE_DEGRADED, &sh->state);
@@ -3124,7 +3124,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 			if (rw == WRITE &&
 			    test_bit(R5_ReWrite, &sh->dev[i].flags))
 				atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
-			generic_make_request(bi);
+			generic_make_request_immed(bi);
 		} else {
 			if (rw == WRITE)
 				set_bit(STRIPE_DEGRADED, &sh->state);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d18ee67..774a3a0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -642,6 +642,7 @@ extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 extern void register_disk(struct gendisk *dev);
 extern void generic_make_request(struct bio *bio);
+extern void generic_make_request_immed(struct bio *bio);
 extern void blk_put_request(struct request *);
 extern void __blk_put_request(struct request_queue *, struct request *);
 extern void blk_end_sync_rq(struct request *rq, int error);


