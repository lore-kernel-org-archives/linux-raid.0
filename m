From: gqjiang@suse.com
Subject: [PATCH 10/10] Reuse the write_bitmap for update uuid
Date: Fri, 24 Apr 2015 15:30:41 +0800
Message-ID: <1429860641-5839-11-git-send-email-gqjiang@suse.com>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

Since write_bitmap is extended for handle different sistuations,
then it also could possible to support change the uuid of bitmap,
and remove bitmap_update_uuid accordingly.

Q: is the write_bitmap0 also impacted?

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Assemble.c |  5 ++---
 bitmap.c   | 20 --------------------
 mdadm.h    |  2 +-
 super1.c   |  4 ++++
 4 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 22042a9..314e4b4 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -664,9 +664,8 @@ static int load_devices(struct devs *devices, char *devmap,
 
 			if (strcmp(c->update, "uuid")==0 &&
 			    ident->bitmap_fd >= 0 && !bitmap_done) {
-				if (bitmap_update_uuid(ident->bitmap_fd,
-						       content->uuid,
-						       tst->ss->swapuuid) != 0)
+				copy_uuid(tst->devs->uuid, content->uuid, tst->ss->swapuuid);
+				if (tst->ss->write_bitmap(tst, dfd, UUIDUpdate))
 					pr_err("Could not update uuid on external bitmap.\n");
 				else
 					bitmap_done = 1;
diff --git a/bitmap.c b/bitmap.c
index ab83f4e..cd65050 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -441,23 +441,3 @@ out:
 		unlink(filename); /* possibly corrupted, better get rid of it */
 	return rv;
 }
-
-int bitmap_update_uuid(int fd, int *uuid, int swap)
-{
-	struct bitmap_super_s bm;
-	if (lseek(fd, 0, 0) != 0)
-		return 1;
-	if (read(fd, &bm, sizeof(bm)) != sizeof(bm))
-		return 1;
-	if (bm.magic != __cpu_to_le32(BITMAP_MAGIC))
-		return 1;
-	copy_uuid(bm.uuid, uuid, swap);
-	if (lseek(fd, 0, 0) != 0)
-		return 2;
-	if (write(fd, &bm, sizeof(bm)) != sizeof(bm)) {
-		lseek(fd, 0, 0);
-		return 2;
-	}
-	lseek(fd, 0, 0);
-	return 0;
-}
diff --git a/mdadm.h b/mdadm.h
index 97892e6..7b9bb28 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -358,6 +358,7 @@ enum bitmap_update {
     NoUpdate,
     NameUpdate,
     NodeNumUpdate,
+    UUIDUpdate,
 };
 
 /* structures read from config file */
@@ -1273,7 +1274,6 @@ extern int CreateBitmap(char *filename, int force, char uuid[16],
 			int major);
 extern int ExamineBitmap(char *filename, int brief, struct supertype *st);
 extern int Write_rules(char *rule_name);
-extern int bitmap_update_uuid(int fd, int *uuid, int swap);
 extern unsigned long bitmap_sectors(struct bitmap_super_s *bsb);
 extern int Dump_metadata(char *dev, char *dir, struct context *c,
 			 struct supertype *st);
diff --git a/super1.c b/super1.c
index 047e799..b2fc6d7 100644
--- a/super1.c
+++ b/super1.c
@@ -2228,6 +2228,10 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 	case NodeNumUpdate:
 	    bms->nodes = __cpu_to_le32(st->nodes);
 	    break;
+	case UUIDUpdate:
+	    memset((char *)bms->uuid, 0, sizeof(bms->uuid));
+	    strncpy((char *)bms->uuid, (char *)st->devs->uuid, sizeof(bms->uuid));
+	    break;
 	case NoUpdate:
 	default:
 	    break;
-- 
1.7.12.4

