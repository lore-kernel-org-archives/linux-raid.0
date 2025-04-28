Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDFC3C3C
	for <linux-raid@vger.kernel.org>; Mon, 28 Apr 2025 08:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745828829; cv=none; b=GX/6KD1C+C8KaKgkOfnSXkmTccGd71MTt+vtdjbEX4S244s4tApI0DVz1CFGi99K4jxH6oUyU3Y9XxccEQ+nWD6yVdvkpOM6eYYkeSz/1gXGRVwTjt7C8xleHGL7JdCYlqlhn91d8YjHdf9lrB0uCuY5rQRIDW4XCAps6JSD22k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745828829; c=relaxed/simple;
	bh=OF9o1WA4pjas3yZB7iU2lyhi65upw21OdhTgISOcb6w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nv11MlAo8h4SCT6E1zMAW8ZP7n8k/3uDWDbXRKNZdrsdXnqe4Tcn/r22PNzYRd05tdsfSCKAjaMYWhFsjbekdmXyT3W7T60Q0mk2GL755SQp+yo8UnBbKUBAkJXc6Tfsw3JOwD05fwRdU3CGjqgbQVvaCVT+oFfb0Hp0dZ4tftA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hciLXtLp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hciLXtLp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745828826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0LI6P1qJUAI47XmABjzNo+mTJwb3B0H2bRUs5HMPZVI=;
	b=hciLXtLp4dZv0baMJpDBOB7P7TaLlaYgPkQvLJHX/0ys3m6Fw0I++1upAf85hj9gk0O0dO
	ILSOe92a/4a/NSA7N4VpPZSPreSrdmcPOqLiU+n5G2t7aLlg5QMMxNPOywWNkEptmt47xo
	5tIbQGn6PL/rHvGpUwok7oXLuR10esc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-536-BaApxreSOrSsqLoMrGY-ug-1; Mon,
 28 Apr 2025 04:27:02 -0400
X-MC-Unique: BaApxreSOrSsqLoMrGY-ug-1
X-Mimecast-MFC-AGG-ID: BaApxreSOrSsqLoMrGY-ug_1745828821
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53CDD180034A;
	Mon, 28 Apr 2025 08:27:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 099BA18001DA;
	Mon, 28 Apr 2025 08:26:57 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	mtkaczyk@kernel.org
Subject: [PATCH 3/3] md: call del_gendisk in sync way
Date: Mon, 28 Apr 2025 16:26:41 +0800
Message-Id: <20250428082641.45027-4-xni@redhat.com>
In-Reply-To: <20250428082641.45027-1-xni@redhat.com>
References: <20250428082641.45027-1-xni@redhat.com>
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
 drivers/md/md.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4ca3d04ce13f..0c921072ffff 100644
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
 
@@ -6591,8 +6599,8 @@ static int do_md_stop(struct mddev *mddev, int mode)
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

