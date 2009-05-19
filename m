From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: PATCH [01/03] md: Removal of num_sectors from dev_info in linear raid
Date: Tue, 19 May 2009 11:58:01 +0530
Message-ID: <37d33d830905182328u60aead19vcf5f88adadb5e76e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: Sandeep K Sinha <sandeepksinha@gmail.com>

    Removal of num_sectors from dev_info and replacing all its occuranc=
es
    with rdev->sectors.

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 7a36e38..2fe909a 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -37,7 +37,7 @@ static inline dev_info_t *which_dev(mddev_t *mddev,
sector_t sector)
 	(void)sector_div(idx, conf->spacing);
 	hash =3D conf->hash_table[idx];

-	while (sector >=3D hash->num_sectors + hash->start_sector)
+	while (sector >=3D hash->rdev->sectors + hash->start_sector)
 		hash++;
 	return hash;
 }
@@ -60,7 +60,7 @@ static int linear_mergeable_bvec(struct request_queue=
 *q,
 	sector_t sector =3D bvm->bi_sector + get_start_sect(bvm->bi_bdev);

 	dev0 =3D which_dev(mddev, sector);
-	maxsectors =3D dev0->num_sectors - (sector - dev0->start_sector);
+	maxsectors =3D dev0->rdev->sectors - (sector - dev0->start_sector);

 	if (maxsectors < bio_sectors)
 		maxsectors =3D 0;
@@ -149,7 +149,6 @@ static linear_conf_t *linear_conf(mddev_t *mddev,
int raid_disks)
 		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
 			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);

-		disk->num_sectors =3D rdev->sectors;
 		conf->array_sectors +=3D rdev->sectors;

 		cnt++;
@@ -175,7 +174,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev,
int raid_disks)
 		sector_t tmp =3D 0;
 		int j;
 		for (j =3D i; j < cnt - 1 && tmp < min_sectors; j++)
-			tmp +=3D conf->disks[j].num_sectors;
+			tmp +=3D conf->disks[j].rdev->sectors;
 		if (tmp >=3D min_sectors && tmp < conf->spacing)
 			conf->spacing =3D tmp;
 	}
@@ -221,7 +220,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev,
int raid_disks)
 	for (i =3D 1; i < raid_disks; i++)
 		conf->disks[i].start_sector =3D
 			conf->disks[i-1].start_sector +
-			conf->disks[i-1].num_sectors;
+			conf->disks[i-1].rdev->sectors;

 	table =3D conf->hash_table;
 	i =3D 0;
@@ -337,7 +336,7 @@ static int linear_make_request (struct
request_queue *q, struct bio *bio)

 	tmp_dev =3D which_dev(mddev, bio->bi_sector);

-	if (unlikely(bio->bi_sector >=3D (tmp_dev->num_sectors +
+	if (unlikely(bio->bi_sector >=3D (tmp_dev->rdev->sectors +
 					tmp_dev->start_sector)
 		     || (bio->bi_sector <
 			 tmp_dev->start_sector))) {
@@ -347,20 +346,20 @@ static int linear_make_request (struct
request_queue *q, struct bio *bio)
 			"dev %s: %llu sectors, offset %llu\n",
 			(unsigned long long)bio->bi_sector,
 			bdevname(tmp_dev->rdev->bdev, b),
-			(unsigned long long)tmp_dev->num_sectors,
+			(unsigned long long)tmp_dev->rdev->sectors,
 			(unsigned long long)tmp_dev->start_sector);
 		bio_io_error(bio);
 		return 0;
 	}
 	if (unlikely(bio->bi_sector + (bio->bi_size >> 9) >
-		     tmp_dev->start_sector + tmp_dev->num_sectors)) {
+		     tmp_dev->start_sector + tmp_dev->rdev->sectors)) {
 		/* This bio crosses a device boundary, so we have to
 		 * split it.
 		 */
 		struct bio_pair *bp;

 		bp =3D bio_split(bio,
-			       tmp_dev->start_sector + tmp_dev->num_sectors
+			       tmp_dev->start_sector + tmp_dev->rdev->sectors
 			       - bio->bi_sector);

 		if (linear_make_request(q, &bp->bio1))
diff --git a/drivers/md/linear.h b/drivers/md/linear.h
index bf81795..26ee7fe 100644
--- a/drivers/md/linear.h
+++ b/drivers/md/linear.h
@@ -3,7 +3,6 @@

 struct dev_info {
 	mdk_rdev_t	*rdev;
-	sector_t	num_sectors;
 	sector_t	start_sector;
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
