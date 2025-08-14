Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED4E237704;
	Thu, 14 Aug 2025 02:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755137112; cv=none; b=C7s7YJjVtoscTFR3q1Yhp1Eh3u79m9F4fMsoFA/NeKEjQKEgw7OXnSzXGJmzE8X/maQuW9fEaOXChuCVww8LLPELtKwy58qkBf5PuUWFBvaZEU0SERDB8l9/VqqLOZYhLf3CeVNMgJq9PUJtKqZyhvY0FgM0aR3mdQs7f575d1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755137112; c=relaxed/simple;
	bh=WH0Cg/IkqbKPKhVZ+q2ZaeTnH9n3VFkF7RpfFBRWxv0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XQMCnLML5MvXWMew6rEzQ9v+/c7z82lXDcO2WvVivxLDWPNjwHpHVJpBIvA7B35Gi7dPLwYxlzuRpxOVHWwS3aBi6AAtSZeK8nWml6nxZmb+YgzDzUCD/bJsmsLuEjZH8630kIYJEmTzgTGryUysOby7yyxFKtzygHl5F30NGQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c2T8j0BCGzYQv0L;
	Thu, 14 Aug 2025 10:05:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9C2441A14C8;
	Thu, 14 Aug 2025 10:05:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHERJRRJ1oFStwDg--.63851S5;
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
Subject: [PATCH v3 1/2] md: add helper rdev_needs_recovery()
Date: Thu, 14 Aug 2025 09:57:20 +0800
Message-Id: <20250814015721.3764005-2-zhengqixing@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHERJRRJ1oFStwDg--.63851S5
X-Coremail-Antispam: 1UD129KBjvJXoW7AryfKFWfKFyDtw17JFy5urg_yoW8ZFyUpa
	9agFy3WryUAFyfW3WDWFn8GFyFga18KrWxKry7Ga4xXasxKr1jgay8CFy5W34DAFZYvr4Y
	va45J3yxZF17Ww7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac85ec73a409..4663e172864e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4835,6 +4835,14 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_metadata =
 __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
 
+static bool rdev_needs_recovery(struct md_rdev *rdev, sector_t sectors)
+{
+	return !test_bit(Journal, &rdev->flags) &&
+	       !test_bit(Faulty, &rdev->flags) &&
+	       !test_bit(In_sync, &rdev->flags) &&
+	       rdev->recovery_offset < sectors;
+}
+
 enum sync_action md_sync_action(struct mddev *mddev)
 {
 	unsigned long recovery = mddev->recovery;
@@ -8969,10 +8977,7 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
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
 
@@ -9333,10 +9338,7 @@ void md_do_sync(struct md_thread *thread)
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

