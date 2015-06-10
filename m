From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 02/11] Add nodes option while creating md
Date: Wed, 10 Jun 2015 13:42:05 +0800
Message-ID: <1433914934-21195-3-git-send-email-gqjiang@suse.com>
References: <1433914934-21195-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1433914934-21195-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

Specifies the maximum number of nodes in the cluster that may use
this device simultaneously. This is equivalent to the number of
bitmaps created in the internal superblock (patches to follow).

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Create.c   |  1 +
 ReadMe.c   |  1 +
 mdadm.8.in |  6 ++++++
 mdadm.c    | 33 ++++++++++++++++++++++++++++++++-
 mdadm.h    |  3 +++
 super1.c   |  1 +
 6 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/Create.c b/Create.c
index 69f5432..e4577af 100644
--- a/Create.c
+++ b/Create.c
@@ -531,6 +531,7 @@ int Create(struct supertype *st, char *mddev,
 				st->ss->name);
 		warn = 1;
 	}
+	st->nodes = c->nodes;
 
 	if (warn) {
 		if (c->runstop!= 1) {
diff --git a/ReadMe.c b/ReadMe.c
index 87a4916..30c569d 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -140,6 +140,7 @@ struct option long_options[] = {
     {"homehost",  1, 0,  HomeHost},
     {"symlinks",  1, 0,  Symlinks},
     {"data-offset",1, 0, DataOffset},
+    {"nodes",1, 0, Nodes},
 
     /* For assemble */
     {"uuid",      1, 0, 'u'},
diff --git a/mdadm.8.in b/mdadm.8.in
index 2a89458..fed0007 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -971,6 +971,12 @@ However for RAID0, it is not possible to add spares.  So to increase
 the number of devices in a RAID0, it is necessary to set the new
 number of devices, and to add the new devices, in the same command.
 
+.TP
+.BR \-\-nodes
+Only works when the array is for clustered environment. It specifies
+the maximum number of nodes in the cluster that will use this device
+simultaneously. If not specified, this defaults to 4.
+
 .SH For assemble:
 
 .TP
diff --git a/mdadm.c b/mdadm.c
index 3e8c49b..25d15a8 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -588,7 +588,14 @@ int main(int argc, char *argv[])
 			}
 			ident.raid_disks = s.raiddisks;
 			continue;
-
+		case O(CREATE, Nodes):
+			c.nodes = parse_num(optarg);
+			if (c.nodes <= 0) {
+				pr_err("invalid number for the number of cluster nodes: %s\n",
+					optarg);
+				exit(2);
+			}
+			continue;
 		case O(CREATE,'x'): /* number of spare (eXtra) disks */
 			if (s.sparedisks) {
 				pr_err("spare-devices set twice: %d and %s\n",
@@ -1097,6 +1104,15 @@ int main(int argc, char *argv[])
 				s.bitmap_file = optarg;
 				continue;
 			}
+			if (strcmp(optarg, "clustered")== 0) {
+			    s.bitmap_file = optarg;
+			    /* Set the default number of cluster nodes
+			     * to 4 if not already set by user
+			     */
+			    if (c.nodes < 1)
+				    c.nodes = 4;
+			    continue;
+			}
 			/* probable typo */
 			pr_err("bitmap file must contain a '/', or be 'internal', or 'none'\n"
 				"       not '%s'\n", optarg);
@@ -1377,6 +1393,21 @@ int main(int argc, char *argv[])
 	case CREATE:
 		if (c.delay == 0)
 			c.delay = DEFAULT_BITMAP_DELAY;
+
+		if (c.nodes) {
+			if (!s.bitmap_file || strcmp(s.bitmap_file, "clustered") != 0) {
+				pr_err("--nodes argument only compatible with --bitmap=clustered\n");
+				rv = 1;
+				break;
+			}
+
+			if (s.level != 1) {
+				pr_err("--bitmap=clustered is currently supported with RAID mirror only\n");
+				rv = 1;
+				break;
+			}
+		}
+
 		if (s.write_behind && !s.bitmap_file) {
 			pr_err("write-behind mode requires a bitmap.\n");
 			rv = 1;
diff --git a/mdadm.h b/mdadm.h
index 141f963..9d55801 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -344,6 +344,7 @@ enum special_options {
 	Dump,
 	Restore,
 	Action,
+	Nodes,
 };
 
 enum prefix_standard {
@@ -418,6 +419,7 @@ struct context {
 	char	*backup_file;
 	int	invalid_backup;
 	char	*action;
+	int	nodes;
 };
 
 struct shape {
@@ -1029,6 +1031,7 @@ struct supertype {
 			 */
 	int devcnt;
 	int retry_soon;
+	int nodes;
 
 	struct mdinfo *devs;
 
diff --git a/super1.c b/super1.c
index 7928a3d..78d98a7 100644
--- a/super1.c
+++ b/super1.c
@@ -2144,6 +2144,7 @@ add_internal_bitmap1(struct supertype *st,
 	bms->daemon_sleep = __cpu_to_le32(delay);
 	bms->sync_size = __cpu_to_le64(size);
 	bms->write_behind = __cpu_to_le32(write_behind);
+	bms->nodes = __cpu_to_le32(st->nodes);
 
 	*chunkp = chunk;
 	return 1;
-- 
1.7.12.4

