Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9809A14F90;
	Thu, 31 Oct 2024 03:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730345668; cv=none; b=nZR6nhqMu/P874NJkWmCkL080BrqBmDY13p4JXacRBZtRjo/YSXMqZ6IMNDOewJ9U6xVyKyJiwemNqJ/Ssnr+4WOuPMvqzIF3C4MQd3TwIhcAQ3SR02CjlefuLjIZyBB08MLknI2c4xXnYIxGpHuWGyfMxsm5Uagt4cu4+6kyVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730345668; c=relaxed/simple;
	bh=vMGajUR3KuIUP2LvIxXSGcL+Cwbk2Nmf5n3MPpiWcw0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XVYgcRWnxrtG7+ZDAgt5rtFt5PW9gYrvh+q0eumremvL/U7AvzvSRexYPrxwVrwzVxHFDOMYzdyio4X3eOKq2HOaTjs2V7GV4WgAhv/s8csKQDwV5lGAznkjbQhJeFGOE6DiW21Zexxej3mxDbTW0xNufKB0C3gzUrrlgR/9yzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Xf8jl2NH8z4f3jJ1;
	Thu, 31 Oct 2024 11:34:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 12C931A0196;
	Thu, 31 Oct 2024 11:34:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCXcYW6+iJnhVy1AQ--.50328S5;
	Thu, 31 Oct 2024 11:34:20 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@intel.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RESEND 1/7] md: add a new helper rdev_blocked()
Date: Thu, 31 Oct 2024 11:31:08 +0800
Message-Id: <20241031033114.3845582-2-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCXcYW6+iJnhVy1AQ--.50328S5
X-Coremail-Antispam: 1UD129KBjvJXoW7AFWDAF47Gr1DJr47Kr45Jrb_yoW8Gw1Dpa
	93WFW5tr1UCr17W3ZxXF1UCa45Xw1rtFyUCFW3t3y7XFyUG3yfW3ZYgrWUJrykXrWfXrsI
	qa15KrW8CFyfXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBl14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r126r1DMx
	AIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_
	Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwI
	xGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWx
	JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcV
	C2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjX18JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The helper will be used in later patches for raid1/raid10/raid5, the
difference is that Faulty rdev with unacknowledged bad block will not
be considered blocked.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Tested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 drivers/md/md.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5d2e6bd58e4d..4ba93af36126 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1002,6 +1002,30 @@ static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bio,
 		trace_block_bio_remap(bio, disk_devt(mddev->gendisk), sector);
 }
 
+static inline bool rdev_blocked(struct md_rdev *rdev)
+{
+	/*
+	 * Blocked will be set by error handler and cleared by daemon after
+	 * updating superblock, meanwhile write IO should be blocked to prevent
+	 * reading old data after power failure.
+	 */
+	if (test_bit(Blocked, &rdev->flags))
+		return true;
+
+	/*
+	 * Faulty device should not be accessed anymore, there is no need to
+	 * wait for bad block to be acknowledged.
+	 */
+	if (test_bit(Faulty, &rdev->flags))
+		return false;
+
+	/* rdev is blocked by badblocks. */
+	if (test_bit(BlockedBadBlocks, &rdev->flags))
+		return true;
+
+	return false;
+}
+
 #define mddev_add_trace_msg(mddev, fmt, args...)			\
 do {									\
 	if (!mddev_is_dm(mddev))					\
-- 
2.39.2

