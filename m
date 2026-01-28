Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139193382DA;
	Wed, 28 Jan 2026 08:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769587585; cv=none; b=qJrduDmc7VOor4pU9Hqyif1Bm1wy0tc7dRfsHycvRa2EgwGkJf71rJIStBoMvnJO1RW5K0xrc0eQXm4k5qHDahQYlq/y9lAtWisJ1a65jbCqpvzqDsdf5V9Ke3cbdsjEw92WureuWuF2Tr89ngm3fKQ/mISFmcuxubt94ICjHTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769587585; c=relaxed/simple;
	bh=BUB2U5HlQfzITHvCbVqC9FXEMMg9pMLz3dr2kFJbIuk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IWiAJKh9jL6EgAy4Cr9rT2JYY2NV99D89a2nKnACmTxsoG7JqcWA0xnQK4pyEl7OG1yCWKG9xpsxoWaiEhb3eVd4/L8uch15HctXMUrqhVgD71IHtUHFXqmBckz3DxQx/1Pi/mrwahssECnwiQWIamtGxasO76r5DKphFi9A3h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f1FFY5kWjzYQv1K;
	Wed, 28 Jan 2026 16:05:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B95E340539;
	Wed, 28 Jan 2026 16:06:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvd1w3lpPgyWFQ--.43207S14;
	Wed, 28 Jan 2026 16:06:14 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: xni@redhat.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 10/14] md/raid1,raid10: clean up resync_fetch_folio
Date: Wed, 28 Jan 2026 15:57:04 +0800
Message-Id: <20260128075708.2259525-11-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260128075708.2259525-1-linan666@huaweicloud.com>
References: <20260128075708.2259525-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBnFvd1w3lpPgyWFQ--.43207S14
X-Coremail-Antispam: 1UD129KBjvJXoWxCrWDtw4xXw4xJrW5JryDGFg_yoW5WF47pa
	nFgrZxXw48Kay8Aws8ZF48C3WFka43tryjyF4xW3s7uFyfXFyqgF4UXay8WF98XF98K34F
	qa48t3y5Z3WrJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQ014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCF
	x2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14
	v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY
	67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYVyIDUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

The helper resync_fetch_folio() only returns the folio member without
any additional logic. Clean it up by accessing rf->folio directly.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid1-10.c |  7 +------
 drivers/md/raid1.c    | 10 ++++------
 drivers/md/raid10.c   |  3 +--
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 568ab002691f..2ff1f8855900 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -55,11 +55,6 @@ static inline void resync_free_folio(struct resync_folio *rf)
 	folio_put(rf->folio);
 }
 
-static inline struct folio *resync_fetch_folio(struct resync_folio *rf)
-{
-	return rf->folio;
-}
-
 /*
  * 'strct resync_folio' stores actual pages used for doing the resync
  *  IO, and it is per-bio, so make .bi_private points to it.
@@ -74,7 +69,7 @@ static void md_bio_reset_resync_folio(struct bio *bio, struct resync_folio *rf,
 			       int size)
 {
 	/* initialize bvec table again */
-	if (WARN_ON(!bio_add_folio(bio, resync_fetch_folio(rf),
+	if (WARN_ON(!bio_add_folio(bio, rf->folio,
 				   min_t(int, size, RESYNC_BLOCK_SIZE),
 				   0))) {
 		bio->bi_status = BLK_STS_RESOURCE;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 27e3b2375b16..a303349eeff4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2981,8 +2981,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		max_sector = sector_nr + good_sectors;
 	nr_sectors = 0;
 	do {
-		struct folio *folio;
 		int len = RESYNC_BLOCK_SIZE;
+
 		if (sector_nr + (len>>9) > max_sector)
 			len = (max_sector - sector_nr) << 9;
 		if (len == 0)
@@ -2996,13 +2996,11 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 			len = sync_blocks<<9;
 
 		for (i = 0 ; i < conf->raid_disks * 2; i++) {
-			struct resync_folio *rf;
-
 			bio = r1_bio->bios[i];
-			rf = get_resync_folio(bio);
 			if (bio->bi_end_io) {
-				folio = resync_fetch_folio(rf);
-				bio_add_folio_nofail(bio, folio, len, 0);
+				struct resync_folio *rf = get_resync_folio(bio);
+
+				bio_add_folio_nofail(bio, rf->folio, len, 0);
 			}
 		}
 		nr_sectors += len>>9;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 06257eea97ed..d8a5fadfc933 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3630,9 +3630,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			break;
 		for (bio= biolist ; bio ; bio=bio->bi_next) {
 			struct resync_folio *rf = get_resync_folio(bio);
-			struct folio *folio = resync_fetch_folio(rf);
 
-			if (WARN_ON(!bio_add_folio(bio, folio, len, 0))) {
+			if (WARN_ON(!bio_add_folio(bio, rf->folio, len, 0))) {
 				bio->bi_status = BLK_STS_RESOURCE;
 				bio_endio(bio);
 				*skipped = 1;
-- 
2.39.2

