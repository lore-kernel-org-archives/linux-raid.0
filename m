Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D7C3398A;
	Sat, 30 Aug 2025 09:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756546258; cv=none; b=CrgdpfBVecnQC+Isq2fUK5Nqa0p3w29p+mH36RjWbh8eWAV79s2ML7jm+Um4MJwt/8s4IZ6Vf3a46pcnpQA7GVdYNCAbvRS9QWRRCW+RQSrqQ2wL78/fZWNyk9nl/N77djdRjYeld2fjQmGcnHywyRurvVqBf1WkM941IIj+ewQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756546258; c=relaxed/simple;
	bh=oBmBgTmJRM5r9JK7Et4cih9k1JqxbuL+gjrwIqzmkAY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mjQiRcPfctk+0rac96mcoQsVayt79nIS8A9NVuTIwqGH6/ZAnCn7dE8GCCMhGFe+8HRdbIxfzt736CcndQn+h9qSAP430TAJozHB+OgH0g6iujqWa5Uvoz01P8+LlOOZQ9OVwoE3OVwsL4rYlmPyx6+CQVxmlzelWOduRyX7Oso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cDTwV0k3MzYQvsr;
	Sat, 30 Aug 2025 17:14:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9752C1A115E;
	Sat, 30 Aug 2025 17:14:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAncIznwLJood4rAw--.54255S4;
	Sat, 30 Aug 2025 17:14:16 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH] md: ensure consistent action state in md_do_sync
Date: Sat, 30 Aug 2025 17:05:32 +0800
Message-Id: <20250830090532.4071221-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncIznwLJood4rAw--.54255S4
X-Coremail-Antispam: 1UD129KBjvJXoWxWFyxKr1UWF48Kr1UWr1rWFg_yoWrXrW5pa
	yfCFnxKr4UAFW3tFW7ta4DJayFvr40yFWqyFW3Wa97Awn3Ka1fGFy5W3W7JayDAa4vyr4a
	q34rGr43ZF47uaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9G14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMx
	C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
	wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
	vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v2
	0xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxV
	W8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbp6wtUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

The 'mddev->recovery' flags can change during md_do_sync(), leading to
inconsistencies. For example, starting with MD_RECOVERY_RECOVER and
ending with MD_RECOVERY_SYNC can cause incorrect offset updates.

To avoid this, use the 'action' determined at the beginning of the
function instead of repeatedly checking 'mddev->recovery'.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6828a569e819..67cda9b64c87 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9516,7 +9516,7 @@ void md_do_sync(struct md_thread *thread)
 
 		skipped = 0;
 
-		if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
+		if (action != ACTION_RESHAPE &&
 		    ((mddev->curr_resync > mddev->curr_resync_completed &&
 		      (mddev->curr_resync - mddev->curr_resync_completed)
 		      > (max_sectors >> 4)) ||
@@ -9529,8 +9529,7 @@ void md_do_sync(struct md_thread *thread)
 			wait_event(mddev->recovery_wait,
 				   atomic_read(&mddev->recovery_active) == 0);
 			mddev->curr_resync_completed = j;
-			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
-			    j > mddev->resync_offset)
+			if (action == ACTION_RESYNC && j > mddev->resync_offset)
 				mddev->resync_offset = j;
 			update_time = jiffies;
 			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
@@ -9646,7 +9645,7 @@ void md_do_sync(struct md_thread *thread)
 	blk_finish_plug(&plug);
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
 
-	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
+	if (action != ACTION_RESHAPE &&
 	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    mddev->curr_resync >= MD_RESYNC_ACTIVE) {
 		mddev->curr_resync_completed = mddev->curr_resync;
@@ -9654,9 +9653,8 @@ void md_do_sync(struct md_thread *thread)
 	}
 	mddev->pers->sync_request(mddev, max_sectors, max_sectors, &skipped);
 
-	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
-	    mddev->curr_resync > MD_RESYNC_ACTIVE) {
-		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
+	if (action != ACTION_CHECK && mddev->curr_resync > MD_RESYNC_ACTIVE) {
+		if (action == ACTION_RESYNC) {
 			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 				if (mddev->curr_resync >= mddev->resync_offset) {
 					pr_debug("md: checkpointing %s of %s.\n",
@@ -9674,8 +9672,7 @@ void md_do_sync(struct md_thread *thread)
 		} else {
 			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 				mddev->curr_resync = MaxSector;
-			if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-			    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
+			if (action == ACTION_RECOVER) {
 				rcu_read_lock();
 				rdev_for_each_rcu(rdev, mddev)
 					if (mddev->delta_disks >= 0 &&
@@ -9692,7 +9689,7 @@ void md_do_sync(struct md_thread *thread)
 	set_mask_bits(&mddev->sb_flags, 0,
 		      BIT(MD_SB_CHANGE_PENDING) | BIT(MD_SB_CHANGE_DEVS));
 
-	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
+	if (action == ACTION_RESHAPE &&
 			!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 			mddev->delta_disks > 0 &&
 			mddev->pers->finish_reshape &&
@@ -9709,10 +9706,10 @@ void md_do_sync(struct md_thread *thread)
 	spin_lock(&mddev->lock);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 		/* We completed so min/max setting can be forgotten if used. */
-		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+		if (action == ACTION_REPAIR)
 			mddev->resync_min = 0;
 		mddev->resync_max = MaxSector;
-	} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+	} else if (action == ACTION_REPAIR)
 		mddev->resync_min = mddev->curr_resync_completed;
 	set_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	mddev->curr_resync = MD_RESYNC_NONE;
-- 
2.39.2

