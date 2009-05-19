From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: PATCH [02/03] md: Removing num_sector and replacing start_sector with
	end_sector
Date: Tue, 19 May 2009 16:21:21 +0530
Message-ID: <37d33d830905190351i5e7a2bc2x523f978a7ca27a50@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

This patch removes the num_sector from dev_info and also replaces
start_sector with end_sector in dev_info.


Author: Sandeep K Sinha <sandeepksinha@gmail.com>
Date:   Tue May 19 15:55:56 2009 +0530

    Removal of num_sectors and also maintaining end_sector
    rather than start_sector in dev_info.

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index f7f748d..f7f6bb9 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -32,7 +32,7 @@ static inline dev_info_t *which_dev(mddev_t *mddev,
sector_t sector)

 	hash =3D conf->disks;

-	while (sector >=3D hash->num_sectors + hash->start_sector)
+	while (sector >=3D hash->end_sector)
 		hash++;
 	return hash;
 }
@@ -55,7 +55,7 @@ static int linear_mergeable_bvec(struct request_queue=
 *q,
 	sector_t sector =3D bvm->bi_sector + get_start_sect(bvm->bi_bdev);

 	dev0 =3D which_dev(mddev, sector);
-	maxsectors =3D dev0->num_sectors - (sector - dev0->start_sector);
+	maxsectors =3D dev0->end_sector - sector;

 	if (maxsectors < bio_sectors)
 		maxsectors =3D 0;
@@ -141,10 +141,9 @@ static linear_conf_t *linear_conf(mddev_t *mddev,
int raid_disks)
 		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
 			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);

-		disk->num_sectors =3D rdev->sectors;
 		conf->array_sectors +=3D rdev->sectors;
-
 		cnt++;
+
 	}
 	if (cnt !=3D raid_disks) {
 		printk("linear: not enough drives present. Aborting!\n");
@@ -155,11 +154,12 @@ static linear_conf_t *linear_conf(mddev_t
*mddev, int raid_disks)
 	/*
 	 * Here we calculate the device offsets.
 	 */
-	conf->disks[0].start_sector =3D 0;
+	conf->disks[0].end_sector =3D conf->disks[0].rdev->sectors;
+
 	for (i =3D 1; i < raid_disks; i++)
-		conf->disks[i].start_sector =3D
-			conf->disks[i-1].start_sector +
-			conf->disks[i-1].num_sectors;
+		conf->disks[i].end_sector =3D
+			conf->disks[i-1].end_sector +
+			conf->disks[i].rdev->sectors;

 	return conf;

@@ -236,6 +236,7 @@ static int linear_make_request (struct
request_queue *q, struct bio *bio)
 	const int rw =3D bio_data_dir(bio);
 	mddev_t *mddev =3D q->queuedata;
 	dev_info_t *tmp_dev;
+	sector_t start_sector;
 	int cpu;

 	if (unlikely(bio_barrier(bio))) {
@@ -250,32 +251,30 @@ static int linear_make_request (struct
request_queue *q, struct bio *bio)
 	part_stat_unlock();

 	tmp_dev =3D which_dev(mddev, bio->bi_sector);
-
-	if (unlikely(bio->bi_sector >=3D (tmp_dev->num_sectors +
-					tmp_dev->start_sector)
-		     || (bio->bi_sector <
-			 tmp_dev->start_sector))) {
+    start_sector =3D tmp_dev->end_sector - tmp_dev->rdev->sectors;
+
+	if (unlikely(bio->bi_sector >=3D (tmp_dev->end_sector)
+		     || (bio->bi_sector < start_sector ))) {
 		char b[BDEVNAME_SIZE];

 		printk("linear_make_request: Sector %llu out of bounds on "
 			"dev %s: %llu sectors, offset %llu\n",
 			(unsigned long long)bio->bi_sector,
 			bdevname(tmp_dev->rdev->bdev, b),
-			(unsigned long long)tmp_dev->num_sectors,
-			(unsigned long long)tmp_dev->start_sector);
+			(unsigned long long)tmp_dev->rdev->sectors,
+			(unsigned long long)start_sector);
 		bio_io_error(bio);
 		return 0;
 	}
 	if (unlikely(bio->bi_sector + (bio->bi_size >> 9) >
-		     tmp_dev->start_sector + tmp_dev->num_sectors)) {
+		     tmp_dev->end_sector)) {
 		/* This bio crosses a device boundary, so we have to
 		 * split it.
 		 */
 		struct bio_pair *bp;

 		bp =3D bio_split(bio,
-			       tmp_dev->start_sector + tmp_dev->num_sectors
-			       - bio->bi_sector);
+			       tmp_dev->end_sector - bio->bi_sector);

 		if (linear_make_request(q, &bp->bio1))
 			generic_make_request(&bp->bio1);
@@ -286,7 +285,7 @@ static int linear_make_request (struct
request_queue *q, struct bio *bio)
 	}
 	=09
 	bio->bi_bdev =3D tmp_dev->rdev->bdev;
-	bio->bi_sector =3D bio->bi_sector - tmp_dev->start_sector
+	bio->bi_sector =3D bio->bi_sector - start_sector
 		+ tmp_dev->rdev->data_offset;

 	return 1;
diff --git a/drivers/md/linear.h b/drivers/md/linear.h
index de9ad5b..843e955 100644
--- a/drivers/md/linear.h
+++ b/drivers/md/linear.h
@@ -3,8 +3,7 @@

 struct dev_info {
 	mdk_rdev_t	*rdev;
-	sector_t	num_sectors;
-	sector_t	start_sector;
+	sector_t	end_sector;
 };

 typedef struct dev_info dev_info_t;

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
