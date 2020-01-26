From: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Subject: [PATCH 2/2] md: enable io polling
Date: Sat, 25 Jan 2020 21:41:38 -0700
Message-ID: <20200126044138.5066-3-andrzej.jakowski@linux.intel.com>
References: <20200126044138.5066-1-andrzej.jakowski@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200126044138.5066-1-andrzej.jakowski@linux.intel.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, song@kernel.org
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Andrzej Jakowski <andrzej.jakowski@linux.intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Provide a callback for polling the mddev which in turn polls the active
member devices. Activate it only if all members support polling.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
---
 drivers/md/md.c | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e7c9f398bc6..95173cd4f8fd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5421,6 +5421,27 @@ int mddev_init_writes_pending(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(mddev_init_writes_pending);
 
+static int md_poll(struct request_queue *q, blk_qc_t cookie)
+{
+	struct mddev *mddev = q->queuedata;
+	struct md_rdev *rdev;
+	int ret = 0;
+	int rv;
+
+	rdev_for_each(rdev, mddev) {
+		if (rdev->raid_disk >= 0 && !test_bit(Faulty, &rdev->flags)) {
+			rv = blk_poll(bdev_get_queue(rdev->bdev), cookie, false);
+			if (rv < 0) {
+				ret = rv;
+				break;
+			}
+			ret += rv;
+		}
+	}
+
+	return ret;
+}
+
 static int md_alloc(dev_t dev, char *name)
 {
 	/*
@@ -5485,6 +5506,7 @@ static int md_alloc(dev_t dev, char *name)
 
 	blk_queue_make_request(mddev->queue, md_make_request);
 	blk_set_stacking_limits(&mddev->queue->limits);
+	mddev->queue->bio_poll_fn = md_poll;
 
 	disk = alloc_disk(1 << shift);
 	if (!disk) {
@@ -5789,12 +5811,17 @@ int md_run(struct mddev *mddev)
 
 	if (mddev->queue) {
 		bool nonrot = true;
+		bool poll = true;
 
 		rdev_for_each(rdev, mddev) {
-			if (rdev->raid_disk >= 0 &&
-			    !blk_queue_nonrot(bdev_get_queue(rdev->bdev))) {
-				nonrot = false;
-				break;
+			if (rdev->raid_disk >= 0) {
+				struct request_queue *q;
+
+				q = bdev_get_queue(rdev->bdev);
+				if (!blk_queue_nonrot(q))
+					nonrot = false;
+				if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+					poll = false;
 			}
 		}
 		if (mddev->degraded)
@@ -5803,6 +5830,10 @@ int md_run(struct mddev *mddev)
 			blk_queue_flag_set(QUEUE_FLAG_NONROT, mddev->queue);
 		else
 			blk_queue_flag_clear(QUEUE_FLAG_NONROT, mddev->queue);
+		if (poll)
+			blk_queue_flag_set(QUEUE_FLAG_POLL, mddev->queue);
+		else
+			blk_queue_flag_clear(QUEUE_FLAG_POLL, mddev->queue);
 		mddev->queue->backing_dev_info->congested_data = mddev;
 		mddev->queue->backing_dev_info->congested_fn = md_congested;
 	}
-- 
2.20.1
