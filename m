Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F142309B6
	for <linux-raid@vger.kernel.org>; Wed, 11 Jun 2025 07:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749627087; cv=none; b=L72dQpM+MTZmi5L7cwzk80/kJ0af3ywyV6EbhHkfJJnJFm2XFtNVGuOPwojc6OAuPg1hu6LZjSIeMgAQFVtSCcohWQNd0mOCEQAV8z3Q7xNTfd8dIVMVo+UKM/qPWUlcQpPmst6Ia4tmbLdAfBoF2mzviW7Vp9Q63Xhftd2bzL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749627087; c=relaxed/simple;
	bh=v7tcmurZ7WY91VkaGXzQGHNoNiSUI4/DOH5m7u79kSA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bHRxrXFq2gxmRaonxhhvfu+Tq6Id51lsNQdP7O+ZvbR/a9Rk0j/EX8UTRj/UBZTeACpM7kc3qAy/JZLFFwE625AuZc17VXxiL+bBS6PEfeQ16S3+mGr6tYZLZfr6cX97MiuZoJ98m7d5rzlx7eGZDXhVO1uEbFT830ARU/8F/K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FZFixkkF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FZFixkkF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749627084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xFnCYlqmty1rPvE1Rq7D3fgqud6RxvAFoncAeDbL/SI=;
	b=FZFixkkFPyyi4nxaqWwKWQLzsteDTkFNVL6dQ3g9r0bNZ6Fyg6oKen1IEvbyIqNcSzWzES
	/R2ZbIs1b2B2hLKMrlpJJPhAq6CSRCO/Ob6zufjMc/D8P8Kxk53FL+mNO0q5RNlsIeCrCw
	vmfs8auIPcjXvX2tQQbbwarGM9ut/70=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-171-Haf_hKxpMuCW9Xm-g8ouSQ-1; Wed,
 11 Jun 2025 03:31:19 -0400
X-MC-Unique: Haf_hKxpMuCW9Xm-g8ouSQ-1
X-Mimecast-MFC-AGG-ID: Haf_hKxpMuCW9Xm-g8ouSQ_1749627078
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20857195608B;
	Wed, 11 Jun 2025 07:31:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.30])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C2258180045B;
	Wed, 11 Jun 2025 07:31:14 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	ncroxon@redhat.com,
	song@kernel.org,
	yukuai1@huaweicloud.com
Subject: [PATCH 1/3] md: call del_gendisk in control path
Date: Wed, 11 Jun 2025 15:31:06 +0800
Message-Id: <20250611073108.25463-2-xni@redhat.com>
In-Reply-To: <20250611073108.25463-1-xni@redhat.com>
References: <20250611073108.25463-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Now del_gendisk and put_disk are called asynchronously in workqueue work.
The asynchronous way has a problem that the device node can still exist
after mdadm --stop command returns in a short window. So udev rule can
open this device node and create the struct mddev in kernel again. So put
del_gendisk in control path and still leave put_disk in md_kobj_release
to avoid uaf of gendisk.

Function del_gendisk can't be called with reconfig_mutex. If it's called
with reconfig mutex, a deadlock can happen. del_gendisk waits all sysfs
files access to finish and sysfs file access waits reconfig mutex. So
put del_gendisk after releasing reconfig mutex.

But there is still a window that sysfs can be accessed between mddev_unlock
and del_gendisk. So some actions (add disk, change level, .e.g) can happen
which lead unexpected results. MD_DELETED is used to resolve this problem.
MD_DELETED is set before releasing reconfig mutex and it should be checked
for these sysfs access which need reconfig mutex. For sysfs access which
don't need reconfig mutex, del_gendisk will wait them to finish.

