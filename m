From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 10/22] md: move offset,
	daemon_sleep and chunksize out of bitmap structure
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.28321.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

... and into bitmap_info.  These are all configuration parameters
the need to be set before the bitmap is created.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |   51 ++++++++++++++++++++++++++++-----------------------
 drivers/md/bitmap.h |    6 +-----
 drivers/md/md.c     |    4 ++--
 drivers/md/md.h     |    3 +++
 drivers/md/raid1.c  |    3 ++-
 drivers/md/raid10.c |    2 +-
 6 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 4c70a01..921b084 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -287,27 +287,28 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 
 	while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
 			int size = PAGE_SIZE;
+			long offset = mddev->bitmap_info.offset;
 			if (page->index == bitmap->file_pages-1)
 				size = roundup(bitmap->last_page_size,
 					       bdev_logical_block_size(rdev->bdev));
 			/* Just make sure we aren't corrupting data or
 			 * metadata
 			 */
-			if (bitmap->offset < 0) {
+			if (offset < 0) {
 				/* DATA  BITMAP METADATA  */
-				if (bitmap->offset
+				if (offset
 				    + (long)(page->index * (PAGE_SIZE/512))
 				    + size/512 > 0)
 					/* bitmap runs in to metadata */
 					goto bad_alignment;
 				if (rdev->data_offset + mddev->dev_sectors
-				    > rdev->sb_start + bitmap->offset)
+				    > rdev->sb_start + offset)
 					/* data runs in to bitmap */
 					goto bad_alignment;
 			} else if (rdev->sb_start < rdev->data_offset) {
 				/* METADATA BITMAP DATA */
 				if (rdev->sb_start
-				    + bitmap->offset
+				    + offset
 				    + page->index*(PAGE_SIZE/512) + size/512
 				    > rdev->data_offset)
 					/* bitmap runs in to data */
@@ -316,7 +317,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 				/* DATA METADATA BITMAP - no problems */
 			}
 			md_super_write(mddev, rdev,
-				       rdev->sb_start + bitmap->offset
+				       rdev->sb_start + offset
 				       + page->index * (PAGE_SIZE/512),
 				       size,
 				       page);
@@ -550,7 +551,8 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 
 		bitmap->sb_page = read_page(bitmap->file, 0, bitmap, bytes);
 	} else {
-		bitmap->sb_page = read_sb_page(bitmap->mddev, bitmap->offset,
+		bitmap->sb_page = read_sb_page(bitmap->mddev,
+					       bitmap->mddev->bitmap_info.offset,
 					       NULL,
 					       0, sizeof(bitmap_super_t));
 	}
@@ -610,10 +612,10 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	}
 success:
 	/* assign fields using values from superblock */
-	bitmap->chunksize = chunksize;
-	bitmap->daemon_sleep = daemon_sleep;
+	bitmap->mddev->bitmap_info.chunksize = chunksize;
+	bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
 	bitmap->daemon_lastrun = jiffies;
-	bitmap->max_write_behind = write_behind;
+	bitmap->mddev->bitmap_info.max_write_behind = write_behind;
 	bitmap->flags |= le32_to_cpu(sb->state);
 	if (le32_to_cpu(sb->version) == BITMAP_MAJOR_HOSTENDIAN)
 		bitmap->flags |= BITMAP_HOSTENDIAN;
@@ -907,7 +909,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	chunks = bitmap->chunks;
 	file = bitmap->file;
 
-	BUG_ON(!file && !bitmap->offset);
+	BUG_ON(!file && !bitmap->mddev->bitmap_info.offset);
 
 #ifdef INJECT_FAULTS_3
 	outofdate = 1;
