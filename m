From: Shaohua Li <shli@kernel.org>
Subject: [patch 1/2]raid5: set bio bi_vcnt 0 for discard request
Date: Sat, 19 Oct 2013 14:50:28 +0800
Message-ID: <20131019065028.GA10670@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com
List-Id: linux-raid.ids


SCSI layer will add new payload for discard request. If two bios are merged
to one, the second bio has bi_vcnt 1 which is set in raid5. This will confuse
SCSI and cause oops.

Suite for backport to 3.7+

Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-10-19 14:10:22.392044663 +0800
+++ linux/drivers/md/raid5.c	2013-10-19 14:10:22.388044717 +0800
@@ -877,6 +877,12 @@ static void ops_run_io(struct stripe_hea
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_size = STRIPE_SIZE;
+			/*
+			 * If this is discard request, set bi_vcnt 0. We don't
+			 * want to confuse SCSI because SCSI will replace payload
+			 */
+			if (rw & REQ_DISCARD)
+				bi->bi_vcnt = 0;
 			if (rrdev)
 				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
 
@@ -915,6 +921,12 @@ static void ops_run_io(struct stripe_hea
 			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			rbi->bi_io_vec[0].bv_offset = 0;
 			rbi->bi_size = STRIPE_SIZE;
+			/*
+			 * If this is discard request, set bi_vcnt 0. We don't
+			 * want to confuse SCSI because SCSI will replace payload
+			 */
+			if (rw & REQ_DISCARD)
+				rbi->bi_vcnt = 0;
 			if (conf->mddev->gendisk)
 				trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
 						      rbi, disk_devt(conf->mddev->gendisk),
