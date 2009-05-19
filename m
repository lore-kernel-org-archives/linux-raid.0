From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject: [PATCH 001/009]: have raid0 compile with MD_DEBUG on
Date: Tue, 19 May 2009 19:06:15 +0300
Message-ID: <1242749175.3293.57.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, neilb@suse.de
Cc: yaron <yaronp@bitband.com>, ofer <ofer@bitband.com>
List-Id: linux-raid.ids

Because of the removal the device list from 
the strips raid0 did not compile with MD_DEBUG flag on

 raid0.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

This Commit is stacked on top of:
	commit 747df02a154401948426050979b061446eadc37e
	Author: NeilBrown <neilb@suse.de>
	Date:   Sat May 16 21:51:51 2009 +1000
all the reset of this patch set are on top of this commit
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 86249c5..8049a92 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -402,7 +402,7 @@ bad_map:
 	return 0;
 }
 
-static void raid0_status (struct seq_file *seq, mddev_t *mddev)
+static void raid0_status(struct seq_file *seq, mddev_t *mddev)
 {
 #undef MD_DEBUG
 #ifdef MD_DEBUG
@@ -410,18 +410,24 @@ static void raid0_status (struct seq_file *seq, mddev_t *mddev)
 	char b[BDEVNAME_SIZE];
 	raid0_conf_t *conf = mddev->private;
 
+	sector_t zone_size;
+	sector_t zone_start = 0;
 	h = 0;
+
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
+				conf->devlist[j*mddesk->raid_disks + k]
+						->bdev, b));
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


