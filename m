Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9414219ED
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 02:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746584080; cv=none; b=S8gxRf37gmmJaw0GxnFFchXGbRgpUy2Px+CBlZ/gHG0/RYyjYw3+Y4/S3OFZayZR/wMM8KqsQAguL9wv1lqoDoMt7UzCfOJhVtVS1pgGWxNKjiV9b06m8oEbmK0LMlI/eICjumIiPtOgqmjxE2gJ3HNZAe4xwU8dcRT7JH059Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746584080; c=relaxed/simple;
	bh=i/6JYunIQGbgJCAg0mnGfAAzTzRtl1jxMZw5EDMNgFY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fMd9o6nvv/KOtRyAeo23r2x3q1WzAqhGaKB4eRMuhfJsEK6YBVOBV5ritrZLMdF0ietZJcWjp//uFwGyB9RH0iaappdOjcUMKWtJ8RJIgTctOHUu5XgDivqDZuVsZsSjLWYhDfGDWC7NksL8lmFVnvRWGkEgWAcXEG25FNbT6UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aRkkN69l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aRkkN69l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746584076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lK45K3BhApyotANEPOomCjCIuoFqpYiL41Ec+BZ+loA=;
	b=aRkkN69lbubiSxEFk3ObXAIj46m7nLkX295Wd0bkq+ZR9ckqirK1oztO0D2IoFU0E3QBDY
	OGi8hP82oGWfykfER6fqg+5s3k6Yo0xgttvbm2Gk0bJeYxcOfwge9L0yITyC3qKbCiCamr
	3X6uGLs3n2vOgJhQbyiyMUghlOrw1WI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-235-SnZ0RBohOlGd_0_75uqIFw-1; Tue,
 06 May 2025 22:14:32 -0400
X-MC-Unique: SnZ0RBohOlGd_0_75uqIFw-1
X-Mimecast-MFC-AGG-ID: SnZ0RBohOlGd_0_75uqIFw_1746584071
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C43CE1954ADA;
	Wed,  7 May 2025 02:14:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 24FE81800352;
	Wed,  7 May 2025 02:14:28 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com
Subject: [PATCH 3/3] md: call del_gendisk in sync way
Date: Wed,  7 May 2025 10:14:15 +0800
Message-Id: <20250507021415.14874-4-xni@redhat.com>
In-Reply-To: <20250507021415.14874-1-xni@redhat.com>
References: <20250507021415.14874-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Now del_gendisk and put_disk are called asynchronously in workqueue work.
The asynchronous way also has a problem that the device node can still
exist after mdadm --stop command returns in a short window. So udev rule
can open this device node and create the struct mddev in kernel again.

So put del_gendisk in ioctl path and still leave put_disk in
md_kobj_release to avoid uaf.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c226747be9e3..a82778f6c31f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5718,19 +5718,30 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
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
+		if (kn)
+			sysfs_unbreak_active_protection(kn);
 		spin_unlock(&all_mddevs_lock);
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
 
@@ -5743,7 +5754,6 @@ static void md_kobj_release(struct kobject *ko)
 	if (mddev->sysfs_level)
 		sysfs_put(mddev->sysfs_level);
 
-	del_gendisk(mddev->gendisk);
 	put_disk(mddev->gendisk);
 }
 
@@ -6585,8 +6595,8 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		mddev->bitmap_info.offset = 0;
 
 		export_array(mddev);
-
 		md_clean(mddev);
+		del_gendisk(mddev->gendisk);
 	}
 	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
-- 
2.32.0 (Apple Git-132)

