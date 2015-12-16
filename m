From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 1/2] mdadm: do not try to hold dlm lock in free_super1
Date: Thu, 17 Dec 2015 01:54:25 +0800
Message-ID: <1450288466-21168-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

Since free_super1 actually doesn't change the sb, it
just free the addr space of sb. Also free_super1 is
called in lots of place within mdadm, so remove dlm
lock code since the func doesn't need the protection
and also reduce latency.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 super1.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/super1.c b/super1.c
index 7a1156d..38362e4 100644
--- a/super1.c
+++ b/super1.c
@@ -2421,15 +2421,6 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 
 static void free_super1(struct supertype *st)
 {
-	int rv, lockid;
-	if (is_clustered(st)) {
-		rv = cluster_get_dlmlock(st, &lockid);
-		if (rv) {
-			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
-			cluster_release_dlmlock(st, lockid);
-			return;
-		}
-	}
 
 	if (st->sb)
 		free(st->sb);
@@ -2441,8 +2432,6 @@ static void free_super1(struct supertype *st)
 		free(di);
 	}
 	st->sb = NULL;
-	if (is_clustered(st))
-		cluster_release_dlmlock(st, lockid);
 }
 
 #ifndef MDASSEMBLE
-- 
2.1.4

