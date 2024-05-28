Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E984B16D9A0;
	Tue, 28 May 2024 12:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716899948; cv=none; b=rY3nJ1KIGVREtMvX50jW3wFuWuCiT9N1Xh3OCmbRt6JX5lNkUAEm3W6+0csUVQnVVw/1T21hmLM3WZi/K2ykm4eb2MkFfaD35ydM3d1pJpdubHW6bweWxCDhHPluJwdskEoQIgb53ZyuaWrJTW5diz0p2xm5i8I7cx6KukOwXcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716899948; c=relaxed/simple;
	bh=SwlaZwQTe+WOm3AHJ1DNVfrfD6aHDXuHVxx1381y2W8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RiDx/O/FWtuyw27a58fEOoqe3Qs9aM14NpGnS643opChnUTgmp5W0bZIIIxozbtIuvECg38y3iw7sDrJHblm3a6SDDfzyk8mnzF5oXPietJddRNXIdHk/W+z2C3U8FrHkKQHVN/HVUSc3xLCXSr1mEo+23KuTazGwjK74kSglkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VpXBG46h7z4f3jHg;
	Tue, 28 May 2024 20:38:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id CF25D1A0568;
	Tue, 28 May 2024 20:38:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgAn+RFd0FVmCNenNw--.15805S4;
	Tue, 28 May 2024 20:38:55 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yukuai3@huawei.com,
	yi.zhang@huawei.com,
	houtao1@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2] md: make md_flush_request() more readable
Date: Wed, 29 May 2024 04:31:49 +0800
Message-Id: <20240528203149.2383260-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAn+RFd0FVmCNenNw--.15805S4
X-Coremail-Antispam: 1UD129KBjvJXoW7WFyfZw13Aw4rKr15GrWruFg_yoW8Wr4Up3
	9akF93Zrs5Aws8Aw47JFykJ3Z8Wws3tFWDtrWavws3ZF15ZFn5Gw1SgryvqFykGryfurW3
	Jrs5A3yrCay8ZwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2jI8I6cxK62vIxIIY0VWUZVW8XwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY
	6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr
	0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0E
	wIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lw4CEc2x0rVAKj4xxMxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20E
	Y4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjTRuMKZUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Setting bio to NULL and checking 'if(!bio)' is redundant and looks strange,
just consolidate them into one condition. There are no functional changes.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Li Nan <linan122@huawei.com>
---
v2: Rewrite the code according to Christoph's suggestion.

 drivers/md/md.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aff9118ff697..9598b4898ea9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -654,24 +654,22 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
 		WARN_ON(percpu_ref_is_zero(&mddev->active_io));
 		percpu_ref_get(&mddev->active_io);
 		mddev->flush_bio = bio;
-		bio = NULL;
-	}
-	spin_unlock_irq(&mddev->lock);
-
-	if (!bio) {
+		spin_unlock_irq(&mddev->lock);
 		INIT_WORK(&mddev->flush_work, submit_flushes);
 		queue_work(md_wq, &mddev->flush_work);
-	} else {
-		/* flush was performed for some other bio while we waited. */
-		if (bio->bi_iter.bi_size == 0)
-			/* an empty barrier - all done */
-			bio_endio(bio);
-		else {
-			bio->bi_opf &= ~REQ_PREFLUSH;
-			return false;
-		}
+		return true;
 	}
-	return true;
+
+	/* flush was performed for some other bio while we waited. */
+	spin_unlock_irq(&mddev->lock);
+	if (bio->bi_iter.bi_size == 0) {
+		/* pure flush without data - all done */
+		bio_endio(bio);
+		return true;
+	}
+
+	bio->bi_opf &= ~REQ_PREFLUSH;
+	return false;
 }
 EXPORT_SYMBOL(md_flush_request);
 
-- 
2.39.2

