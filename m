Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260511531FD;
	Thu, 22 Aug 2024 02:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295143; cv=none; b=Juj37CyJZ7Y0vRXez7lRHJvj6Rvr3yh4MrQ0oNvI5aNZo7a+SAWU7XsQ7LlHvXXkHf6pscmXix3NkC+x0tkYC4/NBMZwb9gCNI7vjMlazwtifvsfzG5hycBhkJQeEQGvlBnTq1tcdtIrsDY7MYB5weD70z3k5H85btZP+pqj+b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295143; c=relaxed/simple;
	bh=GtKbRDpNJ15MwJe/YmZyt4CKpT4JjnDUrYf4VY9wXd4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ab+ns8gEt+2vZsfNcWp1p8OQF8/67sTCM5U7K9PdGq0mrmgD2S0UZ+dBWw8JLtxBeF4MAGwFqFKyitXsYaZZsKTMOfnrX9yiHLUHehmtWKIjQ4agj7rz/lMBrewSCfEsiR17Vo7ccpu3ld3Xx4/34Uiq3kP+dxsUhr0SUbyoYpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wq75Z6tNwz4f3nJq;
	Thu, 22 Aug 2024 10:52:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1A2301A0568;
	Thu, 22 Aug 2024 10:52:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S44;
	Thu, 22 Aug 2024 10:52:17 +0800 (CST)
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
Subject: [PATCH md-6.12 40/41] md/md-bitmap: merge md_bitmap_enabled() into bitmap_operations
Date: Thu, 22 Aug 2024 10:47:17 +0800
Message-Id: <20240822024718.2158259-41-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S44
X-Coremail-Antispam: 1UD129KBjvJXoWxur47tr1UAF13Xw4ruw4rXwb_yoW5WFW8pa
	9rJa45Cr15JFy3W3W7CrWkCFyYqw1ktrZrKryxC34ruFy3ZFZxGF4rGFWUt3Z3Ca43CFnx
	Zr45Kr48Cr1UWr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26F1j6w1UMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VU1zpBDUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 19 ++++++++++++++++++-
 drivers/md/md-bitmap.h |  8 +-------
 drivers/md/raid1-10.c  |  2 +-
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index c96782c69cc9..48a81c144daf 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -40,6 +40,22 @@ static inline char *bmname(struct bitmap *bitmap)
 	return bitmap->mddev ? mdname(bitmap->mddev) : "mdX";
 }
 
+static bool __bitmap_enabled(struct bitmap *bitmap)
+{
+	return bitmap->storage.filemap &&
+	       !test_bit(BITMAP_STALE, &bitmap->flags);
+}
+
+static bool bitmap_enabled(struct mddev *mddev)
+{
+	struct bitmap *bitmap = mddev->bitmap;
+
+	if (!bitmap)
+		return false;
+
+	return __bitmap_enabled(bitmap);
+}
+
 /*
  * check a page and, if necessary, allocate it (or hijack it if the alloc fails)
  *
@@ -1035,7 +1051,7 @@ static void __bitmap_unplug(struct bitmap *bitmap)
 	int dirty, need_write;
 	int writing = 0;
 
-	if (!md_bitmap_enabled(bitmap))
+	if (!__bitmap_enabled(bitmap))
 		return;
 
 	/* look at each page to see if there are any set bits that need to be
@@ -2745,6 +2761,7 @@ const struct attribute_group md_bitmap_group = {
 };
 
 static struct bitmap_operations bitmap_ops = {
+	.enabled		= bitmap_enabled,
 	.create			= bitmap_create,
 	.resize			= bitmap_resize,
 	.load			= bitmap_load,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index bc9cb4ca676e..c720729687e2 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -247,6 +247,7 @@ struct md_bitmap_stats {
 };
 
 struct bitmap_operations {
+	bool (*enabled)(struct mddev *mddev);
 	int (*create)(struct mddev *mddev, int slot);
 	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize,
 		      bool init);
@@ -287,12 +288,5 @@ struct bitmap_operations {
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
-static inline bool md_bitmap_enabled(struct bitmap *bitmap)
-{
-	return bitmap && bitmap->storage.filemap &&
-	       !test_bit(BITMAP_STALE, &bitmap->flags);
-}
-
 #endif
-
 #endif
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index e8207513eb1b..4378d3250bd7 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -140,7 +140,7 @@ static inline bool raid1_add_bio_to_plug(struct mddev *mddev, struct bio *bio,
 	 * If bitmap is not enabled, it's safe to submit the io directly, and
 	 * this can get optimal performance.
 	 */
-	if (!md_bitmap_enabled(mddev->bitmap)) {
+	if (!mddev->bitmap_ops->enabled(mddev)) {
 		raid1_submit_write(bio);
 		return true;
 	}
-- 
2.39.2

