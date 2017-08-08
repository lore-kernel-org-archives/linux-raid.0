From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2] md/bitmap: preserve whole sb_page when initializing bitmap
Date: Tue, 8 Aug 2017 13:36:44 -0700
Message-ID: <20170808203644.538499-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, shli@kernel.org
Cc: Song Liu <songliubraving@fb.com>, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

When bitmap_resize() is used to initialize the bitmap, it is
necessary to preserve the whole page of sb_page instead of just
the header (bitmap_super_t). This is because the sb_page may
contain bitmap read from the disks (initialized by mdadm).

Note that, this code path is only triggered with certain
combinations of parameters. One example is when raid456 array
is created with write journal.

To make the sb_page consistent across mutliple device, we also
update IO block size in write_sb_page() and read_sb_page() to
PAGE_SIZE.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/bitmap.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 40f3cd7..384e45d 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -162,8 +162,7 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
 
 		target = offset + index * (PAGE_SIZE/512);
 
-		if (sync_page_io(rdev, target,
-				 roundup(size, bdev_logical_block_size(rdev->bdev)),
+		if (sync_page_io(rdev, target, PAGE_SIZE,
 				 page, REQ_OP_READ, 0, true)) {
 			page->index = index;
 			return 0;
@@ -227,8 +226,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 			int last_page_size = store->bytes & (PAGE_SIZE-1);
 			if (last_page_size == 0)
 				last_page_size = PAGE_SIZE;
-			size = roundup(last_page_size,
-				       bdev_logical_block_size(bdev));
+			size = roundup(last_page_size, PAGE_SIZE);
 		}
 		/* Just make sure we aren't corrupting data or
 		 * metadata
@@ -2117,8 +2115,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 
 	if (store.sb_page && bitmap->storage.sb_page)
 		memcpy(page_address(store.sb_page),
-		       page_address(bitmap->storage.sb_page),
-		       sizeof(bitmap_super_t));
+		       page_address(bitmap->storage.sb_page), PAGE_SIZE);
 	bitmap_file_unmap(&bitmap->storage);
 	bitmap->storage = store;
 
-- 
2.9.3

