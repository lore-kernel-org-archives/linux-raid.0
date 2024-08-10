Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797A513C8EE;
	Sat, 10 Aug 2024 02:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255982; cv=none; b=eBoJP9r/KJ9UN0eqBah1ur3iHb69iTd7Y4Cd1ayu0VSf8mJ6mo16l5hM++5cCCOU4m2r0wCYhxLBqaZet7wE7xhRT2311dBfP8tiz7fba+sTxB3zsAgJZg0M/hFF+4Jf5NbveRH2+mCFXXv7uibLJbtdGgvZeTHbCydaoG3BQbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255982; c=relaxed/simple;
	bh=4sdSxi6ze98VBI5UDN6ZqHskrfxynjBOCOUgdM+3QBE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ok7coPwkAjvT8Oj/coB7wVwJfwCWlVHQdbI9p5Wb6ahMpDwwHNuyAhqHkLFY2vlhut7/9Dd5E1CoAyG/6JYuqMRIm7TiZtqdcteOdmTXvdAOYZaBjZ8cI0a4mATF9Sr4fB3VeU+KYjYRJk5iPJespumYm1T0ursnaTJx2IZEnVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgknq120Bz4f3jM1;
	Sat, 10 Aug 2024 10:12:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 465311A0359;
	Sat, 10 Aug 2024 10:12:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S15;
	Sat, 10 Aug 2024 10:12:56 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 11/26] md/md-bitmap: merge md_bitmap_dirty_bits() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:39 +0800
Message-Id: <20240810020854.797814-12-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240810020854.797814-1-yukuai1@huaweicloud.com>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S15
X-Coremail-Antispam: 1UD129KBjvJXoWxZF4fAFyUGr48WryxGF1DGFg_yoW5XFyDpF
	WfK345CrW5Ja12qw17ZryDua4Yyw1ktrZrKFWxJ345uFyUXFnxWF4rGa4Utw1kGrWfJFZx
	Z345tryUWr40qaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYcTQUUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  4 +++-
 drivers/md/md-bitmap.h | 10 +++++++++-
 drivers/md/md.c        |  2 +-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index aab7bb5418f7..b85ae1bf2b7d 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1755,7 +1755,8 @@ static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, in
 }
 
 /* dirty the memory and file bits for bitmap chunks "s" to "e" */
-void md_bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e)
+static void bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s,
+			      unsigned long e)
 {
 	unsigned long chunk;
 
@@ -2713,6 +2714,7 @@ static struct bitmap_operations bitmap_ops = {
 	.flush			= bitmap_flush,
 	.status			= bitmap_status,
 	.write_all		= bitmap_write_all,
+	.dirty_bits		= bitmap_dirty_bits,
 
 	.update_sb		= bitmap_update_sb,
 };
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 9df0c1d5f7ee..b708a25bd6f4 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -241,6 +241,7 @@ struct bitmap_operations {
 	void (*flush)(struct mddev *mddev);
 	void (*status)(struct seq_file *seq, struct bitmap *bitmap);
 	void (*write_all)(struct bitmap *bitmap);
+	void (*dirty_bits)(struct bitmap *bitmap, unsigned long s, unsigned long e);
 
 	void (*update_sb)(struct bitmap *bitmap);
 };
@@ -305,7 +306,14 @@ static inline void md_bitmap_write_all(struct mddev *mddev)
 	mddev->bitmap_ops->write_all(mddev->bitmap);
 }
 
-void md_bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e);
+static inline void md_bitmap_dirty_bits(struct mddev *mddev, unsigned long s,
+					unsigned long e)
+{
+	if (!mddev->bitmap || !mddev->bitmap_ops->dirty_bits)
+		return;
+
+	mddev->bitmap_ops->dirty_bits(mddev->bitmap, s, e);
+}
 
 /* these are exported */
 int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2260540dd458..841539a0be1b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4688,7 +4688,7 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 			if (buf == end) break;
 		}
 		if (*end && !isspace(*end)) break;
-		md_bitmap_dirty_bits(mddev->bitmap, chunk, end_chunk);
+		md_bitmap_dirty_bits(mddev, chunk, end_chunk);
 		buf = skip_spaces(end);
 	}
 	md_bitmap_unplug(mddev->bitmap); /* flush the bits to disk */
-- 
2.39.2

