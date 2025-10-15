Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D9C2D060C;
	Wed, 15 Oct 2025 08:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760515865; cv=none; b=T0BVeSqe+wQibl+iHAcLME1zWQGExL/orLp/mbgFCbVbpLrXo2SP0mXDgzyL4BCuaprbvdKn5vhzLEOVFxEwNBm/07uzJzD9Cjw/YoXN3zhU1fxu6H+wyyqcH/ASCKtxYRtgLPKn4OkCd+Gq094sy7ySWoXkKUm+CCQrBq8Uq4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760515865; c=relaxed/simple;
	bh=Y5tGTn2VhKsVUg8HyFDRVlT4x2cUWlH3eIZlNdTJOh4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u0dzhp66GHT0p5Te7knaBw6qlED6H+wuTdNF7qUXkhOWaXI9X3CMW6fZZA6oQUPCPTfIETyXbVph1ATmLz+y5LYh+cSQAeLaTCUf8F296NQHaIlquSLfcf2qhT2x0/5GR/l24x8/wcy2IjXqaF2D2nRRp4PB3WbFRTvbhwgu+oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=LIEGipUa; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="LIEGipUa"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zTKdKAUhOR+Vx9qPdRtWK0FHpUG3B7gnBTtayB0ZLO0=;
	b=LIEGipUaKnsvkI90P359hZy6W6Z9d1uvabSOSazZzMhkBHbAZq1ABAwnuOCs3gnRyLSDKEI1r
	sYX7zUKS3ZRZBj6RdOGs1jL+KCyFDu1ijdtoSeM0A/6AJLnr2McnCXBfBNAbHYPyvkg9NCnIJpp
	nuCKs6gKyTYu5EEmS8Gverc=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4cmkKM0YVWz12LFQ;
	Wed, 15 Oct 2025 16:10:15 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 3C6141800B4;
	Wed, 15 Oct 2025 16:11:00 +0800 (CST)
Received: from kwepemn500011.china.huawei.com (7.202.194.152) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Oct 2025 16:11:00 +0800
Received: from huawei.com (10.50.87.129) by kwepemn500011.china.huawei.com
 (7.202.194.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 15 Oct
 2025 16:10:59 +0800
From: <linan122@huawei.com>
To: <corbet@lwn.net>, <song@kernel.org>, <yukuai3@huawei.com>,
	<linan122@huawei.com>, <xni@redhat.com>, <hare@suse.de>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <martin.petersen@oracle.com>,
	<linan666@huaweicloud.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH -next v7 3/4] md/raid0: Move queue limit setup before r0conf initialization
Date: Wed, 15 Oct 2025 16:03:53 +0800
Message-ID: <20251015080354.3398457-4-linan122@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251015080354.3398457-1-linan122@huawei.com>
References: <20251015080354.3398457-1-linan122@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
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
index adc9e68d064d..5bff8b4ded41 100644
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
@@ -404,6 +404,12 @@ static int raid0_run(struct mddev *mddev)
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
@@ -412,11 +418,6 @@ static int raid0_run(struct mddev *mddev)
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

