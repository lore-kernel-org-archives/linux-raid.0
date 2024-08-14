Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6034015887C;
	Wed, 14 Aug 2024 07:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619743; cv=none; b=lmLihpwpsiekG7MGQoytPuq1XJ9yZuHYbKMS82RBDlkwkoS4z3VU6YAvgUytAhqwTJbu6ilhR47Kl0iGBdcMPUv0mTd/TdeWg2QgxMVfpa8l+wEZozYgan/xtsgZOf6KIpB5J8y0iJwKzJRKahN9/V8nd73oZZgiNqC4o4r7sL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619743; c=relaxed/simple;
	bh=ctHDK/hcD6ZFGI0ijME8cgRspGL2SC/5blWn0tDIb6M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ip9WMQbjryDqnYs4iiHUf5G0U5OQK7t/cmeXlzZvM1mZT1Hrus3Agqh4nAACDhBo4qDp0cevDV6pwqTMMh1kahIuU1rGmr49Mx93BDszbZl9VRgbXKPFi11ILorqMygk8XIazDMLFoBvOdLly6Nmdwt4DtxUPVfjKsMgPe86Guo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKKF24JFz4f3jZ1;
	Wed, 14 Aug 2024 15:15:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9A4D51A0359;
	Wed, 14 Aug 2024 15:15:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S35;
	Wed, 14 Aug 2024 15:15:38 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	hch@infradead.org,
	song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next v2 31/41] md/md-bitmap: merge bitmap_unplug() into bitmap_operations
Date: Wed, 14 Aug 2024 15:11:03 +0800
Message-Id: <20240814071113.346781-32-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814071113.346781-1-yukuai1@huaweicloud.com>
References: <20240814071113.346781-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S35
X-Coremail-Antispam: 1UD129KBjvJXoWxZr1xKFykXryfGr15KryfWFg_yoWrGr4kpF
	Wjqa43Cr45XFW5X3WUAFWDC3WFq3WvgrZrKryxCw4ruF9rXF9xWF4rWayUtw1DCFy3JFsx
	Zw1YyrykWF18XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQFxUU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 4 ++--
 drivers/md/md-bitmap.h | 2 +-
 drivers/md/md.c        | 2 +-
 drivers/md/raid1-10.c  | 2 +-
 drivers/md/raid5.c     | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 13aafe7e3ba8..ec85d7f2eeee 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1087,7 +1087,7 @@ static void bitmap_unplug_async(struct bitmap *bitmap)
 	wait_for_completion(&done);
 }
 
-void md_bitmap_unplug(struct mddev *mddev, bool sync)
+static void bitmap_unplug(struct mddev *mddev, bool sync)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
@@ -1099,7 +1099,6 @@ void md_bitmap_unplug(struct mddev *mddev, bool sync)
 	else
 		bitmap_unplug_async(bitmap);
 }
-EXPORT_SYMBOL_GPL(md_bitmap_unplug);
 
 static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed);
 
@@ -2751,6 +2750,7 @@ static struct bitmap_operations bitmap_ops = {
 	.flush			= bitmap_flush,
 	.write_all		= bitmap_write_all,
 	.dirty_bits		= bitmap_dirty_bits,
+	.unplug			= bitmap_unplug,
 
 	.startwrite		= bitmap_startwrite,
 	.endwrite		= bitmap_endwrite,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index ae6ba558e48a..eaaaab51701e 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -253,6 +253,7 @@ struct bitmap_operations {
 	void (*write_all)(struct mddev *mddev);
 	void (*dirty_bits)(struct mddev *mddev, unsigned long s,
 			   unsigned long e);
+	void (*unplug)(struct mddev *mddev, bool sync);
 
 	int (*startwrite)(struct mddev *mddev, sector_t offset,
 			  unsigned long sectors, bool behind);
@@ -276,7 +277,6 @@ struct bitmap_operations {
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-void md_bitmap_unplug(struct mddev *mddev, bool sync);
 void md_bitmap_daemon_work(struct mddev *mddev);
 
 int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f15784b31b98..6d621c28cea0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4701,7 +4701,7 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->bitmap_ops->dirty_bits(mddev, chunk, end_chunk);
 		buf = skip_spaces(end);
 	}
-	md_bitmap_unplug(mddev, true); /* flush the bits to disk */
+	mddev->bitmap_ops->unplug(mddev, true); /* flush the bits to disk */
 out:
 	mddev_unlock(mddev);
 	return len;
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 45b30f08f3a5..e8207513eb1b 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -168,7 +168,7 @@ static inline bool raid1_add_bio_to_plug(struct mddev *mddev, struct bio *bio,
  */
 static inline void raid1_prepare_flush_writes(struct mddev *mddev)
 {
-	md_bitmap_unplug(mddev, current->bio_list == NULL);
+	mddev->bitmap_ops->unplug(mddev, current->bio_list == NULL);
 }
 
 /*
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e98061c01b44..91b610d11c6a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6768,7 +6768,7 @@ static void raid5d(struct md_thread *thread)
 			/* Now is a good time to flush some bitmap updates */
 			conf->seq_flush++;
 			spin_unlock_irq(&conf->device_lock);
-			md_bitmap_unplug(mddev, true);
+			mddev->bitmap_ops->unplug(mddev, true);
 			spin_lock_irq(&conf->device_lock);
 			conf->seq_write = conf->seq_flush;
 			activate_bit_delay(conf, conf->temp_inactive_list);
-- 
2.39.2

