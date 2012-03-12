From: Shaohua Li <shli@fusionio.com>
Subject: [patch 6/7] blk: add plug for blkdev_issue_discard
Date: Mon, 12 Mar 2012 11:04:18 +0800
Message-ID: <20120312031305.946211513@fusionio.com>
References: <20120312030412.375458948@fusionio.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=blk-discard-plug.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

In raid 0 case, a big discard request is divided into several small requests
in chunk_size unit. Such requests can be merged in low layer if we have
correct plug added. This should improve the performance a little bit.

raid 10 case doesn't matter, as we dispatch request in a separate thread
and there is plug there.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 block/blk-lib.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/block/blk-lib.c
===================================================================
--- linux.orig/block/blk-lib.c	2012-03-09 16:56:41.043790011 +0800
+++ linux/block/blk-lib.c	2012-03-12 10:21:38.716609525 +0800
@@ -47,6 +47,7 @@ int blkdev_issue_discard(struct block_de
 	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
+	struct blk_plug plug;
 
 	if (!q)
 		return -ENXIO;
@@ -78,6 +79,7 @@ int blkdev_issue_discard(struct block_de
 	bb.flags = 1 << BIO_UPTODATE;
 	bb.wait = &wait;
 
+	blk_start_plug(&plug);
 	while (nr_sects) {
 		bio = bio_alloc(gfp_mask, 1);
 		if (!bio) {
@@ -102,6 +104,7 @@ int blkdev_issue_discard(struct block_de
 		atomic_inc(&bb.done);
 		submit_bio(type, bio);
 	}
+	blk_finish_plug(&plug);
 
 	/* Wait for bios in-flight */
 	if (!atomic_dec_and_test(&bb.done))

