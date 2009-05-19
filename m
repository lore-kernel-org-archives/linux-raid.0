From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: PATCH[02/03] md: Getting rid of sector_div and hash table in linear
	raid
Date: Tue, 19 May 2009 11:59:29 +0530
Message-ID: <37d33d830905182329i16408f61w64aeb4f3e0aa68b4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: Sandeep K Sinha <sandeepksinha@gmail.com>

    Removal of hashing table and getting rid of sector_div.
    This also makes the code cleaner.

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 2fe909a..c0fb282 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -29,13 +29,11 @@ static inline dev_info_t *which_dev(mddev_t
*mddev, sector_t sector)
 {
 	dev_info_t *hash;
 	linear_conf_t *conf =3D mddev_to_conf(mddev);
-	sector_t idx =3D sector >> conf->sector_shift;

 	/*
-	 * sector_div(a,b) returns the remainer and sets a to a/b
+	 * Linear Search
 	 */
-	(void)sector_div(idx, conf->spacing);
-	hash =3D conf->hash_table[idx];
+	hash =3D conf->disks;

 	while (sector >=3D hash->rdev->sectors + hash->start_sector)
 		hash++;
@@ -114,11 +112,8 @@ static sector_t linear_size(mddev_t *mddev,
sector_t sectors, int raid_disks)
 static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 {
 	linear_conf_t *conf;
-	dev_info_t **table;
 	mdk_rdev_t *rdev;
-	int i, nb_zone, cnt;
-	sector_t min_sectors;
-	sector_t curr_sector;
+	int i, cnt;

 	conf =3D kzalloc (sizeof (*conf) + raid_disks*sizeof(dev_info_t),
 			GFP_KERNEL);
@@ -158,63 +153,8 @@ static linear_conf_t *linear_conf(mddev_t *mddev,
int raid_disks)
 		goto out;
 	}

-	min_sectors =3D conf->array_sectors;
-	sector_div(min_sectors, PAGE_SIZE/sizeof(struct dev_info *));
-	if (min_sectors =3D=3D 0)
-		min_sectors =3D 1;
-
-	/* min_sectors is the minimum spacing that will fit the hash
-	 * table in one PAGE.  This may be much smaller than needed.
-	 * We find the smallest non-terminal set of consecutive devices
-	 * that is larger than min_sectors and use the size of that as
-	 * the actual spacing
-	 */
-	conf->spacing =3D conf->array_sectors;
-	for (i=3D0; i < cnt-1 ; i++) {
-		sector_t tmp =3D 0;
-		int j;
-		for (j =3D i; j < cnt - 1 && tmp < min_sectors; j++)
-			tmp +=3D conf->disks[j].rdev->sectors;
-		if (tmp >=3D min_sectors && tmp < conf->spacing)
-			conf->spacing =3D tmp;
-	}
-
-	/* spacing may be too large for sector_div to work with,
-	 * so we might need to pre-shift
-	 */
-	conf->sector_shift =3D 0;
-	if (sizeof(sector_t) > sizeof(u32)) {
-		sector_t space =3D conf->spacing;
-		while (space > (sector_t)(~(u32)0)) {
-			space >>=3D 1;
-			conf->sector_shift++;
-		}
-	}
 	/*
-	 * This code was restructured to work around a gcc-2.95.3 internal
-	 * compiler error.  Alter it with care.
-	 */
-	{
-		sector_t sz;
-		unsigned round;
-		unsigned long base;
-
-		sz =3D conf->array_sectors >> conf->sector_shift;
-		sz +=3D 1; /* force round-up */
-		base =3D conf->spacing >> conf->sector_shift;
-		round =3D sector_div(sz, base);
-		nb_zone =3D sz + (round ? 1 : 0);
-	}
-	BUG_ON(nb_zone > PAGE_SIZE / sizeof(struct dev_info *));
-
-	conf->hash_table =3D kmalloc (sizeof (struct dev_info *) * nb_zone,
-					GFP_KERNEL);
-	if (!conf->hash_table)
-		goto out;
-
-	/*
-	 * Here we generate the linear hash table
-	 * First calculate the device offsets.
+	 * Here we calculate the device offsets.
 	 */
 	conf->disks[0].start_sector =3D 0;
 	for (i =3D 1; i < raid_disks; i++)
@@ -222,29 +162,6 @@ static linear_conf_t *linear_conf(mddev_t *mddev,
int raid_disks)
 			conf->disks[i-1].start_sector +
 			conf->disks[i-1].rdev->sectors;

-	table =3D conf->hash_table;
-	i =3D 0;
-	for (curr_sector =3D 0;
-	     curr_sector < conf->array_sectors;
-	     curr_sector +=3D conf->spacing) {
-
-		while (i < raid_disks-1 &&
-		       curr_sector >=3D conf->disks[i+1].start_sector)
-			i++;
-
-		*table ++ =3D conf->disks + i;
-	}
-
-	if (conf->sector_shift) {
-		conf->spacing >>=3D conf->sector_shift;
-		/* round spacing up so that when we divide by it,
-		 * we err on the side of "too-low", which is safest.
-		 */
-		conf->spacing++;
-	}
-
-	BUG_ON(table - conf->hash_table > nb_zone);
-
 	return conf;

 out:
@@ -308,7 +225,6 @@ static int linear_stop (mddev_t *mddev)
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	do {
 		linear_conf_t *t =3D conf->prev;
-		kfree(conf->hash_table);
 		kfree(conf);
 		conf =3D t;
 	} while (conf);
diff --git a/drivers/md/linear.h b/drivers/md/linear.h
index 26ee7fe..ea6abbe 100644
--- a/drivers/md/linear.h
+++ b/drivers/md/linear.h
@@ -11,12 +11,7 @@ typedef struct dev_info dev_info_t;
 struct linear_private_data
 {
 	struct linear_private_data *prev;	/* earlier version */
-	dev_info_t		**hash_table;
-	sector_t		spacing;
 	sector_t		array_sectors;
-	int			sector_shift;	/* shift before dividing
-						 * by spacing
-						 */
 	dev_info_t		disks[0];
 };


--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
