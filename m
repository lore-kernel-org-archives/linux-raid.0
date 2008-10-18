From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 3/8] md: raid0: Represent device offset in sectors.
Date: Sat, 18 Oct 2008 17:24:24 +0200
Message-ID: <1224343469-2831-4-git-send-email-maan@systemlinux.org>
References: <1224343469-2831-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1224343469-2831-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Rename zone->dev_offset to zone->dev_start to make sure all users
have been converted.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/raid0.c         |    9 ++++-----
 include/linux/raid/raid0.h |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index fd65d88..b860536 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -167,7 +167,7 @@ static int create_strip_zones (mddev_t *mddev)
 		zone->dev = conf->strip_zone[i-1].dev + mddev->raid_disks;
 
 		printk("raid0: zone %d\n", i);
-		zone->dev_offset = current_offset;
+		zone->dev_start = current_offset * 2;
 		smallest = NULL;
 		c = 0;
 
@@ -452,8 +452,7 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		x = sector >> chunksect_bits;
 		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
 	}
-	rsect = (((chunk << (chunksect_bits - 1)) + zone->dev_offset)<<1)
-		+ sect_in_chunk;
+	rsect = (chunk << chunksect_bits) + zone->dev_start + sect_in_chunk;
  
 	bio->bi_bdev = tmp_dev->bdev;
 	bio->bi_sector = rsect + tmp_dev->data_offset;
@@ -490,9 +489,9 @@ static void raid0_status (struct seq_file *seq, mddev_t *mddev)
 			seq_printf(seq, "%s/", bdevname(
 				conf->strip_zone[j].dev[k]->bdev,b));
 
-		seq_printf(seq, "] zo=%d do=%d s=%d\n",
+		seq_printf(seq, "] zo=%d ds=%d s=%d\n",
 				conf->strip_zone[j].zone_offset,
-				conf->strip_zone[j].dev_offset,
+				conf->strip_zone[j].dev_start,
 				conf->strip_zone[j].size);
 	}
 #endif
diff --git a/include/linux/raid/raid0.h b/include/linux/raid/raid0.h
index 1b2dda0..61c3d29 100644
--- a/include/linux/raid/raid0.h
+++ b/include/linux/raid/raid0.h
@@ -6,7 +6,7 @@
 struct strip_zone
 {
 	sector_t zone_offset;	/* Zone offset in md_dev */
-	sector_t dev_offset;	/* Zone offset in real dev */
+	sector_t dev_start;	/* Zone offset in real dev (in sectors) */
 	sector_t size;		/* Zone size */
 	int nb_dev;		/* # of devices attached to the zone */
 	mdk_rdev_t **dev;	/* Devices attached to the zone */
-- 
1.5.3.8

