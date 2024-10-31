Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E1314659B;
	Thu, 31 Oct 2024 03:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730345676; cv=none; b=VNduA4ECTB+hfud70nf8Kbc/6tfgFseGn7CePznr4u1TzHXmT+ZvVR3O96UXSjg5Sh7G1++dw1l/4MKiGEiXy/9Bg2BroTUKvLXXAV6emEgbKW/TUyiBq/xW5qjuMiTSnnuw3JpcOxP1icEBjfKhLIfmDOa96PqP2+KDHiU3m7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730345676; c=relaxed/simple;
	bh=Q5/uCXOr4TWyGMeKpjeRhmALjuxrNEIJN6lXU7M6xls=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r4i0ysh3EqVB0K5rlr9Uw35L0JWixa3q1N3UfndSJrzVvF7QibmanoxBlQfkP6RzyOxlP0lxmPEbWUTCzHhPa9km8uhpbWx/6iSdXCgwSSLAD5Ip4Am+OOULOT+7bd0Oxx25a9cWMNR6UWAlTwLcE3d2C9ug2rxFPjhra3/1UOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xf8jq4J63z4f3lfV;
	Thu, 31 Oct 2024 11:34:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2B9E21A0196;
	Thu, 31 Oct 2024 11:34:26 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCXcYW6+iJnhVy1AQ--.50328S11;
	Thu, 31 Oct 2024 11:34:25 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@intel.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RESEND 7/7] md/raid5: don't set Faulty rdev for blocked_rdev
Date: Thu, 31 Oct 2024 11:31:14 +0800
Message-Id: <20241031033114.3845582-8-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241031033114.3845582-1-yukuai1@huaweicloud.com>
References: <20241031033114.3845582-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXcYW6+iJnhVy1AQ--.50328S11
X-Coremail-Antispam: 1UD129KBjvJXoW7GF4ftFy5Kry3ury7GFWxWFg_yoW8Jr1rpa
	9xuFyFvr4UGrn7Xa4qqrW5WFyrXa1UKrW2krW7Jw4xXa4UXryrJws5t343Jr1kJFZaqayr
	XF4DG3y7u34F9r7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYcTQUUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Faulty rdev should never be accessed anymore, hence there is no point to
wait for bad block to be acknowledged in this case while handling write
request.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Tested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
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

