Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC831C3F17
	for <linux-raid@vger.kernel.org>; Tue, 27 Aug 2024 15:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772950; cv=none; b=IVZ1AztPfdCEZ2zS0micGAVR4ZjS1PnJdN/YtUCLICuYjEGij3bwKiXNnsVE/n9mjvl1ptUXpPk+trrh+RPH2Q4rpw4Jac8XBP0M+aLM1ttAeIP+9oKUykvUO1Jgw+pObEz0E9l1fH3sLaNl9tug3IDKKpeoGM2BYPHCLO64lls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772950; c=relaxed/simple;
	bh=DlTgAkDMZigOgB86X3IdPTHyYdpmRglEH5v9Cxh/lHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEh/rK49ibF6FZLM7QzMvL2sjq+EyyLlTGY/PfUcJZ5mQL97vrQrv7OyWoWkv3UWkh196eSfap9GyGTcPytvt9oFOeJnSli938JdZHlZZSQDD7JmsKg1N8ggBGnI9CjaFrWux2qt6HwPDRjEKsBQRizLSOSi2/Af4DWl0KapuyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HKppfxWb; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HKppfxWb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724772949; x=1756308949;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DlTgAkDMZigOgB86X3IdPTHyYdpmRglEH5v9Cxh/lHU=;
  b=HKppfxWbnxsYVl2PJEm/UbeRB4WuHjfzvx0nI+azVPOb7vYji1DBeREi
   3MWFkGuWB2pFkfqFo33ZnWT8EnGCL9ghGOqJoWhqG2y8FuSvmL+KP/Bwf
   8L8t1/WZ8I4DMT+uv9nyA+Wfq1hMU/zAjQl+TCREHy4GivqhlRjVIB/BK
   huQkRgjJWgBY2F9rzirjPtRtidONUdVnTKdmOqdnr9wm3vbDb7MoL8Yjt
   DNx1iP4ZtSpxPZxT1Ir4qdnbC8AN2p2T/KwfcxaIS8iliNggvJiB+eQHq
   /W1sAN16FF7VaXpLbUatrkzXHQ21sQd9scWeuPonXA3JxA9KiLb/gzDXF
   A==;
X-CSE-ConnectionGUID: yYe/0dWsTfGpKAWH5oQlHw==
X-CSE-MsgGUID: /wFHeEXgSym6PLTOxMFtQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11177"; a="34634191"
X-IronPort-AV: E=Sophos;i="6.10,180,1719903600"; 
   d="scan'208";a="34634191"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 08:35:49 -0700
X-CSE-ConnectionGUID: yy5QoDGBR52hd93gtCwkFQ==
X-CSE-MsgGUID: GX6yjKukQT6KoieoW/+tSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,180,1719903600"; 
   d="scan'208";a="62628247"
Received: from apaszkie-mobl2.apaszkie-mobl2 (HELO apaszkie-mobl2.intel.com) ([10.245.244.19])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 08:35:47 -0700
From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	paul.e.luse@intel.com
Subject: [PATCH 3/3] md/raid5: rename wait_for_overlap to wait_for_reshape
Date: Tue, 27 Aug 2024 17:35:36 +0200
Message-ID: <20240827153536.6743-4-artur.paszkiewicz@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240827153536.6743-1-artur.paszkiewicz@intel.com>
References: <20240827153536.6743-1-artur.paszkiewicz@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only remaining uses of wait_for_overlap are related to reshape so
rename it accordingly.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5.c | 26 +++++++++++++-------------
 drivers/md/raid5.h |  2 +-
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8e74c455a87d..7def36cfb408 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5255,7 +5255,7 @@ static void handle_stripe(struct stripe_head *sh)
 	} else if (s.expanded && !sh->reconstruct_state && s.locked == 0) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
-		wake_up(&conf->wait_for_overlap);
+		wake_up(&conf->wait_for_reshape);
 		md_done_sync(conf->mddev, RAID5_STRIPE_SECTORS(conf), 1);
 	}
 
@@ -6149,7 +6149,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 		logical_sector = raid5_bio_lowest_chunk_sector(conf, bi);
 		on_wq = false;
 	} else {
-		add_wait_queue(&conf->wait_for_overlap, &wait);
+		add_wait_queue(&conf->wait_for_reshape, &wait);
 		on_wq = true;
 	}
 	s = (logical_sector - ctx.first_sector) >> RAID5_STRIPE_SHIFT(conf);
@@ -6190,7 +6190,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 			(s << RAID5_STRIPE_SHIFT(conf));
 	}
 	if (unlikely(on_wq))
