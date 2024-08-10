Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469B614373A;
	Sat, 10 Aug 2024 02:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255985; cv=none; b=qlMUYyfwThDiGrCo0l2lK32NZ7T+pdkAm3CqoT5n6ICcEprqjqBlPbK0XfmKdTAGTud5s4GtVaDTN5pMlaK9eh97ewEfjY2lxJ74hlcruoA6ac5TEADljdlrh1v9z69hxim6in4+uxf+2TKWkBgP5k3fLzx7v0r6TGEXvgV2/iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255985; c=relaxed/simple;
	bh=zfiglKccvzzgA0/fEWZcwMg3ZBLAuwYhbnLVJSyk+Ic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kz2gA0swddXC6PcDAfR7cK9oLiIs5EMs9UjsPUOoD4MsYOlHcw5ZvlPTZvJgosM8+4jVzCIcolAAzFBYB6+kZreYxRZV+N2D08OtfQFFVdTdhUjfuXv6es9v9mXh8UOvX5nS+86lpJ0y75OTii7HC2pDntWPWQPpsBc4CgOwQeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wgknj5CcQz4f3jdK;
	Sat, 10 Aug 2024 10:12:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3CF881A0568;
	Sat, 10 Aug 2024 10:12:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S12;
	Sat, 10 Aug 2024 10:12:55 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 08/26] md/md-bitmap: merge md_bitmap_status() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:36 +0800
Message-Id: <20240810020854.797814-9-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S12
X-Coremail-Antispam: 1UD129KBjvJXoWxGF17Gr1DWFWfAF18CFy8Zrb_yoW5XF4Upa
	y7J3W5CrW5JFWfX3W7AFyq9a45X3Wktr9rKr97C3yruFy7XFnxWF4rGa4Utw1rGF1fJFsx
	Z3Z8KryUGr18XFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYcTQUUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  3 ++-
 drivers/md/md-bitmap.h | 11 +++++++++--
 drivers/md/md.c        |  2 +-
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b34f13aa2697..9a21123a3b8b 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2092,7 +2092,7 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 EXPORT_SYMBOL_GPL(md_bitmap_copy_from_slot);
 
 
-void md_bitmap_status(struct seq_file *seq, struct bitmap *bitmap)
+static void bitmap_status(struct seq_file *seq, struct bitmap *bitmap)
 {
 	unsigned long chunk_kb;
 	struct bitmap_counts *counts;
@@ -2711,6 +2711,7 @@ static struct bitmap_operations bitmap_ops = {
 	.load			= bitmap_load,
 	.destroy		= bitmap_destroy,
 	.flush			= bitmap_flush,
+	.status			= bitmap_status,
 
 	.update_sb		= bitmap_update_sb,
 };
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 29c217630ae5..c60b6a9f6163 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -239,6 +239,7 @@ struct bitmap_operations {
 	int (*load)(struct mddev *mddev);
 	void (*destroy)(struct mddev *mddev);
 	void (*flush)(struct mddev *mddev);
+	void (*status)(struct seq_file *seq, struct bitmap *bitmap);
 
 	void (*update_sb)(struct bitmap *bitmap);
 };
@@ -279,6 +280,14 @@ static inline void md_bitmap_flush(struct mddev *mddev)
 	mddev->bitmap_ops->flush(mddev);
 }
 
+static inline void md_bitmap_status(struct seq_file *seq, struct mddev *mddev)
+{
+	if (!mddev->bitmap || !mddev->bitmap_ops->status)
+		return;
+
+	mddev->bitmap_ops->status(seq, mddev->bitmap);
+}
+
 static inline void md_bitmap_update_sb(struct mddev *mddev)
 {
 	if (!mddev->bitmap || !mddev->bitmap_ops->update_sb)
@@ -287,8 +296,6 @@ static inline void md_bitmap_update_sb(struct mddev *mddev)
 	mddev->bitmap_ops->update_sb(mddev->bitmap);
 }
 
-void md_bitmap_status(struct seq_file *seq, struct bitmap *bitmap);
-
 int  md_bitmap_setallbits(struct bitmap *bitmap);
 void md_bitmap_write_all(struct bitmap *bitmap);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index e749e24e12de..033ea06f6abe 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8454,7 +8454,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		} else
 			seq_printf(seq, "\n       ");
 
-		md_bitmap_status(seq, mddev->bitmap);
+		md_bitmap_status(seq, mddev);
 
 		seq_printf(seq, "\n");
 	}
-- 
2.39.2

