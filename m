Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CA923DE;
	Sat, 16 Aug 2025 00:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755304412; cv=none; b=XSAWS7yeYHgxugTLh9LUX4z58sw+rbjjWeh8ehpixyRJTCFxtTRFVGjvk0Y2QEzCql3n7wqX+hrSRxVrVrb+hldLHHBBXDJ5f6b+MocGAKqrwRpPLTQ6ku9NeXWVTwYHM+mkAtoDCL1gda0OKOrZeSPjVsJyX9hyyoz2aPK0z5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755304412; c=relaxed/simple;
	bh=RQLorwHzJts3CDK+H3WTSF9rvvnvX50UIirBMGcEPRk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D00P5D0d/k6LQz/DJlRgjLXRqvY1x5AnwcyLvbLWNXA+WXN7x6Yyv9WMql8HRLA9Zu/R50MuwdZIo6s/96mx74MNbTIFtLE04ZGnYudJYGfqGXzllvjTrVLSUHNhdpxseNyw9EOHtojOwEXQ3aZEwhBjO8MvKu4wIb4rxJkABZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c3g203H73zYQv3x;
	Sat, 16 Aug 2025 08:33:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 146381A08DC;
	Sat, 16 Aug 2025 08:33:27 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHzw_U0Z9oFuFMDw--.8782S5;
	Sat, 16 Aug 2025 08:33:26 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	linan122@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	houtao1@huawei.com,
	zhengqixing@huawei.com,
	pmenzel@molgen.mpg.de
Subject: [PATCH v4 1/2] md: add helper rdev_needs_recovery()
Date: Sat, 16 Aug 2025 08:25:33 +0800
Message-Id: <20250816002534.1754356-2-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250816002534.1754356-1-zhengqixing@huaweicloud.com>
References: <20250816002534.1754356-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHzw_U0Z9oFuFMDw--.8782S5
X-Coremail-Antispam: 1UD129KBjvJXoW7AFWfZr1DCw18ZF4UXry5Jwb_yoW8ur4fpa
	ySqFy3GryUAFyfW34DJr15GayFga1UKrWxKryxGayxXasxKr1qgay5uFy5X34DAFZYvr4Y
	va4rJay3uF17Ww7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmlb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
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
	JbIYCTnIWIevJa73UjIFyTuYvjxUzGYLUUUUU
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

Add a helper for checking if an rdev needs recovery.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac85ec73a409..3fcb061dd713 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4835,6 +4835,15 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_metadata =
 __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
 
+static bool rdev_needs_recovery(struct md_rdev *rdev, sector_t sectors)
+{
+	return rdev->raid_disk >= 0 &&
+	       !test_bit(Journal, &rdev->flags) &&
+	       !test_bit(Faulty, &rdev->flags) &&
+	       !test_bit(In_sync, &rdev->flags) &&
+	       rdev->recovery_offset < sectors;
+}
+
 enum sync_action md_sync_action(struct mddev *mddev)
 {
 	unsigned long recovery = mddev->recovery;
@@ -8968,11 +8977,7 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 		start = MaxSector;
 		rcu_read_lock();
 		rdev_for_each_rcu(rdev, mddev)
-			if (rdev->raid_disk >= 0 &&
-			    !test_bit(Journal, &rdev->flags) &&
-			    !test_bit(Faulty, &rdev->flags) &&
-			    !test_bit(In_sync, &rdev->flags) &&
-			    rdev->recovery_offset < start)
+			if (rdev_needs_recovery(rdev, start))
 				start = rdev->recovery_offset;
 		rcu_read_unlock();
 
@@ -9331,12 +9336,8 @@ void md_do_sync(struct md_thread *thread)
 			    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
 				rcu_read_lock();
 				rdev_for_each_rcu(rdev, mddev)
-					if (rdev->raid_disk >= 0 &&
-					    mddev->delta_disks >= 0 &&
-					    !test_bit(Journal, &rdev->flags) &&
-					    !test_bit(Faulty, &rdev->flags) &&
-					    !test_bit(In_sync, &rdev->flags) &&
-					    rdev->recovery_offset < mddev->curr_resync)
+					if (mddev->delta_disks >= 0 &&
+					    rdev_needs_recovery(rdev, mddev->curr_resync))
 						rdev->recovery_offset = mddev->curr_resync;
 				rcu_read_unlock();
 			}
-- 
2.39.2

