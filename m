From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 007 of 20] Make sure bitmap updates are visible through filesystem.
Date: Mon, 12 Dec 2005 14:14:10 +1100
Message-ID: <1051212031410.5007@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When we update a page_cache page in the kernel, we need to
flush_dache_page or userspace might not see the change.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |    2 ++
 1 file changed, 2 insertions(+)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-12-12 10:45:26.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-12-12 10:45:38.000000000 +1100
@@ -315,6 +315,8 @@ static int write_page(struct bitmap *bit
 	if (bitmap->file == NULL)
 		return write_sb_page(bitmap->mddev, bitmap->offset, page, wait);
 
+	flush_dcache_page(page); /* make sure visible to anyone reading the file */
+
 	if (wait)
 		lock_page(page);
 	else {
