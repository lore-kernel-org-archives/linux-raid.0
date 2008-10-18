From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 4/8] md: raid0: Represent zone->zone_offset in sectors.
Date: Sat, 18 Oct 2008 17:24:25 +0200
Message-ID: <1224343469-2831-5-git-send-email-maan@systemlinux.org>
References: <1224343469-2831-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1224343469-2831-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

For the same reason as in the previous patch, rename it from zone_offset
to zone_start.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/raid0.c         |   12 ++++++------
 include/linux/raid/raid0.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index b860536..6e12a35 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -155,7 +155,7 @@ static int create_strip_zones (mddev_t *mddev)
 	}
 	zone->nb_dev = cnt;
 	zone->size = smallest->size * cnt;
-	zone->zone_offset = 0;
+	zone->zone_start = 0;
 
 	current_offset = smallest->size;
 	curr_zone_offset = zone->size;
@@ -194,7 +194,7 @@ static int create_strip_zones (mddev_t *mddev)
 		printk("raid0: zone->nb_dev: %d, size: %llu\n",
 			zone->nb_dev, (unsigned long long)zone->size);
 
-		zone->zone_offset = curr_zone_offset;
+		zone->zone_start = curr_zone_offset * 2;
 		curr_zone_offset += zone->size;
 
 		current_offset = smallest->size;
@@ -437,14 +437,14 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		zone = conf->hash_table[x];
 	}
  
-	while (sector / 2 >= (zone->zone_offset + zone->size))
+	while (sector / 2 >= (zone->zone_start / 2 + zone->size))
 		zone++;
     
 	sect_in_chunk = bio->bi_sector & (chunk_sects - 1);
 
 
 	{
-		sector_t x = (sector - zone->zone_offset * 2) >> chunksect_bits;
+		sector_t x = (sector - zone->zone_start) >> chunksect_bits;
 
 		sector_div(x, zone->nb_dev);
 		chunk = x;
@@ -489,8 +489,8 @@ static void raid0_status (struct seq_file *seq, mddev_t *mddev)
 			seq_printf(seq, "%s/", bdevname(
 				conf->strip_zone[j].dev[k]->bdev,b));
 
-		seq_printf(seq, "] zo=%d ds=%d s=%d\n",
-				conf->strip_zone[j].zone_offset,
+		seq_printf(seq, "] zs=%d ds=%d s=%d\n",
+				conf->strip_zone[j].zone_start,
 				conf->strip_zone[j].dev_start,
 				conf->strip_zone[j].size);
 	}
diff --git a/include/linux/raid/raid0.h b/include/linux/raid/raid0.h
index 61c3d29..eaf4f6a 100644
--- a/include/linux/raid/raid0.h
+++ b/include/linux/raid/raid0.h
@@ -5,7 +5,7 @@
 
 struct strip_zone
 {
-	sector_t zone_offset;	/* Zone offset in md_dev */
+	sector_t zone_start;	/* Zone offset in md_dev (in sectors) */
 	sector_t dev_start;	/* Zone offset in real dev (in sectors) */
 	sector_t size;		/* Zone size */
 	int nb_dev;		/* # of devices attached to the zone */
-- 
1.5.3.8

