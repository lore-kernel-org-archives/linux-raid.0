From: NeilBrown <neilb@suse.de>
Subject: [PATCH 007 of 9] md: Handle bypassing the read cache (assuming nothing fails).
Date: Wed, 8 Nov 2006 09:09:57 +1100
Message-ID: <1061107220957.12562@suse.de>
References: <20061108085917.12064.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753561AbWKGWJ4@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
List-Id: linux-raid.ids


From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-11-06 11:29:13.000000000 +1100
+++ ./drivers/md/raid5.c	2006-11-06 11:29:13.000000000 +1100
@@ -2633,6 +2633,84 @@ static int raid5_mergeable_bvec(request_
 		return max;
 }
 
+
+static int in_chunk_boundary(mddev_t *mddev, struct bio *bio)
+{
+	sector_t sector = bio->bi_sector + get_start_sect(bio->bi_bdev);
+	unsigned int chunk_sectors = mddev->chunk_size >> 9;
+	unsigned int bio_sectors = bio->bi_size >> 9;
+
+	return  chunk_sectors >=
+		((sector & (chunk_sectors - 1)) + bio_sectors);
+}
+
+/*
+ *  The "raid5_align_endio" should check if the read succeeded and if it
+ *  did, call bio_endio on the original bio (having bio_put the new bio
+ *  first).
+ *  If the read failed..
+ */
+int raid5_align_endio(struct bio *bi, unsigned int bytes , int error)
+{
+	struct bio* raid_bi  = bi->bi_private;
+	if (bi->bi_size)
+		return 1;
+	bio_put(bi);
+	bio_endio(raid_bi, bytes, error);
+	return 0;
+}
+
+static int chunk_aligned_read(request_queue_t *q, struct bio * raid_bio)
+{
+	mddev_t *mddev = q->queuedata;
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+	const unsigned int raid_disks = conf->raid_disks;
+	const unsigned int data_disks = raid_disks - 1;
+	unsigned int dd_idx, pd_idx;
+	struct bio* align_bi;
+	mdk_rdev_t *rdev;
+
+	if (!in_chunk_boundary(mddev, raid_bio)) {
+		printk("chunk_aligned_read : non aligned\n");
+		return 0;
+	}
+	/*
+ 	 * use bio_clone to make a copy of the bio
+	 */
+	align_bi = bio_clone(raid_bio, GFP_NOIO);
+	if (!align_bi)
+		return 0;
+	/*
+	 *   set bi_end_io to a new function, and set bi_private to the
+	 *     original bio.
+	 */
+	align_bi->bi_end_io  = raid5_align_endio;
+	align_bi->bi_private = raid_bio;
+	/*
+	 *	compute position
+	 */
+	align_bi->bi_sector =  raid5_compute_sector(raid_bio->bi_sector,
+					raid_disks,
+					data_disks,
+					&dd_idx,
+					&pd_idx,
+					conf);
+
+	rcu_read_lock();
+	rdev = rcu_dereference(conf->disks[dd_idx].rdev);
+	if (rdev && test_bit(In_sync, &rdev->flags)) {
+		align_bi->bi_bdev =  rdev->bdev;
+		atomic_inc(&rdev->nr_pending);
+		rcu_read_unlock();
+		generic_make_request(align_bi);
+		return 1;
+	} else {
+		rcu_read_unlock();
+		return 0;
+	}
+}
+
+
 static int make_request(request_queue_t *q, struct bio * bi)
 {
 	mddev_t *mddev = q->queuedata;
