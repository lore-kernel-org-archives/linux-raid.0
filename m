From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 2/3] md-cluster: introduce clear_clusterinfo_from_sb
Date: Fri, 20 Nov 2015 16:35:24 +0800
Message-ID: <1448008525-17095-2-git-send-email-gqjiang@suse.com>
References: <1448008525-17095-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1448008525-17095-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com
Cc: rgoldwyn@suse.com, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

To change the bitmap from clustered to none, we also
need to clean related info about cluster from sb, such
as version, nodes and cluster_name.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/bitmap.c | 25 +++++++++++++++++++++++++
 drivers/md/bitmap.h |  1 +
 drivers/md/md.c     |  1 +
 3 files changed, 27 insertions(+)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 4f22e91..c11390f 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -417,6 +417,31 @@ out:
 /*
  * bitmap file superblock operations
  */
+void clear_clusterinfo_from_sb(struct bitmap *bitmap)
+{
+	bitmap_super_t *sb;
+
+	if (!bitmap || !bitmap->mddev) /* no bitmap for this array */
+		return;
+	if (bitmap->mddev->bitmap_info.external)
+		return;
+	if (!bitmap->storage.sb_page) /* no superblock */
+		return;
+	sb = kmap_atomic(bitmap->storage.sb_page);
+	sb->nodes = 0;
+	sb->version = cpu_to_le32(BITMAP_MAJOR_HI);
+	memset(sb->cluster_name, NULL, 64);
+
+	kunmap_atomic(sb);
+	/* Don't write until any other writes have completed */
+	if (bitmap->storage.file)
+		wait_event(bitmap->write_wait,
+			   atomic_read(&bitmap->pending_writes)==0);
+	else
+		md_super_wait(bitmap->mddev);
+
+	write_page(bitmap, bitmap->storage.sb_page, 1);
+}
 
 /* update the event counter and sync the superblock to disk */
 void bitmap_update_sb(struct bitmap *bitmap)
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 7d5c3a6..1d0975b 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -241,6 +241,7 @@ void bitmap_flush(struct mddev *mddev);
 void bitmap_destroy(struct mddev *mddev);
 
 void bitmap_print_sb(struct bitmap *bitmap);
+void clear_clusterinfo_from_sb(struct bitmap *bitmap);
 void bitmap_update_sb(struct bitmap *bitmap);
 void bitmap_status(struct seq_file *seq, struct bitmap *bitmap);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 47ee8ae..f06dc43 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6598,6 +6598,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				}
 
 				mddev->bitmap_info.nodes = 0;
+				clear_clusterinfo_from_sb(mddev->bitmap);
 				md_cluster_ops->leave(mddev);
 			}
 			mddev->pers->quiesce(mddev, 1);
-- 
2.1.4

