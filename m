Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8381BC2A;
	Mon, 15 Dec 2025 03:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765768546; cv=none; b=g0p4gyx2EnSTPldBcCgSu75dkN+3MnUXYxPYFdz4lIhRGvT0zwo6EbcmsBF1/eL9qIajLqOlO0TkwhWwdoXm1mxsF3sfApXoWbs8ZsXLTvohu9sYRrROFxs0mhka7MgIAY+t8gZHVmT3uu3YdKqmyAfutsy39QvwGPWw/JG/Oho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765768546; c=relaxed/simple;
	bh=LuSivPCj/fEnwPiK4vRPb340P+qbO+wbLGUKSbl1W+o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=StcLsoqKjw+vSZO5XP1HZlvV9FxOsCp6Kjmdyff2mY1few/+PEE6WNX8mBFuOcjt/tn7304UMWnlQGvyjrUplsUx+0mfqgLnRR4u7OoFxIqxhKdlr5OfEQhxl457J4G5DB+DsxpwnE8Sh5wRUyoyR+iOQGVdEWDgl9VcNaZyoAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dV4v63LMdzKHMP7;
	Mon, 15 Dec 2025 11:15:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E018A1A084E;
	Mon, 15 Dec 2025 11:15:35 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_dUfT9p8AnuAA--.53622S10;
	Mon, 15 Dec 2025 11:15:35 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 06/13] md: mark rdev Faulty when badblocks setting fails
Date: Mon, 15 Dec 2025 11:04:37 +0800
Message-Id: <20251215030444.1318434-7-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251215030444.1318434-1-linan666@huaweicloud.com>
References: <20251215030444.1318434-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXd_dUfT9p8AnuAA--.53622S10
X-Coremail-Antispam: 1UD129KBjvJXoWxKrWUXw15JFy3uF15KFyrXrb_yoW3WrWxpw
	srGa4Syry5Gr1rZ3WDArWDWF9Ykw1xtFW2yrWaqw1xu3Z5Kr9xtFW8XryagFyDZFy3uF12
	qFn8WrWDZFWUGFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHa14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWU
	tVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOPfHDU
	UUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Currently when sync read fails and badblocks set fails (exceeding
512 limit), rdev isn't immediately marked Faulty. Instead
'recovery_disabled' is set and non-In_sync rdevs are removed later.
This preserves array availability if bad regions aren't read, but bad
sectors might be read by users before rdev removal. This occurs due
to incorrect resync/recovery_offset updates that include these bad
sectors.

When badblocks exceed 512, keeping the disk provides little benefit
while adding complexity. Prompt disk replacement is more important.
Therefore when badblocks set fails, directly call md_error to mark rdev
Faulty immediately, preventing potential data access issues.

After this change, cleanup of offset update logic and 'recovery_disabled'
handling will follow.

Fixes: 5e5702898e93 ("md/raid10: Handle read errors during recovery better.")
Fixes: 3a9f28a5117e ("md/raid1: improve handling of read failure during recovery.")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.c     |  8 +++++++-
 drivers/md/raid1.c  | 20 +++++++++-----------
 drivers/md/raid10.c | 35 +++++++++++++++--------------------
 drivers/md/raid5.c  | 22 +++++++++-------------
 4 files changed, 40 insertions(+), 45 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b452ac087612..39cb8430a7b1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10377,8 +10377,14 @@ bool rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 	else
 		s += rdev->data_offset;
 
-	if (!badblocks_set(&rdev->badblocks, s, sectors, 0))
+	if (!badblocks_set(&rdev->badblocks, s, sectors, 0)) {
+		/*
+		 * Mark the disk as Faulty when setting badblocks fails,
+		 * otherwise, bad sectors may be read.
+		 */
+		md_error(mddev, rdev);
 		return false;
+	}
 
 	/* Make sure they get written out promptly */
 	if (test_bit(ExternalBbl, &rdev->flags))
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8e0312fad3a2..53e13da9d518 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2115,8 +2115,7 @@ static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
 				rdev->mddev->recovery);
 	}
 	/* need to record an error - either for the block or the device */
-	if (!rdev_set_badblocks(rdev, sector, sectors, 0))
-		md_error(rdev->mddev, rdev);
+	rdev_set_badblocks(rdev, sector, sectors, 0);
 	return 0;
 }
 
@@ -2441,8 +2440,7 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 		if (!success) {
 			/* Cannot read from anywhere - mark it bad */
 			struct md_rdev *rdev = conf->mirrors[read_disk].rdev;
-			if (!rdev_set_badblocks(rdev, sect, s, 0))
-				md_error(mddev, rdev);
+			rdev_set_badblocks(rdev, sect, s, 0);
 			break;
 		}
 		/* write it back and re-read */
@@ -2545,7 +2543,10 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
 			/* failure! */
 			ok = false;
 			if (!rdev_set_badblocks(rdev, sector, sectors, 0)) {
-				md_error(mddev, rdev);
+				/*
+				 * Badblocks set failed, disk marked Faulty.
+				 * No further operations needed.
+				 */
 				bio_put(wbio);
 				break;
 			}
@@ -2569,14 +2570,11 @@ static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio
 		if (bio->bi_end_io == NULL)
 			continue;
 		if (!bio->bi_status &&
-		    test_bit(R1BIO_MadeGood, &r1_bio->state)) {
+		    test_bit(R1BIO_MadeGood, &r1_bio->state))
 			rdev_clear_badblocks(rdev, r1_bio->sector, s, 0);
