From: Shaohua Li <shli@fb.com>
Subject: [PATCH 1/2] md: disable WRITE SAME if it fails for linear/raid0
Date: Wed, 30 Nov 2016 16:39:11 -0800
Message-ID: <35d7516cdfdcaa734e5b8cc90a8dbac8e3d201e0.1480552575.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: sitsofe@gmail.com, neilb@suse.com
List-Id: linux-raid.ids

This makes md do the same thing as dm for write same IO failure. Please
see 7eee4ae(dm: disable WRITE SAME if it fails) for details why we need
this.

Also reported here: https://bugzilla.kernel.org/show_bug.cgi?id=118581

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/linear.c |  2 ++
 drivers/md/md.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h     |  2 ++
 drivers/md/raid0.c  |  2 ++
 4 files changed, 48 insertions(+)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 5975c99..d3c7b4d 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -262,6 +262,8 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
 						      split, disk_devt(mddev->gendisk),
 						      bio_sector);
+			if (bio_op(split) == REQ_OP_WRITE_SAME)
+				md_writesame_setup(mddev, split);
 			generic_make_request(split);
 		}
 	} while (split != bio);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c7894fb..5e6efcd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -312,6 +312,48 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 	return BLK_QC_T_NONE;
 }
 
+struct md_writesame_data {
+	bio_end_io_t *orig_endio;
+	void *orig_private;
+	struct mddev *mddev;
+};
+
+static void md_writesame_endio(struct bio *bio)
+{
+	struct md_writesame_data *data = bio->bi_private;
+
+	if (bio->bi_error == -EREMOTEIO &&
+	    !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
+		data->mddev->queue->limits.max_write_same_sectors = 0;
+
+	bio->bi_private = data->orig_private;
+	bio->bi_end_io = data->orig_endio;
+	bio_endio(bio);
+
+	kfree(data);
+}
+
+void md_writesame_setup(struct mddev *mddev, struct bio *bio)
+{
+	struct md_writesame_data *data;
+
+	/*
+	 * this failure means we ignore a chance to handle writesame failure,
+	 * which isn't critcal, we can handle the failure if new writesame IO
+	 * comes
+	 */
+	data = kmalloc(sizeof(*data), GFP_NOIO | __GFP_NORETRY);
+	if (!data)
+		return;
+	data->orig_endio = bio->bi_end_io;
+	data->orig_private = bio->bi_private;
+	data->mddev = mddev;
+
+	bio->bi_private = data;
+	bio->bi_end_io = md_writesame_endio;
+}
+EXPORT_SYMBOL_GPL(md_writesame_setup);
+
 /* mddev_suspend makes sure no new requests are submitted
  * to the device, and that any requests that have been submitted
  * are completely handled.
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5c08f84..2d1556b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -700,4 +700,6 @@ static inline int mddev_is_clustered(struct mddev *mddev)
 {
 	return mddev->cluster_info && mddev->bitmap_info.nodes > 1;
 }
+
+extern void md_writesame_setup(struct mddev *mddev, struct bio *bio);
 #endif /* _MD_MD_H */
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e628f18..4811116 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -498,6 +498,8 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
 						      split, disk_devt(mddev->gendisk),
 						      bio_sector);
+			if (bio_op(split) == REQ_OP_WRITE_SAME)
+				md_writesame_setup(mddev, split);
 			generic_make_request(split);
 		}
 	} while (split != bio);
-- 
2.9.3

