From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 08/11] mdadm: add the ability to change cluster name
Date: Wed, 10 Jun 2015 13:42:11 +0800
Message-ID: <1433914934-21195-9-git-send-email-gqjiang@suse.com>
References: <1433914934-21195-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1433914934-21195-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

To support change the cluster name, the commit do the followings:

1. extend original write_bitmap function for new scenario.
2. add the scenarion to handle the modification of cluster's name
   in write_bitmap1.
3. let the cluster name also show in examine_super1 and detail_super1

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Assemble.c |  5 ++++-
 Grow.c     |  2 +-
 mdadm.8.in |  6 ++++++
 mdadm.c    |  5 ++++-
 mdadm.h    |  7 ++++++-
 super0.c   |  4 ++--
 super1.c   | 23 +++++++++++++++++++++--
 7 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 42710a8..12ac299 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -626,7 +626,10 @@ static int load_devices(struct devs *devices, char *devmap,
 
 			if (strcmp(c->update, "byteorder") == 0)
 				err = 0;
-			else
+			else if (strcmp(c->update, "home-cluster") == 0) {
+				tst->cluster_name = c->homecluster;
+				tst->ss->write_bitmap(tst, dfd, NameUpdate);
+			} else
 				err = tst->ss->update_super(tst, content, c->update,
 							    devname, c->verbose,
 							    ident->uuid_set,
diff --git a/Grow.c b/Grow.c
index 90a7fe9..857c7e1 100644
--- a/Grow.c
+++ b/Grow.c
@@ -412,7 +412,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 						    bitmapsize, offset_setable,
 						    major)
 						)
-						st->ss->write_bitmap(st, fd2);
+						st->ss->write_bitmap(st, fd2, NoUpdate);
 					else {
 						pr_err("failed to create internal bitmap - chunksize problem.\n");
 						close(fd2);
diff --git a/mdadm.8.in b/mdadm.8.in
index 3dd000c..99b02a3 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1098,6 +1098,7 @@ argument given to this flag can be one of
 .BR uuid ,
 .BR name ,
 .BR homehost ,
+.BR home-cluster ,
 .BR resync ,
 .BR byteorder ,
 .BR devicesize ,
@@ -1160,6 +1161,11 @@ same as updating the UUID.
 For version-1 superblocks, this involves updating the name.
 
 The
+.B home\-cluster
+option will change the cluster name as recorded in the superblock and
+bitmap. This option only works for clustered environment.
+
+The
 .B resync
 option will cause the array to be marked
 .I dirty
diff --git a/mdadm.c b/mdadm.c
index f08d8c9..5e9b302 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -598,6 +598,7 @@ int main(int argc, char *argv[])
 			}
 			continue;
 		case O(CREATE, ClusterName):
+		case O(ASSEMBLE, ClusterName):
 			c.homecluster = optarg;
 			if (strlen(c.homecluster) > 64) {
 				pr_err("Cluster name too big.\n");
@@ -741,6 +742,8 @@ int main(int argc, char *argv[])
 				continue;
 			if (strcmp(c.update, "homehost")==0)
 				continue;
+			if (strcmp(c.update, "home-cluster")==0)
+				continue;
 			if (strcmp(c.update, "devicesize")==0)
 				continue;
 			if (strcmp(c.update, "no-bitmap")==0)
@@ -780,7 +783,7 @@ int main(int argc, char *argv[])
 			}
 			fprintf(outf, "Valid --update options are:\n"
 		"     'sparc2.2', 'super-minor', 'uuid', 'name', 'resync',\n"
-		"     'summaries', 'homehost', 'byteorder', 'devicesize',\n"
+		"     'summaries', 'homehost', 'home-cluster', 'byteorder', 'devicesize',\n"
 		"     'no-bitmap', 'metadata', 'revert-reshape'\n"
 		"     'bbl', 'no-bbl'\n"
 				);
diff --git a/mdadm.h b/mdadm.h
index 00c726e..d8b0749 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -354,6 +354,11 @@ enum prefix_standard {
 	IEC
 };
 
+enum bitmap_update {
+    NoUpdate,
+    NameUpdate,
+};
+
 /* structures read from config file */
 /* List of mddevice names and identifiers
  * Identifiers can be:
@@ -850,7 +855,7 @@ extern struct superswitch {
 	/* if add_internal_bitmap succeeded for existing array, this
 	 * writes it out.
 	 */
