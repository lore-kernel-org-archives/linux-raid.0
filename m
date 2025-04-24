Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBAB2206BE
	for <linux-raid@vger.kernel.org>; Thu, 24 Apr 2025 10:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745488869; cv=none; b=cgpuNnlNvRzWuH5iEouVOXW9etA6zCR5He8NSflnaDf8lPdq0iCTUPYXdHq0UiM09bNXINXkqcnvJQjcbblWxlcPIw/TJ9snYuxyoIQ65sRHNBG6SoHCmVZJCruSjLJ1CLNY8PTdpAJQ52qxbEOziuNIPq8tTU3PxdLAPgofPKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745488869; c=relaxed/simple;
	bh=oMafqd1aqE3llv8lymw9FkcehI7fr7DF8y4eTbBkSLA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g7NAgnIITjVSF4AldaZynVns1yRriT/BJdpnK/d9wkmkYRdoPN6fnVv2Q8ml7CW/K4jNvWL9ZHFwDiEFjwR/rOu8S/y3a5MY3EDH78+OgePBzJKnv0LniX0SPPi4hPm1AyiQrDD7dqSg6LzKMR5TTpPaLu0XzwpJ56yCh0/nXec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZsvI6tMI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZsvI6tMI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745488866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=18KX0KJX8g2jPwF2IotwoUikLmmg5x6Uqocp8QJr9Go=;
	b=ZsvI6tMI/5jttBgMdUTS1o5YmBdDO7+W7rvrXMoNpVTkydhsNFw7xW+28GYdk3ozooCkmY
	nsa2OTg+g+QRJwt0WvPwsvWOPiBCkikrx+R17Cb4HZZN1t1x1w0FM1C/6sOxOLHYKEh345
	RGsYQtfAVFBrxZa1qI+to9Af+G6hQ90=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-RZfrxgORPYaely1GuL1J1Q-1; Thu,
 24 Apr 2025 06:01:05 -0400
X-MC-Unique: RZfrxgORPYaely1GuL1J1Q-1
X-Mimecast-MFC-AGG-ID: RZfrxgORPYaely1GuL1J1Q_1745488864
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C1CA1956094;
	Thu, 24 Apr 2025 10:01:04 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.20])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ACD30180047F;
	Thu, 24 Apr 2025 10:01:00 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	hch@lst.de
Subject: [PATCH RFC 3/3] md: call del_gendisk in sync way
Date: Thu, 24 Apr 2025 18:00:44 +0800
Message-Id: <20250424100044.33564-4-xni@redhat.com>
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

Now del_gendisk and put_disk are called asynchronously in workqueue work.
The asynchronous way also has a problem that the device node can still
exist after mdadm --stop command returns in a short window. So udev rule
can open this device node and create the struct mddev in kernel again.

So put del_gendisk in ioctl path and still leave put_disk in
md_kobj_release to avoid uaf.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 455792834e53..1607cd703c75 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5724,11 +5724,16 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
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
@@ -5737,6 +5742,10 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 	spin_unlock(&all_mddevs_lock);
 	rv = entry->store(mddev, page, length);
 	mddev_put(mddev);
+
+	if (kn)
+		sysfs_unbreak_active_protection(kn);
+
 	return rv;
 }
 
@@ -5749,7 +5758,6 @@ static void md_kobj_release(struct kobject *ko)
 	if (mddev->sysfs_level)
 		sysfs_put(mddev->sysfs_level);
 
-	del_gendisk(mddev->gendisk);
 	put_disk(mddev->gendisk);
 }
 
@@ -6600,6 +6608,7 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		md_clean(mddev);
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
+		del_gendisk(mddev->gendisk);
 	}
 	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
-- 
2.32.0 (Apple Git-132)

