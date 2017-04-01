From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 2/4] mdadm/util:integrate fstat operations into one utility function
Date: Sat,  1 Apr 2017 20:51:43 +0800
Message-ID: <20170401125145.14440-3-zlliu@suse.com>
References: <20170401125145.14440-1-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170401125145.14440-1-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

mdadm/util: there are dupilicate codes about fstat checking the
block device, move the operations into one utility function and
make it concise.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 Assemble.c    | 10 ++--------
 Create.c      |  5 +----
 Grow.c        |  4 +---
 Incremental.c | 13 +------------
 bitmap.c      | 12 ++++--------
 mdadm.h       |  1 +
 super-intel.c | 10 ++--------
 util.c        | 15 +++++++++++++++
 8 files changed, 27 insertions(+), 43 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index c6571e6..47c6685 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -204,14 +204,8 @@ static int select_devices(struct mddev_dev *devlist,
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
+		} else if (check_blkdev_via_fstat(dfd, devname) &&
+			   fstat(dfd, &stb)) {
 			tmpdev->used = 2;
 		} else if (must_be_container(dfd)) {
 			if (st) {
diff --git a/Create.c b/Create.c
index 32987af..e43c1d6 100644
--- a/Create.c
+++ b/Create.c
@@ -326,11 +326,8 @@ int Create(struct supertype *st, char *mddev,
 				dname, strerror(errno));
 			exit(2);
 		}
-		if (fstat(dfd, &stb) != 0 ||
-		    (stb.st_mode & S_IFMT) != S_IFBLK) {
+		if (check_blkdev_via_fstat(dfd, dname)) {
 			close(dfd);
-			pr_err("%s is not a block device\n",
-				dname);
 			exit(2);
 		}
 		close(dfd);
diff --git a/Grow.c b/Grow.c
index 78a3474..0085f91 100755
--- a/Grow.c
+++ b/Grow.c
@@ -145,9 +145,7 @@ int Grow_Add_device(char *devname, int fd, char *newdev)
 		free(st);
 		return 1;
 	}
-	fstat(nfd, &stb);
-	if ((stb.st_mode & S_IFMT) != S_IFBLK) {
-		pr_err("%s is not a block device!\n", newdev);
+	if (check_blkdev_via_fstat(nfd, newdev) && fstat(nfd, &stb)) {
 		close(nfd);
 		free(st);
 		return 1;
diff --git a/Incremental.c b/Incremental.c
index 78adf18..19af045 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -164,19 +164,8 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 
 	/* 2/ Find metadata, reject if none appropriate (check
 	 *            version/name from args) */
-
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
+	if (check_blkdev_via_fstat(dfd, devname) && fstat(dfd, &stb))
 		goto out;
-	}
 
 	dinfo.disk.major = major(stb.st_rdev);
 	dinfo.disk.minor = minor(stb.st_rdev);
diff --git a/bitmap.c b/bitmap.c
index ccedfd3..69ce640 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -193,14 +193,7 @@ bitmap_file_open(char *filename, struct supertype **stp, int node_num)
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
+	if (check_blkdev_via_fstat(fd, filename)) {
 		/* block device, so we are probably after an internal bitmap */
 		if (!st)
 			st = guess_super(fd);
@@ -221,6 +214,9 @@ bitmap_file_open(char *filename, struct supertype **stp, int node_num)
 		}
 
 		*stp = st;
+	} else {
+		close(fd);
+		return -1;
 	}
 
 	return fd;
diff --git a/mdadm.h b/mdadm.h
index 0aea822..e021149 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1423,6 +1423,7 @@ extern int check_partitions(int fd, char *dname,
 			    unsigned long long freesize,
 			    unsigned long long size);
 extern int check_blkdev_via_stat(char *dev);
+extern int check_blkdev_via_fstat(int fd, char *dev);
 
 extern int get_mdp_major(void);
 extern int get_maj_min(char *dev, int *major, int *minor);
diff --git a/super-intel.c b/super-intel.c
index 924ad8a..014616c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6604,14 +6604,8 @@ count_volumes_list(struct md_list *devlist, char *homehost,
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
+		} else if (check_blkdev_via_fstat(dfd, devname) &&
+			   fstat(dfd, &stb)) {
 			tmpdev->used = 2;
 		} else if (must_be_container(dfd)) {
 			struct supertype *cst;
diff --git a/util.c b/util.c
index 03d4256..09750a0 100644
--- a/util.c
+++ b/util.c
@@ -789,6 +789,21 @@ int check_blkdev_via_stat(char *dev)
 	return 0;
 }
 
+int check_blkdev_via_fstat(int fd, char *dev)
+{
+	struct stat stb;
+
+	if (fstat(fd, &stb) != 0) {
+		pr_err("fstat failed for %s: %s\n", dev, strerror(errno));
+		return -1;
+	}
+	if ((S_IFMT & stb.st_mode) != S_IFBLK) {
+		pr_err("%s is not a block device.\n", dev);
+		return -1;
+	}
+	return 0;
+}
+
 int is_standard(char *dev, int *nump)
 {
 	/* tests if dev is a "standard" md dev name.
-- 
2.10.2

