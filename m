Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EFD30DEC7
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 15:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767455197; cv=none; b=nQBPy8QCZQ8CVKr1lmW7OE3dspaz6xDl4Z4lQoMEZU6kpgUmigFhTcw5cz4EY81rkQN4M5UBtjbs+K6d6PA/sWAL4jNtdpgJXT5ds9pEzz9twhAuJMUgqXJMYkoaGHLKYWzesBL0D5fR9GfBvg3yaZLExYQFXbxpUNR+jkp8A74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767455197; c=relaxed/simple;
	bh=YpDlLUR2mBP+hS4MztbOUNJocuB//5HfGaDhK0t3qC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=do43DdSBSwKoFdX9THDkmeqibY0DSv6hKSsdp1MqIcqEDrZH3NRjmwYMP+V8Us0srpSpADVjkJxw4uiXjsgsln/XGibjdyxgN0qTl1GGkbFcANFeO53OgSAZfU72UCPxf01DWS+JeSaxFmDAYNnbxJDcniF6MT9IxJCK7Py72J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2914BC113D0;
	Sat,  3 Jan 2026 15:46:32 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	colyli@fnnas.com,
	linan122@huawei.com
Subject: [PATCH v2 11/11] md: fix abnormal io_opt from member disks
Date: Sat,  3 Jan 2026 23:45:43 +0800
Message-ID: <20260103154543.832844-12-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260103154543.832844-1-yukuai@fnnas.com>
References: <20260103154543.832844-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's reported that mtp3sas can report abnormal io_opt, for consequence,
md array will end up with abnormal io_opt as well, due to the
lcm_not_zero() from blk_stack_limits().

Some personalities will configure optimal IO size, and it's indicate that
users can get the best IO bandwidth if they issue IO with this size, and
we don't want io_opt to be covered by member disks with abnormal io_opt.

Fix this problem by adding a new mddev flags MD_STACK_IO_OPT to indicate
that io_opt configured by personalities is preferred over member disks
or not.

Reported-by: Filippo Giunchedi <filippo@debian.org>
Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1121006
Reported-by: Coly Li <colyli@fnnas.com>
Closes: https://lore.kernel.org/all/20250817152645.7115-1-colyli@kernel.org/
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.c     | 35 ++++++++++++++++++++++++++++++++++-
 drivers/md/md.h     |  5 ++++-
 drivers/md/raid1.c  |  2 +-
 drivers/md/raid10.c |  4 ++--
 4 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7292aedef01b..b46b05cd28fb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6192,11 +6192,17 @@ static const struct kobj_type md_ktype = {
 
 int mdp_major = 0;
 
+static bool rdev_is_mddev(struct md_rdev *rdev)
+{
+	return rdev->bdev->bd_disk->fops == &md_fops;
+}
+
 /* stack the limit for all rdevs into lim */
 int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 		unsigned int flags)
 {
 	struct md_rdev *rdev;
+	unsigned int io_opt = lim->io_opt;
 
 	rdev_for_each(rdev, mddev) {
 		queue_limits_stack_bdev(lim, rdev->bdev, rdev->data_offset,
@@ -6204,6 +6210,9 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 		if ((flags & MDDEV_STACK_INTEGRITY) &&
 		    !queue_limits_stack_integrity_bdev(lim, rdev->bdev))
 			return -EINVAL;
+
+		if (rdev_is_mddev(rdev))
+			set_bit(MD_STACK_IO_OPT, &mddev->flags);
 	}
 
 	/*
@@ -6217,14 +6226,24 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 	}
 	mddev->logical_block_size = lim->logical_block_size;
 
+	/*
+	 * If all member disks are not mdraid array, and the personality
+	 * already configures io_opt, keep this io_opt and ignore io_opt from
+	 * member disks.
+	 */
+	if (!test_bit(MD_STACK_IO_OPT, &mddev->flags) && io_opt)
+		lim->io_opt = io_opt;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mddev_stack_rdev_limits);
 
 /* apply the extra stacking limits from a new rdev into mddev */
-int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
+int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev,
+			 bool io_opt_configured)
 {
 	struct queue_limits lim;
+	unsigned int io_opt = 0;
 
 	if (mddev_is_dm(mddev))
 		return 0;
@@ -6237,6 +6256,18 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
 	}
 
 	lim = queue_limits_start_update(mddev->gendisk->queue);
+
+	/*
+	 * Keep the old io_opt if no member disks are from md array, and
+	 * the personality configure it's own io_opt.
+	 */
+	if (!test_bit(MD_STACK_IO_OPT, &mddev->flags)) {
+		if (rdev_is_mddev(rdev))
+			set_bit(MD_STACK_IO_OPT, &mddev->flags);
+		else if (io_opt_configured)
+			io_opt = lim.io_opt;
+	}
+
 	queue_limits_stack_bdev(&lim, rdev->bdev, rdev->data_offset,
 				mddev->gendisk->disk_name);
 
@@ -6247,6 +6278,8 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
 		return -ENXIO;
 	}
 
+	if (io_opt)
+		lim.io_opt = io_opt;
 	return queue_limits_commit_update(mddev->gendisk->queue, &lim);
 }
 EXPORT_SYMBOL_GPL(mddev_stack_new_rdev);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ddf989f2a139..d37076593403 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -348,6 +348,7 @@ struct md_cluster_operations;
  * @MD_FAILLAST_DEV: Allow last rdev to be removed.
  * @MD_SERIALIZE_POLICY: Enforce write IO is not reordered, just used by raid1.
  * @MD_BIO_ALIGN: Bio issued to the array will align to io_opt before split.
+ * @MD_STACK_IO_OPT: Stack io_opt by member disks.
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -368,6 +369,7 @@ enum mddev_flags {
 	MD_FAILLAST_DEV,
 	MD_SERIALIZE_POLICY,
 	MD_BIO_ALIGN,
+	MD_STACK_IO_OPT,
 };
 
 enum mddev_sb_flags {
@@ -1041,7 +1043,8 @@ int do_md_run(struct mddev *mddev);
 #define MDDEV_STACK_INTEGRITY	(1u << 0)
 int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 		unsigned int flags);
-int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev);
+int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev,
+			 bool io_opt_configured);
 void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes);
 
 extern const struct block_device_operations md_fops;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1a957dba2640..f3f3086f27fa 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1944,7 +1944,7 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	for (mirror = first; mirror <= last; mirror++) {
 		p = conf->mirrors + mirror;
 		if (!p->rdev) {
-			err = mddev_stack_new_rdev(mddev, rdev);
+			err = mddev_stack_new_rdev(mddev, rdev, false);
 			if (err)
 				return err;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2c6b65b83724..a6edc91e7a9a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2139,7 +2139,7 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			continue;
 		}
 
-		err = mddev_stack_new_rdev(mddev, rdev);
+		err = mddev_stack_new_rdev(mddev, rdev, true);
 		if (err)
 			return err;
 		p->head_position = 0;
@@ -2157,7 +2157,7 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		clear_bit(In_sync, &rdev->flags);
 		set_bit(Replacement, &rdev->flags);
 		rdev->raid_disk = repl_slot;
-		err = mddev_stack_new_rdev(mddev, rdev);
+		err = mddev_stack_new_rdev(mddev, rdev, true);
 		if (err)
 			return err;
 		conf->fullsync = 1;
-- 
2.51.0

