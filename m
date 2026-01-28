Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D1733B6E7;
	Wed, 28 Jan 2026 08:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769587585; cv=none; b=RWjh25bM9+3BaJtpW0bMZwy5UsyPy4MpLgNnE6nMeAsXU+a6vxL6k8KtonNpDh0OULz6Toso8gjlKQQtHfZ5dmmT4cqpIIwiLKtRFgDZq8wDFKIcKzeaHnmEuicr+qlmLxIncJZhD5xS0mBeetlo7w0lJbynQFBupB6XgcUS0x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769587585; c=relaxed/simple;
	bh=yfudnzEzQRr7C5O99A5U/bgzRdWaEJ6Vw+8Jo3UY7Xo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vv9SlVEjkyvDU5CNH0LI7F8WRdsoz2TEmQ3zsaXcwD4F3zMXmLlvY0TrDCi8Cc9/CwhlOix04jiNIV3xju7kvp5vyT/uIQ8ENT6uyfUlOdKwLBnp83J3vhdLgj9kMc8fA1Menvk+J5G+hJsEH3zPbGsrmgB7rm+IWs5qChs0+pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f1FFZ0RQmzYQv1K;
	Wed, 28 Jan 2026 16:05:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 02AE74056E;
	Wed, 28 Jan 2026 16:06:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvd1w3lpPgyWFQ--.43207S17;
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
Subject: [PATCH v2 13/14] md/raid10: clean up sync IO size calculation in raid10_sync_request
Date: Wed, 28 Jan 2026 15:57:07 +0800
Message-Id: <20260128075708.2259525-14-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBnFvd1w3lpPgyWFQ--.43207S17
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw1DAry7WF4fCF47Jw18Xwb_yoW8Gr4fpF
	1DGr97W3y8ta18Zws8Ja1UC3WFyas5trWjyrWxW3ZxGF1fur9Fka18XF1FgFyDWa43GryY
	q34vyr4Yy3Z7JF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 drivers/md/raid10.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b728131bdad4..030812f908ac 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3618,28 +3618,24 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		}
 	}
 
-	nr_sectors = 0;
 	if (sector_nr + max_sync < max_sector)
 		max_sector = sector_nr + max_sync;
 	do {
-		int len = RESYNC_BLOCK_SIZE;
+		nr_sectors = max_sector - sector_nr;
 
-		if (sector_nr + (len>>9) > max_sector)
-			len = (max_sector - sector_nr) << 9;
-		if (len == 0)
+		if (nr_sectors == 0)
 			break;
 		for (bio= biolist ; bio ; bio=bio->bi_next) {
 			struct resync_folio *rf = get_resync_folio(bio);
 
-			if (WARN_ON(!bio_add_folio(bio, rf->folio, len, 0))) {
+			if (WARN_ON(!bio_add_folio(bio, rf->folio, nr_sectors << 9, 0))) {
 				bio->bi_status = BLK_STS_RESOURCE;
 				bio_endio(bio);
 				*skipped = 1;
-				return len;
+				return nr_sectors << 9;
 			}
 		}
-		nr_sectors += len>>9;
-		sector_nr += len>>9;
+		sector_nr += nr_sectors;;
 	} while (0);
 	r10_bio->sectors = nr_sectors;
 
-- 
2.39.2

