From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject: PATCH[002:002] md: raid0: dump raid configuration
Date: Thu, 14 May 2009 19:00:09 +0300
Message-ID: <1242316809.11444.15.camel@raz>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
	 <1242297833-13908-2-git-send-email-maan@systemlinux.org>
	 <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name>
	 <20090514121042.GH11504@skl-net.de>
	 <4743925b38e2d64317e0b6d7c8005a29.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4743925b38e2d64317e0b6d7c8005a29.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tell the user how raid0 looks like. 
 raid0.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
Signed-Off-by:raziebe@gmail.com
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 9865316..2ce81d0 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -267,6 +267,29 @@ static int raid0_is_power2_chunk(mddev_t *mddev)
 }
 
 
+static void raid0_dump_zones(mddev_t *mddev)
+{
+	int j, k, h;
+	char b[BDEVNAME_SIZE];
+	raid0_conf_t *conf = mddev_to_conf(mddev);
+	printk(KERN_INFO "***** %s configuration ******",
+		mdname(mddev));
+	h = 0;
+	for (j = 0; j < conf->nr_strip_zones; j++) {
+		printk("\nzone%d", j);
+		printk("=[");
+		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
+			printk("%s/", bdevname(
+				conf->strip_zone[j].dev[k]->bdev, b));
+		printk("]\n\t zone offset=%llu device offset=%llu size=%llukb\n",
+			(unsigned long long)conf->strip_zone[j].zone_start,
+			(unsigned long long)conf->strip_zone[j].dev_start,
+			(unsigned long long)conf->strip_zone[j].sectors>>1);
+	}
+	printk(KERN_INFO "**********************************\n\n");
+}
+
+
 static int raid0_run(mddev_t *mddev)
 {
 	int ret;
@@ -317,6 +340,7 @@ static int raid0_run(mddev_t *mddev)
 	}
 
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
+	raid0_dump_zones(mddev);
 	return 0;
 }
 