-		}
 		if (bio->bi_status &&
-		    test_bit(R1BIO_WriteError, &r1_bio->state)) {
-			if (!rdev_set_badblocks(rdev, r1_bio->sector, s, 0))
-				md_error(conf->mddev, rdev);
-		}
+		    test_bit(R1BIO_WriteError, &r1_bio->state))
+			rdev_set_badblocks(rdev, r1_bio->sector, s, 0);
 	}
 	put_buf(r1_bio);
 	md_done_sync(conf->mddev, s);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e1f63f4f1384..6e64a817f1f8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2604,8 +2604,7 @@ static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
 				&rdev->mddev->recovery);
 	}
 	/* need to record an error - either for the block or the device */
-	if (!rdev_set_badblocks(rdev, sector, sectors, 0))
-		md_error(rdev->mddev, rdev);
+	rdev_set_badblocks(rdev, sector, sectors, 0);
 	return 0;
 }
 
@@ -2686,7 +2685,6 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 				    r10_bio->devs[slot].addr
 				    + sect,
 				    s, 0)) {
-				md_error(mddev, rdev);
 				r10_bio->devs[slot].bio
 					= IO_BLOCKED;
 			}
@@ -2824,7 +2822,10 @@ static bool narrow_write_error(struct r10bio *r10_bio, int i)
 			/* Failure! */
 			ok = false;
 			if (!rdev_set_badblocks(rdev, wsector, sectors, 0)) {
-				md_error(mddev, rdev);
+				/*
+				 * Badblocks set failed, disk marked Faulty.
+				 * No further operations needed.
+				 */
 				bio_put(wbio);
 				break;
 			}
@@ -2895,35 +2896,29 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 			if (r10_bio->devs[m].bio == NULL ||
 				r10_bio->devs[m].bio->bi_end_io == NULL)
 				continue;
-			if (!r10_bio->devs[m].bio->bi_status) {
+			if (!r10_bio->devs[m].bio->bi_status)
 				rdev_clear_badblocks(
 					rdev,
 					r10_bio->devs[m].addr,
 					r10_bio->sectors, 0);
-			} else {
-				if (!rdev_set_badblocks(
-					    rdev,
-					    r10_bio->devs[m].addr,
-					    r10_bio->sectors, 0))
-					md_error(conf->mddev, rdev);
-			}
+			else
+				rdev_set_badblocks(rdev,
+						   r10_bio->devs[m].addr,
+						   r10_bio->sectors, 0);
 			rdev = conf->mirrors[dev].replacement;
 			if (r10_bio->devs[m].repl_bio == NULL ||
 				r10_bio->devs[m].repl_bio->bi_end_io == NULL)
 				continue;
 
-			if (!r10_bio->devs[m].repl_bio->bi_status) {
+			if (!r10_bio->devs[m].repl_bio->bi_status)
 				rdev_clear_badblocks(
 					rdev,
 					r10_bio->devs[m].addr,
 					r10_bio->sectors, 0);
-			} else {
-				if (!rdev_set_badblocks(
-					    rdev,
-					    r10_bio->devs[m].addr,
-					    r10_bio->sectors, 0))
-					md_error(conf->mddev, rdev);
-			}
+			else
+				rdev_set_badblocks(rdev,
+						   r10_bio->devs[m].addr,
+						   r10_bio->sectors, 0);
 		}
 		put_buf(r10_bio);
 	} else {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ce63db3e2b9d..c301b65a169e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2817,11 +2817,9 @@ static void raid5_end_read_request(struct bio * bi)
 		else {
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
-			if (!(set_bad
-			      && test_bit(In_sync, &rdev->flags)
-			      && rdev_set_badblocks(
-				      rdev, sh->sector, RAID5_STRIPE_SECTORS(conf), 0)))
-				md_error(conf->mddev, rdev);
+			if (!(set_bad && test_bit(In_sync, &rdev->flags)))
+				rdev_set_badblocks(rdev, sh->sector,
+						   RAID5_STRIPE_SECTORS(conf), 0);
 		}
 	}
 	rdev_dec_pending(rdev, conf->mddev);
@@ -3599,11 +3597,10 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			else
 				rdev = NULL;
 			if (rdev) {
-				if (!rdev_set_badblocks(
-					    rdev,
-					    sh->sector,
-					    RAID5_STRIPE_SECTORS(conf), 0))
-					md_error(conf->mddev, rdev);
+				rdev_set_badblocks(rdev,
+						   sh->sector,
+						   RAID5_STRIPE_SECTORS(conf),
+						   0);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 		}
@@ -5255,9 +5252,8 @@ static void handle_stripe(struct stripe_head *sh)
 			if (test_and_clear_bit(R5_WriteError, &dev->flags)) {
 				/* We own a safe reference to the rdev */
 				rdev = conf->disks[i].rdev;
-				if (!rdev_set_badblocks(rdev, sh->sector,
-							RAID5_STRIPE_SECTORS(conf), 0))
-					md_error(conf->mddev, rdev);
+				rdev_set_badblocks(rdev, sh->sector,
+						   RAID5_STRIPE_SECTORS(conf), 0);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			if (test_and_clear_bit(R5_MadeGood, &dev->flags)) {
-- 
2.39.2

