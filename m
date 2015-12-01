From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 3/4] mdadm: don't show cluster name once the bitmap is cleared
Date: Wed,  2 Dec 2015 00:30:11 +0800
Message-ID: <1448987412-3932-3-git-send-email-gqjiang@suse.com>
References: <1448987412-3932-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1448987412-3932-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com, linux-raid@vger.kernel.org
Cc: rgoldwyn@suse.com, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Don't show cluster name if bitmap is cleared.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 super1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/super1.c b/super1.c
index 1735c2d..062d9e7 100644
--- a/super1.c
+++ b/super1.c
@@ -324,7 +324,7 @@ static void examine_super1(struct supertype *st, char *homehost)
 	    strncmp(sb->set_name, homehost, l) == 0)
 		printf("  (local to host %s)", homehost);
 	printf("\n");
-	if (bms->nodes > 0)
+	if (bms->nodes > 0 && (__le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET))
 		printf("   Cluster Name : %-64s\n", bms->cluster_name);
 	atime = __le64_to_cpu(sb->ctime) & 0xFFFFFFFFFFULL;
 	printf("  Creation Time : %.24s\n", ctime(&atime));
@@ -780,7 +780,7 @@ static void detail_super1(struct supertype *st, char *homehost)
 	    sb->set_name[l] == ':' &&
 	    strncmp(sb->set_name, homehost, l) == 0)
 		printf("  (local to host %s)", homehost);
-	if (bms->nodes > 0)
+	if (bms->nodes > 0 && (__le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET))
 	    printf("\n   Cluster Name : %-64s", bms->cluster_name);
 	printf("\n           UUID : ");
 	for (i=0; i<16; i++) {
-- 
2.1.4

