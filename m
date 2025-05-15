Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2812874F6
	for <linux-raid@vger.kernel.org>; Thu, 15 May 2025 09:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747300145; cv=none; b=DtX24eK6zmV6tpea/4Ui9BZjPN05EMw2mTIFNn/bKNoLR2RaoQyGqvynWpPUVKOKqc80xZtj+6W74KGGhMxjuGVufUIE03gwv6itoXCTomIgSORT1N4N5N5HmWOD8kQMDIrlgH1qYi62G7hiSPq6oqz9fkOZuAvYKftzk8bohNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747300145; c=relaxed/simple;
	bh=efdJT8O8EL88zYVul3sE5Sv9AwTsPZZUAfXXHDeSSOM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i72CsVv87vM8vM/CURdkHejsCki9+vLy8fqWixQjoI2aI0YddJ5RvJgUG6Per03VoE9TZB9mBvdzM6q82Mw74SXa5PzNEm0E0XVnuxRaq2wcz39Oi221tYvMgsa4N+w6MFXgpLgtYh+pVHt6KU3a8dYFU27LIKPgva1F5hMzN5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xg1Nm8XB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xg1Nm8XB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747300142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F9bZ4C5tGbJ0mz8AvDeK00v2pORTrW1L+8dHUfZ7yP4=;
	b=Xg1Nm8XBfnJ58WgCinreXn5ajlIFrZcOXb5dAGaGXs+khkdieY0QeXNS5EkgEMgKqJCG7z
	t/4ei4w7CufEukpcqrqHit3TZbH1p0exPxj2Cd17kOrAloCQj1GeVpBuwuMGY5MXmSdPPR
	i1CcKz0HvS00Ogb75v+QGmRbCHPz9mM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-r7U9cBVvP_eBcVvLY0pqcQ-1; Thu,
 15 May 2025 05:08:59 -0400
X-MC-Unique: r7U9cBVvP_eBcVvLY0pqcQ-1
X-Mimecast-MFC-AGG-ID: r7U9cBVvP_eBcVvLY0pqcQ_1747300138
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3EB3218007E1;
	Thu, 15 May 2025 09:08:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.66.61.200])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EA0AC18008F4;
	Thu, 15 May 2025 09:08:55 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	song@kernel.org
Subject: [PATCH 2/2] md: call del_gendisk in control path
Date: Thu, 15 May 2025 17:08:47 +0800
Message-Id: <20250515090847.2356-3-xni@redhat.com>
In-Reply-To: <20250515090847.2356-1-xni@redhat.com>
References: <20250515090847.2356-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Now del_gendisk and put_disk are called asynchronously in workqueue work.
The asynchronous way also has a problem that the device node can still
exist after mdadm --stop command returns in a short window. So udev rule
can open this device node and create the struct mddev in kernel again.

So put del_gendisk in control path and still leave put_disk in
md_kobj_release to avoid uaf.

But there is a window that sysfs can be accessed between mddev_unlock and
del_gendisk. So some actions (add disk, change level, .e.g) can happen
which lead unexpected results. And if we delete MD_DELETED and only use
MD_CLOSING in stop control path, the sysfs files can't be accessed if
do_md_stop stuck when io hange. So we keep MD_DELETED here and set
MD_DELETED before mddev_unlock.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 53 ++++++++++++++++++++++++++++++++++++++++++-------
 drivers/md/md.h | 16 ++++++++++++++-
 2 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9b9950ed6ee9..a62867f34aa8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -606,15 +606,13 @@ static inline struct mddev *mddev_get(struct mddev *mddev)
 }
 
 static void mddev_delayed_delete(struct work_struct *ws);
