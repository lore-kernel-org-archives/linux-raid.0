From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 1/6] md: raid0: Replace hash table lookup by looping over all strip_zones.
Date: Fri, 15 May 2009 15:18:13 +0200
Message-ID: <1242393498-7528-2-git-send-email-maan@systemlinux.org>
References: <1242393498-7528-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242393498-7528-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

The number of strip_zones of a raid0 array is bounded by the number of
drives in the array and is in fact much smaller for typical setups. For
example, any raid0 array containing identical disks will have only
a single strip_zone.

Therefore, the hash tables which are used for quickly finding the
strip_zone that holds a particular sector are of questionable value
and add quite a bit of unnecessary complexity.

This patch replaces the hash table lookup by equivalent code which
simply loops over all strip zones to find the zone that holds the
given sector.

In order to make this loop as fast as possible, the zone->start field
of struct strip_zone has been renamed to zone_end, and it now stores
the beginning of the next zone in sectors. This allows to save one
addition in the loop.

Subsequent cleanup patches will remove the hash table structure.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/raid0.c |   40 ++++++++++++++++++++--------------------
 drivers/md/raid0.h |    2 +-
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c08d755..f3a35c8 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -52,7 +52,6 @@ static int raid0_congested(void *data, int bits)
 	return ret;
 }
 
-
 static int create_strip_zones (mddev_t *mddev)
 {
 	int i, c, j;
@@ -158,7 +157,7 @@ static int create_strip_zones (mddev_t *mddev)
 	}
 	zone->nb_dev = cnt;
 	zone->sectors = smallest->sectors * cnt;
-	zone->zone_start = 0;
+	zone->zone_end = zone->sectors;
 
 	current_start = smallest->sectors;
 	curr_zone_start = zone->sectors;
@@ -198,14 +197,13 @@ static int create_strip_zones (mddev_t *mddev)
 		printk(KERN_INFO "raid0: zone->nb_dev: %d, sectors: %llu\n",
 			zone->nb_dev, (unsigned long long)zone->sectors);
 
-		zone->zone_start = curr_zone_start;
+		zone->zone_end = curr_zone_start + zone->sectors;
 		curr_zone_start += zone->sectors;
 
 		current_start = smallest->sectors;
 		printk(KERN_INFO "raid0: current zone start: %llu\n",
 			(unsigned long long)current_start);
 	}
-
 	/* Now find appropriate hash spacing.
 	 * We want a number which causes most hash entries to cover
 	 * at most two strips, but the hash table must be at most
@@ -398,6 +396,19 @@ static int raid0_stop (mddev_t *mddev)
 	return 0;
 }
 
+/* Find the zone which holds a particular offset */
+static struct strip_zone *find_zone(struct raid0_private_data *conf,
+		sector_t sector)
+{
+	int i;
+	struct strip_zone *z = conf->strip_zone;
+
+	for (i = 0; i < conf->nr_strip_zones; i++)
+		if (sector < z[i].zone_end)
+			return z + i;
+	BUG();
+}
+
 static int raid0_make_request (struct request_queue *q, struct bio *bio)
 {
 	mddev_t *mddev = q->queuedata;
@@ -443,22 +454,11 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		bio_pair_release(bp);
 		return 0;
 	}
- 
-
-	{
-		sector_t x = sector >> conf->sector_shift;
-		sector_div(x, (u32)conf->spacing);
-		zone = conf->hash_table[x];
-	}
-
-	while (sector >= zone->zone_start + zone->sectors)
-		zone++;
-
+	zone = find_zone(conf, sector);
 	sect_in_chunk = bio->bi_sector & (chunk_sects - 1);
-
-
 	{
-		sector_t x = (sector - zone->zone_start) >> chunksect_bits;
+		sector_t x = (zone->sectors + sector - zone->zone_end)
+				>> chunksect_bits;
 
 		sector_div(x, zone->nb_dev);
 		chunk = x;
@@ -503,8 +503,8 @@ static void raid0_status (struct seq_file *seq, mddev_t *mddev)
 			seq_printf(seq, "%s/", bdevname(
 				conf->strip_zone[j].dev[k]->bdev,b));
 
-		seq_printf(seq, "] zs=%d ds=%d s=%d\n",
-				conf->strip_zone[j].zone_start,
+		seq_printf(seq, "] ze=%d ds=%d s=%d\n",
+				conf->strip_zone[j].zone_end,
 				conf->strip_zone[j].dev_start,
 				conf->strip_zone[j].sectors);
 	}
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index 824b12e..556666f 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -3,7 +3,7 @@
 
 struct strip_zone
 {
-	sector_t zone_start;	/* Zone offset in md_dev (in sectors) */
+	sector_t zone_end;	/* Start of the next zone (in sectors) */
 	sector_t dev_start;	/* Zone offset in real dev (in sectors) */
 	sector_t sectors;	/* Zone size in sectors */
 	int nb_dev;		/* # of devices attached to the zone */
-- 
1.5.4.3

