Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA9D49DBA2;
	Wed, 23 Sep 2026 11:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790163024; cv=none; b=fPY3ZZY+Uo8P9GRegfzsf/gTwWZrwKj1nvvASqUm6o8R1pHMCuKQIlwySBwpnbvCX1bmj+CFO8xDLYUtA9oJCIrYHAfTYT3qwyC66tehg7NYxHpB4W2sBB+PKaAmec6R9rNSQc5LHdO7LzyTvkLee7ikk9xfxDXPhco2I5M9uT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790163024; c=relaxed/simple;
	bh=rDJejpPKVo/7tCf1oOKnq12CHwC0MbZSZwXFEt1f6eI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O+MPao4ClyvTuhvP5KGhZ5OMpwSCOPUUHwYf2fZuehvE3cRXJ/tKjN+Gw2E0hCWg7GnH5e6Y7YL2bpOfg6VLaBJbEO+vpfoqkOtynp+mqPNKZYfeIWGkSZPsejnCkL9P8+apGUzoO1yFJRbdYpd82ttQ6geyhvjqy6iax0FjpcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=HwCuWSQI; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="HwCuWSQI"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pw+b9DOrnByKG8R8u4+XmrGaSLbdxBOCAmLtd4fdPmc=;
	b=HwCuWSQIhoR4uf3bz9afIOGX4ED6A6lxHOdiTcAO8j250BofjL/SSfGvJmItqKaphe/zqbUm4
	DYySC1SMlS9s4USBJSE51t5MVSv7JPfqNhSDAy7sV7uSWgo9VjQK5EiFmamPpiGEtW6L7Xor66p
	7hgs0ELkIzG6kAn5x/h9TKs=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hqZFm1rCTzLlSh;
	Wed, 23 Sep 2026 19:18:04 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id AFD2940580;
	Wed, 23 Sep 2026 19:30:09 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200011.china.huawei.com
 (7.152.185.179) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 23 Sep
 2026 19:30:08 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <shli@kernel.org>, <neil@brown.name>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v3 2/4] md: Handle pers->run failure in level_store
Date: Wed, 23 Sep 2026 19:21:56 +0800
Message-ID: <20260923112159.94175-3-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260923112159.94175-1-chengzhihao1@huawei.com>
References: <20260923112159.94175-1-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
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
 drivers/md/md.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 02798f2dbf0e..ff78bf8656ff 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -97,6 +97,7 @@ static struct workqueue_struct *md_misc_wq;
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
 static void mddev_detach(struct mddev *mddev);
+static void __md_stop(struct mddev *mddev);
 static void export_rdev(struct md_rdev *rdev);
 static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
 
@@ -4243,7 +4244,33 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
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
+		if (mddev->pers->sync_request && mddev->to_remove == NULL)
+			mddev->to_remove = &md_redundancy_group;
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

