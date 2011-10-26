From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 12/16] md/raid5: detect and handle replacements during
 recovery.
Date: Wed, 26 Oct 2011 12:43:01 +1100
Message-ID: <20111026014301.21110.42894.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

During recovery we want to write to the replacement but not
the original.  So we have two new flags
 - R5_NeedReplace if this stripe has a replacement that needs to
   be written at some state
 - R5_WantReplace if NeedReplace, and the data is available, and
   a 'sync' has been requested on this stripe.

We also distinguish between 'sync and replace' which need to read
all other devices, and 'replace' which only needs to read the
devices being replaced.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |  120 +++++++++++++++++++++++++++++++++++++++-------------
 drivers/md/raid5.h |   13 +++++-
 2 files changed, 103 insertions(+), 30 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4ba4b8c..08f388c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -491,6 +491,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	for (i = disks; i--; ) {
 		int rw;
+		int replace_only = 0;
 		struct bio *bi, *rbi;
 		struct md_rdev *rdev, *rrdev = NULL;
 		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags)) {
@@ -500,7 +501,10 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				rw = WRITE;
 		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
 			rw = READ;
-		else
+		else if (test_and_clear_bit(R5_WantReplace, &sh->dev[i].flags)) {
+			rw = WRITE;
+			replace_only = 1;
+		} else
 			continue;
 
 		bi = &sh->dev[i].req;
@@ -516,10 +520,15 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 		rcu_read_lock();
 		rdev = rcu_dereference(conf->disks[i].rdev);
-		if (rw & WRITE)
-			rrdev = rcu_dereference(conf->disks[i].replacement);
-		else if (test_bit(R5_ReadRepl, &sh->dev[i].flags))
-			rdev = rcu_dereference(conf->disks[i].replacement);
+		rrdev = rcu_dereference(conf->disks[i].replacement);
+		if (rw & WRITE) {
+			if (replace_only)
+				rdev = NULL;
+		} else {
+			if (test_bit(R5_ReadRepl, &sh->dev[i].flags))
+				rdev = rrdev;
+			rrdev = NULL;
+		}
 
 		if (rdev && test_bit(Faulty, &rdev->flags))
 			rdev = NULL;
@@ -563,7 +572,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		}
 
 		if (rdev) {
-			if (s->syncing || s->expanding || s->expanded)
+			if (s->syncing || s->expanding || s->expanded
+			    || s->replacing)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
@@ -585,7 +595,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			generic_make_request(bi);
 		}
 		if (rrdev) {
-			if (s->syncing || s->expanding || s->expanded)
+			if (s->syncing || s->expanding || s->expanded
+			    || s->replacing)
 				md_sync_acct(rrdev->bdev, STRIPE_SECTORS);
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
@@ -2431,8 +2442,9 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
 	md_done_sync(conf->mddev, STRIPE_SECTORS, 0);
 	clear_bit(STRIPE_SYNCING, &sh->state);
 	s->syncing = 0;
+	s->replacing = 0;
 	/* There is nothing more to do for sync/check/repair.
-	 * For recover we need to record a bad block on all
+	 * For recover/replace we need to record a bad block on all
 	 * non-sync devices, or abort the recovery
 	 */
 	if (!test_bit(MD_RECOVERY_RECOVER, &conf->mddev->recovery))
@@ -2442,12 +2454,18 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
 	 */
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = conf->disks[i].rdev;
-		if (!rdev
-		    || test_bit(Faulty, &rdev->flags)
-		    || test_bit(In_sync, &rdev->flags))
-			continue;
-		if (!rdev_set_badblocks(rdev, sh->sector,
-					STRIPE_SECTORS, 0))
+		if (rdev
+		    && !test_bit(Faulty, &rdev->flags)
+		    && !test_bit(In_sync, &rdev->flags)
+		    && !rdev_set_badblocks(rdev, sh->sector,
+					   STRIPE_SECTORS, 0))
+			abort = 1;
+		rdev = conf->disks[i].replacement;
+		if (rdev
+		    && !test_bit(Faulty, &rdev->flags)
+		    && !test_bit(In_sync, &rdev->flags)
+		    && !rdev_set_badblocks(rdev, sh->sector,
+					   STRIPE_SECTORS, 0))
 			abort = 1;
 	}
 	if (abort) {
@@ -2456,6 +2474,21 @@ handle_failed_sync(struct r5conf *conf, struct stripe_head *sh,
 	}
 }
 
