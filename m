From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm:check the nodes when operate clustered array
Date: Wed,  1 Mar 2017 18:42:33 +0800
Message-ID: <1488364953-20456-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

It doesn't make sense to write_bitmap with less than 2 nodes,
in order to avoid 'write_bitmap' received invalid nodes number,
it would be better to do checking nodes in getopt operations.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
such as following method would reproduce the issue.
# mdadm -CR /dev/md0 -l1 -n2 --bitmap=internal /dev/sda /dev/sdb
# mdadm --grow /dev/md0 --bitmap=none
# mdadm --grow /dev/md0 --bitmap=clustered --nodes=1
# mdadm -X /dev/sda, it would be written internal bitmap.

diff --git a/mdadm.c b/mdadm.c
index b5d89e4..747101c 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -603,8 +603,8 @@ int main(int argc, char *argv[])
 		case O(GROW, Nodes):
 		case O(CREATE, Nodes):
 			c.nodes = parse_num(optarg);
-			if (c.nodes <= 0) {
-				pr_err("invalid number for the number of cluster nodes: %s\n",
+			if (c.nodes < 2) {
+				pr_err("clustered array needs two nodes at least: %s\n",
 					optarg);
 				exit(2);
 			}
diff --git a/super1.c b/super1.c
index 87a74cb..882cd61 100644
--- a/super1.c
+++ b/super1.c
@@ -2380,14 +2380,7 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 		}
 
 		if (bms->version == BITMAP_MAJOR_CLUSTERED) {
-			if (st->nodes == 1) {
-				/* the parameter for nodes is not valid */
-				pr_err("Warning: cluster-md at least needs two nodes\n");
-				return -EINVAL;
-			} else if (st->nodes == 0)
-				/* --nodes is not specified */
-				break;
-			else if (__cpu_to_le32(st->nodes) < bms->nodes) {
+			if (__cpu_to_le32(st->nodes) < bms->nodes) {
 				/* Since the nodes num is not increased, no need to check the space
 				 * is enough or not, just update bms->nodes */
 				bms->nodes = __cpu_to_le32(st->nodes);
-- 
2.6.6

