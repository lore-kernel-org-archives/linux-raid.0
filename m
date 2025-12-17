Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCD8343204;
	Wed, 17 Dec 2025 12:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765973485; cv=none; b=MoeEcy/KwNN0K63B0dWUepUEy9e7HQCRfhuRb8soDOUDZiem4xvVK7TdX7os2bfCUDgmRuy7t5NKaDCeEb1woPpYMxQv6sZJTU0oL08Qj8NY6pNaqFNFPNm2t16F+G8D0MTc5F9lwQooZjsVlg/Hm1Ch67K+folMU9XKpBJw8nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765973485; c=relaxed/simple;
	bh=2Ab+QkKnuMIQmLYghY2bwomLU3UwvZ3X9rWU+Rsk0E0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nSmhN/m8xGAP3c5HBXXzr7fJTQXUJ/ehwGqgAe9Ofep8YE177nUHtwtI4Z+zT3dDYEvU0680sKfYmDiYtdUTzxRY05ujgLRNycNZsXtnHuM+g09R/yQ+eT6m9uCRx9x2WFrg8eQIVvYFiTvdwC9PF+lTy6YKm/CcfYB3Mf8imF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dWXh60pdYzKHN4w;
	Wed, 17 Dec 2025 20:11:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 32D5E40577;
	Wed, 17 Dec 2025 20:11:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_fdnUJp6F0JAg--.52527S19;
	Wed, 17 Dec 2025 20:11:11 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xni@redhat.com,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH 15/15] md/raid1,raid10: fall back to smaller order if sync folio alloc fails
Date: Wed, 17 Dec 2025 20:00:13 +0800
Message-Id: <20251217120013.2616531-16-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251217120013.2616531-1-linan666@huaweicloud.com>
References: <20251217120013.2616531-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXd_fdnUJp6F0JAg--.52527S19
X-Coremail-Antispam: 1UD129KBjvJXoW3XFykWr48XryxtFW8AF47urg_yoW7CrWUpa
	1UGrySv34rtFWfXa93Jr1DuF1Fk34xWFWUCFnrWwn7u3WfWryq9F4UXay5WF1DZFn8AFyj
	q3WDAr45uFs3JaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4
	v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvhFsUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

RESYNC_BLOCK_SIZE (64K) has higher allocation failure chance than 4k,
so retry with lower orders to improve allocation reliability.

A r1/10_bio may have different rf->folio orders. Use minimum order as
r1/10_bio sectors to prevent exceeding size when adding folio to IO later.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid1-10.c | 14 +++++++++++---
 drivers/md/raid1.c    | 13 +++++++++----
 drivers/md/raid10.c   | 28 ++++++++++++++++++++++++++--
 3 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index ffbd7bd0f6e8..e966d11a81e7 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -41,12 +41,20 @@ static void rbio_pool_free(void *rbio, void *data)
 }
 
 static inline int resync_alloc_folio(struct resync_folio *rf,
-				     gfp_t gfp_flags)
+				     gfp_t gfp_flags, int *order)
 {
-	rf->folio = folio_alloc(gfp_flags, get_order(RESYNC_BLOCK_SIZE));
-	if (!rf->folio)
+	struct folio *folio;
+
+	do {
+		folio = folio_alloc(gfp_flags, *order);
+		if (folio)
+			break;
+	} while (--(*order) > 0);
+
+	if (!folio)
 		return -ENOMEM;
 
+	rf->folio = folio;
 	return 0;
 }
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2be2277d4e7e..a9af40cda7dd 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -149,6 +149,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	int need_folio;
 	int j;
 	struct resync_folio *rfs;
+	int order = get_order(RESYNC_BLOCK_SIZE);
 
 	r1_bio = r1bio_pool_alloc(gfp_flags, conf);
 	if (!r1_bio)
@@ -182,7 +183,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 		struct resync_folio *rf = &rfs[j];
 
 		if (j < need_folio) {
-			if (resync_alloc_folio(rf, gfp_flags))
+			if (resync_alloc_folio(rf, gfp_flags, &order))
 				goto out_free_folio;
 		} else {
 			memcpy(rf, &rfs[0], sizeof(*rf));
@@ -193,6 +194,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 		r1_bio->bios[j]->bi_private = rf;
 	}
 
