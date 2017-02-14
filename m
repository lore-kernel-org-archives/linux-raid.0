From: Shaohua Li <shli@fb.com>
Subject: [PATCH V2] md: disable WRITE SAME if it fails in underlayer disks
Date: Mon, 13 Feb 2017 16:21:49 -0800
Message-ID: <728f3fb3d63e6c9512a68fe5fdc61812d95aa2bd.1487031632.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

This makes md do the same thing as dm for write same IO failure. Please
see 7eee4ae(dm: disable WRITE SAME if it fails) for details why we need
this.

We did a little bit different than dm. Instead of disabling writesame in
the first IO error, we disable it till next writesame IO coming after
the first IO error. This way we don't need to clone a bio.

Also reported here: https://bugzilla.kernel.org/show_bug.cgi?id=118581

Suggested-by: NeilBrown <neilb@suse.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/linear.c    | 1 +
 drivers/md/md.h        | 7 +++++++
 drivers/md/multipath.c | 1 +
 drivers/md/raid0.c     | 1 +
 4 files changed, 10 insertions(+)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 26a73b2..789008b 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -291,6 +291,7 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
 						      split, disk_devt(mddev->gendisk),
 						      bio_sector);
+			mddev_check_writesame(mddev, split);
 			generic_make_request(split);
 		}
 	} while (split != bio);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2a51403..42f8398 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -710,4 +710,11 @@ static inline void mddev_clear_unsupported_flags(struct mddev *mddev,
 {
 	mddev->flags &= ~unsupported_flags;
 }
+
+static inline void mddev_check_writesame(struct mddev *mddev, struct bio *bio)
+{
+	if (bio_op(bio) == REQ_OP_WRITE_SAME &&
+	    !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
+		mddev->queue->limits.max_write_same_sectors = 0;
+}
 #endif /* _MD_MD_H */
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index aa8c4e5c..065fe28 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -138,6 +138,7 @@ static void multipath_make_request(struct mddev *mddev, struct bio * bio)
 	mp_bh->bio.bi_opf |= REQ_FAILFAST_TRANSPORT;
 	mp_bh->bio.bi_end_io = multipath_end_request;
 	mp_bh->bio.bi_private = mp_bh;
+	mddev_check_writesame(mddev, &mp_bh->bio);
 	generic_make_request(&mp_bh->bio);
 	return;
 }
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 848365d..b3d2644 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -503,6 +503,7 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
 						      split, disk_devt(mddev->gendisk),
 						      bio_sector);
+			mddev_check_writesame(mddev, split);
 			generic_make_request(split);
 		}
 	} while (split != bio);
-- 
2.9.3

