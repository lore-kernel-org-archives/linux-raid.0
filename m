Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AE62EB87B
	for <linux-raid@vger.kernel.org>; Wed, 14 Jan 2026 17:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410812; cv=none; b=XOj7kfIbOZirkNf/4ltuj13rp8jmXwlzM0cgwUFhdQGqKL6DlgU0A35gOQU37VnCzmGV/fYlFktDuII4OvjjSdRxQTwhODwb2TGM66zIyTQQk4G2q2uhvxg0xroJvWCINSSsJrPpJJ6MLllhO4Z9+JCj64fs7/CDygd5HQPr1W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410812; c=relaxed/simple;
	bh=ESPT3yqzB6zldoZK0yGUqUMHl3INGYdRHE4gHqF6AVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXR+DFPZNMMLRV1Idb1OUoGA3K1mjwmssccjyf8yjyl90xJdsNqo8yGpxkhZbox8tjaBLAfRwLzRNI55+pVVbELyoEvluvQ7FqA5uHAXksk4ictMBNQ8o+TqFQR7i50aBI7eLDbpzIFTmZJ2r3+dgsM+kbDmylLNsxS6mndayeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD66C19421;
	Wed, 14 Jan 2026 17:13:26 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com,
	dan.carpenter@linaro.org
Subject: [PATCH v5 12/12] md: fix abnormal io_opt from member disks
Date: Thu, 15 Jan 2026 01:12:40 +0800
Message-ID: <20260114171241.3043364-13-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260114171241.3043364-1-yukuai@fnnas.com>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
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

Fix this problem by checking if the member disk is an mdraid array. If
not, keep the io_opt configured by personalities and ignore io_opt from
member disk.

Reported-by: Filippo Giunchedi <filippo@debian.org>
Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1121006
Reported-by: Coly Li <colyli@fnnas.com>
Closes: https://lore.kernel.org/all/20250817152645.7115-1-colyli@kernel.org/
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com> 
Reviewed-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c     | 28 +++++++++++++++++++++++++++-
 drivers/md/md.h     |  3 ++-
 drivers/md/raid1.c  |  2 +-
 drivers/md/raid10.c |  4 ++--
 4 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 731ec800f5cb..6c0fb09c26dc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6200,18 +6200,33 @@ static const struct kobj_type md_ktype = {
 
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
+	bool io_opt_configured = lim->io_opt;
 
 	rdev_for_each(rdev, mddev) {
+		unsigned int io_opt = lim->io_opt;
+
 		queue_limits_stack_bdev(lim, rdev->bdev, rdev->data_offset,
 					mddev->gendisk->disk_name);
 		if ((flags & MDDEV_STACK_INTEGRITY) &&
 		    !queue_limits_stack_integrity_bdev(lim, rdev->bdev))
 			return -EINVAL;
+
+		/*
+		 * If member disk is not mdraid array, keep the io_opt
+		 * from personality and ignore io_opt from member disk.
+		 */
+		if (!rdev_is_mddev(rdev) && io_opt_configured)
+			lim->io_opt = io_opt;
 	}
 
 	/*
@@ -6230,9 +6245,11 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 EXPORT_SYMBOL_GPL(mddev_stack_rdev_limits);
 
 /* apply the extra stacking limits from a new rdev into mddev */
-int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
+int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev,
+			 bool io_opt_configured)
 {
 	struct queue_limits lim;
+	unsigned int io_opt;
 
 	if (mddev_is_dm(mddev))
 		return 0;
@@ -6245,6 +6262,8 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
 	}
 
 	lim = queue_limits_start_update(mddev->gendisk->queue);
+	io_opt = lim.io_opt;
+
 	queue_limits_stack_bdev(&lim, rdev->bdev, rdev->data_offset,
 				mddev->gendisk->disk_name);
 
@@ -6255,6 +6274,13 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
 		return -ENXIO;
 	}
 
+	/*
+	 * If member disk is not mdraid array, keep the io_opt from
+	 * personality and ignore io_opt from member disk.
+	 */
+	if (!rdev_is_mddev(rdev) && io_opt_configured)
+		lim.io_opt = io_opt;
+
 	return queue_limits_commit_update(mddev->gendisk->queue, &lim);
 }
 EXPORT_SYMBOL_GPL(mddev_stack_new_rdev);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ddf989f2a139..80c527b3777d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1041,7 +1041,8 @@ int do_md_run(struct mddev *mddev);
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

