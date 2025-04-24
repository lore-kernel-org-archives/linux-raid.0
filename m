Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4C82701B1
	for <linux-raid@vger.kernel.org>; Thu, 24 Apr 2025 10:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745488867; cv=none; b=UpSuB3jRHPJJU7Amn2MzzHYHHM9MOsrf7RCimm1SbhIc7eQEPYtFkefDnzoP5QehOw7Ce11qFhWtKjPSeLO4XoIjD0UA9isAcNRBkInoI6SUuaA2+sRpCnVnXE7rTuPq8+g9N64WUIe+lnThjdffyuO8cPZAR6VPVJaDIfv2oVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745488867; c=relaxed/simple;
	bh=p8+Cy22M97xvNP853iJcw7u2mjc1b9L/dJk3CwdfW7A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nOBLRVdg5vLMk2jsYCVTd5WfVn4MezMiNs0MZ0tnbpWzxk8wTmgIQ4D4ZyNGJVB3YH5zJeK/fRqojMHMXF+G3bVaoZTeXEbX2UfOs4Fu/n3FB2a+FjheZXGgk+MX21lquCW7L/4hSxlS70TmaTWzU1DHC/YXr9iWi9M9jzpSK/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fH0Vd8zB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fH0Vd8zB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745488864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Q9z9TrMif7etvZYSHiCpZHemv50tEi9zEQnEGv33l0=;
	b=fH0Vd8zBxZR/RlsUwgQM3w3fbBE0uTxKPlsgBavmbcvvuswKW+5VPQtBba2I/Ct/yFIfa8
	5wS8yHNahNSRQU/UMsqJg/60e/V9BsQCZbXKGDI80vC1YeO0B24z8fYvBzdKFJAizzXPIt
	kCTAfJGkkiiGzEMZThUp5Zd+Bfm7MD0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-282-70lNN3y4NRCFNuSemPzZvQ-1; Thu,
 24 Apr 2025 06:01:00 -0400
X-MC-Unique: 70lNN3y4NRCFNuSemPzZvQ-1
X-Mimecast-MFC-AGG-ID: 70lNN3y4NRCFNuSemPzZvQ_1745488859
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD95F1956096;
	Thu, 24 Apr 2025 10:00:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.20])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3C3CF180047F;
	Thu, 24 Apr 2025 10:00:55 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	hch@lst.de
Subject: [PATCH RFC 2/3] md: replace ->openers with ->active
Date: Thu, 24 Apr 2025 18:00:43 +0800
Message-Id: <20250424100044.33564-3-xni@redhat.com>
In-Reply-To: <20250424100044.33564-1-xni@redhat.com>
References: <20250424100044.33564-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

It only checks openers when stopping an array. But some users still can
access mddev through sysfs interfaces. Now ->active is added once mddev
is accessed which is done in function mddev_get protected by lock
all_mddevs_lock. They are md_open, md_seq_show, md_attr_show/store and
md_notify_reboot and md_exit.

->openers is only added in md_open while mddev_get is called too. So we
can replace ->openers with ->active. This can guarantee no one access the
array once MD_CLOSING is set.

At the same time, ->open_mutex is replaced with all_mddevs_lock. Though
all_mddevs_lock is a global lock, the only place checks ->active and sets
MD_CLOSING in ioctl path. So it doesn't affect performance.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 47 +++++++++++++++++------------------------------
 drivers/md/md.h | 11 -----------
 2 files changed, 17 insertions(+), 41 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3cfe26359d7e..455792834e53 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -523,18 +523,27 @@ void mddev_resume(struct mddev *mddev)
 EXPORT_SYMBOL_GPL(mddev_resume);
 
 /* sync bdev before setting device to readonly or stopping raid*/