+static bool can_delete_gendisk(struct mddev *mddev);
 
 static void __mddev_put(struct mddev *mddev)
 {
-	if (mddev->raid_disks || !list_empty(&mddev->disks) ||
-	    mddev->ctime || mddev->hold_active)
-		return;
 
-	/* Array is not configured at all, and not held active, so destroy it */
-	set_bit(MD_DELETED, &mddev->flags);
+	if (can_delete_gendisk(mddev) == false)
+		return;
 
 	/*
 	 * Call queue_work inside the spinlock so that flush_workqueue() after
@@ -4400,6 +4398,7 @@ array_state_show(struct mddev *mddev, char *page)
 	return sprintf(page, "%s\n", array_states[st]);
 }
 
+static void delete_gendisk(struct mddev *mddev);
 static int do_md_stop(struct mddev *mddev, int ro);
 static int md_set_readonly(struct mddev *mddev);
 static int restart_array(struct mddev *mddev);
@@ -4533,6 +4532,9 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	    (err && st == clear))
 		clear_bit(MD_CLOSING, &mddev->flags);
 
+	if ((st == clear || st == inactive) && !err)
+		delete_gendisk(mddev);
+
 	return err ?: len;
 }
 static struct md_sysfs_entry md_array_state =
@@ -5721,19 +5723,30 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 	struct md_sysfs_entry *entry = container_of(attr, struct md_sysfs_entry, attr);
 	struct mddev *mddev = container_of(kobj, struct mddev, kobj);
 	ssize_t rv;
+	struct kernfs_node *kn = NULL;
 
 	if (!entry->store)
 		return -EIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
+
+	if (entry->store == array_state_store && cmd_match(page, "clear"))
+		kn = sysfs_break_active_protection(kobj, attr);
+
 	spin_lock(&all_mddevs_lock);
 	if (!mddev_get(mddev)) {
 		spin_unlock(&all_mddevs_lock);
+		if (kn)
+			sysfs_unbreak_active_protection(kn);
 		return -EBUSY;
 	}
 	spin_unlock(&all_mddevs_lock);
 	rv = entry->store(mddev, page, length);
 	mddev_put(mddev);
+
+	if (kn)
+		sysfs_unbreak_active_protection(kn);
+
 	return rv;
 }
 
@@ -5746,7 +5759,6 @@ static void md_kobj_release(struct kobject *ko)
 	if (mddev->sysfs_level)
 		sysfs_put(mddev->sysfs_level);
 
-	del_gendisk(mddev->gendisk);
 	put_disk(mddev->gendisk);
 }
 
@@ -6526,6 +6538,28 @@ static int md_set_readonly(struct mddev *mddev)
 	return err;
 }
 
+static bool can_delete_gendisk(struct mddev *mddev)
+{
+	if (mddev->raid_disks || !list_empty(&mddev->disks) ||
+	    mddev->ctime || mddev->hold_active)
+		return false;
+
+	return true;
+}
+
+/* Call this function after do_md_stop with mode 0.
+ * And it can't call this function under reconfig_mutex to
+ * avoid deadlock(e.g. call del_gendisk under the lock and
+ * an access to sysfs files waits the lock)
+ */
+static void delete_gendisk(struct mddev *mddev)
+{
+	if (can_delete_gendisk(mddev) == false)
+		return;
+
+	del_gendisk(mddev->gendisk);
+}
+
 /* mode:
  *   0 - completely stop and dis-assemble array
  *   2 - stop but do not disassemble array
@@ -6588,8 +6622,8 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		mddev->bitmap_info.offset = 0;
 
 		export_array(mddev);
-
 		md_clean(mddev);
+		set_bit(MD_DELETED, &mddev->flags);
 	}
 	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
@@ -6616,6 +6650,7 @@ static void autorun_array(struct mddev *mddev)
 	if (err) {
 		pr_warn("md: do_md_run() returned %d\n", err);
 		do_md_stop(mddev, 0);
+		delete_gendisk(mddev);
 	}
 }
 
@@ -7886,6 +7921,10 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 out:
 	if (cmd == STOP_ARRAY_RO || (err && cmd == STOP_ARRAY))
 		clear_bit(MD_CLOSING, &mddev->flags);
+
+	if (cmd == STOP_ARRAY && err == 0)
+		delete_gendisk(mddev);
+
 	return err;
 }
 #ifdef CONFIG_COMPAT
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1cf00a04bcdd..45f1027986e4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -697,11 +697,25 @@ static inline bool reshape_interrupted(struct mddev *mddev)
 
 static inline int __must_check mddev_lock(struct mddev *mddev)
 {
-	return mutex_lock_interruptible(&mddev->reconfig_mutex);
+	int ret = 0;
+
+	ret = mutex_lock_interruptible(&mddev->reconfig_mutex);
+
+	/* MD_DELETED is set in do_md_stop with reconfig_mutex
+	 * So check it here also.
+	 */
+	if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
+		ret = -EBUSY;
+		mutex_unlock(&mddev->reconfig_mutex);
+	}
+
+	return ret;
 }
 
 /* Sometimes we need to take the lock in a situation where
  * failure due to interrupts is not acceptable.
+ * It doesn't need to check MD_DELETED here, the owner which
+ * holds the lock here can't be stopped.
  */
 static inline void mddev_lock_nointr(struct mddev *mddev)
 {
-- 
2.32.0 (Apple Git-132)

