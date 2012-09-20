From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 1/2]MD: raid5 trim support
Date: Thu, 20 Sep 2012 18:31:38 +0800
Message-ID: <20120920103138.GA25389@kernel.org>
References: <20120918082511.GA6298@kernel.org>
 <20120920111517.54d05380@notabene.brown>
 <20120920013642.GA6798@kernel.org>
 <20120920114740.7e2c2d1f@notabene.brown>
 <20120920022717.GD6798@kernel.org>
 <20120920135914.63bf9ff4@notabene.brown>
 <20120920042541.GA12704@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120920042541.GA12704@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 20, 2012 at 12:25:41PM +0800, Shaohua Li wrote:
> On Thu, Sep 20, 2012 at 01:59:14PM +1000, NeilBrown wrote:
> > On Thu, 20 Sep 2012 10:27:17 +0800 Shaohua Li <shli@kernel.org> wrote:
> > 
> > in which wrong sectors were trimmed....
> > > 
> > > Ok, just confirmed, delete raid5_compute_sector is ok if I adjust
> > > logical_sector calculation. Here is the new patch.
> > > 
> > 
> > Thanks.  That looks better.  I've applied it with some minor formatting
> > changes.
> > 
> > I then went to look at the follow-up page and .....
> > I count 11 separate places where you test the new flag and possibly memset a
> > page to zero.  This doesn't seem like an improvement to me.
> 
> We do the zero page just before the stripe is hit in cache, which is rare case.
>  
> > Why don't we just mark the page as not up-to-date when we discard it?  That
> > would avoid storing inconsistent data, and would avoid needing to zero pages.
> 
> We need re-read the strip if it's hit in cache, but it's rare case, we don't
> care. So when we clear the up-to-date flag? I saw a lot of places checking
> up-to-date flag in the write path. Need close look to check if there is race.

Alright, appears ok to use the uptodate flag. Here is the new patch.


Subject: MD: raid5 avoid unnecessary zero page for trim

We want to avoid zero discarded dev page, because it's useless for discard.
But if we don't zero it, another read/write hit such page in the cache and will
get inconsistent data.

To avoid zero the page, we don't set R5_UPTODATE flag after construction is
done. In this way, discard write request is still issued and finished, but read
will not hit the page. If the stripe gets accessed soon, we need reread the
stripe, but since the chance is low, the reread isn't a big deal.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-09-20 18:10:38.546836309 +0800
+++ linux/drivers/md/raid5.c	2012-09-20 18:17:50.849399945 +0800
@@ -547,7 +547,7 @@ static void ops_run_io(struct stripe_hea
 				rw = WRITE_FUA;
 			else
 				rw = WRITE;
-			if (test_and_clear_bit(R5_Discard, &sh->dev[i].flags))
+			if (test_bit(R5_Discard, &sh->dev[i].flags))
 				rw |= REQ_DISCARD;
 		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
 			rw = READ;
@@ -1172,11 +1172,9 @@ ops_run_biodrain(struct stripe_head *sh,
 					set_bit(R5_WantFUA, &dev->flags);
 				if (wbi->bi_rw & REQ_SYNC)
 					set_bit(R5_SyncIO, &dev->flags);
-				if (wbi->bi_rw & REQ_DISCARD) {
-					memset(page_address(dev->page), 0,
-						STRIPE_SECTORS << 9);
+				if (wbi->bi_rw & REQ_DISCARD)
 					set_bit(R5_Discard, &dev->flags);
-				} else
+				else
 					tx = async_copy_data(1, wbi, dev->page,
 						dev->sector, tx);
 				wbi = r5_next_bio(wbi, dev->sector);
@@ -1194,7 +1192,7 @@ static void ops_complete_reconstruct(voi
 	int pd_idx = sh->pd_idx;
 	int qd_idx = sh->qd_idx;
 	int i;
-	bool fua = false, sync = false;
+	bool fua = false, sync = false, discard = false;
 
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
@@ -1202,13 +1200,15 @@ static void ops_complete_reconstruct(voi
 	for (i = disks; i--; ) {
 		fua |= test_bit(R5_WantFUA, &sh->dev[i].flags);
 		sync |= test_bit(R5_SyncIO, &sh->dev[i].flags);
+		discard |= test_bit(R5_Discard, &sh->dev[i].flags);
 	}
 
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 
 		if (dev->written || i == pd_idx || i == qd_idx) {
-			set_bit(R5_UPTODATE, &dev->flags);
+			if (!discard)
+				set_bit(R5_UPTODATE, &dev->flags);
 			if (fua)
 				set_bit(R5_WantFUA, &dev->flags);
 			if (sync)
@@ -1252,8 +1252,6 @@ ops_run_reconstruct5(struct stripe_head
 	}
 	if (i >= sh->disks) {
 		atomic_inc(&sh->count);
-		memset(page_address(sh->dev[pd_idx].page), 0,
-			STRIPE_SECTORS << 9);
 		set_bit(R5_Discard, &sh->dev[pd_idx].flags);
 		ops_complete_reconstruct(sh);
 		return;
@@ -1314,10 +1312,6 @@ ops_run_reconstruct6(struct stripe_head
 	}
 	if (i >= sh->disks) {
 		atomic_inc(&sh->count);
-		memset(page_address(sh->dev[sh->pd_idx].page), 0,
-			STRIPE_SECTORS << 9);
-		memset(page_address(sh->dev[sh->qd_idx].page), 0,
-			STRIPE_SECTORS << 9);
 		set_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
 		set_bit(R5_Discard, &sh->dev[sh->qd_idx].flags);
 		ops_complete_reconstruct(sh);
@@ -2775,7 +2769,8 @@ static void handle_stripe_clean_event(st
 		if (sh->dev[i].written) {
 			dev = &sh->dev[i];
 			if (!test_bit(R5_LOCKED, &dev->flags) &&
-				test_bit(R5_UPTODATE, &dev->flags)) {
+			    (test_bit(R5_UPTODATE, &dev->flags) ||
+			     test_and_clear_bit(R5_Discard, &dev->flags))) {
 				/* We can return any write requests */
 				struct bio *wbi, *wbi2;
 				pr_debug("Return write for disc %d\n", i);
@@ -3493,10 +3488,12 @@ static void handle_stripe(struct stripe_
 	if (s.written &&
 	    (s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
 			     && !test_bit(R5_LOCKED, &pdev->flags)
-			     && test_bit(R5_UPTODATE, &pdev->flags)))) &&
+			     && (test_bit(R5_UPTODATE, &pdev->flags) ||
+				 test_bit(R5_Discard, &pdev->flags))))) &&
 	    (s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
 			     && !test_bit(R5_LOCKED, &qdev->flags)
-			     && test_bit(R5_UPTODATE, &qdev->flags)))))
+			     && (test_bit(R5_UPTODATE, &qdev->flags) ||
+				 test_bit(R5_Discard, &qdev->flags))))))
 		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
 
 	/* Now we might consider reading some blocks, either to check/generate
@@ -3523,9 +3520,11 @@ static void handle_stripe(struct stripe_
 		/* All the 'written' buffers and the parity block are ready to
 		 * be written back to disk
 		 */
-		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags));
+		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags) &&
+		       !test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags));
 		BUG_ON(sh->qd_idx >= 0 &&
-		       !test_bit(R5_UPTODATE, &sh->dev[sh->qd_idx].flags));
+		       !test_bit(R5_UPTODATE, &sh->dev[sh->qd_idx].flags) &&
+		       !test_bit(R5_Discard, &sh->dev[sh->qd_idx].flags));
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (test_bit(R5_LOCKED, &dev->flags) &&
