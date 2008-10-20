From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 6/9] md: raid0 create_strip_zones(): Make two local variables sector-based.
Date: Mon, 20 Oct 2008 10:56:44 +0200
Message-ID: <1224493007-1255-7-git-send-email-maan@systemlinux.org>
References: <1224493007-1255-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1224493007-1255-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

current_offset and curr_zone_offset stored the corresponding offsets
as 1K quantities. Rename them to current_start and curr_zone_start
to match the naming of struct strip_zone and store the offsets as
sector counts.

Also, add KERN_INFO to the printk() affected by this change to make
checkpatch happy.
---
 drivers/md/raid0.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 6e12a35..9074ea4 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -53,7 +53,7 @@ static int raid0_congested(void *data, int bits)
 static int create_strip_zones (mddev_t *mddev)
 {
 	int i, c, j;
-	sector_t current_offset, curr_zone_offset;
+	sector_t current_start, curr_zone_start;
 	sector_t min_spacing;
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 	mdk_rdev_t *smallest, *rdev1, *rdev2, *rdev;
@@ -157,8 +157,8 @@ static int create_strip_zones (mddev_t *mddev)
 	zone->size = smallest->size * cnt;
 	zone->zone_start = 0;
 
-	current_offset = smallest->size;
-	curr_zone_offset = zone->size;
+	current_start = smallest->size * 2;
+	curr_zone_start = zone->size * 2;
 
 	/* now do the other zones */
 	for (i = 1; i < conf->nr_strip_zones; i++)
@@ -167,7 +167,7 @@ static int create_strip_zones (mddev_t *mddev)
 		zone->dev = conf->strip_zone[i-1].dev + mddev->raid_disks;
 
 		printk("raid0: zone %d\n", i);
-		zone->dev_start = current_offset * 2;
+		zone->dev_start = current_start;
 		smallest = NULL;
 		c = 0;
 
@@ -175,8 +175,7 @@ static int create_strip_zones (mddev_t *mddev)
 			char b[BDEVNAME_SIZE];
 			rdev = conf->strip_zone[0].dev[j];
 			printk("raid0: checking %s ...", bdevname(rdev->bdev,b));
-			if (rdev->size > current_offset)
-			{
+			if (rdev->size > current_start / 2) {
 				printk(" contained as device %d\n", c);
 				zone->dev[c] = rdev;
 				c++;
@@ -190,16 +189,16 @@ static int create_strip_zones (mddev_t *mddev)
 		}
 
 		zone->nb_dev = c;
-		zone->size = (smallest->size - current_offset) * c;
+		zone->size = (smallest->size - current_start / 2) * c;
 		printk("raid0: zone->nb_dev: %d, size: %llu\n",
 			zone->nb_dev, (unsigned long long)zone->size);
 
-		zone->zone_start = curr_zone_offset * 2;
-		curr_zone_offset += zone->size;
+		zone->zone_start = curr_zone_start;
+		curr_zone_start += zone->size * 2;
 
-		current_offset = smallest->size;
-		printk("raid0: current zone offset: %llu\n",
-			(unsigned long long)current_offset);
+		current_start = smallest->size * 2;
+		printk(KERN_INFO "raid0: current zone start: %llu\n",
+			(unsigned long long)current_start);
 	}
 
 	/* Now find appropriate hash spacing.
@@ -210,8 +209,8 @@ static int create_strip_zones (mddev_t *mddev)
 	 * strip though as it's size has no bearing on the efficacy of the hash
 	 * table.
 	 */
-	conf->hash_spacing = curr_zone_offset;
-	min_spacing = curr_zone_offset;
+	conf->hash_spacing = curr_zone_start / 2;
+	min_spacing = curr_zone_start / 2;
 	sector_div(min_spacing, PAGE_SIZE/sizeof(struct strip_zone*));
 	for (i=0; i < conf->nr_strip_zones-1; i++) {
 		sector_t sz = 0;
-- 
1.5.3.8

