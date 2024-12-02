Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189761F60A
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 02:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733104928; cv=none; b=lQxI5vguZ6Ckkd48eVW5RctA8o7QO8gGmvi/W7IOZV8byBPmMOkVuc+3/KimvTSgBVk4jcsB+jAwJPWyvNT474Xi2le4nytVqlm060mFo0nKpQ7m1C7zTUWq/47DJrbEhHKudFF7WK1oM2f0Ht5nnTv5hSun+N66hr/s17XZTKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733104928; c=relaxed/simple;
	bh=lCEn4RxpDqT8hcQZDlfgcATQWa5XD+mTT2lTI5oQDnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LRvWVcmqsn59K7Voz47RFJLOJwxae+KD5uOHfrOYumhaHwhyAHkJlIM2Ld5AR0lq3XdumoUFphOiyQz2sbhYJmNyzjHsDlhHFVI+RPQcJWHBiC3CZ9IBjV/yogrQ7STYUZffzXrSnt76ag4AAralhJdAYDyI2Jk6hugL8sMOVn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Y1n8H65MGz4f3jHx
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 10:01:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BD8401A0359
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 10:01:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHo4cQFU1ngWmkDQ--.17049S9;
	Mon, 02 Dec 2024 10:01:55 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v4 mdadm 5/5] mdadm: remove bitmap file support
Date: Mon,  2 Dec 2024 09:59:13 +0800
Message-Id: <20241202015913.3815936-6-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241202015913.3815936-1-yukuai1@huaweicloud.com>
References: <20241202015913.3815936-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHo4cQFU1ngWmkDQ--.17049S9
X-Coremail-Antispam: 1UD129KBjvAXoWfAFyDAw1kCF4rKF4xGw15Jwb_yoW8KF1Uto
	WIva45uF4rur10q342yrnxtFWagw1UKw1SyF1UKr9xuw4jq34Y9rWxWw43WasxXr4YgF93
	t3yxXr15Ga18Jry3n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUY67kC6x804xWl14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF
	0E3s1l82xGYIkIc2x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vE
	j48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxV
	AFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x02
	67AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I
	80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCj
	c4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7IU8SfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Because it's marked deprecated for a long time now, and it's not worthy
to support it for new bitmap.

