Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB54280038;
	Tue,  6 May 2025 12:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746536242; cv=none; b=eMe28nX4477QEpkdaea5BvMeAnC+Ejxx6HnONEWM3zKEbeIgyxzv0fdekZW5xvq/y9cHbPR7qwraQriRl1nU55zukiHCIUVTuQ0cJprLtg8L1ZM9zP8oXEmiKg+tSIPTM1c7RSBD/dHy+aI7rYHXZwjj0gWMCy1HsjxwW0ctAkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746536242; c=relaxed/simple;
	bh=JSvR7C4+yIzGcyP4RuB4kV0hCZ9UNCP5oQNtJtfpLpA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kxyzzC9E4MH/ETO/TrOrlQKjaKb7CV7id+UA0/nMO77BV8uTq//SIN7rikrMOqqkTH07d1Rs2bwRTZXK3YrZaDKu9iAM+V99iGernqrcpZgztgpsmPWGHw4yFLWygrWcX15/gxvXdfD70cj68o8yUDd5o+0P6nbpl8BLj9uJY+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZsJLy04Ntz4f3jt8;
	Tue,  6 May 2025 20:56:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 39FA71A0F01;
	Tue,  6 May 2025 20:57:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDXOl8pBxpoilNvLg--.37994S7;
	Tue, 06 May 2025 20:57:16 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	song@kernel.org,
	hch@lst.de,
	john.g.garry@oracle.com,
	hare@suse.de,
	xni@redhat.com,
	pmenzel@molgen.mpg.de
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v3 4/9] block: clean up blk_mq_in_flight_rw()
Date: Tue,  6 May 2025 20:48:57 +0800
Message-Id: <20250506124903.2540268-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506124903.2540268-1-yukuai1@huaweicloud.com>
References: <20250506124658.2537886-1-yukuai1@huaweicloud.com>
 <20250506124903.2540268-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOl8pBxpoilNvLg--.37994S7
X-Coremail-Antispam: 1UD129KBjvJXoWxuF15Jw1rWrWfXFyxury5twb_yoWrZw45pr
	45Ka98JrW5Wr1S9r1xtan7XFyfKw48KryIvwnxAr1ayr18Kr9xZFy8Gw1ktr1IvrykCFW3
	C3WYyFy7GF1UG37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2
	KfnxnUUI43ZEXa7VUUbAw7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Also add comment for part_inflight_show() for the difference between
bio-based and rq-based device.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 12 ++++++------
 block/blk-mq.h |  3 +--
 block/genhd.c  | 43 +++++++++++++++++++++++++------------------
 3 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 45989960a89d..4722a4ad4121 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -89,7 +89,7 @@ struct mq_inflight {
 	unsigned int inflight[2];
 };
 
-static bool blk_mq_check_inflight(struct request *rq, void *priv)
+static bool blk_mq_check_in_driver(struct request *rq, void *priv)
 {
 	struct mq_inflight *mi = priv;
 
@@ -101,14 +101,14 @@ static bool blk_mq_check_inflight(struct request *rq, void *priv)
 	return true;
 }
 
-void blk_mq_in_flight_rw(struct request_queue *q, struct block_device *part,
-		unsigned int inflight[2])
+void blk_mq_in_driver_rw(struct block_device *part, unsigned int inflight[2])
 {
 	struct mq_inflight mi = { .part = part };
 
-	blk_mq_queue_tag_busy_iter(q, blk_mq_check_inflight, &mi);
-	inflight[0] = mi.inflight[0];
-	inflight[1] = mi.inflight[1];
+	blk_mq_queue_tag_busy_iter(bdev_get_queue(part), blk_mq_check_in_driver,
+				   &mi);
+	inflight[READ] = mi.inflight[READ];
+	inflight[WRITE] = mi.inflight[WRITE];
 }
 
 #ifdef CONFIG_LOCKDEP
diff --git a/block/blk-mq.h b/block/blk-mq.h
index eeac0d47c878..affb2e14b56e 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -246,8 +246,7 @@ static inline bool blk_mq_hw_queue_mapped(struct blk_mq_hw_ctx *hctx)
 	return hctx->nr_ctx && hctx->tags;
 }
 
-void blk_mq_in_flight_rw(struct request_queue *q, struct block_device *part,
-		unsigned int inflight[2]);
+void blk_mq_in_driver_rw(struct block_device *part, unsigned int inflight[2]);
 
 static inline void blk_mq_put_dispatch_budget(struct request_queue *q,
 					      int budget_token)
diff --git a/block/genhd.c b/block/genhd.c
index d158c25237b6..2470099b492b 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -126,27 +126,32 @@ static void part_stat_read_all(struct block_device *part,
 }
 
 static void part_in_flight_rw(struct block_device *part,
-		unsigned int inflight[2])
+		unsigned int inflight[2], bool mq_driver)
 {
 	int cpu;
 
-	inflight[0] = 0;
-	inflight[1] = 0;
-	for_each_possible_cpu(cpu) {
-		inflight[0] += part_stat_local_read_cpu(part, in_flight[0], cpu);
-		inflight[1] += part_stat_local_read_cpu(part, in_flight[1], cpu);
+	if (mq_driver) {
+		blk_mq_in_driver_rw(part, inflight);
+	} else {
+		for_each_possible_cpu(cpu) {
+			inflight[READ] += part_stat_local_read_cpu(
+						part, in_flight[READ], cpu);
+			inflight[WRITE] += part_stat_local_read_cpu(
+						part, in_flight[WRITE], cpu);
+		}
 	}
-	if (WARN_ON_ONCE((int)inflight[0] < 0))
-		inflight[0] = 0;
-	if (WARN_ON_ONCE((int)inflight[1] < 0))
-		inflight[1] = 0;
+
+	if (WARN_ON_ONCE((int)inflight[READ] < 0))
+		inflight[READ] = 0;
+	if (WARN_ON_ONCE((int)inflight[WRITE] < 0))
+		inflight[WRITE] = 0;
 }
 
 unsigned int part_in_flight(struct block_device *part)
 {
-	unsigned int inflight[2];
+	unsigned int inflight[2] = {0};
 
-	part_in_flight_rw(part, inflight);
+	part_in_flight_rw(part, inflight, false);
 
 	return inflight[READ] + inflight[WRITE];
 }
@@ -1036,19 +1041,21 @@ ssize_t part_stat_show(struct device *dev,
 		(unsigned int)div_u64(stat.nsecs[STAT_FLUSH], NSEC_PER_MSEC));
 }
 
+/*
+ * Show the number of IOs issued to driver.
+ * For bio-based device, started from bdev_start_io_acct();
+ * For rq-based device, started from blk_mq_start_request();
+ */
 ssize_t part_inflight_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
 	struct block_device *bdev = dev_to_bdev(dev);
 	struct request_queue *q = bdev_get_queue(bdev);
-	unsigned int inflight[2];
+	unsigned int inflight[2] = {0};
 
-	if (queue_is_mq(q))
-		blk_mq_in_flight_rw(q, bdev, inflight);
-	else
-		part_in_flight_rw(bdev, inflight);
+	part_in_flight_rw(bdev, inflight, queue_is_mq(q));
 
-	return sysfs_emit(buf, "%8u %8u\n", inflight[0], inflight[1]);
+	return sysfs_emit(buf, "%8u %8u\n", inflight[READ], inflight[WRITE]);
 }
 
 static ssize_t disk_capability_show(struct device *dev,
-- 
2.39.2

