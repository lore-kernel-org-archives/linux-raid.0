Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBE418454D
	for <linux-raid@vger.kernel.org>; Wed,  4 Sep 2024 23:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725494114; cv=none; b=P7CG1+6CDPQYdqX5eupJzJ7izNAVd3s6Hb6myYP3wdzj+KMy9dsVPhKCj79K8GvjhoOqKW9C02djGHTpaGJq9NLtQQ6wGSLaNm4Nh3joaXOTtUahP6lA77JZR/q68F+EMLIWfKzjozg11FDe2ZaOXrHbFiwqELXOnP52pK+Sa0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725494114; c=relaxed/simple;
	bh=FUnB6T3RLEM/Wfzy/AdPVh5c/kMWDlPppsZY+tS7rHM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oy2gs6oRPSNUZ/FNxQwpMzSmc6ydjEdC9vaazQhJ0cZ1CKh6320MZmD5rrg95pwkSl3BasmrwusqR+dcnA92/6po/zk/a4CEpDNgBz1Favb+YoDa0RuZXTAHRg9/lRW2FMbm45wvjOyaU9SHr3XNRBmwLGjkKyfq/EvlOkj9I0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=beGAj/dO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="beGAj/dO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725494111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=o1iA2PwedA9R9Y+8b/lMMp2bpdZKFdEOAgAEDRlzFIQ=;
	b=beGAj/dOHpB1z3+wfGxOgarujT3KUjLfIYUiJycJiymIyCL86mV5AFU0cJg/F4euZI157y
	Gud0FkxFBVNsvzhk/7mm+bFdNsmqE6fg5bTho5XWDfyyWtqeaN79CEsDfBS0Wg7uqmbNsO
	swLb5xA0bwcUXfXUw/0PJ4ku24Iy+i0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-hKSk6BQKOOGU-jj3gW4UXQ-1; Wed,
 04 Sep 2024 19:55:04 -0400
X-MC-Unique: hKSk6BQKOOGU-jj3gW4UXQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA1FE195608C;
	Wed,  4 Sep 2024 23:55:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.2])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3371C1956086;
	Wed,  4 Sep 2024 23:54:58 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	pmenzel@molgen.mpg.de,
	yukuai1@huaweicloud.com
Subject: [PATCH V3 md-6.12 1/1] md: add new_level sysfs interface
Date: Thu,  5 Sep 2024 07:54:53 +0800
Message-Id: <20240904235453.99120-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Reshape needs to specify a backup file when it can't update data offset
of member disks. For this situation, first, it starts reshape and then
it kicks off mdadm-grow-continue service which does backup job and
monitors the reshape process. The service is a new process, so it needs
to read superblock from member disks to get information.

But in the first step, it doesn't update new level in superblock. So
in the second step, the new level that systemd service reads from
superblock is wrong. It can't change to the right new level after reshape
finishes. This interface is used to update new level during reshape
progress.

Reproduce steps:
mdadm -CR /dev/md0 -l6 -n4 /dev/loop[0-3]
mdadm --wait /dev/md0
mdadm /dev/md0 --grow -l5 --backup=backup
cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid0] [raid1] [raid10]
md0 : active raid6 loop3[3] loop2[2] loop1[1] loop0[0]

Test case 07changelevels from mdadm regression tests can trigger this
problem.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
V3: explain more about the root cause
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

