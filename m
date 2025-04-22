Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6E028E7
	for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 03:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745292256; cv=none; b=t6z1UfYvk2n43EFu3K0NzwO5+/sY3uPF9xLqW6PshjboyAv8nePoSs6Sj5p4PmKaSuAFeCb2pCNDL9CJO0gHCHxWWuG1shOML7LxBjES8bdzJle6ItvcyiQjuNYVkDz1YsU9bJcHMCFfrNMJoZde6Xidvku2DumFVOqgCv3h4VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745292256; c=relaxed/simple;
	bh=/eL6k4DXpIpzS7USk908/8tpa7wgLseQrQWSSAd7/6M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tmCqb/krKW13HkgYcl0dmuxqdYADfhXKDoKlDJF+bRKZNioSTk/06g9i0mr4pKmKeX0ovEKhuRrMZDYNLMi6px4Y4aHbUByxj6RKNBf/ZDekII5npIYds6qUzMOW1kU48EjXBOajDuxeCJ86jNnQJ45PqWT4XT1PdteirIrjPsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H5CuhJHD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H5CuhJHD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745292253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Tc1MzMnGJN5pE8EZ8/uWDCRF4s3I2DyWQKr6wtnMCyo=;
	b=H5CuhJHDNDvxYh/Mk8KWQKNzVEdjMCaxgCdzES9PTPVVsS7A2621qfkBTylLNQ8rMCpi7i
	NSwF1KK89sIa0+ENZiDh2sjdUngjpC90NGGQLJS1yiC4o7yIq5wfMRvrjh7y07E0BR+9p2
	WBJvlA/StEdyaqmH7HTAe/MOcDuUq1A=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-625-FJBA-27kM8ORDolXNYpZCw-1; Mon,
 21 Apr 2025 23:24:11 -0400
X-MC-Unique: FJBA-27kM8ORDolXNYpZCw-1
X-Mimecast-MFC-AGG-ID: FJBA-27kM8ORDolXNYpZCw_1745292250
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F18C91956077;
	Tue, 22 Apr 2025 03:24:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0B44530001A2;
	Tue, 22 Apr 2025 03:24:05 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai1@huaweicloud.com,
	hch@lst.de,
	ming.lei@redhat.com,
	ncroxon@redhat.com
Subject: [RFC PATCH 1/1] md: delete gendisk in ioctl path
Date: Tue, 22 Apr 2025 11:24:03 +0800
Message-Id: <20250422032403.63057-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

commit 777d0961ff95b ("fs: move the bdex_statx call to vfs_getattr_nosec")
introduces a regression problem, like this:
[ 1479.474440] INFO: task kdevtmpfs:506 blocked for more than 491 seconds.
[ 1479.478569]  __wait_for_common+0x99/0x1c0
[ 1479.478823]  ? __pfx_schedule_timeout+0x10/0x10
[ 1479.479466]  __flush_workqueue+0x138/0x400
[ 1479.479684]  md_alloc+0x21/0x370 [md_mod]
[ 1479.479926]  md_probe+0x24/0x50 [md_mod]
[ 1479.480150]  blk_probe_dev+0x62/0x90
[ 1479.480368]  blk_request_module+0xf/0x70
[ 1479.480604]  blkdev_get_no_open+0x5e/0xa0
[ 1479.480809]  bdev_statx+0x1f/0xf0
[ 1479.481364]  vfs_getattr_nosec+0x10a/0x120
[ 1479.481602]  handle_remove+0x68/0x290
[ 1479.481812]  ? __update_idle_core+0x23/0xb0
[ 1479.482023]  devtmpfs_work_loop+0x10d/0x2a0
[ 1479.482231]  ? __pfx_devtmpfsd+0x10/0x10
[ 1479.482464]  devtmpfsd+0x2f/0x30

[ 1479.485397] INFO: task kworker/33:1:532 blocked for more than 491 seconds.
[ 1479.535380]  __wait_for_common+0x99/0x1c0
[ 1479.566876]  ? __pfx_schedule_timeout+0x10/0x10
[ 1479.591156]  devtmpfs_submit_req+0x6e/0x90
[ 1479.591389]  devtmpfs_delete_node+0x60/0x90
[ 1479.591631]  ? process_sysctl_arg+0x270/0x2f0
[ 1479.592256]  device_del+0x315/0x3d0
[ 1479.592839]  ? mutex_lock+0xe/0x30
[ 1479.593455]  del_gendisk+0x216/0x320
[ 1479.593672]  md_kobj_release+0x34/0x40 [md_mod]
[ 1479.594317]  kobject_cleanup+0x3a/0x130
[ 1479.594562]  process_one_work+0x19d/0x3d0

Now del_gendisk and put_disk are called asynchronously in workqueue work.
del_gendisk deletes device node by devtmpfs. devtmpfs tries to open this
array again and it flush the workqueue at the bigging of open process. So
a deadlock happens.

The asynchronous way also has a problem that the device node can still
exist after mdadm --stop command returns in a short window. So udev rule
can open this device node and create the struct mddev in kernel again.

So put del_gendisk in ioctl path and still leave put_disk in
md_kobj_release to avoid uaf.

Fixes: 777d0961ff95 ("fs: move the bdex_statx call to vfs_getattr_nosec")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9daa78c5fe33..c3f793296ccc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5746,7 +5746,6 @@ static void md_kobj_release(struct kobject *ko)
 	if (mddev->sysfs_level)
 		sysfs_put(mddev->sysfs_level);
 
-	del_gendisk(mddev->gendisk);
 	put_disk(mddev->gendisk);
 }
 
@@ -6597,6 +6596,8 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		md_clean(mddev);
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
+
+		del_gendisk(mddev->gendisk);
 	}
 	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
-- 
2.32.0 (Apple Git-132)

