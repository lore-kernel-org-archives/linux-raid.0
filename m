Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EF314D6FF;
	Sat, 10 Aug 2024 02:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255989; cv=none; b=p7kelPw+kvfvjeOlqF3q/fmmYjrk5nuIzSeayrZCY9ALghSYHrgJjYb68yAmYCNjQlZoIqE4TEQwI7IxJXZmcKBqUAyonv+C3sIju0NJOusXQ6UnKS2GDywA9ysYqZPLhNgSxWLLiErmrFxpSpn9wsMwIUvi38wSeKXBuXD6fX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255989; c=relaxed/simple;
	bh=vfc/XbQZGRMG87KPcwul/B3aFqvLo45/3cCQfUcgCF0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oBZgsOtx3Li+PwLbZO/l33UrgmowmMYP4MiG9e4SN+f0CZJpRv70YHY3/kRuocFkY3jSx2auGih351c77ym24YhgOgig4pgscxY1t9LfXNROir60e+fhA1cSU1CWXst0qq4sGcrUstBfPExEHoqJEMB/V5UNStz25YxcJwsWl8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wgknq1GQxz4f3jrp;
	Sat, 10 Aug 2024 10:12:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A8DFF1A159B;
	Sat, 10 Aug 2024 10:13:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S28;
	Sat, 10 Aug 2024 10:13:00 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 24/26] md/md-bitmap: merge md_bitmap_daemon_work() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:52 +0800
Message-Id: <20240810020854.797814-25-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S28
X-Coremail-Antispam: 1UD129KBjvJXoWxur4xGF48JFyUuw1UAr1xuFg_yoW5tr47pa
	y5t3Z8Cr45JFW3W3W7ArWDZF1Fqr1ktr9rtryfG34rCFy5JrnxWFWrGFyUt3Z5Jr1xAFs8
	Za15Jry8Gr1UWFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 19 +++++++------------
 drivers/md/md-bitmap.h | 10 +++++++++-
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 87e192d172fb..4f3ea6e51572 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1292,9 +1292,9 @@ static void mddev_set_timeout(struct mddev *mddev, unsigned long timeout,
  * bitmap daemon -- periodically wakes up to clean bits and flush pages
  *			out to disk
  */
-void md_bitmap_daemon_work(struct mddev *mddev)
+static void bitmap_daemon_work(struct bitmap *bitmap)
 {
-	struct bitmap *bitmap;
+	struct mddev *mddev = bitmap->mddev;
 	unsigned long j;
 	unsigned long nextpage;
 	sector_t blocks;
@@ -1304,13 +1304,8 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 	 * bitmap_destroy.
 	 */
 	mutex_lock(&mddev->bitmap_info.mutex);
-	bitmap = mddev->bitmap;
-	if (bitmap == NULL) {
-		mutex_unlock(&mddev->bitmap_info.mutex);
-		return;
-	}
-	if (time_before(jiffies, bitmap->daemon_lastrun
-			+ mddev->bitmap_info.daemon_sleep))
+	if (time_before(jiffies, bitmap->daemon_lastrun +
+				 mddev->bitmap_info.daemon_sleep))
 		goto done;
 
 	bitmap->daemon_lastrun = jiffies;
@@ -1780,11 +1775,11 @@ static void bitmap_flush(struct mddev *mddev)
 	 */
 	sleep = mddev->bitmap_info.daemon_sleep * 2;
 	bitmap->daemon_lastrun -= sleep;
-	md_bitmap_daemon_work(mddev);
+	bitmap_daemon_work(bitmap);
 	bitmap->daemon_lastrun -= sleep;
-	md_bitmap_daemon_work(mddev);
+	bitmap_daemon_work(bitmap);
 	bitmap->daemon_lastrun -= sleep;
-	md_bitmap_daemon_work(mddev);
+	bitmap_daemon_work(bitmap);
 	if (mddev->bitmap_info.external)
 		md_super_wait(mddev);
 	bitmap_update_sb(bitmap);
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 090d4f11f3cd..f67e030139cd 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -254,6 +254,7 @@ struct bitmap_operations {
 	void (*close_sync)(struct bitmap *bitmap);
 	void (*cond_end_sync)(struct bitmap *bitmap, sector_t sector, bool force);
 	void (*wait_behind_writes)(struct bitmap *bitmap);
+	void (*daemon_work)(struct bitmap *bitmap);
 
 	void (*update_sb)(struct bitmap *bitmap);
 	int (*resize)(struct bitmap *bitmap, sector_t blocks, int chunksize,
@@ -404,6 +405,14 @@ static inline void md_bitmap_wait_behind_writes(struct mddev *mddev)
 	mddev->bitmap_ops->wait_behind_writes(mddev->bitmap);
 }
 
+static inline void md_bitmap_daemon_work(struct mddev *mddev)
+{
+	if (!mddev->bitmap || !mddev->bitmap_ops->daemon_work)
+		return;
+
+	mddev->bitmap_ops->daemon_work(mddev->bitmap);
+}
+
 static inline int md_bitmap_resize(struct mddev *mddev, sector_t blocks,
 				   int chunksize, int init)
 {
@@ -453,7 +462,6 @@ static inline void md_bitmap_free(struct mddev *mddev, struct bitmap *bitmap)
 
 void md_bitmap_unplug(struct bitmap *bitmap);
 void md_bitmap_unplug_async(struct bitmap *bitmap);
-void md_bitmap_daemon_work(struct mddev *mddev);
 
 static inline bool md_bitmap_enabled(struct bitmap *bitmap)
 {
-- 
2.39.2

