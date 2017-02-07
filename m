From: Shaohua Li <shli@fb.com>
Subject: [PATCH 5/5] md/raid10: don't abuse bio->bi_phys_segments
Date: Tue, 7 Feb 2017 08:56:02 -0800
Message-ID: <8d3fc89d0394e4a5117e8cc1272c08e3586fd8e8.1486485935.git.shli@fb.com>
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
 drivers/md/raid10.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1920756..77623ff 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -133,6 +133,12 @@ static void r10bio_pool_free(void *r10_bio, void *data)
 /* maximum number of concurrent requests, memory permitting */
 #define RESYNC_DEPTH (32*1024*1024/RESYNC_BLOCK_SIZE)
 
+/* The bio has a counter attached */
+static unsigned int *raid10_bio_ref_ptr(struct bio *bio)
+{
+	return md_get_per_bio_data(bio);
+}
+
 /*
  * When performing a resync, we need to read and compare, so
  * we need as many pages are there are copies.
@@ -304,11 +310,11 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
 	int done;
 	struct r10conf *conf = r10_bio->mddev->private;
 
-	if (bio->bi_phys_segments) {
+	if (*raid10_bio_ref_ptr(bio)) {
 		unsigned long flags;
 		spin_lock_irqsave(&conf->device_lock, flags);
-		bio->bi_phys_segments--;
-		done = (bio->bi_phys_segments == 0);
+		(*raid10_bio_ref_ptr(bio))--;
+		done = (*raid10_bio_ref_ptr(bio) == 0);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	} else
 		done = 1;
@@ -1162,10 +1168,10 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 				   - bio->bi_iter.bi_sector);
 		r10_bio->sectors = max_sectors;
 		spin_lock_irq(&conf->device_lock);
-		if (bio->bi_phys_segments == 0)
-			bio->bi_phys_segments = 2;
+		if (*raid10_bio_ref_ptr(bio) == 0)
+			*raid10_bio_ref_ptr(bio) = 2;
 		else
-			bio->bi_phys_segments++;
+			(*raid10_bio_ref_ptr(bio))++;
 		spin_unlock_irq(&conf->device_lock);
 		/*
 		 * Cannot call generic_make_request directly as that will be
@@ -1262,7 +1268,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	 * writing to those blocks.  This potentially requires several
 	 * writes to write around the bad blocks.  Each set of writes
 	 * gets its own r10_bio with a set of bios attached.  The number
-	 * of r10_bios is recored in bio->bi_phys_segments just as with
+	 * of r10_bios is recored in a counter just as with
 	 * the read case.
 	 */
 
@@ -1389,10 +1395,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		 */
 		r10_bio->sectors = max_sectors;
 		spin_lock_irq(&conf->device_lock);
-		if (bio->bi_phys_segments == 0)
-			bio->bi_phys_segments = 2;
+		if (*raid10_bio_ref_ptr(bio) == 0)
+			*raid10_bio_ref_ptr(bio) = 2;
 		else
-			bio->bi_phys_segments++;
+			(*raid10_bio_ref_ptr(bio))++;
 		spin_unlock_irq(&conf->device_lock);
 	}
 	sectors_handled = r10_bio->sector + max_sectors -
@@ -1493,7 +1499,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	if (sectors_handled < bio_sectors(bio)) {
 		one_write_done(r10_bio);
 		/* We need another r10_bio.  It has already been counted
-		 * in bio->bi_phys_segments.
+		 * in bio's counter.
 		 */
 		r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
@@ -1525,11 +1531,11 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 	/*
 	 * We might need to issue multiple reads to different devices if there
 	 * are bad blocks around, so we keep track of the number of reads in
-	 * bio->bi_phys_segments.  If this is 0, there is only one r10_bio and
+	 * a counter.  If this is 0, there is only one r10_bio and
 	 * no locking will be needed when the request completes.  If it is
 	 * non-zero, then it is the number of not-completed requests.
 	 */
-	bio->bi_phys_segments = 0;
+	*raid10_bio_ref_ptr(bio) = 0;
 	bio_clear_flag(bio, BIO_SEG_VALID);
 
 	if (bio_data_dir(bio) == READ)
@@ -1567,6 +1573,7 @@ static void raid10_make_request(struct mddev *mddev, struct bio *bio)
 					   (chunk_sects - 1)),
 					  GFP_NOIO, fs_bio_set);
 			bio_chain(split, bio);
+			md_bio_attach_data(mddev, split);
 		} else {
 			split = bio;
 		}
@@ -2667,10 +2674,10 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 			- mbio->bi_iter.bi_sector;
 		r10_bio->sectors = max_sectors;
 		spin_lock_irq(&conf->device_lock);
-		if (mbio->bi_phys_segments == 0)
-			mbio->bi_phys_segments = 2;
+		if (*raid10_bio_ref_ptr(mbio) == 0)
+			*raid10_bio_ref_ptr(mbio) = 2;
 		else
-			mbio->bi_phys_segments++;
+			(*raid10_bio_ref_ptr(mbio))++;
 		spin_unlock_irq(&conf->device_lock);
 		generic_make_request(bio);
 
@@ -4816,6 +4823,7 @@ static struct md_personality raid10_personality =
 	.start_reshape	= raid10_start_reshape,
 	.finish_reshape	= raid10_finish_reshape,
 	.congested	= raid10_congested,
+	.per_bio_data_size = sizeof(unsigned int),
 };
 
 static int __init raid_init(void)
-- 
2.9.3

