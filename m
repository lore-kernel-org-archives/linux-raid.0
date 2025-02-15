Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC6119E7F8;
	Sat, 15 Feb 2025 09:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739611561; cv=none; b=COJCK2gFFYuohd7lFoLQ1crhgZ3i293T5WzoXUdKQXNbitvUHFycEvCO4xt5gcNDub+yci9pKfYlFbRmFHDMjF31Kf3BTxn9bEmpsU6FvdYSSHbyfcKZLyyO982FmRbafGcvc/geHB4XcjAybFAnBo3TCVnKrjZCcHYxKe4qwn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739611561; c=relaxed/simple;
	bh=zXvTNMRzliuZjqXEe0CMuWpD80LZubI0xLjV0c+ZcAk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cHcqJ7IKQ+K9LIcYNVQUiugONkFMr8OEyqJtq7/otB9w4UAmOl8wwnry1sJizGRfkmcT4QLWaf57T1c9M/9UhscYCKBPZgA82jzZdtFoBRbpZMOFx0MTKwn14vzKpHT0lvyZQZ9qEm3779I92EwzFt4x50txtaZCkSWjrr3pEwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Yw3Rs4yfDz4f3jQv;
	Sat, 15 Feb 2025 17:25:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 285DC1A0359;
	Sat, 15 Feb 2025 17:25:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAni1+bXbBn+Q+iDw--.49525S9;
	Sat, 15 Feb 2025 17:25:51 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.15 5/7] md/md-cluster: cleanup md_cluster_ops reference
Date: Sat, 15 Feb 2025 17:22:23 +0800
Message-Id: <20250215092225.2427977-6-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
References: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAni1+bXbBn+Q+iDw--.49525S9
X-Coremail-Antispam: 1UD129KBjvdXoWruF4UCF48Zw18uFWfCw1kuFg_yoWkuwb_CF
	sa9ry8KFWUGFnYkrn5uw4fZrZYvw1kWF1kXFZrtFZ5A3WDJ3WUA3y8Z347JF109ry3Aa90
	yr9rGw1Sq34YkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb6AFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r126r
	1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
	JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIx
	AIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbx9NDUUUUU=
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

md_cluster_ops->slot_number() is implemented inside md-cluster.c, just
call it directly.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-cluster.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 6595f89becdb..6fd436a1d373 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1166,7 +1166,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 		struct dlm_lock_resource *bm_lockres;
 		char str[64];
 
-		if (i == md_cluster_ops->slot_number(mddev))
+		if (i == slot_number(mddev))
 			continue;
 
 		bitmap = mddev->bitmap_ops->get_from_slot(mddev, i);
@@ -1216,7 +1216,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
  */
 static int cluster_check_sync_size(struct mddev *mddev)
 {
-	int current_slot = md_cluster_ops->slot_number(mddev);
+	int current_slot = slot_number(mddev);
 	int node_num = mddev->bitmap_info.nodes;
 	struct dlm_lock_resource *bm_lockres;
 	struct md_bitmap_stats stats;
-- 
2.39.2