-	int (*write_bitmap)(struct supertype *st, int fd);
+	int (*write_bitmap)(struct supertype *st, int fd, enum bitmap_update update);
 	/* Free the superblock and any other allocated data */
 	void (*free_super)(struct supertype *st);
 
diff --git a/super0.c b/super0.c
index deb5999..6ad9d39 100644
--- a/super0.c
+++ b/super0.c
@@ -900,7 +900,7 @@ static int write_init_super0(struct supertype *st)
 		rv = store_super0(st, di->fd);
 
 		if (rv == 0 && (sb->state & (1<<MD_SB_BITMAP_PRESENT)))
-			rv = st->ss->write_bitmap(st, di->fd);
+			rv = st->ss->write_bitmap(st, di->fd, NoUpdate);
 
 		if (rv)
 			pr_err("failed to write superblock to %s\n",
@@ -1175,7 +1175,7 @@ static void locate_bitmap0(struct supertype *st, int fd)
 	lseek64(fd, offset, 0);
 }
 
-static int write_bitmap0(struct supertype *st, int fd)
+static int write_bitmap0(struct supertype *st, int fd, enum bitmap_update update)
 {
 	unsigned long long dsize;
 	unsigned long long offset;
diff --git a/super1.c b/super1.c
index fd728d2..699f1ec 100644
--- a/super1.c
+++ b/super1.c
@@ -256,6 +256,7 @@ static int awrite(struct align_fd *afd, void *buf, int len)
 static void examine_super1(struct supertype *st, char *homehost)
 {
 	struct mdp_superblock_1 *sb = st->sb;
+	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb)+MAX_SB_SIZE);
 	time_t atime;
 	unsigned int d;
 	int role;
@@ -289,6 +290,8 @@ static void examine_super1(struct supertype *st, char *homehost)
 	    strncmp(sb->set_name, homehost, l) == 0)
 		printf("  (local to host %s)", homehost);
 	printf("\n");
+	if (bms->nodes > 0)
+	    printf("Cluster Name : %s", bms->cluster_name);
 	atime = __le64_to_cpu(sb->ctime) & 0xFFFFFFFFFFULL;
 	printf("  Creation Time : %.24s\n", ctime(&atime));
 	c=map_num(pers, __le32_to_cpu(sb->level));
@@ -740,6 +743,7 @@ err:
 static void detail_super1(struct supertype *st, char *homehost)
 {
 	struct mdp_superblock_1 *sb = st->sb;
+	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MAX_SB_SIZE);
 	int i;
 	int l = homehost ? strlen(homehost) : 0;
 
@@ -748,6 +752,8 @@ static void detail_super1(struct supertype *st, char *homehost)
 	    sb->set_name[l] == ':' &&
 	    strncmp(sb->set_name, homehost, l) == 0)
 		printf("  (local to host %s)", homehost);
+	if (bms->nodes > 0)
+	    printf("Cluster Name : %64s", bms->cluster_name);
 	printf("\n           UUID : ");
 	for (i=0; i<16; i++) {
 		if ((i&3)==0 && i != 0) printf(":");
@@ -1691,7 +1697,7 @@ static int write_init_super1(struct supertype *st)
 		sb->sb_csum = calc_sb_1_csum(sb);
 		rv = store_super1(st, di->fd);
 		if (rv == 0 && (__le32_to_cpu(sb->feature_map) & 1))
-			rv = st->ss->write_bitmap(st, di->fd);
+			rv = st->ss->write_bitmap(st, di->fd, NoUpdate);
 		close(di->fd);
 		di->fd = -1;
 		if (rv)
@@ -2175,7 +2181,7 @@ static void locate_bitmap1(struct supertype *st, int fd)
 	lseek64(fd, offset<<9, 0);
 }
 
-static int write_bitmap1(struct supertype *st, int fd)
+static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update)
 {
 	struct mdp_superblock_1 *sb = st->sb;
 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb)+MAX_SB_SIZE);
@@ -2185,6 +2191,19 @@ static int write_bitmap1(struct supertype *st, int fd)
 	struct align_fd afd;
 	unsigned int i = 0;
 
+	switch (update) {
+	case NameUpdate:
+		/* update cluster name */
+		if (st->cluster_name) {
+			memset((char *)bms->cluster_name, 0, sizeof(bms->cluster_name));
+			strncpy((char *)bms->cluster_name, st->cluster_name, 64);
+		}
+		break;
+	case NoUpdate:
+	default:
+		break;
+	}
+
 	init_afd(&afd, fd);
 
 	locate_bitmap1(st, fd);
-- 
1.7.12.4

