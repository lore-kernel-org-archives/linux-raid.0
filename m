Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4074D1A0BD6;
	Mon, 27 Oct 2025 07:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761550632; cv=none; b=CByXzIPYLrz5uH4X/dKc/JEzno9lqvhtBuiQbYsiAgJpFw6rZpqQnk5UjSxInkyrIopFTbZ3Lhg/CwnATxu/cuSN1ubWksza/6u6Z4a0PxlULqDpFFQrTkDFV+aUGla2wDrMi/dZSRNBqVdnmSKCywlRhZ5gJgl30i9i3iLj8yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761550632; c=relaxed/simple;
	bh=479+mniNecubZehFmc8IlGfr/WAQyGK99DuJrT+llqA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OSBEi+3HuudEqpTdd/UVtCDoyfmpZ0eXxSAMxxL1L3XCEqUz4tsEumxlLmlOmSvNcpFzur3GZrBH2c4UJ302N+W2T+Azh9EyRheNy/K3WXWHTkQOMDRgMB2t9BmMRCdUM2T5LId/S8kwjRsmGBEwYOegVraYDlU5gaB2iu4K364=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=pvMBruke; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="pvMBruke"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=d8IncEcvLlrcKLn7J9fR10HHDAHuWMu7vGLAsTM8sYg=;
	b=pvMBrukeDQ+tkMVrqag3imMWO+Ymw27EowOf/SExtpFlq5qAb1sWM9StX76wwWX6nNZj7TEhF
	bXHqXffx9JZMDPvnA+Xqnx8S60WfNrLykQzcoHvbtAz0pMWVr6ZmwdW0uy9Ank3HDj3+o0y/zsk
	P8wOLnewY3lh7RZPmfD83bY=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4cw50p3T6vz12LKJ;
	Mon, 27 Oct 2025 15:36:26 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id DD46D1800B1;
	Mon, 27 Oct 2025 15:37:04 +0800 (CST)
Received: from kwepemn500011.china.huawei.com (7.202.194.152) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 27 Oct 2025 15:37:04 +0800
Received: from huawei.com (10.50.87.129) by kwepemn500011.china.huawei.com
 (7.202.194.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 27 Oct
 2025 15:37:04 +0800
From: <linan122@huawei.com>
To: <corbet@lwn.net>, <song@kernel.org>, <yukuai@fnnas.com>,
	<linan122@huawei.com>, <hare@suse.de>, <xni@redhat.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <linan666@huaweicloud.com>,
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v7 3/4] md/raid0: Move queue limit setup before r0conf initialization
Date: Mon, 27 Oct 2025 15:29:14 +0800
Message-ID: <20251027072915.3014463-4-linan122@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251027072915.3014463-1-linan122@huawei.com>
References: <20251027072915.3014463-1-linan122@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemn500011.china.huawei.com (7.202.194.152)

From: Li Nan <linan122@huawei.com>

Prepare for making logical blocksize configurable.

Move raid0_set_limits() before create_strip_zones(). It is safe as fields
modified in create_strip_zones() do not involve mddev configuration, and
rdev modifications there are not used in raid0_set_limits().

'blksize' in create_strip_zones() fetches mddev's logical block size. This
change has no impact until logical block size becomes configurable.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid0.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e443e478645a..49477b560cc9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -68,7 +68,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	struct strip_zone *zone;
 	int cnt;
 	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
-	unsigned blksize = 512;
+	unsigned int blksize = queue_logical_block_size(mddev->gendisk->queue);
 
 	*private_conf = ERR_PTR(-ENOMEM);
 	if (!conf)
@@ -405,6 +405,12 @@ static int raid0_run(struct mddev *mddev)
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 
+	if (!mddev_is_dm(mddev)) {
+		ret = raid0_set_limits(mddev);
+		if (ret)
+			return ret;
+	}
+
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {
 		ret = create_strip_zones(mddev, &conf);
@@ -413,11 +419,6 @@ static int raid0_run(struct mddev *mddev)
 		mddev->private = conf;
 	}
 	conf = mddev->private;
-	if (!mddev_is_dm(mddev)) {
-		ret = raid0_set_limits(mddev);
-		if (ret)
-			return ret;
-	}
 
 	/* calculate array device size */
 	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
-- 
2.39.2

