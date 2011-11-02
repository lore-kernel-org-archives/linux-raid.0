From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 12/17] md/raid1: Allocate spare to store replacement
 devices and their bios.
Date: Wed, 02 Nov 2011 16:25:44 +1100
Message-ID: <20111102052544.17566.4451.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In RAID1, a replacement is much like a normal device, so we just
double the size of the relevant arrays and look at all possible
devices for reads and writes.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |   58 +++++++++++++++++++++++++++-------------------------
 drivers/md/raid1.h |    7 +++++-
 2 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 74d4ce5..99cd12e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -134,7 +134,7 @@ out_free_pages:
 			put_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
 	j = -1;
 out_free_bio:
-	while ( ++j < pi->raid_disks )
+	while (++j < pi->raid_disks)
 		bio_put(r1_bio->bios[j]);
 	r1bio_pool_free(r1_bio, data);
 	return NULL;
@@ -163,7 +163,7 @@ static void put_all_bios(struct r1conf *conf, struct r1bio *r1_bio)
 {
 	int i;
 
-	for (i = 0; i < conf->raid_disks; i++) {
+	for (i = 0; i < conf->raid_disks * 2; i++) {
 		struct bio **bio = r1_bio->bios + i;
 		if (!BIO_SPECIAL(*bio))
 			bio_put(*bio);
@@ -184,7 +184,7 @@ static void put_buf(struct r1bio *r1_bio)
 	struct r1conf *conf = r1_bio->mddev->private;
 	int i;
 
-	for (i=0; i<conf->raid_disks; i++) {
+	for (i = 0; i < conf->raid_disks * 2; i++) {
 		struct bio *bio = r1_bio->bios[i];
 		if (bio->bi_end_io)
 			rdev_dec_pending(conf->mirrors[i].rdev, r1_bio->mddev);
@@ -279,11 +279,11 @@ static int find_bio_disk(struct r1bio *r1_bio, struct bio *bio)
 	struct r1conf *conf = r1_bio->mddev->private;
 	int raid_disks = conf->raid_disks;
 
-	for (mirror = 0; mirror < raid_disks; mirror++)
+	for (mirror = 0; mirror < raid_disks * 2; mirror++)
 		if (r1_bio->bios[mirror] == bio)
 			break;
 
-	BUG_ON(mirror == raid_disks);
+	BUG_ON(mirror == raid_disks * 2);
 	update_head_pos(mirror, r1_bio);
 
 	return mirror;
@@ -505,7 +505,7 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 		start_disk = conf->last_used;
 	}
 
-	for (i = 0 ; i < conf->raid_disks ; i++) {
+	for (i = 0 ; i < conf->raid_disks * 2 ; i++) {
 		sector_t dist;
 		sector_t first_bad;
 		int bad_sectors;
@@ -974,7 +974,7 @@ read_again:
 	 */
 	plugged = mddev_check_plugged(mddev);
 
-	disks = conf->raid_disks;
+	disks = conf->raid_disks * 2;
  retry_write:
 	blocked_rdev = NULL;
 	rcu_read_lock();
@@ -1494,7 +1494,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				}
 			}
 			d++;
-			if (d == conf->raid_disks)
+			if (d == conf->raid_disks * 2)
 				d = 0;
 		} while (!success && d != r1_bio->read_disk);
 
@@ -1511,7 +1511,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			       mdname(mddev),
 			       bdevname(bio->bi_bdev, b),
 			       (unsigned long long)r1_bio->sector);
-			for (d = 0; d < conf->raid_disks; d++) {
+			for (d = 0; d < conf->raid_disks * 2; d++) {
 				rdev = conf->mirrors[d].rdev;
 				if (!rdev || test_bit(Faulty, &rdev->flags))
 					continue;
@@ -1537,7 +1537,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 		/* write it back and re-read */
 		while (d != r1_bio->read_disk) {
 			if (d == 0)
-				d = conf->raid_disks;
+				d = conf->raid_disks * 2;
 			d--;
 			if (r1_bio->bios[d]->bi_end_io != end_sync_read)
 				continue;
@@ -1552,7 +1552,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 		d = start;
 		while (d != r1_bio->read_disk) {
 			if (d == 0)
-				d = conf->raid_disks;
+				d = conf->raid_disks * 2;
 			d--;
 			if (r1_bio->bios[d]->bi_end_io != end_sync_read)
 				continue;
@@ -1585,7 +1585,7 @@ static int process_checks(struct r1bio *r1_bio)
 	int primary;
 	int i;
 
-	for (primary = 0; primary < conf->raid_disks; primary++)
+	for (primary = 0; primary < conf->raid_disks * 2; primary++)
 		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
 		    test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
 			r1_bio->bios[primary]->bi_end_io = NULL;
@@ -1593,7 +1593,7 @@ static int process_checks(struct r1bio *r1_bio)
 			break;
 		}
 	r1_bio->read_disk = primary;
-	for (i = 0; i < conf->raid_disks; i++) {
+	for (i = 0; i < conf->raid_disks * 2; i++) {
 		int j;
 		int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
 		struct bio *pbio = r1_bio->bios[primary];
@@ -1657,7 +1657,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 {
 	struct r1conf *conf = mddev->private;
 	int i;
-	int disks = conf->raid_disks;
+	int disks = conf->raid_disks * 2;
 	struct bio *bio, *wbio;
 
 	bio = r1_bio->bios[r1_bio->read_disk];
@@ -1738,7 +1738,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 				success = 1;
 			else {
 				d++;
-				if (d == conf->raid_disks)
+				if (d == conf->raid_disks * 2)
 					d = 0;
 			}
 		} while (!success && d != read_disk);
@@ -1754,7 +1754,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 		start = d;
 		while (d != read_disk) {
 			if (d==0)
-				d = conf->raid_disks;
+				d = conf->raid_disks * 2;
 			d--;
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
@@ -1766,7 +1766,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 		while (d != read_disk) {
 			char b[BDEVNAME_SIZE];
 			if (d==0)
-				d = conf->raid_disks;
+				d = conf->raid_disks * 2;
 			d--;
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
@@ -1888,7 +1888,7 @@ static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio
 {
 	int m;
 	int s = r1_bio->sectors;
-	for (m = 0; m < conf->raid_disks ; m++) {
+	for (m = 0; m < conf->raid_disks * 2 ; m++) {
 		struct md_rdev *rdev = conf->mirrors[m].rdev;
 		struct bio *bio = r1_bio->bios[m];
 		if (bio->bi_end_io == NULL)
@@ -1910,7 +1910,7 @@ static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio
 static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 {
 	int m;
-	for (m = 0; m < conf->raid_disks ; m++)
+	for (m = 0; m < conf->raid_disks * 2 ; m++)
 		if (r1_bio->bios[m] == IO_MADE_GOOD) {
 			struct md_rdev *rdev = conf->mirrors[m].rdev;
 			rdev_clear_badblocks(rdev,
@@ -2185,7 +2185,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 	r1_bio->state = 0;
 	set_bit(R1BIO_IsSync, &r1_bio->state);
 
-	for (i=0; i < conf->raid_disks; i++) {
+	for (i = 0; i < conf->raid_disks * 2; i++) {
 		struct md_rdev *rdev;
 		bio = r1_bio->bios[i];
 
@@ -2256,7 +2256,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 		 * need to mark them bad on all write targets
 		 */
 		int ok = 1;
-		for (i = 0 ; i < conf->raid_disks ; i++)
+		for (i = 0 ; i < conf->raid_disks * 2 ; i++)
 			if (r1_bio->bios[i]->bi_end_io == end_sync_write) {
 				struct md_rdev *rdev =
 					rcu_dereference(conf->mirrors[i].rdev);
@@ -2325,7 +2325,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 				len = sync_blocks<<9;
 		}
 
-		for (i=0 ; i < conf->raid_disks; i++) {
+		for (i = 0 ; i < conf->raid_disks * 2; i++) {
 			bio = r1_bio->bios[i];
 			if (bio->bi_end_io) {
 				page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
@@ -2358,7 +2358,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 	 */
 	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
 		atomic_set(&r1_bio->remaining, read_targets);
-		for (i=0; i<conf->raid_disks; i++) {
+		for (i = 0; i < conf->raid_disks * 2; i++) {
 			bio = r1_bio->bios[i];
 			if (bio->bi_end_io == end_sync_read) {
 				md_sync_acct(bio->bi_bdev, nr_sectors);
@@ -2395,7 +2395,8 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf)
 		goto abort;
 
-	conf->mirrors = kzalloc(sizeof(struct mirror_info)*mddev->raid_disks,
+	conf->mirrors = kzalloc(sizeof(struct mirror_info)
+				* mddev->raid_disks * 2,
 				 GFP_KERNEL);
 	if (!conf->mirrors)
 		goto abort;
@@ -2407,7 +2408,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	conf->poolinfo = kzalloc(sizeof(*conf->poolinfo), GFP_KERNEL);
 	if (!conf->poolinfo)
 		goto abort;
-	conf->poolinfo->raid_disks = mddev->raid_disks;
+	conf->poolinfo->raid_disks = mddev->raid_disks * 2;
 	conf->r1bio_pool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
 					  r1bio_pool_free,
 					  conf->poolinfo);
@@ -2440,7 +2441,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	conf->recovery_disabled = mddev->recovery_disabled - 1;
 
 	conf->last_used = -1;
-	for (i = 0; i < conf->raid_disks; i++) {
+	for (i = 0; i < conf->raid_disks * 2; i++) {
 
 		disk = conf->mirrors + i;
 
@@ -2667,7 +2668,7 @@ static int raid1_reshape(struct mddev *mddev)
 	if (!newpoolinfo)
 		return -ENOMEM;
 	newpoolinfo->mddev = mddev;
-	newpoolinfo->raid_disks = raid_disks;
+	newpoolinfo->raid_disks = raid_disks * 2;
 
 	newpool = mempool_create(NR_RAID1_BIOS, r1bio_pool_alloc,
 				 r1bio_pool_free, newpoolinfo);
@@ -2675,7 +2676,8 @@ static int raid1_reshape(struct mddev *mddev)
 		kfree(newpoolinfo);
 		return -ENOMEM;
 	}
-	newmirrors = kzalloc(sizeof(struct mirror_info) * raid_disks, GFP_KERNEL);
+	newmirrors = kzalloc(sizeof(struct mirror_info) * raid_disks * 2,
+			     GFP_KERNEL);
 	if (!newmirrors) {
 		kfree(newpoolinfo);
 		mempool_destroy(newpool);
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index c732b6c..80ded13 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -12,6 +12,9 @@ struct mirror_info {
  * pool was allocated for, so they know how much to allocate and free.
  * mddev->raid_disks cannot be used, as it can change while a pool is active
  * These two datums are stored in a kmalloced struct.
+ * The 'raid_disks' here is twice the raid_disks in r1conf.
+ * This allows space for each 'real' device can have a replacement in the
+ * second half of the array.
  */
 
 struct pool_info {
@@ -21,7 +24,9 @@ struct pool_info {
 
 struct r1conf {
 	struct mddev		*mddev;
-	struct mirror_info		*mirrors;
+	struct mirror_info	*mirrors;	/* twice 'raid_disks' to
+						 * allow for replacements.
+						 */
 	int			raid_disks;
 
 	/* When choose the best device for a read (read_balance())


