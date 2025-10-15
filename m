Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3543043C6;
	Wed, 15 Oct 2025 08:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760515874; cv=none; b=mD6OTFro/vwcHY+xuH7Xk38h8Kr6j919o6Cy4LsSaYzeDQRv+qPVy60dVtXufcHli7Jm+045tmrPqszxdWjonmmkagRTmeM1cGBDoEfvt7sMOHk/v4TN5rKIGSj0aEA/hsiRtM88cCKSvQa+4mo5u3/wBqgVHJN+c5nyKBQNOr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760515874; c=relaxed/simple;
	bh=Etr9Y2VE7/01GdzNtlmFagLDPukouE088tXY7mskSlo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c0qNjmQw1/1rJ4VuYvI3fXD3mGmdJNIGLXNYK+madyC/GlfTI64y+O7zOIUe1G1/RMmIq5DK7fc573699gK695QIfVLwLh4iUU5zgoiCjQ0JoXK6oB/CumPgWl34q815IJRPEE3PDypqmYXugz9UDUSfH1M4hHZ0SJ38gyzZ550=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=cjxTj+vh; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="cjxTj+vh"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=N4e7i6chQ4TVjuwXTg7dTnhyUJmzd3fmwSf1kKePOrw=;
	b=cjxTj+vhwpqch/C7a0gRA34oPLr4ukmEo8I7K/rMGPNxtE/hOejCiThEuV6I2d6JnXHMgy9ye
	t9dCus5hBYQAa3OEz5fZ2+gKJEZlBCy+VJk1bxclHIz30oM0wjkLDlrjShnQsd3gBo8CC6K9yEO
	iz4tZ0HkdsmzgRvH8xF8ZCc=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4cmkL21H1QzmV66;
	Wed, 15 Oct 2025 16:10:50 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 6911A140338;
	Wed, 15 Oct 2025 16:11:10 +0800 (CST)
Received: from kwepemn500011.china.huawei.com (7.202.194.152) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Oct 2025 16:10:59 +0800
Received: from huawei.com (10.50.87.129) by kwepemn500011.china.huawei.com
 (7.202.194.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 15 Oct
 2025 16:10:58 +0800
From: <linan122@huawei.com>
To: <corbet@lwn.net>, <song@kernel.org>, <yukuai3@huawei.com>,
	<linan122@huawei.com>, <xni@redhat.com>, <hare@suse.de>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <martin.petersen@oracle.com>,
	<linan666@huaweicloud.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH -next v7 2/4] md: init bioset in mddev_init
Date: Wed, 15 Oct 2025 16:03:52 +0800
Message-ID: <20251015080354.3398457-3-linan122@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251015080354.3398457-1-linan122@huawei.com>
References: <20251015080354.3398457-1-linan122@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemn500011.china.huawei.com (7.202.194.152)

From: Li Nan <linan122@huawei.com>

IO operations may be needed before md_run(), such as updating metadata
after writing sysfs. Without bioset, this triggers a NULL pointer
dereference as below:

 BUG: kernel NULL pointer dereference, address: 0000000000000020
 Call Trace:
  md_update_sb+0x658/0xe00
  new_level_store+0xc5/0x120
  md_attr_store+0xc9/0x1e0
  sysfs_kf_write+0x6f/0xa0
  kernfs_fop_write_iter+0x141/0x2a0
  vfs_write+0x1fc/0x5a0
  ksys_write+0x79/0x180
  __x64_sys_write+0x1d/0x30
  x64_sys_call+0x2818/0x2880
  do_syscall_64+0xa9/0x580
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

Reproducer
```
  mdadm -CR /dev/md0 -l1 -n2 /dev/sd[cd]
  echo inactive > /sys/block/md0/md/array_state
  echo 10 > /sys/block/md0/md/new_level
```

