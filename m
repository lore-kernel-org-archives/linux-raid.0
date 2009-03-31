From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 11/14] md/raid5: be more careful about write ordering when
	reshaping.
Date: Tue, 31 Mar 2009 15:54:44 +1100
Message-ID: <20090331045444.2589.28692.stgit@notabene.brown>
References: <20090331044827.2589.95894.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090331044827.2589.95894.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

When we are reshaping an array, it is very important that we read
the data from a particular sector offset before writing new data
at that offset.

In most cases when growing or shrinking an array we read long before
we even consider writing.  But when restriping an array without
changing it size, there is a small possibility that we might have
some data to available write before the read has happened at the same
location.  This would require some stripes to be in cache already.

To guard against this small possibility, we check, before writing,
that the 'old' stripe at the same location is not in the process of
being read.  And we ensure that we mark all 'source' stripes as such
before allowing new 'destination' stripes to proceed.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4fdc6d0..062df84 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -395,7 +395,8 @@ get_active_stripe(raid5_conf_t *conf, sector_t sector,
 				init_stripe(sh, sector, previous);
 		} else {
 			if (atomic_read(&sh->count)) {
-			  BUG_ON(!list_empty(&sh->lru));
+				BUG_ON(!list_empty(&sh->lru)
+				    && !test_bit(STRIPE_EXPANDING, &sh->state));
 			} else {
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
@@ -2944,6 +2945,23 @@ static bool handle_stripe5(struct stripe_head *sh)
 
 	/* Finish reconstruct operations initiated by the expansion process */
 	if (sh->reconstruct_state == reconstruct_state_result) {
+		struct stripe_head *sh2
+			= get_active_stripe(conf, sh->sector, 1, 1);
+		if (sh2 && test_bit(STRIPE_EXPAND_SOURCE, &sh2->state)) {
+			/* sh cannot be written until sh2 has been read.
+			 * so arrange for sh to be delayed a little
+			 */
+			set_bit(STRIPE_DELAYED, &sh->state);
+			set_bit(STRIPE_HANDLE, &sh->state);
+			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE,
+					      &sh2->state))
+				atomic_inc(&conf->preread_active_stripes);
+			release_stripe(sh2);
+			goto unlock;
+		}
+		if (sh2)
+			release_stripe(sh2);
+
 		sh->reconstruct_state = reconstruct_state_idle;
 		clear_bit(STRIPE_EXPANDING, &sh->state);
 		for (i = conf->raid_disks; i--; ) {
@@ -3172,6 +3190,23 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		}
 
 	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
+		struct stripe_head *sh2
+			= get_active_stripe(conf, sh->sector, 1, 1);
+		if (sh2 && test_bit(STRIPE_EXPAND_SOURCE, &sh2->state)) {
+			/* sh cannot be written until sh2 has been read.
+			 * so arrange for sh to be delayed a little
+			 */
+			set_bit(STRIPE_DELAYED, &sh->state);
+			set_bit(STRIPE_HANDLE, &sh->state);
+			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE,
+					      &sh2->state))
+				atomic_inc(&conf->preread_active_stripes);
+			release_stripe(sh2);
+			goto unlock;
+		}
+		if (sh2)
+			release_stripe(sh2);
+
 		/* Need to write out all blocks after computing P&Q */
 		sh->disks = conf->raid_disks;
 		stripe_set_idx(sh->sector, conf, 0, sh);
@@ -3739,6 +3774,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	sector_t writepos, safepos, gap;
 	sector_t stripe_addr;
 	int reshape_sectors;
+	struct list_head stripes;
 
 	if (sector_nr == 0) {
 		/* If restarting in the middle, skip the initial sectors */
@@ -3816,6 +3852,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		BUG_ON(writepos != sector_nr + reshape_sectors);
 		stripe_addr = sector_nr;
 	}
+	INIT_LIST_HEAD(&stripes);
 	for (i = 0; i < reshape_sectors; i += STRIPE_SECTORS) {
 		int j;
 		int skipped = 0;
@@ -3845,7 +3882,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 			set_bit(STRIPE_EXPAND_READY, &sh->state);
 			set_bit(STRIPE_HANDLE, &sh->state);
 		}
-		release_stripe(sh);
+		list_add(&sh->lru, &stripes);
 	}
 	spin_lock_irq(&conf->device_lock);
 	if (mddev->delta_disks < 0)
@@ -3874,6 +3911,14 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		release_stripe(sh);
 		first_sector += STRIPE_SECTORS;
 	}
+	/* Now that the sources are clearly marked, we can release
+	 * the destination stripes
+	 */
+	while (!list_empty(&stripes)) {
+		sh = list_entry(stripes.next, struct stripe_head, lru);
+		list_del_init(&sh->lru);
+		release_stripe(sh);
+	}
 	/* If this takes us to the resync_max point where we have to pause,
 	 * then we need to write out the superblock.
 	 */


