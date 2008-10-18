From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 8/8] md: raid0: make hash_spacing and preshift sector-based.
Date: Sat, 18 Oct 2008 17:24:29 +0200
Message-ID: <1224343469-2831-9-git-send-email-maan@systemlinux.org>
References: <1224343469-2831-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1224343469-2831-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

This patch renames the hash_spacing and preshift members of struct
raid0_private_data to spacing and sector_shift respectively and
changes the semantics as follows:

We always have spacing = 2 * hash_spacing. In case
sizeof(sector_t) > sizeof(u32) we also have sector_shift = preshift + 1
while sector_shift = preshift = 0 otherwise.

Note that the values of nb_zone and zone are unaffected by these changes
because in the sector_div() preceeding the assignement of these two
variables both arguments double.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/raid0.c         |   58 ++++++++++++++++++++++----------------------
 include/linux/raid/raid0.h |    4 +-
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 6e85e88..90f5b24 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -213,16 +213,16 @@ static int create_strip_zones (mddev_t *mddev)
 	 * strip though as it's size has no bearing on the efficacy of the hash
 	 * table.
 	 */
-	conf->hash_spacing = curr_zone_start / 2;
-	min_spacing = curr_zone_start / 2;
+	conf->spacing = curr_zone_start;
+	min_spacing = curr_zone_start;
 	sector_div(min_spacing, PAGE_SIZE/sizeof(struct strip_zone*));
 	for (i=0; i < conf->nr_strip_zones-1; i++) {
-		sector_t sz = 0;
-		for (j=i; j<conf->nr_strip_zones-1 &&
-			     sz < min_spacing ; j++)
-			sz += conf->strip_zone[j].sectors / 2;
-		if (sz >= min_spacing && sz < conf->hash_spacing)
-			conf->hash_spacing = sz;
+		sector_t s = 0;
+		for (j = i; j < conf->nr_strip_zones - 1 &&
+				s < min_spacing; j++)
+			s += conf->strip_zone[j].sectors;
+		if (s >= min_spacing && s < conf->spacing)
+			conf->spacing = s;
 	}
 
 	mddev->queue->unplug_fn = raid0_unplug;
@@ -265,7 +265,7 @@ static int raid0_mergeable_bvec(struct request_queue *q,
 static int raid0_run (mddev_t *mddev)
 {
 	unsigned  cur=0, i=0, nb_zone;
-	s64 size;
+	s64 sectors;
 	raid0_conf_t *conf;
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
@@ -297,51 +297,51 @@ static int raid0_run (mddev_t *mddev)
 	rdev_for_each(rdev, tmp, mddev)
 		mddev->array_sectors += rdev->size * 2;
 
-	printk("raid0 : md_size is %llu blocks.\n", 
-		(unsigned long long)mddev->array_sectors / 2);
-	printk("raid0 : conf->hash_spacing is %llu blocks.\n",
-		(unsigned long long)conf->hash_spacing);
+	printk(KERN_INFO "raid0 : md_size is %llu sectors.\n",
+		(unsigned long long)mddev->array_sectors);
+	printk(KERN_INFO "raid0 : conf->spacing is %llu sectors.\n",
+		(unsigned long long)conf->spacing);
 	{
-		sector_t s = mddev->array_sectors / 2;
-		sector_t space = conf->hash_spacing;
+		sector_t s = mddev->array_sectors;
+		sector_t space = conf->spacing;
 		int round;
-		conf->preshift = 0;
+		conf->sector_shift = 0;
 		if (sizeof(sector_t) > sizeof(u32)) {
 			/*shift down space and s so that sector_div will work */
 			while (space > (sector_t) (~(u32)0)) {
 				s >>= 1;
 				space >>= 1;
 				s += 1; /* force round-up */
-				conf->preshift++;
+				conf->sector_shift++;
 			}
 		}
 		round = sector_div(s, (u32)space) ? 1 : 0;
 		nb_zone = s + round;
 	}
-	printk("raid0 : nb_zone is %d.\n", nb_zone);
+	printk(KERN_INFO "raid0 : nb_zone is %d.\n", nb_zone);
 
-	printk("raid0 : Allocating %Zd bytes for hash.\n",
+	printk(KERN_INFO "raid0 : Allocating %zu bytes for hash.\n",
 				nb_zone*sizeof(struct strip_zone*));
 	conf->hash_table = kmalloc (sizeof (struct strip_zone *)*nb_zone, GFP_KERNEL);
 	if (!conf->hash_table)
 		goto out_free_conf;
-	size = conf->strip_zone[cur].sectors / 2;
+	sectors = conf->strip_zone[cur].sectors;
 
 	conf->hash_table[0] = conf->strip_zone + cur;
 	for (i=1; i< nb_zone; i++) {
-		while (size <= conf->hash_spacing) {
+		while (sectors <= conf->spacing) {
 			cur++;
-			size += conf->strip_zone[cur].sectors / 2;
+			sectors += conf->strip_zone[cur].sectors;
 		}
-		size -= conf->hash_spacing;
+		sectors -= conf->spacing;
 		conf->hash_table[i] = conf->strip_zone + cur;
 	}
-	if (conf->preshift) {
-		conf->hash_spacing >>= conf->preshift;
-		/* round hash_spacing up so when we divide by it, we
+	if (conf->sector_shift) {
+		conf->spacing >>= conf->sector_shift;
+		/* round spacing up so when we divide by it, we
 		 * err on the side of too-low, which is safest
 		 */
-		conf->hash_spacing++;
+		conf->spacing++;
 	}
 
 	/* calculate the max read-ahead size.
@@ -435,8 +435,8 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
  
 
 	{
-		sector_t x = sector >> (conf->preshift + 1);
-		sector_div(x, (u32)conf->hash_spacing);
+		sector_t x = sector >> conf->sector_shift;
+		sector_div(x, (u32)conf->spacing);
 		zone = conf->hash_table[x];
 	}
 
diff --git a/include/linux/raid/raid0.h b/include/linux/raid/raid0.h
index c12521d..fd42aa8 100644
--- a/include/linux/raid/raid0.h
+++ b/include/linux/raid/raid0.h
@@ -19,8 +19,8 @@ struct raid0_private_data
 	mdk_rdev_t **devlist; /* lists of rdevs, pointed to by strip_zone->dev */
 	int nr_strip_zones;
 
-	sector_t hash_spacing;
-	int preshift;			/* shift this before divide by hash_spacing */
+	sector_t spacing;
+	int sector_shift; /* shift this before divide by spacing */
 };
 
 typedef struct raid0_private_data raid0_conf_t;
-- 
1.5.3.8