But it doesn't need to do this in function mddev_lock_nointr. There are
ten places that call it.
* Five of them are in dm raid which we don't need to care. MD_DELETED is
only used for md raid.
* stop_sync_thread, md_do_sync and md_start_sync are related sync request,
and it needs to wait sync thread to finish before stopping an array.
* md_ioctl: md_open is called before md_ioctl, so ->openers is added. It
will fail to stop the array. So it doesn't need to check MD_DELETED here
* md_set_readonly:
It needs to call mddev_set_closing_and_sync_blockdev when setting readonly
or read_auto. So it will fail to stop the array too because MD_CLOSING is
already set.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 33 +++++++++++++++++++++++----------
 drivers/md/md.h | 26 ++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0f03b21e66e4..7445e44eabff 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -636,9 +636,6 @@ static void __mddev_put(struct mddev *mddev)
 	    mddev->ctime || mddev->hold_active)
 		return;
 
-	/* Array is not configured at all, and not held active, so destroy it */
-	set_bit(MD_DELETED, &mddev->flags);
-
 	/*
 	 * Call queue_work inside the spinlock so that flush_workqueue() after
 	 * mddev_find will succeed in waiting for the work to be done.
@@ -873,6 +870,16 @@ void mddev_unlock(struct mddev *mddev)
 		kobject_del(&rdev->kobj);
 		export_rdev(rdev, mddev);
 	}
+
+	/* Call del_gendisk after release reconfig_mutex to avoid
+	 * deadlock (e.g. call del_gendisk under the lock and an
+	 * access to sysfs files waits the lock)
+	 * And MD_DELETED is only used for md raid which is set in
+	 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
+	 * doesn't need to check MD_DELETED when getting reconfig lock
+	 */
+	if (test_bit(MD_DELETED, &mddev->flags))
+		del_gendisk(mddev->gendisk);
 }
 EXPORT_SYMBOL_GPL(mddev_unlock);
 
@@ -5774,19 +5781,30 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
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
 
@@ -5794,12 +5812,6 @@ static void md_kobj_release(struct kobject *ko)
 {
 	struct mddev *mddev = container_of(ko, struct mddev, kobj);
 
-	if (mddev->sysfs_state)
-		sysfs_put(mddev->sysfs_state);
-	if (mddev->sysfs_level)
-		sysfs_put(mddev->sysfs_level);
-
-	del_gendisk(mddev->gendisk);
 	put_disk(mddev->gendisk);
 }
 
@@ -6646,8 +6658,9 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		mddev->bitmap_info.offset = 0;
 
 		export_array(mddev);
-
 		md_clean(mddev);
+		set_bit(MD_DELETED, &mddev->flags);
+
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
 	}
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d45a9e6ead80..67b365621507 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -700,11 +700,26 @@ static inline bool reshape_interrupted(struct mddev *mddev)
 
 static inline int __must_check mddev_lock(struct mddev *mddev)
 {
-	return mutex_lock_interruptible(&mddev->reconfig_mutex);
+	int ret;
+
+	ret = mutex_lock_interruptible(&mddev->reconfig_mutex);
+
+	/* MD_DELETED is set in do_md_stop with reconfig_mutex.
+	 * So check it here.
+	 */
+	if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
+		ret = -ENODEV;
+		mutex_unlock(&mddev->reconfig_mutex);
+	}
+
+	return ret;
 }
 
 /* Sometimes we need to take the lock in a situation where
  * failure due to interrupts is not acceptable.
+ * It doesn't need to check MD_DELETED here, the owner which
+ * holds the lock here can't be stopped. And all paths can't
+ * call this function after do_md_stop.
  */
 static inline void mddev_lock_nointr(struct mddev *mddev)
 {
@@ -713,7 +728,14 @@ static inline void mddev_lock_nointr(struct mddev *mddev)
 
 static inline int mddev_trylock(struct mddev *mddev)
 {
-	return mutex_trylock(&mddev->reconfig_mutex);
+	int ret;
+
+	ret = mutex_trylock(&mddev->reconfig_mutex);
+	if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
+		ret = -ENODEV;
+		mutex_unlock(&mddev->reconfig_mutex);
+	}
+	return ret;
 }
 extern void mddev_unlock(struct mddev *mddev);
 
-- 
2.32.0 (Apple Git-132)

