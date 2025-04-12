Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B237F189F3F;
	Sat, 12 Apr 2025 07:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744443534; cv=none; b=Dq3s0ZOxdFqAnlY9wL1TfbXO5cTDIroXZLAWY7VtduarV3r9r2UHyoV8wfLzNBUK4K1H4cwPjvgRu69keXdReW3VUh1Eg1CQ2WEJD8ughFXkLKU8txnF/l/TSCb2ZMfWPxcGF3fyX6o82H6HUUjBR/sW+4oNDCiLSE7iNzC3gHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744443534; c=relaxed/simple;
	bh=9pBDPuJef6LzInqFdJRfx1sNwkWKEaOr7fq9l/fN9JM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tf5JYfemWTYx5VwxfryYuP1cg1ZR75LR+vSKfiaNfdqqHWjR7jiID3pRPSwZDzvOWy88JuMV6Jx5P1rPehFwjGtHYGYR83M3ym/3YvPgWfuUjL5uqt3aYmrZPWvzWZOBAk0lPDKvB2C2TSghp/8XTfp/3ZHwdjv7zpRRDmAOxv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZZQQZ0N27z4f3jtK;
	Sat, 12 Apr 2025 15:38:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3448D1A0AD9;
	Sat, 12 Apr 2025 15:38:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2CFGPpnI5n6JA--.63008S5;
	Sat, 12 Apr 2025 15:38:48 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	song@kernel.org,
	yukuai3@huawei.com,
	xni@redhat.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 1/4] block: export part_in_flight()
Date: Sat, 12 Apr 2025 15:31:59 +0800
Message-Id: <20250412073202.3085138-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250412073202.3085138-1-yukuai1@huaweicloud.com>
References: <20250412073202.3085138-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2CFGPpnI5n6JA--.63008S5
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar4xKw4kWw43ur48ur4Uurg_yoW8AFy7pF
	1DGas0yFWqgryruFy7tw4xZ3WrXa1jkw1fA343AryF9FZFqrsavF92kr4ayrWSvrZ7ZFWU
	ua43JFZ7Cr1jy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmj14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
	C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kfnx
	nUUI43ZEXa7VUbn2-7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

This helper will be used in mdraid in later patches, check if there
are normal IO inflight while generating background sync IO, to fix a
problem in mdraid that foreground IO can be starved by background sync
IO.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk.h               | 1 -
 block/genhd.c             | 1 +
 include/linux/part_stat.h | 1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk.h b/block/blk.h
index 006e3be433d2..f476f233f195 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -418,7 +418,6 @@ void blk_apply_bdi_limits(struct backing_dev_info *bdi,
 int blk_dev_init(void);
 
 void update_io_ticks(struct block_device *part, unsigned long now, bool end);
-unsigned int part_in_flight(struct block_device *part);
 
 static inline void req_set_nomerge(struct request_queue *q, struct request *req)
 {
diff --git a/block/genhd.c b/block/genhd.c
index c2bd86cd09de..5b408d9b5a9d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -139,6 +139,7 @@ unsigned int part_in_flight(struct block_device *part)
 
 	return inflight;
 }
+EXPORT_SYMBOL_GPL(part_in_flight);
 
 static void part_in_flight_rw(struct block_device *part,
 		unsigned int inflight[2])
diff --git a/include/linux/part_stat.h b/include/linux/part_stat.h
index c5e9cac0575e..79ed730a8d50 100644
--- a/include/linux/part_stat.h
+++ b/include/linux/part_stat.h
@@ -79,4 +79,5 @@ static inline void part_stat_set_all(struct block_device *part, int value)
 #define part_stat_local_read_cpu(part, field, cpu)			\
 	local_read(&(part_stat_get_cpu(part, field, cpu)))
 
+unsigned int part_in_flight(struct block_device *part);
 #endif /* _LINUX_PART_STAT_H */
-- 
2.39.2

