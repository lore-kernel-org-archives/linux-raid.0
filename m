From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 2/3] md/raid5 - avoid deadlocks in get_active_stripe during
	reshape
Date: Tue, 09 Jun 2009 16:39:57 +1000
Message-ID: <20090609063957.11737.91740.stgit@notabene.brown>
References: <20090609063828.11737.65814.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090609063828.11737.65814.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

md has functionality to 'quiesce' and array so that all pending
IO completed and no new IO starts.  This is used to achieve a
stable state before making internal changes.

Currently this quiescing applies equally to normal IO, resync
IO, and reshape IO.
However there is a problem with applying it to reshape IO.
Reshape can have multiple 'stripe_heads' that must be active together.
If the quiesce come between allocating the first and the last of
such a collection, then we deadlock, as the last will not be allocated
until the quiesce is lifted, the quiesce will not be lifted until the
first (which has been allocated) gets used, and that first cannot be
used until the last is allocated.

It is not necessary to inhibit reshape IO when a quiesce is
requested.  Those places in the code that require a full quiesce will
ensure the reshape thread is not running at all.

So allow reshape requests to get access to new stripe_heads without
being blocked by a 'quiesce'.

This only affects in-place reshapes (i.e. where the array does not
grow or shrink) and these are only newly supported.  So this patch is
not needed in earlier kernels.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 75469e6..59f2ec0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -362,7 +362,7 @@ static void raid5_unplug_device(struct request_queue *q);
 
 static struct stripe_head *
 get_active_stripe(raid5_conf_t *conf, sector_t sector,
-		  int previous, int noblock)
+		  int previous, int noblock, int noquiesce)
 {
 	struct stripe_head *sh;
 
@@ -372,7 +372,7 @@ get_active_stripe(raid5_conf_t *conf, sector_t sector,
 
 	do {
 		wait_event_lock_irq(conf->wait_for_stripe,
-				    conf->quiesce == 0,
+				    conf->quiesce == 0 || noquiesce,
 				    conf->device_lock, /* nothing */);
 		sh = __find_stripe(conf, sector, conf->generation - previous);
 		if (!sh) {
@@ -2671,7 +2671,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 			sector_t bn = compute_blocknr(sh, i, 1);
 			sector_t s = raid5_compute_sector(conf, bn, 0,
 							  &dd_idx, NULL);
-			sh2 = get_active_stripe(conf, s, 0, 1);
+			sh2 = get_active_stripe(conf, s, 0, 1, 1);
 			if (sh2 == NULL)
 				/* so far only the early blocks of this stripe
 				 * have been requested.  When later blocks
@@ -2944,7 +2944,7 @@ static bool handle_stripe5(struct stripe_head *sh)
 	/* Finish reconstruct operations initiated by the expansion process */
 	if (sh->reconstruct_state == reconstruct_state_result) {
 		struct stripe_head *sh2
-			= get_active_stripe(conf, sh->sector, 1, 1);
+			= get_active_stripe(conf, sh->sector, 1, 1, 1);
 		if (sh2 && test_bit(STRIPE_EXPAND_SOURCE, &sh2->state)) {
 			/* sh cannot be written until sh2 has been read.
 			 * so arrange for sh to be delayed a little
@@ -3189,7 +3189,7 @@ static bool handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 
 	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
 		struct stripe_head *sh2
-			= get_active_stripe(conf, sh->sector, 1, 1);
+			= get_active_stripe(conf, sh->sector, 1, 1, 1);
 		if (sh2 && test_bit(STRIPE_EXPAND_SOURCE, &sh2->state)) {
 			/* sh cannot be written until sh2 has been read.
 			 * so arrange for sh to be delayed a little
@@ -3675,7 +3675,7 @@ static int make_request(struct request_queue *q, struct bio * bi)
 			(unsigned long long)logical_sector);
 
 		sh = get_active_stripe(conf, new_sector, previous,
-				       (bi->bi_rw&RWA_MASK));
+				       (bi->bi_rw&RWA_MASK), 0);
 		if (sh) {
 			if (unlikely(previous)) {
 				/* expansion might have moved on while waiting for a
@@ -3873,7 +3873,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	for (i = 0; i < reshape_sectors; i += STRIPE_SECTORS) {
 		int j;
 		int skipped = 0;
-		sh = get_active_stripe(conf, stripe_addr+i, 0, 0);
+		sh = get_active_stripe(conf, stripe_addr+i, 0, 0, 1);
 		set_bit(STRIPE_EXPANDING, &sh->state);
 		atomic_inc(&conf->reshape_stripes);
 		/* If any of this stripe is beyond the end of the old
@@ -3922,7 +3922,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	if (last_sector >= mddev->dev_sectors)
 		last_sector = mddev->dev_sectors - 1;
 	while (first_sector <= last_sector) {
-		sh = get_active_stripe(conf, first_sector, 1, 0);
+		sh = get_active_stripe(conf, first_sector, 1, 0, 1);
 		set_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 		set_bit(STRIPE_HANDLE, &sh->state);
 		release_stripe(sh);
@@ -4022,9 +4022,9 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 
 	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
 
-	sh = get_active_stripe(conf, sector_nr, 0, 1);
+	sh = get_active_stripe(conf, sector_nr, 0, 1, 0);
 	if (sh == NULL) {
-		sh = get_active_stripe(conf, sector_nr, 0, 0);
+		sh = get_active_stripe(conf, sector_nr, 0, 0, 0);
 		/* make sure we don't swamp the stripe cache if someone else
 		 * is trying to get access
 		 */
@@ -4086,7 +4086,7 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 			/* already done this stripe */
 			continue;
 
-		sh = get_active_stripe(conf, sector, 0, 1);
+		sh = get_active_stripe(conf, sector, 0, 1, 0);
 
 		if (!sh) {
 			/* failed to get a stripe - must wait */


