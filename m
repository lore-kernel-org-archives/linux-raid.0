Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032DD1802DD;
	Thu, 22 Aug 2024 02:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295139; cv=none; b=t1RWK0YMCLd6HOkwTbI7fFa3yJ7L6fAnBpmB0SRlNYBrKfGnfjFwXGFaw2+fSZhkPa5PcXU49anl+e4bb5ouCAC0Bh/PljHwPhgcXwA8Vk5bcoAweAJM8x8sIo7GzzLk9VS+MvWeU/sKRMbywgHRPLyYStAKt2f8GZNe5x82OzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295139; c=relaxed/simple;
	bh=oYATKtqqUJ2EsKguen+LOyxdoPy/bxrBrsZMnoz8wtU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M4ilB6ySEEbs7MarlQ0ljaWO2kKFLLctpBlw+Ul1xco3SsNZLp7jouwMdTwu0sQpAkDmoVInHZX+IpiJreR2KG6pK+QHhBMmbg0pyoLy1GMLKU9JR47DRjN7aYgBI7iRMU1hSNPkQbPC7goDHtuCvHBKjkrn6UDudiWaoZlkpZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wq75c2W1Gz4f3kpK;
	Thu, 22 Aug 2024 10:52:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0EDD31A153C;
	Thu, 22 Aug 2024 10:52:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S35;
	Thu, 22 Aug 2024 10:52:13 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@linux.intel.com,
	l@damenly.org,
	xni@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 31/41] md/md-bitmap: merge bitmap_unplug() into bitmap_operations
Date: Thu, 22 Aug 2024 10:47:08 +0800
Message-Id: <20240822024718.2158259-32-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
References: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S35
X-Coremail-Antispam: 1UD129KBjvJXoWxZr1xKFykXryxXFyUKrWDXFb_yoWrGr4kpF
	Wjqa43Cr45JFWYqw1UZFWDCa4Fq3Wvgr9rKryxAw1ruF9rXF9xWF4rWayUtw1DuFy3JFnx
	Zw1YyrykWFy8XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VU1zpBDUUUUU==
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
index 8c83891fefad..5838366f47aa 100644
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
 
@@ -2754,6 +2753,7 @@ static struct bitmap_operations bitmap_ops = {
 	.flush			= bitmap_flush,
 	.write_all		= bitmap_write_all,
 	.dirty_bits		= bitmap_dirty_bits,
+	.unplug			= bitmap_unplug,
 
 	.startwrite		= bitmap_startwrite,
 	.endwrite		= bitmap_endwrite,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index ba8ba7e49ef9..dbe9b27091f4 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -254,6 +254,7 @@ struct bitmap_operations {
 	void (*write_all)(struct mddev *mddev);
 	void (*dirty_bits)(struct mddev *mddev, unsigned long s,
 			   unsigned long e);
+	void (*unplug)(struct mddev *mddev, bool sync);
 
 	int (*startwrite)(struct mddev *mddev, sector_t offset,
 			  unsigned long sectors, bool behind);
@@ -277,7 +278,6 @@ struct bitmap_operations {
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-void md_bitmap_unplug(struct mddev *mddev, bool sync);
 void md_bitmap_daemon_work(struct mddev *mddev);
 
 int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8e3f753ee035..6f68f8da0848 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4715,7 +4715,7 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
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

