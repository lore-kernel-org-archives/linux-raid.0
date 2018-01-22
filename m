From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V3 1/3] mdadm: improve the dlm locking mechanism for clustered raid
Date: Mon, 22 Jan 2018 17:12:08 +0800
Message-ID: <20180122091210.29910-2-gqjiang@suse.com>
References: <20180122091210.29910-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180122091210.29910-1-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Previously, the dlm locking only protects several
functions which writes to superblock (update_super,
add_to_super and store_super), and we missed other
funcs such as add_internal_bitmap. We also need to
call the funcs which read superblock under the
locking protection to avoid consistent issue.

So let's remove the dlm stuffs from super1.c, and
provide the locking mechanism to the main() except
assemble mode which will be handled in next commit.
And since we can identify it is a clustered raid or
not based on check the different conditions of each
mode, so the change should not have effect on native
array.

And we improve the existed locking stuffs as follows:

1. replace ls_unlock with ls_unlock_wait since we
should return when unlock operation is complete.

2. inspired by lvm, let's also try to use the existed
lockspace first before creat a lockspace blindly if
the lockspace not released for some reason.

3. try more times before quit if EAGAIN happened for
locking.

Note: for MANAGE mode, we do not need to get lock if
node just want to confirm device change, otherwise we
can't add a disk to cluster since all nodes are compete
for the lock.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 mdadm.c  | 20 ++++++++++++++++++++
 mdadm.h  | 10 +++++-----
 super1.c | 42 ------------------------------------------
 util.c   | 57 +++++++++++++++++++++++++++++++++++++++++++--------------
 4 files changed, 68 insertions(+), 61 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index afc3015144d3..5afe4155d701 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -57,6 +57,7 @@ int main(int argc, char *argv[])
 	struct mddev_dev *devlist = NULL;
 	struct mddev_dev **devlistend = & devlist;
 	struct mddev_dev *dv;
+	mdu_array_info_t array;
 	int devs_found = 0;
 	char *symlinks = NULL;
 	int grow_continue = 0;
@@ -103,6 +104,7 @@ int main(int argc, char *argv[])
 	FILE *outf;
 
 	int mdfd = -1;
+	int locked = 0;
 
 	srandom(time(0) ^ getpid());
 
@@ -1434,6 +1436,22 @@ int main(int argc, char *argv[])
 		/* --scan implied --brief unless -vv */
 		c.brief = 1;
 
+	if (mode == CREATE) {
+		if (s.bitmap_file && strcmp(s.bitmap_file, "clustered") == 0) {
+			locked = cluster_get_dlmlock();
+			if (locked != 1)
+				exit(1);
+		}
+	} else if (mode == MANAGE || mode == GROW || mode == INCREMENTAL) {
+		if (!md_get_array_info(mdfd, &array) && (devmode != 'c')) {
+			if (array.state & (1 << MD_SB_CLUSTERED)) {
+				locked = cluster_get_dlmlock();
+				if (locked != 1)
+					exit(1);
+			}
+		}
+	}
+
 	switch(mode) {
 	case MANAGE:
 		/* readonly, add/remove, readwrite, runstop */
@@ -1739,6 +1757,8 @@ int main(int argc, char *argv[])
 		autodetect();
 		break;
 	}
+	if (locked)
+		cluster_release_dlmlock();
 	if (mdfd > 0)
 		close(mdfd);
 	exit(rv);
diff --git a/mdadm.h b/mdadm.h
index cf4721aa9e9a..61bc7afe036e 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1604,6 +1604,7 @@ struct dlm_hooks {
 
 	dlm_lshandle_t (*create_lockspace)(const char *name,
 					   unsigned int mode);
+	dlm_lshandle_t (*open_lockspace)(const char *name);
 	int (*release_lockspace)(const char *name, dlm_lshandle_t ls,
 				 int force);
 	int (*ls_lock)(dlm_lshandle_t lockspace, uint32_t mode,
@@ -1612,17 +1613,16 @@ struct dlm_hooks {
 		       uint32_t parent, void (*astaddr) (void *astarg),
 		       void *astarg, void (*bastaddr) (void *astarg),
 		       void *range);
-	int (*ls_unlock)(dlm_lshandle_t lockspace, uint32_t lkid,
-			 uint32_t flags, struct dlm_lksb *lksb,
-			 void *astarg);
+	int (*ls_unlock_wait)(dlm_lshandle_t lockspace, uint32_t lkid,
+			      uint32_t flags, struct dlm_lksb *lksb);
 	int (*ls_get_fd)(dlm_lshandle_t ls);
 	int (*dispatch)(int fd);
 };
 
 extern int get_cluster_name(char **name);
 extern int dlm_funs_ready(void);
-extern int cluster_get_dlmlock(int *lockid);
-extern int cluster_release_dlmlock(int lockid);
+extern int cluster_get_dlmlock(void);
+extern int cluster_release_dlmlock(void);
 extern void set_dlm_hooks(void);
 
 #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
diff --git a/super1.c b/super1.c
index 7ae6dc326683..6774fbd2b53f 100644
--- a/super1.c
+++ b/super1.c
@@ -1185,20 +1185,9 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 	 * ignored.
 	 */
 	int rv = 0;
-	int lockid;
 	struct mdp_superblock_1 *sb = st->sb;
 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MAX_SB_SIZE);
 
