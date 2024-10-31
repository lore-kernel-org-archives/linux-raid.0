Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DDD1428E3;
	Thu, 31 Oct 2024 03:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730345676; cv=none; b=nRMXw/Ijddi/rKjalIa4v+20/Vj0cZStGcbSquuXw2A0/jc5afzu2bK1FwWpf9hihVhXTMtVwomiwYY3O1gtTtn02LymqMmwa/HqJMb7W9VnWDSO7AyYBA8ogFsPtCRj80x8EG2SZafy53ZHcxgLEE/Z5zQsM9SylIMqrG5V8eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730345676; c=relaxed/simple;
	bh=3AZvfB67/jA48B3yrk23ivWc1y7T0sEjRlH9EazUe50=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uyZ+vhs1bNNuNFRWWtBoe0YGn2tfM/Uw7jCvjJu9xxIK599w9jblC5UapNTJT5y7zqfUIAuEMg/cnHZU35s01/8XLnRkd0g9KcUgq10xuSB6Vsmsk0n5+Lnnk+URkJSogL6GFCIPO7t34PcblmKO79wEDOGDmxIBcw1dZY71eOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xf8jp3MQSz4f3lfY;
	Thu, 31 Oct 2024 11:34:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0D2511A058E;
	Thu, 31 Oct 2024 11:34:25 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCXcYW6+iJnhVy1AQ--.50328S8;
	Thu, 31 Oct 2024 11:34:24 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@intel.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RESEND 4/7] md/raid1: factor out helper to handle blocked rdev from raid1_write_request()
Date: Thu, 31 Oct 2024 11:31:11 +0800
Message-Id: <20241031033114.3845582-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241031033114.3845582-1-yukuai1@huaweicloud.com>
References: <20241031033114.3845582-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXcYW6+iJnhVy1AQ--.50328S8
X-Coremail-Antispam: 1UD129KBjvJXoWxGw18KF15WFyxJF1xXFWrZrb_yoWrtw1kpw
	sI9F4FqrW7Cr15X3WDtFWUGF1Fgw48trWIyrW7J3WxXw47tr97K3WvqryrJr9YyFZxurs8
	XF1DCrW7C3429FUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPUUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Currently raid1 is preparing IO for underlying disks while checking if
any disk is blocked, if so allocated resources must be released, then
waiting for rdev to be unblocked and try to prepare IO again.

Make code cleaner by checking blocked rdev first, it doesn't matter if
rdev is blocked while issuing IO, the IO will wait for rdev to be
unblocked or not.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Tested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 drivers/md/raid1.c | 84 ++++++++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 36 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6c9d24203f39..1679c1e9b3d5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1412,6 +1412,49 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	submit_bio_noacct(read_bio);
 }
 
+static bool wait_blocked_rdev(struct mddev *mddev, struct bio *bio)
+{
+	struct r1conf *conf = mddev->private;
+	int disks = conf->raid_disks * 2;
+	int i;
+
+retry:
+	for (i = 0; i < disks; i++) {
+		struct md_rdev *rdev = conf->mirrors[i].rdev;
+
+		if (!rdev)
+			continue;
+
+		if (test_bit(Blocked, &rdev->flags)) {
+			if (bio->bi_opf & REQ_NOWAIT)
+				return false;
+
+			mddev_add_trace_msg(rdev->mddev, "raid1 wait rdev %d blocked",
+					    rdev->raid_disk);
+			atomic_inc(&rdev->nr_pending);
+			md_wait_for_blocked_rdev(rdev, rdev->mddev);
+			goto retry;
+		}
+
+		/* don't write here until the bad block is acknowledged */
+		if (test_bit(WriteErrorSeen, &rdev->flags) &&
+		    rdev_has_badblock(rdev, bio->bi_iter.bi_sector,
+				      bio_sectors(bio)) < 0) {
+			if (bio->bi_opf & REQ_NOWAIT)
+				return false;
+
+			set_bit(BlockedBadBlocks, &rdev->flags);
+			mddev_add_trace_msg(rdev->mddev, "raid1 wait rdev %d blocked",
+					    rdev->raid_disk);
+			atomic_inc(&rdev->nr_pending);
+			md_wait_for_blocked_rdev(rdev, rdev->mddev);
+			goto retry;
+		}
+	}
+
+	return true;
+}
+
 static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				int max_write_sectors)
 {
@@ -1419,7 +1462,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	struct r1bio *r1_bio;
 	int i, disks;
 	unsigned long flags;
-	struct md_rdev *blocked_rdev;
 	int first_clone;
 	int max_sectors;
 	bool write_behind = false;
@@ -1457,7 +1499,11 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		return;
 	}
 
- retry_write:
+	if (!wait_blocked_rdev(mddev, bio)) {
+		bio_wouldblock_error(bio);
+		return;
+	}
+
 	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_write_sectors;
 
@@ -1473,7 +1519,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 */
 
 	disks = conf->raid_disks * 2;
-	blocked_rdev = NULL;
 	max_sectors = r1_bio->sectors;
 	for (i = 0;  i < disks; i++) {
 		struct md_rdev *rdev = conf->mirrors[i].rdev;
@@ -1486,11 +1531,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		if (!is_discard && rdev && test_bit(WriteMostly, &rdev->flags))
 			write_behind = true;
 
-		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
-			atomic_inc(&rdev->nr_pending);
-			blocked_rdev = rdev;
-			break;
-		}
 		r1_bio->bios[i] = NULL;
 		if (!rdev || test_bit(Faulty, &rdev->flags)) {
 			if (i < conf->raid_disks)
@@ -1506,13 +1546,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 			is_bad = is_badblock(rdev, r1_bio->sector, max_sectors,
 					     &first_bad, &bad_sectors);
-			if (is_bad < 0) {
-				/* mustn't write here until the bad block is
-				 * acknowledged*/
-				set_bit(BlockedBadBlocks, &rdev->flags);
-				blocked_rdev = rdev;
-				break;
-			}
 			if (is_bad && first_bad <= r1_bio->sector) {
 				/* Cannot write here at all */
 				bad_sectors -= (r1_bio->sector - first_bad);
@@ -1543,27 +1576,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		r1_bio->bios[i] = bio;
 	}
 
-	if (unlikely(blocked_rdev)) {
-		/* Wait for this device to become unblocked */
-		int j;
-
-		for (j = 0; j < i; j++)
-			if (r1_bio->bios[j])
-				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
-		mempool_free(r1_bio, &conf->r1bio_pool);
-		allow_barrier(conf, bio->bi_iter.bi_sector);
-
-		if (bio->bi_opf & REQ_NOWAIT) {
-			bio_wouldblock_error(bio);
-			return;
-		}
-		mddev_add_trace_msg(mddev, "raid1 wait rdev %d blocked",
-				blocked_rdev->raid_disk);
-		md_wait_for_blocked_rdev(blocked_rdev, mddev);
-		wait_barrier(conf, bio->bi_iter.bi_sector, false);
-		goto retry_write;
-	}
-
 	/*
 	 * When using a bitmap, we may call alloc_behind_master_bio below.
 	 * alloc_behind_master_bio allocates a copy of the data payload a page
-- 
2.39.2

