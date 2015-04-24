From: gqjiang@suse.com
Subject: [PATCH 08/10] mdadm: add the ability to change cluster name
Date: Fri, 24 Apr 2015 15:30:39 +0800
Message-ID: <1429860641-5839-9-git-send-email-gqjiang@suse.com>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

To support change the cluster name, the commit do the followings:

1. extend original write_bitmap function for new scenario.
2. add the scenarion to handle the modification of cluster's name
   in write_bitmap1.
3. make update_super1 can change the name in mdp_superblock_1.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Assemble.c |  5 +++++
 Grow.c     |  2 +-
 mdadm.c    |  3 +++
 mdadm.h    |  7 ++++++-
 super0.c   |  4 ++--
 super1.c   | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 61 insertions(+), 6 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 25a103d..e1b846c 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -644,6 +644,11 @@ static int load_devices(struct devs *devices, char *devmap,
 				*stp = st;
 				return -1;
 			}
+			if (strcmp(c->update, "home-cluster") == 0) {
+				err = tst->ss->update_super(tst, content, c->update,
+							    devname, 0, 0, c->homecluster);
+				tst->ss->write_bitmap(tst, dfd, NameUpdate);
+			}
 			if (strcmp(c->update, "uuid")==0 &&
 			    !ident->uuid_set) {
 				ident->uuid_set = 1;
diff --git a/Grow.c b/Grow.c
index 1122cec..bf44e66 100644
--- a/Grow.c
+++ b/Grow.c
@@ -420,7 +420,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 						    bitmapsize, offset_setable,
 						    major)
 						)
-						st->ss->write_bitmap(st, fd2);
+						st->ss->write_bitmap(st, fd2, NoUpdate);
 					else {
 						pr_err("failed to create internal bitmap - chunksize problem.\n");
 						close(fd2);
diff --git a/mdadm.c b/mdadm.c
index 5b4b3ef..20f195d 100644
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
index 3c2fce2..e43bef1 100644
--- a/super1.c
+++ b/super1.c
@@ -1073,6 +1073,25 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		info->name[32] = 0;
 	}
 
+	if (strcmp(update, "home-cluster") == 0 &&
+	    homehost) {
+		/* Note that 'home-cluster' is to change the name of cluster,
+		 * it is another "name" update.
+		 */
+		char *new_name = xmalloc(sizeof(sb->set_name));
+		if (strrchr(sb->set_name, ':')) {
+			strcpy(new_name, strchr(sb->set_name, ':'));
+		}
+
+		memset(sb->set_name, 0, sizeof(sb->set_name));
+		strcpy(sb->set_name, homehost);
+		if (new_name)
+			strcat(sb->set_name, new_name);
+
+		free(new_name);
+		goto out;
+	}
+
 	if (strcmp(update, "force-one")==0) {
 		/* Not enough devices for a working array,
 		 * so bring this one up-to-date
@@ -1313,6 +1332,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 	else
 		rv = -1;
 
+out:
 	sb->sb_csum = calc_sb_1_csum(sb);
 	return rv;
 }
@@ -1691,7 +1711,7 @@ static int write_init_super1(struct supertype *st)
 		sb->sb_csum = calc_sb_1_csum(sb);
 		rv = store_super1(st, di->fd);
 		if (rv == 0 && (__le32_to_cpu(sb->feature_map) & 1))
-			rv = st->ss->write_bitmap(st, di->fd);
+			rv = st->ss->write_bitmap(st, di->fd, NoUpdate);
 		close(di->fd);
 		di->fd = -1;
 		if (rv)
@@ -2175,7 +2195,7 @@ static void locate_bitmap1(struct supertype *st, int fd)
 	lseek64(fd, offset<<9, 0);
 }
 
-static int write_bitmap1(struct supertype *st, int fd)
+static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update)
 {
 	struct mdp_superblock_1 *sb = st->sb;
 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb)+MAX_SB_SIZE);
@@ -2185,6 +2205,28 @@ static int write_bitmap1(struct supertype *st, int fd)
 	struct align_fd afd;
 	unsigned int i;
 
+	switch (update) {
+	case NameUpdate:
+	{
+	    char *new_name = xmalloc(sizeof(sb->set_name));
+
+	    strncpy(new_name, sb->set_name, sizeof(sb->set_name));
+	    memset((char *)bms->cluster_name, 0, sizeof(bms->cluster_name));
+
+	    if (strtok(new_name, ":"))
+		strncpy((char *)bms->cluster_name, new_name, strlen(sb->set_name));
+	    else
+		/* In case the original set_name doesn't like aaa:md* */
+		strncpy((char *)bms->cluster_name, sb->set_name, strlen(sb->set_name));
+
+	    free(new_name);
+	    break;
+	}
+	case NoUpdate:
+	default:
+	    break;
+	}
+
 	init_afd(&afd, fd);
 
 	locate_bitmap1(st, fd);
-- 
1.7.12.4

