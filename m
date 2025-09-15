Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E620126FD9A
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 03:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757907828; cv=none; b=XuHoKu9VFLtS88pDTgv0MJw470rQW2hWfksEsi1GDllHzhxyFKsMFRE2UfmnGOxkwIf17vL8cTPbVkvDvGprLBlH5P4E4XZzp7IzVLn+HMHy2I3K02pRN0TBB3+/zBGlA3sj1InyF6evhzP3/2sKNNf+P0MYUmfC5T91ygCwiaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757907828; c=relaxed/simple;
	bh=xVrsJVZuhFnm9LlNG5pdF6cSZYwuUUtbPrOEa0kZaf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmfWDxtxOixQDEH150IJcKkYQ8rFqTTZJW0nKtlGAB922+jOBPNE8XY6Y4+vJmCQC7rEVTXOwJ9W75T2sqcC34jf4Pzv1+mnQcQXB3Xk4tRIKLP36jrDZxtcG8+Am6rLgNCoWZqLJMTHUwI1RGYU9zbcY8zJ4kQxjkjQLmcNqXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=aYbF0rGe; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="aYbF0rGe"
Received: from fedora (p4504123-ipxg00s01tokaisakaetozai.aichi.ocn.ne.jp [114.172.113.123])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58F3gpZi004256
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 15 Sep 2025 12:43:16 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=eYqXkk84Nk/9USgO3/iO04eK9HLGW/S0O+fefYCCwoI=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1757907796; v=1;
        b=aYbF0rGeO+0w+wasbY3F+D6nb5VWwRxBvGFfJsXou00YGqhRPkDJhOoQLbYuPvtH
         a98lwCXlLRrNDuFdq2uhB3MhmfF1zWG8e8sDdjrkTMwwbWs9bv94j99JpcEbN/DB
         LY77XktDdb5GeCQsNdsvBOnavjY3dDDVCeivWyBGODjrm0zLCFFPOLosQ2BdD62S
         2WxJmGPHor5t99GC0ahE58fJLpHDDp+3241iiG0WkvTrZ77LdU/YaSRpbakLlYzT
         EQheqUOcc1qyGvuNlt6rHzLoTNe5+4/x33Vlzf0qNFqCr4u9TZYV4Gilcof5IwdE
         4QaJ4CYvjG3d9JQT6xfOkA==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v4 1/9] md/raid1,raid10: Set the LastDev flag when the configuration changes
Date: Mon, 15 Sep 2025 12:42:02 +0900
Message-ID: <20250915034210.8533-2-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250915034210.8533-1-k@mgml.me>
References: <20250915034210.8533-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the LastDev flag is set on an rdev that failed a failfast
metadata write and called md_error, but did not become Faulty. It is
cleared when the metadata write retry succeeds. This has problems for
the following reasons:

* Despite its name, the flag is only set during a metadata write window.
* Unlike when LastDev and Failfast was introduced, md_error on the last
  rdev of a RAID1/10 array now sets MD_BROKEN. Thus when LastDev is set,
  the array is already unwritable.

A following commit will prevent failfast bios from breaking the array,
which requires knowing from outside the personality whether an rdev is
the last one. For that purpose, LastDev should be set on rdevs that must
not be lost.

This commit ensures that LastDev is set on the indispensable rdev in a
degraded RAID1/10 array.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/md.c     |  4 +---
 drivers/md/md.h     |  6 +++---
 drivers/md/raid1.c  | 34 +++++++++++++++++++++++++++++++++-
 drivers/md/raid10.c | 34 +++++++++++++++++++++++++++++++++-
 4 files changed, 70 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e033c26fdd4..268410b66b83 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1007,10 +1007,8 @@ static void super_written(struct bio *bio)
 		if (!test_bit(Faulty, &rdev->flags)
 		    && (bio->bi_opf & MD_FAILFAST)) {
 			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
-			set_bit(LastDev, &rdev->flags);
 		}
