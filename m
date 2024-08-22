Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7381CD15;
	Thu, 22 Aug 2024 02:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295126; cv=none; b=m7bXLEHTRIXoc2bZdnEMIeHURVsgnc12X5AOjyBty72vjRD1d+X/5A3UtKWMyvLVRUm5g19fkoNiV/fDLWfzGXCt1WlBCA3k4bO3tk5HrGukmmcAKmO43r0GL51UIiow/a7NpnlxIkD5PrJkeMElNC/TtWMcB1B2SwzGxbCrZVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295126; c=relaxed/simple;
	bh=AlnCRfuMKu6QMNGIldmtj055RY4KSn6MUQwndsDBMOM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ny1bH+X6dpovfnws82E7wM/z1N3CN/PH4VQmwNM4IwNPKirD0U92ZOo1cadh0n0o6Qsev297vLWWOjqVjholb9PiyTv87w64hyipxFkPAMc1rFYojRvjSKeE7MuUddXW0oQR324AJrKFpNYKznOXTmlhhHZi1VZBMdwFB6Gj2A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wq75H1Ct3z4f3jdl;
	Thu, 22 Aug 2024 10:51:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6052D1A018D;
	Thu, 22 Aug 2024 10:52:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S7;
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
Subject: [PATCH md-6.12 03/41] md: use new helper md_bitmap_get_stats() in update_array_info()
Date: Thu, 22 Aug 2024 10:46:40 +0800
Message-Id: <20240822024718.2158259-4-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S7
X-Coremail-Antispam: 1UD129KBjvdXoWruFWUuF4xKryfKw47Cry7GFg_yoWDJFcEgF
	4vk348GrW5GryrtFnxZw4avryYyayDW3WkXF47K34xAF1UJa4fGrs5uwn8tr1xXFW7Ar9I
	yryUJw4Svrn5AjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbk8FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWwA2048vs2IY02
	0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84
	ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I2
	62IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcV
	AFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG
	0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI
	1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17
	CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0
	I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I
	8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73
	UjIFyTuYvjfUF3kuDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

There are no functional changes, avoid dereferencing bitmap directly to
prepare inventing a new bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b52d0cc773ae..92e7f05e6bc1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7577,15 +7577,17 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 			if (rv)
 				md_bitmap_destroy(mddev);
 		} else {
-			/* remove the bitmap */
-			if (!mddev->bitmap) {
-				rv = -ENOENT;
+			struct md_bitmap_stats stats;
+
+			rv = md_bitmap_get_stats(mddev->bitmap, &stats);
+			if (rv)
 				goto err;
-			}
-			if (mddev->bitmap->storage.file) {
+
+			if (stats.file) {
 				rv = -EINVAL;
 				goto err;
 			}
+
 			if (mddev->bitmap_info.nodes) {
 				/* hold PW on all the bitmap lock */
 				if (md_cluster_ops->lock_all_bitmaps(mddev) <= 0) {
-- 
2.39.2

