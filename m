From: Zhilong Liu <zlliu@suse.com>
Subject: [mdadm PATCH 1/2] util: unify fstat operations into function
Date: Tue,  2 May 2017 11:26:45 +0800
Message-ID: <20170502032646.20220-2-zlliu@suse.com>
References: <20170502032646.20220-1-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170502032646.20220-1-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

declare new function to integrate repeated fstat operation,
the fd and devname are necessary arguments, the dev_t *rdev
is optional. according to parse the pointer of dev_t *rdev,
if valid, assigned device number to rdev, if NULL, ignores.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 Assemble.c    | 17 +++++------------
 Build.c       |  5 +++--
 Create.c      | 23 ++++++++++-------------
 Grow.c        | 10 ++++------
 Incremental.c | 33 ++++++++++++---------------------
 Manage.c      |  2 +-
 bitmap.c      | 10 +---------
 mdadm.h       |  1 +
 super-intel.c | 13 +++----------
 util.c        | 17 +++++++++++++++++
 10 files changed, 57 insertions(+), 74 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index d6beb23..58bf96d 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -149,6 +149,7 @@ static int select_devices(struct mddev_dev *devlist,
 	struct mdinfo *content = NULL;
 	int report_mismatch = ((inargv && c->verbose >= 0) || c->verbose > 0);
 	struct domainlist *domains = NULL;
+	dev_t rdev;
 
 	tmpdev = devlist; num_devs = 0;
 	while (tmpdev) {
@@ -169,7 +170,6 @@ static int select_devices(struct mddev_dev *devlist,
 	     tmpdev = tmpdev ? tmpdev->next : NULL) {
 		char *devname = tmpdev->devname;
 		int dfd;
-		struct stat stb;
 		struct supertype *tst;
 		struct dev_policy *pol = NULL;
 		int found_container = 0;
@@ -204,14 +204,7 @@ static int select_devices(struct mddev_dev *devlist,
 				pr_err("cannot open device %s: %s\n",
 				       devname, strerror(errno));
 			tmpdev->used = 2;
-		} else if (fstat(dfd, &stb)< 0) {
-			/* Impossible! */
-			pr_err("fstat failed for %s: %s\n",
-			       devname, strerror(errno));
-			tmpdev->used = 2;
-		} else if ((stb.st_mode & S_IFMT) != S_IFBLK) {
-			pr_err("%s is not a block device.\n",
-			       devname);
+		} else if (fstat_md_is_blkdev(dfd, devname, &rdev)){
 			tmpdev->used = 2;
 		} else if (must_be_container(dfd)) {
 			if (st) {
@@ -234,7 +227,7 @@ static int select_devices(struct mddev_dev *devlist,
 					       devname);
 				tmpdev->used = 2;
 			} else if (auto_assem &&
-				   !conf_test_metadata(tst->ss->name, (pol = devid_policy(stb.st_rdev)),
+				   !conf_test_metadata(tst->ss->name, (pol = devid_policy(rdev)),
 						       tst->ss->match_home(tst, c->homehost) == 1)) {
 				if (report_mismatch)
 					pr_err("%s has metadata type %s for which auto-assembly is disabled\n",
@@ -261,7 +254,7 @@ static int select_devices(struct mddev_dev *devlist,
 					       tst->ss->name, devname);
 				tmpdev->used = 2;
 			} else if (auto_assem && st == NULL &&
-				   !conf_test_metadata(tst->ss->name, (pol = devid_policy(stb.st_rdev)),
+				   !conf_test_metadata(tst->ss->name, (pol = devid_policy(rdev)),
 						       tst->ss->match_home(tst, c->homehost) == 1)) {
 				if (report_mismatch)
 					pr_err("%s has metadata type %s for which auto-assembly is disabled\n",
@@ -484,7 +477,7 @@ static int select_devices(struct mddev_dev *devlist,
 		/* Collect domain information from members only */
 		if (tmpdev && tmpdev->used == 1) {
 			if (!pol)
-				pol = devid_policy(stb.st_rdev);
+				pol = devid_policy(rdev);
 			domain_merge(&domains, pol, tst?tst->ss->name:NULL);
 		}
 		dev_policy_free(pol);
diff --git a/Build.c b/Build.c
index 11ba12f..25aa4ea 100644
--- a/Build.c
+++ b/Build.c
@@ -42,6 +42,7 @@ int Build(char *mddev, struct mddev_dev *devlist,
 	 */
 	int i;
 	struct stat stb;
+	dev_t rdev;
 	int subdevs = 0, missing_disks = 0;
 	struct mddev_dev *dv;
 	int bitmap_fd;
@@ -126,8 +127,8 @@ int Build(char *mddev, struct mddev_dev *devlist,
 	array.nr_disks = s->raiddisks;
 	array.raid_disks = s->raiddisks;
 	array.md_minor = 0;
-	if (fstat(mdfd, &stb) == 0)
-		array.md_minor = minor(stb.st_rdev);
+	if (fstat_md_is_blkdev(mdfd, mddev, &rdev) == 0)
+		array.md_minor = minor(rdev);
 	array.not_persistent = 1;
 	array.state = 0; /* not clean, but no errors */
 	if (s->assume_clean)
diff --git a/Create.c b/Create.c
index 6ca0924..0f57257 100644
--- a/Create.c
+++ b/Create.c
@@ -89,8 +89,8 @@ int Create(struct supertype *st, char *mddev,
 	char *maxdisc = NULL;
 	int dnum, raid_disk_num;
 	struct mddev_dev *dv;
+	dev_t rdev;
 	int fail = 0, warn = 0;
-	struct stat stb;
 	int first_missing = subdevs * 2;
 	int second_missing = subdevs * 2;
 	int missing_disks = 0;
@@ -325,11 +325,8 @@ int Create(struct supertype *st, char *mddev,
 				dname, strerror(errno));
 			exit(2);
 		}
-		if (fstat(dfd, &stb) != 0 ||
-		    (stb.st_mode & S_IFMT) != S_IFBLK) {
+		if (fstat_md_is_blkdev(dfd, dname, NULL)) {
 			close(dfd);
-			pr_err("%s is not a block device\n",
-				dname);
 			exit(2);
 		}
 		close(dfd);
@@ -640,8 +637,8 @@ int Create(struct supertype *st, char *mddev,
 	 * with, but it chooses to trust me instead. Sigh
 	 */
 	info.array.md_minor = 0;
-	if (fstat(mdfd, &stb) == 0)
-		info.array.md_minor = minor(stb.st_rdev);
+	if (fstat_md_is_blkdev(mdfd, mddev, &rdev) == 0)
+		info.array.md_minor = minor(rdev);
 	info.array.not_persistent = 0;
 
 	if (((s->level == 4 || s->level == 5) &&
@@ -840,7 +837,6 @@ int Create(struct supertype *st, char *mddev,
 		for (dnum = 0, raid_disk_num = 0, dv = devlist; dv;
 		     dv = (dv->next) ? (dv->next) : moved_disk, dnum++) {
 			int fd;
-			struct stat stb2;
 			struct mdinfo *inf = &infos[dnum];
 
 			if (dnum >= total_slots)
@@ -896,9 +892,10 @@ int Create(struct supertype *st, char *mddev,
 							dv->devname);
 						goto abort_locked;
 					}
-					fstat(fd, &stb2);
-					inf->disk.major = major(stb2.st_rdev);
-					inf->disk.minor = minor(stb2.st_rdev);
+					if (fstat_md_is_blkdev(fd, dv->devname, &rdev))
+						return 1;
+					inf->disk.major = major(rdev);
+					inf->disk.minor = minor(rdev);
 				}
 				if (fd >= 0)
 					remove_partitions(fd);
@@ -919,8 +916,8 @@ int Create(struct supertype *st, char *mddev,
 
 				if (!have_container) {
 					/* getinfo_super might have lost these ... */
-					inf->disk.major = major(stb2.st_rdev);
-					inf->disk.minor = minor(stb2.st_rdev);
+					inf->disk.major = major(rdev);
+					inf->disk.minor = minor(rdev);
 				}
 				break;
 			case 2:
diff --git a/Grow.c b/Grow.c
index c6967ed..5949db0 100755
--- a/Grow.c
+++ b/Grow.c
@@ -109,7 +109,7 @@ int Grow_Add_device(char *devname, int fd, char *newdev)
 	 */
 	struct mdinfo info;
 
-	struct stat stb;
+	dev_t rdev;
 	int nfd, fd2;
 	int d, nd;
 	struct supertype *st = NULL;
@@ -145,9 +145,7 @@ int Grow_Add_device(char *devname, int fd, char *newdev)
 		free(st);
 		return 1;
 	}
-	fstat(nfd, &stb);
-	if ((stb.st_mode & S_IFMT) != S_IFBLK) {
-		pr_err("%s is not a block device!\n", newdev);
+	if (fstat_md_is_blkdev(nfd, newdev, &rdev)) {
 		close(nfd);
 		free(st);
 		return 1;
@@ -198,8 +196,8 @@ int Grow_Add_device(char *devname, int fd, char *newdev)
 	 */
 
 	info.disk.number = d;
-	info.disk.major = major(stb.st_rdev);
-	info.disk.minor = minor(stb.st_rdev);
+	info.disk.major = major(rdev);
+	info.disk.minor = minor(rdev);
 	info.disk.raid_disk = d;
 	info.disk.state = (1 << MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE);
 	st->ss->update_super(st, &info, "linear-grow-new", newdev,
diff --git a/Incremental.c b/Incremental.c
index 28f1f77..6512af8 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -87,6 +87,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 	 *   start the array (auto-readonly).
 	 */
 	struct stat stb;
+	dev_t rdev;
 	struct mdinfo info, dinfo;
 	struct mdinfo *sra = NULL, *d;
 	struct mddev_ident *match;
@@ -175,21 +176,11 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 	/* 2/ Find metadata, reject if none appropriate (check
 	 *            version/name from args) */
 
-	if (fstat(dfd, &stb) < 0) {
-		if (c->verbose >= 0)
-			pr_err("fstat failed for %s: %s.\n",
-				devname, strerror(errno));
-		goto out;
-	}
-	if ((stb.st_mode & S_IFMT) != S_IFBLK) {
-		if (c->verbose >= 0)
-			pr_err("%s is not a block device.\n",
-				devname);
+	if (fstat_md_is_blkdev(dfd, devname, &rdev))
 		goto out;
-	}
 
-	dinfo.disk.major = major(stb.st_rdev);
-	dinfo.disk.minor = minor(stb.st_rdev);
+	dinfo.disk.major = major(rdev);
+	dinfo.disk.minor = minor(rdev);
 
 	policy = disk_policy(&dinfo);
 	have_target = policy_check_path(&dinfo, &target_array);
@@ -341,8 +332,8 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 		}
 
 		dinfo = info;
-		dinfo.disk.major = major(stb.st_rdev);
-		dinfo.disk.minor = minor(stb.st_rdev);
+		dinfo.disk.major = major(rdev);
+		dinfo.disk.minor = minor(rdev);
 		if (add_disk(mdfd, st, &info, &dinfo) != 0) {
 			pr_err("failed to add %s to new array %s: %s.\n",
 				devname, chosen_name, strerror(errno));
@@ -444,8 +435,8 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 				goto out_unlock;
 			}
 		}
-		info.disk.major = major(stb.st_rdev);
-		info.disk.minor = minor(stb.st_rdev);
+		info.disk.major = major(rdev);
+		info.disk.minor = minor(rdev);
 		/* add disk needs to know about containers */
 		if (st->ss->external)
 			sra->array.level = LEVEL_CONTAINER;
@@ -868,12 +859,12 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 	 * Return 0 on success, or some exit code on failure, probably 1.
 	 */
 	int rv = 1;
-	struct stat stb;
+	dev_t rdev;
 	struct map_ent *mp, *map = NULL;
 	struct mdinfo *chosen = NULL;
 	int dfd = *dfdp;
 
-	if (fstat(dfd, &stb) != 0)
+	if (fstat_md_is_blkdev(dfd, devname, &rdev))
 		return 1;
 
 	/*
@@ -1045,8 +1036,8 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 			devlist.writemostly = FlagDefault;
 			devlist.failfast = FlagDefault;
 			devlist.devname = chosen_devname;
-			sprintf(chosen_devname, "%d:%d", major(stb.st_rdev),
-				minor(stb.st_rdev));
+			sprintf(chosen_devname, "%d:%d", major(rdev),
+				minor(rdev));
 			devlist.disposition = 'a';
 			close(dfd);
 			*dfdp = -1;
diff --git a/Manage.c b/Manage.c
index 8966e33..69c68ba 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1515,7 +1515,7 @@ int Manage_subdevs(char *devname, int fd,
 			struct stat stb;
 			tfd = dev_open(dv->devname, O_RDONLY);
 			if (tfd >= 0) {
-				fstat(tfd, &stb);
+				fstat_md_is_blkdev(tfd, dv->devname, &rdev);
 				close(tfd);
 			} else {
 				int open_err = errno;
diff --git a/bitmap.c b/bitmap.c
index 16a6b73..2cf7938 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -183,7 +183,6 @@ static int
 bitmap_file_open(char *filename, struct supertype **stp, int node_num)
 {
 	int fd;
-	struct stat stb;
 	struct supertype *st = *stp;
 
 	fd = open(filename, O_RDONLY|O_DIRECT);
@@ -193,14 +192,7 @@ bitmap_file_open(char *filename, struct supertype **stp, int node_num)
 		return -1;
 	}
 
-	if (fstat(fd, &stb) < 0) {
-		pr_err("failed to determine bitmap file/device type: %s\n",
-			strerror(errno));
-		close(fd);
-		return -1;
-	}
-
-	if ((stb.st_mode & S_IFMT) == S_IFBLK) {
+	if (fstat_md_is_blkdev(fd, filename, NULL) == 0) {
 		/* block device, so we are probably after an internal bitmap */
 		if (!st)
 			st = guess_super(fd);
diff --git a/mdadm.h b/mdadm.h
index 1bbacfe..1d63932 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1433,6 +1433,7 @@ extern int check_raid(int fd, char *name);
 extern int check_partitions(int fd, char *dname,
 			    unsigned long long freesize,
 			    unsigned long long size);
+extern int fstat_md_is_blkdev(int fd, char *devname, dev_t *rdev);
 
 extern int get_mdp_major(void);
 extern int get_maj_min(char *dev, int *major, int *minor);
diff --git a/super-intel.c b/super-intel.c
index 0aed57c..c16edfb 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6557,7 +6557,7 @@ count_volumes_list(struct md_list *devlist, char *homehost,
 
 	for (tmpdev = devlist; tmpdev; tmpdev = tmpdev->next) {
 		char *devname = tmpdev->devname;
-		struct stat stb;
+		dev_t rdev;
 		struct supertype *tst;
 		int dfd;
 		if (tmpdev->used > 1)
@@ -6573,14 +6573,7 @@ count_volumes_list(struct md_list *devlist, char *homehost,
 			dprintf("cannot open device %s: %s\n",
 				devname, strerror(errno));
 			tmpdev->used = 2;
-		} else if (fstat(dfd, &stb)< 0) {
-			/* Impossible! */
-			dprintf("fstat failed for %s: %s\n",
-				devname, strerror(errno));
-			tmpdev->used = 2;
-		} else if ((stb.st_mode & S_IFMT) != S_IFBLK) {
-			dprintf("%s is not a block device.\n",
-				devname);
+		} else if (fstat_md_is_blkdev(dfd, devname, &rdev)) {
 			tmpdev->used = 2;
 		} else if (must_be_container(dfd)) {
 			struct supertype *cst;
@@ -6602,7 +6595,7 @@ count_volumes_list(struct md_list *devlist, char *homehost,
 			if (cst)
 				cst->ss->free_super(cst);
 		} else {
-			tmpdev->st_rdev = stb.st_rdev;
+			tmpdev->st_rdev = rdev;
 			if (tst->ss->load_super(tst,dfd, NULL)) {
 				dprintf("no RAID superblock on %s\n",
 					devname);
diff --git a/util.c b/util.c
index 21a63c9..6294fff 100644
--- a/util.c
+++ b/util.c
@@ -706,6 +706,23 @@ int check_raid(int fd, char *name)
 	return 1;
 }
 
+int fstat_md_is_blkdev(int fd, char *devname, dev_t *rdev)
+{
+	struct stat stb;
+
+	if (fstat(fd, &stb) != 0) {
+		pr_err("fstat failed for %s: %s\n", devname, strerror(errno));
+		return 1;
+	}
+	if ((S_IFMT & stb.st_mode) != S_IFBLK) {
+		pr_err("%s is not a block device.\n", devname);
+		return 1;
+	}
+	if (rdev)
+		*rdev = stb.st_rdev;
+	return 0;
+}
+
 int ask(char *mesg)
 {
 	char *add = "";
-- 
2.10.2

