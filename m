Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A66237704;
	Thu, 14 Aug 2025 02:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755137117; cv=none; b=OTXWo4Awe/QsOKq50bD6KtHrEXxNDitUkCx3CBdPoeNdPpER3Ie01PKgvUvld4gheaHCeGO551d6gzuxtCgbLkF5JX/eQcu3JvdR/IGydx3yidy+cF6f7CO3fg6S/DeO5HT88O2O1cXO2oRnSRdti51LiMj1VFL8S3N35YZSxng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755137117; c=relaxed/simple;
	bh=58UlwQy1yBcF9ZZ1cRNrAJ4s/XBlgpt0pYISUGm+gOM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C4baHjDBRT7FbsscjTkir2uttHf1sZBn2V8r51nc4YPr6lZngL7Bw6lvy0KYDLjmS/UT1XYOwAUgrUaI9ghJn0fof/D4x3WQoepl3MCzPMWKmdO5Xx/HlWDaa7NQ0obwe9DBD+l+8seb4mBJFlfKVEg0Lupk31PQO4UkQ8H5vFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c2T8h5ZFpzKHMgc;
	Thu, 14 Aug 2025 10:05:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 122C11A2127;
	Thu, 14 Aug 2025 10:05:08 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHERJRRJ1oFStwDg--.63851S6;
	Thu, 14 Aug 2025 10:05:07 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	linan122@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pmenzel@molgen.mpg.de,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	houtao1@huawei.com,
	zhengqixing@huawei.com
Subject: [PATCH v3 2/2] md: fix sync_action incorrect display during resync
Date: Thu, 14 Aug 2025 09:57:21 +0800
Message-Id: <20250814015721.3764005-3-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250814015721.3764005-1-zhengqixing@huaweicloud.com>
References: <20250814015721.3764005-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHERJRRJ1oFStwDg--.63851S6
X-Coremail-Antispam: 1UD129KBjvJXoWxGr1rWr1rJry8Zw15Xr17GFg_yoW5XrWkpF
	4IkF98Wr17JryfJa9xA34qvFWF93WxWrW7JFyfW345AanxKrnYva47K3W3WFyDAFyava1Y
	q34DtFW5uF4UCaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmlb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI
	0_Jw0_GFyl42xK82IYc2Ij64vIr41l4c8EcI0Ec7CjxVAaw2AFwI0_Jw0_GFyl4I8I3I0E
	4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGV
	WUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_
	Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rV
	WUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4U
	JbIYCTnIWIevJa73UjIFyTuYvjxU2WrWUUUUU
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

During raid resync, if a disk becomes faulty, the operation is
briefly interrupted. The MD_RECOVERY_RECOVER flag triggered by
the disk failure causes sync_action to incorrectly show "recover"
instead of "resync". The same issue affects reshape operations.

Reproduction steps:
  mdadm -Cv /dev/md1 -l1 -n4 -e1.2 /dev/sd{a..d} // -> resync happended
  mdadm -f /dev/md1 /dev/sda                     // -> resync interrupted
  cat sync_action
  -> recover

Add progress checks in md_sync_action() for resync/recover/reshape
to ensure the interface correctly reports the actual operation type.

Fixes: 4b10a3bc67c1 ("md: ensure resync is prioritized over recovery")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 drivers/md/md.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4663e172864e..5b6ab4ef042e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4843,9 +4843,34 @@ static bool rdev_needs_recovery(struct md_rdev *rdev, sector_t sectors)
 	       rdev->recovery_offset < sectors;
 }
 
+static enum sync_action md_get_active_sync_action(struct mddev *mddev)
+{
+	struct md_rdev *rdev;
+	bool is_recover = false;
+
+	if (mddev->resync_offset < MaxSector)
+		return ACTION_RESYNC;
+
+	if (mddev->reshape_position != MaxSector)
+		return ACTION_RESHAPE;
+
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev) {
+		if (rdev->raid_disk >= 0 &&
+		    rdev_needs_recovery(rdev, MaxSector)) {
+			is_recover = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return is_recover ? ACTION_RECOVER : ACTION_IDLE;
+}
+
 enum sync_action md_sync_action(struct mddev *mddev)
 {
 	unsigned long recovery = mddev->recovery;
+	enum sync_action active_action;
 
 	/*
 	 * frozen has the highest priority, means running sync_thread will be
@@ -4869,8 +4894,17 @@ enum sync_action md_sync_action(struct mddev *mddev)
 	    !test_bit(MD_RECOVERY_NEEDED, &recovery))
 		return ACTION_IDLE;
 
-	if (test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
-	    mddev->reshape_position != MaxSector)
+	/*
+	 * Check if any sync operation (resync/recover/reshape) is
+	 * currently active. This ensures that only one sync operation
+	 * can run at a time. Returns the type of active operation, or
+	 * ACTION_IDLE if none are active.
+	 */
+	active_action = md_get_active_sync_action(mddev);
+	if (active_action != ACTION_IDLE)
+		return active_action;
+
+	if (test_bit(MD_RECOVERY_RESHAPE, &recovery))
 		return ACTION_RESHAPE;
 
 	if (test_bit(MD_RECOVERY_RECOVER, &recovery))
-- 
2.39.2

