Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B019830B529;
	Thu, 16 Apr 2026 03:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776311447; cv=none; b=XutjN6U2cFkbyctKJT22uVjk2qraW4WX1dgUl72EjOhONiolkiXtcy0RiAO+jyljxdV+LEFVHW4chBVdW44SMuLkXRsCVEOdc6XWs8FebsFpiSK+REqKR1FljcyShy0xiJkuTq4TFrTiChdKhuyEBYerq92zo538GaYPZF6t108=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776311447; c=relaxed/simple;
	bh=0/Weum56tYesfsI2M5mjBMd5+QZ6/NKzSDzxKwdxG9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BTyfVuzy3hMbQo/rG/6+P+zBKx8knrVr+7l+62dacbtWwptTJGT3/SURYElpm03Rv+1E3O74MOMCm4cOUJlv3paPv9U3sDVfXDQ74tHKIUcQEpJ+BslsOm8YH3PrUDMtgQ2q/TnGDH1tiLnTXTrcdjiJl243Ac+NAYitH+gb4as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fx3tw2c2TzKHMKJ;
	Thu, 16 Apr 2026 11:50:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 0E65440577;
	Thu, 16 Apr 2026 11:50:27 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP3 (Coremail) with SMTP id _Ch0CgCHM72BXOBpn95JAg--.61021S5;
	Thu, 16 Apr 2026 11:50:26 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 1/8] md/raid1,raid10: clean up of RESYNC_SECTORS
Date: Thu, 16 Apr 2026 11:37:54 +0800
Message-Id: <20260416033801.786415-2-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260416033801.786415-1-linan666@huaweicloud.com>
References: <20260416033801.786415-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCHM72BXOBpn95JAg--.61021S5
X-Coremail-Antispam: 1UD129KBjvJXoWxWr4fXF4fKF18XF15GFyxuFg_yoW5GFy5pa
	1DGFyfZw4UKF47Aas7JayUuayrA3Wxt3yUCFn5ZaykuFy3XrZrXrWjqayYgF1DXFn5tFyj
	qw1qkr45ZFy3taDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmG14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2vY
	z4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvj
	eVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I
	1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8
	JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjWxRPUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Move redundant RESYNC_SECTORS definition from raid1 and raid10
implementations to raid1-10.c.

Simplify max_sync assignment in raid10_sync_request().

No functional changes.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid1-10.c | 1 +
 drivers/md/raid1.c    | 1 -
 drivers/md/raid10.c   | 4 +---
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index c33099925f23..cda531d0720b 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -2,6 +2,7 @@
 /* Maximum size of each resync request */
 #define RESYNC_BLOCK_SIZE (64*1024)
 #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
+#define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
 
 /* when we get a read error on a read-only array, we redirect to another
  * device without failing the first device, or trying to over-write to
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 867db18bc3ba..5a73a9f19e0e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -136,7 +136,6 @@ static void *r1bio_pool_alloc(gfp_t gfp_flags, struct r1conf *conf)
 }
 
 #define RESYNC_DEPTH 32
-#define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
 #define RESYNC_WINDOW (RESYNC_BLOCK_SIZE * RESYNC_DEPTH)
 #define RESYNC_WINDOW_SECTORS (RESYNC_WINDOW >> 9)
 #define CLUSTER_RESYNC_WINDOW (16 * RESYNC_WINDOW)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b4892c5d571c..90c1036f6ec4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -113,7 +113,6 @@ static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 	return kzalloc(size, gfp_flags);
 }
 
-#define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
 /* amount of memory to reserve for resync requests */
 #define RESYNC_WINDOW (1024*1024)
 /* maximum number of concurrent requests, memory permitting */
@@ -3153,7 +3152,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	struct bio *biolist = NULL, *bio;
 	sector_t nr_sectors;
 	int i;
-	int max_sync;
+	int max_sync = RESYNC_SECTORS;
 	sector_t sync_blocks;
 	sector_t chunk_mask = conf->geo.chunk_mask;
 	int page_idx = 0;
@@ -3266,7 +3265,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	 * end_sync_write if we will want to write.
 	 */
 
-	max_sync = RESYNC_PAGES << (PAGE_SHIFT-9);
 	if (!test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 		/* recovery... the complicated one */
 		int j;
-- 
2.39.2

