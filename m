From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 06/54] md: Dont write more than is required of the last page of a bitmap
Date: Fri, 08 Jun 2007 00:21:33 -0700
Message-ID: <20070608072149.560764000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=md-don-t-write-more-than-is-required-of-the-last-page-of-a-bitmap.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
List-Id: linux-raid.ids

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: NeilBrown <neilb@suse.de>

It is possible that real data or metadata follows the bitmap
without full page alignment.
So limit the last write to be only the required number of bytes,
rounded up to the hard sector size of the device.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/md/bitmap.c         |   17 ++++++++++++-----
 include/linux/raid/bitmap.h |    1 +
 2 files changed, 13 insertions(+), 5 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- linux-2.6.21.4.orig/drivers/md/bitmap.c
+++ linux-2.6.21.4/drivers/md/bitmap.c
@@ -255,19 +255,25 @@ static struct page *read_sb_page(mddev_t
 
 }
 
-static int write_sb_page(mddev_t *mddev, long offset, struct page *page, int wait)
+static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 {
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
+	mddev_t *mddev = bitmap->mddev;
 
 	ITERATE_RDEV(mddev, rdev, tmp)
 		if (test_bit(In_sync, &rdev->flags)
-		    && !test_bit(Faulty, &rdev->flags))
+		    && !test_bit(Faulty, &rdev->flags)) {
+			int size = PAGE_SIZE;
+			if (page->index == bitmap->file_pages-1)
+				size = roundup(bitmap->last_page_size,
+					       bdev_hardsect_size(rdev->bdev));
 			md_super_write(mddev, rdev,
-				       (rdev->sb_offset<<1) + offset
+				       (rdev->sb_offset<<1) + bitmap->offset
 				       + page->index * (PAGE_SIZE/512),
-				       PAGE_SIZE,
+				       size,
 				       page);
+		}
 
 	if (wait)
 		md_super_wait(mddev);
@@ -282,7 +288,7 @@ static int write_page(struct bitmap *bit
 	struct buffer_head *bh;
 
 	if (bitmap->file == NULL)
-		return write_sb_page(bitmap->mddev, bitmap->offset, page, wait);
+		return write_sb_page(bitmap, page, wait);
 
 	bh = page_buffers(page);
 
@@ -923,6 +929,7 @@ static int bitmap_init_from_disk(struct 
 			}
 
 			bitmap->filemap[bitmap->file_pages++] = page;
+			bitmap->last_page_size = count;
 		}
 		paddr = kmap_atomic(page, KM_USER0);
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
--- linux-2.6.21.4.orig/include/linux/raid/bitmap.h
+++ linux-2.6.21.4/include/linux/raid/bitmap.h
@@ -232,6 +232,7 @@ struct bitmap {
 	struct page **filemap; /* list of cache pages for the file */
 	unsigned long *filemap_attr; /* attributes associated w/ filemap pages */
 	unsigned long file_pages; /* number of pages in the file */
+	int last_page_size; /* bytes in the last page */
 
 	unsigned long flags;
 

-- 
