From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 4] md: Define backing_dev_info.congested_fn for raid0 and linear
Date: Tue, 29 Aug 2006 15:39:24 +1000
Message-ID: <1060829053924.6610@suse.de>
References: <20060829153414.6475.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Each backing_dev needs to be able to report whether it is congested,
either by modulating BDI_*_congested in ->state, or by
defining a ->congested_fn.
md/raid did neither of these.  This patch add a congested_fn
which simply checks all component devices to see if they are
congested.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/linear.c |   15 +++++++++++++++
 ./drivers/md/raid0.c  |   17 +++++++++++++++++
 2 files changed, 32 insertions(+)

diff .prev/drivers/md/linear.c ./drivers/md/linear.c
--- .prev/drivers/md/linear.c	2006-08-29 12:17:10.000000000 +1000
+++ ./drivers/md/linear.c	2006-08-29 14:12:26.000000000 +1000
@@ -111,6 +111,19 @@ static int linear_issue_flush(request_qu
 	return ret;
 }
 
+static int linear_congested(void *data, int bits)
+{
+	mddev_t *mddev = data;
+	linear_conf_t *conf = mddev_to_conf(mddev);
+	int i, ret = 0;
+
+	for (i = 0; i < mddev->raid_disks && !ret ; i++) {
+		request_queue_t *q = bdev_get_queue(conf->disks[i].rdev->bdev);
+		ret |= bdi_congested(&q->backing_dev_info, bits);
+	}
+	return ret;
+}
+
 static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 {
 	linear_conf_t *conf;
@@ -269,6 +282,8 @@ static int linear_run (mddev_t *mddev)
 	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
 	mddev->queue->unplug_fn = linear_unplug;
 	mddev->queue->issue_flush_fn = linear_issue_flush;
+	mddev->queue->backing_dev_info.congested_fn = linear_congested;
+	mddev->queue->backing_dev_info.congested_data = mddev;
 	return 0;
 }
 

diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
--- .prev/drivers/md/raid0.c	2006-08-29 12:50:07.000000000 +1000
+++ ./drivers/md/raid0.c	2006-08-29 14:11:49.000000000 +1000
@@ -60,6 +60,21 @@ static int raid0_issue_flush(request_que
 	return ret;
 }
 
+static int raid0_congested(void *data, int bits)
+{
+	mddev_t *mddev = data;
+	raid0_conf_t *conf = mddev_to_conf(mddev);
+	mdk_rdev_t **devlist = conf->strip_zone[0].dev;
+	int i, ret = 0;
+
+	for (i = 0; i < mddev->raid_disks && !ret ; i++) {
+		request_queue_t *q = bdev_get_queue(devlist[i]->bdev);
+
+		ret |= bdi_congested(&q->backing_dev_info, bits);
+	}
+	return ret;
+}
+
 
 static int create_strip_zones (mddev_t *mddev)
 {
@@ -236,6 +251,8 @@ static int create_strip_zones (mddev_t *
 	mddev->queue->unplug_fn = raid0_unplug;
 
 	mddev->queue->issue_flush_fn = raid0_issue_flush;
+	mddev->queue->backing_dev_info.congested_fn = raid0_congested;
+	mddev->queue->backing_dev_info.congested_data = mddev;
 
 	printk("raid0: done.\n");
 	return 0;