-static int mddev_set_closing_and_sync_blockdev(struct mddev *mddev, int opener_num)
+static int mddev_set_closing_and_sync_blockdev(struct mddev *mddev)
 {
-	mutex_lock(&mddev->open_mutex);
-	if (mddev->pers && atomic_read(&mddev->openers) > opener_num) {
-		mutex_unlock(&mddev->open_mutex);
+	spin_lock(&all_mddevs_lock);
+
+	/*
+	 * there are two places that call this function and ->active
+	 * is added before calling this function. So the array can't
+	 *  be stopped when ->active is bigger than 1.
+	 */
+	if (mddev->pers && atomic_read(&mddev->active) > 1) {
+
+		spin_unlock(&all_mddevs_lock);
 		return -EBUSY;
 	}
+
 	if (test_and_set_bit(MD_CLOSING, &mddev->flags)) {
-		mutex_unlock(&mddev->open_mutex);
+		spin_unlock(&all_mddevs_lock);
 		return -EBUSY;
 	}
-	mutex_unlock(&mddev->open_mutex);
+
+	spin_unlock(&all_mddevs_lock);
 
 	sync_blockdev(mddev->gendisk->part0);
 	return 0;
@@ -663,7 +672,6 @@ int mddev_init(struct mddev *mddev)
 	/* We want to start with the refcount at zero */
 	percpu_ref_put(&mddev->writes_pending);
 
-	mutex_init(&mddev->open_mutex);
 	mutex_init(&mddev->reconfig_mutex);
 	mutex_init(&mddev->suspend_mutex);
 	mutex_init(&mddev->bitmap_info.mutex);
@@ -672,7 +680,6 @@ int mddev_init(struct mddev *mddev)
 	INIT_LIST_HEAD(&mddev->deleting);
 	timer_setup(&mddev->safemode_timer, md_safemode_timeout, 0);
 	atomic_set(&mddev->active, 1);
-	atomic_set(&mddev->openers, 0);
 	atomic_set(&mddev->sync_seq, 0);
 	spin_lock_init(&mddev->lock);
 	init_waitqueue_head(&mddev->sb_wait);
@@ -4421,8 +4428,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	case read_auto:
 		if (!mddev->pers || !md_is_rdwr(mddev))
 			break;
-		/* write sysfs will not open mddev and opener should be 0 */
-		err = mddev_set_closing_and_sync_blockdev(mddev, 0);
+		err = mddev_set_closing_and_sync_blockdev(mddev);
 		if (err)
 			return err;
 		break;
@@ -7745,7 +7751,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		/* Need to flush page cache, and ensure no-one else opens
 		 * and writes
 		 */
-		err = mddev_set_closing_and_sync_blockdev(mddev, 1);
+		err = mddev_set_closing_and_sync_blockdev(mddev);
 		if (err)
 			return err;
 	}
@@ -7945,7 +7951,6 @@ static int md_set_read_only(struct block_device *bdev, bool ro)
 static int md_open(struct gendisk *disk, blk_mode_t mode)
 {
 	struct mddev *mddev;
-	int err;
 
 	spin_lock(&all_mddevs_lock);
 	mddev = mddev_get(disk->private_data);
@@ -7953,25 +7958,8 @@ static int md_open(struct gendisk *disk, blk_mode_t mode)
 	if (!mddev)
 		return -ENODEV;
 
-	err = mutex_lock_interruptible(&mddev->open_mutex);
-	if (err)
-		goto out;
-
-	err = -ENODEV;
-	if (test_bit(MD_CLOSING, &mddev->flags))
-		goto out_unlock;
-
-	atomic_inc(&mddev->openers);
-	mutex_unlock(&mddev->open_mutex);
-
 	disk_check_media_change(disk);
 	return 0;
-
-out_unlock:
-	mutex_unlock(&mddev->open_mutex);
-out:
-	mddev_put(mddev);
-	return err;
 }
 
 static void md_release(struct gendisk *disk)
@@ -7979,7 +7967,6 @@ static void md_release(struct gendisk *disk)
 	struct mddev *mddev = disk->private_data;
 
 	BUG_ON(!mddev);
-	atomic_dec(&mddev->openers);
 	mddev_put(mddev);
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a9dccb3d84ed..60dc0943e05b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -496,19 +496,8 @@ struct mddev {
 	int				recovery_disabled;
 
 	int				in_sync;	/* know to not need resync */
-	/* 'open_mutex' avoids races between 'md_open' and 'do_md_stop', so
-	 * that we are never stopping an array while it is open.
-	 * 'reconfig_mutex' protects all other reconfiguration.
-	 * These locks are separate due to conflicting interactions
-	 * with disk->open_mutex.
-	 * Lock ordering is:
-	 *  reconfig_mutex -> disk->open_mutex
-	 *  disk->open_mutex -> open_mutex:  e.g. __blkdev_get -> md_open
-	 */
-	struct mutex			open_mutex;
 	struct mutex			reconfig_mutex;
 	atomic_t			active;		/* general refcount */
-	atomic_t			openers;	/* number of active opens */
 
 	int				changed;	/* True if we might need to
 							 * reread partition info */
-- 
2.32.0 (Apple Git-132)

