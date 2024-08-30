Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80497158860;
	Fri, 30 Aug 2024 07:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725002921; cv=none; b=oQM3QgKF5dTbOgFwEDUZ+DQBkkyybmhaxCUdtw/l8T5X6jqKJbfbmbZ/EYeMVMgM2Hzk6lLMb6hnrP1P3jIr6XacaNfi9hOv02Ym1/VxXM0Ym2O6ODAVOQqo4137Nlt9Y9++NzwfetT2bBtQa1WNrRgMmi5hH5vXbtJDEIQzlEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725002921; c=relaxed/simple;
	bh=ppPn8huKmv2EiF2kjyFPo668pIxOPMt94++3jkAABYc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YN1jimKlzCU52trqrErJTmlm5ywyMk8X4yNzytgL0a2/SfJhu/VJiWNFr3H9KPjmeAilXH+Kd5ZlU29CmwvyWkM00md+umrlM0lyS5mRrG4w1Q1/GVdIcgjaIdW/UeMlJ1YYQ1OtdkUYRVNkrLFCF0X9m2td33FRm6j/VKTpa4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Ww8rp44xMz4f3jty;
	Fri, 30 Aug 2024 15:28:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9C5911A018D;
	Fri, 30 Aug 2024 15:28:36 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WhdNFmxAd_DA--.47391S6;
	Fri, 30 Aug 2024 15:28:36 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@intel.com,
	song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 2/7] md: don't wait faulty rdev in md_wait_for_blocked_rdev()
Date: Fri, 30 Aug 2024 15:27:16 +0800
Message-Id: <20240830072721.2112006-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
References: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WhdNFmxAd_DA--.47391S6
X-Coremail-Antispam: 1UD129KBjvdXoW7GFy5WFWrXF48Kry3Cr4xXrb_yoWDZFbE9a
	93ZryxGr1xJF1Fyr15tF4xZrZ0kr1kua1xXFy2qFya9F15J3y8Cws2q34rJrZrCa43G3sI
	krW09a4avr1IkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb68FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXwA2048vs2IY02
	0Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r126r1DMx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_
	Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwI
	xGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWx
	JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcV
	C2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUUApnJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

md_wait_for_blocked_rdev() is called for write IO while rdev is
blocked, howerver, rdev can be faulty after choosing this rdev to write,
and faulty rdev should never be accessed anymore, hence there is no point
to wait for faulty rdev to be unblocked.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 414146111425..675d89597c7b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9728,9 +9728,7 @@ EXPORT_SYMBOL(md_reap_sync_thread);
 void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev)
 {
 	sysfs_notify_dirent_safe(rdev->sysfs_state);
-	wait_event_timeout(rdev->blocked_wait,
-			   !test_bit(Blocked, &rdev->flags) &&
-			   !test_bit(BlockedBadBlocks, &rdev->flags),
+	wait_event_timeout(rdev->blocked_wait, rdev_blocked(rdev),
 			   msecs_to_jiffies(5000));
 	rdev_dec_pending(rdev, mddev);
 }
-- 
2.39.2

