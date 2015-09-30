From: Shaohua Li <shli@fb.com>
Subject: [PATCH 3/3] raid5-cache: IO error handling
Date: Wed, 30 Sep 2015 16:15:40 -0700
Message-ID: <e9c915cf18d81f76e122a2533baeb68c56186d8f.1443653794.git.shli@fb.com>
References: <cover.1443653794.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1443653794.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

There are 3 places the raid5-cache dispatches IO. The discard IO error
doesn't matter, so we ignore it. The superblock write IO error can be
handled in MD core. The remaining are log write and flush. When the IO
error happens, we simply fail all raid disks and continue the stripe
state machine. The MD/raid5 core can handle it (for example, mark all
disks faulty, report bio error and so on).

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index afc3b6b..430ce5c 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -223,7 +223,16 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	io->state = state;
 }
 
-/* XXX: totally ignores I/O errors */
+static void r5l_log_io_error(struct r5l_log *log)
+{
+	struct md_rdev *rdev;
+
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, log->rdev->mddev)
+		md_error(log->rdev->mddev, rdev);
+	rcu_read_unlock();
+}
+
 static void r5l_log_endio(struct bio *bio)
 {
 	struct r5l_io_unit *io = bio->bi_private;
@@ -232,6 +241,9 @@ static void r5l_log_endio(struct bio *bio)
 
 	bio_put(bio);
 
+	if (bio->bi_error)
+		r5l_log_io_error(log);
+
 	if (!atomic_dec_and_test(&io->pending_io))
 		return;
 
@@ -594,6 +606,9 @@ static void r5l_log_flush_endio(struct bio *bio)
 	struct r5l_io_unit *io;
 	struct stripe_head *sh;
 
+	if (bio->bi_error)
+		r5l_log_io_error(log);
+
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	list_for_each_entry(io, &log->flushing_ios, log_sibling) {
 		while (!list_empty(&io->stripe_list)) {
@@ -681,6 +696,7 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
 	}
 
+	/* discard IO error really doesn't matter, ignore it */
 	if (log->last_checkpoint < end) {
 		blkdev_issue_discard(bdev,
 				log->last_checkpoint + log->rdev->data_offset,
-- 
2.4.6