@@ -967,14 +969,15 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 				offset = sizeof(bitmap_super_t);
 				if (!file)
 					read_sb_page(bitmap->mddev,
-						     bitmap->offset,
+						     bitmap->mddev->bitmap_info.offset,
 						     page,
 						     index, count);
 			} else if (file) {
 				page = read_page(file, index, bitmap, count);
 				offset = 0;
 			} else {
-				page = read_sb_page(bitmap->mddev, bitmap->offset,
+				page = read_sb_page(bitmap->mddev,
+						    bitmap->mddev->bitmap_info.offset,
 						    NULL,
 						    index, count);
 				offset = 0;
@@ -1096,7 +1099,8 @@ void bitmap_daemon_work(mddev_t *mddev)
 		mutex_unlock(&mddev->open_mutex);
 		return;
 	}
-	if (time_before(jiffies, bitmap->daemon_lastrun + bitmap->daemon_sleep*HZ))
+	if (time_before(jiffies, bitmap->daemon_lastrun
+			+ bitmap->mddev->bitmap_info.daemon_sleep*HZ))
 		goto done;
 
 	bitmap->daemon_lastrun = jiffies;
@@ -1210,7 +1214,8 @@ void bitmap_daemon_work(mddev_t *mddev)
 
  done:
 	if (bitmap->allclean == 0)
-		bitmap->mddev->thread->timeout = bitmap->daemon_sleep * HZ;
+		bitmap->mddev->thread->timeout = 
+			bitmap->mddev->bitmap_info.daemon_sleep * HZ;
 	mutex_unlock(&mddev->open_mutex);
 }
 
@@ -1479,7 +1484,7 @@ void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector)
 		return;
 	}
 	if (time_before(jiffies, (bitmap->last_end_sync
-				  + bitmap->daemon_sleep * HZ)))
+				  + bitmap->mddev->bitmap_info.daemon_sleep * HZ)))
 		return;
 	wait_event(bitmap->mddev->recovery_wait,
 		   atomic_read(&bitmap->mddev->recovery_active) == 0);
@@ -1540,7 +1545,7 @@ void bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e)
 void bitmap_flush(mddev_t *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
-	int sleep;
+	long sleep;
 
 	if (!bitmap) /* there was no bitmap */
 		return;
@@ -1548,12 +1553,13 @@ void bitmap_flush(mddev_t *mddev)
 	/* run the daemon_work three time to ensure everything is flushed
 	 * that can be
 	 */
-	sleep = bitmap->daemon_sleep;
-	bitmap->daemon_sleep = 0;
+	sleep = mddev->bitmap_info.daemon_sleep * HZ * 2;
+	bitmap->daemon_lastrun -= sleep;
 	bitmap_daemon_work(mddev);
+	bitmap->daemon_lastrun -= sleep;
 	bitmap_daemon_work(mddev);
+	bitmap->daemon_lastrun -= sleep;
 	bitmap_daemon_work(mddev);
-	bitmap->daemon_sleep = sleep;
 	bitmap_update_sb(bitmap);
 }
 
@@ -1633,7 +1639,6 @@ int bitmap_create(mddev_t *mddev)
 	bitmap->mddev = mddev;
 
 	bitmap->file = file;
-	bitmap->offset = mddev->bitmap_info.offset;
 	if (file) {
 		get_file(file);
 		/* As future accesses to this file will use bmap,
@@ -1642,12 +1647,12 @@ int bitmap_create(mddev_t *mddev)
 		 */
 		vfs_fsync(file, file->f_dentry, 1);
 	}
-	/* read superblock from bitmap file (this sets bitmap->chunksize) */
+	/* read superblock from bitmap file (this sets mddev->bitmap_info.chunksize) */
 	err = bitmap_read_sb(bitmap);
 	if (err)
 		goto error;
 
-	bitmap->chunkshift = ffz(~bitmap->chunksize);
+	bitmap->chunkshift = ffz(~mddev->bitmap_info.chunksize);
 
 	/* now that chunksize and chunkshift are set, we can use these macros */
  	chunks = (blocks + CHUNK_BLOCK_RATIO(bitmap) - 1) >>
@@ -1689,7 +1694,7 @@ int bitmap_create(mddev_t *mddev)
 
 	mddev->bitmap = bitmap;
 
-	mddev->thread->timeout = bitmap->daemon_sleep * HZ;
+	mddev->thread->timeout = mddev->bitmap_info.daemon_sleep * HZ;
 
 	bitmap_update_sb(bitmap);
 
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 7e38d13..50ee424 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -106,7 +106,7 @@ typedef __u16 bitmap_counter_t;
 #define BITMAP_BLOCK_SHIFT 9
 
 /* how many blocks per chunk? (this is variable) */
