Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B70314C5AF;
	Wed, 14 Aug 2024 07:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619739; cv=none; b=uqX0VRLcwBiydJeubj+SMWkO2hz+TDWTteGIXh7SamWIXXswmZTs2ksEr2dd/815wDgBRRwLwO9nN1VRXrFYAuRRvOWofJIv4o+tIXnkoopUXBGjthTZkiQIEVCQJIyHD7md/Daq5rqlmhs2ydsMIzyGq1IjQQRDvivC2WkxfgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619739; c=relaxed/simple;
	bh=6qrreoLGbiDMfO3ChY9KdA7yA/TKyIMi7M8BU4ndWns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UnAHW6GgEPJyLee4lUdBjLuVi/suysfS4UQV3birYQDdHWhUowFL6vRFNjQSNysNt7ShDVcGVyViDEFYWwjawS3ambykWJ8q8gpwh79uM7mWtvXBi3qG0A10rPWeDdrqaXTnveb1/Y6SPJztF+rsdV0+78mZUxbApviZCsDnLNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKK91j5Xz4f3jjk;
	Wed, 14 Aug 2024 15:15:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8DABA1A0359;
	Wed, 14 Aug 2024 15:15:34 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S25;
	Wed, 14 Aug 2024 15:15:34 +0800 (CST)
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
Subject: [PATCH RFC -next v2 21/41] md/md-bitmap: merge md_bitmap_dirty_bits() into bitmap_operations
Date: Wed, 14 Aug 2024 15:10:53 +0800
Message-Id: <20240814071113.346781-22-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S25
X-Coremail-Antispam: 1UD129KBjvJXoWxXFW8trykCr47tr13uFyDZFb_yoW5tw4UpF
	4xta45KrW5JFyaqw17AryDAFWFy3WktrZrtFWfG345uFy7ZFnxGFWrWayUtw1kGrWfJFsx
	Zw15KryUWF4UXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
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
index 3b52fa59a36d..01f2370b991c 100644
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
@@ -2717,6 +2723,7 @@ static struct bitmap_operations bitmap_ops = {
 	.destroy		= bitmap_destroy,
 	.flush			= bitmap_flush,
 	.write_all		= bitmap_write_all,
+	.dirty_bits		= bitmap_dirty_bits,
 
 	.update_sb		= bitmap_update_sb,
 	.get_stats		= bitmap_get_stats,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 70ca226036e1..fded46433bcb 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -251,6 +251,8 @@ struct bitmap_operations {
 	void (*destroy)(struct mddev *mddev);
 	void (*flush)(struct mddev *mddev);
 	void (*write_all)(struct mddev *mddev);
+	void (*dirty_bits)(struct mddev *mddev, unsigned long s,
+			   unsigned long e);
 
 	void (*update_sb)(struct bitmap *bitmap);
 	int (*get_stats)(struct bitmap *bitmap, struct md_bitmap_stats *stats);
@@ -259,10 +261,6 @@ struct bitmap_operations {
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
index bddc0ceb169a..1e1d3db56bb9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4685,14 +4685,20 @@ bitmap_store(struct mddev *mddev, const char *buf, size_t len)
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

