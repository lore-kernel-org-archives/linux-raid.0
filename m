Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F37130AF6;
	Sat, 10 Aug 2024 02:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255980; cv=none; b=Wc5NqJ6rCml7W+5vzPy7aOQGjTaSFYurVqSAW6jtpOI1aEn3MnxPdMX5Tx23z84m1xyuSHtqscXH8DySYZPIHUCRFEyy0ZuIXmeksykllwGTSJkR3j/X0uSefIBVQLj+1UB1CB/VhOsWc6VmN/fu+I33HKMxKwTriTwYPqMMnxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255980; c=relaxed/simple;
	bh=3GoKVzYachsSHL4Lugg1lCn/HUX3KP9ILTUz99MjpN0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fbdH693/I/wjOXcY9fzivN+4tx1z4xLYSWK8zTgjR1CBiYixm+ZzlUBBta2H2WZi5M14lx1NRIt3xQsv5o9cg9XGs1KD6zR/LZSM2IOEkWKHACgqSoSye4+Tp+/UEjpoHKutzfg+lMgdp03XpIZI2mBlfsGeSM8n8r2oobH+kq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgknp675Jz4f3jkL;
	Sat, 10 Aug 2024 10:12:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E90961A11D6;
	Sat, 10 Aug 2024 10:12:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S14;
	Sat, 10 Aug 2024 10:12:55 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 10/26] md/md-bitmap: merge bitmap_write_all() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:38 +0800
Message-Id: <20240810020854.797814-11-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S14
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr45Cr4xZw1rtrWrKrWfKrg_yoW5JFW3pa
	y7Ka45u3y5JFW7X3W7AFyDuFyYv3Wktr9rtrWfC34ruFyUAFnxWF4rWa4Utwn5GrW3JFsx
	Zw45try8Gr48XF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYcTQUUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 3 ++-
 drivers/md/md-bitmap.h | 9 ++++++++-
 drivers/md/md.c        | 2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 9a21123a3b8b..aab7bb5418f7 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1225,7 +1225,7 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	return ret;
 }
 
-void md_bitmap_write_all(struct bitmap *bitmap)
+static void bitmap_write_all(struct bitmap *bitmap)
 {
 	/* We don't actually write all bitmap blocks here,
 	 * just flag them as needing to be written
@@ -2712,6 +2712,7 @@ static struct bitmap_operations bitmap_ops = {
 	.destroy		= bitmap_destroy,
 	.flush			= bitmap_flush,
 	.status			= bitmap_status,
+	.write_all		= bitmap_write_all,
 
 	.update_sb		= bitmap_update_sb,
 };
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 3fd2e5a7ba9c..9df0c1d5f7ee 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -240,6 +240,7 @@ struct bitmap_operations {
 	void (*destroy)(struct mddev *mddev);
 	void (*flush)(struct mddev *mddev);
 	void (*status)(struct seq_file *seq, struct bitmap *bitmap);
+	void (*write_all)(struct bitmap *bitmap);
 
 	void (*update_sb)(struct bitmap *bitmap);
 };
@@ -296,7 +297,13 @@ static inline void md_bitmap_update_sb(struct mddev *mddev)
 	mddev->bitmap_ops->update_sb(mddev->bitmap);
 }
 
-void md_bitmap_write_all(struct bitmap *bitmap);
+static inline void md_bitmap_write_all(struct mddev *mddev)
+{
+	if (!mddev->bitmap || !mddev->bitmap_ops->write_all)
+		return;
+
+	mddev->bitmap_ops->write_all(mddev->bitmap);
+}
 
 void md_bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long e);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 033ea06f6abe..2260540dd458 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9507,7 +9507,7 @@ static void md_start_sync(struct work_struct *ws)
 	 * stored on all devices. So make sure all bitmap pages get written.
 	 */
 	if (spares)
-		md_bitmap_write_all(mddev->bitmap);
+		md_bitmap_write_all(mddev);
 
 	name = test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
 			"reshape" : "resync";
-- 
2.39.2

