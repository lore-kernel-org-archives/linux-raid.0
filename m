Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6D63382F9;
	Wed, 28 Jan 2026 08:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769587579; cv=none; b=NkubgcsJUI/qGo94ttwPmAuddaMNGIVeg9SOXxfwSp/GsCDPJMPMBz2yFg6ylcL1uuH0STo9dUuqTu+dllSXr1RMAp4+x8lV88yC1xzEuTz/sV+wnQnlTi56ENbae7qB25DHGoiZKOp91nJNHoI7ZTV5P2D2AELzRJdhMc0yfBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769587579; c=relaxed/simple;
	bh=Z81F5faV8Go/v42IbDRj5OpLIq2tSbyJukEKkImbA/M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ML7CIUc/ys31vDz99laAo2vSxKL9CWR1IMtoPFm21Z+dlmMClCPPFGe4XeDN//zL+PN+RqNyJCriBwQclT3GLv1nEv5YfxUslZ4F0/Zs2by7N7brlT7/kQTCbAl0/UKXrpkd0+DuTQm16EJN0qg5sty9qf1ZLXdf7M5FbaG3N7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f1FFY0bg0zYQtxM;
	Wed, 28 Jan 2026 16:05:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 08AF64056F;
	Wed, 28 Jan 2026 16:06:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvd1w3lpPgyWFQ--.43207S5;
	Wed, 28 Jan 2026 16:06:13 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: xni@redhat.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 01/14] md/raid1,raid10: clean up of RESYNC_SECTORS
Date: Wed, 28 Jan 2026 15:56:55 +0800
Message-Id: <20260128075708.2259525-2-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBnFvd1w3lpPgyWFQ--.43207S5
X-Coremail-Antispam: 1UD129KBjvJXoWxJr4rtF4rJFWUZryDKrWrGrg_yoW5JFy8pa
	1DGrySvw45KF47Jas7JayUua1Yy3Zrt3yUCrn5Za95uFy3XrZrXrWjqayYgF1DXFn5tFy2
	q3WDCr4UZFy3taUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmC14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2Iq
	xVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r
	106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AK
	xVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7
	xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_
	Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUfCzNUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Move redundant RESYNC_SECTORS definition from raid1 and raid10
implementations to raid1-10.c.

Simplify max_sync assignment in raid10_sync_request().

No functional changes.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid1-10.c | 1 +
 drivers/md/raid1.c    | 1 -
 drivers/md/raid10.c   | 4 +---
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 521625756128..260d7fd7ccbe 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -2,6 +2,7 @@
 /* Maximum size of each resync request */
 #define RESYNC_BLOCK_SIZE (64*1024)
 #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
+#define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
 
 /*
  * Number of guaranteed raid bios in case of extreme VM load:
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 00120c86c443..407925951299 100644
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
index 1adad768e277..1e57d9ce98e7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -113,7 +113,6 @@ static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 	return kzalloc(size, gfp_flags);
 }
 
-#define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
 /* amount of memory to reserve for resync requests */
 #define RESYNC_WINDOW (1024*1024)
 /* maximum number of concurrent requests, memory permitting */
@@ -3171,7 +3170,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	struct bio *biolist = NULL, *bio;
 	sector_t nr_sectors;
 	int i;
-	int max_sync;
+	int max_sync = RESYNC_SECTORS;
 	sector_t sync_blocks;
 	sector_t chunk_mask = conf->geo.chunk_mask;
 	int page_idx = 0;
@@ -3284,7 +3283,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 	 * end_sync_write if we will want to write.
 	 */
 
-	max_sync = RESYNC_PAGES << (PAGE_SHIFT-9);
 	if (!test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 		/* recovery... the complicated one */
 		int j;
-- 
2.39.2

