Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F40E1586D0;
	Fri, 30 Aug 2024 07:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725002921; cv=none; b=UcGyp90fbay0StfXjJEXZVaG3pRZR53li4+GoQmnjzGLatSNGunB4QGScFJHwy3Y5LWFPKoZWcHcreU2CWExsiTni0+MK68Ba0VYC3H7G7azk17sPOO6LKUK5V1NrinBi5lNuVOXXgqZy2r6OHu32Ld5wgjW2cgK0N8tdinouaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725002921; c=relaxed/simple;
	bh=attVgK11ki1hQ05AyqN2qN9lo6ovOyONuf46lry9MhY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=haReIn803B6R8tkmzcTsPjQyUO+TyxRIrFNquU4TJpG33dhZv98n80Jvn0M8PnlXUEumqjzfsXA1f/EiAerLqFHpaIiqf30RnXDkWJZsDD+IzhNFydz2xySHbpxWXBMMjSn3uYl6S17WX6X+gBK4QiEDCP/I8txkpPiqrBJ96mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Ww8rp1K9yz4f3jqZ;
	Fri, 30 Aug 2024 15:28:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3E6F91A058E;
	Fri, 30 Aug 2024 15:28:36 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WhdNFmxAd_DA--.47391S5;
	Fri, 30 Aug 2024 15:28:36 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@intel.com,
	song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 1/7] md: add a new helper rdev_blocked()
Date: Fri, 30 Aug 2024 15:27:15 +0800
Message-Id: <20240830072721.2112006-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
References: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WhdNFmxAd_DA--.47391S5
X-Coremail-Antispam: 1UD129KBjvJXoW7AFWDAF47Gr1DJr47Kr45Jrb_yoW8GrW8pa
	n3WFW5tw1UCr17W3ZIgF1UCa45Xw1FyFW0kFW3t3y7Xa4UG3yfWanYgrWUJrykXrWfXrsI
	qF43GrW8CFyfXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBG14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAVWUtw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUfDGrUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The helper will be used in later patches for raid1/raid10/raid5, the
difference is that Faulty rdev with unacknowledged bad block will not
be considered blocked.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5d2e6bd58e4d..4ba93af36126 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1002,6 +1002,30 @@ static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bio,
 		trace_block_bio_remap(bio, disk_devt(mddev->gendisk), sector);
 }
 
+static inline bool rdev_blocked(struct md_rdev *rdev)
+{
+	/*
+	 * Blocked will be set by error handler and cleared by daemon after
+	 * updating superblock, meanwhile write IO should be blocked to prevent
+	 * reading old data after power failure.
+	 */
+	if (test_bit(Blocked, &rdev->flags))
+		return true;
+
+	/*
+	 * Faulty device should not be accessed anymore, there is no need to
+	 * wait for bad block to be acknowledged.
+	 */
+	if (test_bit(Faulty, &rdev->flags))
+		return false;
+
+	/* rdev is blocked by badblocks. */
+	if (test_bit(BlockedBadBlocks, &rdev->flags))
+		return true;
+
+	return false;
+}
+
 #define mddev_add_trace_msg(mddev, fmt, args...)			\
 do {									\
 	if (!mddev_is_dm(mddev))					\
-- 
2.39.2

