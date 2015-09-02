From: Shaohua Li <shli@fb.com>
Subject: [PATCH 6/8] raid5-cache: optimize FLUSH IO with log enabled
Date: Wed, 2 Sep 2015 13:49:49 -0700
Message-ID: <309970755f7a955cf708954de72d4182b98571b7.1441221530.git.shli@fb.com>
References: <cover.1441221530.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1441221530.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

With log enabled, bio is written to raid disks after the bio is settled
down in log disk. The recovery guarantees we can recovery the bio data
from log disk, so we we skip FLUSH IO.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 18 ++++++++++++++++++
 drivers/md/raid5.c       | 10 ++++++++--
 drivers/md/raid5.h       |  1 +
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 5a216ab..27fb513 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -502,6 +502,24 @@ void r5l_write_stripe_run(struct r5l_log *log)
 	mutex_unlock(&log->io_mutex);
 }
 
+int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
+{
+	if (!log)
+		return -ENODEV;
+	/*
+	 * we flush log disk cache first, then write stripe data to raid disks.
+	 * So if bio is finished, the log disk cache is flushed already. The
+	 * recovery guarantees we can recovery the bio from log disk, so we
+	 * don't need to flush again
+	 * */
+	if (bio->bi_iter.bi_size == 0) {
+		bio_endio(bio, 0);
+		return 0;
+	}
+	bio->bi_rw &= ~REQ_FLUSH;
+	return -EAGAIN;
+}
+
 /* This will run after log space is reclaimed */
 static void r5l_run_no_space_stripes(struct r5l_log *log)
 {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b247997..394cdf8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5166,8 +5166,14 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 	bool do_prepare;
 
 	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
-		md_flush_request(mddev, bi);
-		return;
+		int ret = r5l_handle_flush_request(conf->log, bi);
+		if (ret == 0)
+			return;
+		if (ret == -ENODEV) {
+			md_flush_request(mddev, bi);
+			return;
+		}
+		/* ret == -EAGAIN, fallback */
 	}
 
 	md_write_start(mddev, bi);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 7ecd7d4..e6b9a40 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -629,4 +629,5 @@ extern int r5l_write_stripe(struct r5l_log *log, struct stripe_head *head_sh);
 extern void r5l_write_stripe_run(struct r5l_log *log);
 extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
 extern void r5l_stripe_write_finished(struct stripe_head *sh);
+extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
 #endif
-- 
1.8.1

