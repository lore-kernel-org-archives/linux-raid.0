Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE013431EC;
	Wed, 17 Dec 2025 12:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765973485; cv=none; b=Jq8JqZjth6/croHLSEd+8yw/jcrWjOHx7KvULx7LCUgT4z8MebOtv274zVGmd932Vnw16MGWujT8yqWNYSFnYMLDTcWIlI6vQjOvJx1Dc8pxFHZ8zBJmlEa+GsNakDkgrjddwPtHLCpDYOEkQdMf8VT975e5kDAYEdmtGVEOKyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765973485; c=relaxed/simple;
	bh=8zC8ckEZPOSqxOznjVN8+F9Y212m42xN5I14oi6qhRg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YdKqX+sHIQv7RgQKUn2rF7S4kbBRxK8jNPPVMemfNaxfslP4HKfQzWBhOOIUr8SEA6MZzmGv06w2KhHH6r9G4s5+HWZBUtR9c6j7eFlJ33jTv+J+ByQFkHRJLEUvttEp+9SCFgwZTgYWBWHSF2WF0ws8FJbf3SPYk1bMHPrGOi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dWXh56Bb2zKHN4Z;
	Wed, 17 Dec 2025 20:11:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E96B24056E;
	Wed, 17 Dec 2025 20:11:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_fdnUJp6F0JAg--.52527S16;
	Wed, 17 Dec 2025 20:11:10 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xni@redhat.com,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH 12/15] md: clean up resync_free_folio
Date: Wed, 17 Dec 2025 20:00:10 +0800
Message-Id: <20251217120013.2616531-13-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXd_fdnUJp6F0JAg--.52527S16
X-Coremail-Antispam: 1UD129KBjvJXoW7tFW5uFyxCrW3WF18KFykKrg_yoW8uF17pa
	n8Wr9Iva18GFW8AFs8ZF4UZFy5C3y7J3yUCFWxuws3ZFy3ZFyDWa1UJa4UKr4DXrn8Ga4I
	qFn8GrW3W3W5JF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

The resync_free_folio() helper only wraps a single folio_put() call,
so remove it and call folio_put() directly.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid1-10.c | 5 -----
 drivers/md/raid1.c    | 4 ++--
 drivers/md/raid10.c   | 4 ++--
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 2ff1f8855900..ffbd7bd0f6e8 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -50,11 +50,6 @@ static inline int resync_alloc_folio(struct resync_folio *rf,
 	return 0;
 }
 
-static inline void resync_free_folio(struct resync_folio *rf)
-{
-	folio_put(rf->folio);
-}
-
 /*
  * 'strct resync_folio' stores actual pages used for doing the resync
  *  IO, and it is per-bio, so make .bi_private points to it.
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cf87f36fb7d8..38f86de45dea 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -199,7 +199,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 
 out_free_folio:
 	while (--j >= 0)
-		resync_free_folio(&rfs[j]);
+		folio_put(rfs[j].folio);
 
 out_free_bio:
 	while (++j < conf->raid_disks * 2) {
@@ -222,7 +222,7 @@ static void r1buf_pool_free(void *__r1_bio, void *data)
 
 	for (i = conf->raid_disks * 2; i--; ) {
 		rf = get_resync_folio(r1bio->bios[i]);
-		resync_free_folio(rf);
+		folio_put(rf->folio);
 		bio_uninit(r1bio->bios[i]);
 		kfree(r1bio->bios[i]);
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5afe270f6941..c3ef2ea38b08 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -204,7 +204,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 
 out_free_pages:
 	while (--j >= 0)
-		resync_free_folio(&rfs[j]);
+		folio_put(rfs[j].folio);
 
 	j = 0;
 out_free_bio:
@@ -234,7 +234,7 @@ static void r10buf_pool_free(void *__r10_bio, void *data)
 
 		if (bio) {
 			rf = get_resync_folio(bio);
-			resync_free_folio(rf);
+			folio_put(rf->folio);
 			bio_uninit(bio);
 			kfree(bio);
 		}
-- 
2.39.2

