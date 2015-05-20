From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V3 09/11] mdadm: change the num of cluster node
Date: Wed, 20 May 2015 11:20:41 +0800
Message-ID: <1432092043-24220-10-git-send-email-gqjiang@suse.com>
References: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

This extends nodes option for assemble mode, make the num of
cluster node could be change by user.

Before that, it is necessary to ensure there are enough space
for those nodes, calc_bitmap_size is introduced to calculate
the bitmap size of each node.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Assemble.c |  4 ++++
 ReadMe.c   |  2 +-
 mdadm.c    |  3 +++
 mdadm.h    |  1 +
 super1.c   | 37 +++++++++++++++++++++++++++++++++++++
 5 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/Assemble.c b/Assemble.c
index e1b846c..9ff546b 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -626,6 +626,10 @@ static int load_devices(struct devs *devices, char *devmap,
 
 			if (strcmp(c->update, "byteorder") == 0)
 				err = 0;
+			else if (strcmp(c->update, "nodes") == 0) {
+				tst->nodes = c->nodes;
+				err = tst->ss->write_bitmap(tst, dfd, NodeNumUpdate);
+			}
 			else
 				err = tst->ss->update_super(tst, content, c->update,
 							    devname, c->verbose,
diff --git a/ReadMe.c b/ReadMe.c
index c854cd5..d1830e1 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -140,7 +140,7 @@ struct option long_options[] = {
     {"homehost",  1, 0,  HomeHost},
     {"symlinks",  1, 0,  Symlinks},
     {"data-offset",1, 0, DataOffset},
-    {"nodes",1, 0, Nodes},
+    {"nodes",1, 0, Nodes}, /* also for --assemble */
     {"home-cluster",1, 0, ClusterName},
 
     /* For assemble */
diff --git a/mdadm.c b/mdadm.c
index 22f4fc7..87c572d 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -589,6 +589,7 @@ int main(int argc, char *argv[])
 			}
 			ident.raid_disks = s.raiddisks;
 			continue;
+		case O(ASSEMBLE, Nodes):
 		case O(CREATE, Nodes):
 			c.nodes = parse_num(optarg);
 			if (c.nodes <= 0) {
@@ -744,6 +745,8 @@ int main(int argc, char *argv[])
 				continue;
 			if (strcmp(c.update, "home-cluster")==0)
 				continue;
+			if (strcmp(c.update, "nodes")==0)
+				continue;
 			if (strcmp(c.update, "devicesize")==0)
 				continue;
 			if (strcmp(c.update, "no-bitmap")==0)
diff --git a/mdadm.h b/mdadm.h
index d8b0749..97892e6 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -357,6 +357,7 @@ enum prefix_standard {
 enum bitmap_update {
     NoUpdate,
     NameUpdate,
+    NodeNumUpdate,
 };
 
 /* structures read from config file */
diff --git a/super1.c b/super1.c
index 07944d4..fe12e81 100644
--- a/super1.c
+++ b/super1.c
@@ -134,6 +134,20 @@ struct misc_dev_info {
 					|MD_FEATURE_NEW_OFFSET		\
 					)
 
+/* return how many bytes are needed for bitmap, for cluster-md each node
+ * should have it's own bitmap */
+static unsigned int calc_bitmap_size(bitmap_super_t *bms, unsigned int boundary)
+{
+	unsigned long long bits, bytes;
+
+	bits = __le64_to_cpu(bms->sync_size) / (__le32_to_cpu(bms->chunksize)>>9);
+	bytes = (bits+7) >> 3;
+	bytes += sizeof(bitmap_super_t);
+	bytes = ROUND_UP(bytes, boundary);
+
+	return bytes;
+}
+
 static unsigned int calc_sb_1_csum(struct mdp_superblock_1 * sb)
 {
 	unsigned int disk_csum, csum;
@@ -2201,6 +2215,7 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 	struct align_fd afd;
 	unsigned int i = 0;
 	char *new_name;
+	unsigned long long total_bm_space, bm_space_per_node;
 
 	switch (update) {
 	case NameUpdate:
@@ -2217,6 +2232,28 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 
 	    free(new_name);
 	    break;
+	case NodeNumUpdate:
+	    /* cluster md only supports superblock 1.2 now */
+	    if (st->minor_version != 2) {
+		pr_err("Warning: cluster md only works with superblock 1.2\n");
+		return -EINVAL;
+	    }
+
+	    /* Each node has an independent bitmap, it is necessary to calculate the
+	     * space is enough or not, first get how many bytes for the total bitmap */
+	    bm_space_per_node = calc_bitmap_size(bms, 4096);
+
+	    total_bm_space = 512 * (__le64_to_cpu(sb->data_offset) - __le64_to_cpu(sb->super_offset));
+	    total_bm_space = total_bm_space - 4096; /* leave another 4k for superblock */
+
+	    if (bm_space_per_node * st->nodes > total_bm_space) {
+		pr_err("Warning: The max num of nodes can't exceed %llu\n",
+			total_bm_space / bm_space_per_node);
+		return -ENOMEM;
+	    }
+
+	    bms->nodes = __cpu_to_le32(st->nodes);
+	    break;
 	case NoUpdate:
 	default:
 	    break;
-- 
1.7.12.4

