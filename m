From: gqjiang@suse.com
Subject: [PATCH 09/10] mdadm: change the num of cluster node
Date: Fri, 24 Apr 2015 15:30:40 +0800
Message-ID: <1429860641-5839-10-git-send-email-gqjiang@suse.com>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

This extends nodes option for assemble mode, make the num of
cluster node could be change by user.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Assemble.c | 4 ++++
 ReadMe.c   | 2 +-
 mdadm.c    | 3 +++
 mdadm.h    | 1 +
 super1.c   | 6 ++++++
 5 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/Assemble.c b/Assemble.c
index e1b846c..22042a9 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -649,6 +649,10 @@ static int load_devices(struct devs *devices, char *devmap,
 							    devname, 0, 0, c->homecluster);
 				tst->ss->write_bitmap(tst, dfd, NameUpdate);
 			}
+			if (strcmp(c->update, "nodes") == 0) {
+				tst->nodes = c->nodes;
+				tst->ss->write_bitmap(tst, dfd, NodeNumUpdate);
+			}
 			if (strcmp(c->update, "uuid")==0 &&
 			    !ident->uuid_set) {
 				ident->uuid_set = 1;
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
index 20f195d..344bde2 100644
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
index e43bef1..047e799 100644
--- a/super1.c
+++ b/super1.c
@@ -1329,6 +1329,9 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		sb->devflags |= WriteMostly1;
 	else if (strcmp(update, "readwrite")==0)
 		sb->devflags &= ~WriteMostly1;
+	else if (strcmp(update, "nodes")==0)
+		/* Just a placeholder since no related member in mdp_superblock_1 */
+		;
 	else
 		rv = -1;
 
@@ -2222,6 +2225,9 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 	    free(new_name);
 	    break;
 	}
+	case NodeNumUpdate:
+	    bms->nodes = __cpu_to_le32(st->nodes);
+	    break;
 	case NoUpdate:
 	default:
 	    break;
-- 
1.7.12.4

