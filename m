Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E8B208D1;
	Thu,  1 Aug 2024 12:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722516920; cv=none; b=ffAYF9H05etyuUrXKzdcKHfJYl8d+PpNPMTDdseWJxbHYq3Mdy956z2jtxb3KtTg9My2TwOAH+OWdwfTezC0nUoMCt0t99Erp6cvM/URllPk8p205/QEmkib484YsSAWg0l7fS22bSJQfGrtSLklmYDdtLENyu8M9+jv3apQ3co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722516920; c=relaxed/simple;
	bh=7bZHFJJarhJ+jA0T5T9PA81+5VAjSAfGdGrOFRuQm38=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HfZ3dJgeui7qmK4uVjZJEdXrjktXyaNR/s+bjQI4vk+eiqgfcd8+jqM6lngNQMIDOC3nHnfN4HOKdWw6dIR4OCRJwlbUUVH63fViKJOixGcQCl0VFNHI1+6PsdCUNfF/l/16hQ20rMNjJMejKpBZJOdvwT7nT/2X6yMHA9PQoYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WZTT15HDrz4f3jJ3;
	Thu,  1 Aug 2024 20:55:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B3BF21A0568;
	Thu,  1 Aug 2024 20:55:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCHr4Wxhatm5YDhAQ--.33488S4;
	Thu, 01 Aug 2024 20:55:14 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH -next] md: wake up mdmon after setting badblocks
Date: Thu,  1 Aug 2024 20:51:48 +0800
Message-Id: <20240801125148.251986-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHr4Wxhatm5YDhAQ--.33488S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw13CF1ktw4DGw4kGr1kGrg_yoWkuFgEgr
	ZrZrW8JryxJws0kr15tryxZrWF9F1DKw1xuFyS9r4jvrn8XFykKr1kuw45Grs5ua4xJ3Z8
	Cr1jgr1avw4rKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUG0PhUUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

For external super_block, mdmon rely on "mddev->sysfs_state" to update
super_block. However, rdev_set_badblocks() will set sb_flags without
waking up mdmon, which might cauing IO hang due to suepr_block can't be
updated.

This problem is found by code review.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 23cc77d51676..06d6ee8cd543 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9831,10 +9831,12 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 		/* Make sure they get written out promptly */
 		if (test_bit(ExternalBbl, &rdev->flags))
 			sysfs_notify_dirent_safe(rdev->sysfs_unack_badblocks);
-		sysfs_notify_dirent_safe(rdev->sysfs_state);
 		set_mask_bits(&mddev->sb_flags, 0,
 			      BIT(MD_SB_CHANGE_CLEAN) | BIT(MD_SB_CHANGE_PENDING));
 		md_wakeup_thread(rdev->mddev->thread);
+
+		sysfs_notify_dirent_safe(rdev->sysfs_state);
+		sysfs_notify_dirent_safe(mddev->sysfs_state);
 		return 1;
 	} else
 		return 0;
-- 
2.39.2

