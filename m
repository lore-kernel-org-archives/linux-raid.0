From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 6/6] md: Convert remaining 1k representations in linear.c to sectors.
Date: Fri, 25 Jul 2008 17:27:52 +0200
Message-ID: <1216999672-4943-7-git-send-email-maan@systemlinux.org>
References: <1216999672-4943-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1216999672-4943-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

This patch renames hash_spacing and preshift to  spacing and
sector_shift respectively with the following change of semantics:

Case 1: (sizeof(sector_t) <= sizeof(u32)).
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this case, we have sector_shift = preshift = 0 and spacing =
2 * hash_spacing.

Hence, the index for the hash table which is computed by the new code
in which_dev() as sector / spacing equals the old value which was
(sector/2) / hash_spacing.

Note also that the value of nb_zone stays the same because both sz
and base double.

Case 2: (sizeof(sector_t) > sizeof(u32)).
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(aka the shifting dance case). Here we have sector_shift = preshift +
1 and

spacing = 2 * hash_spacing

during the computation of nb_zone and curr_sector, but

spacing = hash_spacing

in which_dev() because in the last hunk of the patch for linear.c we
shift down conf->spacing (= 2 * hash_spacing) by one more bit than
in the old code.

Hence in the computation of nb_zone, sz and base have the same value
as before, so nb_zone is not affected. Also curr_sector in the next
hunk stays the same.

In which_dev() the hash table index is computed as

(sector >> sector_shift) / spacing

In view of sector_shift = preshift + 1 and spacing = hash_spacing,
this equals

((sector/2) >> preshift) / hash_spacing

which is the value computed by the old code.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/linear.c         |   35 +++++++++++++++++------------------
 include/linux/raid/linear.h |    6 ++++--
 2 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 441b7fa..71ffebd 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -33,14 +33,13 @@ static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sector)
 {
 	dev_info_t *hash;
 	linear_conf_t *conf = mddev_to_conf(mddev);
-	sector_t block = sector >> 1;
 
 	/*
 	 * sector_div(a,b) returns the remainer and sets a to a/b
 	 */
-	block >>= conf->preshift;
-	(void)sector_div(block, conf->hash_spacing);
-	hash = conf->hash_table[block];
+	sector >>= conf->sector_shift;
+	(void)sector_div(sector, conf->spacing);
+	hash = conf->hash_table[sector];
 
 	while (sector >= hash->num_sectors + hash->start_sector)
 		hash++;
@@ -162,25 +161,25 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 	 * that is larger than min_sectors and use the size of that as
 	 * the actual spacing
 	 */
-	conf->hash_spacing = conf->array_sectors / 2;
+	conf->spacing = conf->array_sectors;
 	for (i=0; i < cnt-1 ; i++) {
 		sector_t tmp = 0;
 		int j;
 		for (j = i; j < cnt - 1 && tmp < min_sectors; j++)
 			tmp += conf->disks[j].num_sectors;
-		if (tmp >= min_sectors && tmp < conf->hash_spacing * 2)
-			conf->hash_spacing = tmp / 2;
+		if (tmp >= min_sectors && tmp < conf->spacing)
+			conf->spacing = tmp;
 	}
 
-	/* hash_spacing may be too large for sector_div to work with,
+	/* spacing may be too large for sector_div to work with,
 	 * so we might need to pre-shift
 	 */
-	conf->preshift = 0;
+	conf->sector_shift = 0;
 	if (sizeof(sector_t) > sizeof(u32)) {
-		sector_t space = conf->hash_spacing;
+		sector_t space = conf->spacing;
 		while (space > (sector_t)(~(u32)0)) {
 			space >>= 1;
-			conf->preshift++;
+			conf->sector_shift++;
 		}
 	}
 	/*
@@ -192,9 +191,9 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 		unsigned round;
 		unsigned long base;
 
-		sz = conf->array_sectors >> (conf->preshift + 1);
+		sz = conf->array_sectors >> conf->sector_shift;
 		sz += 1; /* force round-up */
-		base = conf->hash_spacing >> conf->preshift;
+		base = conf->spacing >> conf->sector_shift;
 		round = sector_div(sz, base);
 		nb_zone = sz + (round ? 1 : 0);
 	}
@@ -219,7 +218,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 	i = 0;
 	for (curr_sector = 0;
 	     curr_sector < conf->array_sectors;
-	     curr_sector += conf->hash_spacing * 2) {
+	     curr_sector += conf->spacing) {
 
 		while (i < raid_disks-1 &&
 		       curr_sector >= conf->disks[i+1].start_sector)
@@ -228,12 +227,12 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 		*table ++ = conf->disks + i;
 	}
 
-	if (conf->preshift) {
-		conf->hash_spacing >>= conf->preshift;
-		/* round hash_spacing up so that when we divide by it,
+	if (conf->sector_shift) {
+		conf->spacing >>= conf->sector_shift;
+		/* round spacing up so that when we divide by it,
 		 * we err on the side of "too-low", which is safest.
 		 */
-		conf->hash_spacing++;
+		conf->spacing++;
 	}
 
 	BUG_ON(table - conf->hash_table > nb_zone);
diff --git a/include/linux/raid/linear.h b/include/linux/raid/linear.h
index 87090e9..f38b9c5 100644
--- a/include/linux/raid/linear.h
+++ b/include/linux/raid/linear.h
@@ -15,9 +15,11 @@ struct linear_private_data
 {
 	struct linear_private_data *prev;	/* earlier version */
 	dev_info_t		**hash_table;
-	sector_t		hash_spacing;
+	sector_t		spacing;
 	sector_t		array_sectors;
-	int			preshift; /* shift before dividing by hash_spacing */
+	int			sector_shift;	/* shift before dividing
+						 * by spacing
+						 */
 	dev_info_t		disks[0];
 };
 
-- 
1.5.4.3