-	if (bms->version == BITMAP_MAJOR_CLUSTERED && dlm_funs_ready()) {
-		rv = cluster_get_dlmlock(&lockid);
-		if (rv) {
-			pr_err("Cannot get dlmlock in %s return %d\n",
-			       __func__, rv);
-			cluster_release_dlmlock(lockid);
-			return rv;
-		}
-	}
-
 	if (strcmp(update, "homehost") == 0 &&
 	    homehost) {
 		/* Note that 'homehost' is special as it is really
@@ -1551,8 +1540,6 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		rv = -1;
 
 	sb->sb_csum = calc_sb_1_csum(sb);
-	if (bms->version == BITMAP_MAJOR_CLUSTERED && dlm_funs_ready())
-		cluster_release_dlmlock(lockid);
 
 	return rv;
 }
@@ -1656,20 +1643,8 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 	struct mdp_superblock_1 *sb = st->sb;
 	__u16 *rp = sb->dev_roles + dk->number;
 	struct devinfo *di, **dip;
-	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MAX_SB_SIZE);
-	int rv, lockid;
 	int dk_state;
 
-	if (bms->version == BITMAP_MAJOR_CLUSTERED && dlm_funs_ready()) {
-		rv = cluster_get_dlmlock(&lockid);
-		if (rv) {
-			pr_err("Cannot get dlmlock in %s return %d\n",
-			       __func__, rv);
-			cluster_release_dlmlock(lockid);
-			return rv;
-		}
-	}
-
 	dk_state = dk->state & ~(1<<MD_DISK_FAILFAST);
 	if ((dk_state & (1<<MD_DISK_ACTIVE)) &&
 	    (dk_state & (1<<MD_DISK_SYNC)))/* active, sync */
@@ -1701,9 +1676,6 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 	di->next = NULL;
 	*dip = di;
 
-	if (bms->version == BITMAP_MAJOR_CLUSTERED && dlm_funs_ready())
-		cluster_release_dlmlock(lockid);
-
 	return 0;
 }
 
@@ -1716,18 +1688,6 @@ static int store_super1(struct supertype *st, int fd)
 	struct align_fd afd;
 	int sbsize;
 	unsigned long long dsize;
-	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MAX_SB_SIZE);
-	int rv, lockid;
-
-	if (bms->version == BITMAP_MAJOR_CLUSTERED && dlm_funs_ready()) {
-		rv = cluster_get_dlmlock(&lockid);
-		if (rv) {
-			pr_err("Cannot get dlmlock in %s return %d\n",
-			       __func__, rv);
-			cluster_release_dlmlock(lockid);
-			return rv;
-		}
-	}
 
 	if (!get_dev_size(fd, NULL, &dsize))
 		return 1;
@@ -1788,8 +1748,6 @@ static int store_super1(struct supertype *st, int fd)
 		}
 	}
 	fsync(fd);
-	if (bms->version == BITMAP_MAJOR_CLUSTERED && dlm_funs_ready())
-		cluster_release_dlmlock(lockid);
 
 	return 0;
 }
diff --git a/util.c b/util.c
index 543ec6cf46ef..4adbbff0295e 100644
--- a/util.c
+++ b/util.c
@@ -128,11 +128,17 @@ static void dlm_ast(void *arg)
 
 static char *cluster_name = NULL;
 /* Create the lockspace, take bitmapXXX locks on all the bitmaps. */