+	r1_bio->sectors = 1 << (order + PAGE_SECTORS_SHIFT);
 	r1_bio->master_bio = NULL;
 
 	return r1_bio;
@@ -2767,7 +2769,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	int write_targets = 0, read_targets = 0;
 	sector_t sync_blocks;
 	bool still_degraded = false;
-	int good_sectors = RESYNC_SECTORS;
+	int good_sectors;
 	int min_bad = 0; /* number of sectors that are bad in all devices */
 	int idx = sector_to_idx(sector_nr);
 
@@ -2849,8 +2851,11 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	r1_bio->sector = sector_nr;
 	r1_bio->state = 0;
 	set_bit(R1BIO_IsSync, &r1_bio->state);
-	/* make sure good_sectors won't go across barrier unit boundary */
-	good_sectors = align_to_barrier_unit_end(sector_nr, good_sectors);
+	/*
+	 * make sure good_sectors won't go across barrier unit boundary.
+	 * r1_bio->sectors <= RESYNC_SECTORS.
+	 */
+	good_sectors = align_to_barrier_unit_end(sector_nr, r1_bio->sectors);
 
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		struct md_rdev *rdev;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f3e10e20ebb1..f0e91090097a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -135,6 +135,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 	int j;
 	int nalloc, nalloc_rf;
 	struct resync_folio *rfs;
+	int order = get_order(RESYNC_BLOCK_SIZE);
 
 	r10_bio = r10bio_pool_alloc(gfp_flags, conf);
 	if (!r10_bio)
@@ -185,7 +186,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 
 		if (!j || test_bit(MD_RECOVERY_SYNC,
 				   &conf->mddev->recovery)) {
-			if (resync_alloc_folio(rf, gfp_flags))
+			if (resync_alloc_folio(rf, gfp_flags, &order))
 				goto out_free_pages;
 		} else {
 			memcpy(rf, &rfs[0], sizeof(*rf));
@@ -200,6 +201,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 		}
 	}
 
+	r10_bio->sectors = 1 << (order + PAGE_SECTORS_SHIFT);
 	return r10_bio;
 
 out_free_pages:
@@ -3374,6 +3376,15 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 						continue;
 					}
 				}
+
+				/*
+				 * RESYNC_BLOCK_SIZE folio might alloc failed in
+				 * resync_alloc_folio(). Fall back to smaller sync
+				 * size if needed.
+				 */
+				if (max_sync > r10_bio->sectors)
+					max_sync = r10_bio->sectors;
+
 				any_working = 1;
 				bio = r10_bio->devs[0].bio;
 				bio->bi_next = biolist;
@@ -3525,7 +3536,15 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		}
 		if (sync_blocks < max_sync)
 			max_sync = sync_blocks;
+
 		r10_bio = raid10_alloc_init_r10buf(conf);
+		/*
+		 * RESYNC_BLOCK_SIZE folio might alloc failed in resync_alloc_folio().
+		 * Fall back to smaller sync size if needed.
+		 */
+		if (max_sync > r10_bio->sectors)
+			max_sync = r10_bio->sectors;
+
 		r10_bio->state = 0;
 
 		r10_bio->mddev = mddev;
@@ -4702,7 +4721,12 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	r10_bio->mddev = mddev;
 	r10_bio->sector = sector_nr;
 	set_bit(R10BIO_IsReshape, &r10_bio->state);
-	r10_bio->sectors = last - sector_nr + 1;
+	/*
+	 * RESYNC_BLOCK_SIZE folio might alloc failed in
+	 * resync_alloc_folio(). Fall back to smaller sync
+	 * size if needed.
+	 */
+	r10_bio->sectors = min_t(int, r10_bio->sectors, last - sector_nr + 1);
 	rdev = read_balance(conf, r10_bio, &max_sectors);
 	BUG_ON(!test_bit(R10BIO_Previous, &r10_bio->state));
 
-- 
2.39.2

