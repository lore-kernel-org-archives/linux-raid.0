From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 008 of 8] Fix bitmap/read_sb_page so that it handles errors properly.
Date: Mon, 22 Aug 2005 11:59:14 +1000
Message-ID: <E1E71ak-0001IW-09@notabene.cse.unsw.edu.au>
References: <20050822115252.4868.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


read_sb_page assumed that if sync_page_io fails, the device would be
marked faultly.  However it isn't.  So in the face of error,
read_sb_page would loop forever.

Redo the logic so that this cannot happen.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-08-22 11:49:45.000000000 +1000
+++ ./drivers/md/bitmap.c	2005-08-22 11:49:50.000000000 +1000
@@ -270,19 +270,20 @@ static struct page *read_sb_page(mddev_t
 
 	if (!page)
 		return ERR_PTR(-ENOMEM);
-	do {
-		ITERATE_RDEV(mddev, rdev, tmp)
-			if (rdev->in_sync && !rdev->faulty)
-				goto found;
-		return ERR_PTR(-EIO);
 
-	found:
+	ITERATE_RDEV(mddev, rdev, tmp) {
+		if (! rdev->in_sync || rdev->faulty)
+			continue;
+
 		target = (rdev->sb_offset << 1) + offset + index * (PAGE_SIZE/512);
 
-	} while (!sync_page_io(rdev->bdev, target, PAGE_SIZE, page, READ));
+		if (sync_page_io(rdev->bdev, target, PAGE_SIZE, page, READ)) {
+			page->index = index;
+			return page;
+		}
+	}
+	return ERR_PTR(-EIO);
 
-	page->index = index;
-	return page;
 }
 
 static int write_sb_page(mddev_t *mddev, long offset, struct page *page, int wait)
