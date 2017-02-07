From: Shaohua Li <shli@fb.com>
Subject: [PATCH 4/5] md/raid1: don't abuse bio->bi_phys_segments
Date: Tue, 7 Feb 2017 08:56:01 -0800
Message-ID: <bf9bae0512427d28fece6c2ed1422441384c1649.1486485935.git.shli@fb.com>
References: <cover.1486485935.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1486485935.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: khlebnikov@yandex-team.ru, hch@lst.de, neilb@suse.com
List-Id: linux-raid.ids

Allocates extra data (an 'unsigned int') for bio reference accounting.
Don't need to abuse bio->bi_phys_segments.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid1.c | 44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7b0f647..daa4038 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -102,6 +102,11 @@ static void r1bio_pool_free(void *r1_bio, void *data)
 #define CLUSTER_RESYNC_WINDOW_SECTORS (CLUSTER_RESYNC_WINDOW >> 9)
 #define NEXT_NORMALIO_DISTANCE (3 * RESYNC_WINDOW_SECTORS)
 
+static unsigned int *raid1_bio_ref_ptr(struct bio *bio)
+{
+	return md_get_per_bio_data(bio);
+}
+
 static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct pool_info *pi = data;
@@ -246,15 +251,15 @@ static void call_bio_endio(struct r1bio *r1_bio)
 	sector_t start_next_window = r1_bio->start_next_window;
 	sector_t bi_sector = bio->bi_iter.bi_sector;
 
-	if (bio->bi_phys_segments) {
+	if (*raid1_bio_ref_ptr(bio)) {
 		unsigned long flags;
 		spin_lock_irqsave(&conf->device_lock, flags);
-		bio->bi_phys_segments--;
-		done = (bio->bi_phys_segments == 0);
+		(*raid1_bio_ref_ptr(bio))--;
+		done = (*raid1_bio_ref_ptr(bio) == 0);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 		/*
 		 * make_request() might be waiting for
-		 * bi_phys_segments to decrease
+		 * bio reference count to decrease
 		 */
 		wake_up(&conf->wait_barrier);
 	} else
@@ -1138,10 +1143,10 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 				   - bio->bi_iter.bi_sector);
 		r1_bio->sectors = max_sectors;
 		spin_lock_irq(&conf->device_lock);
-		if (bio->bi_phys_segments == 0)
-			bio->bi_phys_segments = 2;
+		if (*raid1_bio_ref_ptr(bio) == 0)
+			*raid1_bio_ref_ptr(bio) = 2;
 		else
-			bio->bi_phys_segments++;
+			(*raid1_bio_ref_ptr(bio))++;
 		spin_unlock_irq(&conf->device_lock);
 
 		/*
@@ -1316,13 +1321,13 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		start_next_window = wait_barrier(conf, bio);
 		/*
 		 * We must make sure the multi r1bios of bio have
-		 * the same value of bi_phys_segments
+		 * the same value of reference count
 		 */
-		if (bio->bi_phys_segments && old &&
+		if (*raid1_bio_ref_ptr(bio) && old &&
 		    old != start_next_window)
 			/* Wait for the former r1bio(s) to complete */
 			wait_event(conf->wait_barrier,
-				   bio->bi_phys_segments == 1);
+				   *raid1_bio_ref_ptr(bio) == 1);
 		goto retry_write;
 	}
 
@@ -1332,10 +1337,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		 */
 		r1_bio->sectors = max_sectors;
 		spin_lock_irq(&conf->device_lock);
-		if (bio->bi_phys_segments == 0)
-			bio->bi_phys_segments = 2;
+		if (*raid1_bio_ref_ptr(bio) == 0)
+			*raid1_bio_ref_ptr(bio) = 2;
 		else
-			bio->bi_phys_segments++;
+			(*raid1_bio_ref_ptr(bio))++;
 		spin_unlock_irq(&conf->device_lock);
 	}
 	sectors_handled = r1_bio->sector + max_sectors - bio->bi_iter.bi_sector;
@@ -1428,7 +1433,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	if (sectors_handled < bio_sectors(bio)) {
 		r1_bio_write_done(r1_bio);
 		/* We need another r1_bio.  It has already been counted
-		 * in bio->bi_phys_segments
+		 * in bio reference count
 		 */
 		r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
 		r1_bio->master_bio = bio;
@@ -1466,11 +1471,11 @@ static void raid1_make_request(struct mddev *mddev, struct bio *bio)
 	/*
 	 * We might need to issue multiple reads to different devices if there
 	 * are bad blocks around, so we keep track of the number of reads in
-	 * bio->bi_phys_segments.  If this is 0, there is only one r1_bio and
+	 * bio reference count.  If this is 0, there is only one r1_bio and
 	 * no locking will be needed when requests complete.  If it is
 	 * non-zero, then it is the number of not-completed requests.
 	 */
-	bio->bi_phys_segments = 0;
+	*raid1_bio_ref_ptr(bio) = 0;
 	bio_clear_flag(bio, BIO_SEG_VALID);
 
 	if (bio_data_dir(bio) == READ)
@@ -2438,10 +2443,10 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 					       - mbio->bi_iter.bi_sector);
 			r1_bio->sectors = max_sectors;
 			spin_lock_irq(&conf->device_lock);
-			if (mbio->bi_phys_segments == 0)
-				mbio->bi_phys_segments = 2;
+			if (*raid1_bio_ref_ptr(mbio) == 0)
+				*raid1_bio_ref_ptr(mbio) = 2;
 			else
-				mbio->bi_phys_segments++;
+				(*raid1_bio_ref_ptr(mbio))++;
 			spin_unlock_irq(&conf->device_lock);
 			trace_block_bio_remap(bdev_get_queue(bio->bi_bdev),
 					      bio, bio_dev, bio_sector);
@@ -3289,6 +3294,7 @@ static struct md_personality raid1_personality =
 	.quiesce	= raid1_quiesce,
 	.takeover	= raid1_takeover,
 	.congested	= raid1_congested,
+	.per_bio_data_size = sizeof(unsigned int),
 };
 
 static int __init raid_init(void)
-- 
2.9.3

