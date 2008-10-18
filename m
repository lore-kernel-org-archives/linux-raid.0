From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 7/8] md: raid0: Represent the size of strip zones in sectors.
Date: Sat, 18 Oct 2008 17:24:28 +0200
Message-ID: <1224343469-2831-8-git-send-email-maan@systemlinux.org>
References: <1224343469-2831-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1224343469-2831-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

This completes the block -> sector conversion of struct strip_zone.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/raid0.c         |   26 +++++++++++++-------------
 include/linux/raid/raid0.h |    2 +-
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c759436..6e85e88 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -156,11 +156,11 @@ static int create_strip_zones (mddev_t *mddev)
 		goto abort;
 	}
 	zone->nb_dev = cnt;
-	zone->size = smallest->size * cnt;
+	zone->sectors = smallest->size * cnt * 2;
 	zone->zone_start = 0;
 
 	current_start = smallest->size * 2;
-	curr_zone_start = zone->size * 2;
+	curr_zone_start = zone->sectors;
 
 	/* now do the other zones */
 	for (i = 1; i < conf->nr_strip_zones; i++)
@@ -193,12 +193,12 @@ static int create_strip_zones (mddev_t *mddev)
 		}
 
 		zone->nb_dev = c;
-		zone->size = (smallest->size - current_start / 2) * c;
-		printk(KERN_INFO "raid0: zone->nb_dev: %d, size: %llu\n",
-			zone->nb_dev, (unsigned long long)zone->size);
+		zone->sectors = (smallest->size * 2 - current_start) * c;
+		printk(KERN_INFO "raid0: zone->nb_dev: %d, sectors: %llu\n",
+			zone->nb_dev, (unsigned long long)zone->sectors);
 
 		zone->zone_start = curr_zone_start;
-		curr_zone_start += zone->size * 2;
+		curr_zone_start += zone->sectors;
 
 		current_start = smallest->size * 2;
 		printk(KERN_INFO "raid0: current zone start: %llu\n",
@@ -220,7 +220,7 @@ static int create_strip_zones (mddev_t *mddev)
 		sector_t sz = 0;
 		for (j=i; j<conf->nr_strip_zones-1 &&
 			     sz < min_spacing ; j++)
-			sz += conf->strip_zone[j].size;
+			sz += conf->strip_zone[j].sectors / 2;
 		if (sz >= min_spacing && sz < conf->hash_spacing)
 			conf->hash_spacing = sz;
 	}
@@ -325,13 +325,13 @@ static int raid0_run (mddev_t *mddev)
 	conf->hash_table = kmalloc (sizeof (struct strip_zone *)*nb_zone, GFP_KERNEL);
 	if (!conf->hash_table)
 		goto out_free_conf;
-	size = conf->strip_zone[cur].size;
+	size = conf->strip_zone[cur].sectors / 2;
 
 	conf->hash_table[0] = conf->strip_zone + cur;
 	for (i=1; i< nb_zone; i++) {
 		while (size <= conf->hash_spacing) {
 			cur++;
-			size += conf->strip_zone[cur].size;
+			size += conf->strip_zone[cur].sectors / 2;
 		}
 		size -= conf->hash_spacing;
 		conf->hash_table[i] = conf->strip_zone + cur;
@@ -439,10 +439,10 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		sector_div(x, (u32)conf->hash_spacing);
 		zone = conf->hash_table[x];
 	}
- 
-	while (sector / 2 >= (zone->zone_start / 2 + zone->size))
+
+	while (sector >= zone->zone_start + zone->sectors)
 		zone++;
-    
+
 	sect_in_chunk = bio->bi_sector & (chunk_sects - 1);
 
 
@@ -495,7 +495,7 @@ static void raid0_status (struct seq_file *seq, mddev_t *mddev)
 		seq_printf(seq, "] zs=%d ds=%d s=%d\n",
 				conf->strip_zone[j].zone_start,
 				conf->strip_zone[j].dev_start,
-				conf->strip_zone[j].size);
+				conf->strip_zone[j].sectors);
 	}
 #endif
 	seq_printf(seq, " %dk chunks", mddev->chunk_size/1024);
diff --git a/include/linux/raid/raid0.h b/include/linux/raid/raid0.h
index eaf4f6a..c12521d 100644
--- a/include/linux/raid/raid0.h
+++ b/include/linux/raid/raid0.h
@@ -7,7 +7,7 @@ struct strip_zone
 {
 	sector_t zone_start;	/* Zone offset in md_dev (in sectors) */
 	sector_t dev_start;	/* Zone offset in real dev (in sectors) */
-	sector_t size;		/* Zone size */
+	sector_t sectors;	/* Zone size in sectors */
 	int nb_dev;		/* # of devices attached to the zone */
 	mdk_rdev_t **dev;	/* Devices attached to the zone */
 };
-- 
1.5.3.8

