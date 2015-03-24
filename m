From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH] Fix bitmap offset calculations
Date: Tue, 24 Mar 2015 11:29:05 -0500
Message-ID: <20150324162905.GA16104@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The calculations of bitmap offset is incorrect with respect to bits to bytes
conversion.

Also, remove an irrelevant duplicate message.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index ac79fef..e98db04 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -575,7 +575,9 @@ re_read:
 
 		sector_div(bm_blocks,
 			   bitmap->mddev->bitmap_info.chunksize >> 9);
-		bm_blocks = bm_blocks << 3;
+		/* bits to bytes */
+		bm_blocks = ((bm_blocks+7) >> 3) + sizeof(bitmap_super_t);
+		/* to 4k blocks */
 		bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks, 4096);
 		bitmap->mddev->bitmap_info.offset += bitmap->cluster_slot * (bm_blocks << 3);
 		pr_info("%s:%d bm slot: %d offset: %llu\n", __func__, __LINE__,
@@ -672,9 +674,6 @@ out:
 			goto out_no_sb;
 		}
 		bitmap->cluster_slot = md_cluster_ops->slot_number(bitmap->mddev);
-		pr_info("%s:%d bm slot: %d offset: %llu\n", __func__, __LINE__,
-			bitmap->cluster_slot,
-			(unsigned long long)bitmap->mddev->bitmap_info.offset);
 		goto re_read;
 	}
 
