Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7E8242D6E;
	Thu,  7 Aug 2025 07:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754552437; cv=none; b=qccRAt5hKs0tD9TBs61FVB6st0VRtAiAbPSmgNk9UOTBbqL3+ZajUyhetMljxkCZ7TBySx+Yh8JuzrMObBtBrglIJSgD17h0UAlnsjg5s1GfKV12pCZ0kwjIWROWGSRyuqmiTebwx7iL5Il4RjUOW2UGLTnX+e8eL+kiZsNkBKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754552437; c=relaxed/simple;
	bh=+VozcMLy1p/2md6uD2ddC3N3it/NxFpzbSy7adB3IKA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U7RedjukCxI81e/1Bs6IHlcF18eg478TZc+bArwax+WKYX/cnFLGm3eHgG7jHqbdg5zgaPpnDM/Mfpiac8G+yCiopDk/kI2UR8psZibiYr4Wqvnmk5/wxINIJayu1z3yJF2ClJ8XeZjQxpcPhF5a0GctwLRnODfe0GDP8GNQGZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4byJww17CpzKHLv3;
	Thu,  7 Aug 2025 15:40:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3F2D01A058E;
	Thu,  7 Aug 2025 15:40:31 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3QBFtWJRouJ1wCw--.53470S4;
	Thu, 07 Aug 2025 15:40:31 +0800 (CST)
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
Subject: [PATCH] md: fix sync_action incorrect display during resync
Date: Thu,  7 Aug 2025 15:33:10 +0800
Message-Id: <20250807073310.2694206-1-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3QBFtWJRouJ1wCw--.53470S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGr1rWr17ArWDJr47WFy8Zrb_yoW5Ww17pF
	W0yFy5Wr1DAryfJ39IyryDta45u3WxWrW7WryfG34UAanxKr1Fva4qka45XF90yF909a1Y
	q34DJFW3uFWUCaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU10PfPUUUUU==
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

During raid resync, if a disk becomes faulty, the operation is
briefly interrupted. The MD_RECOVERY_RECOVER flag triggered by
the disk failure causes sync_action to incorrectly show "recover"
instead of "resync". The same issue affects reshape operations.

Reproduction steps:
  mdadm -Cv /dev/md1 -l1 -n4 -e1.2 /dev/sd{a..d} // -> resync happended
  mdadm -f /dev/md1 /dev/sda 			 // -> resync interrupted
  cat sync_action
  -> recover

Add progress checks in md_sync_action() for resync/recover/reshape
to ensure the interface correctly reports the actual operation type.

Fixes: 4b10a3bc67c1 ("md: ensure resync is prioritized over recovery")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac85ec73a409..2a4055ad72a1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4835,9 +4835,37 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_metadata =
 __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
 
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
+		    !test_bit(Journal, &rdev->flags) &&
+		    !test_bit(Faulty, &rdev->flags) &&
+		    !test_bit(In_sync, &rdev->flags) &&
+		    rdev->recovery_offset < MaxSector) {
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
@@ -4861,8 +4889,17 @@ enum sync_action md_sync_action(struct mddev *mddev)
 	    !test_bit(MD_RECOVERY_NEEDED, &recovery))
 		return ACTION_IDLE;
 
-	if (test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
-	    mddev->reshape_position != MaxSector)
+	/*
+	 * Check if any sync operation (resync/recover/reshape) is currently
+	 * active. This ensures mutual exclusion - only one sync operation
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