-int cluster_get_dlmlock(int *lockid)
+int cluster_get_dlmlock(void)
 {
 	int ret = -1;
 	char str[64];
 	int flags = LKF_NOQUEUE;
+	int retry_count = 0;
+
+	if (!dlm_funs_ready()) {
+		pr_err("Something wrong with dlm library\n");
+		return -1;
+	}
 
 	ret = get_cluster_name(&cluster_name);
 	if (ret) {
@@ -141,38 +147,57 @@ int cluster_get_dlmlock(int *lockid)
 	}
 
 	dlm_lock_res = xmalloc(sizeof(struct dlm_lock_resource));
-	dlm_lock_res->ls = dlm_hooks->create_lockspace(cluster_name, O_RDWR);
+	dlm_lock_res->ls = dlm_hooks->open_lockspace(cluster_name);
 	if (!dlm_lock_res->ls) {
-		pr_err("%s failed to create lockspace\n", cluster_name);
-		return -ENOMEM;
+		dlm_lock_res->ls = dlm_hooks->create_lockspace(cluster_name, O_RDWR);
+		if (!dlm_lock_res->ls) {
+			pr_err("%s failed to create lockspace\n", cluster_name);
+			return -ENOMEM;
+		}
+	} else {
+		pr_err("open existed %s lockspace\n", cluster_name);
 	}
 
 	snprintf(str, 64, "bitmap%s", cluster_name);
+retry:
 	ret = dlm_hooks->ls_lock(dlm_lock_res->ls, LKM_PWMODE,
 				 &dlm_lock_res->lksb, flags, str, strlen(str),
 				 0, dlm_ast, dlm_lock_res, NULL, NULL);
 	if (ret) {
 		pr_err("error %d when get PW mode on lock %s\n", errno, str);
+		/* let's try several times if EAGAIN happened */
+		if (dlm_lock_res->lksb.sb_status == EAGAIN && retry_count < 10) {
+			sleep(10);
+			retry_count++;
+			goto retry;
+		}
 		dlm_hooks->release_lockspace(cluster_name, dlm_lock_res->ls, 1);
 		return ret;
 	}
 
 	/* Wait for it to complete */
 	poll_for_ast(dlm_lock_res->ls);
-	*lockid = dlm_lock_res->lksb.sb_lkid;
 
-	return dlm_lock_res->lksb.sb_status;
+	if (dlm_lock_res->lksb.sb_status) {
+		pr_err("failed to lock cluster\n");
+		return -1;
+	}
+	return 1;
 }
 
-int cluster_release_dlmlock(int lockid)
+int cluster_release_dlmlock(void)
 {
 	int ret = -1;
 
 	if (!cluster_name)
-		return -1;
+                goto out;
+
+	if (!dlm_lock_res->lksb.sb_lkid)
+                goto out;
 
-	ret = dlm_hooks->ls_unlock(dlm_lock_res->ls, lockid, 0,
-				     &dlm_lock_res->lksb, dlm_lock_res);
+	ret = dlm_hooks->ls_unlock_wait(dlm_lock_res->ls,
+					dlm_lock_res->lksb.sb_lkid, 0,
+					&dlm_lock_res->lksb);
 	if (ret) {
 		pr_err("error %d happened when unlock\n", errno);
 		/* XXX make sure the lock is unlocked eventually */
@@ -2324,18 +2349,22 @@ void set_dlm_hooks(void)
 	if (!dlm_hooks->dlm_handle)
 		return;
 
+	dlm_hooks->open_lockspace =
+		dlsym(dlm_hooks->dlm_handle, "dlm_open_lockspace");
 	dlm_hooks->create_lockspace =
 		dlsym(dlm_hooks->dlm_handle, "dlm_create_lockspace");
 	dlm_hooks->release_lockspace =
 		dlsym(dlm_hooks->dlm_handle, "dlm_release_lockspace");
 	dlm_hooks->ls_lock = dlsym(dlm_hooks->dlm_handle, "dlm_ls_lock");
-	dlm_hooks->ls_unlock = dlsym(dlm_hooks->dlm_handle, "dlm_ls_unlock");
+	dlm_hooks->ls_unlock_wait =
+		dlsym(dlm_hooks->dlm_handle, "dlm_ls_unlock_wait");
 	dlm_hooks->ls_get_fd = dlsym(dlm_hooks->dlm_handle, "dlm_ls_get_fd");
 	dlm_hooks->dispatch = dlsym(dlm_hooks->dlm_handle, "dlm_dispatch");
 
-	if (!dlm_hooks->create_lockspace || !dlm_hooks->ls_lock ||
-	    !dlm_hooks->ls_unlock || !dlm_hooks->release_lockspace ||
-	    !dlm_hooks->ls_get_fd || !dlm_hooks->dispatch)
+	if (!dlm_hooks->open_lockspace || !dlm_hooks->create_lockspace ||
+	    !dlm_hooks->ls_lock || !dlm_hooks->ls_unlock_wait ||
+	    !dlm_hooks->release_lockspace || !dlm_hooks->ls_get_fd ||
+	    !dlm_hooks->dispatch)
 		dlclose(dlm_hooks->dlm_handle);
 	else
 		is_dlm_hooks_ready = 1;
-- 
2.13.6

