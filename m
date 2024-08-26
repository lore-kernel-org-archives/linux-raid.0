Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B8C14C5A1;
	Mon, 26 Aug 2024 07:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658602; cv=none; b=Bmsf9vC2l+4p5Iz6WrpK76IC3XgRmKIsMMAD5yv/4onOgYx2fTIq4pfIiR6qyizQ5Twqh6EzLTwggfrCVO/i7BFGMVfJyy5NIkFAblwLEq10m7c9yvYTfuMPwqUruPBsmaWiojHT2cdp6BYFc69DWt3c0+m5hlAOUbDHpqFF06I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658602; c=relaxed/simple;
	bh=CXYWnWI6gJnpMgibmCSMHM7rCf0mWzeoXawX/gHE0Xc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WRslQM96D804viCXNQln4oUYZjVWENDwTZolwlQp83Yvf9Z2QYmxVxq62U5dpK7zJxULG09jHKl/ZwMQfSa4GyR0jcGaG93aSb4tO8+NyTXoE66UIbGLtRsrIMKe9zhTgVzNHdPrMwV9w3scxo/U6S1C1i7C8NCmwjQ0ntQYXUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WsjWC1RMcz4f3jMX;
	Mon, 26 Aug 2024 15:49:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A48521A0568;
	Mon, 26 Aug 2024 15:49:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S26;
	Mon, 26 Aug 2024 15:49:57 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	xni@redhat.com,
	song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 v2 22/42] md/md-bitmap: merge md_bitmap_dirty_bits() into bitmap_operations
Date: Mon, 26 Aug 2024 15:44:32 +0800
Message-Id: <20240826074452.1490072-23-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
References: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S26
X-Coremail-Antispam: 1UD129KBjvJXoWxXFW8trW8Aw4UAw48ury7trb_yoW5tw4UpF
	43Ga45Kr45JFyaqw17ZryDAFWFy3WktrZrtrWfG345uFyUXFnxGFWrWayUtw1kGrW3JFsx
	Zw15KryUWF4UXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r
	43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
	Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUU
	UUU==
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
index 47d074bf292d..6448f78d50c2 100644
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

