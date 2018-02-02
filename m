From: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Subject: [PATCH 4/5] raid5: set write hint for parity
Date: Fri,  2 Feb 2018 14:50:38 +0100
Message-ID: <20180202135039.32086-5-mariusz.dabrowski@intel.com>
References: <20180202135039.32086-1-mariusz.dabrowski@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180202135039.32086-1-mariusz.dabrowski@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Mariusz Dabrowski <mariusz.dabrowski@intel.com>
List-Id: linux-raid.ids

During sequential workload, if no full-stripe write occurs, each parity
will be written data_disks (raid_disks-max_degraded) times. The lifetime
of the parity written before the data_disks update will be short, so
RWH_WRITE_LIFE_SHORT write hint can be assigned to those writes.

New counter has been added to the stripe_head struct to count number of
parity updates in a stripe. If this counter is equal to data_disks or this
is the full stripe write, a write hint from the original bio is assigned.
Otherwise RWH_WRITE_LIFE_SHORT write hint will be set.

Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 drivers/md/raid5.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/md/raid5.h |  2 ++
 2 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 088b97bbcbe2..1c581b0bbc44 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -978,6 +978,36 @@ static void defer_issue_bios(struct r5conf *conf, sector_t sector,
 	dispatch_bio_list(&tmp);
 }
 
+static void raid5_set_parity_write_hint(struct bio *bio,
+					 struct stripe_head *sh,
+					 int *updates_cnt)
+{
+	enum rw_hint hint = WRITE_LIFE_NOT_SET;
+	struct r5conf *conf = sh->raid_conf;
+	int data_disks = conf->raid_disks - conf->max_degraded;
+
+	if (!test_bit(STRIPE_FULL_WRITE, &sh->state) &&
+	    (++*updates_cnt < data_disks)) {
+		hint = WRITE_LIFE_SHORT;
+	} else {
+		int i;
+
+		for (i = 0; i < sh->disks; i++) {
+			if ((i != sh->pd_idx) && (i != sh->qd_idx)) {
+				if (sh->dev[i].req.bi_write_hint > 0)
+					hint = sh->dev[i].req.bi_write_hint;
+				else if (sh->dev[i].write_hint > 0)
+					hint = sh->dev[i].write_hint;
+				if (hint)
+					break;
+			}
+		}
+
+		*updates_cnt = 0;
+	}
+	bio->bi_write_hint = hint;
+}
+
 static void
 raid5_end_read_request(struct bio *bi);
 static void
@@ -1003,6 +1037,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		int replace_only = 0;
 		struct bio *bi, *rbi;
 		struct md_rdev *rdev, *rrdev = NULL;
+		int sh_syncing = s->syncing || s->expanding ||
+				 s->expanded || s->replacing;
+
 
 		sh = head_sh;
 		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags)) {
@@ -1094,8 +1131,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		}
 
 		if (rdev) {
-			if (s->syncing || s->expanding || s->expanded
-			    || s->replacing)
+			if (sh_syncing)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
@@ -1155,14 +1191,25 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				trace_block_bio_remap(bi->bi_disk->queue,
 						      bi, disk_devt(conf->mddev->gendisk),
 						      sh->dev[i].sector);
+
+			if (op_is_write(op) && !sh_syncing &&
+			    test_bit(WH_POLICY_PARITY,
+				     &conf->write_hint_flags)) {
+				if (i == sh->pd_idx)
+					raid5_set_parity_write_hint(bi, sh,
+							&sh->p_updates);
+				else if (i == sh->qd_idx)
+					raid5_set_parity_write_hint(bi, sh,
+							&sh->q_updates);
+			}
+
 			if (should_defer && op_is_write(op))
 				bio_list_add(&pending_bios, bi);
 			else
 				generic_make_request(bi);
 		}
 		if (rrdev) {
-			if (s->syncing || s->expanding || s->expanded
-			    || s->replacing)
+			if (sh_syncing)
 				md_sync_acct(rrdev->bdev, STRIPE_SECTORS);
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
@@ -1205,6 +1252,18 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				trace_block_bio_remap(rbi->bi_disk->queue,
 						      rbi, disk_devt(conf->mddev->gendisk),
 						      sh->dev[i].sector);
+
+			if (op_is_write(op) && !sh_syncing &&
+			    test_bit(WH_POLICY_PARITY,
+				     &conf->write_hint_flags)) {
+				if (i == sh->pd_idx)
+					raid5_set_parity_write_hint(rbi, sh,
+							&sh->p_updates);
+				else if (i == sh->qd_idx)
+					raid5_set_parity_write_hint(rbi, sh,
+							&sh->q_updates);
+			}
+
 			if (should_defer && op_is_write(op))
 				bio_list_add(&pending_bios, rbi);
 			else
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index e08071dc4202..4a5fa44ffecf 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -219,6 +219,8 @@ struct stripe_head {
 						  * this is only checked when stripe
 						  * has STRIPE_BATCH_READY
 						  */
+	int p_updates;
+	int q_updates;
 	enum check_states	check_state;
 	enum reconstruct_states reconstruct_state;
 	spinlock_t		stripe_lock;
-- 
2.16.1

