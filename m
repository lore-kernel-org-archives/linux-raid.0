From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 1 of 7] Remove md_flush_all
Date: Wed, 08 Sep 2004 12:48:09 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1C4sVF-0005dZ-GD@notabene.cse.unsw.edu.au>
References: <20040908124236.20651.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This isn't needed as each personality defines its own issue_flush_fn

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |   33 ---------------------------------
 1 files changed, 33 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-09-08 11:03:11.000000000 +1000
+++ ./drivers/md/md.c	2004-09-08 11:03:16.000000000 +1000
@@ -197,38 +197,6 @@ static spinlock_t all_mddevs_lock = SPIN
 		tmp = tmp->next;})					\
 		)
 
-int md_flush_mddev(mddev_t *mddev, sector_t *error_sector)
-{
-	struct list_head *tmp;
-	mdk_rdev_t *rdev;
-	int ret = 0;
-
-	/*
-	 * this list iteration is done without any locking in md?!
-	 */
-	ITERATE_RDEV(mddev, rdev, tmp) {
-		request_queue_t *r_queue = bdev_get_queue(rdev->bdev);
-		int err;
-
-		if (!r_queue->issue_flush_fn)
-			err = -EOPNOTSUPP;
-		else
-			err = r_queue->issue_flush_fn(r_queue, rdev->bdev->bd_disk, error_sector);
-
-		if (!ret)
-			ret = err;
-	}
-
-	return ret;
-}
-
-static int md_flush_all(request_queue_t *q, struct gendisk *disk,
-			 sector_t *error_sector)
-{
-	mddev_t *mddev = q->queuedata;
-
-	return md_flush_mddev(mddev, error_sector);
-}
 
 static int md_fail_request (request_queue_t *q, struct bio *bio)
 {
@@ -1757,7 +1725,6 @@ static int do_md_run(mddev_t * mddev)
 	 */
 	mddev->queue->queuedata = mddev;
 	mddev->queue->make_request_fn = mddev->pers->make_request;
-	mddev->queue->issue_flush_fn = md_flush_all;
 
 	mddev->changed = 1;
 	md_new_event();
