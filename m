Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5ABDDA8;
	Sat, 15 Feb 2025 02:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739585106; cv=none; b=D3QilHYBDax7WISg9CQR/BmxcRkiCRTMlRJMitkU1OHE1nyMcMAC9pZreUEc4G/JGNntP3h5rIUIjkwXPr0Gc2y2/rrlBccJ/7n1pT9KF2bnPAnSgOlhjsvx4qvkdoaTpg2DL5lJyzYTTw/7Z52ROUGJ1a5CKcki+j6/q8IwdU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739585106; c=relaxed/simple;
	bh=llezsW1A9H1Dufa9VVhXKJsgHh3cs8iksbRBqlqDpcA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Iz7TJsGT3YpocjryynPl/tlRfKK+LpPEO5EizgQZB5PjjBNELlnpaPSgj9/J+XRpwL1Ck1GwB4guMFpPIEIrZsAZVwgnYEp87BDR+gReyFtHwhF1ky/UPxPoAV6/toLEQdQNCS+Y58wT35gIduMAch/gf9yodvQoDg6hcZfG6gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Yvsg93gGdz4f3l6s;
	Sat, 15 Feb 2025 10:04:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EB7F01A1A97;
	Sat, 15 Feb 2025 10:04:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBXvGBJ9q9nmMGEDw--.39248S4;
	Sat, 15 Feb 2025 10:04:58 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	axboe@kernel.dk,
	martin.petersen@oracle.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	zhengqixing@huawei.com
Subject: [PATCH] md/raid1: fix memory leak in raid1_run() if no active rdev
Date: Sat, 15 Feb 2025 10:01:37 +0800
Message-Id: <20250215020137.3703757-1-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXvGBJ9q9nmMGEDw--.39248S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw17tr4kWF4UGw4rZw4fXwb_yoW8GF4rpa
	nxXas8WrWxWryfGayDAFyDuayYyayDKrWvkFyxWw15AFn3KFZ8Way5Za4jgr9xA3yrX345
	J398KrWDGFyUKFJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IUbmii3UUUUU==
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

When `raid1_set_limits()` fails or when the array has no active
`rdev`, the allocated memory for `conf` is not properly freed.

Add raid1_free() call to properly free the conf in error path.

Fixes: 799af947ed13 ("md/raid1: don't free conf on raid0_run failure")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/raid1.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9d57a88dbd26..a87eb9a3b016 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -45,6 +45,7 @@
 
 static void allow_barrier(struct r1conf *conf, sector_t sector_nr);
 static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
+static void raid1_free(struct mddev *mddev, void *priv);
 
 #define RAID_1_10_NAME "raid1"
 #include "raid1-10.c"
@@ -3258,8 +3259,11 @@ static int raid1_run(struct mddev *mddev)
 
 	if (!mddev_is_dm(mddev)) {
 		ret = raid1_set_limits(mddev);
-		if (ret)
+		if (ret) {
+			if (!mddev->private)
+				raid1_free(mddev, conf);
 			return ret;
+		}
 	}
 
 	mddev->degraded = 0;
@@ -3273,6 +3277,8 @@ static int raid1_run(struct mddev *mddev)
 	 */
 	if (conf->raid_disks - mddev->degraded < 1) {
 		md_unregister_thread(mddev, &conf->thread);
+		if (!mddev->private)
+			raid1_free(mddev, conf);
 		return -EINVAL;
 	}
 
-- 
2.39.2

