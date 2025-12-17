Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB9E343201;
	Wed, 17 Dec 2025 12:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765973485; cv=none; b=UXR0qPge5ZzE5zt4Z0F2eX9eBT6k5Fp5N/ZyGxDACwj9KUXxvf6/ImS+Z/CJqd6vMiQ3ZDvz400n/rAXCws3EM62s0mfBCoAzX+TYUmZ4vQ1rrgzmKAP9De5GBSXtsMcQ8Mf+xcoG6M6cEKYp2coW1lMjzT1jlBqMydEacAXVug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765973485; c=relaxed/simple;
	bh=pQBpAPQxfq/M/ibNQjzbJURavGAoUDSIa2Jdzm/a1Uk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rA9sCDmg5NpOKKzRDXYStfKwdYZmKIQ59lFVL9OYJWd+PW59A1/hyL9WTfphQ9RszcluU3tYCXu5Rca1TOJyICQ3kUTu7YaT2fhjjbgaz+zqUmKFiiEIDB9kGAumvq695NwDG2jM+JzbgWSf/TdEaHQStbOXfgQlWGZgeSlvbLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dWXh60PMjzKHN4p;
	Wed, 17 Dec 2025 20:11:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1FBCB40576;
	Wed, 17 Dec 2025 20:11:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_fdnUJp6F0JAg--.52527S18;
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
Subject: [PATCH 14/15] md/raid10: clean up sync IO size calculation in raid10_sync_request
Date: Wed, 17 Dec 2025 20:00:12 +0800
Message-Id: <20251217120013.2616531-15-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXd_fdnUJp6F0JAg--.52527S18
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw1DAry7WF4fCF47Jw18Xwb_yoW8Gr4fpF
	4DGr97W3y8Ja18Zw45J3WUu3WFya93trWUAr4xW3Z3WF1fCr9Fka18J3WFgFyDXFy3GrWY
	qw18Ar45A3WkJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
index c3ef2ea38b08..f3e10e20ebb1 100644
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

