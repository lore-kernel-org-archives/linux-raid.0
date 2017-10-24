From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 2/4] md-cluster: Suspend writes in RAID10 if within range
Date: Tue, 24 Oct 2017 15:11:51 +0800
Message-ID: <20171024071153.5275-3-gqjiang@suse.com>
References: <20171024071153.5275-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171024071153.5275-1-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

If there is a resync going on, all nodes must suspend
writes to the range. This is recorded in suspend_info
and suspend_list.

If there is an I/O within the ranges of any of the
suspend_info, area_resyncing will return 1.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/raid10.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 61890231972e..5a32f6749d1c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -25,6 +25,7 @@
 #include <linux/seq_file.h>
 #include <linux/ratelimit.h>
 #include <linux/kthread.h>
+#include <linux/sched/signal.h>
 #include <trace/events/block.h>
 #include "md.h"
 #include "raid10.h"
@@ -1294,6 +1295,22 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	sector_t sectors;
 	int max_sectors;
 
+	if ((mddev_is_clustered(mddev) &&
+	     md_cluster_ops->area_resyncing(mddev, WRITE,
+					    bio->bi_iter.bi_sector,
+					    bio_end_sector(bio)))) {
+		DEFINE_WAIT(w);
+		for (;;) {
+			prepare_to_wait(&conf->wait_barrier,
+					&w, TASK_IDLE);
+			if (!md_cluster_ops->area_resyncing(mddev, WRITE,
+				 bio->bi_iter.bi_sector, bio_end_sector(bio)))
+				break;
+			schedule();
+		}
+		finish_wait(&conf->wait_barrier, &w);
+	}
+
 	/*
 	 * Register the new request and wait if the reconstruction
 	 * thread has put up a bar for new requests.
-- 
2.10.0