-	} else
-		clear_bit(LastDev, &rdev->flags);
+	}
 
 	bio_put(bio);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 51af29a03079..ec598f9a8381 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -281,9 +281,9 @@ enum flag_bits {
 				 * It is expects that no bad block log
 				 * is present.
 				 */
-	LastDev,		/* Seems to be the last working dev as
-				 * it didn't fail, so don't use FailFast
-				 * any more for metadata
+	LastDev,		/* This is the last working rdev.
+				 * so don't use FailFast any more for
+				 * metadata.
 				 */
 	CollisionCheck,		/*
 				 * check if there is collision between raid1
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index bf44878ec640..32ad6b102ff7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1733,6 +1733,33 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
 	seq_printf(seq, "]");
 }
 
+/**
+ * update_lastdev - Set or clear LastDev flag for all rdevs in array
+ * @conf: pointer to r1conf
+ *
+ * Sets LastDev if the device is In_sync and cannot be lost for the array.
+ * Otherwise, clear it.
+ *
+ * Caller must hold ->device_lock.
+ */
+static void update_lastdev(struct r1conf *conf)
+{
+	int i;
+	int alive_disks = conf->raid_disks - conf->mddev->degraded;
+
+	for (i = 0; i < conf->raid_disks; i++) {
+		struct md_rdev *rdev = conf->mirrors[i].rdev;
+
+		if (rdev) {
+			if (test_bit(In_sync, &rdev->flags) &&
+			    alive_disks == 1)
+				set_bit(LastDev, &rdev->flags);
+			else
+				clear_bit(LastDev, &rdev->flags);
+		}
+	}
+}
+
 /**
  * raid1_error() - RAID1 error handler.
  * @mddev: affected md device.
@@ -1767,8 +1794,10 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 		}
 	}
 	set_bit(Blocked, &rdev->flags);
-	if (test_and_clear_bit(In_sync, &rdev->flags))
+	if (test_and_clear_bit(In_sync, &rdev->flags)) {
 		mddev->degraded++;
+		update_lastdev(conf);
+	}
 	set_bit(Faulty, &rdev->flags);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 	/*
@@ -1864,6 +1893,7 @@ static int raid1_spare_active(struct mddev *mddev)
 		}
 	}
 	mddev->degraded -= count;
+	update_lastdev(conf);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
 	print_conf(conf);
@@ -3290,6 +3320,7 @@ static int raid1_run(struct mddev *mddev)
 	rcu_assign_pointer(conf->thread, NULL);
 	mddev->private = conf;
 	set_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
+	update_lastdev(conf);
 
 	md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
 
@@ -3427,6 +3458,7 @@ static int raid1_reshape(struct mddev *mddev)
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	mddev->degraded += (raid_disks - conf->raid_disks);
+	update_lastdev(conf);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 	conf->raid_disks = mddev->raid_disks = raid_disks;
 	mddev->delta_disks = 0;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b60c30bfb6c7..dc4edd4689f8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1983,6 +1983,33 @@ static int enough(struct r10conf *conf, int ignore)
 		_enough(conf, 1, ignore);
 }
 
+/**
+ * update_lastdev - Set or clear LastDev flag for all rdevs in array
+ * @conf: pointer to r10conf
+ *
+ * Sets LastDev if the device is In_sync and cannot be lost for the array.
+ * Otherwise, clear it.
+ *
+ * Caller must hold ->reconfig_mutex or ->device_lock.
+ */
+static void update_lastdev(struct r10conf *conf)
+{
+	int i;
+	int raid_disks = max(conf->geo.raid_disks, conf->prev.raid_disks);
+
+	for (i = 0; i < raid_disks; i++) {
+		struct md_rdev *rdev = conf->mirrors[i].rdev;
+
+		if (rdev) {
+			if (test_bit(In_sync, &rdev->flags) &&
+			    !enough(conf, i))
+				set_bit(LastDev, &rdev->flags);
+			else
+				clear_bit(LastDev, &rdev->flags);
+		}
+	}
+}
+
 /**
  * raid10_error() - RAID10 error handler.
  * @mddev: affected md device.
@@ -2013,8 +2040,10 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 			return;
 		}
 	}
-	if (test_and_clear_bit(In_sync, &rdev->flags))
+	if (test_and_clear_bit(In_sync, &rdev->flags)) {
 		mddev->degraded++;
+		update_lastdev(conf);
+	}
 
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(Blocked, &rdev->flags);
@@ -2102,6 +2131,7 @@ static int raid10_spare_active(struct mddev *mddev)
 	}
 	spin_lock_irqsave(&conf->device_lock, flags);
 	mddev->degraded -= count;
+	update_lastdev(conf);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
 	print_conf(conf);
@@ -4159,6 +4189,7 @@ static int raid10_run(struct mddev *mddev)
 	md_set_array_sectors(mddev, size);
 	mddev->resync_max_sectors = size;
 	set_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
+	update_lastdev(conf);
 
 	if (md_integrity_register(mddev))
 		goto out_free_conf;
@@ -4567,6 +4598,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	 */
 	spin_lock_irq(&conf->device_lock);
 	mddev->degraded = calc_degraded(conf);
+	update_lastdev(conf);
 	spin_unlock_irq(&conf->device_lock);
 	mddev->raid_disks = conf->geo.raid_disks;
 	mddev->reshape_position = conf->reshape_progress;
-- 
2.50.1