-#define CHUNK_BLOCK_RATIO(bitmap) ((bitmap)->chunksize >> BITMAP_BLOCK_SHIFT)
+#define CHUNK_BLOCK_RATIO(bitmap) ((bitmap)->mddev->bitmap_info.chunksize >> BITMAP_BLOCK_SHIFT)
 #define CHUNK_BLOCK_SHIFT(bitmap) ((bitmap)->chunkshift - BITMAP_BLOCK_SHIFT)
 #define CHUNK_BLOCK_MASK(bitmap) (CHUNK_BLOCK_RATIO(bitmap) - 1)
 
@@ -209,7 +209,6 @@ struct bitmap {
 	int counter_bits; /* how many bits per block counter */
 
 	/* bitmap chunksize -- how much data does each bit represent? */
-	unsigned long chunksize;
 	unsigned long chunkshift; /* chunksize = 2^chunkshift (for bitops) */
 	unsigned long chunks; /* total number of data chunks for the array */
 
@@ -226,7 +225,6 @@ struct bitmap {
 	/* bitmap spinlock */
 	spinlock_t lock;
 
-	long offset; /* offset from superblock if file is NULL */
 	struct file *file; /* backing disk file */
 	struct page *sb_page; /* cached copy of the bitmap file superblock */
 	struct page **filemap; /* list of cache pages for the file */
@@ -238,7 +236,6 @@ struct bitmap {
 
 	int allclean;
 
-	unsigned long max_write_behind; /* write-behind mode */
 	atomic_t behind_writes;
 
 	/*
@@ -246,7 +243,6 @@ struct bitmap {
 	 * file, cleaning up bits and flushing out pages to disk as necessary
 	 */
 	unsigned long daemon_lastrun; /* jiffies of last run */
-	unsigned long daemon_sleep; /* how many seconds between updates? */
 	unsigned long last_end_sync; /* when we lasted called end_sync to
 				      * update bitmap with resync progress */
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b989189..9f797ac 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6102,14 +6102,14 @@ static int md_seq_show(struct seq_file *seq, void *v)
 			unsigned long chunk_kb;
 			unsigned long flags;
 			spin_lock_irqsave(&bitmap->lock, flags);
-			chunk_kb = bitmap->chunksize >> 10;
+			chunk_kb = mddev->bitmap_info.chunksize >> 10;
 			seq_printf(seq, "bitmap: %lu/%lu pages [%luKB], "
 				"%lu%s chunk",
 				bitmap->pages - bitmap->missing_pages,
 				bitmap->pages,
 				(bitmap->pages - bitmap->missing_pages)
 					<< (PAGE_SHIFT - 10),
-				chunk_kb ? chunk_kb : bitmap->chunksize,
+				chunk_kb ? chunk_kb : mddev->bitmap_info.chunksize,
 				chunk_kb ? "KB" : "B");
 			if (bitmap->file) {
 				seq_printf(seq, ", file: ");
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 94a8e51..b35b29d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -290,6 +290,9 @@ struct mddev_s
 							 * hot-adding a bitmap.  It should
 							 * eventually be settable by sysfs.
 							 */
+		unsigned long		chunksize;
+		unsigned long		daemon_sleep; /* how many seconds between updates? */
+		unsigned long		max_write_behind; /* write-behind mode */
 	} bitmap_info;
 	struct list_head		all_mddevs;
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 18da334..da017f0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -943,7 +943,8 @@ static int make_request(struct request_queue *q, struct bio * bio)
 
 	/* do behind I/O ? */
 	if (bitmap &&
-	    atomic_read(&bitmap->behind_writes) < bitmap->max_write_behind &&
+	    (atomic_read(&bitmap->behind_writes)
+	     < mddev->bitmap_info.max_write_behind) &&
 	    (behind_pages = alloc_behind_pages(bio)) != NULL)
 		set_bit(R1BIO_BehindIO, &r1_bio->state);
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2fbf867..2255e33 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2277,7 +2277,7 @@ static void raid10_quiesce(mddev_t *mddev, int state)
 	}
 	if (mddev->thread) {
 		if (mddev->bitmap)
-			mddev->thread->timeout = mddev->bitmap->daemon_sleep * HZ;
+			mddev->thread->timeout = mddev->bitmap_info.daemon_sleep * HZ;
 		else
 			mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
 		md_wakeup_thread(mddev->thread);


