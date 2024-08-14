Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A982F13AA27;
	Wed, 14 Aug 2024 07:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619733; cv=none; b=BK6sLHX+QIaw4zqPOK6SRDROXkz1aLsGjHOf0JOiFMBT+B+3O1CXvVK3s9obsCTBiYd9laap1kn44eVOHvst8Wwld3F8vRtPqOUTgAnbK+6rAQum5+/JkBo0vHlHnuMMl7d0iPbZQCImfWLB6wxn3+My9nZGq1B+3ukd1E76T2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619733; c=relaxed/simple;
	bh=Of9GnqItEHq+L0T4tjM0slvjKwDloXOvnPmj+hEtqlM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mVHITfpGdiTQ5UGm0XvvGVsZHR/4I0gh06hY+/BWq2oPmsijUn35yKsJSMa2+lRCzmvIOtBfroQgUR28GnYLoBcu9DiJ7ixaFfyolKH1pcNIcDw4sA1eFctlUQN1QydNdzfNC3UbsyiFPNCUyfqdu4fyfZkWnFpw87ZoZ+zBDYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKK30fBJz4f3jZ1;
	Wed, 14 Aug 2024 15:15:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 690801A018D;
	Wed, 14 Aug 2024 15:15:28 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S10;
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
Subject: [PATCH RFC -next v2 06/41] md/md-bitmap: add 'file_pages' into struct md_bitmap_stats
Date: Wed, 14 Aug 2024 15:10:38 +0800
Message-Id: <20240814071113.346781-7-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S10
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr47Kr4xtF15Jry8CrWktFb_yoW8KF45pa
	ykJa45urWrXr45Xw17XFyDuFyrX3ZxKFZrKF93C3y5uFyUAF9xWFWrGFWUJw1DCFW5AFsx
	Zrn8trWUur1j9w7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  1 +
 drivers/md/md-bitmap.h |  1 +
 drivers/md/md.c        | 12 ++++++++----
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 9ff5ed250ba5..cd304240aaa6 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2109,6 +2109,7 @@ int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 	counts = &bitmap->counts;
 	stats->pages = counts->pages;
 	stats->missing_pages = counts->missing_pages;
+	stats->file_pages = bitmap->storage.file_pages;
 	stats->file = bitmap->storage.file;
 	stats->events_cleared = bitmap->events_cleared;
 
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 1a7ad2cf9f75..52ef4dae8f3e 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -237,6 +237,7 @@ struct bitmap {
 struct md_bitmap_stats {
 	unsigned long pages;
 	unsigned long missing_pages;
+	unsigned long file_pages;
 	unsigned long sync_size;
 	struct file *file;
 	u64 events_cleared;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 29ec6fe80ae8..628fa49170e1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2323,7 +2323,10 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 			 unsigned long long new_offset)
 {
 	/* All necessary checks on new >= old have been done */
-	struct bitmap *bitmap;
+	struct bitmap *bitmap = rdev->mddev->bitmap;
+	struct md_bitmap_stats stats;
+	int err;
+
 	if (new_offset >= rdev->data_offset)
 		return 1;
 
@@ -2340,10 +2343,11 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 	 */
 	if (rdev->sb_start + (32+4)*2 > new_offset)
 		return 0;
-	bitmap = rdev->mddev->bitmap;
-	if (bitmap && !rdev->mddev->bitmap_info.file &&
+
+	err = md_bitmap_get_stats(bitmap, &stats);
+	if (!err && !rdev->mddev->bitmap_info.file &&
 	    rdev->sb_start + rdev->mddev->bitmap_info.offset +
-	    bitmap->storage.file_pages * (PAGE_SIZE>>9) > new_offset)
+	    stats.file_pages * (PAGE_SIZE>>9) > new_offset)
 		return 0;
 	if (rdev->badblocks.sector + rdev->badblocks.size > new_offset)
 		return 0;
-- 
2.39.2

