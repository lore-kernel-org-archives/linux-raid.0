Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F755185B65;
	Thu, 22 Aug 2024 02:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295143; cv=none; b=Ylear2mOV8f3lKMokVszw+o+E0b0wwb4sDB7AaG+55yE7moagthkRVrBXTdun3b5Xm9NfqezlSznRdofAuY0QZ4tlVpgcDAxIMs2zC8WRADOyFJZdvAI2za1cfssJk6pGBJZIJ1w4gGPjjryvEAYmTUMzILx3+NIj7vHF+Dr668=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295143; c=relaxed/simple;
	bh=22JLXzNpfbEMypJk8dRIIyx9uVBpKtzyciAoPHwzyhs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FuIyCVLhGWOVLAigQfUirHAfidgbyxGhjkQ0DqV9itrC1Zslaa8LUXpNHeV5PcxNEYER1CDffpy1x87NNk0ERJc0T/gxatAyDSEmzWs4scHVVg94v+6aiuFP9fhLHYb66zPjFhaW6MtSuznOSmmunAvHwSCVbUsF7Xz+O1D8tPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wq75b3DQ0z4f3jsD;
	Thu, 22 Aug 2024 10:52:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A66F51A0359;
	Thu, 22 Aug 2024 10:52:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S43;
	Thu, 22 Aug 2024 10:52:17 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@linux.intel.com,
	l@damenly.org,
	xni@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 39/41] md/md-bitmap: merge md_bitmap_wait_behind_writes() into bitmap_operations
Date: Thu, 22 Aug 2024 10:47:16 +0800
Message-Id: <20240822024718.2158259-40-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
References: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S43
X-Coremail-Antispam: 1UD129KBjvJXoWxZFW8Cr48Gr1fXr18XFyfXrb_yoW5tw4xpF
	ZFqF1Ykr45tFW3Xw4UAFykCFyYy3Wktr9rtryxuw1ruFy3Arn8GF4FgFWDt3sxCa43AFs8
	Za1rtryUWw10qFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VU1zpBDUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 6 +++---
 drivers/md/md-bitmap.h | 4 +---
 drivers/md/md.c        | 2 +-
 drivers/md/raid1.c     | 2 +-
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b5e2b0a2a493..c96782c69cc9 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1863,7 +1863,7 @@ static void md_bitmap_free(struct bitmap *bitmap)
 	kfree(bitmap);
 }
 
-void md_bitmap_wait_behind_writes(struct mddev *mddev)
+static void bitmap_wait_behind_writes(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
@@ -1876,7 +1876,6 @@ void md_bitmap_wait_behind_writes(struct mddev *mddev)
 			   atomic_read(&bitmap->behind_writes) == 0);
 	}
 }
-EXPORT_SYMBOL_GPL(md_bitmap_wait_behind_writes);
 
 static void bitmap_destroy(struct mddev *mddev)
 {
@@ -1885,7 +1884,7 @@ static void bitmap_destroy(struct mddev *mddev)
 	if (!bitmap) /* there was no bitmap */
 		return;
 
-	md_bitmap_wait_behind_writes(mddev);
+	bitmap_wait_behind_writes(mddev);
 	if (!mddev->serialize_policy)
 		mddev_destroy_serial_pool(mddev, NULL);
 
@@ -2755,6 +2754,7 @@ static struct bitmap_operations bitmap_ops = {
 	.dirty_bits		= bitmap_dirty_bits,
 	.unplug			= bitmap_unplug,
 	.daemon_work		= bitmap_daemon_work,
+	.wait_behind_writes	= bitmap_wait_behind_writes,
 
 	.startwrite		= bitmap_startwrite,
 	.endwrite		= bitmap_endwrite,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 7f6cc6f616b3..bc9cb4ca676e 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -259,6 +259,7 @@ struct bitmap_operations {
 			   unsigned long e);
 	void (*unplug)(struct mddev *mddev, bool sync);
 	void (*daemon_work)(struct mddev *mddev);
+	void (*wait_behind_writes)(struct mddev *mddev);
 
 	int (*startwrite)(struct mddev *mddev, sector_t offset,
 			  unsigned long sectors, bool behind);
@@ -286,9 +287,6 @@ struct bitmap_operations {
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
-/* these are exported */
-void md_bitmap_wait_behind_writes(struct mddev *mddev);
-
 static inline bool md_bitmap_enabled(struct bitmap *bitmap)
 {
 	return bitmap && bitmap->storage.filemap &&
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4046df5dc33e..a38981de8901 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6498,7 +6498,7 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
 
 static void mddev_detach(struct mddev *mddev)
 {
-	md_bitmap_wait_behind_writes(mddev);
+	mddev->bitmap_ops->wait_behind_writes(mddev);
 	if (mddev->pers && mddev->pers->quiesce && !is_md_suspended(mddev)) {
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c3bdc819e5e8..52a707e39a4d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1384,7 +1384,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 		 * over-take any writes that are 'behind'
 		 */
 		mddev_add_trace_msg(mddev, "raid1 wait behind writes");
-		md_bitmap_wait_behind_writes(mddev);
+		mddev->bitmap_ops->wait_behind_writes(mddev);
 	}
 
 	if (max_sectors < bio_sectors(bio)) {
-- 
2.39.2

