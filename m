From: gqjiang@suse.com
Subject: [PATCH 04/10] Show all bitmaps while examining bitmap
Date: Fri, 24 Apr 2015 15:30:35 +0800
Message-ID: <1429860641-5839-5-git-send-email-gqjiang@suse.com>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

This adds capability of exmining bitmaps corresponding to all
nodes/slots on the device.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 bitmap.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/bitmap.c b/bitmap.c
index b1d54a6..ab83f4e 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -258,7 +258,7 @@ int ExamineBitmap(char *filename, int brief, struct supertype *st)
 	int rv = 1;
 	char buf[64];
 	int swap;
-	int fd;
+	int fd, i;
 	__u32 uuid32[4];
 
 	fd = bitmap_file_open(filename, &st);
@@ -315,9 +315,6 @@ int ExamineBitmap(char *filename, int brief, struct supertype *st)
 		       uuid32[2],
 		       uuid32[3]);
 
-	printf("          Events : %llu\n", (unsigned long long)sb->events);
-	printf("  Events Cleared : %llu\n", (unsigned long long)sb->events_cleared);
-	printf("           State : %s\n", bitmap_state(sb->state));
 	printf("       Chunksize : %s\n", human_chunksize(sb->chunksize));
 	printf("          Daemon : %ds flush period\n", sb->daemon_sleep);
 	if (sb->write_behind)
@@ -327,11 +324,31 @@ int ExamineBitmap(char *filename, int brief, struct supertype *st)
 	printf("      Write Mode : %s\n", buf);
 	printf("       Sync Size : %llu%s\n", (unsigned long long)sb->sync_size/2,
 					human_size(sb->sync_size * 512));
-	if (brief)
-		goto free_info;
-	printf("          Bitmap : %llu bits (chunks), %llu dirty (%2.1f%%)\n",
-			info->total_bits, info->dirty_bits,
-			100.0 * info->dirty_bits / (info->total_bits?:1));
+	if (sb->nodes > 0) {
+		printf("   Cluster nodes : %d\n", sb->nodes);
+		printf("    Cluster name : %s\n", sb->cluster_name);
+	}
+	i = 0;
+	do {
+		if (i) {
+			free(info);
+			info = bitmap_fd_read(fd, brief);
+			sb = &info->sb;
+		}
+		if (sb->magic != BITMAP_MAGIC) {
+			pr_err("invalid bitmap magic 0x%x, the bitmap file appears to be corrupted\n", sb->magic);
+		}
+		printf("       Node Slot : %d\n", i);
+		printf("          Events : %llu\n", (unsigned long long)sb->events);
+		printf("  Events Cleared : %llu\n", (unsigned long long)sb->events_cleared);
+		printf("           State : %s\n", bitmap_state(sb->state));
+		if (brief)
+			continue;
+		printf("          Bitmap : %llu bits (chunks), %llu dirty (%2.1f%%)\n",
+				info->total_bits, info->dirty_bits,
+				100.0 * info->dirty_bits / (info->total_bits?:1));
+	} while (++i < (int)sb->nodes);
+
 free_info:
 	free(info);
 	return rv;
-- 
1.7.12.4

