From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 4] md: Add a ->congested_fn function for raid5/6
Date: Tue, 29 Aug 2006 15:39:48 +1000
Message-ID: <1060829053948.6646@suse.de>
References: <20060829153414.6475.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


This is very different from other raid levels and all requests
go through a 'stripe cache', and it has congestion management
already.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-08-29 14:57:09.000000000 +1000
+++ ./drivers/md/raid5.c	2006-08-29 14:57:05.000000000 +1000
@@ -2593,6 +2593,24 @@ static int raid5_issue_flush(request_que
 	return ret;
 }
 
+static int raid5_congested(void *data, int bits)
+{
+	mddev_t *mddev = data;
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+
+	/* No difference between reads and writes.  Just check
+	 * how busy the stripe_cache is
+	 */
+	if (conf->inactive_blocked)
+		return 1;
+	if (conf->quiesce)
+		return 1;
+	if (list_empty_careful(&conf->inactive_list))
+		return 1;
+
+	return 0;
+}
+
 static int make_request(request_queue_t *q, struct bio * bi)
 {
 	mddev_t *mddev = q->queuedata;
@@ -3296,6 +3314,9 @@ static int run(mddev_t *mddev)
 
 	mddev->queue->unplug_fn = raid5_unplug_device;
 	mddev->queue->issue_flush_fn = raid5_issue_flush;
+	mddev->queue->backing_dev_info.congested_fn = raid5_congested;
+	mddev->queue->backing_dev_info.congested_data = mddev;
+
 	mddev->array_size =  mddev->size * (conf->previous_raid_disks -
 					    conf->max_degraded);
 
