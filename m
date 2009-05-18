From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject: [PATCH 1/6] md: raid0 to compile when MD DEBUG  is on
Date: Tue, 19 May 2009 02:00:04 +0300
Message-ID: <1242687604.21201.7.camel@raz>
References: <20090516115726.14596.58766.stgit@notabene.brown>
	 <20090516115731.14596.16948.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090516115731.14596.16948.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Because of the removal the device list from 
the strips raid0 did not compile with MD_DEBUG flag on.
commit is stacked on top of:
commit 747df02a154401948426050979b061446eadc37e
Author: NeilBrown <neilb@suse.de>
Date:   Sat May 16 21:51:51 2009 +1000

 raid0.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

Signed-off-by: raziebe@gmail.com
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 86249c5..df224ae 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -402,26 +402,29 @@ bad_map:
 	return 0;
 }
 
-static void raid0_status (struct seq_file *seq, mddev_t *mddev)
+static void raid0_status(struct seq_file *seq, mddev_t *mddev)
 {
 #undef MD_DEBUG
 #ifdef MD_DEBUG
 	int j, k, h;
 	char b[BDEVNAME_SIZE];
 	raid0_conf_t *conf = mddev->private;
-
+	sector_t zone_size;
+	sector_t zone_start = 0;
 	h = 0;
 	for (j = 0; j < conf->nr_strip_zones; j++) {
 		seq_printf(seq, "      z%d", j);
 		seq_printf(seq, "=[");
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
 			seq_printf(seq, "%s/", bdevname(
-				conf->strip_zone[j].dev[k]->bdev,b));
-
-		seq_printf(seq, "] ze=%d ds=%d s=%d\n",
-				conf->strip_zone[j].zone_end,
-				conf->strip_zone[j].dev_start,
-				conf->strip_zone[j].sectors);
+				conf->devlist[k]->bdev, b));
+
+		zone_size  = conf->strip_zone[j].zone_end - zone_start;
+		seq_printf(seq, "] ze=%lld ds=%lld s=%lld\n",
+			(unsigned long long)zone_start>>1,
+			(unsigned long long)conf->strip_zone[j].dev_start>>1,
+			(unsigned long long)zone_size>>1);
+		zone_start = conf->strip_zone[j].zone_end;
 	}
 #endif
 	seq_printf(seq, " %dk chunks", mddev->chunk_size/1024);


