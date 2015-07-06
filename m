From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 2/3] md-cluster: use %-64s to print cluster_name
Date: Mon,  6 Jul 2015 16:52:11 +0800
Message-ID: <1436172732-21021-2-git-send-email-gqjiang@suse.com>
References: <1436172732-21021-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436172732-21021-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Left align is better for cluster with name less than 64. Also
make the output of cluster name is aligned with others.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
Against cluster branch, this could be squashed with commit 0aa2f15
"mdadm: add the ability to change cluster name", sorry for inconvenience.

 bitmap.c | 2 +-
 super1.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/bitmap.c b/bitmap.c
index 0c3f6de..9847001 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -342,7 +342,7 @@ int ExamineBitmap(char *filename, int brief, struct supertype *st)
 		       100.0 * info->dirty_bits / (info->total_bits?:1));
 	} else {
 		printf("   Cluster nodes : %d\n", sb->nodes);
-		printf("    Cluster name : %64s\n", sb->cluster_name);
+		printf("    Cluster name : %-64s\n", sb->cluster_name);
 		for (i = 0; i < (int)sb->nodes; i++) {
 			if (i) {
 				free(info);
diff --git a/super1.c b/super1.c
index fda71e3..9b991e6 100644
--- a/super1.c
+++ b/super1.c
@@ -305,7 +305,7 @@ static void examine_super1(struct supertype *st, char *homehost)
 		printf("  (local to host %s)", homehost);
 	printf("\n");
 	if (bms->nodes > 0)
-		printf("Cluster Name : %s", bms->cluster_name);
+		printf("   Cluster Name : %-64s\n", bms->cluster_name);
 	atime = __le64_to_cpu(sb->ctime) & 0xFFFFFFFFFFULL;
 	printf("  Creation Time : %.24s\n", ctime(&atime));
 	c=map_num(pers, __le32_to_cpu(sb->level));
@@ -763,7 +763,7 @@ static void detail_super1(struct supertype *st, char *homehost)
 	    strncmp(sb->set_name, homehost, l) == 0)
 		printf("  (local to host %s)", homehost);
 	if (bms->nodes > 0)
-	    printf("Cluster Name : %64s", bms->cluster_name);
+	    printf("\n   Cluster Name : %-64s", bms->cluster_name);
 	printf("\n           UUID : ");
 	for (i=0; i<16; i++) {
 		if ((i&3)==0 && i != 0) printf(":");
-- 
1.7.12.4

