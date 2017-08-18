From: Shaohua Li <shli@kernel.org>
Subject: [PATCH] md/raid0: attach correct cgroup info in bio
Date: Fri, 18 Aug 2017 11:59:07 -0700
Message-ID: <52c757338a50063cb378125e20e87241d8285d11.1503082468.git.shli@fb.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, axboe@kernel.dk
Cc: Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

The discard bio doesn't attach the original bio cgroup info. Normal bio
is cloned, so is fine.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 block/bio.c        | 2 +-
 drivers/md/raid0.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 9a63597aaacc..51189a1d9009 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -2085,7 +2085,7 @@ void bio_clone_blkcg_association(struct bio *dst, struct bio *src)
 	if (src->bi_css)
 		WARN_ON(bio_associate_blkcg(dst, src->bi_css));
 }
-
+EXPORT_SYMBOL_GPL(bio_clone_blkcg_association);
 #endif /* CONFIG_BLK_CGROUP */
 
 static void __init biovec_init_slabs(void)
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 94d9ae9b0fd0..6fb81704aff4 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -539,6 +539,7 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 		    !discard_bio)
 			continue;
 		bio_chain(discard_bio, bio);
+		bio_clone_blkcg_association(discard_bio, bio);
 		if (mddev->gendisk)
 			trace_block_bio_remap(bdev_get_queue(rdev->bdev),
 				discard_bio, disk_devt(mddev->gendisk),
-- 
2.11.0

