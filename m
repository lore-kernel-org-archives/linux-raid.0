Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE88B2E36F2;
	Fri, 25 Jul 2025 03:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753414962; cv=none; b=R61Uxkzry9jcFoOV1gr6Lr488cfvNlR3rVVZgSJoD7SKci3cdy1LpGaF1E90ibaiDneBm0wISqY33pxqESURyRJ8YBwQ9RSFRD3WzaZLs3dLOgUmIVQSrpIwV5wggKjibVqad51woUP+klT7C5zcbgm4lLee4lchYe2PfTwnv9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753414962; c=relaxed/simple;
	bh=8Uik39Jx4LSGqUPRqIiOZx/J++HO7fj6bjGaJHNgIX8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EnFK/bOS2Kv71kF5CzaW8R10iRfSj4xnY+L+hRUvtCWRtkJG9uAvjp45zOnj+d8/zF6QAwUCbUnP+WI8K2WhXgYhK/sWP82NDLCSbM/tk5NnjO7QU+HAQPVvZr25vK/XpJVTouiD2x7dhRv0iutqYyfUuK3c+0N3hCfPci4NuQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bpDGQ6FYrzKHLxX;
	Fri, 25 Jul 2025 11:42:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A19AF1A0F86;
	Fri, 25 Jul 2025 11:42:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3QBEr_YJoP+2eBQ--.51659S5;
	Fri, 25 Jul 2025 11:42:37 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH 1/3] md: cleanup no_add tag in remove_and_add_spares()
Date: Fri, 25 Jul 2025 11:36:03 +0800
Message-Id: <20250725033605.3147379-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250725033605.3147379-1-yukuai1@huaweicloud.com>
References: <20250725033605.3147379-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3QBEr_YJoP+2eBQ--.51659S5
X-Coremail-Antispam: 1UD129KBjvJXoWxJr43Cw4fGrW8Kr4kAry8AFb_yoW8urW3pa
	1xtasxGr4UZ3ySqF4UWF1DCa45Jr1xXrWvya43Wa4Ivw13Ar1qga4rXFWYvr9Yva4F9F4r
	Jw18tw45Cry7KFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm214x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAVWUtw
	CF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7AKxVWUAVWUtwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVF
	xhVjvjDU0xZFpf9x0JUfDGrUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Just fold in the tag into remove_spares() to make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 046fe85c76fe..a0c05b37d087 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9459,10 +9459,10 @@ static bool md_spares_need_change(struct mddev *mddev)
 	return false;
 }
 
-static int remove_spares(struct mddev *mddev, struct md_rdev *this)
+static bool remove_spares(struct mddev *mddev, struct md_rdev *this)
 {
 	struct md_rdev *rdev;
-	int removed = 0;
+	bool removed = false;
 
 	rdev_for_each(rdev, mddev) {
 		if ((this == NULL || rdev == this) && rdev_removeable(rdev) &&
@@ -9470,14 +9470,18 @@ static int remove_spares(struct mddev *mddev, struct md_rdev *this)
 			sysfs_unlink_rdev(mddev, rdev);
 			rdev->saved_raid_disk = rdev->raid_disk;
 			rdev->raid_disk = -1;
-			removed++;
+			removed = true;
 		}
 	}
 
-	if (removed && mddev->kobj.sd)
-		sysfs_notify_dirent_safe(mddev->sysfs_degraded);
+	if (removed) {
+		if (mddev->kobj.sd)
+			sysfs_notify_dirent_safe(mddev->sysfs_degraded);
+
+		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
+	}
 
-	return removed;
+	return this && removed;
 }
 
 static int remove_and_add_spares(struct mddev *mddev,
@@ -9485,15 +9489,13 @@ static int remove_and_add_spares(struct mddev *mddev,
 {
 	struct md_rdev *rdev;
 	int spares = 0;
-	int removed = 0;
 
 	if (this && test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		/* Mustn't remove devices when resync thread is running */
 		return 0;
 
-	removed = remove_spares(mddev, this);
-	if (this && removed)
-		goto no_add;
+	if (remove_spares(mddev, this))
+		return 0;
 
 	rdev_for_each(rdev, mddev) {
 		if (this && this != rdev)
@@ -9513,9 +9515,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		}
 	}
-no_add:
-	if (removed)
-		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
+
 	return spares;
 }
 
-- 
2.39.2

