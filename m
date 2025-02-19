Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1A01F4626;
	Wed, 19 Feb 2025 08:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954333; cv=none; b=Ez3uiNDgMzoWtcUpcy4dU5XoZPF++Ep7V4npeka1BxemMYpiWKEXwLXo3R0W0qpL8gu+7scbB6/PlA7SsVihjzjaAyd4S/MdrlYp4TVxRNXX04sKcMqs2SlzEr9RqoEY46cI8n21guOmuQh333ZZ/Qi+cDrEI5aPKJVQIFT/ovg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954333; c=relaxed/simple;
	bh=RacByfW6IeE3uYa1vM6ZMRbz1bij79Mds5hm70QeLwg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B3KAzHAfy5+9AiUb/FLE04duhpB7zk6WqKHHDiaIPUcTR7hsIBektYLJNBaNYKskas6cfIC/QwLnMXno1S1dsWxOyGIDngXOJpUj5jtEeJ9gN9YgBP8FYZR8E0y/JgDILIwgxGVoJcn+YhUOBjt4G2Fhm4CiqPPOM4PDAGvAHxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YyVCY3LqHz4f3jXL;
	Wed, 19 Feb 2025 16:38:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 137771A0F73;
	Wed, 19 Feb 2025 16:38:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBXvGCImLVn4yQeEQ--.36560S10;
	Wed, 19 Feb 2025 16:38:38 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.15 v4 06/11] md/raid1: check bitmap before behind write
Date: Wed, 19 Feb 2025 16:34:51 +0800
Message-Id: <20250219083456.941760-7-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250219083456.941760-1-yukuai1@huaweicloud.com>
References: <20250219083456.941760-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXvGCImLVn4yQeEQ--.36560S10
X-Coremail-Antispam: 1UD129KBjvJXoWxJFWUuF17Xr47ury3tw43ZFb_yoWrJF1kpa
	yqqFn0krW5trW3XrnrAFykuFyrXw4ktF9rtrWfW34Fgr12yrn0ga1FgFyrGrnxA3s3CF45
	Zw4YyryUWrWSqFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPUUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

behind write rely on bitmap, because the number of IO are recoreded in
bitmap->behind_writes, and callers rely on bitmap_wait_behind_writes()
to wait for IO to be done.

Hence if behind write start without bitmap, readers will not wait for
the IO to be done because bitmap_wait_behind_writes() do nothing,
and old data can be read.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  6 ------
 drivers/md/raid1.c     | 45 ++++++++++++++++++++++++++----------------
 2 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index dc937cd9d46a..e4d337c1f197 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2033,9 +2033,6 @@ static void bitmap_start_behind_write(struct mddev *mddev)
 	struct bitmap *bitmap = mddev->bitmap;
 	int bw;
 
-	if (!bitmap)
-		return;
-
 	atomic_inc(&bitmap->behind_writes);
 	bw = atomic_read(&bitmap->behind_writes);
 	if (bw > bitmap->behind_writes_used)
@@ -2049,9 +2046,6 @@ static void bitmap_end_behind_write(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
-	if (!bitmap)
-		return;
-
 	if (atomic_dec_and_test(&bitmap->behind_writes))
 		wake_up(&bitmap->behind_wait);
 	pr_debug("dec write-behind count %d/%lu\n",
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5b6a7c5e9806..7022d2a11a27 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1369,7 +1369,8 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 				    (unsigned long long)r1_bio->sector,
 				    mirror->rdev->bdev);
 
-	if (test_bit(WriteMostly, &mirror->rdev->flags)) {
+	if (test_bit(WriteMostly, &mirror->rdev->flags) &&
+	    md_bitmap_enabled(mddev)) {
 		/*
 		 * Reading from a write-mostly device must take care not to
 		 * over-take any writes that are 'behind'
@@ -1456,6 +1457,30 @@ static bool wait_blocked_rdev(struct mddev *mddev, struct bio *bio)
 	return true;
 }
 
+static void raid1_start_write_behind(struct mddev *mddev, struct r1bio *r1_bio,
+				     struct bio *bio)
+{
+	unsigned long max_write_behind = mddev->bitmap_info.max_write_behind;
+	struct md_bitmap_stats stats;
+	int err;
+
+	/* behind write rely on bitmap, see bitmap_operations */
+	if (!md_bitmap_enabled(mddev))
+		return;
+
+	err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
+	if (err)
+		return;
+
+	/* Don't do behind IO if reader is waiting, or there are too many. */
+	if (!stats.behind_wait && stats.behind_writes < max_write_behind)
+		alloc_behind_master_bio(r1_bio, bio);
+
+	if (test_bit(R1BIO_BehindIO, &r1_bio->state))
+		mddev->bitmap_ops->start_behind_write(mddev);
+
+}
+
 static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				int max_write_sectors)
 {
@@ -1616,22 +1641,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			continue;
 
 		if (first_clone) {
-			unsigned long max_write_behind =
-				mddev->bitmap_info.max_write_behind;
-			struct md_bitmap_stats stats;
-			int err;
-
-			/* do behind I/O ?
-			 * Not if there are too many, or cannot
-			 * allocate memory, or a reader on WriteMostly
-			 * is waiting for behind writes to flush */
-			err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
-			if (!err && write_behind && !stats.behind_wait &&
-			    stats.behind_writes < max_write_behind)
-				alloc_behind_master_bio(r1_bio, bio);
-
-			if (test_bit(R1BIO_BehindIO, &r1_bio->state))
-				mddev->bitmap_ops->start_behind_write(mddev);
+			if (write_behind)
+				raid1_start_write_behind(mddev, r1_bio, bio);
 			first_clone = 0;
 		}
 
-- 
2.39.2

