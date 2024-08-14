Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCE814E2FA;
	Wed, 14 Aug 2024 07:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619740; cv=none; b=p92pXTDDWhYQW1FHZvSDIv/7O+X0YjumjNGleyjqJEsJN00jWU5m2PcXotK8/w3o2ajEEBo1msEF9Z8xWuUi98L0m4Tes0Db++3o5QongYgv/VkT9fsk/tKAx9DuA3TF6xRg4RMqrChmAmUHEMRSl/5/+cmzg3D/IUyhpC7PZ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619740; c=relaxed/simple;
	bh=yawgvxopyN2QMVnfW3VYYWsF0by52TIQNf3mSHrm+eI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IBPy630KFcuQoFReN5492stTolUfWjQkKoEhhZ8p3IQ1tUXCZWZWkhOj7YQvoCIOx7iQjoiTtSNyh/8TcBI2yR1wrLHI54WcQezPjUrajJpLHaMOYN7QB1GmwmJfqrIk6KYJkW/s30/cG9Mxw5QvyIo0P1iPyOr1ZRMAMk/MlOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WkKK51ZLgz4f3jHT;
	Wed, 14 Aug 2024 15:15:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EE7E41A06D7;
	Wed, 14 Aug 2024 15:15:34 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S26;
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
Subject: [PATCH RFC -next v2 22/41] md/md-bitmap: merge md_bitmap_startwrite() into bitmap_operations
Date: Wed, 14 Aug 2024 15:10:54 +0800
Message-Id: <20240814071113.346781-23-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S26
X-Coremail-Antispam: 1UD129KBjvJXoW3XrWDtr18Kw47Zw4UGry5XFb_yoW7XFW7pa
	1DXFya93y5JF45Xw1DGFyDuFyFy3WktrZrtrWfX3s5uFyqvrnxWF48WFyUtw15CFy3AFZx
	Z3Z8trWUGr42qFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
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
bitmap outside md-bitmap.c as much as possible. And change the type
of 'behind' from int to bool.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  8 ++++++--
 drivers/md/md-bitmap.h |  5 +++--
 drivers/md/raid1.c     |  5 +++--
 drivers/md/raid10.c    |  3 ++-
 drivers/md/raid5.c     | 13 +++++--------
 5 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 01f2370b991c..1387d5bbf8a1 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1458,8 +1458,11 @@ __acquires(bitmap->lock)
 			&(bitmap->bp[page].map[pageoff]);
 }
 
-int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors, int behind)
+static int bitmap_startwrite(struct mddev *mddev, sector_t offset,
+			     unsigned long sectors, bool behind)
 {
+	struct bitmap *bitmap = mddev->bitmap;
+
 	if (!bitmap)
 		return 0;
 
@@ -1520,7 +1523,6 @@ int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long s
 	}
 	return 0;
 }
-EXPORT_SYMBOL(md_bitmap_startwrite);
 
 void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
 			unsigned long sectors, int success, int behind)
@@ -2725,6 +2727,8 @@ static struct bitmap_operations bitmap_ops = {
 	.write_all		= bitmap_write_all,
 	.dirty_bits		= bitmap_dirty_bits,
 
+	.startwrite		= bitmap_startwrite,
+
 	.update_sb		= bitmap_update_sb,
 	.get_stats		= bitmap_get_stats,
 };
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index fded46433bcb..cc76b4a69a31 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -254,6 +254,9 @@ struct bitmap_operations {
 	void (*dirty_bits)(struct mddev *mddev, unsigned long s,
 			   unsigned long e);
 
+	int (*startwrite)(struct mddev *mddev, sector_t offset,
+			  unsigned long sectors, bool behind);
+
 	void (*update_sb)(struct bitmap *bitmap);
 	int (*get_stats)(struct bitmap *bitmap, struct md_bitmap_stats *stats);
 };
@@ -262,8 +265,6 @@ struct bitmap_operations {
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
-			 unsigned long sectors, int behind);
 void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
 			unsigned long sectors, int success, int behind);
 int md_bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int degraded);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5e1a487bd4de..e07b3a0427cb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1616,8 +1616,9 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			    !stats.behind_wait)
 				alloc_behind_master_bio(r1_bio, bio);
 
-			md_bitmap_startwrite(bitmap, r1_bio->sector, r1_bio->sectors,
-					     test_bit(R1BIO_BehindIO, &r1_bio->state));
+			mddev->bitmap_ops->startwrite(mddev, r1_bio->sector,
+				r1_bio->sectors,
+				test_bit(R1BIO_BehindIO, &r1_bio->state));
 			first_clone = 0;
 		}
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2a9c4ee982e0..96de2d68c913 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1492,7 +1492,8 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	md_account_bio(mddev, &bio);
 	r10_bio->master_bio = bio;
 	atomic_set(&r10_bio->remaining, 1);
-	md_bitmap_startwrite(mddev->bitmap, r10_bio->sector, r10_bio->sectors, 0);
+	mddev->bitmap_ops->startwrite(mddev, r10_bio->sector, r10_bio->sectors,
+				      false);
 
 	for (i = 0; i < conf->copies; i++) {
 		if (r10_bio->devs[i].bio)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c14cf2410365..c24036d1e6da 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3563,8 +3563,8 @@ static void __add_stripe_bio(struct stripe_head *sh, struct bio *bi,
 		 */
 		set_bit(STRIPE_BITMAP_PENDING, &sh->state);
 		spin_unlock_irq(&sh->stripe_lock);
-		md_bitmap_startwrite(conf->mddev->bitmap, sh->sector,
-				     RAID5_STRIPE_SECTORS(conf), 0);
+		conf->mddev->bitmap_ops->startwrite(conf->mddev, sh->sector,
+					RAID5_STRIPE_SECTORS(conf), false);
 		spin_lock_irq(&sh->stripe_lock);
 		clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
 		if (!sh->batch_head) {
@@ -5788,13 +5788,10 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		}
 		spin_unlock_irq(&sh->stripe_lock);
 		if (conf->mddev->bitmap) {
-			for (d = 0;
-			     d < conf->raid_disks - conf->max_degraded;
+			for (d = 0; d < conf->raid_disks - conf->max_degraded;
 			     d++)
-				md_bitmap_startwrite(mddev->bitmap,
-						     sh->sector,
-						     RAID5_STRIPE_SECTORS(conf),
-						     0);
+				mddev->bitmap_ops->startwrite(mddev, sh->sector,
+					RAID5_STRIPE_SECTORS(conf), false);
 			sh->bm_seq = conf->seq_flush + 1;
 			set_bit(STRIPE_BIT_DELAY, &sh->state);
 		}
-- 
2.39.2

