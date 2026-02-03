Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1693783B0;
	Tue,  3 Feb 2026 06:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770099767; cv=none; b=XTo1/gJGBY9Oc7VF1Z2Y+tqW9OmvKOYnnSH0jYvVgfKmT6ixQFMiYnZH8u2MMVwfU6hSXadJ1PV0wnvAqKNC2+mqtF3jzm5RqREAZhEaSh7BV+UC8/tXwCndc7Epjh9T/wrt/krHKFUQDJ6XsqfWRjndqFGnOOTNQtuQzvx/qVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770099767; c=relaxed/simple;
	bh=YWTQEVWKxGAi++g7pj6QJGY6kPUUsf8XdiRUDEk4cEE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q0YFgKn9S6/aJvCRvictAf8KNBn+OXWC7PmCDMgvaohLb2FQcuDqO0UAst6QO1REohgxgAx8l1yvRJ4CSVhhYus0foyObTG6weefQKj+G3jHpQVyU/u0uR12HKHmUvWzZT5bjgwb68IYREz0S6U7uQcRAlv8fzd1czxXmJ0s2gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f4tgd20VRzKHMYm;
	Tue,  3 Feb 2026 14:22:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9223440577;
	Tue,  3 Feb 2026 14:22:42 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBHp_cilIFpIQhbGA--.27054S5;
	Tue, 03 Feb 2026 14:22:42 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com
Cc: xni@redhat.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	houtao1@huawei.com,
	zhengqixing@huawei.com
Subject: [RFC v2 1/5] md: add helpers for requested sync action
Date: Tue,  3 Feb 2026 14:12:55 +0800
Message-Id: <20260203061259.609206-2-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
References: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHp_cilIFpIQhbGA--.27054S5
X-Coremail-Antispam: 1UD129KBjvJXoWxZF4fXr47KFyrZFW5WrWfKrg_yoWrXr13pF
	WSy3Z8Cr4UZFyfXFW7ta4DZayfZr1IqrZrtrW7W34kJFnxKr4rAF15W3ZrtFZ5ta4kZw45
	Xa4UGF47uF13uw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7
	AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UN
	dbbUUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

Add helpers for handling requested sync action.

No functional change.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md.c | 65 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 19 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5df2220b1bd1..84af578876e2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -665,6 +665,41 @@ void mddev_put(struct mddev *mddev)
 	spin_unlock(&all_mddevs_lock);
 }
 
+static int handle_requested_sync_action(struct mddev *mddev,
+					enum sync_action action)
+{
+	switch (action) {
+	case ACTION_CHECK:
+		set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+		fallthrough;
+	case ACTION_REPAIR:
+		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
+		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static enum sync_action get_recovery_sync_action(struct mddev *mddev)
+{
+	if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
+		return ACTION_CHECK;
+	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+		return ACTION_REPAIR;
+	return ACTION_RESYNC;
+}
+
+static void set_requested_position(struct mddev *mddev, sector_t value)
+{
+	mddev->resync_min = value;
+}
+
+static sector_t get_requested_position(struct mddev *mddev)
+{
+	return mddev->resync_min;
+}
+
 static void md_safemode_timeout(struct timer_list *t);
 static void md_start_sync(struct work_struct *ws);
 
@@ -5101,17 +5136,9 @@ enum sync_action md_sync_action(struct mddev *mddev)
 	if (test_bit(MD_RECOVERY_RECOVER, &recovery))
 		return ACTION_RECOVER;
 
-	if (test_bit(MD_RECOVERY_SYNC, &recovery)) {
-		/*
-		 * MD_RECOVERY_CHECK must be paired with
-		 * MD_RECOVERY_REQUESTED.
-		 */
-		if (test_bit(MD_RECOVERY_CHECK, &recovery))
-			return ACTION_CHECK;
-		if (test_bit(MD_RECOVERY_REQUESTED, &recovery))
-			return ACTION_REPAIR;
-		return ACTION_RESYNC;
-	}
+	/* MD_RECOVERY_CHECK must be paired with MD_RECOVERY_REQUESTED. */
+	if (test_bit(MD_RECOVERY_SYNC, &recovery))
+		return get_recovery_sync_action(mddev);
 
 	/*
 	 * MD_RECOVERY_NEEDED or MD_RECOVERY_RUNNING is set, however, no
@@ -5300,11 +5327,10 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 			break;
 		case ACTION_CHECK:
-			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
-			fallthrough;
 		case ACTION_REPAIR:
-			set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
-			set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+			ret = handle_requested_sync_action(mddev, action);
+			if (ret)
+				goto out;
 			fallthrough;
 		case ACTION_RESYNC:
 		case ACTION_IDLE:
@@ -9370,7 +9396,7 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 	switch (action) {
 	case ACTION_CHECK:
 	case ACTION_REPAIR:
-		return mddev->resync_min;
+		return get_requested_position(mddev);
 	case ACTION_RESYNC:
 		if (!mddev->bitmap)
 			return mddev->resync_offset;
@@ -9795,10 +9821,11 @@ void md_do_sync(struct md_thread *thread)
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 		/* We completed so min/max setting can be forgotten if used. */
 		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
-			mddev->resync_min = 0;
+			set_requested_position(mddev, 0);
 		mddev->resync_max = MaxSector;
-	} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
-		mddev->resync_min = mddev->curr_resync_completed;
+	} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
+		set_requested_position(mddev, mddev->curr_resync_completed);
+	}
 	set_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	mddev->curr_resync = MD_RESYNC_NONE;
 	spin_unlock(&mddev->lock);
-- 
2.39.2

