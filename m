Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87532868A6;
	Mon,  5 Jan 2026 11:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767611502; cv=none; b=MpAF++npZSO94/aS3aA2DhL8dz50wELRzdYgM9gFsYBT62rd2m6TEtgwdvIYuJLiD+jaeo13D/wuf7hnUKiskwZ1KDX6gOkiqjc5QUyH9pCd4aIbHO7S9ciliUrHkzzOOvuFrYY8FOo2bGFv6KkK5QB7LTuRUmHYpZsS8ItBYAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767611502; c=relaxed/simple;
	bh=qEafbAwgEmL26fWbbADNx6Xbyt2dY1CcH+Xfy+NEdcU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tMARdX7W5hEH/gsSrblc5yLVxvKZoueRxDKoBp/rOHdaYfl7aNnVnF9CcIV7bJq3hFx9BKHei2/aau/ytZG5EXcDOY3hur4TCy625SyHtLyT7VOsfxqv5LAR+upSK1lCkIxZV2I1NidHmqsISNsjbcJTn2bhx+Tr7x4Da0lvCSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dlBRf5QD5zYQthS;
	Mon,  5 Jan 2026 19:10:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7B2814056B;
	Mon,  5 Jan 2026 19:11:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBXuPhmnFtp6EHbCg--.50545S8;
	Mon, 05 Jan 2026 19:11:37 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v4 04/12] md: break remaining operations on badblocks set failure in narrow_write_error
Date: Mon,  5 Jan 2026 19:02:52 +0800
Message-Id: <20260105110300.1442509-5-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260105110300.1442509-1-linan666@huaweicloud.com>
References: <20260105110300.1442509-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXuPhmnFtp6EHbCg--.50545S8
X-Coremail-Antispam: 1UD129KBjvJXoWxXrW8Jr4UKFWxWw4kur4rXwb_yoWrAr4kp3
	yDGasayrWjqFyrWw4qyFZrua9Yk34fKFW2yrs7WwnrCwnYyrykGF4jq34YgFy8CFZIg3WU
	Xwn8urZrZr1DJFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF
	x2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14
	v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY
	67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2
	IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQqXLUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Mark device faulty and exit at once when setting badblocks fails in
narrow_write_error(). No need to continue processing remaining sections.
With this change, narrow_write_error() no longer needs to return a value,
so adjust its return type to void.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid1.c  | 24 ++++++++++++------------
 drivers/md/raid10.c | 22 ++++++++++++----------
 2 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ef66ff4cab37..a665e2f61ceb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2486,7 +2486,7 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	}
 }
 
-static bool narrow_write_error(struct r1bio *r1_bio, int i)
+static void narrow_write_error(struct r1bio *r1_bio, int i)
 {
 	struct mddev *mddev = r1_bio->mddev;
 	struct r1conf *conf = mddev->private;
@@ -2507,7 +2507,6 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
 	sector_t sector;
 	int sectors;
 	int sect_to_write = r1_bio->sectors;
-	bool ok = true;
 
 	if (rdev->badblocks.shift < 0)
 		block_sectors = lbs;
@@ -2541,18 +2540,22 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
 		bio_trim(wbio, sector - r1_bio->sector, sectors);
 		wbio->bi_iter.bi_sector += rdev->data_offset;
 
-		if (submit_bio_wait(wbio) < 0)
-			/* failure! */
-			ok = rdev_set_badblocks(rdev, sector,
-						sectors, 0)
-				&& ok;
+		if (submit_bio_wait(wbio) &&
+		    !rdev_set_badblocks(rdev, sector, sectors, 0)) {
+			/*
+			 * Badblocks set failed, disk marked Faulty.
+			 * No further operations needed.
+			 */
+			md_error(mddev, rdev);
+			bio_put(wbio);
+			break;
+		}
 
 		bio_put(wbio);
 		sect_to_write -= sectors;
 		sector += sectors;
 		sectors = block_sectors;
 	}
-	return ok;
 }
 
 static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
@@ -2596,10 +2599,7 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 			 * errors.
 			 */
 			fail = true;
-			if (!narrow_write_error(r1_bio, m))
-				md_error(conf->mddev,
-					 conf->mirrors[m].rdev);
-				/* an I/O failed, we can't clear the bitmap */
+			narrow_write_error(r1_bio, m);
 			rdev_dec_pending(conf->mirrors[m].rdev,
 					 conf->mddev);
 		}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0700ed1dac60..62e0b501f74e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2773,7 +2773,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 	}
 }
 
-static bool narrow_write_error(struct r10bio *r10_bio, int i)
+static void narrow_write_error(struct r10bio *r10_bio, int i)
 {
 	struct bio *bio = r10_bio->master_bio;
 	struct mddev *mddev = r10_bio->mddev;
@@ -2794,7 +2794,6 @@ static bool narrow_write_error(struct r10bio *r10_bio, int i)
 	sector_t sector;
 	int sectors;
 	int sect_to_write = r10_bio->sectors;
-	bool ok = true;
 
 	if (rdev->badblocks.shift < 0)
 		block_sectors = lbs;
@@ -2820,18 +2819,22 @@ static bool narrow_write_error(struct r10bio *r10_bio, int i)
 				   choose_data_offset(r10_bio, rdev);
 		wbio->bi_opf = REQ_OP_WRITE;
 
-		if (submit_bio_wait(wbio) < 0)
-			/* Failure! */
-			ok = rdev_set_badblocks(rdev, wsector,
-						sectors, 0)
-				&& ok;
+		if (submit_bio_wait(wbio) &&
+		    !rdev_set_badblocks(rdev, wsector, sectors, 0)) {
+			/*
+			 * Badblocks set failed, disk marked Faulty.
+			 * No further operations needed.
+			 */
+			md_error(mddev, rdev);
+			bio_put(wbio);
+			break;
+		}
 
 		bio_put(wbio);
 		sect_to_write -= sectors;
 		sector += sectors;
 		sectors = block_sectors;
 	}
-	return ok;
 }
 
 static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
@@ -2936,8 +2939,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 				rdev_dec_pending(rdev, conf->mddev);
 			} else if (bio != NULL && bio->bi_status) {
 				fail = true;
-				if (!narrow_write_error(r10_bio, m))
-					md_error(conf->mddev, rdev);
+				narrow_write_error(r10_bio, m);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			bio = r10_bio->devs[m].repl_bio;
-- 
2.39.2

