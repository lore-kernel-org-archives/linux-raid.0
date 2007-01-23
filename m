From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 4] md: Avoid reading past the end of a bitmap file.
Date: Tue, 23 Jan 2007 11:27:01 +1100
Message-ID: <1070123002701.29489@suse.de>
References: <20070123112437.29357.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


In most cases we check the size of the bitmap file before
reading data from it.  However when reading the superblock,
we always read the first PAGE_SIZE bytes, which might not 
always be appropriate.  So limit that read to the size of the
file if appropriate.

Also, we get the count of available bytes wrong in one place,
so that too can read past the end of the file.

Cc:  "yang yin" <yinyang801120@gmail.com>

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2007-01-23 11:13:43.000000000 +1100
+++ ./drivers/md/bitmap.c	2007-01-23 11:24:09.000000000 +1100
@@ -479,9 +479,12 @@ static int bitmap_read_sb(struct bitmap 
 	int err = -EINVAL;
 
 	/* page 0 is the superblock, read it... */
-	if (bitmap->file)
-		bitmap->sb_page = read_page(bitmap->file, 0, bitmap, PAGE_SIZE);
-	else {
+	if (bitmap->file) {
+		loff_t isize = i_size_read(bitmap->file->f_mapping->host);
+		int bytes = isize > PAGE_SIZE ? PAGE_SIZE : isize;
+
+		bitmap->sb_page = read_page(bitmap->file, 0, bitmap, bytes);
+	} else {
 		bitmap->sb_page = read_sb_page(bitmap->mddev, bitmap->offset, 0);
 	}
 	if (IS_ERR(bitmap->sb_page)) {
@@ -877,7 +880,8 @@ static int bitmap_init_from_disk(struct 
 			int count;
 			/* unmap the old page, we're done with it */
 			if (index == num_pages-1)
-				count = bytes - index * PAGE_SIZE;
+				count = bytes + sizeof(bitmap_super_t)
+					- index * PAGE_SIZE;
 			else
 				count = PAGE_SIZE;
 			if (index == 0) {
