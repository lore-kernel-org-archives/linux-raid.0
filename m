Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109345505EE;
	Tue, 22 Sep 2026 14:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086993; cv=none; b=oXDrdciDAALvD15QpiLXaPBWC7P6iYimSUuzHbVMc21ZDZ5vkVXh/utqIovVeCBnnI0zuTlY1z7x1j5xcQeBNFwffptvIx9VGANuX4w9/L1dsZpFMGOebsrl//dAVMxR3hVmLWebOMfqTEMkg6CXw2vBMAYX5Gb7FIwCsWw5d6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086993; c=relaxed/simple;
	bh=yf55lsz/Qpc0fAky6f3bM9lMSDqg6+yDnLOFCJ338jY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g//74wqRp29xAy3m/EA7MgZCYeirkXnCksxXhDRKxp1bkmbf/h/13pSQgzhmfhhak2W7KNm8nU5lOqCGhNr6UGRJhRlhrshAXEqnkne4MKfE/6TlD+1Zaq1CZ0qw5Dw5lAT0TRkHiT0VvhKvHXbWMWoY3hyP74hKHAJ7kXCe/IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=i8+hJARz; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="i8+hJARz"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ivxyXF6RfyoDHF012OJks5Rfv96pLgde3fMDEfCpsNw=;
	b=i8+hJARzn0STXcQg0R5Z/rXP8PQkIIW31GaAN8054Wa38szF9NhmoAD5eA9tk/oq/PalmQAL/
	QARNYUf86di1t8nBNfIjn9+vJas9GOgxQYk/ZQSPml88hXVbMk7MAVij/jrBxcHfYIpsHb1jBZ1
	TKEi3F+eqR9yaaEqLscRCjs=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hq27w1Y4bzpStW;
	Tue, 22 Sep 2026 22:11:08 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id B799B4058C;
	Tue, 22 Sep 2026 22:23:04 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200011.china.huawei.com
 (7.152.185.179) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 22 Sep
 2026 22:23:03 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <shli@kernel.org>, <neil@brown.name>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v2 2/4] md: Handle pers->run failure in level_store
Date: Tue, 22 Sep 2026 22:14:54 +0800
Message-ID: <20260922141456.738937-3-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260922141456.738937-1-chengzhihao1@huawei.com>
References: <20260922141456.738937-1-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemo200011.china.huawei.com (7.152.185.179)

Set 'raid_disks' after raid5_run() failure will trigger an
null-ptr-deref problem:
 BUG: kernel NULL pointer dereference, address: 0000000000000038
 RIP: 0010:raid5_check_reshape+0xad
 Call Trace:
  update_raid_disks+0x124
  raid_disks_store+0x145
  md_attr_store+0xd7
  sysfs_kf_write+0x7c

The trigger process is simple:
 mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda /dev/sdb
 --force --assume-clean # create raid1
 echo 5 > /sys/block/md0/md/level
  level_store
   mddev->pers = pers
   mddev->private = priv
   raid5_run
    fail to abort (eg. raid5_create_ctx_pool fails)
    mddev->private = NULL
 echo 10 > /sys/block/md0/md/raid_disks
  raid_disks_store
   if (mddev->pers) // true
    update_raid_disks
     raid5_check_reshape
      conf = mddev->private
       conf->algorithm = mddev->new_layout // null-ptr-deref !

Similar process exists in do_md_stop->__md_stop_writes->raid5_quiesce.
Similar process exists in raid10 too.

Fix it by handling the error from pers->run, next active-type order will
restart the mddev.

Fixes: 245f46c2c221e ("md: add ->takeover method to support changing the personality managing an array")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 drivers/md/md.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 02798f2dbf0e..fdadd5ff338d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -97,6 +97,7 @@ static struct workqueue_struct *md_misc_wq;
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
 static void mddev_detach(struct mddev *mddev);
+static void __md_stop(struct mddev *mddev);
 static void export_rdev(struct md_rdev *rdev);
 static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
 
@@ -4243,7 +4244,31 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->in_sync = 1;
 		timer_delete_sync(&mddev->safemode_timer);
 	}
-	pers->run(mddev);
+	rv = pers->run(mddev);
+	if (rv) {
+		/*
+		 * ->run() has released the private data of the new personality,
+		 * while the old one has already been released as well. There is
+		 * nothing to fall back to, so stop the array to avoid leaving
+		 * 'mddev->pers' pointing to a personality which has no private
+		 * data, and reminds user to try to active the mddev again.
+		 */
+		pr_warn("md: %s: failed to run %s after takeover, please try to active\n",
+			mdname(mddev), pers->head.name);
+		if (md_bitmap_enabled(mddev, true))
+			mddev->bitmap_ops->flush(mddev);
+		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
+		mddev_destroy_serial_pool(mddev, NULL);
+		__md_stop(mddev);
+		rdev_for_each(rdev, mddev)
+			if (rdev->raid_disk >= 0)
+				sysfs_unlink_rdev(mddev, rdev);
+		set_capacity_and_notify(mddev->gendisk, 0);
+		mddev->changed = 1;
+		md_new_event();
+		sysfs_notify_dirent_safe(mddev->sysfs_state);
+		goto out_unlock;
+	}
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	if (!mddev->thread)
 		md_update_sb(mddev, 1);
-- 
2.52.0

