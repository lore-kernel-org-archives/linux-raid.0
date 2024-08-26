Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E24D185B77;
	Mon, 26 Aug 2024 07:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658609; cv=none; b=BtCiFIJTdNa56MnH9iZjrB1XAiNTdZysbp0EzQD09i7c+1npVboIQ4BqZvwvxl9ojpsFQQzjwrvOXNaY2XmrAeR2VPjm3FPGAh965vR3zmgVtn6IK5borXLQvUksCfHHh2n5x0Ffw5qgATs4SeZxXPU8102lu425bQRw/GQ/920=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658609; c=relaxed/simple;
	bh=1um0DO5r02SkTVnW6zGkh/MmFnGWz8txiWO5oavEXsI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rQxZ43liuS5I57TxZduK/+ALoprIZaaNyopwAXNjqELCKjxquV3oEZHl9aphh1Ub1yYeKeMq2h98xaYpsagZBe9KQhrHi95nXvNUaOs+fStDO0Eg9o5IsC6EACfbQIhFKUy5jZIXBMS9IP/29f1NexRuXPiwmXX2NJiiaVr0J0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsjWJ3BjGz4f3lDG;
	Mon, 26 Aug 2024 15:49:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C86531A1A21;
	Mon, 26 Aug 2024 15:50:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S41;
	Mon, 26 Aug 2024 15:50:03 +0800 (CST)
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
Subject: [PATCH md-6.12 v2 37/42] md/md-bitmap: merge md_bitmap_copy_from_slot() into struct bitmap_operation.
Date: Mon, 26 Aug 2024 15:44:47 +0800
Message-Id: <20240826074452.1490072-38-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S41
X-Coremail-Antispam: 1UD129KBjvJXoWxZFykCF15Kw4xAFy5uF1xZrb_yoWrGry7pa
	1jqasxKrWrJFWaq3WUXFyDua45tw1ktrZrKryxG3yfuFy3WFsxGF48G3WktryUKF1rJFsI
	q3WYkrW8ur15Xr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  | 6 +++---
 drivers/md/md-bitmap.h  | 4 ++--
 drivers/md/md-cluster.c | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index a75f4216fd40..25126cdee4e1 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2088,8 +2088,8 @@ static struct bitmap *bitmap_get_from_slot(struct mddev *mddev, int slot)
 /* Loads the bitmap associated with slot and copies the resync information
  * to our bitmap
  */
-int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
-		sector_t *low, sector_t *high, bool clear_bits)
+static int bitmap_copy_from_slot(struct mddev *mddev, int slot, sector_t *low,
+				 sector_t *high, bool clear_bits)
 {
 	int rv = 0, i, j;
 	sector_t block, lo = 0, hi = 0;
@@ -2131,7 +2131,6 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 
 	return rv;
 }
-EXPORT_SYMBOL_GPL(md_bitmap_copy_from_slot);
 
 void md_bitmap_set_pages(struct bitmap *bitmap, unsigned long pages)
 {
@@ -2782,6 +2781,7 @@ static struct bitmap_operations bitmap_ops = {
 
 	.sync_with_cluster	= bitmap_sync_with_cluster,
 	.get_from_slot		= bitmap_get_from_slot,
+	.copy_from_slot		= bitmap_copy_from_slot,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 6bcb88b71371..94d9a6ae244a 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -277,6 +277,8 @@ struct bitmap_operations {
 				  sector_t old_lo, sector_t old_hi,
 				  sector_t new_lo, sector_t new_hi);
 	struct bitmap *(*get_from_slot)(struct mddev *mddev, int slot);
+	int (*copy_from_slot)(struct mddev *mddev, int slot, sector_t *lo,
+			      sector_t *hi, bool clear_bits);
 };
 
 /* the bitmap API */
@@ -284,8 +286,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
 
-int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
-			     sector_t *lo, sector_t *hi, bool clear_bits);
 void md_bitmap_set_pages(struct bitmap *bitmap, unsigned long pages);
 void md_bitmap_free(struct bitmap *bitmap);
 void md_bitmap_wait_behind_writes(struct mddev *mddev);
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 81c630dcf9ea..515f46983ace 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -317,7 +317,7 @@ static void recover_bitmaps(struct md_thread *thread)
 					str, ret);
 			goto clear_bit;
 		}
-		ret = md_bitmap_copy_from_slot(mddev, slot, &lo, &hi, true);
+		ret = mddev->bitmap_ops->copy_from_slot(mddev, slot, &lo, &hi, true);
 		if (ret) {
 			pr_err("md-cluster: Could not copy data from bitmap %d\n", slot);
 			goto clear_bit;
@@ -857,7 +857,7 @@ static int gather_all_resync_info(struct mddev *mddev, int total_slots)
 		}
 
 		/* Read the disk bitmap sb and check if it needs recovery */
-		ret = md_bitmap_copy_from_slot(mddev, i, &lo, &hi, false);
+		ret = mddev->bitmap_ops->copy_from_slot(mddev, i, &lo, &hi, false);
 		if (ret) {
 			pr_warn("md-cluster: Could not gather bitmaps from slot %d", i);
 			lockres_free(bm_lockres);
@@ -1600,7 +1600,7 @@ static int gather_bitmaps(struct md_rdev *rdev)
 	for (sn = 0; sn < mddev->bitmap_info.nodes; sn++) {
 		if (sn == (cinfo->slot_number - 1))
 			continue;
-		err = md_bitmap_copy_from_slot(mddev, sn, &lo, &hi, false);
+		err = mddev->bitmap_ops->copy_from_slot(mddev, sn, &lo, &hi, false);
 		if (err) {
 			pr_warn("md-cluster: Could not gather bitmaps from slot %d", sn);
 			goto out;
-- 
2.39.2

