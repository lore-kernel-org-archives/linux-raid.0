From: Cong Wang <amwang@redhat.com>
Subject: [PATCH 57/62] md: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:37 +0800
Message-ID: <1322371662-26166-58-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/md/bitmap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 8659515..4062823 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -525,7 +525,7 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
 	}
 	bitmap->sb_page->index = 0;
 
-	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = kmap_atomic(bitmap->sb_page);
 
 	sb->magic = cpu_to_le32(BITMAP_MAGIC);
 	sb->version = cpu_to_le32(BITMAP_MAJOR_HI);
@@ -533,7 +533,7 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
 	chunksize = bitmap->mddev->bitmap_info.chunksize;
 	BUG_ON(!chunksize);
 	if (!is_power_of_2(chunksize)) {
-		kunmap_atomic(sb, KM_USER0);
+		kunmap_atomic(sb);
 		printk(KERN_ERR "bitmap chunksize not a power of 2\n");
 		return -EINVAL;
 	}
@@ -571,7 +571,7 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
 	bitmap->flags |= BITMAP_HOSTENDIAN;
 	sb->version = cpu_to_le32(BITMAP_MAJOR_HOSTENDIAN);
 
-	kunmap_atomic(sb, KM_USER0);
+	kunmap_atomic(sb);
 
 	return 0;
 }
-- 
1.7.4.4

