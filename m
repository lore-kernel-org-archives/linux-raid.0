From: NeilBrown <neilb@suse.de>
Subject: [PATCH 006 of 7] md: Check that internal bitmap does not overlap other data.
Date: Mon, 21 May 2007 11:33:33 +1000
Message-ID: <1070521013333.6790@suse.de>
References: <20070521111837.20906.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


We current completely trust user-space to set up metadata
describing an consistant array.  In particlar, that the metadata,
data, and bitmap do not overlap.
But userspace can be buggy, and it is better to report an error
than corrupt data.  So put in some appropriate checks.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |   35 +++++++++++++++++++++++++++++++++--
 ./drivers/md/md.c     |   22 +++++++++++++++++++++-
 2 files changed, 54 insertions(+), 3 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2007-05-21 11:17:57.000000000 +1000
+++ ./drivers/md/bitmap.c	2007-05-21 11:18:22.000000000 +1000
@@ -268,6 +268,31 @@ static int write_sb_page(struct bitmap *
 			if (page->index == bitmap->file_pages-1)
 				size = roundup(bitmap->last_page_size,
 					       bdev_hardsect_size(rdev->bdev));
+			/* Just make sure we aren't corrupting data or
+			 * metadata
+			 */
+			if (bitmap->offset < 0) {
+				/* DATA  BITMAP METADATA  */
+				if (bitmap->offset
+				    + page->index * (PAGE_SIZE/512)
+				    + size/512 > 0)
+					/* bitmap runs in to metadata */
+					return -EINVAL;
+				if (rdev->data_offset + mddev->size*2
+				    > rdev->sb_offset*2 + bitmap->offset)
+					/* data runs in to bitmap */
+					return -EINVAL;
+			} else if (rdev->sb_offset*2 < rdev->data_offset) {
+				/* METADATA BITMAP DATA */
+				if (rdev->sb_offset*2
+				    + bitmap->offset
+				    + page->index*(PAGE_SIZE/512) + size/512
+				    > rdev->data_offset)
+					/* bitmap runs in to data */
+					return -EINVAL;
+			} else {
+				/* DATA METADATA BITMAP - no problems */
+			}
 			md_super_write(mddev, rdev,
 				       (rdev->sb_offset<<1) + bitmap->offset
 				       + page->index * (PAGE_SIZE/512),
@@ -287,8 +312,14 @@ static int write_page(struct bitmap *bit
 {
 	struct buffer_head *bh;
 
-	if (bitmap->file == NULL)
-		return write_sb_page(bitmap, page, wait);
+	if (bitmap->file == NULL) {
+		switch (write_sb_page(bitmap, page, wait)) {
+		case -EINVAL:
+			bitmap->flags |= BITMAP_WRITE_ERROR;
+			return -EIO;
+		}
+		return 0;
+	}
 
 	bh = page_buffers(page);
 

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-05-21 11:18:00.000000000 +1000
+++ ./drivers/md/md.c	2007-05-21 11:18:22.000000000 +1000
@@ -3176,13 +3176,33 @@ static int do_md_run(mddev_t * mddev)
 	 * Drop all container device buffers, from now on
 	 * the only valid external interface is through the md
 	 * device.
-	 * Also find largest hardsector size
 	 */
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		if (test_bit(Faulty, &rdev->flags))
 			continue;
 		sync_blockdev(rdev->bdev);
 		invalidate_bdev(rdev->bdev);
+
+		/* perform some consistency tests on the device.
+		 * We don't want the data to overlap the metadata,
+		 * Internal Bitmap issues has handled elsewhere.
+		 */
+		if (rdev->data_offset < rdev->sb_offset) {
+			if (mddev->size &&
+			    rdev->data_offset + mddev->size*2
+			    > rdev->sb_offset*2) {
+				printk("md: %s: data overlaps metadata\n",
+				       mdname(mddev));
+				return -EINVAL;
+			}
+		} else {
+			if (rdev->sb_offset*2 + rdev->sb_size/512
+			    > rdev->data_offset) {
+				printk("md: %s: metadata overlaps data\n",
+				       mdname(mddev));
+				return -EINVAL;
+			}
+		}
 	}
 
 	md_probe(mddev->unit, NULL, NULL);
