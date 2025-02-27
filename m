Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D5422CBC9;
	Thu, 27 Feb 2025 12:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740658151; cv=none; b=X3k/35iJKvxvBdLERI2NvUa5IF5PStLT6AiNvW901WYOeE/bf0NRy+J/ZGpiDYaGTA//EJbsVPKLGbIZx56OoYfJKNyzWvi3MBcB8dz4LYmCZOUqkpWIHfDzTNQG3mh+LACVMgMKqPle4h32G7tE0X1akDuFxlUU080Rq5AU8e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740658151; c=relaxed/simple;
	bh=/fleRfFAR2Ajiahigv6r9BtBewlXsM8Z+XAOx2X9m38=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rhrJXRo3As9lVNJNCcE8uE4eJB4p04DbLn7prfAYkPTpjzM/O/hEWdGDP8L8O4dahm2qDh4ll5ThrHW7nSHvRsJjIHH9rTv4yFHkqbx4zUnPeurgBY3p/qE3AXkceRc1y2A0eD2AUGXQdp4CxHA3zrVE+PHa8JI3DfbG5imb7+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z3VVX5Tdxz4f3kvw;
	Thu, 27 Feb 2025 20:08:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 194AA1A06D7;
	Thu, 27 Feb 2025 20:09:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB32l7aVcBnqbAxFA--.33449S4;
	Thu, 27 Feb 2025 20:08:59 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH] md/raid5: merge reshape_progress checking inside get_reshape_loc()
Date: Thu, 27 Feb 2025 20:04:52 +0800
Message-Id: <20250227120452.808503-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB32l7aVcBnqbAxFA--.33449S4
X-Coremail-Antispam: 1UD129KBjvJXoW7WFWkZw45Ww4xurWrtr1UKFg_yoW8tFW7pa
	nxKFy2grykZrn3trsxJ34j9ryrC39rGFWYkan7G34xuF1ktr97Wa1rWryYqF1UXFZ3XrW3
	t3W5AFy8Cr1Yga7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

During code review, it's found that other than raid5_bitmap_sector(),
reshape_progress is always checked before get_reshape_loc(), while
raid5_bitmap_sector() should check as well to prevent holding the
lock 'conf->device_lock'. Hence merge that checking inside
get_reshape_loc().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid5.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5c79429acc64..73fb0223d8a9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5858,6 +5858,9 @@ static enum reshape_loc get_reshape_loc(struct mddev *mddev,
 		struct r5conf *conf, sector_t logical_sector)
 {
 	sector_t reshape_progress, reshape_safe;
+
+	if (likely(conf->reshape_progress == MaxSector))
+		return LOC_NO_RESHAPE;
 	/*
 	 * Spinlock is needed as reshape_progress may be
 	 * 64bit on a 32bit platform, and so it might be
@@ -5935,22 +5938,19 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 	const int rw = bio_data_dir(bi);
 	enum stripe_result ret;
 	struct stripe_head *sh;
+	enum reshape_loc loc;
 	sector_t new_sector;
 	int previous = 0, flags = 0;
 	int seq, dd_idx;
 
 	seq = read_seqcount_begin(&conf->gen_lock);
-
-	if (unlikely(conf->reshape_progress != MaxSector)) {
-		enum reshape_loc loc = get_reshape_loc(mddev, conf,
-						       logical_sector);
-		if (loc == LOC_INSIDE_RESHAPE) {
-			ret = STRIPE_SCHEDULE_AND_RETRY;
-			goto out;
-		}
-		if (loc == LOC_AHEAD_OF_RESHAPE)
-			previous = 1;
+	loc = get_reshape_loc(mddev, conf, logical_sector);
+	if (loc == LOC_INSIDE_RESHAPE) {
+		ret = STRIPE_SCHEDULE_AND_RETRY;
+		goto out;
 	}
+	if (loc == LOC_AHEAD_OF_RESHAPE)
+		previous = 1;
 
 	new_sector = raid5_compute_sector(conf, logical_sector, previous,
 					  &dd_idx, NULL);
@@ -6127,7 +6127,6 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 
 	/* Bail out if conflicts with reshape and REQ_NOWAIT is set */
 	if ((bi->bi_opf & REQ_NOWAIT) &&
-	    (conf->reshape_progress != MaxSector) &&
 	    get_reshape_loc(mddev, conf, logical_sector) == LOC_INSIDE_RESHAPE) {
 		bio_wouldblock_error(bi);
 		if (rw == WRITE)
-- 
2.39.2

