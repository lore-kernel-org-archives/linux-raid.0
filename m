Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9D613A40C;
	Wed, 14 Aug 2024 07:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619734; cv=none; b=AI+k+PcccA7u2z/bfcyzyqgYo5EH8GkK3gJqLOMjjc7OBLFw/jJYtekL4EJrPTEJspEUK7M/TLQRk6Q2x5UG40hBcHQm3iA48zWCjJTA6mfcgDlYiNv4LchujlI4T4yOhXXu6KIgsOIyzDe+/p1UVjtReVMqwFamYgMswwu8zjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619734; c=relaxed/simple;
	bh=oNYBbRGv+iB0zEXtUms24ZgMssacSQmKc2ExHYel+E4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KxN0z2erI5yQhmzkqArSZc9uZigcySyEO8OvxiwsPlzDsUOraqlUBbAQsCMnIoSw2jnPkfa0zmUZtGLtZr83Q+dCJ+LfTH4+f/iRoe/FT1OglOg9Petkee1LKcZGaE7BmtnpfB+i7903Bf2PMNqVOWN8cYJ4URwWEurfoLlm8HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WkKJz0W7jz4f3jXm;
	Wed, 14 Aug 2024 15:15:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CB5F81A058E;
	Wed, 14 Aug 2024 15:15:28 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S11;
	Wed, 14 Aug 2024 15:15:28 +0800 (CST)
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
Subject: [PATCH RFC -next v2 07/41] md/md-bitmap: add 'behind_writes' and 'behind_wait' into struct md_bitmap_stats
Date: Wed, 14 Aug 2024 15:10:39 +0800
Message-Id: <20240814071113.346781-8-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S11
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr47Kr4xtF15Jry8XrWUJwb_yoW8Kw1UpF
	Wqq345uw45XF45Xw1DZFy8ZFyrJ3Z0qFZrKFWfu3s8uFy2yF90ga1FgFWUCw1DCF9xAF43
	XF45JryUuFyjqFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOyIUUUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

There are no functional changes, avoid dereferencing bitmap directly to
prepare inventing a new bitmap.

Also fix following checkpatch warning by using wq_has_sleeper().

WARNING: waitqueue_active without comment

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  2 ++
 drivers/md/md-bitmap.h |  2 ++
 drivers/md/raid1.c     | 12 +++++++-----
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index cd304240aaa6..7dcb025207b8 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2113,6 +2113,8 @@ int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 	stats->file = bitmap->storage.file;
 	stats->events_cleared = bitmap->events_cleared;
 
+	stats->behind_writes = atomic_read(&bitmap->behind_writes);
+	stats->behind_wait = wq_has_sleeper(&bitmap->behind_wait);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(md_bitmap_get_stats);
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 52ef4dae8f3e..119644907f89 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -241,6 +241,8 @@ struct md_bitmap_stats {
 	unsigned long sync_size;
 	struct file *file;
 	u64 events_cleared;
+	int behind_writes;
+	bool behind_wait;
 };
 
 /* the bitmap API */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 81fc100e7830..bfd2d63d1c59 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1603,16 +1603,18 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			continue;
 
 		if (first_clone) {
+			struct md_bitmap_stats stats;
+			int err = md_bitmap_get_stats(bitmap, &stats);
+
 			/* do behind I/O ?
 			 * Not if there are too many, or cannot
 			 * allocate memory, or a reader on WriteMostly
 			 * is waiting for behind writes to flush */
-			if (bitmap && write_behind &&
-			    (atomic_read(&bitmap->behind_writes)
-			     < mddev->bitmap_info.max_write_behind) &&
-			    !waitqueue_active(&bitmap->behind_wait)) {
+			if (!err && write_behind &&
+			    stats.behind_writes <
+			    mddev->bitmap_info.max_write_behind &&
+			    !stats.behind_wait)
 				alloc_behind_master_bio(r1_bio, bio);
-			}
 
 			md_bitmap_startwrite(bitmap, r1_bio->sector, r1_bio->sectors,
 					     test_bit(R1BIO_BehindIO, &r1_bio->state));
-- 
2.39.2

