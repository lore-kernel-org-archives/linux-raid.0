From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 08/10] md/raid10: Introduce 'prev' geometry to support
 reshape.
Date: Tue, 03 Apr 2012 15:53:02 +1000
Message-ID: <20120403055302.19495.74009.stgit@notabene.brown>
References: <20120403054656.19495.36380.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120403054656.19495.36380.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When RAID10 supports reshape it will need a 'previous' and a 'current'
geometry, so introduce that here.
Use the 'prev' geometry when before the reshape_position, and the
current 'geo' when beyond it.  At other times, use both as
appropriate.

For now, both are identical (And reshape_position is never set).

When we use the 'prev' geometry, we must use the old data_offset.
When we use the current (And a reshape is happening) we must use
the new_data_offset.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |  106 ++++++++++++++++++++++++++++++++++++++++-----------
 drivers/md/raid10.h |    8 +++-
 2 files changed, 91 insertions(+), 23 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 39f5239..0a6746f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -504,15 +504,13 @@ static void raid10_end_write_request(struct bio *bio, int error)
  * sector offset to a virtual address
  */
 
-static void raid10_find_phys(struct r10conf *conf, struct r10bio *r10bio)
+static void __raid10_find_phys(struct geom *geo, struct r10bio *r10bio)
 {
 	int n,f;
 	sector_t sector;
 	sector_t chunk;
 	sector_t stripe;
 	int dev;
-	struct geom *geo = &conf->geo;
-
 	int slot = 0;
 
 	/* now calculate first sector/dev */
@@ -550,12 +548,29 @@ static void raid10_find_phys(struct r10conf *conf, struct r10bio *r10bio)
 			sector += (geo->chunk_mask + 1);
 		}
 	}
