Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA05E30C37B;
	Mon,  3 Nov 2025 13:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762175178; cv=none; b=VWkawTILzoWanXU66qCPsYlvOHWzftJW2KC+ahJWo/GVk9/zfOSM8GR4C66uETLsZJhQhKTlX2NSNEsOCu2hvAHekLQxpXfm8WfAfOmpZ0tcshGjQgldXfY7KAcrAgRz0WYhJa/dLO28yFnewPwS5R3A56oFpda3ObWuInZi7Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762175178; c=relaxed/simple;
	bh=jEYk7IoOCUlwQqplPMVYUiRApi1kbzCpFpscGepfb/g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HeP54iJgqp6t4QU6vYYbCm8Qnvjvhc9RHgPiwfzDxM8ezB6iafKE8A2HVkJ9qntELpLQPoasXBC7XmItxofMichNwF+M0hGrSCQwJAo/G92m55UI+g3P01CVHZgEqc9eYXoSOl17BduWbWDa95a9jbJdMObdlQGLApfd+H8lkSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d0Wzz1zCkzKHMKp;
	Mon,  3 Nov 2025 21:06:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 915C01A0D7D;
	Mon,  3 Nov 2025 21:06:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgCHK0TCqAhp+jFMCg--.19557S6;
	Mon, 03 Nov 2025 21:06:11 +0800 (CST)
From: linan666@huaweicloud.com
To: corbet@lwn.net,
	song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v9 2/5] md: init bioset in mddev_init
Date: Mon,  3 Nov 2025 20:57:54 +0800
Message-Id: <20251103125757.1405796-3-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251103125757.1405796-1-linan666@huaweicloud.com>
References: <20251103125757.1405796-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCHK0TCqAhp+jFMCg--.19557S6
X-Coremail-Antispam: 1UD129KBjvJXoWxWw4kAF1ftr4DGFy3Cr1fCrg_yoWrtw1xpa
	yxXas5Kr4kJrWag347JF1v93WrXr1xtFZrtrW7Wrn5Aa1Syr4UG3WYgF48ZFykG3ykCa15
	Ww1rJFW3WF15ur7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8
	ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr
	0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUHnQUUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

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

mddev_init() can only be called once per mddev, no need to test if bioset
has been initialized anymore.

Fixes: d981ed841930 ("md: Add new_level sysfs interface")
Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 69 +++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f6fd55a1637b..dffc6a482181 100644
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
@@ -741,10 +743,23 @@ int mddev_init(struct mddev *mddev)
 
 	if (percpu_ref_init(&mddev->writes_pending, no_op,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
-		percpu_ref_exit(&mddev->active_io);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto exit_acitve_io;
 	}
 
+	err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
+	if (err)
+		goto exit_writes_pending;
+
+	err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
+	if (err)
+		goto exit_bio_set;
+
+	err = bioset_init(&mddev->io_clone_set, BIO_POOL_SIZE,
+			  offsetof(struct md_io_clone, bio_clone), 0);
+	if (err)
+		goto exit_sync_set;
+
 	/* We want to start with the refcount at zero */
 	percpu_ref_put(&mddev->writes_pending);
 
@@ -773,11 +788,24 @@ int mddev_init(struct mddev *mddev)
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
@@ -6393,29 +6421,9 @@ int md_run(struct mddev *mddev)
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
@@ -6426,8 +6434,7 @@ int md_run(struct mddev *mddev)
 	    pers->start_reshape == NULL) {
 		/* This personality cannot handle reshaping... */
 		put_pers(pers);
-		err = -EINVAL;
-		goto abort;
+		return -EINVAL;
 	}
 
 	if (pers->sync_request) {
@@ -6554,12 +6561,6 @@ int md_run(struct mddev *mddev)
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
@@ -6784,10 +6785,6 @@ static void __md_stop(struct mddev *mddev)
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

