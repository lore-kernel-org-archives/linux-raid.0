From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 2/2] mdadm: improve the safeguard for change cluster raid's sb
Date: Thu, 17 Dec 2015 01:54:26 +0800
Message-ID: <1450288466-21168-2-git-send-email-gqjiang@suse.com>
References: <1450288466-21168-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450288466-21168-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

This commit does the following jobs:

1. rename is_clustered to dlm_funs_ready since it match the
   function better.
2. st->cluster_name can't be use to identify the raid is a
   clustered or not, we should check the bitmap's version to
   perform the identification.
3. for cluster_get_dlmlock/cluster_release_dlmlock funcs, both
   of them just need the lockid as parameter since the cluster
   name can get by get_cluster_name().

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 mdadm.h  |  6 +++---
 super1.c | 33 ++++++++++++++++++---------------
 util.c   | 30 ++++++++++++++++++------------
 3 files changed, 39 insertions(+), 30 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index aad0fa8..be5dc7f 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1484,9 +1484,9 @@ struct dlm_hooks {
 };
 
 extern int get_cluster_name(char **name);
-extern int is_clustered(struct supertype *st);
-extern int cluster_get_dlmlock(struct supertype *st, int *lockid);
-extern int cluster_release_dlmlock(struct supertype *st, int lockid);
+extern int dlm_funs_ready(void);
+extern int cluster_get_dlmlock(int *lockid);
+extern int cluster_release_dlmlock(int lockid);
 extern void set_dlm_hooks(void);
 
 #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
diff --git a/super1.c b/super1.c
index 38362e4..c7ff634 100644
--- a/super1.c
+++ b/super1.c
@@ -1100,12 +1100,13 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 	int rv = 0;
 	int lockid;
 	struct mdp_superblock_1 *sb = st->sb;
+	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MAX_SB_SIZE);
 
-	if (is_clustered(st)) {
-		rv = cluster_get_dlmlock(st, &lockid);
+	if (bms->version == BITMAP_MAJOR_CLUSTERED && dlm_funs_ready()) {
+		rv = cluster_get_dlmlock(&lockid);
 		if (rv) {
 			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
-			cluster_release_dlmlock(st, lockid);
+			cluster_release_dlmlock(lockid);
 			return rv;
 		}
 	}
@@ -1368,8 +1369,8 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		rv = -1;
 
 	sb->sb_csum = calc_sb_1_csum(sb);
-	if (is_clustered(st))
-		cluster_release_dlmlock(st, lockid);
+	if (bms->version == BITMAP_MAJOR_CLUSTERED && dlm_funs_ready())
+		cluster_release_dlmlock(lockid);
 
 	return rv;
 }
@@ -1474,13 +1475,14 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 	struct mdp_superblock_1 *sb = st->sb;
 	__u16 *rp = sb->dev_roles + dk->number;
 	struct devinfo *di, **dip;
+	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MAX_SB_SIZE);
 	int rv, lockid;
 
-	if (is_clustered(st)) {
-		rv = cluster_get_dlmlock(st, &lockid);
+	if (bms->version == BITMAP_MAJOR_CLUSTERED && dlm_funs_ready()) {
+		rv = cluster_get_dlmlock(&lockid);
 		if (rv) {
 			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
-			cluster_release_dlmlock(st, lockid);
+			cluster_release_dlmlock(lockid);
 			return rv;
 		}
 	}
@@ -1513,8 +1515,8 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 	di->next = NULL;
 	*dip = di;
 
-	if (is_clustered(st))
-		cluster_release_dlmlock(st, lockid);
+	if (bms->version == BITMAP_MAJOR_CLUSTERED && dlm_funs_ready())
+		cluster_release_dlmlock(lockid);
 
 	return 0;
 }
@@ -1529,13 +1531,14 @@ static int store_super1(struct supertype *st, int fd)
 	struct align_fd afd;
 	int sbsize;
 	unsigned long long dsize;
+	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MAX_SB_SIZE);
 	int rv, lockid;
 
