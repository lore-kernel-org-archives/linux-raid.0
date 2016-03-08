From: Jes.Sorensen@redhat.com
Subject: [PATCH 8/8] super1: Fix potential buffer overflows when copying cluster_name
Date: Tue,  8 Mar 2016 12:30:52 -0500
Message-ID: <1457458252-20203-9-git-send-email-Jes.Sorensen@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

cmap_get_string() used to retrieve cluster_name does not restrict it's
size. To prevent buffer overflows use the size of the destination
buffer, not strlen() of the source, and null terminate the copied
string.

Fixes: 0aa2f15b ("mdadm: add the ability to change cluster name)"
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super1.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/super1.c b/super1.c
index f8a35ac..baa9a96 100644
--- a/super1.c
+++ b/super1.c
@@ -2201,6 +2201,7 @@ add_internal_bitmap1(struct supertype *st,
 	unsigned long long chunk = *chunkp;
 	int room = 0;
 	int creating = 0;
+	int len;
 	struct mdp_superblock_1 *sb = st->sb;
 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MAX_SB_SIZE);
 	int uuid[4];
@@ -2326,9 +2327,11 @@ add_internal_bitmap1(struct supertype *st,
 	if (st->nodes)
 		sb->feature_map = __cpu_to_le32(__le32_to_cpu(sb->feature_map)
 						| MD_FEATURE_BITMAP_VERSIONED);
-	if (st->cluster_name)
-		strncpy((char *)bms->cluster_name,
-			st->cluster_name, strlen(st->cluster_name));
+	if (st->cluster_name) {
+		len = sizeof(bms->cluster_name);
+		strncpy((char *)bms->cluster_name, st->cluster_name, len);
+		bms->cluster_name[len - 1] = '\0';
+	}
 
 	*chunkp = chunk;
 	return 1;
@@ -2366,7 +2369,7 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb)+MAX_SB_SIZE);
 	int rv = 0;
 	void *buf;
-	int towrite, n;
+	int towrite, n, len;
 	struct align_fd afd;
 	unsigned int i = 0;
 	unsigned long long total_bm_space, bm_space_per_node;
@@ -2375,8 +2378,11 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 	case NameUpdate:
 		/* update cluster name */
 		if (st->cluster_name) {
-			memset((char *)bms->cluster_name, 0, sizeof(bms->cluster_name));
-			strncpy((char *)bms->cluster_name, st->cluster_name, 64);
+			len = sizeof(bms->cluster_name);
+			memset((char *)bms->cluster_name, 0, len);
+			strncpy((char *)bms->cluster_name,
+				st->cluster_name, len);
+			bms->cluster_name[len - 1] = '\0';
 		}
 		break;
 	case NodeNumUpdate:
-- 
2.5.0

