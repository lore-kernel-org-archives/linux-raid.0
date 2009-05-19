From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject: [PATCH 005/009]: raid0: chunk size check in raid0_run
Date: Tue, 19 May 2009 19:07:34 +0300
Message-ID: <1242749254.3293.65.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux raid <linux-raid@vger.kernel.org>
Cc: ofer <ofer@bitband.com>, yaron <yaronp@bitband.com>
List-Id: linux-raid.ids

have raid0 check chunk size in run method instead of in md
hardsect is short and chunksize am int, so i can use %.
 raid0.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)
Signed-off-by: raziebe@gmail.com
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index a994169..b92b332 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -236,7 +236,17 @@ static int create_strip_zones(mddev_t *mddev)
 	mddev->queue->unplug_fn = raid0_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid0_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
-
+	/*
+	* now since we have the hard sector sizes, we can make sure
+	* chunk size is a multiple of that sector size
+	* note! mdadm enforced 1K minimum for the chunk size.
+	*/
+	if (mddev->chunk_size % mddev->queue->hardsect_size) {
+		printk(KERN_ERR "%s chunk_size of %d not valid\n",
+				mdname(mddev),
+				mddev->chunk_size);
+		goto abort;
+	}
 	printk(KERN_INFO "raid0: done.\n");
 	mddev->private = conf;
 	return 0;


