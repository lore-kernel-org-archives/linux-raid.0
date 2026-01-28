Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A463382D2;
	Wed, 28 Jan 2026 08:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769587585; cv=none; b=u37LqDhl80ORV9Zr43NK0rLUxbsyd/Q404vy0L84LeP6riWKpHaMHFNShcXFDLoR5IlTaK+jO2r7ndzx8Iym8o82gXjJjPHBJA0HGVyUAeooKlMuAX0LlPDmo5AOGhPpl1PNvDIqvDIEL+PzqKrhwU6rfpkfeel641N+CzVKNWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769587585; c=relaxed/simple;
	bh=v1ca4ji6icjqN01yAKdlL3ILFAmiqg1Q9Weya/OoKH0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b+k4TdP90ea9CNOgT93WCj3Y9mocUq25ARTk3dV7Y+uphAsear0BLJnhHM21JmsHgVkIWuFjm7zqQxNW19CWWpexstFVsgBzw5/7Wnl0nh2VOW8GZvyqVslshsjdTHr6wUP4Uqt43tJVijyBooXQ/LqVElHe6aerTAfgHHIhtmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f1FFZ0kQrzYQv2R;
	Wed, 28 Jan 2026 16:05:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D040E4056B;
	Wed, 28 Jan 2026 16:06:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvd1w3lpPgyWFQ--.43207S15;
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
Subject: [PATCH v2 11/14] md: clean up resync_free_folio
Date: Wed, 28 Jan 2026 15:57:05 +0800
Message-Id: <20260128075708.2259525-12-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBnFvd1w3lpPgyWFQ--.43207S15
X-Coremail-Antispam: 1UD129KBjvJXoW7tFW5uFyxCrW3WF18KFykKrg_yoW8uF17pa
	n8Wr9Ivw48GFW8AF4DZF4UZFy5Cay7K3yjkFWxuws3ZFy3ZFyDWa1UJa4UKr4DXrn8Ga4I
	qF98GrW3XF1rJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
index a303349eeff4..b5239b5cb4e9 100644
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
index d8a5fadfc933..b728131bdad4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -204,7 +204,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 
 out_free_folio:
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

