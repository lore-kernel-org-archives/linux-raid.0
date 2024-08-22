Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB7713B294;
	Thu, 22 Aug 2024 02:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295134; cv=none; b=OzicjVtRfzT/Z75Y9WzEgMMfuo3b8DpBGDsX7qpe+VGNQKmY+ae8vfz3qpkUOEslK6P4W05VTF6As7TVWSZikFBczPEn36mOTbDBppuuHwhVAdVgPTUs18YPu0xNM1kcg7KLMPF8xTsTLBw76rTkyr5V9EAuv3IE9G2jDlXuE4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295134; c=relaxed/simple;
	bh=bmGpiD0eW+b0zGBlDxQR8+qIGJOQU2QuKFAoSQVzfEE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TSzfAenFMSl5Om8kKIJCYIcwqJiOwqEKJu4HmDAp9CtvT3mBSaLuLodwdSGsEK7yWpzQcz/b3EQBVVuWH+OZC/V0WtB2NYhp/RGqJ+OfhfRG8XAsaILEKd9+W7nfJAAQDOxqvCHds6RuuEVrEDshjuW7+eIVhxWgWgkrrnhA+Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wq75Q32Hbz4f3nJj;
	Thu, 22 Aug 2024 10:51:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8C1D21A12DB;
	Thu, 22 Aug 2024 10:52:09 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S25;
	Thu, 22 Aug 2024 10:52:09 +0800 (CST)
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
Subject: [PATCH md-6.12 21/41] md/md-bitmap: merge md_bitmap_dirty_bits() into bitmap_operations
Date: Thu, 22 Aug 2024 10:46:58 +0800
Message-Id: <20240822024718.2158259-22-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S25
X-Coremail-Antispam: 1UD129KBjvJXoWxXFW8trW8Gw1ktF17Jr47Jwb_yoW5tw4UpF
	47Ja45Kr45Ja4aqw17ZryDAFWFy3WktrZrtrWfG345uF9rXFnxGFWrWayUtw1kGrW3JFsx
	Zw15KryUWF4UXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Also change the parameter from bitmap to mddev, to avoid access
bitmap outside md-bitmap.c as much as possible.

And while we're here, also fix coding style for bitmap_store().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  9 ++++++++-
 drivers/md/md-bitmap.h |  6 ++----
 drivers/md/md.c        | 14 ++++++++++----
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index f5ef058dcdce..540b06dcc488 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1753,12 +1753,18 @@ static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, in
 }
 
 /* dirty the memory and file bits for bitmap chunks "s" to "e" */
-void md_bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e)
+static void bitmap_dirty_bits(struct mddev *mddev, unsigned long s,
+			      unsigned long e)
 {
 	unsigned long chunk;
+	struct bitmap *bitmap = mddev->bitmap;
+
+	if (!bitmap)
+		return;
 
 	for (chunk = s; chunk <= e; chunk++) {
 		sector_t sec = (sector_t)chunk << bitmap->counts.chunkshift;
+
 		md_bitmap_set_memory_bits(bitmap, sec, 1);
 		md_bitmap_file_set_bit(bitmap, sec);
 		if (sec < bitmap->mddev->recovery_cp)
@@ -2720,6 +2726,7 @@ static struct bitmap_operations bitmap_ops = {
 	.destroy		= bitmap_destroy,
 	.flush			= bitmap_flush,
 	.write_all		= bitmap_write_all,
+	.dirty_bits		= bitmap_dirty_bits,
 
 	.update_sb		= bitmap_update_sb,
 	.get_stats		= bitmap_get_stats,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 89cd60a7bb07..875ecbb5b1e4 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -252,6 +252,8 @@ struct bitmap_operations {
 	void (*destroy)(struct mddev *mddev);
 	void (*flush)(struct mddev *mddev);
 	void (*write_all)(struct mddev *mddev);
+	void (*dirty_bits)(struct mddev *mddev, unsigned long s,
+			   unsigned long e);
 
 	void (*update_sb)(struct bitmap *bitmap);
 	int (*get_stats)(struct bitmap *bitmap, struct md_bitmap_stats *stats);
@@ -260,10 +262,6 @@ struct bitmap_operations {
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
-/* these are used only by md/bitmap */
-
-void md_bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e);
-
 /* these are exported */
 int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
 			 unsigned long sectors, int behind);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 17350adb675f..6cf0131b9b81 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4699,14 +4699,20 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
 	/* buf should be <chunk> <chunk> ... or <chunk>-<chunk> ... (range) */
 	while (*buf) {
 		chunk = end_chunk = simple_strtoul(buf, &end, 0);
-		if (buf == end) break;
+		if (buf == end)
+			break;
+
 		if (*end == '-') { /* range */
 			buf = end + 1;
 			end_chunk = simple_strtoul(buf, &end, 0);
-			if (buf == end) break;
+			if (buf == end)
+				break;
 		}
-		if (*end && !isspace(*end)) break;
-		md_bitmap_dirty_bits(mddev->bitmap, chunk, end_chunk);
+
+		if (*end && !isspace(*end))
+			break;
+
+		mddev->bitmap_ops->dirty_bits(mddev, chunk, end_chunk);
 		buf = skip_spaces(end);
 	}
 	md_bitmap_unplug(mddev->bitmap); /* flush the bits to disk */
-- 
2.39.2

