From: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Subject: [PATCH 2/5] raid5: copy write hint from origin bio to stripe
Date: Fri,  2 Feb 2018 14:50:36 +0100
Message-ID: <20180202135039.32086-3-mariusz.dabrowski@intel.com>
References: <20180202135039.32086-1-mariusz.dabrowski@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180202135039.32086-1-mariusz.dabrowski@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Mariusz Dabrowski <mariusz.dabrowski@intel.com>
List-Id: linux-raid.ids

Store write hint from original bio in stripe head so it can be assigned to
bio sent to each RAID device.

Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 drivers/md/raid5.c | 6 ++++++
 drivers/md/raid5.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 50d01144b805..bd99f1651b66 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1139,6 +1139,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_iter.bi_size = STRIPE_SIZE;
+			bi->bi_write_hint = sh->dev[i].write_hint;
+			if (!rrdev)
+				sh->dev[i].write_hint = 0;
 			/*
 			 * If this is discard request, set bi_vcnt 0. We don't
 			 * want to confuse SCSI because SCSI will replace payload
@@ -1190,6 +1193,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			rbi->bi_io_vec[0].bv_offset = 0;
 			rbi->bi_iter.bi_size = STRIPE_SIZE;
+			rbi->bi_write_hint = sh->dev[i].write_hint;
+			sh->dev[i].write_hint = 0;
 			/*
 			 * If this is discard request, set bi_vcnt 0. We don't
 			 * want to confuse SCSI because SCSI will replace payload
@@ -3203,6 +3208,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
 		(unsigned long long)sh->sector);
 
 	spin_lock_irq(&sh->stripe_lock);
+	sh->dev[dd_idx].write_hint = bi->bi_write_hint;
 	/* Don't allow new IO added to stripes in batch list */
 	if (sh->batch_head)
 		goto overlap;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 2e6123825095..69686616d2ca 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -257,6 +257,7 @@ struct stripe_head {
 		sector_t	sector;			/* sector of this page */
 		unsigned long	flags;
 		u32		log_checksum;
+		u32		write_hint;
 	} dev[1]; /* allocated with extra space depending of RAID geometry */
 };
 
-- 
2.16.1

