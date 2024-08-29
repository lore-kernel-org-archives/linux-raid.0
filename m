Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D75156875
	for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 10:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724925710; cv=none; b=ZfPHn+mMg/TbsQ0RnS2s4VQ0OiWqypPIEP6rBRTO9bEPaHE78d2JlpPRwrBSzFYKVGdlT199HO4twCS+oEco22dBVigLFKQml2IlX9YgnNihnuhIKYU8f/KLHG/IXc6C4pNk5fuDjzY9GqW3XZSLJCULGM/wACERJUeTtttBSG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724925710; c=relaxed/simple;
	bh=65x5ehKovMyXUv9gWySpGll23DzEOL3kjilEVVSwmeI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rDjUXPjn6GzZRtu11V51tY3jS+dDiClZ0E8Nihoqomk6Gdu7iWEc4ydjAF8rqjKDDc03uPvhhEwUYCzTD22g20oOjD3ZJcux8egxuGX2YuVU3+ZfMrzXwvD2G5AxRllKWhIWxuIoioKaUD6kMRl/wNSpFldMfmFT7ga0bgGrxPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TLa2cbT/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TLa2cbT/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724925706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aKbYEblkEoJQoTvDJIMr3R1FM6cye7Zvq6GhlFX7/dQ=;
	b=TLa2cbT/b4yU6VGWODnz+sQV+3O555g8iAigU/WP8/RCM/5Lu0D6ZKglIknX+yGXiueXLJ
	vLcKEBYMAR3DnV8VuA5ntMz79KB/Top66tTbuWtkHbphNASYaN5yM5fEm13WA02p3pKmSF
	UKbsfDO4r7gurPhxqgk3NN60C+l1wq4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-tJzFUiYbP8i44in0cjlPXw-1; Thu,
 29 Aug 2024 06:01:43 -0400
X-MC-Unique: tJzFUiYbP8i44in0cjlPXw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B93701955F3D;
	Thu, 29 Aug 2024 10:01:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.36])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8B09619560A3;
	Thu, 29 Aug 2024 10:01:38 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	pmenzel@molgen.mpg.de
Subject: [PATCH 1/1] [PATCH V2 md-6.12 1/1] md: add new_level sysfs interface
Date: Thu, 29 Aug 2024 18:01:33 +0800
Message-Id: <20240829100133.74242-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

This interface is used to update new level during reshape progress.
Now it doesn't update new level during reshape. So it can't know the
new level when systemd service mdadm-grow-continue runs. And it can't
finally change to new level.

mdadm -CR /dev/md0 -l6 -n4 /dev/loop[0-3]
mdadm --wait /dev/md0
mdadm /dev/md0 --grow -l5 --backup=backup
cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid0] [raid1] [raid10]
md0 : active raid6 loop3[3] loop2[2] loop1[1] loop0[0]

The case 07changelevels in mdadm can trigger this problem. Now it can't
run successfully. This patch is used to fix this. There is also a
userspace patch set that work together with this patch to fix this problem.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
V2: add detail about test information
 drivers/md/md.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d3a837506a36..3c354e7a7825 100644
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
+	return len;
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

