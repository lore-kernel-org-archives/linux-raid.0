Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1E4433A0;
	Sat, 10 Aug 2024 02:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255979; cv=none; b=qlkcjZ/rLMewIGAK8T5CpF+o9FX+zMGAhB+OGPV++lCmzvhj0I3pHkBPrnAznGlENedzbGf8BJb5XaaY/p+t+6xuKzqqHuKrfNLlKXgu5Srpv5l7ol1Ca4VDkWsfoiNcnE7zOrU9Ylv3dsw8AmcIX3Ob+aSbfmQ+FQCfLA9geFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255979; c=relaxed/simple;
	bh=XuzieE8hEXTvl4iETklpJsh4ejMMZBLqiyTNyaxkPp0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iSbHJIWpIWn5LS4gtXiQzVdEEvUHyH2cdswcpm6ELBQ5yKm7TeTSoKEztiBG9YMP5J9f0GNwW0huuN+OycPv30kiHKVGmB/7NbNkk+QDs4zwh3Va1CfDk6pe2bIs3N3M7I2KpwH+8Rhoy1REVEOWj88ldfj3rMY+XUNQ9tk4gnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgkng5rxFz4f3jLc;
	Sat, 10 Aug 2024 10:12:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4B41A1A058E;
	Sat, 10 Aug 2024 10:12:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S9;
	Sat, 10 Aug 2024 10:12:54 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 05/26] md/md-bitmap: merge md_bitmap_flush() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:33 +0800
Message-Id: <20240810020854.797814-6-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S9
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr45Cr4rAr1Uuw4rJw4DXFb_yoW8Cw1rpF
	srt3W5Cw43tFW3Ww1UZFyDCa4FvF1ktrZrKFyfCw1rCF9xXFnxGF4rWa4jyw1rGF13JFsI
	vw15tr1UWr18XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPUUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 3 ++-
 drivers/md/md-bitmap.h | 9 ++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 8aaf0491bf5d..33bcae5594e2 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1776,7 +1776,7 @@ void md_bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long
 /*
  * flush out any pending updates
  */
-void md_bitmap_flush(struct mddev *mddev)
+static void bitmap_flush(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 	long sleep;
@@ -2711,6 +2711,7 @@ static struct bitmap_operations bitmap_ops = {
 	.create			= bitmap_create,
 	.load			= bitmap_load,
 	.destroy		= bitmap_destroy,
+	.flush			= bitmap_flush,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 46db4d8199d8..749351db04d3 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -238,6 +238,7 @@ struct bitmap_operations {
 	struct bitmap* (*create)(struct mddev *mddev, int slot);
 	int (*load)(struct mddev *mddev);
 	void (*destroy)(struct mddev *mddev);
+	void (*flush)(struct mddev *mddev);
 };
 
 /* the bitmap API */
@@ -268,7 +269,13 @@ static inline void md_bitmap_destroy(struct mddev *mddev)
 	mddev->bitmap_ops->destroy(mddev);
 }
 
-void md_bitmap_flush(struct mddev *mddev);
+static inline void md_bitmap_flush(struct mddev *mddev)
+{
+	if (!mddev->bitmap_ops->flush)
+		return;
+
+	mddev->bitmap_ops->flush(mddev);
+}
 
 void md_bitmap_print_sb(struct bitmap *bitmap);
 void md_bitmap_update_sb(struct bitmap *bitmap);
-- 
2.39.2

