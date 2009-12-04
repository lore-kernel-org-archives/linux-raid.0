From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 13/22] md: support bitmap offset appropriate for
	external-metadata arrays.
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.46244.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

For md arrays were metadata is managed externally, the kernel does not
know about a superblock so the superblock offset is 0.
If we want to have a write-intent-bitmap near the end of the
devices of such an array, we should support sector_t sized offset.
We need offset be possibly negative for when the bitmap is before
the metadata, so use loff_t instead.

Also add sanity check that bitmap does not overlap with data.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |   14 +++++++++++---
 drivers/md/md.h     |    6 ++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 4df173a..5b77e5c 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -212,7 +212,7 @@ static void bitmap_checkfree(struct bitmap *bitmap, unsigned long page)
  */
 
 /* IO operations when bitmap is stored near all superblocks */
-static struct page *read_sb_page(mddev_t *mddev, long offset,
+static struct page *read_sb_page(mddev_t *mddev, loff_t offset,
 				 struct page *page,
 				 unsigned long index, int size)
 {
@@ -287,14 +287,22 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 
 	while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
 			int size = PAGE_SIZE;
-			long offset = mddev->bitmap_info.offset;
+			loff_t offset = mddev->bitmap_info.offset;
 			if (page->index == bitmap->file_pages-1)
 				size = roundup(bitmap->last_page_size,
 					       bdev_logical_block_size(rdev->bdev));
 			/* Just make sure we aren't corrupting data or
 			 * metadata
 			 */
-			if (offset < 0) {
+			if (mddev->external) {
+				/* Bitmap could be anywhere. */
+				if (rdev->sb_start + offset + (page->index *(PAGE_SIZE/512)) >
+				    rdev->data_offset &&
+				    rdev->sb_start + offset < 
+				    rdev->data_offset + mddev->dev_sectors +
+				    (PAGE_SIZE/512))
+					goto bad_alignment;
+			} else if (offset < 0) {
 				/* DATA  BITMAP METADATA  */
 				if (offset
 				    + (long)(page->index * (PAGE_SIZE/512))
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b35b29d..aa67532 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -282,11 +282,13 @@ struct mddev_s
 	struct bitmap                   *bitmap; /* the bitmap for the device */
 	struct {
 		struct file		*file; /* the bitmap file */
-		long			offset; /* offset from superblock of
+		loff_t			offset; /* offset from superblock of
 						 * start of bitmap. May be
 						 * negative, but not '0'
+						 * For external metadata, offset
+						 * from start of device. 
 						 */
-		long			default_offset; /* this is the offset to use when
+		loff_t			default_offset; /* this is the offset to use when
 							 * hot-adding a bitmap.  It should
 							 * eventually be settable by sysfs.
 							 */


