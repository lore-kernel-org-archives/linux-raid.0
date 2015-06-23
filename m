From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] Add MD_FEATURE_WRITE_CACHE to sb->feature_map for write cache
Date: Tue, 23 Jun 2015 15:10:38 -0700
Message-ID: <1435097438-164901-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, shli@fb.com, dan.j.williams@intel.com, neilb@suse.de, hch@infradead.org
List-Id: linux-raid.ids

In write_init_suepr1, if a cache device is presented, turn on
bit MD_FEATURE_WRITE_CACHE.


This is an additional patch to the mdadm patches for write-cache:
http://marc.info/?l=linux-raid&m=143158584528009

This is required for kernel patch v4 by Shaohua:
http://marc.info/?l=linux-raid&m=143509551122609


Signed-off-by: Song Liu <songliubraving@fb.com>
---
 super1.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/super1.c b/super1.c
index e229efe..98cd54a 100644
--- a/super1.c
+++ b/super1.c
@@ -125,6 +125,7 @@ struct misc_dev_info {
 					    * backwards anyway.
 					    */
 #define	MD_FEATURE_NEW_OFFSET		64 /* new_offset must be honoured */
+#define	MD_FEATURE_WRITE_CACHE		256
 #define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET	\
 					|MD_FEATURE_RECOVERY_OFFSET	\
 					|MD_FEATURE_RESHAPE_ACTIVE	\
@@ -132,6 +133,7 @@ struct misc_dev_info {
 					|MD_FEATURE_REPLACEMENT		\
 					|MD_FEATURE_RESHAPE_BACKWARDS	\
 					|MD_FEATURE_NEW_OFFSET		\
+					|MD_FEATURE_WRITE_CACHE		\
 					)
 static int write_r5l_super1(struct supertype *st, int fd);
 
@@ -1597,6 +1599,10 @@ static int write_init_super1(struct supertype *st)
 	for (di = st->info; di; di = di->next) {
 		if (di->disk.state & (1 << MD_DISK_WRITECACHE))
 		    cache_di = di;
+		sb->feature_map |= MD_FEATURE_WRITE_CACHE;
+	}
+
+	for (di = st->info; di; di = di->next) {
 		if (di->disk.state & (1 << MD_DISK_FAULTY))
 			continue;
 		if (di->fd < 0)
@@ -1733,6 +1739,7 @@ static int write_init_super1(struct supertype *st)
 		}
 
 		sb->sb_csum = calc_sb_1_csum(sb);
+		pr_err("sb->feature_map = %d\n", sb->feature_map);
 		rv = store_super1(st, di->fd);
 		if (rv == 0 && (__le32_to_cpu(sb->feature_map) & 1))
 			rv = st->ss->write_bitmap(st, di->fd);
-- 
1.8.1

