From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 1/7] md: fix loading of out-of-date bitmap.
Date: Mon, 04 May 2009 16:58:49 +1000
Message-ID: <20090504065849.11688.86569.stgit@notabene.brown>
References: <20090504065540.11688.39505.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090504065540.11688.39505.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: stable@kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

When md is loading a bitmap which it knows is out of date, it fills
each page with 1s and writes it back out again.  However the
write_page call makes used of bitmap->file_pages and
bitmap->last_page_size which haven't been set correctly yet.  So this
can sometimes fail.

Move the setting of file_pages and last_page_size to before the call
to write_page.

This bug can cause the assembly on an array to fail, thus making the
data inaccessible.  Hence I think it is a suitable candidate for
-stable.

Cc: stable@kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 1fb91ed..bc1d64b 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -986,6 +986,9 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 			oldindex = index;
 			oldpage = page;
 
+			bitmap->filemap[bitmap->file_pages++] = page;
+			bitmap->last_page_size = count;
+
 			if (outofdate) {
 				/*
 				 * if bitmap is out of date, dirty the
@@ -998,15 +1001,9 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 				write_page(bitmap, page, 1);
 
 				ret = -EIO;
-				if (bitmap->flags & BITMAP_WRITE_ERROR) {
-					/* release, page not in filemap yet */
-					put_page(page);
+				if (bitmap->flags & BITMAP_WRITE_ERROR)
 					goto err;
-				}
 			}
-
-			bitmap->filemap[bitmap->file_pages++] = page;
-			bitmap->last_page_size = count;
 		}
 		paddr = kmap_atomic(page, KM_USER0);
 		if (bitmap->flags & BITMAP_HOSTENDIAN)


