Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7AC165F05;
	Fri, 30 Aug 2024 07:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725002924; cv=none; b=KDyRkk4UAKw40ywLd3SV8I53SVV05zPc2Nl+SGiJVYkTdBe0KARmgyhpeBpn5T19u6b8ffxnLndMeqt8bc8Um4rE1nD8aaMkOv9ct4OsNSMOqCWtN3bN+O7xuqF/afn6mmFLterJOTgYJZCzjFrT4qPCn0/BEY8C5+VEMi1wokk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725002924; c=relaxed/simple;
	bh=NjIVZWUfwogEAmZ4GypDkKQWDhXHrNk/lQRxclq119c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j2iF5IJ7m0HeeX5UezMo8/LID9SA5MuPMrl0kbPOAhHqXnn+frOCSxhrxKhtq4E6buTepTF2bjwPvm538L0VYIKTeu6oGdcGu0ad3IM8KAy0DO5uh8OJwn6qPaSuatZ0BtXWq7ruoX1tQb9IWJYWy6WvXuB3GzbPZQPnjBZlHb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Ww8rm2b0Qz4f3lCf;
	Fri, 30 Aug 2024 15:28:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E64321A018D;
	Fri, 30 Aug 2024 15:28:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WhdNFmxAd_DA--.47391S8;
	Fri, 30 Aug 2024 15:28:39 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@intel.com,
	song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 4/7] md/raid1: factor out helper to handle blocked rdev from raid1_write_request()
Date: Fri, 30 Aug 2024 15:27:18 +0800
Message-Id: <20240830072721.2112006-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
References: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WhdNFmxAd_DA--.47391S8
X-Coremail-Antispam: 1UD129KBjvJXoWxGw18KrWkGw18uw1kAF15CFg_yoWruw4fpw
	sxKayFqrW7Cry5X3Z0yFWUC3WrKw18trWIyrW7Jw1xXw43Kr95K3WvqryrJr95CFZ3urs8
	X3Z8CrW7C3429FUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
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
rdev is blocked while issuing this IO.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid1.c | 84 ++++++++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 36 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f55c8e67d059..aa30c3240c85 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1406,6 +1406,49 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
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
@@ -1413,7 +1456,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	struct r1bio *r1_bio;
 	int i, disks;
 	unsigned long flags;
-	struct md_rdev *blocked_rdev;
 	int first_clone;
 	int max_sectors;
 	bool write_behind = false;
@@ -1451,7 +1493,11 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
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
 
@@ -1467,7 +1513,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	 */
 
 	disks = conf->raid_disks * 2;
-	blocked_rdev = NULL;
 	max_sectors = r1_bio->sectors;
 	for (i = 0;  i < disks; i++) {
 		struct md_rdev *rdev = conf->mirrors[i].rdev;
@@ -1480,11 +1525,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
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
@@ -1500,13 +1540,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
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
@@ -1537,27 +1570,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
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

