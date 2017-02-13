From: Shaohua Li <shli@fb.com>
Subject: [PATCH --resend 1/2] md: disable WRITE SAME if it fails for linear/raid0
Date: Mon, 13 Feb 2017 11:55:47 -0800
Message-ID: <c98a106b47626695f3b6976b616230da4b638df8.1487015420.git.shli@fb.com>
References: <cover.1487015420.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1487015420.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

This makes md do the same thing as dm for write same IO failure. Please
see 7eee4ae(dm: disable WRITE SAME if it fails) for details why we need
this.

Also reported here: https://bugzilla.kernel.org/show_bug.cgi?id=118581

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/linear.c |  6 +++++-
 drivers/md/md.c     | 45 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h     |  2 ++
 drivers/md/raid0.c  |  6 +++++-
 4 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 26a73b2..bebc834 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -291,7 +291,11 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
 						      split, disk_devt(mddev->gendisk),
 						      bio_sector);
-			generic_make_request(split);
+			if (bio_op(split) == REQ_OP_WRITE_SAME)
+				generic_make_request(md_writesame_setup(mddev,
+								split));
+			else
+				generic_make_request(split);
 		}
 	} while (split != bio);
 	return;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 13020e5..7354f0b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -312,6 +312,51 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 	return BLK_QC_T_NONE;
 }
 
+struct md_writesame_data {
+	struct bio *orig_bio;
+	struct mddev *mddev;
+	struct bio cloned_bio;
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
+	data->orig_bio->bi_error = bio->bi_error;
+	bio_endio(data->orig_bio);
+
+	kfree(data);
+}
+
+struct bio *md_writesame_setup(struct mddev *mddev, struct bio *bio)
+{
+	struct md_writesame_data *data;
+	struct bio *cloned_bio;
+
+	/*
+	 * this failure means we ignore a chance to handle writesame failure,
+	 * which isn't critcal, we can handle the failure if new writesame IO
+	 * comes
+	 */
+	data = kmalloc(sizeof(*data), GFP_NOIO | __GFP_NORETRY);
+	if (!data)
+		return bio;
+	cloned_bio = &data->cloned_bio;
+	data->mddev = mddev;
+	data->orig_bio = bio;
+	bio_init(cloned_bio, NULL, 0);
+	__bio_clone_fast(cloned_bio, bio);
+
+	cloned_bio->bi_private = data;
+	cloned_bio->bi_end_io = md_writesame_endio;
+	return cloned_bio;
+}
+EXPORT_SYMBOL_GPL(md_writesame_setup);
+
 /* mddev_suspend makes sure no new requests are submitted
  * to the device, and that any requests that have been submitted
  * are completely handled.
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2a51403..5c983e9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -710,4 +710,6 @@ static inline void mddev_clear_unsupported_flags(struct mddev *mddev,
 {
 	mddev->flags &= ~unsupported_flags;
 }
+
+extern struct bio *md_writesame_setup(struct mddev *mddev, struct bio *bio);
 #endif /* _MD_MD_H */
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 848365d..e38636e 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -503,7 +503,11 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
 						      split, disk_devt(mddev->gendisk),
 						      bio_sector);
-			generic_make_request(split);
+			if (bio_op(split) == REQ_OP_WRITE_SAME)
+				generic_make_request(md_writesame_setup(mddev,
+							split));
+			else
+				generic_make_request(split);
 		}
 	} while (split != bio);
 }
-- 
2.9.3

