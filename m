Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EA333E35C;
	Wed, 28 Jan 2026 08:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769587588; cv=none; b=m1CAnW0/1bmX69VEutM0ccS4ZgUUm4oIru4VdDFwcTOxQotmwSHIJMVCYWlVMjB/X5d9Htjqbqdo9rnzRLz+hFlJssOi+/bHIvc27ApaMvFyCbdm9SKfV3OclpD3hVZ51vqQVSkjqf6sr6IK+P+FrN54NgQ9ssYQhtnEcHoagLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769587588; c=relaxed/simple;
	bh=OQzhPQQuk4PYy9Nvn1MQer5EX0ZLWqiPDUVNKKCVVXw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=obhPygLdHxXrWQ/DmGZObEW1aJHy9MS9q2YSu4o8gsX2skBfgYOk1U1+lNLAIftVaA0x3PosyefDoJtPls1LF9sQYObcP+PkGMuaTZ1W4LmHk0NjRiSJ2wNFm5DcnWtMq7uim9J8cTTNnSPM+G3I0hEiIT0Td2R/e1X70G8u3A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f1FG25Cd9zKHMlN;
	Wed, 28 Jan 2026 16:06:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E509240593;
	Wed, 28 Jan 2026 16:06:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvd1w3lpPgyWFQ--.43207S16;
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
Subject: [PATCH v2 12/14] md/raid1: clean up sync IO size calculation in raid1_sync_request
Date: Wed, 28 Jan 2026 15:57:06 +0800
Message-Id: <20260128075708.2259525-13-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBnFvd1w3lpPgyWFQ--.43207S16
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw1DAry7WFWUKr45tw1rXrb_yoW8WF1rpw
	nxGr93W3y8JF45Zw13Jw1UCF1FkFy5KrWUJF4SgwnrWFn7Gr9rCF48XF1YgFyDua4ftrWr
	X34kAr45A3WDJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 drivers/md/raid1.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b5239b5cb4e9..2253e65c5f03 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2979,32 +2979,27 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		max_sector = mddev->resync_max; /* Don't do IO beyond here */
 	if (max_sector > sector_nr + good_sectors)
 		max_sector = sector_nr + good_sectors;
-	nr_sectors = 0;
 	do {
-		int len = RESYNC_BLOCK_SIZE;
-
-		if (sector_nr + (len>>9) > max_sector)
-			len = (max_sector - sector_nr) << 9;
-		if (len == 0)
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
 			bio = r1_bio->bios[i];
 			if (bio->bi_end_io) {
 				struct resync_folio *rf = get_resync_folio(bio);
 
-				bio_add_folio_nofail(bio, rf->folio, len, 0);
+				bio_add_folio_nofail(bio, rf->folio, nr_sectors << 9, 0);
 			}
 		}
-		nr_sectors += len>>9;
-		sector_nr += len>>9;
+		sector_nr += nr_sectors;
 	} while (0);
 
 	r1_bio->sectors = nr_sectors;
-- 
2.39.2