-		remove_wait_queue(&conf->wait_for_overlap, &wait);
+		remove_wait_queue(&conf->wait_for_reshape, &wait);
 
 	if (ctx.batch_last)
 		raid5_release_stripe(ctx.batch_last);
@@ -6343,7 +6343,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	     : (safepos < writepos && readpos > writepos)) ||
 	    time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
 		/* Cannot proceed until we've updated the superblock... */
-		wait_event(conf->wait_for_overlap,
+		wait_event(conf->wait_for_reshape,
 			   atomic_read(&conf->reshape_stripes)==0
 			   || test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 		if (atomic_read(&conf->reshape_stripes) != 0)
@@ -6369,7 +6369,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 		spin_lock_irq(&conf->device_lock);
 		conf->reshape_safe = mddev->reshape_position;
 		spin_unlock_irq(&conf->device_lock);
-		wake_up(&conf->wait_for_overlap);
+		wake_up(&conf->wait_for_reshape);
 		sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	}
 
@@ -6452,7 +6452,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	    (sector_nr - mddev->curr_resync_completed) * 2
 	    >= mddev->resync_max - mddev->curr_resync_completed) {
 		/* Cannot proceed until we've updated the superblock... */
-		wait_event(conf->wait_for_overlap,
+		wait_event(conf->wait_for_reshape,
 			   atomic_read(&conf->reshape_stripes) == 0
 			   || test_bit(MD_RECOVERY_INTR, &mddev->recovery));
 		if (atomic_read(&conf->reshape_stripes) != 0)
@@ -6478,7 +6478,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 		spin_lock_irq(&conf->device_lock);
 		conf->reshape_safe = mddev->reshape_position;
 		spin_unlock_irq(&conf->device_lock);
-		wake_up(&conf->wait_for_overlap);
+		wake_up(&conf->wait_for_reshape);
 		sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	}
 ret:
@@ -6513,7 +6513,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 	}
 
 	/* Allow raid5_quiesce to complete */
-	wait_event(conf->wait_for_overlap, conf->quiesce != 2);
+	wait_event(conf->wait_for_reshape, conf->quiesce != 2);
 
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return reshape_request(mddev, sector_nr, skipped);
@@ -7497,7 +7497,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 	init_waitqueue_head(&conf->wait_for_quiescent);
 	init_waitqueue_head(&conf->wait_for_stripe);
-	init_waitqueue_head(&conf->wait_for_overlap);
+	init_waitqueue_head(&conf->wait_for_reshape);
 	INIT_LIST_HEAD(&conf->handle_list);
 	INIT_LIST_HEAD(&conf->loprio_list);
 	INIT_LIST_HEAD(&conf->hold_list);
@@ -8555,7 +8555,7 @@ static void end_reshape(struct r5conf *conf)
 			    !test_bit(In_sync, &rdev->flags))
 				rdev->recovery_offset = MaxSector;
 		spin_unlock_irq(&conf->device_lock);
-		wake_up(&conf->wait_for_overlap);
+		wake_up(&conf->wait_for_reshape);
 
 		mddev_update_io_opt(conf->mddev,
 			conf->raid_disks - conf->max_degraded);
@@ -8619,13 +8619,13 @@ static void raid5_quiesce(struct mddev *mddev, int quiesce)
 		conf->quiesce = 1;
 		unlock_all_device_hash_locks_irq(conf);
 		/* allow reshape to continue */
-		wake_up(&conf->wait_for_overlap);
+		wake_up(&conf->wait_for_reshape);
 	} else {
 		/* re-enable writes */
 		lock_all_device_hash_locks_irq(conf);
 		conf->quiesce = 0;
 		wake_up(&conf->wait_for_quiescent);
-		wake_up(&conf->wait_for_overlap);
+		wake_up(&conf->wait_for_reshape);
 		unlock_all_device_hash_locks_irq(conf);
 	}
 	log_quiesce(conf, quiesce);
@@ -8944,7 +8944,7 @@ static void raid5_prepare_suspend(struct mddev *mddev)
 {
 	struct r5conf *conf = mddev->private;
 
-	wake_up(&conf->wait_for_overlap);
+	wake_up(&conf->wait_for_reshape);
 }
 
 static struct md_personality raid6_personality =
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 9b5a7dc3f2a0..896ecfc4afa6 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -668,7 +668,7 @@ struct r5conf {
 	struct llist_head	released_stripes;
 	wait_queue_head_t	wait_for_quiescent;
 	wait_queue_head_t	wait_for_stripe;
-	wait_queue_head_t	wait_for_overlap;
+	wait_queue_head_t	wait_for_reshape;
 	unsigned long		cache_state;
 	struct shrinker		*shrinker;
 	int			pool_size; /* number of disks in stripeheads in pool */
-- 
2.43.0

