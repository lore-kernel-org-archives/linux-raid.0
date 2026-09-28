Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED434F392F
	for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2026 21:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790630692; cv=none; b=dBw3REEXDADvWvS6I2GtcWYOIVlj/hLtaef33DvLtHbFtilXIFqmo1B85qQ2GE5KlrmixVVBY/yjihZFojZ/H/Ksuf7lvsRxNoq+06JdtGdlbb9CLO940IjpCUycjl+kUX8+7RLLHuIP/qDhNSdu4LA8VaDuMJ6IcCRDw6PHg+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790630692; c=relaxed/simple;
	bh=E8dtKT7T0zgT4tlhOlHlDyL2u8zm+JQRF+achHb3NF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXx/MSgVwEUI0FY73/fPscpcpSwYja1ACZJE8jA5c0QPvXiKdUAua78ang3QyePt0WLylftG1IfmxJV5uVzDf8vKLRVGcdNjLdKH416Qb6fHI3z+wkS1mnajhby2AbuciDx/qJFrhQJAVW8u5XSmY45NvHjnaV1ZzofblPyO+1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fWaU7HCP; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fWaU7HCP"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-488780459e2so3424081f8f.2
        for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2026 14:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790630679; x=1791235479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a9AreVMfRlIIzUlMLuV9vXXOXb08C+6/2Zq6D1+es7w=;
        b=fWaU7HCPQAN6vZzU2mP40drVPYUfJO2xQ/lDsnfYMfvg8qcsofpJiOzXRwNoU8QwZy
         nTtrSm1s3Be1SPhp5431Lzrigsdp5lcKtv3KfBuNhIspFPAzOd+EETJ5w5/NvYTAX0S/
         mG0eHmMdZH6XdbvBsWi8Eq9Dv4b2VzB+58thM1RhQ6jYL0NfPLYNNmzfGyHS/oHrHGl1
         ZL3Ka+e5FsB8qL+OjOCEnbCloQH/XN6MRAJA2nfXw2hVKdol7aiqlFZswKga1qKsPH4+
         2weSGuzfjz1XxBrSDv6m5HKfhaJPclmSIyJSbitwVfyDHbPbBv0DYHeZvzeVQLVe74Ju
         8asA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790630679; x=1791235479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=a9AreVMfRlIIzUlMLuV9vXXOXb08C+6/2Zq6D1+es7w=;
        b=mM2tLZH3XxLjgWG7sEs63HMNlqX70GRYPFnOHx07X80ezMGq86sabdFhIAMMOIDo8c
         KLdCom9kB6ACMj0m5b10K2HwZfTN4dTd6sAhSa9r88Gb5uhNqP4DuRQ3fhtM0cRuLGi1
         btePCtMuJD6m4Ts+fNKiaSScGLPF0f7VvgisW72nYTo0Cip0hVVnSIJzpsRzTRtF24d9
         ElXNM6ZnJSJJUiK1KwjYz9mF5kuq2JM6HeOrypQs1/Bnbqjs78FdtwyS3yEBxAoJq1Vj
         wXg+7LiT/eCK70EMT/hw0OtyUDuPYQhyyYFtMOzRs0i6+li4t9lMVRinbqQNNCcOswlE
         QVsQ==
X-Gm-Message-State: AFq9FYJaRSGtMM8Ib4WVjXz7uc7z0KH9AosFuplGRdOfReW2YyhTcyV3
	ZTwtOySi7lQKMNiBPXWy9xsviG28OSPbci2LuaPbStA9LOudXgL2LfaN
X-Gm-Gg: AYBFou3mSUP4GD1aiEBGkDX9g7cmclioL5XHfwFbW6n1YR5l+Op5gmv1WYr5SEctffh
	CJvhWwlDDzbT1gBR5yBgMRi3z+St/4stkKGFB1vHaemLIfqMcAhLHgkIYUVJzCLWU/XYu3J30R8
	GPU1gLm8RXnovUZHohKbOTTv6v5gRY2keFzIcUGLAfBSggIYJBe0ggk/p+fy+DVK9aEecKP253x
	UxWfpYhS7jwFq3yEPNlitKNbuYXUEU9O61OqFKMXkbMrJr8WaXC+qiydRLxkrVt0WyTLL2O3/Qm
	3IzfsK3h9OT8h6TH3syIlH4NZXZG2vDSae2LuwY0e+C+UPlYL3psDuJ4Z5qn70cHkcHRP6My3N5
	KPuczuhIdBUdcJ2ZBqUp4oCYnaxT/FwL3lIe+6jwAcN55m+XxQvJUHujhO6VLz0h+3ZWMAPtlme
	HL8NR602Pf2slom5vo1U17VoJT7wezNQ8/xkz+EiY11yuSrqrjnpEfUELa+8u6YL4QKKQUgx/Gn
	MGgkrzqndQUXdZ1sr/QxdHcpJwA7xdUh5KTUfcO5TCJviY=
X-Received: by 2002:a5d:5f06:0:b0:488:8b97:3cc1 with SMTP id ffacd0b85a97d-4888b973ff7mr10688190f8f.6.1790630679050;
        Mon, 28 Sep 2026 14:24:39 -0700 (PDT)
