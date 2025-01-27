Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAD616CD1D;
	Mon, 27 Jan 2025 08:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737968143; cv=none; b=qIn/H9d4tk0jct9KkqEBt9C4ELiyhqpva33DgFo2FUG+Cg75PMpckYj6aidjeJRya0MxYlO/YaisnBP1Hr8GDdPs0CpUBmqj23+M8CO9S6+y86UUVdrxD6mxauHxah58BlEUyO3l5ZlfDqAHxqqR/TG6G+sEIbM87PAUC5s+3kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737968143; c=relaxed/simple;
	bh=kDeOxdMNlpwvXYE5RevsOfdwZQIbEkSUN4dPfzEM+sw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ubBFy8LD3IemtY/a9vEE2mSCDg1HMctrM+TWIUFeGSJ0NuUHYMY0fIah8o1rnajEKU/KRl3TA/QLadIuxmKNhCba7WfNRbBveJbJuTB4J2yxBa3yloP4l3zTFQ79Ho4Kt1ZpsgmvzYI44vxzG/F67DGs21fpp+iS8k1JCVOKJaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YhMgn6Mvrz4f3jqy;
	Mon, 27 Jan 2025 16:55:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 776461A1530;
	Mon, 27 Jan 2025 16:55:33 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2ABSpdnDuF9CA--.54166S8;
	Mon, 27 Jan 2025 16:55:33 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 6.13 4/5] md/raid5: implement pers->bitmap_sector()
Date: Mon, 27 Jan 2025 16:49:27 +0800
Message-Id: <20250127084928.3197157-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250127084928.3197157-1-yukuai1@huaweicloud.com>
References: <20250127084928.3197157-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2ABSpdnDuF9CA--.54166S8
X-Coremail-Antispam: 1UD129KBjvJXoWxWry5Kr1xCFWDZw47Ar45trb_yoWrGF17pa
	nFvrWagrWYqrnxWwsxJw1kuF1rta95Cr47tFW3WwsYg3W7GrWkZ3W8t3W5ZF1UCrWfJr90
	yw1YyFW8CF4qgFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBK14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r
	43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
	JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIx
	AIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU1zpBDUUUUU=
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

commit 9c89f604476cf15c31fbbdb043cff7fbf1dbe0cb upstream.

Bitmap is used for the whole array for raid1/raid10, hence IO for the
array can be used directly for bitmap. However, bitmap is used for
underlying disks for raid5, hence IO for the array can't be used
directly for bitmap.

Implement pers->bitmap_sector() for raid5 to convert IO ranges from the
array to the underlying disks.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250109015145.158868-5-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Yu Kuai <yukuai1@huaweicloud.com>
---
 drivers/md/raid5.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a5a619400d8f..a08f49b47b7e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5918,6 +5918,54 @@ static enum reshape_loc get_reshape_loc(struct mddev *mddev,
 	return LOC_BEHIND_RESHAPE;
 }
 
+static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
+				unsigned long *sectors)
+{
+	struct r5conf *conf = mddev->private;
+	sector_t start = *offset;
+	sector_t end = start + *sectors;
+	sector_t prev_start = start;
+	sector_t prev_end = end;
+	int sectors_per_chunk;
+	enum reshape_loc loc;
+	int dd_idx;
+
+	sectors_per_chunk = conf->chunk_sectors *
+		(conf->raid_disks - conf->max_degraded);
+	start = round_down(start, sectors_per_chunk);
+	end = round_up(end, sectors_per_chunk);
+
+	start = raid5_compute_sector(conf, start, 0, &dd_idx, NULL);
+	end = raid5_compute_sector(conf, end, 0, &dd_idx, NULL);
+
+	/*
+	 * For LOC_INSIDE_RESHAPE, this IO will wait for reshape to make
+	 * progress, hence it's the same as LOC_BEHIND_RESHAPE.
+	 */
+	loc = get_reshape_loc(mddev, conf, prev_start);
+	if (likely(loc != LOC_AHEAD_OF_RESHAPE)) {
+		*offset = start;
+		*sectors = end - start;
+		return;
+	}
+
+	sectors_per_chunk = conf->prev_chunk_sectors *
+		(conf->previous_raid_disks - conf->max_degraded);
+	prev_start = round_down(prev_start, sectors_per_chunk);
+	prev_end = round_down(prev_end, sectors_per_chunk);
+
+	prev_start = raid5_compute_sector(conf, prev_start, 1, &dd_idx, NULL);
+	prev_end = raid5_compute_sector(conf, prev_end, 1, &dd_idx, NULL);
+
+	/*
+	 * for LOC_AHEAD_OF_RESHAPE, reshape can make progress before this IO
+	 * is handled in make_stripe_request(), we can't know this here hence
+	 * we set bits for both.
+	 */
+	*offset = min(start, prev_start);
+	*sectors = max(end, prev_end) - *offset;
+}
+
 static enum stripe_result make_stripe_request(struct mddev *mddev,
 		struct r5conf *conf, struct stripe_request_ctx *ctx,
 		sector_t logical_sector, struct bio *bi)
@@ -8966,6 +9014,7 @@ static struct md_personality raid6_personality =
 	.takeover	= raid6_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
+	.bitmap_sector	= raid5_bitmap_sector,
 };
 static struct md_personality raid5_personality =
 {
@@ -8991,6 +9040,7 @@ static struct md_personality raid5_personality =
 	.takeover	= raid5_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
+	.bitmap_sector	= raid5_bitmap_sector,
 };
 
 static struct md_personality raid4_personality =
@@ -9017,6 +9067,7 @@ static struct md_personality raid4_personality =
 	.takeover	= raid4_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
+	.bitmap_sector	= raid5_bitmap_sector,
 };
 
 static int __init raid5_init(void)
-- 
2.39.2

