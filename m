From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 10/13] md: separate meta and data devs
Date: Wed, 12 Jan 2011 09:12:47 +1100
Message-ID: <20110111221247.12732.87882.stgit@notabene.brown>
References: <20110111221050.12732.31647.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111221050.12732.31647.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids

From: Jonathan Brassow <jbrassow@redhat.com>

Allow the metadata to be on a separate device from the
data.

This doesn't mean the data and metadata will by on separate
physical devices - it simply gives device-mapper and userspace
tools more flexibility.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |    6 +++++-
 drivers/md/md.c     |   10 ++++++----
 drivers/md/md.h     |    6 ++++++
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 1977765..6cf5871 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -264,14 +264,18 @@ static mdk_rdev_t *next_active_rdev(mdk_rdev_t *rdev, mddev_t *mddev)
 static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 {
 	mdk_rdev_t *rdev = NULL;
+	struct block_device *bdev;
 	mddev_t *mddev = bitmap->mddev;
 
 	while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
 		int size = PAGE_SIZE;
 		loff_t offset = mddev->bitmap_info.offset;
+
+		bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
+
 		if (page->index == bitmap->file_pages-1)
 			size = roundup(bitmap->last_page_size,
-				       bdev_logical_block_size(rdev->bdev));
+				       bdev_logical_block_size(bdev));
 		/* Just make sure we aren't corrupting data or
 		 * metadata
 		 */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0bc10cc..b98a85f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -765,7 +765,7 @@ void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 	 */
 	struct bio *bio = bio_alloc_mddev(GFP_NOIO, 1, mddev);
 
-	bio->bi_bdev = rdev->bdev;
+	bio->bi_bdev = rdev->meta_bdev ? rdev->meta_bdev : rdev->bdev;
 	bio->bi_sector = sector;
 	bio_add_page(bio, page, size, 0);
 	bio->bi_private = rdev;
@@ -803,7 +803,8 @@ int sync_page_io(mdk_rdev_t *rdev, sector_t sector, int size,
 
 	rw |= REQ_SYNC | REQ_UNPLUG;
 
-	bio->bi_bdev = rdev->bdev;
+	bio->bi_bdev = (metadata_op && rdev->meta_bdev) ?
+		rdev->meta_bdev : rdev->bdev;
 	if (metadata_op)
 		bio->bi_sector = sector + rdev->sb_start;
 	else
@@ -4435,7 +4436,9 @@ int md_run(mddev_t *mddev)
 		 * We don't want the data to overlap the metadata,
 		 * Internal Bitmap issues have been handled elsewhere.
 		 */
-		if (rdev->data_offset < rdev->sb_start) {
+		if (rdev->meta_bdev) {
+			/* Nothing to check */;
+		} else if (rdev->data_offset < rdev->sb_start) {
 			if (mddev->dev_sectors &&
 			    rdev->data_offset + mddev->dev_sectors
 			    > rdev->sb_start) {
@@ -5532,7 +5535,6 @@ static int update_size(mddev_t *mddev, sector_t num_sectors)
 	 * sb_start or, if that is <data_offset, it must fit before the size
 	 * of each device.  If num_sectors is zero, we find the largest size
 	 * that fits.
-
 	 */
 	if (mddev->sync_thread)
 		return -EBUSY;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7e4f358..eec517c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -60,6 +60,12 @@ struct mdk_rdev_s
 	mddev_t *mddev;			/* RAID array if running */
 	int last_events;		/* IO event timestamp */
 
+	/*
+	 * If meta_bdev is non-NULL, it means that a separate device is
+	 * being used to store the metadata (superblock/bitmap) which
+	 * would otherwise be contained on the same device as the data (bdev).
+	 */
+	struct block_device *meta_bdev;
 	struct block_device *bdev;	/* block device handle */
 
 	struct page	*sb_page;


