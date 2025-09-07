Received: from q64jeremias.jears.at (jears.at [62.240.152.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B661F4FA
	for <linux-raid@vger.kernel.org>; Sun,  7 Sep 2025 18:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.240.152.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757268968; cv=none; b=WNH2S33utjwou5UycCxgXiD8cH8damLU9W1639lQOKmjsl09qhg0gt+HcB/sHd0Lx0/m1MxAyA/aX5Q0+HoRwfJx30L96CEHw7TqkmCwXWsAq34R9+pNwig7hi9FJw4QOz/mdrf+4rZpYQulcflf/HcoHoowYQHFojG0q+TDG0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757268968; c=relaxed/simple;
	bh=5YmrvJjA+49Rp2Jp8J65zGYsQvwkps0LvrEbCAf6sc4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=stTCvQEA51gpkNTf0a5+o3DtAqsxmMayvshH7HUVwUTuCVbeOSikGdBPi1zgxo5o/3vKqBFcOxiTJFJ0de3MgiYReZPbdztKSrtD4BiGY3f89/qXFoo3CMtki0BMVkjSdDK98r4r4+zmME7Htwd4PK/eYduG3uAWjM4rrboP1S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jears.at; spf=pass smtp.mailfrom=jears.at; dkim=pass (1024-bit key) header.d=jears.at header.i=@jears.at header.b=y14K0jaU; dkim=pass (1024-bit key) header.d=jears.at header.i=@jears.at header.b=uf5aRzzE; arc=none smtp.client-ip=62.240.152.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jears.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jears.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jears.at header.i=@jears.at header.b="y14K0jaU";
	dkim=pass (1024-bit key) header.d=jears.at header.i=@jears.at header.b="uf5aRzzE"
Received: from localhost (localhost [127.0.0.1])
	by foo.example.com (Postfix) with ESMTP id E74CA10DD6F;
	Sun, 07 Sep 2025 20:09:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jears.at; s=mail;
	t=1757268583; bh=jul6ldXDxQgHnoeT7G6rbCz2JP4ZrZQfLTb9aObRubk=;
	h=From:To:Cc:Subject:Date;
	b=y14K0jaUhl4DWvqjhizNOj42TjycCRlNBCsfb2Hih1Z+P2gjTrmW52o+zoLBtUpmi
	 5EAWi+2ikbpLHNYpDy8WDTggCk4hAOe7dwkooXJVxvWMreuUHc+TvblPvsMUBhgmqH
	 RRqVxbXzKNz7C+0p+FO06lNCRUQrg64Ytg3LgxC8=
X-Virus-Scanned: amavisd-new at jears.at
Received: from q64jeremias.jears.at ([127.0.0.1])
	by localhost (mail.jears.at [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id dZFqYHaGBC8s; Sun,  7 Sep 2025 20:09:39 +0200 (CEST)
Received: from localhost.localdomain (Jeremias-PC.fritz.box [192.168.0.66])
	by q64jeremias.jears.at (Postfix) with ESMTPA id D85E910DD6A;
	Sun, 07 Sep 2025 20:09:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jears.at; s=mail;
	t=1757268577; bh=jul6ldXDxQgHnoeT7G6rbCz2JP4ZrZQfLTb9aObRubk=;
	h=From:To:Cc:Subject:Date;
	b=uf5aRzzE5nfVBKiw1tFEUm/feuTPjftu5moHeU93orGY2DpLzCWKsZAM+Sztu5yjk
	 75/scrSHlZTq79+cBEq+2eoKWyOhkUQ3CmKtgtb7oMnnk7nvGfhqbpO/+S0aVzS17/
	 aMK7xkJXLwHNeCvH3sMt/TNOiu8jqTAGJab8AjtM=
From: Jeremias Stotter <jeremias@jears.at>
To: linux-raid@vger.kernel.org
Cc: Jeremias Stotter <jeremias@jears.at>
Subject: [PATCH] md: allow autodetection of superblock v1.x
Date: Sun,  7 Sep 2025 18:01:25 +0000
Message-ID: <20250907180124.1419-2-jeremias@jears.at>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, md autodetect only supports version 0.90 superblocks.
This patch enables the kernel to autodetect the version of the superblock
during autodetection by trying which version succeeds loading.
mdadm uses a similar approach.

Version 1 superblocks don't store a preferred minor number, so one is
picked from 0xffff downwards so it is unlikely to cause collisions.

A new helper md_autodetect_bind_export_rdev is added for use in
md_setup_drive in md_autodetect.c. It wraps bind_rdev_to_array() and
export_rdev() to keep them private to md.c

Updated md.rst to reflect the removed restriction.

This has been tested with v0.90, v1.0-2 arrays both with assembly
explicitly through md=... and automatic detection.

This patch supersedes my previous submission sent on 2025-08-25:
 md: Allow setting persistent superblock version for md= command line

Signed-off-by: Jeremias Stotter <jeremias@jears.at>
---
 Documentation/admin-guide/md.rst |  3 +-
 drivers/md/md-autodetect.c       | 56 ++++++++++++++------
 drivers/md/md.c                  | 89 ++++++++++++++++++++++++++++----
 drivers/md/md.h                  |  4 ++
 4 files changed, 125 insertions(+), 27 deletions(-)

diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
index 4ff2cc291d18..277bf0cdd84a 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -80,8 +80,7 @@ Boot time autodetection of RAID arrays
 When md is compiled into the kernel (not as module), partitions of
 type 0xfd are scanned and automatically assembled into RAID arrays.
 This autodetection may be suppressed with the kernel parameter
-``raid=noautodetect``.  As of kernel 2.6.9, only drives with a type 0
-superblock can be autodetected and run at boot time.
+``raid=noautodetect``.
 
 The kernel parameter ``raid=partitionable`` (or ``raid=part``) means
 that all auto-detected arrays are assembled as partitionable.
diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 4b80165afd23..c677e90a6c62 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -198,22 +198,48 @@ static void __init md_setup_drive(struct md_setup_args *args)
 			ainfo.raid_disks++;
 	}
 
-	err = md_set_array_info(mddev, &ainfo);
-
-	for (i = 0; i <= MD_SB_DISKS && devices[i]; i++) {
-		struct mdu_disk_info_s dinfo = {
-			.major	= MAJOR(devices[i]),
-			.minor	= MINOR(devices[i]),
-		};
-
-		if (args->level != LEVEL_NONE) {
-			dinfo.number = i;
-			dinfo.raid_disk = i;
-			dinfo.state =
-				(1 << MD_DISK_ACTIVE) | (1 << MD_DISK_SYNC);
-		}
+	if (args->level != LEVEL_NONE) {
+		err = md_set_array_info(mddev, &ainfo);
+		for (i = 0; i <= MD_SB_DISKS && devices[i]; i++) {
+			struct mdu_disk_info_s dinfo = {
+				.major	= MAJOR(devices[i]),
+				.minor	= MINOR(devices[i]),
+			};
+
+			if (args->level != LEVEL_NONE) {
+				dinfo.number = i;
+				dinfo.raid_disk = i;
+				dinfo.state =
+					(1 << MD_DISK_ACTIVE) | (1 << MD_DISK_SYNC);
+			}
 
-		md_add_new_disk(mddev, &dinfo);
+			md_add_new_disk(mddev, &dinfo);
+		}
+	} else {
+		ainfo.major_version = -1;
+		ainfo.minor_version = -1;
+		for (i = 0; i <= MD_SB_DISKS && devices[i]; i++) {
+			struct md_rdev *rdev = NULL;
+
+			if (ainfo.major_version < 0) {
+				rdev = md_guess_super_import_device(devices[i]);
+				if (rdev == NULL)
+					continue;
+				ainfo.major_version = rdev->sb_major_version;
+				ainfo.minor_version = rdev->sb_minor_version;
+				err = md_set_array_info(mddev, &ainfo);
+				if (err) {
+					pr_warn("md: couldn't update array info. %d\n", err);
+					break;
+				}
+			} else {
+				rdev = md_import_device(devices[i],
+							ainfo.major_version, ainfo.minor_version);
+				if (rdev == NULL)
+					continue;
+			}
+			md_autodetect_bind_export_rdev(rdev, mddev);
+		}
 	}
 
 	if (!err)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1baaf52c603c..0ef7d8c905f1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2538,6 +2538,15 @@ static void export_rdev(struct md_rdev *rdev, struct mddev *mddev)
 	kobject_put(&rdev->kobj);
 }
 
+int md_autodetect_bind_export_rdev(struct md_rdev *rdev, struct mddev *mddev)
+{
+	int err = bind_rdev_to_array(rdev, mddev);
+
+	if (err)
+		export_rdev(rdev, mddev);
+	return err;
+}
+
 static void md_kick_rdev_from_array(struct md_rdev *rdev)
 {
 	struct mddev *mddev = rdev->mddev;
@@ -3703,7 +3712,7 @@ EXPORT_SYMBOL_GPL(md_rdev_init);
  *
  * a faulty rdev _never_ has rdev->sb set.
  */
-static struct md_rdev *md_import_device(dev_t newdev, int super_format, int super_minor)
+struct md_rdev *md_import_device(dev_t newdev, int super_format, int super_minor)
 {
 	struct md_rdev *rdev;
 	sector_t size;
@@ -3757,10 +3766,13 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 		}
 	}
 
+	rdev->sb_major_version = super_format;
+	rdev->sb_minor_version = super_minor;
+
 	return rdev;
 
 out_blkdev_put:
-	fput(rdev->bdev_file);
+	bdev_fput(rdev->bdev_file);
 out_clear_rdev:
 	md_rdev_clear(rdev);
 out_free_rdev:
@@ -6773,6 +6785,11 @@ static void autorun_devices(int part)
 {
 	struct md_rdev *rdev0, *rdev, *tmp;
 	struct mddev *mddev;
+	/*
+	 * Version 1 superblocks don't store a preferred minor number,
+	 * assign a high one here so we get no conflicts
+	 */
+	int preferred_minor_1 = 0xffff;
 
 	pr_info("md: autorun ...\n");
 	while (!list_empty(&pending_raid_disks)) {
@@ -6784,28 +6801,50 @@ static void autorun_devices(int part)
 
 		pr_debug("md: considering %pg ...\n", rdev0->bdev);
 		INIT_LIST_HEAD(&candidates);
-		rdev_for_each_list(rdev, tmp, &pending_raid_disks)
-			if (super_90_load(rdev, rdev0, 0) >= 0) {
+		rdev_for_each_list(rdev, tmp, &pending_raid_disks) {
+			if (rdev0->sb_major_version != rdev->sb_major_version ||
+			    rdev0->sb_minor_version != rdev->sb_minor_version) {
+				pr_debug("md:  Versions don't match with %pg ...\n",
+					 rdev->bdev);
+				continue;
+			}
+			if (super_types[rdev->sb_major_version].load_super(rdev,
+									  rdev0,
+									  rdev0->sb_minor_version
+									  ) >= 0) {
 				pr_debug("md:  adding %pg ...\n",
 					 rdev->bdev);
 				list_move(&rdev->same_set, &candidates);
 			}
+		}
 		/*
 		 * now we have a set of devices, with all of them having
 		 * mostly sane superblocks. It's time to allocate the
 		 * mddev.
 		 */
+
+		int minor = rdev0->preferred_minor;
+
+		if (rdev0->sb_major_version == 1) {
+			if (preferred_minor_1 < 0) {
+				pr_warn("md: no free minor number left for v1 superblock\n");
+				break;
+			}
+			minor = preferred_minor_1;
+			preferred_minor_1--;
+		}
+
 		if (part) {
 			dev = MKDEV(mdp_major,
-				    rdev0->preferred_minor << MdpMinorShift);
+				    minor << MdpMinorShift);
 			unit = MINOR(dev) >> MdpMinorShift;
 		} else {
-			dev = MKDEV(MD_MAJOR, rdev0->preferred_minor);
+			dev = MKDEV(MD_MAJOR, minor);
 			unit = MINOR(dev);
 		}
-		if (rdev0->preferred_minor != unit) {
+		if (minor != unit) {
 			pr_warn("md: unit number in %pg is bad: %d\n",
-				rdev0->bdev, rdev0->preferred_minor);
+				rdev0->bdev, minor);
 			break;
 		}
 
@@ -6823,6 +6862,10 @@ static void autorun_devices(int part)
 		} else {
 			pr_debug("md: created %s\n", mdname(mddev));
 			mddev->persistent = 1;
+
+			mddev->major_version = rdev0->sb_major_version;
+			mddev->minor_version = rdev0->sb_minor_version;
+
 			rdev_for_each_list(rdev, tmp, &candidates) {
 				list_del_init(&rdev->same_set);
 				if (bind_rdev_to_array(rdev, mddev))
@@ -10350,6 +10393,32 @@ void md_autodetect_dev(dev_t dev)
 	}
 }
 
+struct md_sb_type {
+	int major;
+	int minor;
+};
+
+static const struct md_sb_type super_versions[4] = {
+	{0, 90},
+	{1, 2},
+	{1, 1},
+	{1, 0}
+};
+
+struct md_rdev *md_guess_super_import_device(dev_t dev)
+{
+	const struct md_sb_type *super;
+	struct md_rdev *rdev;
+
+	for (int i = 0; i < ARRAY_SIZE(super_versions); i++) {
+		super = &super_versions[i];
+		rdev = md_import_device(dev, super->major, super->minor);
+		if (!IS_ERR_OR_NULL(rdev))
+			return rdev;
+	}
+	return NULL; /* No valid superblock found */
+}
+
 void md_autostart_arrays(int part)
 {
 	struct md_rdev *rdev;
@@ -10371,9 +10440,9 @@ void md_autostart_arrays(int part)
 		dev = node_detected_dev->dev;
 		kfree(node_detected_dev);
 		mutex_unlock(&detected_devices_mutex);
-		rdev = md_import_device(dev,0, 90);
+		rdev = md_guess_super_import_device(dev);
 		mutex_lock(&detected_devices_mutex);
-		if (IS_ERR(rdev))
+		if (rdev == NULL)
 			continue;
 
 		if (test_bit(Faulty, &rdev->flags))
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 51af29a03079..b7eab774ef7f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -145,6 +145,7 @@ struct md_rdev {
 
 	struct page	*sb_page, *bb_page;
 	int		sb_loaded;
+	int		sb_major_version, sb_minor_version;
 	__u64		sb_events;
 	sector_t	data_offset;	/* start of data in array */
 	sector_t	new_data_offset;/* only relevant while reshaping */
@@ -921,6 +922,7 @@ extern void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern void md_set_array_sectors(struct mddev *mddev, sector_t array_sectors);
 extern int md_check_no_bitmap(struct mddev *mddev);
 extern int md_integrity_register(struct mddev *mddev);
+int md_autodetect_bind_export_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
 
 extern int mddev_init(struct mddev *mddev);
@@ -933,6 +935,7 @@ extern int md_start(struct mddev *mddev);
 extern void md_stop(struct mddev *mddev);
 extern void md_stop_writes(struct mddev *mddev);
 extern int md_rdev_init(struct md_rdev *rdev);
+struct md_rdev *md_import_device(dev_t newdev, int super_format, int super_minor);
 extern void md_rdev_clear(struct md_rdev *rdev);
 
 extern bool md_handle_request(struct mddev *mddev, struct bio *bio);
@@ -1014,6 +1017,7 @@ struct mdu_disk_info_s;
 
 extern int mdp_major;
 extern struct workqueue_struct *md_bitmap_wq;
+struct md_rdev *md_guess_super_import_device(dev_t dev);
 void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
-- 
2.49.1

