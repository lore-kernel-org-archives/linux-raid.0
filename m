Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BF413BACC;
	Mon, 26 Aug 2024 07:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658596; cv=none; b=Hl2LXSk+4ItsZYSCfX759Y/q5Kcq6Hn9STNKmL2xKIdyO76JKWzJr6AJX3Lc1iYanjUEC+0wEQ+706TKRMrQs3H6neaoBr8CqrfxgXDGdfDOQKVce2JOlCTHeSuEe1ol2CpHwNlAp8PgyNyYubHU16zSIIoSC9WwFZGM11yg8vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658596; c=relaxed/simple;
	bh=72JGYvFu5yuFgCCfSoVYTBhfnQL9w7GVGVfbY/MEbT4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GJRB9LvuXxvmlIadAcNybSjVRSWah/6CSSKZKsIYXmAYeI9mEgDpawdYqffAhTGvRmE94xTw2O4XrdLez9bBuqsW6XaYZBuV2wN5oCgF4Qt9U9M/8iZlHw0fthc9N/qZgpUZePJzi+azuGyo8DvTrzAH8LQbJ7vir6C19z09BGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WsjW52vRcz4f3jMs;
	Mon, 26 Aug 2024 15:49:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D687D1A058E;
	Mon, 26 Aug 2024 15:49:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S12;
	Mon, 26 Aug 2024 15:49:51 +0800 (CST)
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
Subject: [PATCH md-6.12 v2 08/42] md/md-bitmap: add 'behind_writes' and 'behind_wait' into struct md_bitmap_stats
Date: Mon, 26 Aug 2024 15:44:18 +0800
Message-Id: <20240826074452.1490072-9-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S12
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr47Kr4xtF15Jry8XrWUJwb_yoW5JF47pF
	WDX345uw45JF45Xr1DZFyUZFyrJasIqFZrKFWfW3s8uFy2yF9IgF40gFW5Cw1DCF93AF45
	Xr45JryUuryYqFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUU
	UUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

There are no functional changes, avoid dereferencing bitmap directly to
prepare inventing a new bitmap.

Also fix following checkpatch warning by using wq_has_sleeper().

WARNING: waitqueue_active without comment

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  2 ++
 drivers/md/md-bitmap.h |  3 +++
 drivers/md/raid1.c     | 13 ++++++++-----
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index ba83b99d6185..918510f36e33 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2115,6 +2115,8 @@ int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 	stats->file_pages = storage->file_pages;
 	stats->file = storage->file;
 
+	stats->behind_writes = atomic_read(&bitmap->behind_writes);
+	stats->behind_wait = wq_has_sleeper(&bitmap->behind_wait);
 	stats->events_cleared = bitmap->events_cleared;
 	return 0;
 }
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 870125670087..909a661383c6 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -236,6 +236,9 @@ struct bitmap {
 
 struct md_bitmap_stats {
 	u64		events_cleared;
+	int		behind_writes;
+	bool		behind_wait;
+
 	unsigned long	missing_pages;
 	unsigned long	file_pages;
 	unsigned long	sync_size;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 81fc100e7830..f9861f9103c2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1603,16 +1603,19 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			continue;
 
 		if (first_clone) {
+			unsigned long max_write_behind =
+				mddev->bitmap_info.max_write_behind;
+			struct md_bitmap_stats stats;
+			int err;
+
 			/* do behind I/O ?
 			 * Not if there are too many, or cannot
 			 * allocate memory, or a reader on WriteMostly
 			 * is waiting for behind writes to flush */
-			if (bitmap && write_behind &&
-			    (atomic_read(&bitmap->behind_writes)
-			     < mddev->bitmap_info.max_write_behind) &&
-			    !waitqueue_active(&bitmap->behind_wait)) {
+			err = md_bitmap_get_stats(bitmap, &stats);
+			if (!err && write_behind && !stats.behind_wait &&
+			    stats.behind_writes < max_write_behind)
 				alloc_behind_master_bio(r1_bio, bio);
-			}
 
 			md_bitmap_startwrite(bitmap, r1_bio->sector, r1_bio->sectors,
 					     test_bit(R1BIO_BehindIO, &r1_bio->state));
-- 
2.39.2

