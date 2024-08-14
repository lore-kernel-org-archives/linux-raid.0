Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8057144D0A;
	Wed, 14 Aug 2024 07:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619736; cv=none; b=UMho1bhMYrMfcXDz0afYk0cjFzA4zKC9kHF3W7tGlr16S5KTOxKladyERskyxNAES157lSCDGkRe11GdLVO4Svx1OfqMagReg13/RK+aUAXco2liOGy5aoCdlPKfJzmurgWtSxNI3lsmav9rsrMIYNiMdkKPrmk3SOY6Fl629s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619736; c=relaxed/simple;
	bh=r8PzBI7J+CY6oiwe21tDvXq7GnGeNiQ21nx7K8izyrw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fzE6K6iKZvdhKLWlkO9iUq08x38hdC+yR0NgAagp1tvWzG1TaVFtzUdca8IKMj2n82KrGZOm27ME9+NF0yfH6aCIyMU6s3Js97rFMoNQ9ScvBVT9RuaXzbGfD0nnxtR6RPz//vy7tfhm85Zr2RLl+k/5vFdCMp9RLJsd2g8J/Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WkKK22JMvz4f3jHT;
	Wed, 14 Aug 2024 15:15:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 167C51A15C7;
	Wed, 14 Aug 2024 15:15:32 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S19;
	Wed, 14 Aug 2024 15:15:31 +0800 (CST)
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
Subject: [PATCH RFC -next v2 15/41] md/md-bitmap: merge md_bitmap_flush() into bitmap_operations
Date: Wed, 14 Aug 2024 15:10:47 +0800
Message-Id: <20240814071113.346781-16-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S19
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr45Cr4fAFW5Jw1rCF4Uurg_yoW8tr45pF
	Z7ta45Cr45JFW3Ww1UZFykCa4Yq3WktrZrKFWfC34ruFyUZFn8GF4rWayDtwn5W3W3JFsI
	vw15tryUWr18XrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQFxUU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 6 ++----
 drivers/md/md-bitmap.h | 2 +-
 drivers/md/md.c        | 3 ++-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 94cf3c6e96e3..d1b43bce5953 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1773,10 +1773,7 @@ void md_bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long
 	}
 }
 
-/*
- * flush out any pending updates
- */
-void md_bitmap_flush(struct mddev *mddev)
+static void bitmap_flush(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 	long sleep;
@@ -2722,6 +2719,7 @@ static struct bitmap_operations bitmap_ops = {
 	.create			= bitmap_create,
 	.load			= bitmap_load,
 	.destroy		= bitmap_destroy,
+	.flush			= bitmap_flush,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 9376bbeb4698..0212284c2b29 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -249,13 +249,13 @@ struct bitmap_operations {
 	int (*create)(struct mddev *mddev, int slot);
 	int (*load)(struct mddev *mddev);
 	void (*destroy)(struct mddev *mddev);
+	void (*flush)(struct mddev *mddev);
 };
 
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
-void md_bitmap_flush(struct mddev *mddev);
 
 void md_bitmap_print_sb(struct bitmap *bitmap);
 void md_bitmap_update_sb(struct bitmap *bitmap);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7aecd99d50e2..69d4b21c441e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6450,7 +6450,8 @@ static void __md_stop_writes(struct mddev *mddev)
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
 	}
-	md_bitmap_flush(mddev);
+
+	mddev->bitmap_ops->flush(mddev);
 
 	if (md_is_rdwr(mddev) &&
 	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
-- 
2.39.2