+static int want_replace(struct stripe_head *sh, int disk_idx)
+{
+	struct md_rdev *rdev;
+	int rv = 0;
+	/* Doing recovery so rcu locking not required */
+	rdev = sh->raid_conf->disks[disk_idx].replacement;
+	if (rdev &&
+	    !test_bit(Faulty, &rdev->flags) &&
+	    !test_bit(In_sync, &rdev->flags) &&
+	    rdev->recovery_offset <= sh->sector)
+		rv = 1;
+
+	return rv;
+}
+
 /* fetch_block - checks the given member device to see if its data needs
  * to be read or computed to satisfy a request.
  *
@@ -2475,6 +2508,7 @@ static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
 	    (dev->toread ||
 	     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
 	     s->syncing || s->expanding ||
+	     (s->replacing && want_replace(sh, disk_idx)) ||
 	     (s->failed >= 1 && fdev[0]->toread) ||
 	     (s->failed >= 2 && fdev[1]->toread) ||
 	     (sh->raid_conf->level <= 5 && s->failed && fdev[0]->towrite &&
@@ -3028,22 +3062,18 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 	}
 }
 
-
 /*
  * handle_stripe - do things to a stripe.
  *
- * We lock the stripe and then examine the state of various bits
- * to see what needs to be done.
+ * We lock the stripe by setting STRIPE_ACTIVE and then examine the
+ * state of various bits to see what needs to be done.
  * Possible results:
- *    return some read request which now have data
- *    return some write requests which are safely on disc
+ *    return some read requests which now have data
+ *    return some write requests which are safely on storage
  *    schedule a read on some buffers
  *    schedule a write of some buffers
  *    return confirmation of parity correctness
  *
- * buffers are taken off read_list or write_list, and bh_cache buffers
- * get BH_Lock set before the stripe lock is released.
- *
  */
 
 static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
@@ -3052,10 +3082,10 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 	int disks = sh->disks;
 	struct r5dev *dev;
 	int i;
+	int do_recovery = 0;
 
 	memset(s, 0, sizeof(*s));
 
-	s->syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	s->expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	s->expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	s->failed_num[0] = -1;
@@ -3073,7 +3103,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		dev = &sh->dev[i];
 
 		pr_debug("check %d: state 0x%lx read %p write %p written %p\n",
-			i, dev->flags, dev->toread, dev->towrite, dev->written);
+			 i, dev->flags, dev->toread, dev->towrite, dev->written);
 		/* maybe we can reply to a read
 		 *
 		 * new wantfill requests are only permitted while
@@ -3114,6 +3144,8 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 				 &first_bad, &bad_sectors))
 			set_bit(R5_ReadRepl, &dev->flags);
 		else {
+			if (rdev)
+				set_bit(R5_NeedReplace, &dev->flags);
 			rdev = rcu_dereference(conf->disks[i].rdev);
 			clear_bit(R5_ReadRepl, &dev->flags);
 		}
@@ -3193,9 +3225,25 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 			if (s->failed < 2)
 				s->failed_num[s->failed] = i;
 			s->failed++;
+			if (rdev && !test_bit(Faulty, &rdev->flags))
+				do_recovery = 1;
 		}
 	}
 	spin_unlock_irq(&conf->device_lock);
+	if (test_bit(STRIPE_SYNCING, &sh->state)) {
+		/* If there is a failed device being replaced,
+		 *     we must be recovering.
+		 * else if we are after recovery_cp, we must be syncing
+		 * else we can only be replacing
+		 * sync and recovery both need to read all devices, and so
+		 * use the same flag.
+		 */
+		if (do_recovery ||
+		    sh->sector >= conf->mddev->recovery_cp)
+			s->syncing = 1;
+		else
+			s->replacing = 1;
+	}
 	rcu_read_unlock();
 }
 
