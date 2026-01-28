Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962B533AD98;
	Wed, 28 Jan 2026 08:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769587586; cv=none; b=hyB1csmBH03oHv2fZvHvDXUOKqsI2JrL39YI3v5kr42XVRdyeAxYm3Qq+HYt1abKdVCRE0JL8fjKK5vCnqtLcuqNGjpPx0oBfadViknnoTbvSHaJDOKMNohdmC0ftVqqPmTkqVFFVDLd85U0GhcsGrBW1T/31GqiFaNR8PAWtIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769587586; c=relaxed/simple;
	bh=t3zzn+TK20wic0tjff/CfXNfXyZZYq/ohxmBT7DuvLg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p+UsBkJnR5VrRLCWFe6mFnpdgrvm6HfN4sH2PLvrBr+93TsiXzzNVcyV7eHz1XcQ54rgwRy2JllK8oP2Ky9LaHejmleXhpBT8UxOYJIcsUzG7yLREofzWmb0JTVm+5gkWWo7DpG/oAL29P7J51t40lzCHXyz4lzrkS14TN1USP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f1FG226j9zKHMl1;
	Wed, 28 Jan 2026 16:06:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7A23F4056E;
	Wed, 28 Jan 2026 16:06:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvd1w3lpPgyWFQ--.43207S10;
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
Subject: [PATCH v2 06/14] md: Clean up folio sync support related code
Date: Wed, 28 Jan 2026 15:57:00 +0800
Message-Id: <20260128075708.2259525-7-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBnFvd1w3lpPgyWFQ--.43207S10
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4rJr18CF1rXrW8XFWxCrg_yoW5uFy8pa
	9rGrySv3yrKF48ZF4Dtw4UAayFk34Yga4UCFWfua97uF13ZFyDKF4jqa48Jr1DAF95Ca4F
	qF93Ja1UXa15tF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYVyIDUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

1. Remove resync_get_all_folio() and invoke folio_get() directly instead.
2. Clean up redundant while(0) loop in md_bio_reset_resync_folio().
3. Clean up bio variable by directly referencing r10_bio->devs[j].bio
   instead in r1buf_pool_alloc() and r10buf_pool_alloc().
4. Clean up RESYNC_PAGES.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid1-10.c | 22 ++++++----------------
 drivers/md/raid1.c    |  6 ++----
 drivers/md/raid10.c   |  6 ++----
 3 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 300fbe9dc02e..568ab002691f 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Maximum size of each resync request */
 #define RESYNC_BLOCK_SIZE (64*1024)
-#define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
 #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
 
 /*
@@ -56,11 +55,6 @@ static inline void resync_free_folio(struct resync_folio *rf)
 	folio_put(rf->folio);
 }
 
-static inline void resync_get_folio(struct resync_folio *rf)
-{
-	folio_get(rf->folio);
-}
-
 static inline struct folio *resync_fetch_folio(struct resync_folio *rf)
 {
 	return rf->folio;
@@ -80,16 +74,12 @@ static void md_bio_reset_resync_folio(struct bio *bio, struct resync_folio *rf,
 			       int size)
 {
 	/* initialize bvec table again */
-	do {
-		struct folio *folio = resync_fetch_folio(rf);
-		int len = min_t(int, size, RESYNC_BLOCK_SIZE);
-
-		if (WARN_ON(!bio_add_folio(bio, folio, len, 0))) {
-			bio->bi_status = BLK_STS_RESOURCE;
-			bio_endio(bio);
-			return;
-		}
-	} while (0);
+	if (WARN_ON(!bio_add_folio(bio, resync_fetch_folio(rf),
+				   min_t(int, size, RESYNC_BLOCK_SIZE),
+				   0))) {
+		bio->bi_status = BLK_STS_RESOURCE;
+		bio_endio(bio);
+	}
 }
 
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d9c106529289..5954ead7dfd4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -181,18 +181,16 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	for (j = 0; j < conf->raid_disks * 2; j++) {
 		struct resync_folio *rf = &rfs[j];
 
-		bio = r1_bio->bios[j];
-
 		if (j < need_folio) {
 			if (resync_alloc_folio(rf, gfp_flags))
 				goto out_free_folio;
 		} else {
 			memcpy(rf, &rfs[0], sizeof(*rf));
-			resync_get_folio(rf);
+			folio_get(rf->folio);
 		}
 
 		rf->raid_bio = r1_bio;
-		bio->bi_private = rf;
+		r1_bio->bios[j]->bi_private = rf;
 	}
 
 	r1_bio->master_bio = NULL;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7533aeb23819..5c0975ec8809 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -183,19 +183,17 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 		if (rbio)
 			rf_repl = &rfs[nalloc + j];
 
-		bio = r10_bio->devs[j].bio;
-
 		if (!j || test_bit(MD_RECOVERY_SYNC,
 				   &conf->mddev->recovery)) {
 			if (resync_alloc_folio(rf, gfp_flags))
 				goto out_free_folio;
 		} else {
 			memcpy(rf, &rfs[0], sizeof(*rf));
-			resync_get_folio(rf);
+			folio_get(rf->folio);
 		}
 
 		rf->raid_bio = r10_bio;
-		bio->bi_private = rf;
+		r10_bio->devs[j].bio->bi_private = rf;
 		if (rbio) {
 			memcpy(rf_repl, rf, sizeof(*rf));
 			rbio->bi_private = rf_repl;
-- 
2.39.2

