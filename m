From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 03/28] drivers/md: Remove unnecessary casts of void *
Date: Thu, 15 Apr 2010 16:21:07 +1000
Message-ID: <20100415062107.5126.78846.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
List-Id: linux-raid.ids

From: H Hartley Sweeten <hartleys@visionengravers.com>

void pointers do not need to be cast to other pointer types.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c    |    8 ++++----
 drivers/md/faulty.c    |    6 +++---
 drivers/md/multipath.c |    2 +-
 drivers/md/raid1.c     |    8 ++++----
 drivers/md/raid10.c    |    8 ++++----
 drivers/md/raid5.c     |   10 +++++-----
 6 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 6279393..49d6080 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -505,7 +505,7 @@ void bitmap_update_sb(struct bitmap *bitmap)
 		return;
 	}
 	spin_unlock_irqrestore(&bitmap->lock, flags);
-	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
 	if (bitmap->mddev->events < bitmap->events_cleared) {
 		/* rocking back to read-only */
@@ -526,7 +526,7 @@ void bitmap_print_sb(struct bitmap *bitmap)
 
 	if (!bitmap || !bitmap->sb_page)
 		return;
-	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
 	printk(KERN_DEBUG "%s: bitmap file superblock:\n", bmname(bitmap));
 	printk(KERN_DEBUG "         magic: %08x\n", le32_to_cpu(sb->magic));
 	printk(KERN_DEBUG "       version: %d\n", le32_to_cpu(sb->version));
@@ -575,7 +575,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 		return err;
 	}
 
-	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
 
 	chunksize = le32_to_cpu(sb->chunksize);
 	daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
@@ -661,7 +661,7 @@ static int bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
 		return 0;
 	}
 	spin_unlock_irqrestore(&bitmap->lock, flags);
-	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
 	old = le32_to_cpu(sb->state) & bits;
 	switch (op) {
 		case MASK_SET: sb->state |= cpu_to_le32(bits);
diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 713acd0..608a8d3 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -171,7 +171,7 @@ static void add_sector(conf_t *conf, sector_t start, int mode)
 static int make_request(struct request_queue *q, struct bio *bio)
 {
 	mddev_t *mddev = q->queuedata;
-	conf_t *conf = (conf_t*)mddev->private;
+	conf_t *conf = mddev->private;
 	int failit = 0;
 
 	if (bio_data_dir(bio) == WRITE) {
@@ -224,7 +224,7 @@ static int make_request(struct request_queue *q, struct bio *bio)
 
 static void status(struct seq_file *seq, mddev_t *mddev)
 {
-	conf_t *conf = (conf_t*)mddev->private;
+	conf_t *conf = mddev->private;
 	int n;
 
 	if ((n=atomic_read(&conf->counters[WriteTransient])) != 0)
@@ -327,7 +327,7 @@ static int run(mddev_t *mddev)
 
 static int stop(mddev_t *mddev)
 {
-	conf_t *conf = (conf_t *)mddev->private;
+	conf_t *conf = mddev->private;
 
 	kfree(conf);
 	mddev->private = NULL;
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 5558ebc..97befd5 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -84,7 +84,7 @@ static void multipath_end_bh_io (struct multipath_bh *mp_bh, int err)
 static void multipath_end_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct multipath_bh * mp_bh = (struct multipath_bh *)(bio->bi_private);
+	struct multipath_bh *mp_bh = bio->bi_private;
 	multipath_conf_t *conf = mp_bh->mddev->private;
 	mdk_rdev_t *rdev = conf->multipaths[mp_bh->path].rdev;
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f741f77..ff6f97b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -262,7 +262,7 @@ static inline void update_head_pos(int disk, r1bio_t *r1_bio)
 static void raid1_end_read_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
+	r1bio_t *r1_bio = bio->bi_private;
 	int mirror;
 	conf_t *conf = r1_bio->mddev->private;
 
@@ -307,7 +307,7 @@ static void raid1_end_read_request(struct bio *bio, int error)
 static void raid1_end_write_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
+	r1bio_t *r1_bio = bio->bi_private;
 	int mirror, behind = test_bit(R1BIO_BehindIO, &r1_bio->state);
 	conf_t *conf = r1_bio->mddev->private;
 	struct bio *to_put = NULL;
@@ -1222,7 +1222,7 @@ abort:
 
 static void end_sync_read(struct bio *bio, int error)
 {
-	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
+	r1bio_t *r1_bio = bio->bi_private;
 	int i;
 
 	for (i=r1_bio->mddev->raid_disks; i--; )
@@ -1245,7 +1245,7 @@ static void end_sync_read(struct bio *bio, int error)
 static void end_sync_write(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
+	r1bio_t *r1_bio = bio->bi_private;
 	mddev_t *mddev = r1_bio->mddev;
 	conf_t *conf = mddev->private;
 	int i;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b4ba41e..b90fef6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -254,7 +254,7 @@ static inline void update_head_pos(int slot, r10bio_t *r10_bio)
 static void raid10_end_read_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	r10bio_t * r10_bio = (r10bio_t *)(bio->bi_private);
+	r10bio_t *r10_bio = bio->bi_private;
 	int slot, dev;
 	conf_t *conf = r10_bio->mddev->private;
 
@@ -295,7 +295,7 @@ static void raid10_end_read_request(struct bio *bio, int error)
 static void raid10_end_write_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	r10bio_t * r10_bio = (r10bio_t *)(bio->bi_private);
+	r10bio_t *r10_bio = bio->bi_private;
 	int slot, dev;
 	conf_t *conf = r10_bio->mddev->private;
 
@@ -1223,7 +1223,7 @@ abort:
 
 static void end_sync_read(struct bio *bio, int error)
 {
-	r10bio_t * r10_bio = (r10bio_t *)(bio->bi_private);
+	r10bio_t *r10_bio = bio->bi_private;
 	conf_t *conf = r10_bio->mddev->private;
 	int i,d;
 
@@ -1260,7 +1260,7 @@ static void end_sync_read(struct bio *bio, int error)
 static void end_sync_write(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	r10bio_t * r10_bio = (r10bio_t *)(bio->bi_private);
+	r10bio_t *r10_bio = bio->bi_private;
 	mddev_t *mddev = r10_bio->mddev;
 	conf_t *conf = mddev->private;
 	int i,d;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 70ffbd0..04139d9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1618,7 +1618,7 @@ static void raid5_build_block(struct stripe_head *sh, int i, int previous)
 static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	char b[BDEVNAME_SIZE];
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 	pr_debug("raid5: error called\n");
 
 	if (!test_bit(Faulty, &rdev->flags)) {
@@ -4057,7 +4057,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	 * As the reads complete, handle_stripe will copy the data
 	 * into the destination stripe and release that stripe.
 	 */
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 	struct stripe_head *sh;
 	sector_t first_sector, last_sector;
 	int raid_disks = conf->previous_raid_disks;
@@ -4266,7 +4266,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 /* FIXME go_faster isn't used */
 static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, int go_faster)
 {
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 	struct stripe_head *sh;
 	sector_t max_sector = mddev->dev_sectors;
 	int sync_blocks;
@@ -5130,7 +5130,7 @@ abort:
 
 static int stop(mddev_t *mddev)
 {
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
@@ -5178,7 +5178,7 @@ static void printall(struct seq_file *seq, raid5_conf_t *conf)
 
 static void status(struct seq_file *seq, mddev_t *mddev)
 {
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 	int i;
 
 	seq_printf(seq, " level %d, %dk chunk, algorithm %d", mddev->level,


