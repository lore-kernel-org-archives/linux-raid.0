From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 1 of 12] Check return value of write_page, rather than ignore it
Date: Wed, 23 Mar 2005 16:47:10 +1100
Message-ID: <E1DDyhy-0004GO-Ou@notabene.cse.unsw.edu.au>
References: <20050323164208.16240.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-03-22 16:35:20.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-03-22 17:11:04.000000000 +1100
@@ -350,8 +350,7 @@ int bitmap_update_sb(struct bitmap *bitm
 	if (!bitmap->mddev->degraded)
 		sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
 	kunmap(bitmap->sb_page);
-	write_page(bitmap->sb_page, 0);
-	return 0;
+	return write_page(bitmap->sb_page, 0);
 }
 
 /* print out the bitmap file superblock */
@@ -735,7 +734,8 @@ int bitmap_unplug(struct bitmap *bitmap)
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 
 		if (attr & (BITMAP_PAGE_DIRTY | BITMAP_PAGE_NEEDWRITE))
-			write_page(page, 0);
+			if (write_page(page, 0))
+				return 1;
 	}
 	if (wait) { /* if any writes were performed, we need to wait on them */
 		spin_lock_irq(&bitmap->write_lock);
@@ -961,7 +961,7 @@ int bitmap_daemon_work(struct bitmap *bi
 				if (get_page_attr(bitmap, lastpage) & BITMAP_PAGE_NEEDWRITE) {
 					clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 					spin_unlock_irqrestore(&bitmap->lock, flags);
-					write_page(lastpage, 0);
+					err = write_page(lastpage, 0);
 				} else {
 					set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 					spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1009,7 +1009,7 @@ int bitmap_daemon_work(struct bitmap *bi
 		if (get_page_attr(bitmap, lastpage) &BITMAP_PAGE_NEEDWRITE) {
 			clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
-			write_page(lastpage, 0);
+			err = write_page(lastpage, 0);
 		} else {
 			set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1384,7 +1384,8 @@ int bitmap_setallbits(struct bitmap *bit
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 		memset(kmap(page), 0xff, PAGE_SIZE);
 		kunmap(page);
-		write_page(page, 0);
+		if (write_page(page, 0))
+			return 1;
 	}
 
 	return 0;
