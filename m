From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject:[PATCH 004:013]: dump_zones to print_conf
Date: Wed, 17 Jun 2009 00:53:28 +0300
Message-ID: <1245189208.3478.100.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

rename dump_zones to print_conf. replace arguments to
 fit reshape use

 raid0.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Signed-off-by: razb <raziebe@gmail.com>
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 6160374..6f87db2 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -55,28 +55,28 @@ static int raid0_congested(void *data, int bits)
 /*
  * inform the user of the raid configuration
 */
-static void dump_zones(mddev_t *mddev)
+static void print_conf(raid0_conf_t *conf, int raid_disks, char *name)
 {
 	int j, k, h;
 	sector_t zone_size = 0;
 	sector_t zone_start = 0;
 	char b[BDEVNAME_SIZE];
-	raid0_conf_t *conf = mddev->private;
 	printk(KERN_INFO "******* %s configuration *********",
-		mdname(mddev));
+		name);
 	h = 0;
 	for (j = 0; j < conf->nr_strip_zones; j++) {
 		printk("\nzone%d", j);
 		printk("=[");
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
 			printk("%s/",
-			bdevname(conf->devlist[j*mddev->raid_disks
+			bdevname(conf->devlist[j*raid_disks
 						+ k]->bdev, b));
 
 		zone_size  = conf->strip_zone[j].zone_end - zone_start;
-		printk("]\n\t zone offset=%llukb "
+		printk("]\n\t zone offset=%llukb zone end=%lld "
 				"device offset=%llukb size=%llukb\n",
 			(unsigned long long)zone_start>>1,
+			(unsigned long long)conf->strip_zone[j].zone_end>>1,
 			(unsigned long long)conf->strip_zone[j].dev_start>>1,
 			(unsigned long long)zone_size>>1);
 		zone_start = conf->strip_zone[j].zone_end;
@@ -348,7 +348,7 @@ static int raid0_run(mddev_t *mddev)
 	}
 
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
-	dump_zones(mddev);
+	print_conf(mddev->private, mddev->raid_disks, mdname(mddev));
 	return 0;
 }
 





