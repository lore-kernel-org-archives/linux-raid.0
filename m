Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5240217BD6;
	Fri, 11 Oct 2024 01:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609514; cv=none; b=KywmqFMpUCtEkyYAdeOTPfRjDsWMf5nwciJcNtcjhKkZ4GnQYVcfM6E9XdmfMVsatSuacYumKW4Jfe05pi+l4yOTdT7VjiFOPOp4DiefHngEWlBC48bZ7QDhuU0pscrMLA9MjBicdmTwgj4T4sF/2lYVqp2bNViMQsv2d5iUNPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609514; c=relaxed/simple;
	bh=mqb2dcUZiMVko5Dx0zcblh+CR9za0lNwy3EDHZ+oe8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZmstLArV74HUHAGUP9MzQVFc2NMJYFxN6aO2GPvp8wVpDJwVVRsNcMZSOrrhRjTri6JqyvbpDaZ9nHjEtr/r2Tnk4UZYCIT9eCkrbQB34u+upmKjCTBI4wz3eVzhTBUsMGyjd6Gl7VBi4J1OXFSJ3eS4h9zf4mY3NxP+siP/VSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XPpfD21RXz4f3jXl;
	Fri, 11 Oct 2024 09:18:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 307BC1A08FC;
	Fri, 11 Oct 2024 09:18:29 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDH+sbefAhnm9MFDw--.55490S11;
	Fri, 11 Oct 2024 09:18:29 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@intel.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 7/7] md/raid5: don't set Faulty rdev for blocked_rdev
Date: Fri, 11 Oct 2024 09:16:30 +0800
Message-Id: <20241011011630.2002803-8-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241011011630.2002803-1-yukuai1@huaweicloud.com>
References: <20241011011630.2002803-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDH+sbefAhnm9MFDw--.55490S11
X-Coremail-Antispam: 1UD129KBjvdXoW7GF4ftFy5KF47GF1xWrWruFg_yoWkAFgEka
	4fZFZ3Gr18CFn8Zw1DWryrZrWjkr1kuFn7W3WUKFWYvr98XrWUK3yjqFyUJw4Uua9I9rW5
	Gw10gF1fXrZ3GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbD8FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r126r
	1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWx
	JVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPUUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Faulty rdev should never be accessed anymore, hence there is no point to
wait for bad block to be acknowledged in this case while handling write
request.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid5.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dc2ea636d173..f5ac81dd21b2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4724,14 +4724,13 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		if (rdev) {
 			is_bad = rdev_has_badblock(rdev, sh->sector,
 						   RAID5_STRIPE_SECTORS(conf));
-			if (s->blocked_rdev == NULL
-			    && (test_bit(Blocked, &rdev->flags)
-				|| is_bad < 0)) {
+			if (s->blocked_rdev == NULL) {
 				if (is_bad < 0)
-					set_bit(BlockedBadBlocks,
-						&rdev->flags);
-				s->blocked_rdev = rdev;
-				atomic_inc(&rdev->nr_pending);
+					set_bit(BlockedBadBlocks, &rdev->flags);
+				if (rdev_blocked(rdev)) {
+					s->blocked_rdev = rdev;
+					atomic_inc(&rdev->nr_pending);
+				}
 			}
 		}
 		clear_bit(R5_Insync, &dev->flags);
-- 
2.39.2

