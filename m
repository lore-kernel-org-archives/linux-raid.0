Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7535A55898;
	Wed, 14 Aug 2024 07:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619732; cv=none; b=jFNsUQXgxKSgRPnE9hbfOgSBdO1D6G0/C6UnQ5r1O25jWgaTVnJ6Hoc/ImWIftK8P7g2Z5f5UQ3pQh0Y23lck2bc4hAt2SaimFcTXG+SbXCRRGD/gyzBkxc1fU5vAp+Ln8iKDVbgfXcQJycNwAaDMu/6JxasPoifQhJ+T1Y8QSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619732; c=relaxed/simple;
	bh=uYYfO/xaz/fn766NtdTCipiZ3PE2V8xH0WoCwGTbN8E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=szJ0gGoKcXOizCBNC2Qy8FXRsvQdb4cVOu/GyMYdfgDXumllHdzSJourBmr5scLuUgdWqi+mHc5x13Zvw5PkQuCfHdHka6f4Gz5BEyKgjXSSOG2h9V3e/uzQzd5DCO49HLRuiaoLMWkJu+7gIw0olWC8k4ceI325F4hIYjfB5kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKK21zCCz4f3jZQ;
	Wed, 14 Aug 2024 15:15:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 976E51A058E;
	Wed, 14 Aug 2024 15:15:27 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S8;
	Wed, 14 Aug 2024 15:15:27 +0800 (CST)
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
Subject: [PATCH RFC -next v2 04/41] md/md-bitmap: add 'events_cleared' into struct md_bitmap_stats
Date: Wed, 14 Aug 2024 15:10:36 +0800
Message-Id: <20240814071113.346781-5-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S8
X-Coremail-Antispam: 1UD129KBjvJXoWxXFWkJr4fZr4xCw4fZFyxXwb_yoW5GFyrpF
	WUJa4Ykr4rJFW7Xw13ZFyDuFy5t3Z7trZFkryfC3s8uFyUZF98XF4rWFyUXwn8GFy5AF43
	Zw15tr4UCryjqaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Also add a new helper to get events_cleared to avoid dereferencing
bitmap directly to prepare inventing a new bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  1 +
 drivers/md/md-bitmap.h | 12 ++++++++++++
 drivers/md/md.c        |  4 ++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 8866c7122f79..8a2411040d2f 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2105,6 +2105,7 @@ int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 	stats->pages = counts->pages;
 	stats->missing_pages = counts->missing_pages;
 	stats->file = bitmap->storage.file;
+	stats->events_cleared = bitmap->events_cleared;
 
 	return 0;
 }
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 8fb52aacd5a1..c8527ba38dfc 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -238,6 +238,7 @@ struct md_bitmap_stats {
 	unsigned long pages;
 	unsigned long missing_pages;
 	struct file *file;
+	u64 events_cleared;
 };
 
 /* the bitmap API */
@@ -282,6 +283,17 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 void md_bitmap_free(struct bitmap *bitmap);
 void md_bitmap_wait_behind_writes(struct mddev *mddev);
 
+static inline u64 md_bitmap_events_cleared(struct mddev *mddev)
+{
+	struct md_bitmap_stats stats;
+	int err = md_bitmap_get_stats(mddev->bitmap, &stats);
+
+	if (err)
+		return 0;
+
+	return stats.events_cleared;
+}
+
 static inline bool md_bitmap_enabled(struct bitmap *bitmap)
 {
 	return bitmap && bitmap->storage.filemap &&
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 27013059baa2..29ec6fe80ae8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1464,7 +1464,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, stru
 		/* if adding to array with a bitmap, then we can accept an
 		 * older device ... but not too old.
 		 */
-		if (ev1 < mddev->bitmap->events_cleared)
+		if (ev1 < md_bitmap_events_cleared(mddev))
 			return 0;
 		if (ev1 < mddev->events)
 			set_bit(Bitmap_sync, &rdev->flags);
@@ -1991,7 +1991,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
 		/* If adding to array with a bitmap, then we can accept an
 		 * older device, but not too old.
 		 */
-		if (ev1 < mddev->bitmap->events_cleared)
+		if (ev1 < md_bitmap_events_cleared(mddev))
 			return 0;
 		if (ev1 < mddev->events)
 			set_bit(Bitmap_sync, &rdev->flags);
-- 
2.39.2

