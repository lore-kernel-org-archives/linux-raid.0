Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CEF13A25F;
	Mon, 26 Aug 2024 07:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658595; cv=none; b=OyBYntEuwNLdT7FeOFI9OhPvA6Vequ/+bXRn4KfAFgE95F3ZqsS2n50LkSV/U9LUznIKtB46dZD4c6SQfdhcWqfa5uDy+ePnSVP93toehnX+tVQCGIwL770SKvJw8z6NSlYnokupsqCJlAKchC1Gub1Xp0qBsLwJZZ6uTSvdBHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658595; c=relaxed/simple;
	bh=0e+2RLibGr8Nj9yi1GtmTxUh3a348MMApQb+YJyeUA4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mH4UK05lNo+koNQR/iDme3ehoLX8cz2Qynenw7p+e+rD8812aAxCQt2P790OWlq80/zqtLNYd2meWaa3ED7OivHX0fv2a9kx/1jasf/p7d91rxoKPMWRsGrAG3ZLnIfE4SM9vfaN5NpM6mSTWxSdarPmQ/L3ihoLMMplhz7oOds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsjW268x9z4f3l22;
	Mon, 26 Aug 2024 15:49:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 37FD91A018D;
	Mon, 26 Aug 2024 15:49:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S8;
	Mon, 26 Aug 2024 15:49:50 +0800 (CST)
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
Subject: [PATCH md-6.12 v2 04/42] md/md-bitmap: add 'events_cleared' into struct md_bitmap_stats
Date: Mon, 26 Aug 2024 15:44:14 +0800
Message-Id: <20240826074452.1490072-5-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S8
X-Coremail-Antispam: 1UD129KBjvJXoWxXFyfXw1xtry3Cw4UZw1kXwb_yoW5Jw4kpF
	W8Ja4Ykr4rJF4UXw15ZFyUua45tas3trZ7KryfC3s8uFyUZF98XF4rKFWjvrn0gFW5AF43
	Zw15tFWUury0qaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUOyIUUUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Also add a new helper to get events_cleared to avoid dereferencing
bitmap directly to prepare inventing a new bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  2 ++
 drivers/md/md-bitmap.h |  1 +
 drivers/md/md.c        | 16 ++++++++++++++--
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 66ebe12d80ae..95afc22bd255 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2104,6 +2104,8 @@ int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 	counts = &bitmap->counts;
 	stats->missing_pages = counts->missing_pages;
 	stats->pages = counts->pages;
+
+	stats->events_cleared = bitmap->events_cleared;
 	stats->file = bitmap->storage.file;
 
 	return 0;
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index b60418e3f573..751dca2366c3 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -235,6 +235,7 @@ struct bitmap {
 };
 
 struct md_bitmap_stats {
+	u64		events_cleared;
 	unsigned long	missing_pages;
 	unsigned long	pages;
 	struct file	*file;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 92e7f05e6bc1..5e1dd3009092 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1372,6 +1372,18 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 	return ret;
 }
 
+static u64 md_bitmap_events_cleared(struct mddev *mddev)
+{
+	struct md_bitmap_stats stats;
+	int err;
+
+	err = md_bitmap_get_stats(mddev->bitmap, &stats);
+	if (err)
+		return 0;
+
+	return stats.events_cleared;
+}
+
 /*
  * validate_super for 0.90.0
  * note: we are not using "freshest" for 0.9 superblock
@@ -1464,7 +1476,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *freshest, stru
 		/* if adding to array with a bitmap, then we can accept an
 		 * older device ... but not too old.
 		 */
-		if (ev1 < mddev->bitmap->events_cleared)
+		if (ev1 < md_bitmap_events_cleared(mddev))
 			return 0;
 		if (ev1 < mddev->events)
 			set_bit(Bitmap_sync, &rdev->flags);
@@ -1991,7 +2003,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
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

