Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946A213A257;
	Mon, 26 Aug 2024 07:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658594; cv=none; b=X9T1v+9pLzyFaOJOMJxLKmy4XjkuOkF8h2V+ssgjBkilgvKEEYO47LqcXTLZBrBR8O+cKHCbW0y5E2tfq/Y//jb8GhyTZotVKfsXuY14y2n9givP97CVik6UV5j9rsMvYqHnedSdeSMsj5T2+J6qousk4DxhtGS70HdCFw6TipI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658594; c=relaxed/simple;
	bh=7U+4rPCuQ8v4J3iHLq0gHk+8/gNnVcV511s4CcwVVnI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CS/37fFoXUnZkF+equV1JAplnhAJoJ/ggQ7ua1MC7zQ5A3iHsMS6D0igsugINgfuYKnSe2b59MOA45mWnbbLGljnlIASM63fxdSLsbrqSW0Z8ef5KRDsURIPHN6Sv/hXvO7MG9vQH9h/wAnAJ9ZjZ19oW8HU6bNj3SITtQAjHPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WsjW26c1Vz4f3jMP;
	Mon, 26 Aug 2024 15:49:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 60CB91A058E;
	Mon, 26 Aug 2024 15:49:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S6;
	Mon, 26 Aug 2024 15:49:49 +0800 (CST)
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
Subject: [PATCH md-6.12 v2 02/42] md/md-bitmap: replace md_bitmap_status() with a new helper md_bitmap_get_stats()
Date: Mon, 26 Aug 2024 15:44:12 +0800
Message-Id: <20240826074452.1490072-3-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S6
X-Coremail-Antispam: 1UD129KBjvJXoWxur1UJF1fXw1rtw48tr1kXwb_yoWrXF4xpF
	W3G343CrW5JFW3XrnrXrykuFy5Xwn5trZFqF93C34ruFy7XF9IgF48Wa4UJw1UGry7JFZx
	Z3Z0gFy5CF18Xr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBG14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtVW8Zw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUczV8UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

There are no functional changes, and the new helper will be used in
multiple places in following patches to avoid dereferencing bitmap
directly.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 25 ++++++-------------------
 drivers/md/md-bitmap.h |  8 +++++++-
 drivers/md/md.c        | 29 ++++++++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 08743dcc70f1..66ebe12d80ae 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2094,32 +2094,19 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 }
 EXPORT_SYMBOL_GPL(md_bitmap_copy_from_slot);
 
-
-void md_bitmap_status(struct seq_file *seq, struct bitmap *bitmap)
+int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 {
-	unsigned long chunk_kb;
 	struct bitmap_counts *counts;
 
 	if (!bitmap)
-		return;
+		return -ENOENT;
 
 	counts = &bitmap->counts;
+	stats->missing_pages = counts->missing_pages;
+	stats->pages = counts->pages;
+	stats->file = bitmap->storage.file;
 
-	chunk_kb = bitmap->mddev->bitmap_info.chunksize >> 10;
-	seq_printf(seq, "bitmap: %lu/%lu pages [%luKB], "
-		   "%lu%s chunk",
-		   counts->pages - counts->missing_pages,
-		   counts->pages,
-		   (counts->pages - counts->missing_pages)
-		   << (PAGE_SHIFT - 10),
-		   chunk_kb ? chunk_kb : bitmap->mddev->bitmap_info.chunksize,
-		   chunk_kb ? "KB" : "B");
-	if (bitmap->storage.file) {
-		seq_printf(seq, ", file: ");
-		seq_file_path(seq, bitmap->storage.file, " \t\n");
-	}
-
-	seq_printf(seq, "\n");
+	return 0;
 }
 
 int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index bb9eb418780a..b60418e3f573 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -234,6 +234,12 @@ struct bitmap {
 	int cluster_slot;		/* Slot offset for clustered env */
 };
 
+struct md_bitmap_stats {
+	unsigned long	missing_pages;
+	unsigned long	pages;
+	struct file	*file;
+};
+
 /* the bitmap API */
 
 /* these are used only by md/bitmap */
@@ -244,7 +250,7 @@ void md_bitmap_destroy(struct mddev *mddev);
 
 void md_bitmap_print_sb(struct bitmap *bitmap);
 void md_bitmap_update_sb(struct bitmap *bitmap);
-void md_bitmap_status(struct seq_file *seq, struct bitmap *bitmap);
+int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats);
 
 int  md_bitmap_setallbits(struct bitmap *bitmap);
 void md_bitmap_write_all(struct bitmap *bitmap);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d3a837506a36..b52d0cc773ae 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8370,6 +8370,33 @@ static void md_seq_stop(struct seq_file *seq, void *v)
 	spin_unlock(&all_mddevs_lock);
 }
 
+static void md_bitmap_status(struct seq_file *seq, struct mddev *mddev)
+{
+	struct md_bitmap_stats stats;
+	unsigned long used_pages;
+	unsigned long chunk_kb;
+	int err;
+
+	err = md_bitmap_get_stats(mddev->bitmap, &stats);
+	if (err)
+		return;
+
+	chunk_kb = mddev->bitmap_info.chunksize >> 10;
+	used_pages = stats.pages - stats.missing_pages;
+
+	seq_printf(seq, "bitmap: %lu/%lu pages [%luKB], %lu%s chunk",
+		   used_pages, stats.pages, used_pages << (PAGE_SHIFT - 10),
+		   chunk_kb ? chunk_kb : mddev->bitmap_info.chunksize,
+		   chunk_kb ? "KB" : "B");
+
+	if (stats.file) {
+		seq_puts(seq, ", file: ");
+		seq_file_path(seq, stats.file, " \t\n");
+	}
+
+	seq_putc(seq, '\n');
+}
+
 static int md_seq_show(struct seq_file *seq, void *v)
 {
 	struct mddev *mddev;
@@ -8453,7 +8480,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		} else
 			seq_printf(seq, "\n       ");
 
-		md_bitmap_status(seq, mddev->bitmap);
+		md_bitmap_status(seq, mddev);
 
 		seq_printf(seq, "\n");
 	}
-- 
2.39.2

