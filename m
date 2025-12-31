Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67BB19258E;
	Wed, 31 Dec 2025 07:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767165503; cv=none; b=Jzb2RwujIQ+XHpjBh1Cjmcb0xbM5+P716dVde7mEnJbQYwWTvy41gVLFq/+IXCYBwITU/WGBr//z0H3KnkOJWpqC0tDxulvVyc3SW0GPSW/IiUfNj826O0K2IwbSGUkpXDhqiRzhAqMFaT69+nfxTtivWv3AVwOI2l7GTFDBaIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767165503; c=relaxed/simple;
	bh=ThK0u+K9PzIHd43MFCfhIvDzPPDCEJWJpIdu/T32+p0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O/XOQnrZjqAODSrvakKif5PlMwL2UTkZVZD+I2EXbevIjJw07uAWs163jYPRiKhO59tbbX6J4wZM6sfIJbVVvBRktZttdtcnCeep8mk81jxC80Zr6O6CTyZRUrGuh5amaMgNSfQWRKmSYZqn/4AAmmtWA4Tj3hKodpo8JeZGNuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dh1WH28rtzKHMcy;
	Wed, 31 Dec 2025 15:17:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7D08340596;
	Wed, 31 Dec 2025 15:18:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgCX+PgvzlRpTtVyCA--.62349S5;
	Wed, 31 Dec 2025 15:18:17 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	houtao1@huawei.com,
	zhengqixing@huawei.com,
	linan122@h-partners.com
Subject: [RFC PATCH 1/5] md: add helpers for requested sync action
Date: Wed, 31 Dec 2025 15:09:48 +0800
Message-Id: <20251231070952.1233903-2-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCX+PgvzlRpTtVyCA--.62349S5
X-Coremail-Antispam: 1UD129KBjvJXoW3XFy7JFWxCFy7ur1DCF48Zwb_yoW7Ww4Dpa
	yft3Z0kr4UXFWfXFWxta4DAaySvr1IqrZ7trW7W34kJFn3KrsYkFy5W3ZrJr95ta4kZF45
	Xa4DGF43ZFy3uw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UKg4fUUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

Add helpers for handling requested sync action.

In handle_requested_sync_action(), add mutual exclusivity checks between
check/repair operations. This prevents the scenario where one operation
is requested, but before MD_RECOVERY_RUNNING is set, another operation is
requested, resulting in neither an EBUSY return nor proper execution of
the second operation.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md.c | 87 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 66 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5df2220b1bd1..ccaa2e6fe079 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -665,6 +665,59 @@ void mddev_put(struct mddev *mddev)
 	spin_unlock(&all_mddevs_lock);
 }
 
+static int __handle_requested_sync_action(struct mddev *mddev,
+					  enum sync_action action)
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
+static int handle_requested_sync_action(struct mddev *mddev,
+					enum sync_action action)
+{
+	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+		return -EBUSY;
+	return __handle_requested_sync_action(mddev, action);
+}
+
+static enum sync_action __get_recovery_sync_action(struct mddev *mddev)
+{
+	if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
+		return ACTION_CHECK;
+	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+		return ACTION_REPAIR;
+	return ACTION_RESYNC;
+}
+
+static enum sync_action get_recovery_sync_action(struct mddev *mddev)
+{
+	return __get_recovery_sync_action(mddev);
+}
+
+static void init_recovery_position(struct mddev *mddev)
+{
+	mddev->resync_min = 0;
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
 
@@ -781,7 +834,7 @@ int mddev_init(struct mddev *mddev)
 	mddev->reshape_position = MaxSector;
 	mddev->reshape_backwards = 0;
 	mddev->last_sync_action = ACTION_IDLE;
-	mddev->resync_min = 0;
+	init_recovery_position(mddev);
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
 
@@ -5101,17 +5154,9 @@ enum sync_action md_sync_action(struct mddev *mddev)
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
@@ -5300,11 +5345,10 @@ action_store(struct mddev *mddev, const char *page, size_t len)
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
@@ -6783,7 +6827,7 @@ static void md_clean(struct mddev *mddev)
 	mddev->dev_sectors = 0;
 	mddev->raid_disks = 0;
 	mddev->resync_offset = 0;
-	mddev->resync_min = 0;
+	init_recovery_position(mddev);
 	mddev->resync_max = MaxSector;
 	mddev->reshape_position = MaxSector;
 	/* we still need mddev->external in export_rdev, do not clear it yet */
@@ -9370,7 +9414,7 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 	switch (action) {
 	case ACTION_CHECK:
 	case ACTION_REPAIR:
-		return mddev->resync_min;
+		return get_requested_position(mddev);
 	case ACTION_RESYNC:
 		if (!mddev->bitmap)
 			return mddev->resync_offset;
@@ -9795,10 +9839,11 @@ void md_do_sync(struct md_thread *thread)
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

