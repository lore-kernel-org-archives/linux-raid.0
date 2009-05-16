From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 1/2] md: raid0: remove ->sectors from the strip_zone
	structure.
Date: Sat, 16 May 2009 21:57:31 +1000
Message-ID: <20090516115731.14596.96474.stgit@notabene.brown>
References: <20090516115726.14596.58766.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090516115726.14596.58766.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

storing ->sectors is redundant as is can be computed from the
difference  z->zone_end - (z-1)->zone_end

The one place where it is used, it is just as efficient to use
a zone_end value instead.

And removing it makes strip_zone smaller, so they array of these that
is searched on every request has a better chance to say in cache.

So discard the field and get the value from elsewhere.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid0.c |   37 +++++++++++++++++++++----------------
 drivers/md/raid0.h |    1 -
 2 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 0305061..4b6c16a 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -55,7 +55,7 @@ static int raid0_congested(void *data, int bits)
 static int create_strip_zones(mddev_t *mddev)
 {
 	int i, c, j, err;
-	sector_t current_start, curr_zone_start;
+	sector_t current_start, curr_zone_start, sectors;
 	mdk_rdev_t *smallest, *rdev1, *rdev2, *rdev;
 	struct strip_zone *zone;
 	int cnt;
@@ -153,11 +153,10 @@ static int create_strip_zones(mddev_t *mddev)
 		goto abort;
 	}
 	zone->nb_dev = cnt;
-	zone->sectors = smallest->sectors * cnt;
-	zone->zone_end = zone->sectors;
+	zone->zone_end = smallest->sectors * cnt;
 
 	current_start = smallest->sectors;
-	curr_zone_start = zone->sectors;
+	curr_zone_start = zone->zone_end;
 
 	/* now do the other zones */
 	for (i = 1; i < conf->nr_strip_zones; i++)
@@ -190,14 +189,14 @@ static int create_strip_zones(mddev_t *mddev)
 		}
 
 		zone->nb_dev = c;
-		zone->sectors = (smallest->sectors - current_start) * c;
+		sectors = (smallest->sectors - current_start) * c;
 		printk(KERN_INFO "raid0: zone->nb_dev: %d, sectors: %llu\n",
-			zone->nb_dev, (unsigned long long)zone->sectors);
-
-		zone->zone_end = curr_zone_start + zone->sectors;
-		curr_zone_start += zone->sectors;
+			zone->nb_dev, (unsigned long long)sectors);
 
+		curr_zone_start += sectors;
 		current_start = smallest->sectors;
+		zone->zone_end = curr_zone_start;
+
 		printk(KERN_INFO "raid0: current zone start: %llu\n",
 			(unsigned long long)current_start);
 	}
@@ -312,16 +311,22 @@ static int raid0_stop(mddev_t *mddev)
 	return 0;
 }
 
-/* Find the zone which holds a particular offset */
+/* Find the zone which holds a particular offset
+ * Update *sectorp to be an offset in that zone
+ */
 static struct strip_zone *find_zone(struct raid0_private_data *conf,
-		sector_t sector)
+				    sector_t *sectorp)
 {
 	int i;
 	struct strip_zone *z = conf->strip_zone;
+	sector_t sector = *sectorp;
 
 	for (i = 0; i < conf->nr_strip_zones; i++)
-		if (sector < z[i].zone_end)
+		if (sector < z[i].zone_end) {
+			if (i)
+				*sectorp = sector - z[i-1].zone_end;
 			return z + i;
+		}
 	BUG();
 }
 
@@ -333,7 +338,7 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
 	sector_t chunk;
-	sector_t sector, rsect;
+	sector_t sector, rsect, sector_offset;
 	const int rw = bio_data_dir(bio);
 	int cpu;
 
@@ -370,11 +375,11 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		bio_pair_release(bp);
 		return 0;
 	}
-	zone = find_zone(conf, sector);
+	sector_offset = sector;
+	zone = find_zone(conf, &sector_offset);
 	sect_in_chunk = bio->bi_sector & (chunk_sects - 1);
 	{
-		sector_t x = (zone->sectors + sector - zone->zone_end)
-				>> chunksect_bits;
+		sector_t x = sector_offset >> chunksect_bits;
 
 		sector_div(x, zone->nb_dev);
 		chunk = x;
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index dbcf1da..124ba34 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -5,7 +5,6 @@ struct strip_zone
 {
 	sector_t zone_end;	/* Start of the next zone (in sectors) */
 	sector_t dev_start;	/* Zone offset in real dev (in sectors) */
-	sector_t sectors;	/* Zone size in sectors */
 	int nb_dev;		/* # of devices attached to the zone */
 	mdk_rdev_t **dev;	/* Devices attached to the zone */
 };


