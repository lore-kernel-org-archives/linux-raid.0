Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7231F3BA9;
	Mon,  7 Jul 2025 07:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751875185; cv=none; b=bbIjoRP4oa//ymOXo4ipgC2XLrYteNQ0Yb1QhvwQ9a18qoY91UXcrgDCI3tqUiaO30PTmvXqZACDz1JKAT2TJe/IkT1a89T6jOpBYC7fM2Z+ToKVciHKjxriYbRzeMe3UQnpVqEy+xWn0LR3MtLrrBXHjbkLgFkaBPj625rEzcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751875185; c=relaxed/simple;
	bh=cfd+EsoWzibsQd9JRjP7jxP3pOWvpF67Kv0LT+J1AwM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=amcdb+yvT6pTCaRAi3nq6LltaeOtDBhN9k0BQZcBO89ldoMTJk+7LGWNDHbSRbPGY5iBbTayH9YnMVuQnFOmRQYtgnEV0e1iJ4AQRmEs7P6N6bNOEmWrDAanm+ljyUt365ZLzIaGneMbyqN80P4lL25LoB5gfGGaMmfH8tkFn08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bbGqK022wzKHMxr;
	Mon,  7 Jul 2025 15:59:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 719C61A0CD8;
	Mon,  7 Jul 2025 15:59:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDnSCZpfmtonKGuAw--.43238S4;
	Mon, 07 Jul 2025 15:59:39 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	linan122@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	houtao1@huawei.com,
	zhengqixing@huawei.com
Subject: [PATCH] md: allow removing faulty rdev during resync
Date: Mon,  7 Jul 2025 15:54:12 +0800
Message-Id: <20250707075412.150301-1-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgDnSCZpfmtonKGuAw--.43238S4
X-Coremail-Antispam: 1UD129KBjvJXoWxZF13CF15CryDAryDtr1xGrg_yoW5Gw1fpa
	1xt3Z8Gr4UJ3yrGa1DXa4kGa45Zr10qrW7tFy7Wa4fA3W3Aryvqa4rX3WjvryYya4F9F4r
	Xw18K3y5Cr1fKaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

During RAID resync, faulty rdev cannot be removed and will result in
"Device or resource busy" error when attempting hot removal.

Reproduction steps:
  mdadm -Cv /dev/md0 -l1 -n3 -e1.2 /dev/sd{b..d}
  mdadm /dev/md0 -f /dev/sdb
  mdadm /dev/md0 -r /dev/sdb
  -> mdadm: hot remove failed for /dev/sdb: Device or resource busy

After commit 4b10a3bc67c1 ("md: ensure resync is prioritized over
recovery"), when a device becomes faulty during resync, the
md_choose_sync_action() function returns early without calling
remove_and_add_spares(), preventing faulty device removal.

This patch extracts a helper function remove_spares() to support
removing faulty devices during RAID resync operations.

Fixes: 4b10a3bc67c1 ("md: ensure resync is prioritized over recovery")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0f03b21e66e4..7f5e5a16243a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9456,17 +9456,11 @@ static bool md_spares_need_change(struct mddev *mddev)
 	return false;
 }
 
-static int remove_and_add_spares(struct mddev *mddev,
-				 struct md_rdev *this)
+static int remove_spares(struct mddev *mddev, struct md_rdev *this)
 {
 	struct md_rdev *rdev;
-	int spares = 0;
 	int removed = 0;
 
-	if (this && test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
-		/* Mustn't remove devices when resync thread is running */
-		return 0;
-
 	rdev_for_each(rdev, mddev) {
 		if ((this == NULL || rdev == this) && rdev_removeable(rdev) &&
 		    !mddev->pers->hot_remove_disk(mddev, rdev)) {
@@ -9480,6 +9474,21 @@ static int remove_and_add_spares(struct mddev *mddev,
 	if (removed && mddev->kobj.sd)
 		sysfs_notify_dirent_safe(mddev->sysfs_degraded);
 
+	return removed;
+}
+
+static int remove_and_add_spares(struct mddev *mddev,
+				 struct md_rdev *this)
+{
+	struct md_rdev *rdev;
+	int spares = 0;
+	int removed = 0;
+
+	if (this && test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		/* Mustn't remove devices when resync thread is running */
+		return 0;
+
+	removed = remove_spares(mddev, this);
 	if (this && removed)
 		goto no_add;
 
@@ -9522,6 +9531,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 
 	/* Check if resync is in progress. */
 	if (mddev->recovery_cp < MaxSector) {
+		remove_spares(mddev, NULL);
 		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 		return true;
-- 
2.39.2

