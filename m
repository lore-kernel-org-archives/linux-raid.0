From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 35/54] md/raid5: Adjust 13 checks for null pointers
Date: Thu, 6 Oct 2016 11:35:03 +0200
Message-ID: <8434b567-8ce5-66c9-bda8-c7563ff4862d@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Oct 2016 14:07:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid5.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4debd86..f7a3369 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -679,7 +679,7 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 					set_bit(R5_ALLOC_MORE,
 						&conf->cache_state);
 			}
-			if (noblock && sh == NULL)
+			if (noblock && !sh)
 				break;
 			if (!sh) {
 				set_bit(R5_INACTIVE_BLOCKED,
@@ -719,7 +719,7 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
 			atomic_inc(&sh->count);
 			spin_unlock(&conf->device_lock);
 		}
-	} while (sh == NULL);
+	} while (!sh);
 
 	spin_unlock_irq(conf->hash_locks + hash);
 	return sh;
@@ -2260,7 +2260,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		list_del_init(&nsh->lru);
 
 		for (i=conf->raid_disks; i < newsize; i++)
-			if (nsh->dev[i].page == NULL) {
+			if (!nsh->dev[i].page) {
 				struct page *p = alloc_page(GFP_NOIO);
 				nsh->dev[i].page = p;
 				nsh->dev[i].orig_page = p;
@@ -2977,7 +2977,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
 		goto overlap;
 	if (forwrite) {
 		bip = &sh->dev[dd_idx].towrite;
-		if (*bip == NULL)
+		if (!*bip)
 			firstwrite = 1;
 	} else
 		bip = &sh->dev[dd_idx].toread;
@@ -3962,7 +3962,7 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
 			sector_t s = raid5_compute_sector(conf, bn, 0,
 							  &dd_idx, NULL);
 			sh2 = raid5_get_active_stripe(conf, s, 0, 1, 1);
-			if (sh2 == NULL)
+			if (!sh2)
 				/* so far only the early blocks of this stripe
 				 * have been requested.  When later blocks
 				 * get requested, we will try again
@@ -4094,7 +4094,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		if (rdev) {
 			is_bad = is_badblock(rdev, sh->sector, STRIPE_SECTORS,
 					     &first_bad, &bad_sectors);
-			if (s->blocked_rdev == NULL
+			if (!s->blocked_rdev
 			    && (test_bit(Blocked, &rdev->flags)
 				|| is_bad < 0)) {
 				if (is_bad < 0)
@@ -5044,8 +5044,7 @@ static void release_stripe_plug(struct mddev *mddev,
 	}
 
 	cb = container_of(blk_cb, struct raid5_plug_cb, cb);
-
-	if (cb->list.next == NULL) {
+	if (!cb->list.next) {
 		int i;
 		INIT_LIST_HEAD(&cb->list);
 		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
@@ -5653,7 +5652,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 	bitmap_cond_end_sync(mddev->bitmap, sector_nr, false);
 
 	sh = raid5_get_active_stripe(conf, sector_nr, 0, 1, 0);
-	if (sh == NULL) {
+	if (!sh) {
 		sh = raid5_get_active_stripe(conf, sector_nr, 0, 0, 0);
 		/* make sure we don't swamp the stripe cache if someone else
 		 * is trying to get access
@@ -5668,7 +5667,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 	for (i = 0; i < conf->raid_disks; i++) {
 		struct md_rdev *rdev = ACCESS_ONCE(conf->disks[i].rdev);
 
-		if (rdev == NULL || test_bit(Faulty, &rdev->flags))
+		if (!rdev || test_bit(Faulty, &rdev->flags))
 			still_degraded = 1;
 	}
 	rcu_read_unlock();
@@ -6780,7 +6779,7 @@ static int raid5_run(struct mddev *mddev)
 		BUG_ON(mddev->delta_disks != 0);
 	}
 
-	if (mddev->private == NULL)
+	if (!mddev->private)
 		conf = setup_conf(mddev);
 	else
 		conf = mddev->private;
@@ -7230,12 +7229,12 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	 */
 	if (rdev->saved_raid_disk >= 0 &&
 	    rdev->saved_raid_disk >= first &&
-	    conf->disks[rdev->saved_raid_disk].rdev == NULL)
+	    !conf->disks[rdev->saved_raid_disk].rdev)
 		first = rdev->saved_raid_disk;
 
 	for (disk = first; disk <= last; disk++) {
 		p = conf->disks + disk;
-		if (p->rdev == NULL) {
+		if (!p->rdev) {
 			clear_bit(In_sync, &rdev->flags);
 			rdev->raid_disk = disk;
 			err = 0;
@@ -7248,7 +7247,7 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	for (disk = first; disk <= last; disk++) {
 		p = conf->disks + disk;
 		if (test_bit(WantReplacement, &p->rdev->flags) &&
-		    p->replacement == NULL) {
+		    !p->replacement) {
 			clear_bit(In_sync, &rdev->flags);
 			set_bit(Replacement, &rdev->flags);
 			rdev->raid_disk = disk;
-- 
2.10.1
