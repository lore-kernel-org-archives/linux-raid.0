From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] md/bitmap: preserve whole sb_page when initializing bitmap
Date: Tue, 1 Aug 2017 23:11:37 -0700
Message-ID: <20170802061137.2434370-1-songliubraving@fb.com>
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
is created with write journal

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/bitmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 40f3cd7..93dd809 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -2118,7 +2118,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	if (store.sb_page && bitmap->storage.sb_page)
 		memcpy(page_address(store.sb_page),
 		       page_address(bitmap->storage.sb_page),
-		       sizeof(bitmap_super_t));
+		       init ? PAGE_SIZE : sizeof(bitmap_super_t));
 	bitmap_file_unmap(&bitmap->storage);
 	bitmap->storage = store;
 
-- 
2.9.3