Fixes: d981ed841930 ("md: Add new_level sysfs interface")
Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 74 +++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 852383a9143d..d0aa8e6339f2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -730,6 +730,8 @@ static void mddev_clear_bitmap_ops(struct mddev *mddev)
 
 int mddev_init(struct mddev *mddev)
 {
+	int err = 0;
+
 	if (!IS_ENABLED(CONFIG_MD_BITMAP))
 		mddev->bitmap_id = ID_BITMAP_NONE;
 	else
@@ -741,8 +743,26 @@ int mddev_init(struct mddev *mddev)
 
 	if (percpu_ref_init(&mddev->writes_pending, no_op,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
-		percpu_ref_exit(&mddev->active_io);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto exit_acitve_io;
+	}
+
+	if (!bioset_initialized(&mddev->bio_set)) {
+		err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
+		if (err)
+			goto exit_writes_pending;
+	}
+	if (!bioset_initialized(&mddev->sync_set)) {
+		err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
+		if (err)
+			goto exit_bio_set;
+	}
+
+	if (!bioset_initialized(&mddev->io_clone_set)) {
+		err = bioset_init(&mddev->io_clone_set, BIO_POOL_SIZE,
+				  offsetof(struct md_io_clone, bio_clone), 0);
+		if (err)
+			goto exit_sync_set;
 	}
 
 	/* We want to start with the refcount at zero */
@@ -773,11 +793,24 @@ int mddev_init(struct mddev *mddev)
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
 
 	return 0;
+
+exit_sync_set:
+	bioset_exit(&mddev->sync_set);
+exit_bio_set:
+	bioset_exit(&mddev->bio_set);
+exit_writes_pending:
+	percpu_ref_exit(&mddev->writes_pending);
+exit_acitve_io:
+	percpu_ref_exit(&mddev->active_io);
+	return err;
 }
 EXPORT_SYMBOL_GPL(mddev_init);
 
 void mddev_destroy(struct mddev *mddev)
 {
+	bioset_exit(&mddev->bio_set);
+	bioset_exit(&mddev->sync_set);
+	bioset_exit(&mddev->io_clone_set);
 	percpu_ref_exit(&mddev->active_io);
 	percpu_ref_exit(&mddev->writes_pending);
 }
@@ -6391,29 +6424,9 @@ int md_run(struct mddev *mddev)
 		nowait = nowait && bdev_nowait(rdev->bdev);
 	}
 
-	if (!bioset_initialized(&mddev->bio_set)) {
-		err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
-		if (err)
-			return err;
-	}
-	if (!bioset_initialized(&mddev->sync_set)) {
-		err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
-		if (err)
-			goto exit_bio_set;
-	}
-
-	if (!bioset_initialized(&mddev->io_clone_set)) {
-		err = bioset_init(&mddev->io_clone_set, BIO_POOL_SIZE,
-				  offsetof(struct md_io_clone, bio_clone), 0);
-		if (err)
-			goto exit_sync_set;
-	}
-
 	pers = get_pers(mddev->level, mddev->clevel);
-	if (!pers) {
-		err = -EINVAL;
-		goto abort;
-	}
+	if (!pers)
+		return -EINVAL;
 	if (mddev->level != pers->head.id) {
 		mddev->level = pers->head.id;
 		mddev->new_level = pers->head.id;
@@ -6424,8 +6437,7 @@ int md_run(struct mddev *mddev)
 	    pers->start_reshape == NULL) {
 		/* This personality cannot handle reshaping... */
 		put_pers(pers);
-		err = -EINVAL;
-		goto abort;
+		return -EINVAL;
 	}
 
 	if (pers->sync_request) {
@@ -6552,12 +6564,6 @@ int md_run(struct mddev *mddev)
 	mddev->private = NULL;
 	put_pers(pers);
 	md_bitmap_destroy(mddev);
-abort:
-	bioset_exit(&mddev->io_clone_set);
-exit_sync_set:
-	bioset_exit(&mddev->sync_set);
-exit_bio_set:
-	bioset_exit(&mddev->bio_set);
 	return err;
 }
 EXPORT_SYMBOL_GPL(md_run);
@@ -6782,10 +6788,6 @@ static void __md_stop(struct mddev *mddev)
 	mddev->private = NULL;
 	put_pers(pers);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-
-	bioset_exit(&mddev->bio_set);
-	bioset_exit(&mddev->sync_set);
-	bioset_exit(&mddev->io_clone_set);
 }
 
 void md_stop(struct mddev *mddev)
-- 
2.39.2

