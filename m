Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBC11FDA8E;
	Thu, 25 Dec 2025 12:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766665484; cv=none; b=DXdzWfTm7V9zYPHZkW1ws1ItqGeHkoHbo+FnwrxbQK3EnNw+Wpncq1WSxHDLOFPo0r5bJz3kfXV0F2IhRobbp8UxX6BGSNs0L72C4tJvf4ElA5kQ+IDejlmE3zvvdjWG8MgDV2lijuoH5DqPukRibbykq7iRLKHfUPfEHacjfO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766665484; c=relaxed/simple;
	bh=FKJ71r4xqaSs2INUO13ZXlduJQx5d48TZJs5TfZxdfM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s0+bqqsESKO6ZjgD3LnBtDzPY4WfCK3pC1xCa+ogFz9rRRApQOdtdvEe/P5svI8so/kFcdOyBzmY7V0Tkh85WjHptuLzOEso0dNUYgwMpvR+84V2fWA1mGGhVY0C6xz8V2vrLvwz7YZEl9L/s93/bqKiNHVKTD67HoW6VcMupTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dcSbl2BnZzKHMK1;
	Thu, 25 Dec 2025 20:24:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6AA9040573;
	Thu, 25 Dec 2025 20:24:40 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAHZ_cFLU1pXf69BQ--.53218S5;
	Thu, 25 Dec 2025 20:24:38 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	xni@redhat.com,
	linan122@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bugreports61@gmail.com,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 2/2] md: Fix forward incompatibility from configurable logical block size
Date: Thu, 25 Dec 2025 20:13:11 +0800
Message-Id: <20251225121311.1992029-2-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251225121311.1992029-1-linan666@huaweicloud.com>
References: <20251225121311.1992029-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHZ_cFLU1pXf69BQ--.53218S5
X-Coremail-Antispam: 1UD129KBjvJXoWxWFy3tryUuw1xJF4DGF4UArb_yoW5uFW3pa
	yxuFyYyw15Xryfta1fAas5Wa45Xw48KF4DK3y3Xw4Yyr47Ar1UCrs3WFyrXr90g3s7Jr4D
	Xan8tF1ruFnrAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHY14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8
	ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr
	0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUqtCcUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Commit 62ed1b582246 ("md: allow configuring logical block size") used
reserved pad to add 'logical_block_size' to metadata. RAID rejects
non-zero reserved pad, so arrays fail when rolling back to old kernels
after booting new ones.

Set 'logical_block_size' only for newly created arrays to support rollback
to old kernels. Importantly new arrays still won't work on old kernels to
prevent data loss issue from LBS changes.

For arrays created on old kernels which confirmed not to rollback,
configure LBS by echo current LBS (queue/logical_block_size) to
md/logical_block_size.

Fixes: 62ed1b582246 ("md: allow configuring logical block size")
Reported-by: BugReports <bugreports61@gmail.com>
Closes: https://lore.kernel.org/linux-raid/825e532d-d1e1-44bb-5581-692b7c091796@huaweicloud.com/T/#t
Signed-off-by: Li Nan <linan122@huawei.com>
---
v2:
  - move warn message to mddev_stack_rdev_limits
  - set current LBS to sysfs to enable feature instead of 'enable'

 drivers/md/md.c | 48 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7c0dd94a4d25..57b82154c411 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5983,13 +5983,33 @@ lbs_store(struct mddev *mddev, const char *buf, size_t len)
 	if (mddev->major_version == 0)
 		return -EINVAL;
 
-	if (mddev->pers)
-		return -EBUSY;
-
 	err = kstrtouint(buf, 10, &lbs);
 	if (err < 0)
 		return -EINVAL;
 
+	if (mddev->pers) {
+		unsigned int curr_lbs;
+
+		if (mddev->logical_block_size)
+			return -EBUSY;
+		/*
+		 * To fix forward compatibility issues, LBS is not
+		 * configured in old kernels array (<=6.18) by default.
+		 * If the user confirms no rollback to old kernels,
+		 * enable LBS by writing "enable" — to prevent data
+		 * loss from LBS changes.
+		 */
+		curr_lbs = queue_logical_block_size(mddev->gendisk->queue);
+		if (lbs != curr_lbs)
+			return -EINVAL;
+
+		mddev->logical_block_size = curr_lbs;
+		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
+		pr_info("%s: config logical block size success, array will not be assembled in old kernels (<= 6.18)\n",
+			mdname(mddev));
+		return len;
+	}
+
 	err = mddev_lock(mddev);
 	if (err)
 		goto unlock;
@@ -6165,7 +6185,27 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 			mdname(mddev));
 		return -EINVAL;
 	}
-	mddev->logical_block_size = lim->logical_block_size;
+
+	/* Only 1.x meta needs to set logical block size */
+	if (mddev->major_version == 0)
+		return 0;
+
+	/*
+	 * Fix forward compatibility issue. Only set LBS by default for
+	 * new array, mddev->events == 0 indicates the array was just
+	 * created. When assembling an array, read LBS from the superblock
+	 * instead — LBS is 0 in superblocks created by old kernels.
+	 */
+	if (!mddev->events) {
+		pr_info("%s: array will not be assembled in old kernels that lack configurable lbs support (<= 6.18)\n",
+			mdname(mddev));
+		mddev->logical_block_size = lim->logical_block_size;
+	}
+
+	if (!mddev->logical_block_size)
+		pr_warn("%s: echo current LBS to md/logical_block_size to prevent data loss issue from LBS changes.\n"
+			"\tNote: After setting, array will not be assembled in old kernels (<= 6.18)\n",
+			mdname(mddev));
 
 	return 0;
 }
-- 
2.39.2

