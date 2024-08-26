Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC3F188CB9;
	Mon, 26 Aug 2024 07:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658610; cv=none; b=K8jtIYTFkRfOpxNPlvKaRoAG3XfYUno4YBFz+QrM8foF5eW5nw4UbOZim5VvxIEfG/M3Y7pAOAiSi+Jl16kYDt155ZCZjz1Ql7/A5kkn+4mmoBzpeCVB3MkWnp5SaOO17hwuWHZ2kJd6dJ2M4rcerD3no22fCDg+eUwHos07kVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658610; c=relaxed/simple;
	bh=TDe9rBKfowRtz4UCrvE7RNvmxNt2Gp5SPmRIl403GgQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qj1QwLZ0w0rnvhFIvJDU5yLUlxLYhPidmurgC7lg+wWCwfoiPJSjUODjdpop7wOvjwrQIB5o6KJBvRqPGqYPNwWH2RP5RyNcPsg80r4tV9+KHn5C1ow8p83deYkYMK2U7E9OhRP5sQ2Q7xkHeEjqtwbjy6TeYweHBBYvStp6h0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsjWL16kZz4f3l21;
	Mon, 26 Aug 2024 15:49:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7D6911A058E;
	Mon, 26 Aug 2024 15:50:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S45;
	Mon, 26 Aug 2024 15:50:05 +0800 (CST)
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
Subject: [PATCH md-6.12 v2 41/42] md/md-bitmap: merge md_bitmap_enabled() into bitmap_operations
Date: Mon, 26 Aug 2024 15:44:51 +0800
Message-Id: <20240826074452.1490072-42-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S45
X-Coremail-Antispam: 1UD129KBjvJXoWxur4xur1xGw1DGr13Zry3CFg_yoW5WFW8pa
	9rJa45Cr15JFy3W3W7CrWkCFy5tw1ktrZrKryxG34ruFy3ZFsxGF4rGFWUt3Z3Ga43CFsx
	Zr45Kr48Cr1UWr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r
	43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26F1j6w1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
	Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUU
	UUU==
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
index b5dbfa9728dc..098bffac2167 100644
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
@@ -2753,6 +2769,7 @@ const struct attribute_group md_bitmap_group = {
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

