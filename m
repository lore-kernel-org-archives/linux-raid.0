From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 09/11] mdadm: change the num of cluster node
Date: Wed, 10 Jun 2015 13:42:12 +0800
Message-ID: <1433914934-21195-10-git-send-email-gqjiang@suse.com>
References: <1433914934-21195-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1433914934-21195-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

This extends nodes option for assemble mode, make the num of
cluster node could be change by user.

Before that, it is necessary to ensure there are enough space
for those nodes, calc_bitmap_size is introduced to calculate
the bitmap size of each node.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Assemble.c |  6 +++++-
 ReadMe.c   |  2 +-
 mdadm.8.in |  8 ++++++++
 mdadm.c    |  5 ++++-
 mdadm.h    |  1 +
 super1.c   | 37 +++++++++++++++++++++++++++++++++++++
 6 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 12ac299..d163eaa 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -629,7 +629,11 @@ static int load_devices(struct devs *devices, char *devmap,
 			else if (strcmp(c->update, "home-cluster") == 0) {
 				tst->cluster_name = c->homecluster;
 				tst->ss->write_bitmap(tst, dfd, NameUpdate);
-			} else
+			} else if (strcmp(c->update, "nodes") == 0) {
+				tst->nodes = c->nodes;
+				err = tst->ss->write_bitmap(tst, dfd, NodeNumUpdate);
+			}
+			else
 				err = tst->ss->update_super(tst, content, c->update,
 							    devname, c->verbose,
 							    ident->uuid_set,
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
diff --git a/mdadm.8.in b/mdadm.8.in
index 99b02a3..8b7768d 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1097,6 +1097,7 @@ argument given to this flag can be one of
 .BR summaries ,
 .BR uuid ,
 .BR name ,
+.BR nodes ,
 .BR homehost ,
 .BR home-cluster ,
 .BR resync ,
@@ -1149,6 +1150,13 @@ The
 .B name
 option will change the
 .I name
+of the array as stored in the superblock and bitmap. This option only
+works for clustered environment.
+
+The
+.B nodes
+option will change the
+.I nodes
 of the array as stored in the superblock.  This is only supported for
 version-1 superblocks.
 
diff --git a/mdadm.c b/mdadm.c
index 5e9b302..7b85570 100644
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
@@ -782,7 +785,7 @@ int main(int argc, char *argv[])
 					Name, c.update);
 			}
 			fprintf(outf, "Valid --update options are:\n"
-		"     'sparc2.2', 'super-minor', 'uuid', 'name', 'resync',\n"
+		"     'sparc2.2', 'super-minor', 'uuid', 'name', 'nodes', 'resync',\n"
 		"     'summaries', 'homehost', 'home-cluster', 'byteorder', 'devicesize',\n"
 		"     'no-bitmap', 'metadata', 'revert-reshape'\n"
 		"     'bbl', 'no-bbl'\n"
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
index 699f1ec..faccfcd 100644
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
@@ -2190,6 +2204,7 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 	int towrite, n;
 	struct align_fd afd;
 	unsigned int i = 0;
+	unsigned long long total_bm_space, bm_space_per_node;
 
 	switch (update) {
 	case NameUpdate:
@@ -2199,6 +2214,28 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 			strncpy((char *)bms->cluster_name, st->cluster_name, 64);
 		}
 		break;
+	case NodeNumUpdate:
+		/* cluster md only supports superblock 1.2 now */
+		if (st->minor_version != 2) {
+			pr_err("Warning: cluster md only works with superblock 1.2\n");
+			return -EINVAL;
+		}
+
+		/* Each node has an independent bitmap, it is necessary to calculate the
+		 * space is enough or not, first get how many bytes for the total bitmap */
+		bm_space_per_node = calc_bitmap_size(bms, 4096);
+
+		total_bm_space = 512 * (__le64_to_cpu(sb->data_offset) - __le64_to_cpu(sb->super_offset));
+		total_bm_space = total_bm_space - 4096; /* leave another 4k for superblock */
+
+		if (bm_space_per_node * st->nodes > total_bm_space) {
+			pr_err("Warning: The max num of nodes can't exceed %llu\n",
+				total_bm_space / bm_space_per_node);
+			return -ENOMEM;
+		}
+
+		bms->nodes = __cpu_to_le32(st->nodes);
+		break;
 	case NoUpdate:
 	default:
 		break;
-- 
1.7.12.4

