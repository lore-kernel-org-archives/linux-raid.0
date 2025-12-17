Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED2233E35D;
	Wed, 17 Dec 2025 12:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765973485; cv=none; b=fh008bKMZjsB7OMAfBjYLljPntXsYuiomz4i6l4eHh7t2UQltsBaXl99ihoWvBi4XqFV/SZA/EphvESmMkM7s7+OZdE3jxl/ofO7+Xr0EXEoWQ7qIfaGWfTWzIDwRd7/xRmBap8w8nCXU9j+w+nPCjX4JwZdYUih0a5SrqOAWR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765973485; c=relaxed/simple;
	bh=2lovPEcp877LJDlQA4BGV3f9E2/j2yk4BPX0zKENcjg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SPK5Fq2HdHLy5+XvGtu6j8PGSZvRF3LhDt8P9iUU1yDiBQdlcgKLnLqKcK+ZY+1aaofNPEtc2xOE5qXS+I9mGQOq72Ol4w2l6EDYqB2Gru0yU1kkEQP6juhdaeq5AP1K9oVGm9xTnP+Xt7kEs6euP9JcbFI1L88SDWch7p93vy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dWXh56jxgzKHN4w;
	Wed, 17 Dec 2025 20:11:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 073054056F;
	Wed, 17 Dec 2025 20:11:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_fdnUJp6F0JAg--.52527S17;
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
Subject: [PATCH 13/15] md/raid1: clean up sync IO size calculation in raid1_sync_request
Date: Wed, 17 Dec 2025 20:00:11 +0800
Message-Id: <20251217120013.2616531-14-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXd_fdnUJp6F0JAg--.52527S17
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw1DAry7WFWUKr1DWFWfZrb_yoW8AF15pw
	nxGr9Ig3yrGa13XwnxAa4UCF1FkFy3KrWUJFWSgwnxWF97CrnFka18XF1YgFyDZa43trZ8
	X34kAr45A3WkJaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Use 'nr_sectors' directly for sync IO size calculation. Prepare folio
allocation failure fallback.

No functional changes.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid1.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 38f86de45dea..2be2277d4e7e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2970,21 +2970,19 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		max_sector = mddev->resync_max; /* Don't do IO beyond here */
 	if (max_sector > sector_nr + good_sectors)
 		max_sector = sector_nr + good_sectors;
-	nr_sectors = 0;
 	do {
 		struct folio *folio;
-		int len = RESYNC_BLOCK_SIZE;
-		if (sector_nr + (len>>9) > max_sector)
-			len = (max_sector - sector_nr) << 9;
-		if (len == 0)
+
+		nr_sectors = max_sector - sector_nr;
+		if (nr_sectors == 0)
 			break;
 		if (!md_bitmap_start_sync(mddev, sector_nr,
 					  &sync_blocks, still_degraded) &&
 		    !conf->fullsync &&
 		    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 			break;
-		if ((len >> 9) > sync_blocks)
-			len = sync_blocks<<9;
+		if (nr_sectors > sync_blocks)
+			nr_sectors = sync_blocks;
 
 		for (i = 0 ; i < conf->raid_disks * 2; i++) {
 			struct resync_folio *rf;
@@ -2998,11 +2996,10 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 				 * won't fail because the vec table is big
 				 * enough to hold all these pages
 				 */
-				bio_add_folio_nofail(bio, folio, len, 0);
+				bio_add_folio_nofail(bio, folio, nr_sectors << 9, 0);
 			}
 		}
-		nr_sectors += len>>9;
-		sector_nr += len>>9;
+		sector_nr += nr_sectors;
 	} while (0);
 
 	r1_bio->sectors = nr_sectors;
-- 
2.39.2

