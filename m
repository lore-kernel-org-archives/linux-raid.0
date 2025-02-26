Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5A627455;
	Wed, 26 Feb 2025 06:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740551664; cv=none; b=EsXFCWRlZJG9RPbn7IzJ23aQtquh9qX13ayRuj71VshXAKNO3lKk4Rt/frgxqpCrmsQe+1skNAeHhHreKyS0BZ/qFh+v0ig0cH0SXuCME8jl4jhT5+MouLrzMnv4K3CkRq77Ilaw70wpzdSD49U6mBKyU4MmhDWHIoxkKWtZB6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740551664; c=relaxed/simple;
	bh=uagHt1edGLsKO/w7E5CpRr6rb9GrmY+1q7+2GhMUNWQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TBhqqXQAeKiQEy11jn/XGBrkCRKZjabvg+Nky6nz8gbntrdZVuP7ug0IKwfcPqtRJ3wEn6FwUnlo8bkNa0LY8YYwCRwSFV4aI4alAF3FxDx0eGRAUq6IDDsoicewHIc84qe1YAc9y9T1mKtQZkw/PLkrrNUmSjDKhLY4h/CEHXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z2l6m5XwCz4f3jrt;
	Wed, 26 Feb 2025 14:33:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 98B6C1A058E;
	Wed, 26 Feb 2025 14:34:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl_ktb5nQ+25Ew--.13735S4;
	Wed, 26 Feb 2025 14:34:14 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH] md/raid1,raid10: don't ignore IO flags
Date: Wed, 26 Feb 2025 14:30:11 +0800
Message-Id: <20250226063011.968761-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHKl_ktb5nQ+25Ew--.13735S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGr1fZr1kGFyUKFykWw15Arb_yoWrXr48pa
	9rtayrurW3Jw4UZr1DXFZruaySgF4qgFW2krW8Ww1fJw1avFyqqa1rJrWrWFn8ZFW3ur17
	Xwn5A3yDCr4agFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYCJmUU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

If blk-wbt is enabled by default, it's found that raid write performance
is quite bad because all IO are throttled by wbt of underlying disks,
due to flag REQ_IDLE is ignored. And turns out this behaviour exist since
blk-wbt is introduced.

Other than REQ_IDLE, other flags should not be ignored as well, for
example REQ_META can be set for filesystems, clear it can cause priority
reverse problems; And REQ_NOWAIT should not be cleared as well, because
io will wait instead of fail directly in underlying disks.

Fix those problems by keeping IO flags from master bio.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid1.c  | 5 -----
 drivers/md/raid10.c | 8 --------
 2 files changed, 13 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a87eb9a3b016..347de0e36d59 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1316,8 +1316,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	struct r1conf *conf = mddev->private;
 	struct raid1_info *mirror;
 	struct bio *read_bio;
-	const enum req_op op = bio_op(bio);
-	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	int max_sectors;
 	int rdisk, error;
 	bool r1bio_existed = !!r1_bio;
@@ -1405,7 +1403,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_iter.bi_sector = r1_bio->sector +
 		mirror->rdev->data_offset;
 	read_bio->bi_end_io = raid1_end_read_request;
-	read_bio->bi_opf = op | do_sync;
 	if (test_bit(FailFast, &mirror->rdev->flags) &&
 	    test_bit(R1BIO_FailFast, &r1_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
@@ -1654,8 +1651,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_opf = bio_op(bio) |
-			(bio->bi_opf & (REQ_SYNC | REQ_FUA | REQ_ATOMIC));
 		if (test_bit(FailFast, &rdev->flags) &&
 		    !test_bit(WriteMostly, &rdev->flags) &&
 		    conf->raid_disks - mddev->degraded > 1)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index efe93b979167..e294ba00ea0e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1146,8 +1146,6 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 {
 	struct r10conf *conf = mddev->private;
 	struct bio *read_bio;
-	const enum req_op op = bio_op(bio);
-	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	int max_sectors;
 	struct md_rdev *rdev;
 	char b[BDEVNAME_SIZE];
@@ -1228,7 +1226,6 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
 		choose_data_offset(r10_bio, rdev);
 	read_bio->bi_end_io = raid10_end_read_request;
-	read_bio->bi_opf = op | do_sync;
 	if (test_bit(FailFast, &rdev->flags) &&
 	    test_bit(R10BIO_FailFast, &r10_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
@@ -1247,10 +1244,6 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 				  struct bio *bio, bool replacement,
 				  int n_copy)
 {
-	const enum req_op op = bio_op(bio);
-	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
-	const blk_opf_t do_fua = bio->bi_opf & REQ_FUA;
-	const blk_opf_t do_atomic = bio->bi_opf & REQ_ATOMIC;
 	unsigned long flags;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
@@ -1269,7 +1262,6 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	mbio->bi_iter.bi_sector	= (r10_bio->devs[n_copy].addr +
 				   choose_data_offset(r10_bio, rdev));
 	mbio->bi_end_io	= raid10_end_write_request;
-	mbio->bi_opf = op | do_sync | do_fua | do_atomic;
 	if (!replacement && test_bit(FailFast,
 				     &conf->mirrors[devnum].rdev->flags)
 			 && enough(conf, devnum))
-- 
2.39.2