@@ -3237,7 +3285,7 @@ static void handle_stripe(struct stripe_head *sh)
 
 	if (unlikely(s.blocked_rdev)) {
 		if (s.syncing || s.expanding || s.expanded ||
-		    s.to_write || s.written) {
+		    s.replacing || s.to_write || s.written) {
 			set_bit(STRIPE_HANDLE, &sh->state);
 			goto finish;
 		}
@@ -3260,7 +3308,7 @@ static void handle_stripe(struct stripe_head *sh)
 	 */
 	if (s.failed > conf->max_degraded && s.to_read+s.to_write+s.written)
 		handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
-	if (s.failed > conf->max_degraded && s.syncing)
+	if (s.failed > conf->max_degraded && s.syncing + s.replacing)
 		handle_failed_sync(conf, sh, &s);
 
 	/*
@@ -3290,7 +3338,9 @@ static void handle_stripe(struct stripe_head *sh)
 	 */
 	if (s.to_read || s.non_overwrite
 	    || (conf->level == 6 && s.to_write && s.failed)
-	    || (s.syncing && (s.uptodate + s.compute < disks)) || s.expanding)
+	    || (s.syncing && (s.uptodate + s.compute < disks))
+	    || s.replacing
+	    || s.expanding)
 		handle_stripe_fill(sh, &s, disks);
 
 	/* Now we check to see if any write operations have recently
@@ -3352,7 +3402,20 @@ static void handle_stripe(struct stripe_head *sh)
 			handle_parity_checks5(conf, sh, &s, disks);
 	}
 
-	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
+	if (s.replacing && s.locked == 0
+	    && !test_bit(STRIPE_INSYNC, &sh->state)) {
+		/* Write out to replacement devices where possible */
+		for (i = 0; i < conf->raid_disks; i++)
+			if (test_bit(R5_UPTODATE, &sh->dev[i].flags) &&
+			    test_bit(R5_NeedReplace, &sh->dev[i].flags)) {
+				set_bit(R5_WantReplace, &sh->dev[i].flags);
+				set_bit(R5_LOCKED, &sh->dev[i].flags);
+				s.locked++;
+			}
+		set_bit(STRIPE_INSYNC, &sh->state);
+	}
+	if ((s.syncing || s.replacing) && s.locked == 0 &&
+	    test_bit(STRIPE_INSYNC, &sh->state)) {
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
@@ -4243,7 +4306,6 @@ static inline sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int
 		return sync_blocks * STRIPE_SECTORS; /* keep things rounded to whole stripes */
 	}
 
-
 	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
 
 	sh = get_active_stripe(conf, sector_nr, 0, 1, 0);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index f6faaa1..8d8e139 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -242,7 +242,13 @@ struct stripe_head {
  *     for handle_stripe.
  */
 struct stripe_head_state {
-	int syncing, expanding, expanded;
+	/* 'syncing' means that we need to read all devices, either
+	 * to check/correct parity, or to reconstruct a missing device.
+	 * 'replacing' means we are replacing one or more drives and
+	 * the source is valid at this point so we don't need to
+	 * read all devices, just the replacement targets.
+	 */
+	int syncing, expanding, expanded, replacing;
 	int locked, uptodate, to_read, to_write, failed, written;
 	int to_fill, compute, req_compute, non_overwrite;
 	int failed_num[2];
@@ -284,6 +290,11 @@ enum r5dev_flags {
 	R5_ReadRepl,	/* Will/did read from replacement rather than orig */
 	R5_MadeGoodRepl,/* A bad block on the replacement device has been
 			 * fixed by writing to it */
+	R5_NeedReplace,	/* This device has a replacement which is not
+			 * up-to-date at this stripe. */
+	R5_WantReplace, /* We need to update the replacement, we have read
+			 * data in, and now is a good time to write it out.
+			 */
 };
 
 /*


