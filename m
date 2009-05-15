From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 3/6] md: raid0: Remove hash spacing and sector shift.
Date: Fri, 15 May 2009 15:18:15 +0200
Message-ID: <1242393498-7528-4-git-send-email-maan@systemlinux.org>
References: <1242393498-7528-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242393498-7528-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

The "sector_shift" and "spacing" fields of struct raid0_private_data
were only used for the hash table lookups. So the removal of the
hash table allows get rid of these fields as well which simplifies
create_strip_zones() and raid0_run() quite a bit.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/raid0.c |   63 +---------------------------------------------------
 drivers/md/raid0.h |    3 --
 2 files changed, 1 insertions(+), 65 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d550396..4b207ab 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -56,7 +56,6 @@ static int create_strip_zones (mddev_t *mddev)
 {
 	int i, c, j;
 	sector_t current_start, curr_zone_start;
-	sector_t min_spacing;
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 	mdk_rdev_t *smallest, *rdev1, *rdev2, *rdev;
 	struct strip_zone *zone;
@@ -204,28 +203,7 @@ static int create_strip_zones (mddev_t *mddev)
 		printk(KERN_INFO "raid0: current zone start: %llu\n",
 			(unsigned long long)current_start);
 	}
-	/* Now find appropriate hash spacing.
-	 * We want a number which causes most hash entries to cover
-	 * at most two strips, but the hash table must be at most
-	 * 1 PAGE.  We choose the smallest strip, or contiguous collection
-	 * of strips, that has big enough size.  We never consider the last
-	 * strip though as it's size has no bearing on the efficacy of the hash
-	 * table.
-	 */
-	conf->spacing = curr_zone_start;
-	min_spacing = curr_zone_start;
-	sector_div(min_spacing, PAGE_SIZE/sizeof(struct strip_zone*));
-	for (i=0; i < conf->nr_strip_zones-1; i++) {
-		sector_t s = 0;
-		for (j = i; j < conf->nr_strip_zones - 1 &&
-				s < min_spacing; j++)
-			s += conf->strip_zone[j].sectors;
-		if (s >= min_spacing && s < conf->spacing)
-			conf->spacing = s;
-	}
-
 	mddev->queue->unplug_fn = raid0_unplug;
-
 	mddev->queue->backing_dev_info.congested_fn = raid0_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
 
@@ -275,10 +253,8 @@ static sector_t raid0_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 	return array_sectors;
 }
 
-static int raid0_run (mddev_t *mddev)
+static int raid0_run(mddev_t *mddev)
 {
-	unsigned  cur=0, i=0, nb_zone;
-	s64 sectors;
 	raid0_conf_t *conf;
 
 	if (mddev->chunk_size == 0) {
@@ -308,43 +284,6 @@ static int raid0_run (mddev_t *mddev)
 
 	printk(KERN_INFO "raid0 : md_size is %llu sectors.\n",
 		(unsigned long long)mddev->array_sectors);
-	printk(KERN_INFO "raid0 : conf->spacing is %llu sectors.\n",
-		(unsigned long long)conf->spacing);
-	{
-		sector_t s = raid0_size(mddev, 0, 0);
-		sector_t space = conf->spacing;
-		int round;
-		conf->sector_shift = 0;
-		if (sizeof(sector_t) > sizeof(u32)) {
-			/*shift down space and s so that sector_div will work */
-			while (space > (sector_t) (~(u32)0)) {
-				s >>= 1;
-				space >>= 1;
-				s += 1; /* force round-up */
-				conf->sector_shift++;
-			}
-		}
-		round = sector_div(s, (u32)space) ? 1 : 0;
-		nb_zone = s + round;
-	}
-	printk(KERN_INFO "raid0 : nb_zone is %d.\n", nb_zone);
-	sectors = conf->strip_zone[cur].sectors;
-
-	for (i=1; i< nb_zone; i++) {
-		while (sectors <= conf->spacing) {
-			cur++;
-			sectors += conf->strip_zone[cur].sectors;
-		}
-		sectors -= conf->spacing;
-	}
-	if (conf->sector_shift) {
-		conf->spacing >>= conf->sector_shift;
-		/* round spacing up so when we divide by it, we
-		 * err on the side of too-low, which is safest
-		 */
-		conf->spacing++;
-	}
-
 	/* calculate the max read-ahead size.
 	 * For read-ahead of large files to be effective, we need to
 	 * readahead at least twice a whole stripe. i.e. number of devices
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index a14630a..dbcf1da 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -15,9 +15,6 @@ struct raid0_private_data
 	struct strip_zone *strip_zone;
 	mdk_rdev_t **devlist; /* lists of rdevs, pointed to by strip_zone->dev */
 	int nr_strip_zones;
-
-	sector_t spacing;
-	int sector_shift; /* shift this before divide by spacing */
 };
 
 typedef struct raid0_private_data raid0_conf_t;
-- 
1.5.4.3

