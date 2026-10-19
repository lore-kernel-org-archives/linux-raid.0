Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A88F331202;
	Mon, 19 Oct 2026 01:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372549; cv=none; b=ItmlQQ76nopW+uQIv2inOwwWUPHz/wKUwfgT/trOSVRP+0iw2lm51MHNSJ7xJLG7NRiFvzdvN81oLwas+qAf6cq+0sl1UELNIR557OOnIY3UnXATLvLuOjQAlKhnD8Goz1bLjqRoQYXC8ZeMbxp57LSAO/CkQQeNd/SJTD1ONf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372549; c=relaxed/simple;
	bh=HD3+pmSzQOUXvEqvyp8S6xN7SpuEufeWv5Y909wqbas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVXphLp15y9CD9I8cnb1aJ1Z+rpmnN33ZRb364uhV3Url36o800LyglM4w+RSpjmINT0z0praPIZsaDTyA+QZUhs2/+B9R3twLJQjUg5daXwteebHsUJ87YyVj025n4mp414FysYOzZG93Zj84NFyJnWjc5G0sGElIJtnUWNTaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j7HdT2N4QzYQtwW;
	Mon, 19 Oct 2026 09:14:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1F41840A38;
	Mon, 19 Oct 2026 09:15:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBXkO85b9VqI9LoAw--.23742S5;
	Mon, 19 Oct 2026 09:15:37 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wozizhi@huawei.com
Subject: [PATCH V2 1/6] md/raid0: don't leave mddev in an inconsistent state when takeover fails
Date: Mon, 19 Oct 2026 09:08:22 +0800
Message-ID: <20261019010827.2922617-2-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261019010827.2922617-1-wozizhi@huaweicloud.com>
References: <20261019010827.2922617-1-wozizhi@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXkO85b9VqI9LoAw--.23742S5
X-Coremail-Antispam: 1UD129KBjvJXoWxurW3KF45Cr4fCw13ZFyfCrg_yoWrWFW3p3
	yxXFnxWFWUJry3JF9rXryDCayFv3y8JrWvyrZ3Xw4UKw1fArWDJa4rXFs8JFZrta93Ar15
	tw18Ar4DC3ZrKFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUz8nYUUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

raid0_takeover_raid45(), raid0_takeover_raid10() and raid0_takeover_raid1()
update mddev before create_strip_zones(), which can fail.

On failure, level_store() only rolls back new_level, new_layout,
new_chunk_sectors, raid_disks and delta_disks. The old personality is
therefore left with a reset resync_offset, cleared feature flags, and, for
raid1, the wrong chunk size.

Set only what create_strip_zones() needs before calling it, and move the
rest after it succeeds.

create_strip_zones() also rounds rdev->sectors, but the old levels do not
use it for I/O, so that is harmless. And mddev->degraded is already reset
by level_store() on success, so drop the redundant assignment in
raid0_takeover_raid10().

Fixes: 9af204cf720c ("md: Add support for Raid5->Raid0 and Raid10->Raid0 takeover")
Fixes: fc3a08b85b7a ("Add raid1->raid0 takeover support")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/md/raid0.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 35e103f0c2c3..8157e1058a24 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -669,15 +669,16 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
 	mddev->new_level = 0;
 	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = mddev->chunk_sectors;
 	mddev->raid_disks--;
 	mddev->delta_disks = -1;
-	/* make sure it will be not marked as dirty */
-	mddev->resync_offset = MaxSector;
-	mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
 
-	create_strip_zones(mddev, &priv_conf);
+	if (!create_strip_zones(mddev, &priv_conf)) {
+		/* make sure it will be not marked as dirty */
+		mddev->resync_offset = MaxSector;
+		mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
+	}
 
 	return priv_conf;
 }
 
 static void *raid0_takeover_raid10(struct mddev *mddev)
@@ -711,23 +712,25 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
 	mddev->new_level = 0;
 	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = mddev->chunk_sectors;
 	mddev->delta_disks = - mddev->raid_disks / 2;
 	mddev->raid_disks += mddev->delta_disks;
-	mddev->degraded = 0;
-	/* make sure it will be not marked as dirty */
-	mddev->resync_offset = MaxSector;
-	mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
 
-	create_strip_zones(mddev, &priv_conf);
+	if (!create_strip_zones(mddev, &priv_conf)) {
+		/* make sure it will be not marked as dirty */
+		mddev->resync_offset = MaxSector;
+		mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
+	}
+
 	return priv_conf;
 }
 
 static void *raid0_takeover_raid1(struct mddev *mddev)
 {
 	struct r0conf *priv_conf;
 	int chunksect;
+	int old_chunk_sectors;
 
 	/* Check layout:
 	 *  - (N - 1) mirror drives must be already faulty
 	 */
 	if ((mddev->raid_disks - 1) != mddev->degraded) {
@@ -748,22 +751,29 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
 
 	if ((chunksect << 9) < PAGE_SIZE)
 		/* array size does not allow a suitable chunk size */
 		return ERR_PTR(-EINVAL);
 
+	/* Save for rollback if create_strip_zones() fails */
+	old_chunk_sectors = mddev->chunk_sectors;
+
 	/* Set new parameters */
 	mddev->new_level = 0;
 	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = chunksect;
 	mddev->chunk_sectors = chunksect;
 	mddev->delta_disks = 1 - mddev->raid_disks;
 	mddev->raid_disks = 1;
-	/* make sure it will be not marked as dirty */
-	mddev->resync_offset = MaxSector;
-	mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
 
-	create_strip_zones(mddev, &priv_conf);
+	if (!create_strip_zones(mddev, &priv_conf)) {
+		/* make sure it will be not marked as dirty */
+		mddev->resync_offset = MaxSector;
+		mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
+	} else {
+		mddev->chunk_sectors = old_chunk_sectors;
+	}
+
 	return priv_conf;
 }
 
 static void *raid0_takeover(struct mddev *mddev)
 {
-- 
2.52.0

