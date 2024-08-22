Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86C71CD16;
	Thu, 22 Aug 2024 02:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295127; cv=none; b=IjQZ58jbR3pP1FWRkF4d7Y1Bq8hc56homvpDMokB5i0xMr+PVv9ScQikoGlGXjBjKjsewU5YKZbIOMOe7/kQaGGH29Cs8ThrBoHd9QDdFmn/EzJTofL60YkeC5XNeVMc5sfI3RQbqgknbGYPNT/By6lsh85XkdiP3n9htOGvpNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295127; c=relaxed/simple;
	bh=0e+2RLibGr8Nj9yi1GtmTxUh3a348MMApQb+YJyeUA4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AuprXUSG9b/ui+UlmDI0GJcTrK/eqTBocxkch9CWjPY7bEeG5l7jqB/sBimkCPrp5DUxK37Dj0DUYwKhyHioQfzjDmVWm8JdlPXr86eZ7e3SNIIECvAn69/WsOrdlULZSzF4oGIzKJqlVrtJje/S/Vo/Ky1m25owr/diq7VpFM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wq75H4XyPz4f3jsD;
	Thu, 22 Aug 2024 10:51:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D23861A0568;
	Thu, 22 Aug 2024 10:52:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S8;
	Thu, 22 Aug 2024 10:52:01 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@linux.intel.com,
	l@damenly.org,
	xni@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 04/41] md/md-bitmap: add 'events_cleared' into struct md_bitmap_stats
Date: Thu, 22 Aug 2024 10:46:41 +0800
Message-Id: <20240822024718.2158259-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
References: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S8
X-Coremail-Antispam: 1UD129KBjvJXoWxXFyfXw1xtry3Cw4UZw1kXwb_yoW5Jw4kpF
	W8Ja4Ykr4rJF4UXw15ZFyUua45tas3trZ7KryfC3s8uFyUZF98XF4rKFWjvrn0gFW5AF43
	Zw15tFWUury0qaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7VU1zpBDUUUUU==
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

