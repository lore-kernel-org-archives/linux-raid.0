Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408BC1CFBE;
	Thu, 22 Aug 2024 02:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295131; cv=none; b=mAyiWJy19sr96OK+0Gj0x/vd1kmmuad2pZ5/1mtsG4QbLxrshbb1cdpD0yU549+/zQ/o2SnSlNiJUZ04jNpaore97gO0KHfXqKRKFGXmSDyVkJSgW5nZRjwDpSWP35109MBedQ4HbSuVH8fjHQKtOeuL4i4MQK+ctHG6tf2CT7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295131; c=relaxed/simple;
	bh=aUzKtCnZV18bC7cCEQnI7mbJOfidHVcbtPHpuZAop9s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tw3B7dT0U/YYxRZX8YYhqzymPTov+sNFnpM5DlYFCErnSr7yCtAhfY/GgswIUVTZgj1ZFS1yRNibcWlDr216UxEhy32GmzYfPWXeqDSR/Xh3Ew1PG8wfcmO4sQJmQe337YC7vNxJtlPdEMeyZiXUe9fhWcsVYG5kRgF2Us36woQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wq75P3ldNz4f3kny;
	Thu, 22 Aug 2024 10:51:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 36CFD1A06D7;
	Thu, 22 Aug 2024 10:52:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S11;
	Thu, 22 Aug 2024 10:52:03 +0800 (CST)
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
Subject: [PATCH md-6.12 07/41] md/md-bitmap: add 'behind_writes' and 'behind_wait' into struct md_bitmap_stats
Date: Thu, 22 Aug 2024 10:46:44 +0800
Message-Id: <20240822024718.2158259-8-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S11
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr47Kr4xtF15Jry8XrWUJwb_yoW5JF47pF
	WDX345uw45JF45Xr1DZFyUZFyrJasaqFZrKFWfu3s5uFy2yF9IgF40gFW5Cw1DCF93AF45
	Xr45JryUuryYqF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm214x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVF
	xhVjvjDU0xZFpf9x0JUWMKtUUUUU=
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
index 82b31a46caa1..ab349182e646 100644
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

