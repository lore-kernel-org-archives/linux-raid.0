Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B7C22172A;
	Thu, 13 Feb 2025 13:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739452734; cv=none; b=uHFTFBcMrEsh+fqamoTO6OwrAegMCGAqwSk8Ck3BgXGbOu9KWcyWL6iqZXMuT/9YcKrN5F1AYpMM92iGDTtlRxWv4MT8BgzzNCO1RXiJwEe9X3AUbHbI4kewUD/I+lW39kP8qyUQqOiq/0rOv+ODlPNXt3251A9aB2AUZ6mlJbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739452734; c=relaxed/simple;
	bh=XIzr+PvuXP2KTBlj+0Qas/W7CfoHCr/ilC9hkHMevkY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CjPPqE6LWKdiMu0zbHGTYCycFUcj4vJH7B8c+NA8ImSLbwiqE7nhs4hmc1/xeo/7MKXg8Jxpq/Awwim3Wg32fqqxbSsSWFK+lHX7DNyLSC4QPcJNSSib65iwC2jsEcKyNaJfmKZ8eLY8W6B4FwD9Z4ELzs8CFEr2KiFh+Kc6bhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YtwjY3XVGz4f3kvt;
	Thu, 13 Feb 2025 21:18:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 420A41A160B;
	Thu, 13 Feb 2025 21:18:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXe1828a1nMAXxDg--.16673S4;
	Thu, 13 Feb 2025 21:18:48 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	zhangxiaoxu5@huawei.com,
	wanghai38@huawei.com
Subject: [PATCH] md: ensure resync is prioritized over recovery
Date: Thu, 13 Feb 2025 21:15:30 +0800
Message-Id: <20250213131530.3698600-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXe1828a1nMAXxDg--.16673S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar47XFy7Gw15tr1rCr17ZFb_yoW8Xw1fpa
	1fJFsxurWrtFWfAFWUtw1kXay5Cry0yry8tFy3W3yrZry3tr13ArW5Wa1jvFyUGFyIqa1j
	qr4kJrWfZF1fCw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9G14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMx
	C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
	wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
	vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v2
	0xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxV
	W8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjTa0DUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

If a new disk is added during resync, the resync process is interrupted,
and recovery is triggered, causing the previous resync to be lost. In
reality, disk addition should not terminate resync, fix it.

Steps to reproduce the issue:
  mdadm -CR /dev/md0 -l1 -n3 -x1 /dev/sd[abcd]
  mdadm --fail /dev/md0 /dev/sdc

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 30b3dbbce2d2..827646b3eb59 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9460,6 +9460,13 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 		return true;
 	}
 
+	/* Check if resync is in progress. */
+	if (mddev->recovery_cp < MaxSector) {
+		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+		return true;
+	}
+
 	/*
 	 * Remove any failed drives, then add spares if possible. Spares are
 	 * also removed and re-added, to allow the personality to fail the
@@ -9476,13 +9483,6 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 		return true;
 	}
 
-	/* Check if recovery is in progress. */
-	if (mddev->recovery_cp < MaxSector) {
-		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
-		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
-		return true;
-	}
-
 	/* Delay to choose resync/check/repair in md_do_sync(). */
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 		return true;
-- 
2.39.2

