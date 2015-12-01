From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 4/4] mdadm: do not display bitmap info if it is cleared
Date: Wed,  2 Dec 2015 00:30:12 +0800
Message-ID: <1448987412-3932-4-git-send-email-gqjiang@suse.com>
References: <1448987412-3932-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1448987412-3932-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com, linux-raid@vger.kernel.org
Cc: rgoldwyn@suse.com, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

"mdadm -X DISK" is used to report information about a bitmap
file, it is better to not display all the related infos if
bitmap is cleared with "--bitmap=none" under grow mode.

To do that, the locate_bitmap is changed a little to have a
return value based on MD_FEATURE_BITMAP_OFFSET.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 bitmap.c |  8 ++++++--
 mdadm.h  |  2 +-
 super0.c |  7 ++++---
 super1.c | 12 +++++++++---
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/bitmap.c b/bitmap.c
index 803eda3..dab674b 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -221,8 +221,12 @@ int bitmap_file_open(char *filename, struct supertype **stp)
 			pr_err("No bitmap possible with %s metadata\n",
 				st->ss->name);
 			return -1;
-		} else
-			st->ss->locate_bitmap(st, fd);
+		} else {
+			if (st->ss->locate_bitmap(st, fd)) {
+				pr_err("%s doesn't have bitmap\n", filename);
+				fd = -1;
+			}
+		}
 
 		*stp = st;
 	} else {
diff --git a/mdadm.h b/mdadm.h
index 5d5e97f..aad0fa8 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -873,7 +873,7 @@ extern struct superswitch {
 	/* Seek 'fd' to start of write-intent-bitmap.  Must be an
 	 * md-native format bitmap
 	 */
-	void (*locate_bitmap)(struct supertype *st, int fd);
+	int (*locate_bitmap)(struct supertype *st, int fd);
 	/* if add_internal_bitmap succeeded for existing array, this
 	 * writes it out.
 	 */
diff --git a/super0.c b/super0.c
index 6ad9d39..7f80014 100644
--- a/super0.c
+++ b/super0.c
@@ -1155,16 +1155,16 @@ static int add_internal_bitmap0(struct supertype *st, int *chunkp,
 	return 1;
 }
 
-static void locate_bitmap0(struct supertype *st, int fd)
+static int locate_bitmap0(struct supertype *st, int fd)
 {
 	unsigned long long dsize;
 	unsigned long long offset;
 
 	if (!get_dev_size(fd, NULL, &dsize))
-		return;
+		return -1;
 
 	if (dsize < MD_RESERVED_SECTORS*512)
-		return;
+		return -1;
 
 	offset = MD_NEW_SIZE_SECTORS(dsize>>9);
 
@@ -1173,6 +1173,7 @@ static void locate_bitmap0(struct supertype *st, int fd)
 	offset += MD_SB_BYTES;
 
 	lseek64(fd, offset, 0);
+	return 0;
 }
 
 static int write_bitmap0(struct supertype *st, int fd, enum bitmap_update update)
diff --git a/super1.c b/super1.c
index 062d9e7..7a1156d 100644
--- a/super1.c
+++ b/super1.c
@@ -1520,7 +1520,7 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 }
 #endif
 
-static void locate_bitmap1(struct supertype *st, int fd);
+static int locate_bitmap1(struct supertype *st, int fd);
 
 static int store_super1(struct supertype *st, int fd)
 {
@@ -2304,24 +2304,30 @@ add_internal_bitmap1(struct supertype *st,
 	return 1;
 }
 
-static void locate_bitmap1(struct supertype *st, int fd)
+static int locate_bitmap1(struct supertype *st, int fd)
 {
 	unsigned long long offset;
 	struct mdp_superblock_1 *sb;
 	int mustfree = 0;
+	int ret;
 
 	if (!st->sb) {
 		if (st->ss->load_super(st, fd, NULL))
-			return; /* no error I hope... */
+			return -1; /* no error I hope... */
 		mustfree = 1;
 	}
 	sb = st->sb;
 
+	if ((__le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET))
+		ret = 0;
+	else
+		ret = -1;
 	offset = __le64_to_cpu(sb->super_offset);
 	offset += (int32_t) __le32_to_cpu(sb->bitmap_offset);
 	if (mustfree)
 		free(sb);
 	lseek64(fd, offset<<9, 0);
+	return ret;
 }
 
 static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update)
-- 
2.1.4

