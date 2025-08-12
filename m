Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9262D8365;
	Tue, 12 Aug 2025 02:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754965524; cv=none; b=uw/4NZXPimSbozrtrbakac4lOeoxE1O1jXtRn18rxtx3GHUOaWppMIMPO7W+TI62MaAb2qQ2il8vvB0qGVEyGFnLyTHPbuLNY0u5pL3vt6m9WQLr9VhjG0NoFvWTZDIbZSzX9cEvCw0IiYyxggyWerz4h6BZ0g22MG4eWkFTibI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754965524; c=relaxed/simple;
	bh=eaROccnxxb+GQOj/KaXS4chG3XqhXN10YO9GesGAYnU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B7eHTCdfOo9qmiaqrEi94hoEy94b9gNag/TODKuPA6EWIBmwMXZAMde1XZpLAoVsMJdlB+XWvjx6L5fe7P+Yl91Rnsuh1jDQomeFG5+sQUDBpoYJAZ1xOsD6XZfaDfEZAKfojyCD/g51HgmbZ1Zy/gymxcoZfpKVFZkkIPv+FGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c1Fhs5rRKzKHMYG;
	Tue, 12 Aug 2025 10:25:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 100461A17B7;
	Tue, 12 Aug 2025 10:25:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDnrxAKpppoBm2ODQ--.41854S5;
	Tue, 12 Aug 2025 10:25:16 +0800 (CST)
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
Subject: [PATCH v2 1/2] md: add helper rdev_needs_recovery()
Date: Tue, 12 Aug 2025 10:17:37 +0800
Message-Id: <20250812021738.3722569-2-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250812021738.3722569-1-zhengqixing@huaweicloud.com>
References: <20250812021738.3722569-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnrxAKpppoBm2ODQ--.41854S5
X-Coremail-Antispam: 1UD129KBjvJXoW7ZrWDJF1ktr1kuF1fuF1xXwb_yoW8Zr18pa
	ySqFy3GryUAFyfW3WDWFn8Ga4Fga18KrWxKry7Ga4xJasxKr1jgay8uFy5XryDAFZYvr4Y
	v345JayfuF17Ww7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr4
	1l4c8EcI0Ec7CjxVAaw2AFwI0_Jw0_GFyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r
	43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	WUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU
	zGYLUUUUU
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

Add a helper for checking if an rdev needs recovery.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac85ec73a409..4ea956a80343 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4835,6 +4835,16 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_metadata =
 __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
 
+static bool rdev_needs_recovery(struct md_rdev *rdev, sector_t sectors)
+{
+	if (!test_bit(Journal, &rdev->flags) &&
+	    !test_bit(Faulty, &rdev->flags) &&
+	    !test_bit(In_sync, &rdev->flags) &&
+	    rdev->recovery_offset < sectors)
+		return true;
+	return false;
+}
+
 enum sync_action md_sync_action(struct mddev *mddev)
 {
 	unsigned long recovery = mddev->recovery;
@@ -8969,10 +8979,7 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 		rcu_read_lock();
 		rdev_for_each_rcu(rdev, mddev)
 			if (rdev->raid_disk >= 0 &&
-			    !test_bit(Journal, &rdev->flags) &&
-			    !test_bit(Faulty, &rdev->flags) &&
-			    !test_bit(In_sync, &rdev->flags) &&
-			    rdev->recovery_offset < start)
+			    rdev_needs_recovery(rdev, start))
 				start = rdev->recovery_offset;
 		rcu_read_unlock();
 
@@ -9333,10 +9340,7 @@ void md_do_sync(struct md_thread *thread)
 				rdev_for_each_rcu(rdev, mddev)
 					if (rdev->raid_disk >= 0 &&
 					    mddev->delta_disks >= 0 &&
-					    !test_bit(Journal, &rdev->flags) &&
-					    !test_bit(Faulty, &rdev->flags) &&
-					    !test_bit(In_sync, &rdev->flags) &&
-					    rdev->recovery_offset < mddev->curr_resync)
+					    rdev_needs_recovery(rdev, mddev->curr_resync))
 						rdev->recovery_offset = mddev->curr_resync;
 				rcu_read_unlock();
 			}
-- 
2.39.2