-	BUG_ON(slot != conf->copies);
+}
+
+static void raid10_find_phys(struct r10conf *conf, struct r10bio *r10bio)
+{
+	struct geom *geo = &conf->geo;
+
+	if (conf->reshape_progress != MaxSector &&
+	    ((r10bio->sector >= conf->reshape_progress) !=
+	     conf->mddev->reshape_backwards)) {
+		set_bit(R10BIO_Previous, &r10bio->state);
+		geo = &conf->prev;
+	} else
+		clear_bit(R10BIO_Previous, &r10bio->state);
+
+	__raid10_find_phys(geo, r10bio);
 }
 
 static sector_t raid10_find_virt(struct r10conf *conf, sector_t sector, int dev)
 {
 	sector_t offset, chunk, vchunk;
+	/* Never use conf->prev as this is only called during resync
+	 * or recovery, so reshape isn't happening
+	 */
 	struct geom *geo = &conf->geo;
 
 	offset = sector & geo->chunk_mask;
@@ -603,6 +618,11 @@ static int raid10_mergeable_bvec(struct request_queue *q,
 	unsigned int bio_sectors = bvm->bi_size >> 9;
 	struct geom *geo = &conf->geo;
 
+	if (conf->reshape_progress != MaxSector &&
+	    ((sector >= conf->reshape_progress) !=
+	     conf->mddev->reshape_backwards))
+		geo = &conf->prev;
+
 	if (geo->near_copies < geo->raid_disks) {
 		max = (chunk_sectors - ((sector & (chunk_sectors - 1))
 					+ bio_sectors)) << 9;
@@ -617,6 +637,12 @@ static int raid10_mergeable_bvec(struct request_queue *q,
 	if (mddev->merge_check_needed) {
 		struct r10bio r10_bio;
 		int s;
+		if (conf->reshape_progress != MaxSector) {
+			/* Cannot give any guidance during reshape */
+			if (max <= biovec->bv_len && bio_sectors == 0)
+				return biovec->bv_len;
+			return 0;
+		}
 		r10_bio.sector = sector;
 		raid10_find_phys(conf, &r10_bio);
 		rcu_read_lock();
@@ -816,7 +842,10 @@ static int raid10_congested(void *data, int bits)
 	if (mddev_congested(mddev, bits))
 		return 1;
 	rcu_read_lock();
-	for (i = 0; i < conf->geo.raid_disks && ret == 0; i++) {
+	for (i = 0;
+	     (i < conf->geo.raid_disks || i < conf->prev.raid_disks)
+		     && ret == 0;
+	     i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev && !test_bit(Faulty, &rdev->flags)) {
 			struct request_queue *q = bdev_get_queue(rdev->bdev);
@@ -977,13 +1006,23 @@ static void unfreeze_array(struct r10conf *conf)
 	spin_unlock_irq(&conf->resync_lock);
 }
 
+static sector_t choose_data_offset(struct r10bio *r10_bio,
+				   struct md_rdev *rdev)
+{
+	if (!test_bit(MD_RECOVERY_RESHAPE, &rdev->mddev->recovery) ||
+	    test_bit(R10BIO_Previous, &r10_bio->state))
+		return rdev->data_offset;
+	else
+		return rdev->new_data_offset;
+}
+
 static void make_request(struct mddev *mddev, struct bio * bio)
 {
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10_bio;
 	struct bio *read_bio;
 	int i;
-	sector_t chunk_mask = conf->geo.chunk_mask;
+	sector_t chunk_mask = (conf->geo.chunk_mask & conf->prev.chunk_mask);
 	int chunk_sects = chunk_mask + 1;
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
@@ -1004,7 +1043,8 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	 */
 	if (unlikely((bio->bi_sector & chunk_mask) + (bio->bi_size >> 9)
 		     > chunk_sects
-		     && conf->geo.near_copies < conf->geo.raid_disks)) {
+		     && (conf->geo.near_copies < conf->geo.raid_disks
+			 || conf->prev.near_copies < conf->prev.raid_disks))) {
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
 		if (bio->bi_vcnt != 1 ||
@@ -1098,7 +1138,7 @@ read_again:
 		r10_bio->devs[slot].rdev = rdev;
 
 		read_bio->bi_sector = r10_bio->devs[slot].addr +
-			rdev->data_offset;
+			choose_data_offset(r10_bio, rdev);
 		read_bio->bi_bdev = rdev->bdev;
 		read_bio->bi_end_io = raid10_end_read_request;
 		read_bio->bi_rw = READ | do_sync;
@@ -1302,7 +1342,8 @@ retry_write:
 		r10_bio->devs[i].bio = mbio;
 
 		mbio->bi_sector	= (r10_bio->devs[i].addr+
-				   conf->mirrors[d].rdev->data_offset);
+				   choose_data_offset(r10_bio,
+						      conf->mirrors[d].rdev));
 		mbio->bi_bdev = conf->mirrors[d].rdev->bdev;
 		mbio->bi_end_io	= raid10_end_write_request;
 		mbio->bi_rw = WRITE | do_sync | do_fua;
@@ -1326,8 +1367,10 @@ retry_write:
 		 * so it cannot disappear, so the replacement cannot
 		 * become NULL here
 		 */
-		mbio->bi_sector	= (r10_bio->devs[i].addr+
-				   conf->mirrors[d].replacement->data_offset);
+		mbio->bi_sector	= (r10_bio->devs[i].addr +
+				   choose_data_offset(
+					   r10_bio,
+					   conf->mirrors[d].replacement));
 		mbio->bi_bdev = conf->mirrors[d].replacement->bdev;
 		mbio->bi_end_io	= raid10_end_write_request;
 		mbio->bi_rw = WRITE | do_sync | do_fua;
@@ -1397,7 +1440,7 @@ static void status(struct seq_file *seq, struct mddev *mddev)
  * Don't consider the device numbered 'ignore'
  * as we might be about to remove it.
  */
-static int enough(struct r10conf *conf, int ignore)
+static int _enough(struct r10conf *conf, struct geom *geo, int ignore)
 {
 	int first = 0;
 
@@ -1408,7 +1451,7 @@ static int enough(struct r10conf *conf, int ignore)
 			if (conf->mirrors[first].rdev &&
 			    first != ignore)
 				cnt++;
-			first = (first+1) % conf->geo.raid_disks;
+			first = (first+1) % geo->raid_disks;
 		}
 		if (cnt == 0)
 			return 0;
@@ -1416,6 +1459,12 @@ static int enough(struct r10conf *conf, int ignore)
 	return 1;
 }
 
+static int enough(struct r10conf *conf, int ignore)
+{
+	return _enough(conf, &conf->geo, ignore) &&
+		_enough(conf, &conf->prev, ignore);
+}
+
 static void error(struct mddev *mddev, struct md_rdev *rdev)
 {
 	char b[BDEVNAME_SIZE];
@@ -2223,7 +2272,9 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 				       " (%d sectors at %llu on %s)\n",
 				       mdname(mddev), s,
 				       (unsigned long long)(
-					       sect + rdev->data_offset),
+					       sect +
+					       choose_data_offset(r10_bio,
+								  rdev)),
 				       bdevname(rdev->bdev, b));
 				printk(KERN_NOTICE "md/raid10:%s: %s: failing "
 				       "drive\n",
@@ -2261,7 +2312,8 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 				       " (%d sectors at %llu on %s)\n",
 				       mdname(mddev), s,
 				       (unsigned long long)(
-					       sect + rdev->data_offset),
+					       sect +
+					       choose_data_offset(r10_bio, rdev)),
 				       bdevname(rdev->bdev, b));
 				printk(KERN_NOTICE "md/raid10:%s: %s: failing "
 				       "drive\n",
@@ -2274,7 +2326,8 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 				       " (%d sectors at %llu on %s)\n",
 				       mdname(mddev), s,
 				       (unsigned long long)(
-					       sect + rdev->data_offset),
+					       sect +
+					       choose_data_offset(r10_bio, rdev)),
 				       bdevname(rdev->bdev, b));
 				atomic_add(s, &rdev->corrected_errors);
 			}
@@ -2348,7 +2401,7 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 		wbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
 		md_trim_bio(wbio, sector - bio->bi_sector, sectors);
 		wbio->bi_sector = (r10_bio->devs[i].addr+
-				   rdev->data_offset+
+				   choose_data_offset(r10_bio, rdev) +
 				   (sector - r10_bio->sector));
 		wbio->bi_bdev = rdev->bdev;
 		if (submit_bio_wait(WRITE, wbio) == 0)
@@ -2425,7 +2478,7 @@ read_more:
 	r10_bio->devs[slot].bio = bio;
 	r10_bio->devs[slot].rdev = rdev;
 	bio->bi_sector = r10_bio->devs[slot].addr
-		+ rdev->data_offset;
+		+ choose_data_offset(r10_bio, rdev);
 	bio->bi_bdev = rdev->bdev;
 	bio->bi_rw = READ | do_sync;
 	bio->bi_private = r10_bio;
@@ -3246,7 +3299,8 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	else
 		sector_div(stride, fc);
 	conf->geo.stride = stride << conf->geo.chunk_shift;
-
+	conf->prev = conf->geo;
+	conf->reshape_progress = MaxSector;
 
 	spin_lock_init(&conf->device_lock);
 	INIT_LIST_HEAD(&conf->retry_list);
@@ -3312,8 +3366,10 @@ static int run(struct mddev *mddev)
 	rdev_for_each(rdev, mddev) {
 
 		disk_idx = rdev->raid_disk;
-		if (disk_idx >= conf->geo.raid_disks
-		    || disk_idx < 0)
+		if (disk_idx < 0)
+			continue;
+		if (disk_idx >= conf->geo.raid_disks &&
+		    disk_idx >= conf->prev.raid_disks)
 			continue;
 		disk = conf->mirrors + disk_idx;
 
@@ -3340,7 +3396,10 @@ static int run(struct mddev *mddev)
 	}
 
 	mddev->degraded = 0;
-	for (i = 0; i < conf->geo.raid_disks; i++) {
+	for (i = 0;
+	     i < conf->geo.raid_disks
+		     || i < conf->prev.raid_disks;
+	     i++) {
 
 		disk = conf->mirrors + i;
 
@@ -3459,6 +3518,9 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 	struct r10conf *conf = mddev->private;
 	sector_t oldsize, size;
 
+	if (mddev->reshape_position != MaxSector)
+		return -EBUSY;
+
 	if (conf->geo.far_copies > 1 && !conf->geo.far_offset)
 		return -EINVAL;
 
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 4c4942a..37509d7 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -34,13 +34,14 @@ struct r10conf {
 					       */
 		int		chunk_shift; /* shift from chunks to sectors */
 		sector_t	chunk_mask;
-	} geo;
+	} prev, geo;
 	int			copies;	      /* near_copies * far_copies.
 					       * must be <= raid_disks
 					       */
 
 	sector_t		dev_sectors;  /* temp copy of
 					       * mddev->dev_sectors */
+	sector_t		reshape_progress;
 
 	struct list_head	retry_list;
 	/* queue pending writes and submit them on unplug */
@@ -147,5 +148,10 @@ enum r10bio_state {
  */
 	R10BIO_MadeGood,
 	R10BIO_WriteError,
+/* During a reshape we might be performing IO on the
+ * 'previous' part of the array, in which case this
+ * flag is set
+ */
+	R10BIO_Previous,
 };
 #endif


