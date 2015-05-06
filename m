From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/5] raid5: directly use mddev->queue
Date: Wed, 6 May 2015 16:57:12 -0700
Message-ID: <f60934f270116a58e7100aafbe4e73524f3a0861.1430954848.git.shli@fb.com>
References: <cover.1430954848.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1430954848.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

When the cache layer flushes data from cache disk to raid disks, it will
dipsatch IO to raid disks. At that time, we don't have a block device
attached to the bio, so directly use mddev->queue. That should not
impact IO dispatched to rdev, which has rdev block device attached.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 77dfd72..950c3c6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -223,7 +223,7 @@ static int raid6_idx_to_slot(int idx, struct stripe_head *sh,
 	return slot;
 }
 
-static void return_io(struct bio *return_bi)
+static void return_io(struct r5conf *conf, struct bio *return_bi)
 {
 	struct bio *bi = return_bi;
 	while (bi) {
@@ -231,8 +231,7 @@ static void return_io(struct bio *return_bi)
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
 		bi->bi_iter.bi_size = 0;
-		trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
-					 bi, 0);
+		trace_block_bio_complete(conf->mddev->queue, bi, 0);
 		bio_endio(bi, 0);
 		bi = return_bi;
 	}
@@ -1193,7 +1192,7 @@ static void ops_complete_biofill(void *stripe_head_ref)
 	}
 	clear_bit(STRIPE_BIOFILL_RUN, &sh->state);
 
-	return_io(return_bi);
+	return_io(sh->raid_conf, return_bi);
 
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
@@ -4563,7 +4562,7 @@ static void handle_stripe(struct stripe_head *sh)
 			md_wakeup_thread(conf->mddev->thread);
 	}
 
-	return_io(s.return_bi);
+	return_io(conf, s.return_bi);
 
 	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
 }
@@ -5267,8 +5266,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 		if ( rw == WRITE )
 			md_write_end(mddev);
 
-		trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
-					 bi, 0);
+		trace_block_bio_complete(mddev->queue, bi, 0);
 		bio_endio(bi, 0);
 	}
 }
-- 
1.8.1