Now that we don't need to store filename for bitmap, also declare a new
enum type bitmap_type to simplify code.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 Assemble.c    | 33 +-----------------
 Build.c       | 35 +------------------
 Create.c      | 36 +++-----------------
 Grow.c        | 94 ++++++---------------------------------------------
 Incremental.c | 37 +-------------------
 bitmap.c      | 44 +++++++++++++-----------
 config.c      | 17 +++++++---
 mdadm.c       | 85 +++++++++++++++++++++-------------------------
 mdadm.h       | 18 ++++++----
 9 files changed, 103 insertions(+), 296 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 87d1ae04..37a530ee 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -633,7 +633,6 @@ static int load_devices(struct devs *devices, char *devmap,
 	struct mddev_dev *tmpdev;
 	int devcnt = 0;
 	int nextspare = 0;
-	int bitmap_done = 0;
 	int most_recent = -1;
 	int bestcnt = 0;
 	int *best = *bestp;
@@ -661,7 +660,7 @@ static int load_devices(struct devs *devices, char *devmap,
 			if (c->update == UOPT_UUID && !ident->uuid_set)
 				random_uuid((__u8 *)ident->uuid);
 
-			if (c->update == UOPT_PPL && ident->bitmap_fd >= 0) {
+			if (c->update == UOPT_PPL && ident->btype != BitmapNone) {
 				pr_err("PPL is not compatible with bitmap\n");
 				close(mdfd);
 				free(devices);
@@ -728,16 +727,6 @@ static int load_devices(struct devs *devices, char *devmap,
 			if (tst->ss->store_super(tst, dfd))
 				pr_err("Could not re-write superblock on %s.\n",
 				       devname);
-
-			if (c->update == UOPT_UUID &&
-			    ident->bitmap_fd >= 0 && !bitmap_done) {
-				if (bitmap_update_uuid(ident->bitmap_fd,
-						       content->uuid,
-						       tst->ss->swapuuid) != 0)
-					pr_err("Could not update uuid on external bitmap.\n");
-				else
-					bitmap_done = 1;
-			}
 		} else {
 			dfd = dev_open(devname,
 				       tmpdev->disposition == 'I'
@@ -1057,26 +1046,6 @@ static int start_array(int mdfd,
 		       mddev, strerror(errno));
 		return 1;
 	}
-	if (ident->bitmap_fd >= 0) {
-		if (ioctl(mdfd, SET_BITMAP_FILE, ident->bitmap_fd) != 0) {
-			pr_err("SET_BITMAP_FILE failed.\n");
-			return 1;
-		}
-	} else if (ident->bitmap_file) {
-		/* From config file */
-		int bmfd = open(ident->bitmap_file, O_RDWR);
-		if (bmfd < 0) {
-			pr_err("Could not open bitmap file %s\n",
-			       ident->bitmap_file);
-			return 1;
-		}
-		if (ioctl(mdfd, SET_BITMAP_FILE, bmfd) != 0) {
-			pr_err("Failed to set bitmapfile for %s\n", mddev);
-			close(bmfd);
-			return 1;
-		}
-		close(bmfd);
-	}
 
 	/* First, add the raid disks, but add the chosen one last */
 	for (i = 0; i <= bestcnt; i++) {
diff --git a/Build.c b/Build.c
index 6f63d3f3..70aab7a0 100644
--- a/Build.c
+++ b/Build.c
@@ -40,8 +40,6 @@ int Build(struct mddev_ident *ident, struct mddev_dev *devlist, struct shape *s,
 	dev_t rdev;
 	int subdevs = 0, missing_disks = 0;
 	struct mddev_dev *dv;
-	int bitmap_fd;
-	unsigned long long bitmapsize;
 	int mdfd;
 	char chosen_name[1024];
 	int uuid[4] = {0,0,0,0};
@@ -110,13 +108,6 @@ int Build(struct mddev_ident *ident, struct mddev_dev *devlist, struct shape *s,
 		goto abort;
 	}
 
-	if (s->bitmap_file && str_is_none(s->bitmap_file) == true)
-		s->bitmap_file = NULL;
-	if (s->bitmap_file && s->level <= 0) {
-		pr_err("bitmaps not meaningful with level %s\n",
-			map_num(pers, s->level)?:"given");
-		goto abort;
-	}
 	/* now add the devices */
 	for ((i=0), (dv = devlist) ; dv ; i++, dv=dv->next) {
 		mdu_disk_info_t disk;
@@ -150,31 +141,7 @@ int Build(struct mddev_ident *ident, struct mddev_dev *devlist, struct shape *s,
 			goto abort;
 		}
 	}
-	/* now to start it */
-	if (s->bitmap_file) {
-		bitmap_fd = open(s->bitmap_file, O_RDWR);
-		if (bitmap_fd < 0) {
-			int major = BITMAP_MAJOR_HI;
-			bitmapsize = s->size >> 9; /* FIXME wrong for RAID10 */
-			if (CreateBitmap(s->bitmap_file, 1, NULL,
-					 s->bitmap_chunk, c->delay,
-					 s->write_behind, bitmapsize, major)) {
-				goto abort;
-			}
-			bitmap_fd = open(s->bitmap_file, O_RDWR);
-			if (bitmap_fd < 0) {
-				pr_err("%s cannot be opened.\n", s->bitmap_file);
-				goto abort;
-			}
-		}
-		if (ioctl(mdfd, SET_BITMAP_FILE, bitmap_fd) < 0) {
-			pr_err("Cannot set bitmap file for %s: %s\n", chosen_name,
-			       strerror(errno));
-			close(bitmap_fd);
-			goto abort;
-		}
-	close(bitmap_fd);
-	}
+
 	if (ioctl(mdfd, RUN_ARRAY, &param)) {
 		pr_err("RUN_ARRAY failed: %s\n", strerror(errno));
 		if (s->chunk & (s->chunk - 1)) {
diff --git a/Create.c b/Create.c
index f6d14f76..fd6c9215 100644
--- a/Create.c
+++ b/Create.c
@@ -521,7 +521,6 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 	int insert_point = subdevs * 2; /* where to insert a missing drive */
 	int total_slots;
 	int rv;
-	int bitmap_fd;
 	int have_container = 0;
 	int container_fd = -1;
 	int need_mdmon = 0;
@@ -534,9 +533,9 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 	struct map_ent *map = NULL;
 	unsigned long long newsize;
 	mdu_array_info_t inf;
-
 	int major_num = BITMAP_MAJOR_HI;
-	if (s->bitmap_file && strcmp(s->bitmap_file, "clustered") == 0) {
+
+	if (s->btype == BitmapCluster) {
 		major_num = BITMAP_MAJOR_CLUSTERED;
 		if (c->nodes <= 1) {
 			pr_err("At least 2 nodes are needed for cluster-md\n");
@@ -618,7 +617,7 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 		pr_err("You haven't given enough devices (real or missing) to create this array\n");
 		return 1;
 	}
-	if (s->bitmap_file && s->level <= 0) {
+	if (s->btype != BitmapNone && s->level <= 0) {
 		pr_err("bitmaps not meaningful with level %s\n",
 			map_num(pers, s->level)?:"given");
 		return 1;
@@ -949,9 +948,6 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 		}
 	}
 
-	if (s->bitmap_file && str_is_none(s->bitmap_file) == true)
-		s->bitmap_file = NULL;
-
 	if (s->consistency_policy == CONSISTENCY_POLICY_PPL &&
 	    !st->ss->write_init_ppl) {
 		pr_err("%s metadata does not support PPL\n", st->ss->name);
@@ -1186,8 +1182,7 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 	 * to stop another mdadm from finding and using those devices.
 	 */
 
-	if (s->bitmap_file && (strcmp(s->bitmap_file, "internal") == 0 ||
-			       strcmp(s->bitmap_file, "clustered") == 0)) {
+	if (s->btype == BitmapInternal || s->btype == BitmapCluster) {
 		if (!st->ss->add_internal_bitmap) {
 			pr_err("internal bitmaps not supported with %s metadata\n",
 				st->ss->name);
@@ -1199,7 +1194,6 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 			pr_err("Given bitmap chunk size not supported.\n");
 			goto abort_locked;
 		}
-		s->bitmap_file = NULL;
 	}
 
 	if (sysfs_init(&info, mdfd, NULL)) {
@@ -1241,28 +1235,6 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 		goto abort_locked;
 	}
 
-	if (s->bitmap_file) {
-		int uuid[4];
-
-		st->ss->uuid_from_super(st, uuid);
-		if (CreateBitmap(s->bitmap_file, c->force, (char*)uuid, s->bitmap_chunk,
-				 c->delay, s->write_behind,
-				 bitmapsize,
-				 major_num)) {
-			goto abort_locked;
-		}
-		bitmap_fd = open(s->bitmap_file, O_RDWR);
-		if (bitmap_fd < 0) {
-			pr_err("weird: %s cannot be opened\n",
-				s->bitmap_file);
-			goto abort_locked;
-		}
-		if (ioctl(mdfd, SET_BITMAP_FILE, bitmap_fd) < 0) {
-			pr_err("Cannot set bitmap file for %s: %s\n", chosen_name, strerror(errno));
-			goto abort_locked;
-		}
-	}
-
 	if (add_disks(mdfd, &info, s, c, st, &map, devlist, total_slots,
 		      have_container, insert_point, major_num, chosen_name))
 		goto abort_locked;
diff --git a/Grow.c b/Grow.c
index 31786941..cc1be6cc 100644
--- a/Grow.c
+++ b/Grow.c
@@ -285,7 +285,6 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 	 * find all the active devices, and write the bitmap block
 	 * to all devices
 	 */
-	mdu_bitmap_file_t bmf;
 	mdu_array_info_t array;
 	struct supertype *st;
 	char *subarray = NULL;
@@ -294,40 +293,21 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 	struct mdinfo *mdi;
 
 	/*
-	 * We only ever get called if s->bitmap_file is != NULL, so this check
+	 * We only ever get called if bitmap is not none, so this check
 	 * is just here to quiet down static code checkers.
 	 */
-	if (!s->bitmap_file)
+	if (s->btype == BitmapUnknown)
 		return 1;
 
-	if (strcmp(s->bitmap_file, "clustered") == 0)
+	if (s->btype == BitmapCluster)
 		major = BITMAP_MAJOR_CLUSTERED;
 
-	if (ioctl(fd, GET_BITMAP_FILE, &bmf) != 0) {
-		if (errno == ENOMEM)
-			pr_err("Memory allocation failure.\n");
-		else
-			pr_err("bitmaps not supported by this kernel.\n");
-		return 1;
-	}
-	if (bmf.pathname[0]) {
-		if (str_is_none(s->bitmap_file) == true) {
-			if (ioctl(fd, SET_BITMAP_FILE, -1) != 0) {
-				pr_err("failed to remove bitmap %s\n",
-					bmf.pathname);
-				return 1;
-			}
-			return 0;
-		}
-		pr_err("%s already has a bitmap (%s)\n", devname, bmf.pathname);
-		return 1;
-	}
 	if (md_get_array_info(fd, &array) != 0) {
 		pr_err("cannot get array status for %s\n", devname);
 		return 1;
 	}
 	if (array.state & (1 << MD_SB_BITMAP_PRESENT)) {
-		if (str_is_none(s->bitmap_file) == true) {
+		if (s->btype == BitmapNone) {
 			array.state &= ~(1 << MD_SB_BITMAP_PRESENT);
 			if (md_set_array_info(fd, &array) != 0) {
 				if (array.state & (1 << MD_SB_CLUSTERED))
@@ -342,10 +322,11 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 		return 1;
 	}
 
-	if (str_is_none(s->bitmap_file) == true) {
+	if (s->btype == BitmapNone) {
 		pr_err("no bitmap found on %s\n", devname);
 		return 1;
 	}
+
 	if (array.level <= 0) {
 		pr_err("Bitmaps not meaningful with level %s\n",
 			map_num(pers, array.level)?:"of this array");
@@ -371,7 +352,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 		ncopies = (array.layout & 255) * ((array.layout >> 8) & 255);
 		bitmapsize = bitmapsize * array.raid_disks / ncopies;
 
-		if (strcmp(s->bitmap_file, "clustered") == 0 &&
+		if (s->btype == BitmapCluster &&
 		    !is_near_layout_10(array.layout)) {
 			pr_err("only near layout is supported with clustered raid10\n");
 			return 1;
@@ -402,8 +383,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 		free(mdi);
 	}
 
-	if (strcmp(s->bitmap_file, "internal") == 0 ||
-	    strcmp(s->bitmap_file, "clustered") == 0) {
+	if (s->btype == BitmapInternal || s->btype == BitmapCluster) {
 		int rv;
 		int d;
 		int offset_setable = 0;
@@ -432,7 +412,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 			if (!dv)
 				continue;
 			if ((disk.state & (1 << MD_DISK_WRITEMOSTLY)) &&
-			   (strcmp(s->bitmap_file, "clustered") == 0)) {
+			    s->btype == BitmapCluster) {
 				pr_err("%s disks marked write-mostly are not supported with clustered bitmap\n",devname);
 				free(mdi);
 				return 1;
@@ -471,7 +451,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 						  mdi->bitmap_offset);
 			free(mdi);
 		} else {
-			if (strcmp(s->bitmap_file, "clustered") == 0)
+			if (s->btype == BitmapCluster)
 				array.state |= (1 << MD_SB_CLUSTERED);
 			array.state |= (1 << MD_SB_BITMAP_PRESENT);
 			rv = md_set_array_info(fd, &array);
@@ -482,60 +462,6 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 			pr_err("failed to set internal bitmap.\n");
 			return 1;
 		}
-	} else {
-		int uuid[4];
-		int bitmap_fd;
-		int d;
-		int max_devs = st->max_devs;
-
-		/* try to load a superblock */
-		for (d = 0; d < max_devs; d++) {
-			mdu_disk_info_t disk;
-			char *dv;
-			int fd2;
-			disk.number = d;
-			if (md_get_disk_info(fd, &disk) < 0)
-				continue;
-			if ((disk.major==0 && disk.minor == 0) ||
-			    (disk.state & (1 << MD_DISK_REMOVED)))
-				continue;
-			dv = map_dev(disk.major, disk.minor, 1);
-			if (!dv)
-				continue;
-			fd2 = dev_open(dv, O_RDONLY);
-			if (fd2 >= 0) {
-				if (st->ss->load_super(st, fd2, NULL) == 0) {
-					close(fd2);
-					st->ss->uuid_from_super(st, uuid);
-					break;
-				}
-				close(fd2);
-			}
-		}
-		if (d == max_devs) {
-			pr_err("cannot find UUID for array!\n");
-			return 1;
-		}
-		if (CreateBitmap(s->bitmap_file, c->force, (char*)uuid,
-				 s->bitmap_chunk, c->delay, s->write_behind,
-				 bitmapsize, major)) {
-			return 1;
-		}
-		bitmap_fd = open(s->bitmap_file, O_RDWR);
-		if (bitmap_fd < 0) {
-			pr_err("weird: %s cannot be opened\n", s->bitmap_file);
-			return 1;
-		}
-		if (ioctl(fd, SET_BITMAP_FILE, bitmap_fd) < 0) {
-			int err = errno;
-			if (errno == EBUSY)
-				pr_err("Cannot add bitmap while array is resyncing or reshaping etc.\n");
-			pr_err("Cannot set bitmap file for %s: %s\n",
-				devname, strerror(err));
-			close_fd(&bitmap_fd);
-			return 1;
-		}
-		close_fd(&bitmap_fd);
 	}
 
 	return 0;
diff --git a/Incremental.c b/Incremental.c
index 5e59b6d1..aa5db3bf 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -544,21 +544,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 			cont_err("by --incremental.  Please use --assemble\n");
 			goto out;
 		}
-		if (match && match->bitmap_file) {
-			int bmfd = open(match->bitmap_file, O_RDWR);
-			if (bmfd < 0) {
-				pr_err("Could not open bitmap file %s.\n",
-				       match->bitmap_file);
-				goto out;
-			}
-			if (ioctl(mdfd, SET_BITMAP_FILE, bmfd) != 0) {
-				close(bmfd);
-				pr_err("Failed to set bitmapfile for %s.\n",
-				       chosen_name);
-				goto out;
-			}
-			close(bmfd);
-		}
+
 		/* Need to remove from the array any devices which
 		 * 'count_active' discerned were too old or inappropriate
 		 */
@@ -1400,28 +1386,7 @@ restart:
 			if (mddev->devname && me->path &&
 			    devname_matches(mddev->devname, me->path))
 				break;
-		if (mddev && mddev->bitmap_file) {
-			/*
-			 * Note: early kernels will wrongly fail this, so it
-			 * is a hint only
-			 */
-			int added = -1;
-			int bmfd;
 
-			bmfd = open(mddev->bitmap_file, O_RDWR);
-			if (is_fd_valid(bmfd)) {
-				added = ioctl(mdfd, SET_BITMAP_FILE, bmfd);
-				close_fd(&bmfd);
-			}
-			if (c->verbose >= 0) {
-				if (added == 0)
-					pr_err("Added bitmap %s to %s\n",
-					       mddev->bitmap_file, me->path);
-				else if (errno != EEXIST)
-					pr_err("Failed to add bitmap to %s: %s\n",
-					       me->path, strerror(errno));
-			}
-		}
 		/* FIXME check for reshape_active and consider not
 		 * starting array.
 		 */
diff --git a/bitmap.c b/bitmap.c
index 5110ae2f..c62d18d4 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -200,28 +200,32 @@ bitmap_file_open(char *filename, struct supertype **stp, int node_num, int fd)
 		close(fd);
 		return -1;
 	}
-	if ((stb.st_mode & S_IFMT) == S_IFBLK) {
-		/* block device, so we are probably after an internal bitmap */
-		if (!st)
-			st = guess_super(fd);
-		if (!st) {
-			/* just look at device... */
-			lseek(fd, 0, 0);
-		} else if (!st->ss->locate_bitmap) {
-			pr_err("No bitmap possible with %s metadata\n",
-				st->ss->name);
-			close(fd);
-			return -1;
-		} else {
-			if (st->ss->locate_bitmap(st, fd, node_num)) {
-				pr_err("%s doesn't have bitmap\n", filename);
-				close(fd);
-				fd = -1;
-			}
-		}
-		*stp = st;
+
+	if ((stb.st_mode & S_IFMT) != S_IFBLK) {
+		pr_err("bitmap file is not supported %s\n", filename);
+		close(fd);
+		return -1;
+	}
+
+	if (!st)
+		st = guess_super(fd);
+
+	if (!st) {
+		/* just look at device... */
+		lseek(fd, 0, 0);
+	} else if (!st->ss->locate_bitmap) {
+		pr_err("No bitmap possible with %s metadata\n", st->ss->name);
+		close(fd);
+		return -1;
+	}
+
+	if (st->ss->locate_bitmap(st, fd, node_num)) {
+		pr_err("%s doesn't have bitmap\n", filename);
+		close(fd);
+		fd = -1;
 	}
 
+	*stp = st;
 	return fd;
 }
 
diff --git a/config.c b/config.c
index 3359504d..8a8ae5e4 100644
--- a/config.c
+++ b/config.c
@@ -171,8 +171,7 @@ inline void ident_init(struct mddev_ident *ident)
 	assert(ident);
 
 	ident->assembled = false;
-	ident->bitmap_fd = -1;
-	ident->bitmap_file = NULL;
+	ident->btype = BitmapUnknown;
 	ident->container = NULL;
 	ident->devices = NULL;
 	ident->devname = NULL;
@@ -542,11 +541,19 @@ void arrayline(char *line)
 			/* Ignore name in confile */
 			continue;
 		} else if (strncasecmp(w, "bitmap=", 7) == 0) {
-			if (mis.bitmap_file)
+			if (mis.btype != BitmapUnknown)
 				pr_err("only specify bitmap file once. %s ignored\n",
 					w);
-			else
-				mis.bitmap_file = xstrdup(w + 7);
+			else {
+				char *bname = xstrdup(w + 7);
+
+				if (strcmp(bname, STR_COMMON_NONE) == 0)
+					mis.btype = BitmapNone;
+				else if (strcmp(bname, "internal") == 0)
+					mis.btype = BitmapInternal;
+				else if (strcmp(bname, "clustered") == 0)
+					mis.btype = BitmapCluster;
+			}
 
 		} else if (strncasecmp(w, "devices=", 8 ) == 0) {
 			if (mis.devices)
diff --git a/mdadm.c b/mdadm.c
index b7bcb336..7d3b656b 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -41,18 +41,23 @@
  */
 static mdadm_status_t set_bitmap_value(struct shape *s, struct context *c, char *val)
 {
-	if (s->bitmap_file) {
+	if (s->btype != BitmapUnknown) {
 		pr_err("--bitmap cannot be set twice. Second value: \"%s\".\n", val);
 		return MDADM_STATUS_ERROR;
 	}
 
-	if (strcmp(val, "internal") == 0 || strcmp(optarg, STR_COMMON_NONE) == 0) {
-		s->bitmap_file = val;
+	if (strcmp(optarg, STR_COMMON_NONE) == 0) {
+		s->btype = BitmapNone;
+		return MDADM_STATUS_SUCCESS;
+	}
+
+	if (strcmp(val, "internal") == 0) {
+		s->btype = BitmapInternal;
 		return MDADM_STATUS_SUCCESS;
 	}
 
 	if (strcmp(val, "clustered") == 0) {
-		s->bitmap_file = val;
+		s->btype = BitmapCluster;
 		/* Set the default number of cluster nodes
 		 * to 4 if not already set by user
 		 */
@@ -62,17 +67,12 @@ static mdadm_status_t set_bitmap_value(struct shape *s, struct context *c, char
 	}
 
 	if (strchr(val, '/')) {
-		pr_info("Custom write-intent bitmap file option is deprecated.\n");
-		if (ask("Do you want to continue? (y/n)")) {
-			s->bitmap_file = val;
-			return MDADM_STATUS_SUCCESS;
-		}
-
+		pr_err("Custom write-intent bitmap file option is not supported.\n");
 		return MDADM_STATUS_ERROR;
 	}
 
-	pr_err("--bitmap value must contain a '/' or be 'internal', 'clustered' or 'none'\n");
-	pr_err("Current value is \"%s\"", val);
+	pr_err("--bitmap value must be 'internal', 'clustered' or 'none'\n");
+	pr_err("Current value is \"%s\"\n", val);
 	return MDADM_STATUS_ERROR;
 }
 
@@ -99,7 +99,6 @@ int main(int argc, char *argv[])
 	struct mddev_ident ident;
 	char *configfile = NULL;
 	int devmode = 0;
-	int bitmap_fd = -1;
 	struct mddev_dev *devlist = NULL;
 	struct mddev_dev **devlistend = & devlist;
 	struct mddev_dev *dv;
@@ -116,6 +115,7 @@ int main(int argc, char *argv[])
 		.bitmap_chunk	= UnSet,
 		.consistency_policy	= CONSISTENCY_POLICY_UNKNOWN,
 		.data_offset = INVALID_SECTORS,
+		.btype		= BitmapUnknown,
 	};
 
 	char sys_hostname[256];
@@ -1089,24 +1089,15 @@ int main(int argc, char *argv[])
 
 		case O(ASSEMBLE,'b'): /* here we simply set the bitmap file */
 		case O(ASSEMBLE,Bitmap):
-			if (!optarg) {
-				pr_err("bitmap file needed with -b in --assemble mode\n");
-				exit(2);
-			}
-			if (strcmp(optarg, "internal") == 0 ||
-			    strcmp(optarg, "clustered") == 0) {
+			if (optarg && (strcmp(optarg, "internal") == 0 ||
+				       strcmp(optarg, "clustered")) == 0) {
 				pr_err("no need to specify --bitmap when assembling"
 					" arrays with internal or clustered bitmap\n");
 				continue;
 			}
-			bitmap_fd = open(optarg, O_RDWR);
-			if (!*optarg || bitmap_fd < 0) {
-				pr_err("cannot open bitmap file %s: %s\n", optarg, strerror(errno));
-				exit(2);
-			}
-			ident.bitmap_fd = bitmap_fd; /* for Assemble */
-			continue;
 
+			pr_err("bitmap file is not supported %s\n", optarg);
+			exit(2);
 		case O(ASSEMBLE, BackupFile):
 		case O(GROW, BackupFile):
 			/* Specify a file into which grow might place a backup,
@@ -1256,12 +1247,11 @@ int main(int argc, char *argv[])
 			pr_err("PPL consistency policy is only supported for RAID level 5.\n");
 			exit(2);
 		} else if (s.consistency_policy == CONSISTENCY_POLICY_BITMAP &&
-			  (!s.bitmap_file || str_is_none(s.bitmap_file) == true)) {
+			   s.btype == BitmapNone) {
 			pr_err("--bitmap is required for consistency policy: %s\n",
 			       map_num_s(consistency_policies, s.consistency_policy));
 			exit(2);
-		} else if (s.bitmap_file &&
-			   str_is_none(s.bitmap_file) == false &&
+		} else if ((s.btype == BitmapInternal || s.btype == BitmapCluster) &&
 			   s.consistency_policy != CONSISTENCY_POLICY_BITMAP &&
 			   s.consistency_policy != CONSISTENCY_POLICY_JOURNAL) {
 			pr_err("--bitmap is not compatible with consistency policy: %s\n",
@@ -1394,7 +1384,7 @@ int main(int argc, char *argv[])
 		c.brief = 1;
 
 	if (mode == CREATE) {
-		if (s.bitmap_file && strcmp(s.bitmap_file, "clustered") == 0) {
+		if (s.btype == BitmapCluster) {
 			locked = cluster_get_dlmlock();
 			if (locked != 1)
 				exit(1);
@@ -1479,7 +1469,17 @@ int main(int argc, char *argv[])
 	case BUILD:
 		if (c.delay == 0)
 			c.delay = DEFAULT_BITMAP_DELAY;
-		if (s.write_behind && !s.bitmap_file) {
+
+		if (s.btype == BitmapUnknown)
+			s.btype = BitmapNone;
+
+		if (s.btype != BitmapNone) {
+			pr_err("--build argument only compatible with --bitmap=none\n");
+			rv |= 1;
+			break;
+		}
+
+		if (s.write_behind) {
 			pr_err("write-behind mode requires a bitmap.\n");
 			rv = 1;
 			break;
@@ -1490,14 +1490,6 @@ int main(int argc, char *argv[])
 			break;
 		}
 
-		if (s.bitmap_file) {
-			if (strcmp(s.bitmap_file, "internal") == 0 ||
-			    strcmp(s.bitmap_file, "clustered") == 0) {
-				pr_err("'internal' and 'clustered' bitmaps not supported with --build\n");
-				rv |= 1;
-				break;
-			}
-		}
 		rv = Build(&ident, devlist->next, &s, &c);
 		break;
 	case CREATE:
@@ -1505,8 +1497,7 @@ int main(int argc, char *argv[])
 			c.delay = DEFAULT_BITMAP_DELAY;
 
 		if (c.nodes) {
-			if (!s.bitmap_file ||
-			    strcmp(s.bitmap_file, "clustered") != 0) {
+			if (s.btype != BitmapCluster) {
 				pr_err("--nodes argument only compatible with --bitmap=clustered\n");
 				rv = 1;
 				break;
@@ -1524,7 +1515,7 @@ int main(int argc, char *argv[])
 			}
 		}
 
-		if (s.write_behind && !s.bitmap_file) {
+		if (s.write_behind && s.btype == BitmapNone) {
 			pr_err("write-behind mode requires a bitmap.\n");
 			rv = 1;
 			break;
@@ -1535,12 +1526,12 @@ int main(int argc, char *argv[])
 			break;
 		}
 
-		if (!s.bitmap_file) {
+		if (s.btype == BitmapUnknown) {
 			if (c.runstop != 1 && s.level >= 1 &&
 			    ask("To optimalize recovery speed, it is recommended to enable write-indent bitmap, do you want to enable it now?"))
-				s.bitmap_file = "internal";
+				s.btype = BitmapInternal;
 			else
-				s.bitmap_file = "none";
+				s.btype = BitmapNone;
 		}
 
 		rv = Create(ss, &ident, devs_found - 1, devlist->next, &s, &c);
@@ -1634,7 +1625,7 @@ int main(int argc, char *argv[])
 		if (devs_found > 1 && s.raiddisks == 0 && s.level == UnSet) {
 			/* must be '-a'. */
 			if (s.size > 0 || s.chunk ||
-			    s.layout_str || s.bitmap_file) {
+			    s.layout_str || s.btype != BitmapNone) {
 				pr_err("--add cannot be used with other geometry changes in --grow mode\n");
 				rv = 1;
 				break;
@@ -1644,7 +1635,7 @@ int main(int argc, char *argv[])
 				if (rv)
 					break;
 			}
-		} else if (s.bitmap_file) {
+		} else if (s.btype != BitmapUnknown) {
 			if (s.size > 0 || s.raiddisks || s.chunk ||
 			    s.layout_str || devs_found > 1) {
 				pr_err("--bitmap changes cannot be used with other geometry changes in --grow mode\n");
diff --git a/mdadm.h b/mdadm.h
index 5aa50854..af54a6ab 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -598,9 +598,16 @@ enum prefix_standard {
 };
 
 enum bitmap_update {
-    NoUpdate,
-    NameUpdate,
-    NodeNumUpdate,
+	NoUpdate,
+	NameUpdate,
+	NodeNumUpdate,
+};
+
+enum bitmap_type {
+	BitmapNone,
+	BitmapInternal,
+	BitmapCluster,
+	BitmapUnknown,
 };
 
 enum flag_mode {
@@ -640,8 +647,7 @@ struct mddev_ident {
 	int spare_disks;
 	struct supertype *st;
 	char	*spare_group;
-	char	*bitmap_file;
-	int	bitmap_fd;
+	enum bitmap_type btype;
 
 	char	*container;	/* /dev/whatever name of container, or
 				 * uuid of container.  You would expect
@@ -693,7 +699,7 @@ struct shape {
 	char	*layout_str;
 	int	chunk;
 	int	bitmap_chunk;
-	char	*bitmap_file;
+	enum bitmap_type btype;
 	int	assume_clean;
 	bool	write_zeroes;
 	int	write_behind;
-- 
2.39.2