Received: from env.. (dynamic-176-003-100-011.176.3.pool.telefonica.de. [176.3.100.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a34a314sm30869895f8f.6.2026.09.28.14.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 14:24:38 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: yukuai@fygo.io,
	chengzhihao1@huawei.com,
	blazej.kucman@graidtech.com,
	mtkaczyk@kernel.org,
	ncroxon@redhat.com,
	xni@redhat.com,
	song@kernel.org
Cc: linux-raid@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH 2/2] mdadm: switch management ioctls to md_ioctl()
Date: Mon, 28 Sep 2026 21:18:49 +0000
Message-ID: <20260928211849.3602414-3-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260928211849.3602414-1-abd.masalkhi@gmail.com>
References: <20260928211849.3602414-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use md_ioctl() for md management ioctls so that mdadm uses the new
/dev/md-control interface.

The control device uses new 64-bit structures, including mdu_ioctl,
mdu_array_info64, mdu_disk_info64, mdu_param64, mdu_bitmap_file64,
and mdu_version64.

Suggested-by: Yu Kuai <yukuai@fygo.io>
Suggested-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 Assemble.c    |  4 ++--
 Build.c       | 12 ++++++------
 Create.c      | 19 ++++++++++---------
 Detail.c      | 22 +++++++++++-----------
 Grow.c        | 30 +++++++++++++++---------------
 Incremental.c |  6 +++---
 Manage.c      | 44 ++++++++++++++++++++++----------------------
 Query.c       |  4 ++--
 managemon.c   |  4 ++--
 mdadm.c       |  2 +-
 mdadm.h       | 16 ++++++++--------
 mdmonitor.c   |  8 ++++----
 super-ddf.c   | 22 +++++++++++-----------
 super-intel.c | 14 +++++++-------
 super0.c      |  6 +++---
 super1.c      |  6 +++---
 util.c        | 29 +++++++++++++++--------------
 17 files changed, 125 insertions(+), 123 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index a56186f4..8dfa3e1d 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1183,7 +1183,7 @@ static int start_array(int mdfd,
 			rv = sysfs_set_str(content, NULL,
 					   "array_state", "readonly");
 		} else
-			rv = ioctl(mdfd, RUN_ARRAY, NULL);
+			rv = md_ioctl(mdfd, MD_RUN_ARRAY);
 		reopen_mddev(mdfd); /* drop O_EXCL */
 		if (rv == 0) {
 			sysfs_rules_apply(mddev, content, st);
@@ -1910,7 +1910,7 @@ try_again:
 			 pre_exist != NULL,
 			 was_forced);
 	if (rv == 1 && !pre_exist)
-		ioctl(mdfd, STOP_ARRAY, NULL);
+		md_ioctl(mdfd, MD_STOP_ARRAY);
 	free(devices);
 	free(avail);
 out:
diff --git a/Build.c b/Build.c
index 3e0e5900..1e375365 100644
--- a/Build.c
+++ b/Build.c
@@ -45,8 +45,8 @@ int Build(struct mddev_ident *ident, struct mddev_dev *devlist, struct shape *s,
 	char chosen_name[1024];
 	int uuid[4] = {0,0,0,0};
 	struct map_ent *map = NULL;
-	mdu_array_info_t array;
-	mdu_param_t param; /* not used by syscall */
+	struct mdu_array_info64 array = {0};
+	struct mdu_param64 param = {0}; /* not used by syscall */
 
 	if (s->level == UnSet) {
 		pr_err("a RAID level is needed to Build an array.\n");
@@ -115,7 +115,7 @@ int Build(struct mddev_ident *ident, struct mddev_dev *devlist, struct shape *s,
 
 	/* now add the devices */
 	for ((i=0), (dv = devlist) ; dv ; i++, dv=dv->next) {
-		mdu_disk_info_t disk;
+		struct mdu_disk_info64 disk = {0};
 		unsigned long long dsize;
 		int fd;
 
@@ -140,14 +140,14 @@ int Build(struct mddev_ident *ident, struct mddev_dev *devlist, struct shape *s,
 			disk.state |= 1<<MD_DISK_WRITEMOSTLY;
 		disk.major = major(rdev);
 		disk.minor = minor(rdev);
-		if (ioctl(mdfd, ADD_NEW_DISK, &disk)) {
+		if (md_ioctl(mdfd, MD_ADD_NEW_DISK, &disk)) {
 			pr_err("ADD_NEW_DISK failed for %s: %s\n",
 			       dv->devname, strerror(errno));
 			goto abort;
 		}
 	}
 
-	if (ioctl(mdfd, RUN_ARRAY, &param)) {
+	if (md_ioctl(mdfd, MD_RUN_ARRAY, &param)) {
 		pr_err("RUN_ARRAY failed: %s\n", strerror(errno));
 		if (s->chunk & (s->chunk - 1)) {
 			cont_err("Problem may be that chunk size is not a power of 2\n");
@@ -162,7 +162,7 @@ int Build(struct mddev_ident *ident, struct mddev_dev *devlist, struct shape *s,
 	return 0;
 
  abort:
-	ioctl(mdfd, STOP_ARRAY, 0);
+	md_ioctl(mdfd, MD_STOP_ARRAY, 0);
 	close(mdfd);
 	return 1;
 }
diff --git a/Create.c b/Create.c
index 85c23d83..c411ff25 100644
--- a/Create.c
+++ b/Create.c
@@ -297,7 +297,7 @@ static int add_disk_to_super(int mdfd, struct shape *s, struct context *c,
 		remove_partitions(fd);
 	if (st->ss->add_to_super(st, &info->disk, fd, dv->devname,
 				 dv->data_offset)) {
-		ioctl(mdfd, STOP_ARRAY, NULL);
+		md_ioctl(mdfd, MD_STOP_ARRAY);
 		close_fd(&fd);
 		return 1;
 	}
@@ -306,7 +306,7 @@ static int add_disk_to_super(int mdfd, struct shape *s, struct context *c,
 	if (fd >= 0 && s->write_zeroes) {
 		*zero_pid = write_zeroes_fork(fd, s, st, dv);
 		if (*zero_pid <= 0) {
-			ioctl(mdfd, STOP_ARRAY, NULL);
+			md_ioctl(mdfd, MD_STOP_ARRAY);
 			close(fd);
 			return 1;
 		}
@@ -531,7 +531,7 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 	char chosen_name[1024];
 	struct map_ent *map = NULL;
 	unsigned long long newsize;
-	mdu_array_info_t inf;
+	struct mdu_array_info64 inf;
 	int major_num = BITMAP_MAJOR_HI;
 
 	if (s->btype == BitmapCluster) {
@@ -1274,7 +1274,7 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 			sysfs_set_safemode(&info, info.safe_mode_delay);
 			if (err) {
 				pr_err("failed to activate array.\n");
-				ioctl(mdfd, STOP_ARRAY, NULL);
+				md_ioctl(mdfd, MD_STOP_ARRAY);
 				goto abort;
 			}
 		} else if (c->readonly &&
@@ -1284,7 +1284,7 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 					  "array_state", "readonly") < 0) {
 				pr_err("Failed to start array: %s\n",
 				       strerror(errno));
-				ioctl(mdfd, STOP_ARRAY, NULL);
+				md_ioctl(mdfd, MD_STOP_ARRAY);
 				goto abort;
 			}
 		} else {
@@ -1297,8 +1297,9 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 			}
 
 			/* param is not actually used */
-			mdu_param_t param;
-			if (ioctl(mdfd, RUN_ARRAY, &param)) {
+			struct mdu_param64 param = {0};
+
+			if (md_ioctl(mdfd, MD_RUN_ARRAY, &param)) {
 				pr_err("RUN_ARRAY failed: %s\n",
 				       strerror(errno));
 				if (errno == 524 /* ENOTSUP */ &&
@@ -1307,14 +1308,14 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 				if (info.array.chunk_size & (info.array.chunk_size-1)) {
 					cont_err("Problem may be that chunk size is not a power of 2\n");
 				}
-				ioctl(mdfd, STOP_ARRAY, NULL);
+				md_ioctl(mdfd, MD_STOP_ARRAY);
 				goto abort;
 			}
 			/* if start_ro module parameter is set, array is
 			 * auto-read-only, which is bad as the resync won't
 			 * start.  So lets make it read-write now.
 			 */
-			ioctl(mdfd, RESTART_ARRAY_RW, NULL);
+			md_ioctl(mdfd, MD_RESTART_ARRAY_RW);
 		}
 		if (c->verbose >= 0)
 			pr_info("array %s started.\n", chosen_name);
diff --git a/Detail.c b/Detail.c
index 7daec982..7790be7a 100644
--- a/Detail.c
+++ b/Detail.c
@@ -81,8 +81,8 @@ int Detail(char *dev, struct context *c)
 	 * Print out details for an md array
 	 */
 	int fd = open(dev, O_RDONLY);
-	mdu_array_info_t array;
-	mdu_disk_info_t *disks = NULL;
+	struct mdu_array_info64 array = {0};
+	struct mdu_disk_info64 *disks = NULL;
 	int next;
 	int d;
 	time_t atime;
@@ -175,7 +175,7 @@ int Detail(char *dev, struct context *c)
 		for (d = 0, subdev = sra ? sra->devs : NULL;
 		     d < max_disks || subdev;
 		     subdev ? (void)(subdev = subdev->next) : (void)(d++)){
-		mdu_disk_info_t disk;
+		struct mdu_disk_info64 disk = {0};
 		char *dv;
 		int fd2;
 		int err;
@@ -324,7 +324,7 @@ int Detail(char *dev, struct context *c)
 		goto out;
 	}
 
-	disks = xmalloc(max_disks * 2 * sizeof(mdu_disk_info_t));
+	disks = xmalloc(max_disks * 2 * sizeof(struct mdu_disk_info64));
 	for (d = 0; d < max_disks * 2; d++) {
 		disks[d].state = (1 << MD_DISK_REMOVED);
 		disks[d].major = disks[d].minor = 0;
@@ -340,7 +340,7 @@ int Detail(char *dev, struct context *c)
 			disks[next - 1].number = -1;
 		}
 	} else for (d = 0; d < max_disks; d++) {
-		mdu_disk_info_t disk;
+		struct mdu_disk_info64 disk = {0};
 		disk.number = d;
 		if (md_get_disk_info(fd, &disk) < 0) {
 			if (d < array.raid_disks)
@@ -382,7 +382,7 @@ int Detail(char *dev, struct context *c)
 	}
 
 	if (c->brief) {
-		mdu_bitmap_file_t bmf;
+		struct mdu_bitmap_file64 bmf;
 		if (inactive && !is_container)
 			printf("INACTIVE-ARRAY %s", dev);
 		else
@@ -410,11 +410,11 @@ int Detail(char *dev, struct context *c)
 		}
 
 		/* Only try GET_BITMAP_FILE for 0.90.01 and later */
-		if (ioctl(fd, GET_BITMAP_FILE, &bmf) == 0 && bmf.pathname[0]) {
+		if (md_ioctl(fd, MD_GET_BITMAP_FILE, &bmf) == 0 && bmf.pathname[0]) {
 			printf(" bitmap=%s", bmf.pathname);
 		}
 	} else {
-		mdu_bitmap_file_t bmf;
+		struct mdu_bitmap_file64 bmf;
 		unsigned long long larray_size;
 		struct mdstat_ent *ms = mdstat_read(0, 0);
 		struct mdstat_ent *e;
@@ -485,7 +485,7 @@ int Detail(char *dev, struct context *c)
 			       array.not_persistent ? "not " : "");
 		printf("\n");
 		/* Only try GET_BITMAP_FILE for 0.90.01 and later */
-		if (ioctl(fd, GET_BITMAP_FILE, &bmf) == 0 && bmf.pathname[0]) {
+		if (md_ioctl(fd, MD_GET_BITMAP_FILE, &bmf) == 0 && bmf.pathname[0]) {
 			printf("     Intent Bitmap : %s\n", bmf.pathname);
 			printf("\n");
 		} else if (array.state & (1<<MD_SB_CLUSTERED))
@@ -520,7 +520,7 @@ int Detail(char *dev, struct context *c)
 				if (array.state & (1<<MD_SB_CLUSTERED)) {
 					for (d = 0; d < max_disks * 2; d++) {
 						char *dv;
-						mdu_disk_info_t disk = disks[d];
+						struct mdu_disk_info64 disk = disks[d];
 
 						/* only check first valid disk in cluster env */
 						if ((disk.state & (MD_DISK_SYNC | MD_DISK_ACTIVE))
@@ -715,7 +715,7 @@ int Detail(char *dev, struct context *c)
 
 	for (d = 0; d < max_disks * 2; d++) {
 		char *dv;
-		mdu_disk_info_t disk = disks[d];
+		struct mdu_disk_info64 disk = disks[d];
 
 		if (d >= array.raid_disks * 2 &&
 		    disk.major == 0 && disk.minor == 0)
diff --git a/Grow.c b/Grow.c
index f3f746f0..f8b52758 100644
--- a/Grow.c
+++ b/Grow.c
@@ -149,7 +149,7 @@ int Grow_Add_device(char *devname, int fd, char *newdev)
 	/* now check out all the devices and make sure we can read the
 	 * superblock */
 	for (d=0 ; d < info.array.raid_disks ; d++) {
-		mdu_disk_info_t disk;
+		struct mdu_disk_info64 disk = {0};
 		char *dv;
 
 		st->ss->free_super(st);
@@ -208,7 +208,7 @@ int Grow_Add_device(char *devname, int fd, char *newdev)
 	}
 	close(nfd);
 
-	if (ioctl(fd, ADD_NEW_DISK, &info.disk) != 0) {
+	if (md_ioctl(fd, MD_ADD_NEW_DISK, &info.disk) != 0) {
 		pr_err("Cannot add new disk to this array\n");
 		return 1;
 	}
@@ -223,7 +223,7 @@ int Grow_Add_device(char *devname, int fd, char *newdev)
 
 	nd = d;
 	for (d=0 ; d < info.array.raid_disks ; d++) {
-		mdu_disk_info_t disk;
+		struct mdu_disk_info64 disk = {0};
 		char *dv;
 
 		disk.number = d;
@@ -281,7 +281,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 	 * find all the active devices, and write the bitmap block
 	 * to all devices
 	 */
-	mdu_array_info_t array;
+	struct mdu_array_info64 array = {0};
 	struct supertype *st;
 	char *subarray = NULL;
 	int major = BITMAP_MAJOR_HI;
@@ -394,7 +394,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 		if (mdi)
 			offset_setable = 1;
 		for (d = 0; d < st->max_devs; d++) {
-			mdu_disk_info_t disk;
+			struct mdu_disk_info64 disk = {0};
 			char *dv;
 			int fd2;
 
@@ -1831,7 +1831,7 @@ int Grow_reshape(char *devname, int fd,
 	 * reshape (e.g. raid6->raid5, raid5->raid0)
 	 *
 	 */
-	struct mdu_array_info_s array;
+	struct mdu_array_info64 array;
 	int rv = 0;
 	struct supertype *st;
 	char *subarray = NULL;
@@ -2824,7 +2824,7 @@ static int impose_reshape(struct mdinfo *sra,
 			  char *devname, char *container,
 			  struct reshape *reshape)
 {
-	struct mdu_array_info_s array;
+	struct mdu_array_info64 array;
 
 	sra->new_chunk = info->new_chunk;
 
@@ -2903,7 +2903,7 @@ release:
 static int impose_level(int fd, int level, char *devname, int verbose)
 {
 	char *c;
-	struct mdu_array_info_s array;
+	struct mdu_array_info64 array;
 	struct mdinfo info;
 
 	if (sysfs_init(&info, fd, NULL)) {
@@ -2928,7 +2928,7 @@ static int impose_level(int fd, int level, char *devname, int verbose)
 		/* First remove any spares so no recovery starts */
 		for (d = 0, found = 0;
 		     d < MAX_DISKS && found < array.nr_disks; d++) {
-			mdu_disk_info_t disk;
+			struct mdu_disk_info64 disk = {0};
 			disk.number = d;
 			if (md_get_disk_info(fd, &disk) < 0)
 				continue;
@@ -2939,14 +2939,14 @@ static int impose_level(int fd, int level, char *devname, int verbose)
 			    disk.raid_disk < data_disks)
 				/* keep this */
 				continue;
-			ioctl(fd, HOT_REMOVE_DISK,
+			md_ioctl(fd, MD_HOT_REMOVE_DISK,
 			      makedev(disk.major, disk.minor));
 		}
 		/* Now fail anything left */
 		md_get_array_info(fd, &array);
 		for (d = 0, found = 0;
 		     d < MAX_DISKS && found < array.nr_disks; d++) {
-			mdu_disk_info_t disk;
+			struct mdu_disk_info64 disk = {0};
 			disk.number = d;
 			if (md_get_disk_info(fd, &disk) < 0)
 				continue;
@@ -2957,7 +2957,7 @@ static int impose_level(int fd, int level, char *devname, int verbose)
 			    disk.raid_disk < data_disks)
 				/* keep this */
 				continue;
-			ioctl(fd, SET_DISK_FAULTY,
+			md_ioctl(fd, MD_SET_DISK_FAULTY,
 			      makedev(disk.major, disk.minor));
 			hot_remove_disk(fd, makedev(disk.major, disk.minor), 1);
 		}
@@ -3035,7 +3035,7 @@ static int reshape_array(char *container, int fd, char *devname,
 	int odisks;
 	int delayed;
 
-	struct mdu_array_info_s array;
+	struct mdu_array_info64 array;
 	char *c;
 
 	struct mddev_dev *dv;
@@ -3082,7 +3082,7 @@ static int reshape_array(char *container, int fd, char *devname,
 			info->array.raid_disks += info->delta_disks;
 		if (!restart)
 			/* Make sure the array isn't read-only */
-			ioctl(fd, RESTART_ARRAY_RW, 0);
+			md_ioctl(fd, MD_RESTART_ARRAY_RW, 0);
 	} else
 		msg = analyse_change(devname, info, &reshape);
 	if (msg) {
@@ -5054,7 +5054,7 @@ int Grow_continue_command(char *devname, int fd, struct context *c)
 		 */
 		do {
 			for (d = 0; d < MAX_DISKS; d++) {
-				mdu_disk_info_t disk;
+				struct mdu_disk_info64 disk = {0};
 				char *dv;
 				int err;
 				disk.number = d;
diff --git a/Incremental.c b/Incremental.c
index 4466ab8e..5bd6b1e2 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -314,7 +314,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 		if (add_disk(mdfd, st, &info, &dinfo) != 0) {
 			pr_err("failed to add %s to new array %s: %s.\n",
 				devname, chosen_name, strerror(errno));
-			ioctl(mdfd, STOP_ARRAY, 0);
+			md_ioctl(mdfd, MD_STOP_ARRAY, 0);
 			rv = 2;
 			goto out_unlock;
 		}
@@ -326,7 +326,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 			 * kernel, and mdadm -I may not be able to complete.
 			 * So reject it.
 			 */
-			ioctl(mdfd, STOP_ARRAY, NULL);
+			md_ioctl(mdfd, MD_STOP_ARRAY, NULL);
 			pr_err("You have an old buggy kernel which cannot support\n      --incremental reliably.  Aborting.\n");
 			rv = 2;
 			goto out_unlock;
@@ -592,7 +592,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 
 		if ((sra == NULL || active_disks >= info.array.working_disks) &&
 		    trustworthy != FOREIGN)
-			rv = ioctl(mdfd, RUN_ARRAY, NULL);
+			rv = md_ioctl(mdfd, MD_RUN_ARRAY, NULL);
 		else
 			rv = sysfs_set_str(sra, NULL,
 					   "array_state", "read-auto");
diff --git a/Manage.c b/Manage.c
index 40d52cfc..e8809cb0 100644
--- a/Manage.c
+++ b/Manage.c
@@ -93,14 +93,14 @@ int Manage_ro(char *devname, int fd, int readonly)
 	}
 
 	if (readonly > 0) {
-		if (ioctl(fd, STOP_ARRAY_RO, NULL)) {
+		if (md_ioctl(fd, MD_STOP_ARRAY, NULL, MD_RO_FLAG)) {
 			pr_err("failed to set readonly for %s: %s\n",
 				devname, strerror(errno));
 			rv = 1;
 			goto out;
 		}
 	} else if (readonly < 0) {
-		if (ioctl(fd, RESTART_ARRAY_RW, NULL)) {
+		if (md_ioctl(fd, MD_RESTART_ARRAY_RW, NULL)) {
 			pr_err("failed to set writable for %s: %s\n",
 				devname, strerror(errno));
 			rv = 1;
@@ -442,7 +442,7 @@ done:
 	 */
 	count = 25; err = 0;
 	while (count && fd >= 0 &&
-	       (err = ioctl(fd, STOP_ARRAY, NULL)) < 0 && errno == EBUSY) {
+	       (err = md_ioctl(fd, MD_STOP_ARRAY, NULL)) < 0 && errno == EBUSY) {
 		err = errno;
 		sleep_for(0, MSEC_TO_NSEC(200), true);
 		count --;
@@ -489,8 +489,8 @@ static struct mddev_dev *add_one(struct mddev_dev *dv, char *name, char disp)
 
 static void add_faulty(struct mddev_dev *dv, int fd, char disp)
 {
-	mdu_array_info_t array;
-	mdu_disk_info_t disk;
+	struct mdu_array_info64 array = {0};
+	struct mdu_disk_info64 disk = {0};
 	int remaining_disks;
 	int i;
 
@@ -515,8 +515,8 @@ static void add_faulty(struct mddev_dev *dv, int fd, char disp)
 
 static void add_detached(struct mddev_dev *dv, int fd, char disp)
 {
-	mdu_array_info_t array;
-	mdu_disk_info_t disk;
+	struct mdu_array_info64 array = {0};
+	struct mdu_disk_info64 disk = {0};
 	int remaining_disks;
 	int i;
 
@@ -551,8 +551,8 @@ static void add_detached(struct mddev_dev *dv, int fd, char disp)
 
 static void add_set(struct mddev_dev *dv, int fd, char set_char)
 {
-	mdu_array_info_t array;
-	mdu_disk_info_t disk;
+	struct mdu_array_info64 array = {0};
+	struct mdu_disk_info64 disk = {0};
 	int remaining_disks;
 	int copies, set;
 	int i;
@@ -586,7 +586,7 @@ static void add_set(struct mddev_dev *dv, int fd, char set_char)
 int attempt_re_add(int fd, int tfd, struct mddev_dev *dv,
 		   struct supertype *dev_st, struct supertype *tst,
 		   unsigned long rdev, enum update_opt update,
-		   char *devname, int verbose, mdu_array_info_t *array)
+		   char *devname, int verbose, struct mdu_array_info64 *array)
 {
 	struct mdinfo mdi;
 	int duuid[4];
@@ -607,7 +607,7 @@ int attempt_re_add(int fd, int tfd, struct mddev_dev *dv,
 		 * kernel will accept it
 		 * though.
 		 */
-		mdu_disk_info_t disc;
+		struct mdu_disk_info64 disc;
 		disc.number = mdi.disk.number;
 		if (md_get_disk_info(fd, &disc) != 0 ||
 		    disc.major != 0 || disc.minor != 0)
@@ -674,7 +674,7 @@ int attempt_re_add(int fd, int tfd, struct mddev_dev *dv,
 		}
 		/* don't even try if disk is marked as faulty */
 		errno = 0;
-		if (ioctl(fd, ADD_NEW_DISK, &disc) == 0) {
+		if (md_ioctl(fd, MD_ADD_NEW_DISK, &disc) == 0) {
 			if (verbose >= 0)
 				pr_err("re-added %s\n", dv->devname);
 			return 1;
@@ -702,7 +702,7 @@ skip_re_add:
  * Superblock is released here because any open fd with O_EXCL will block sysfs_add_disk().
  */
 mdadm_status_t manage_add_external(struct supertype *st, int fd, char *disk_name,
-				   mdu_disk_info_t *disc)
+				   struct mdu_disk_info64 *disc)
 {
 	mdadm_status_t rv = MDADM_STATUS_ERROR;
 	char container_devpath[MD_NAME_MAX];
@@ -785,7 +785,7 @@ out:
 }
 
 int Manage_add(int fd, int tfd, struct mddev_dev *dv,
-	       struct supertype *tst, mdu_array_info_t *array,
+	       struct supertype *tst, struct mdu_array_info64 *array,
 	       int force, int verbose, char *devname,
 	       enum update_opt update, unsigned long rdev,
 	       unsigned long long array_size, int raid_slot)
@@ -793,7 +793,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	unsigned long long ldsize;
 	struct supertype *dev_st;
 	int j;
-	mdu_disk_info_t disc;
+	struct mdu_disk_info64 disc;
 	struct map_ent *map = NULL;
 	bool add_new_super = false;
 
@@ -1022,7 +1022,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 		 */
 		char *used = xcalloc(array->raid_disks, 1);
 		for (j = 0; j < tst->max_devs; j++) {
-			mdu_disk_info_t disc2;
+			struct mdu_disk_info64 disc2;
 			disc2.number = j;
 			if (md_get_disk_info(fd, &disc2))
 				continue;
@@ -1061,7 +1061,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			goto unlock;
 	} else {
 		tst->ss->free_super(tst);
-		if (ioctl(fd, ADD_NEW_DISK, &disc)) {
+		if (md_ioctl(fd, MD_ADD_NEW_DISK, &disc)) {
 			if (dv->disposition == 'j')
 				pr_err("Failed to hot add %s as journal, "
 				       "please try restart %s.\n", dv->devname, devname);
@@ -1327,7 +1327,7 @@ abort:
  *
  * Return: True if array will be operational, false otherwise.
  */
-bool is_remove_safe(mdu_array_info_t *array, const int fd, char *devname, const int verbose)
+bool is_remove_safe(struct mdu_array_info64 *array, const int fd, char *devname, const int verbose)
 {
 	dev_t devid = devnm2devid(devname + 5);
 	struct mdinfo *mdi = sysfs_read(fd, NULL, GET_DEVS | GET_DISKS | GET_STATE);
@@ -1405,7 +1405,7 @@ int Manage_subdevs(char *devname, int fd,
 		   struct mddev_dev *devlist, int verbose, int test,
 		   enum update_opt update, int force)
 {
-	mdu_array_info_t array;
+	struct mdu_array_info64 array = {0};
 	unsigned long long array_size;
 	struct mddev_dev *dv;
 	int tfd = -1;
@@ -1493,7 +1493,7 @@ int Manage_subdevs(char *devname, int fd,
 			struct mddev_dev **dp;
 
 			if (dv->disposition == 'c') {
-				rv = ioctl(fd, CLUSTERED_DISK_NACK, NULL);
+				rv = md_ioctl(fd, MD_CLUSTERED_DISK_NACK, NULL);
 				break;
 			}
 
@@ -1677,7 +1677,7 @@ int Manage_subdevs(char *devname, int fd,
 			if (is_fd_valid(sysfd)) {
 				rv = sysfs_set_memb_state_fd(sysfd, MEMB_STATE_FAULTY, &err);
 			} else {
-				rv = ioctl(fd, SET_DISK_FAULTY, rdev);
+				rv = md_ioctl(fd, MD_SET_DISK_FAULTY, rdev);
 				if (rv)
 					err = errno;
 			}
@@ -1744,7 +1744,7 @@ int autodetect(void)
 	int rv = 1;
 	int fd = dev_open("9:0", O_RDONLY);
 	if (fd >= 0) {
-		if (ioctl(fd, RAID_AUTORUN, 0) == 0)
+		if (md_ioctl(fd, MD_RAID_AUTORUN, 0) == 0)
 			rv = 0;
 		close_fd(&fd);
 	}
diff --git a/Query.c b/Query.c
index 4ce52af9..d62bbde3 100644
--- a/Query.c
+++ b/Query.c
@@ -41,7 +41,7 @@ int Query(char *dev)
 	unsigned long long larray_size = 0;
 	struct stat stb;
 	char *mddev;
-	mdu_disk_info_t disc;
+	struct mdu_disk_info64 disc;
 	char *activity;
 
 	fd = open(dev, O_RDONLY);
@@ -63,7 +63,7 @@ int Query(char *dev)
 		raid_disks = sra->array.raid_disks;
 		spare_disks = sra->array.spare_disks;
 	} else {
-		mdu_array_info_t array;
+		struct mdu_array_info64 array = {0};
 
 		if (md_get_array_info(fd, &array) < 0) {
 			ioctlerr = errno;
diff --git a/managemon.c b/managemon.c
index cdeadf3a..24f6c26d 100644
--- a/managemon.c
+++ b/managemon.c
@@ -269,7 +269,7 @@ static void add_disk_to_container(struct supertype *st, struct mdinfo *sd)
 	int dfd;
 	char nm[20];
 	struct metadata_update *update = NULL;
-	mdu_disk_info_t dk = {
+	struct mdu_disk_info64 dk = {
 		.number = -1,
 		.major = sd->disk.major,
 		.minor = sd->disk.minor,
@@ -302,7 +302,7 @@ static void add_disk_to_container(struct supertype *st, struct mdinfo *sd)
 static void remove_disk_from_container(struct supertype *st, struct mdinfo *sd)
 {
 	struct metadata_update *update = NULL;
-	mdu_disk_info_t dk = {
+	struct mdu_disk_info64 dk = {
 		.number = -1,
 		.major = sd->disk.major,
 		.minor = sd->disk.minor,
diff --git a/mdadm.c b/mdadm.c
index 2517b037..ca1bd64b 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -138,7 +138,7 @@ int main(int argc, char *argv[])
 	struct mddev_dev *devlist = NULL;
 	struct mddev_dev **devlistend = & devlist;
 	struct mddev_dev *dv;
-	mdu_array_info_t array;
+	struct mdu_array_info64 array = {0};
 	int devs_found = 0;
 	int grow_continue = 0;
 	struct context c = {
diff --git a/mdadm.h b/mdadm.h
index fb85ed6d..2579dd82 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -269,8 +269,8 @@ struct md_bb {
 
 /* general information that might be extracted from a superblock */
 struct mdinfo {
-	mdu_array_info_t	array;
-	mdu_disk_info_t		disk;
+	struct mdu_array_info64	array;
+	struct mdu_disk_info64  disk;
 	__u64			events;
 	int			uuid[4];
 	char			name[33];
@@ -1021,7 +1021,7 @@ extern struct superswitch {
 	 * Also used to zero metadata prior to writing it to invalidate old
 	 * metadata.
 	 */
-	int (*init_super)(struct supertype *st, mdu_array_info_t *info,
+	int (*init_super)(struct supertype *st, struct mdu_array_info64 *info,
 			  struct shape *s, char *name,
 			  char *homehost, int *uuid,
 			  unsigned long long data_offset);
@@ -1029,13 +1029,13 @@ extern struct superswitch {
 	/* update the metadata to include new device, either at create or
 	 * when hot-adding a spare.
 	 */
-	int (*add_to_super)(struct supertype *st, mdu_disk_info_t *dinfo,
+	int (*add_to_super)(struct supertype *st, struct mdu_disk_info64 *dinfo,
 			    int fd, char *devname,
 			    unsigned long long data_offset);
 	/* update the metadata to delete a device,
 	 * when hot-removing.
 	 */
-	int (*remove_from_super)(struct supertype *st, mdu_disk_info_t *dinfo);
+	int (*remove_from_super)(struct supertype *st, struct mdu_disk_info64 *dinfo);
 
 	/* Write metadata to one device when fixing problems or adding
 	 * a new device.
@@ -1515,9 +1515,9 @@ extern int Restore_metadata(char *dev, char *dir, struct context *c,
 int md_array_valid(int fd);
 int md_array_active(int fd);
 int md_array_is_active(struct mdinfo *info);
-int md_get_array_info(int fd, struct mdu_array_info_s *array);
-int md_set_array_info(int fd, struct mdu_array_info_s *array);
-int md_get_disk_info(int fd, struct mdu_disk_info_s *disk);
+int md_get_array_info(int fd, struct mdu_array_info64 *array);
+int md_set_array_info(int fd, struct mdu_array_info64 *array);
+int md_get_disk_info(int fd, struct mdu_disk_info64 *disk);
 extern int get_linux_version(void);
 extern int mdadm_version(char *version);
 extern unsigned long long parse_size(char *size);
diff --git a/mdmonitor.c b/mdmonitor.c
index b06fa46a..0c746b05 100644
--- a/mdmonitor.c
+++ b/mdmonitor.c
@@ -750,7 +750,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	 */
 	struct { int state, major, minor; } disks_info[MAX_DISKS];
 	struct mdinfo *sra = NULL;
-	mdu_array_info_t array;
+	struct mdu_array_info64 array = {0};
 	struct mdstat_ent *mse = NULL, *mse2;
 	char *dev = st->devname;
 	int fd;
@@ -878,7 +878,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 
 	remaining_disks = sra->array.nr_disks;
 	for (i = 0; i < MAX_DISKS && remaining_disks > 0; i++) {
-		mdu_disk_info_t disc;
+		struct mdu_disk_info64 disc;
 		disc.number = i;
 		if (md_get_disk_info(fd, &disc) >= 0) {
 			disks_info[i].state = disc.state;
@@ -904,7 +904,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		st->metadata = super_by_fd(fd, NULL);
 
 	for (i = 0; i < MAX_DISKS; i++) {
-		mdu_disk_info_t disc = {0, 0, 0, 0, 0};
+		struct mdu_disk_info64 disc = {0, 0, 0, 0, 0};
 		int newstate = 0;
 		int change;
 		char *dv = NULL;
@@ -972,7 +972,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist)
 				      (strcmp(mse->level, "raid0") != 0 &&
 				       strcmp(mse->level, "linear") != 0))) {
 			struct state *st = xcalloc(1, sizeof *st);
-			mdu_array_info_t array;
+			struct mdu_array_info64 array = {0};
 			int fd;
 
 			name = get_md_name(mse->devnm);
diff --git a/super-ddf.c b/super-ddf.c
index a32addb0..dc172f24 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -533,7 +533,7 @@ static void uuid_from_super_ddf(struct supertype *st, int uuid[4]);
 static void _ddf_array_name(char *name, const struct ddf_super *ddf, int i);
 static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, char *map);
 static int init_super_ddf_bvd(struct supertype *st,
-			      mdu_array_info_t *info,
+			      struct mdu_array_info64 *info,
 			      unsigned long long size,
 			      char *name, char *homehost,
 			      int *uuid, unsigned long long data_offset);
@@ -590,14 +590,14 @@ static be32 calc_crc(void *buf, int len)
 
 #define DDF_INVALID_LEVEL 0xff
 #define DDF_NO_SECONDARY 0xff
-static int err_bad_md_layout(const mdu_array_info_t *array)
+static int err_bad_md_layout(const struct mdu_array_info64 *array)
 {
 	pr_err("RAID%d layout %x with %d disks is unsupported for DDF\n",
 	       array->level, array->layout, array->raid_disks);
 	return -1;
 }
 
-static int layout_md2ddf(const mdu_array_info_t *array,
+static int layout_md2ddf(const struct mdu_array_info64 *array,
 			 struct vd_config *conf)
 {
 	be16 prim_elmnt_count = cpu_to_be16(array->raid_disks);
@@ -708,7 +708,7 @@ static int err_bad_ddf_layout(const struct vd_config *conf)
 }
 
 static int layout_ddf2md(const struct vd_config *conf,
-			 mdu_array_info_t *array)
+			 struct mdu_array_info64 *array)
 {
 	int level = LEVEL_UNSUPPORTED;
 	int layout = 0;
@@ -2432,7 +2432,7 @@ static unsigned int find_vde_by_guid(const struct ddf_super *ddf,
 }
 
 static int init_super_ddf(struct supertype *st,
-			  mdu_array_info_t *info,
+			  struct mdu_array_info64 *info,
 			  struct shape *s, char *name, char *homehost,
 			  int *uuid, unsigned long long data_offset)
 {
@@ -2751,7 +2751,7 @@ static unsigned long long find_space(
 }
 
 static int init_super_ddf_bvd(struct supertype *st,
-			      mdu_array_info_t *info,
+			      struct mdu_array_info64 *info,
 			      unsigned long long size,
 			      char *name, char *homehost,
 			      int *uuid, unsigned long long data_offset)
@@ -2870,7 +2870,7 @@ static int init_super_ddf_bvd(struct supertype *st,
 }
 
 static void add_to_super_ddf_bvd(struct supertype *st,
-				 mdu_disk_info_t *dk, int fd, char *devname,
+				 struct mdu_disk_info64 *dk, int fd, char *devname,
 				 unsigned long long data_offset)
 {
 	/* fd and devname identify a device within the ddf container (st).
@@ -2992,7 +2992,7 @@ static void _set_config_size(struct phys_disk_entry *pde, const struct dl *dl)
  * expanding a pre-existing container
  */
 static int add_to_super_ddf(struct supertype *st,
-			    mdu_disk_info_t *dk, int fd, char *devname,
+			    struct mdu_disk_info64 *dk, int fd, char *devname,
 			    unsigned long long data_offset)
 {
 	struct ddf_super *ddf = st->sb;
@@ -3126,7 +3126,7 @@ static int add_to_super_ddf(struct supertype *st,
 	return 0;
 }
 
-static int remove_from_super_ddf(struct supertype *st, mdu_disk_info_t *dk)
+static int remove_from_super_ddf(struct supertype *st, struct mdu_disk_info64 *dk)
 {
 	struct ddf_super *ddf = st->sb;
 	struct dl *dl;
@@ -3555,7 +3555,7 @@ static int validate_geometry_ddf(struct supertype *st,
 		*chunk = DEFAULT_CHUNK;
 
 	if (!dev) {
-		mdu_array_info_t array = {
+		struct mdu_array_info64 array = {
 			.level = level,
 			.layout = layout,
 			.raid_disks = raiddisks
@@ -4408,7 +4408,7 @@ static int get_bvd_state(const struct ddf_super *ddf,
 	unsigned int n_prim = be16_to_cpu(vc->prim_elmnt_count);
 	int pd, st, state;
 	char *avail = xcalloc(1, n_prim);
-	mdu_array_info_t array;
+	struct mdu_array_info64 array = {0};
 
 	layout_ddf2md(vc, &array);
 
diff --git a/super-intel.c b/super-intel.c
index 72e42c6c..7cbf32cd 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5575,14 +5575,14 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 	return 0;
 }
 
-static __u16 info_to_blocks_per_strip(mdu_array_info_t *info)
+static __u16 info_to_blocks_per_strip(struct mdu_array_info64 *info)
 {
 	if (info->level == 1)
 		return 128;
 	return info->chunk_size >> 9;
 }
 
-static unsigned long long info_to_blocks_per_member(mdu_array_info_t *info,
+static unsigned long long info_to_blocks_per_member(struct mdu_array_info64 *info,
 						    unsigned long long size)
 {
 	if (info->level == 1)
@@ -5679,7 +5679,7 @@ static bool imsm_is_name_allowed(struct intel_super *super, const char * const n
 	return true;
 }
 
-static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
+static int init_super_imsm_volume(struct supertype *st, struct mdu_array_info64 *info,
 				  struct shape *s, char *name,
 				  char *homehost, int *uuid,
 				  long long data_offset)
@@ -5857,7 +5857,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	return 1;
 }
 
-static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
+static int init_super_imsm(struct supertype *st, struct mdu_array_info64 *info,
 		           struct shape *s, char *name,
 			   char *homehost, int *uuid,
 			   unsigned long long data_offset)
@@ -5935,7 +5935,7 @@ static int drive_validate_sector_size(struct intel_super *super, struct dl *dl)
 	return 1;
 }
 
-static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
+static int add_to_super_imsm_volume(struct supertype *st, struct mdu_disk_info64 *dk,
 				     int fd, char *devname)
 {
 	struct intel_super *super = st->sb;
@@ -6109,7 +6109,7 @@ int mark_spare(struct dl *disk)
 
 static int write_super_imsm_spare(struct intel_super *super, struct dl *d);
 
-static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
+static int add_to_super_imsm(struct supertype *st, struct mdu_disk_info64 *dk,
 			     int fd, char *devname,
 			     unsigned long long data_offset)
 {
@@ -6229,7 +6229,7 @@ error:
 	return MDADM_STATUS_ERROR;
 }
 
-static int remove_from_super_imsm(struct supertype *st, mdu_disk_info_t *dk)
+static int remove_from_super_imsm(struct supertype *st, struct mdu_disk_info64 *dk)
 {
 	struct intel_super *super = st->sb;
 	struct dl *dd;
diff --git a/super0.c b/super0.c
index 36588347..44f14ef0 100644
--- a/super0.c
+++ b/super0.c
@@ -754,7 +754,7 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
  * 8 bytes for a hash of the host leaving 8 bytes of random material.
  * We use the first 8 bytes (64bits) of the sha1 of the host name
  */
-static int init_super0(struct supertype *st, mdu_array_info_t *info,
+static int init_super0(struct supertype *st, struct mdu_array_info64 *info,
 		       struct shape *s, char *ignored_name,
 		       char *homehost, int *uuid,
 		       unsigned long long data_offset)
@@ -840,13 +840,13 @@ static int init_super0(struct supertype *st, mdu_array_info_t *info,
 struct devinfo {
 	int fd;
 	char *devname;
-	mdu_disk_info_t disk;
+	struct mdu_disk_info64 disk;
 	unsigned long long dev_size;
 	struct devinfo *next;
 };
 
 /* Add a device to the superblock being created */
-static int add_to_super0(struct supertype *st, mdu_disk_info_t *dinfo,
+static int add_to_super0(struct supertype *st, struct mdu_disk_info64 *dinfo,
 			 int fd, char *devname, unsigned long long data_offset)
 {
 	mdp_super_t *sb = st->sb;
diff --git a/super1.c b/super1.c
index 38640681..6e7cb526 100644
--- a/super1.c
+++ b/super1.c
@@ -1503,7 +1503,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 	return rv;
 }
 
-static int init_super1(struct supertype *st, mdu_array_info_t *info,
+static int init_super1(struct supertype *st, struct mdu_array_info64 *info,
 		       struct shape *s, char *name, char *homehost,
 		       int *uuid, unsigned long long data_offset)
 {
@@ -1603,12 +1603,12 @@ struct devinfo {
 	char *devname;
 	long long data_offset;
 	unsigned long long dev_size;
-	mdu_disk_info_t disk;
+	struct mdu_disk_info64 disk;
 	struct devinfo *next;
 };
 
 /* Add a device to the superblock being created */
-static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
+static int add_to_super1(struct supertype *st, struct mdu_disk_info64 *dk,
 			 int fd, char *devname, unsigned long long data_offset)
 {
 	struct mdp_superblock_1 *sb = st->sb;
diff --git a/util.c b/util.c
index 5f0f401b..d1ef0eda 100644
--- a/util.c
+++ b/util.c
@@ -270,7 +270,7 @@ int md_array_valid(int fd)
 		 * GET_ARRAY_INFO doesn't provide access to the proper state
 		 * information, so fallback to a basic check for raid_disks != 0
 		 */
-		ret = ioctl(fd, RAID_VERSION);
+		ret = md_ioctl(fd, MD_RAID_VERSION);
 	}
 
 	return !ret;
@@ -279,7 +279,7 @@ int md_array_valid(int fd)
 int md_array_active(int fd)
 {
 	struct mdinfo *sra;
-	struct mdu_array_info_s array;
+	struct mdu_array_info64 array;
 	int ret = 0;
 
 	sra = sysfs_read(fd, NULL, GET_ARRAY_STATE);
@@ -310,25 +310,25 @@ int md_array_is_active(struct mdinfo *info)
  * Get array info from the kernel. Longer term we want to deprecate the
  * ioctl and get it from sysfs.
  */
-int md_get_array_info(int fd, struct mdu_array_info_s *array)
+int md_get_array_info(int fd, struct mdu_array_info64 *array)
 {
-	return ioctl(fd, GET_ARRAY_INFO, array);
+	return md_ioctl(fd, MD_GET_ARRAY_INFO, array);
 }
 
 /*
  * Set array info
  */
-int md_set_array_info(int fd, struct mdu_array_info_s *array)
+int md_set_array_info(int fd, struct mdu_array_info64 *array)
 {
-	return ioctl(fd, SET_ARRAY_INFO, array);
+	return md_ioctl(fd, MD_SET_ARRAY_INFO, array);
 }
 
 /*
  * Get disk info from the kernel.
  */
-int md_get_disk_info(int fd, struct mdu_disk_info_s *disk)
+int md_get_disk_info(int fd, struct mdu_disk_info64 *disk)
 {
-	return ioctl(fd, GET_DISK_INFO, disk);
+	return md_ioctl(fd, MD_GET_DISK_INFO, disk);
 }
 
 int get_linux_version()
@@ -1196,7 +1196,7 @@ struct superswitch *superlist[] =
 
 struct supertype *super_by_fd(int fd, char **subarrayp)
 {
-	mdu_array_info_t array;
+	struct mdu_array_info64 array = {0};
 	int vers;
 	int minor;
 	struct supertype *st = NULL;
@@ -1782,7 +1782,7 @@ int add_disk(int mdfd, struct supertype *st,
 			}
 		}
 	} else
-		rv = ioctl(mdfd, ADD_NEW_DISK, &info->disk);
+		rv = md_ioctl(mdfd, MD_ADD_NEW_DISK, &info->disk);
 	return rv;
 }
 
@@ -1795,8 +1795,8 @@ int remove_disk(int mdfd, struct supertype *st,
 	if (st->ss->external)
 		rv = sysfs_set_str(sra, info, "slot", STR_COMMON_NONE);
 	else
-		rv = ioctl(mdfd, HOT_REMOVE_DISK, makedev(info->disk.major,
-							  info->disk.minor));
+		rv = md_ioctl(mdfd, MD_HOT_REMOVE_DISK,
+			      makedev(info->disk.major, info->disk.minor));
 	return rv;
 }
 
@@ -1810,7 +1810,7 @@ int hot_remove_disk(int mdfd, unsigned long dev, int force)
 	 * In this case, it can be helpful to wait a little while,
 	 * up to 5 seconds if 'force' is set, or 50 msec if not.
 	 */
-	while ((ret = ioctl(mdfd, HOT_REMOVE_DISK, dev)) == -1 &&
+	while ((ret = md_ioctl(mdfd, MD_HOT_REMOVE_DISK, dev)) == -1 &&
 	       errno == EBUSY &&
 	       cnt-- > 0)
 		sleep_for(0, MSEC_TO_NSEC(10), true);
@@ -1844,7 +1844,7 @@ int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info)
 	 * This varies between externally managed arrays
 	 * and older kernels
 	 */
-	mdu_array_info_t inf;
+	struct mdu_array_info64 inf = {0};
 	int rv;
 
 	if (st->ss->external)
@@ -2644,3 +2644,4 @@ bool init_md_mod(void)
 
 	return ret;
 }
+
-- 
2.43.0

