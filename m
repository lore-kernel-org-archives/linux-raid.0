Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC80532A3C2;
	Wed, 17 Dec 2025 12:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765973481; cv=none; b=V/isd8RtDpo65Eew/w6n5hkiGi+TmrKdzqgbWROmZfUEZG0bJDQLsbJvVhbxPOkiYViOVicHnaiMqXjurl4LBLFO92j8dJPmwN0UCfMFWxkQgRYlTcqlSlEvHS4zFvHwB3xUX6BKMXdOfpnGziEaJkMwKWmkXOUGKkUWUbECXcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765973481; c=relaxed/simple;
	bh=89xAFIJo2kmpQ+WPh636tStbkdYmmswMN8cLscxBEYM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZBEuB7V9aTbJaCDN0b7RbWfltD5N0ynlPVTssgZBLPzLldMudFlKLuq00u8fGdSgtMCu6BVMbuwy9mrqtfs9a+yyEKb5PRn5/55U8axN59Xq98+YhLdBHyQspvioAxPDxvyv6dqw0yJWL5Y0onhYMc/hz4T1SI4phvd0Nued1V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dWXh54STFzKHN4D;
	Wed, 17 Dec 2025 20:11:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id ADBFE40575;
	Wed, 17 Dec 2025 20:11:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_fdnUJp6F0JAg--.52527S12;
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
Subject: [PATCH 08/15] md/raid1: clean up useless sync_blocks handling in raid1_sync_request
Date: Wed, 17 Dec 2025 20:00:06 +0800
Message-Id: <20251217120013.2616531-9-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXd_fdnUJp6F0JAg--.52527S12
X-Coremail-Antispam: 1UD129KBjvJXoW7CF43Ar43JF1kCw4DGr1rJFb_yoW8AF17pa
	17Jryag345WFW5ZasxAr1UCFyFkFy7trWUJryfW3s7WFZ7Gr97CF48X3WagFyqqa43trW5
	X3s5Ar45CF13tF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Since the loop is changed to while(0), some handling of sync_blocks
in raid1_sync_request() is no longer needed and can be removed.

No functional changes.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid1.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f01bab41da95..432ab96ec1cc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2976,7 +2976,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	if (max_sector > sector_nr + good_sectors)
 		max_sector = sector_nr + good_sectors;
 	nr_sectors = 0;
-	sync_blocks = 0;
 	do {
 		struct folio *folio;
 		int len = RESYNC_BLOCK_SIZE;
@@ -2984,15 +2983,13 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 			len = (max_sector - sector_nr) << 9;
 		if (len == 0)
 			break;
-		if (sync_blocks == 0) {
-			if (!md_bitmap_start_sync(mddev, sector_nr,
-						  &sync_blocks, still_degraded) &&
-			    !conf->fullsync &&
-			    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
-				break;
-			if ((len >> 9) > sync_blocks)
-				len = sync_blocks<<9;
-		}
+		if (!md_bitmap_start_sync(mddev, sector_nr,
+					  &sync_blocks, still_degraded) &&
+		    !conf->fullsync &&
+		    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+			break;
+		if ((len >> 9) > sync_blocks)
+			len = sync_blocks<<9;
 
 		for (i = 0 ; i < conf->raid_disks * 2; i++) {
 			struct resync_folio *rf;
@@ -3011,7 +3008,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		}
 		nr_sectors += len>>9;
 		sector_nr += len>>9;
-		sync_blocks -= (len>>9);
 	} while (0);
 
 	r1_bio->sectors = nr_sectors;
-- 
2.39.2