-	if (is_clustered(st)) {
-		rv = cluster_get_dlmlock(st, &lockid);
+	if (bms->version == BITMAP_MAJOR_CLUSTERED && dlm_funs_ready()) {
+		rv = cluster_get_dlmlock(&lockid);
 		if (rv) {
 			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
-			cluster_release_dlmlock(st, lockid);
+			cluster_release_dlmlock(lockid);
 			return rv;
 		}
 	}
@@ -1599,8 +1602,8 @@ static int store_super1(struct supertype *st, int fd)
 		}
 	}
 	fsync(fd);
-	if (is_clustered(st))
-		cluster_release_dlmlock(st, lockid);
+	if (bms->version == BITMAP_MAJOR_CLUSTERED && dlm_funs_ready())
+		cluster_release_dlmlock(lockid);
 
 	return 0;
 }
diff --git a/util.c b/util.c
index 8217e11..f1b0b95 100644
--- a/util.c
+++ b/util.c
@@ -92,13 +92,9 @@ struct dlm_lock_resource {
 	struct dlm_lksb lksb;
 };
 
-int is_clustered(struct supertype *st)
+int dlm_funs_ready(void)
 {
-	/* is it a cluster md or not */
-	if (is_dlm_hooks_ready && st->cluster_name)
-		return 1;
-	else
-		return 0;
+	return is_dlm_hooks_ready ? 1 : 0;
 }
 
 /* Using poll(2) to wait for and dispatch ASTs */
@@ -128,17 +124,24 @@ static void dlm_ast(void *arg)
 	ast_called = 1;
 }
 
+static char *cluster_name = NULL;
 /* Create the lockspace, take bitmapXXX locks on all the bitmaps. */
-int cluster_get_dlmlock(struct supertype *st, int *lockid)
+int cluster_get_dlmlock(int *lockid)
 {
 	int ret = -1;
 	char str[64];
 	int flags = LKF_NOQUEUE;
 
+	ret = get_cluster_name(&cluster_name);
+	if (ret) {
+		pr_err("The md can't get cluster name\n");
+		return -1;
+	}
+
 	dlm_lock_res = xmalloc(sizeof(struct dlm_lock_resource));
-	dlm_lock_res->ls = dlm_hooks->create_lockspace(st->cluster_name, O_RDWR);
+	dlm_lock_res->ls = dlm_hooks->create_lockspace(cluster_name, O_RDWR);
 	if (!dlm_lock_res->ls) {
-		pr_err("%s failed to create lockspace\n", st->cluster_name);
+		pr_err("%s failed to create lockspace\n", cluster_name);
                 goto out;
 	}
 
@@ -146,7 +149,7 @@ int cluster_get_dlmlock(struct supertype *st, int *lockid)
 	if (flags & LKF_CONVERT)
 		dlm_lock_res->lksb.sb_lkid = *lockid;
 
-	snprintf(str, 64, "bitmap%04d", st->nodes);
+	snprintf(str, 64, "bitmap%s", cluster_name);
 	/* if flags with LKF_CONVERT causes below return ENOENT which means
 	 * "No such file or directory" */
 	ret = dlm_hooks->ls_lock(dlm_lock_res->ls, LKM_PWMODE, &dlm_lock_res->lksb,
@@ -171,10 +174,13 @@ out:
 	return ret;
 }
 
-int cluster_release_dlmlock(struct supertype *st, int lockid)
+int cluster_release_dlmlock(int lockid)
 {
 	int ret = -1;
 
+	if (!cluster_name)
+		return -1;
+
 	/* if flags with LKF_CONVERT causes below return EINVAL which means
 	 * "Invalid argument" */
 	ret = dlm_hooks->ls_unlock(dlm_lock_res->ls, lockid, 0,
@@ -195,7 +201,7 @@ int cluster_release_dlmlock(struct supertype *st, int lockid)
                 goto out;
 	}
 
-	ret = dlm_hooks->release_lockspace(st->cluster_name, dlm_lock_res->ls, 1);
+	ret = dlm_hooks->release_lockspace(cluster_name, dlm_lock_res->ls, 1);
 	if (ret) {
 		pr_err("error %d happened when release lockspace\n", errno);
 		/* XXX make sure the lockspace is released eventually */
-- 
2.1.4

