From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/4] md: introduce bio_clone_slow_mddev_partial()
Date: Sun,  5 Feb 2017 14:22:11 +0800
Message-ID: <1486275733-7268-3-git-send-email-tom.leiming@gmail.com>
References: <1486275733-7268-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1486275733-7268-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

In raid1/raid10, most users of bio_clone_mddev() need bio_trim() too,
that means only part of the bio is required to be cloned, and not
necessary to clone the whole bio each time, and it is just enough
to clone the specified bvecs range.

So this patch introduces bio_clone_slow_mddev_partial() to improve
the situation, and it is named as slow because the following patch
will switch to bio_clone_fast() in bio_clone_mddev().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/md.c | 16 ++++++++++++++++
 drivers/md/md.h |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4c1b82defa78..704be11355a9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -200,6 +200,22 @@ struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 }
 EXPORT_SYMBOL_GPL(bio_clone_mddev);
 
+struct bio *bio_clone_slow_mddev_partial(struct bio *bio, gfp_t gfp_mask,
+					 struct mddev *mddev, int offset,
+					 int size)
+{
+	struct bio_set *bs;
+
+	if (!mddev || !mddev->bio_set)
+		bs = fs_bio_set;
+	else
+		bs = mddev->bio_set;
+
+	return bio_clone_bioset_partial(bio, gfp_mask, bs, offset << 9,
+					size << 9);
+}
+EXPORT_SYMBOL_GPL(bio_clone_slow_mddev_partial);
+
 /*
  * We have a system wide 'event count' that is incremented
  * on any 'interesting' event, and readers of /proc/mdstat
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 968bbe72b237..4f4e6ded59e5 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -675,6 +675,9 @@ extern void mddev_suspend(struct mddev *mddev);
 extern void mddev_resume(struct mddev *mddev);
 extern struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 				   struct mddev *mddev);
+extern struct bio *bio_clone_slow_mddev_partial(struct bio *bio, gfp_t gfp_mask,
+						struct mddev *mddev, int offset,
+						int size);
 extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
 				   struct mddev *mddev);
 
-- 
2.7.4
