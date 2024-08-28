Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAF79460
	for <linux-raid@vger.kernel.org>; Wed, 28 Aug 2024 02:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724811525; cv=none; b=FFDVaewYMbT9TW/eJLfTJoy//GOt65hNY0X3HxDIhmCXT9senCW8U5uWOKXnaKe3GHVzZEaWi/xtqpJ6x68LCxrNZvNY7v129Tl6+gOfl/YUC+WgfeC6EO6N6PdBt0ilFU9TXLDqJ9zfclGO+GyN42hvinFFTmPh3A/pjXr9Nz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724811525; c=relaxed/simple;
	bh=69wjdb+KDoCEHvF0hI7F7hhO/KTlSqSObygQF5LZ4P0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gQxKEOgudhujD6plITtJ5qE7gS13ELGr+aeBkUMmb/in1M1YiF/U8VEQSI92j1oCndvfIUJjajcj0BKFPJfOdk1lW+3ovI4BZSKEAAiBQXwc9WiGUQFzzLxjtZav4W+7cNXdBoRfTvgBMfVPkefU5eKaVotAPtwIDzL+kT7vnyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GW8ZrMHU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GW8ZrMHU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724811523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IXH6aFjOf2uZfZMqTedbSRaoECxjBNHjcUUtfgwzeNU=;
	b=GW8ZrMHUErH8dNflv+0ICu7WEmGNrxcJWjyZeLtS3CdwZspZNwQVCdRC8AQK5gpzgWmebQ
	/q52lTxIbKRWumE5/yv0j6qjmyJ6pZuKX49Qr9L7pM4Av2PNEXL8p8iamJMKLavsKDNhS1
	G4a7t/fyfMFvxa1CVpSa/T/qi91pKj0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-150-BGCYiUOzN4aNYtZT8fr2tg-1; Tue,
 27 Aug 2024 22:18:39 -0400
X-MC-Unique: BGCYiUOzN4aNYtZT8fr2tg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B8D1F1955BF6;
	Wed, 28 Aug 2024 02:18:37 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C72A13001FF9;
	Wed, 28 Aug 2024 02:18:34 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com
Subject: [PATCH md-6.12 1/1] md: add new_level sysfs interface
Date: Wed, 28 Aug 2024 10:18:28 +0800
Message-Id: <20240828021828.63447-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

This interface is used to updating new level during reshape progress.
Now it doesn't update new level during reshape. So it can't know the
new level when systemd service mdadm-grow-continue runs. And it can't
finally change to new level.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d3a837506a36..c639eca03df9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4141,6 +4141,34 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_level =
 __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
 
+static ssize_t
+new_level_show(struct mddev *mddev, char *page)
+{
+	return sprintf(page, "%d\n", mddev->new_level);
+}
+
+static ssize_t
+new_level_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	unsigned int n;
+	int err;
+
+	err = kstrtouint(buf, 10, &n);
+	if (err < 0)
+		return err;
+	err = mddev_lock(mddev);
+	if (err)
+		return err;
+
+	mddev->new_level = n;
+	md_update_sb(mddev, 1);
+
+	mddev_unlock(mddev);
+	return err ?: len;
+}
+static struct md_sysfs_entry md_new_level =
+__ATTR(new_level, 0664, new_level_show, new_level_store);
+
 static ssize_t
 layout_show(struct mddev *mddev, char *page)
 {
@@ -5666,6 +5694,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
 
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
+	&md_new_level.attr,
 	&md_layout.attr,
 	&md_raid_disks.attr,
 	&md_uuid.attr,
-- 
2.32.0 (Apple Git-132)

