Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794989776;
	b=jezRTFSUol9aORuS7pJmBDiscLgY13yFPBqqoUGz5Go+1TkBgJt3uSAiwHGQ2h8M85j2
	 mgBqt6j/77qwylsQIvGR+kA0WwxkkT2zQ3zIKLEz1zhU7fdIvcx/lVprkU/hRV/de+Tdb
	 9Y6LPjEZ84AOr6dqZGhgN4A8tnSkiPPZ0/sZ2rFtnUzZJsmrROpA8xOkgl4aOveMm1wLv
	 DRun+Wk1v07WqaEamS7bzar5hTqvdQnPIXVrbRVciUMgxCmFjHtIKKKssrOLw3q9B78IO
	 Wn7avnnb3qrRl2oQ5QPuKZrh6qKWP3mJbuJioycqaNOE02o5n9pNo8Zh9/DyrdT9IQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794989776;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XL3h2yYsYjPUzu7A8O3AV6SsM8VkYtjNh+ErAVl7/BY=;
	b=DZUwI9aX/Xstrt1OzqBnzYzWceFJb2iHe7NRTslc5zEm7TUmuhpTepi+UAZaekA5t9Tn
	 9fvdF9Y2L+4acrK1Wn4LVJMcY/AdAIVTAjLE50SYtkumP7c2ZsB9g2tZHhK2Oh5dK9jTA
	 DObhy1WERx0B+cBRhw8tBAdZf7+CWEpxzft7gB6GIUKE/1DhbF5bZtUP1MvlVi0DvgQML
	 mSdmUaAkM91g+ZNMzR0sTt3JMH1MNsKoiQrAbrRDLqJ5gBJ7aiXR6R9gvo1g+62sObBc9
	 pyWy2VNmpQc44wY/uPJmZoJGNT1b3rb4WXsWS9jMnfPFE+SSvxx+5nq48U++FkgsPLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=L4sO12OV;
	arc=none smtp.remote-ip=111.22.67.135
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5715606A334;
	Wed, 18 Nov 2026 08:16:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5715606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=L4sO12OV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=L4sO12OVGyKu/VFfG8cNKQZm/K6/7E2AY/XQUptKwt08372tWM4Mp6S0rSQA4H8mpUFwO88qoDrJg
	 3ZI5JHQi9wEt4IxPCqE7wU/zoVv4QKmHP+y+EJrVSWaXVDLlnFf2NC2sCRiBZH2dPnOMNFresSKZrM
	 Y23kIA4xyVlQ6Sfo=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee76afd5e5f111-12fff;
	Wed, 18 Nov 2026 16:14:24 +0800 (CST)
X-RM-TRANSID:2ee76afd5e5f111-12fff
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHD-W7400297 (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee66afd5e5e2eb-cfa5b;
	Wed, 18 Nov 2026 16:14:24 +0800 (CST)
X-RM-TRANSID:2ee66afd5e5e2eb-cfa5b
From: Aibing Chen <chenaibing@cmss.chinamobile.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] md/raid1: reject oversized raid_disks values
Date: Wed, 18 Nov 2026 16:14:21 +0800
Message-ID: <20261118081421.2004-1-chenaibing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
In-Reply-To: <20261117235714.1101-1-chenaibing@cmss.chinamobile.com>
References: <20261117235714.1101-1-chenaibing@cmss.chinamobile.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

setup_conf(), raid1_reshape() and r1buf_pool_alloc() size the mirrors
array, the r1bio pool and the resync buffer pool by raid_disks * 2.
raid_disks is set from the user through the SET_ARRAY_INFO ioctl and is
unbounded, so a large value makes one of those allocations exceed
KMALLOC_MAX_SIZE: kmalloc emits a WARN_ON_ONCE_GFP() splat (syzbot:
WARNING in r1buf_pool_alloc) and returns NULL.

Cap raid_disks by the largest element size involved, and check the cap
both in raid1_run(), before the pools are allocated, and in
raid1_reshape(), which updates raid_disks on a running array through
update_raid_disks().

Reported-by: syzbot+c0e700c08ee88f60e54d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c0e700c08ee88f60e54d
Signed-off-by: Aibing Chen <chenaibing@cmss.chinamobile.com>
---
v2:
- cap by max(sizeof(struct resync_pages), sizeof(struct raid1_info)) so
  the mirrors array is covered on 64K page kernels as well.
- add the same check to raid1_reshape(), which changes raid_disks on a
  running array without going through raid1_run().

 drivers/md/raid1.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 894efb50c..609c64d85 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3152,6 +3152,18 @@ static int raid1_set_limits(struct mddev *mddev)
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
+/*
+ * setup_conf(), raid1_reshape() and r1buf_pool_alloc() size the mirrors
+ * array, the r1bio pool and the resync buffer pool by raid_disks * 2.
+ * Reject a disk count for which those allocations would exceed
+ * KMALLOC_MAX_SIZE instead of letting kmalloc warn and fail later.
+ */
+static int raid1_max_disks(void)
+{
+	return KMALLOC_MAX_SIZE /
+		(2 * max(sizeof(struct resync_pages), sizeof(struct raid1_info)));
+}
+
 static int raid1_run(struct mddev *mddev)
 {
 	struct r1conf *conf;
@@ -3169,6 +3181,9 @@ static int raid1_run(struct mddev *mddev)
 		return -EIO;
 	}
 
+	if (mddev->raid_disks <= 0 || mddev->raid_disks > raid1_max_disks())
+		return -EINVAL;
+
 	/*
 	 * copy the already verified devices into our private RAID1
 	 * bookkeeping area. [whatever we allocate in run(),
@@ -3318,6 +3333,9 @@ static int raid1_reshape(struct mddev *mddev)
 
 	raid_disks = mddev->raid_disks + mddev->delta_disks;
 
+	if (raid_disks <= 0 || raid_disks > raid1_max_disks())
+		return -EINVAL;
+
 	if (raid_disks < conf->raid_disks) {
 		cnt=0;
 		for (d= 0; d < conf->raid_disks; d++)


