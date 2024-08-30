Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7F2166305;
	Fri, 30 Aug 2024 07:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725002924; cv=none; b=UtX1maAnJ7bdjV+3AR6f2I8WgGtQeGxi2PvjYAq7Psjjc7N1OY3WPw4R2AY3VCoa5HH2gQ4mp6Z0uPiJIrfgrr4zUTzxusYhfFpqjohqVtlYm8YQLhU4GoGdxi/ZXk9kJDOeiKJiyJgKCU6YvZzWCjz46hT3wOGl47kA4MipwdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725002924; c=relaxed/simple;
	bh=3JJI8YwdeeVV6IYNcCe9JxGFSFw8iwCLC0VGfgw2uV8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Or/BlE5ecAsX/lgsQmV1FV3Q/f4vhJsm3IlGEs4WP1AUabI4+S9TikX6MR5No8SfX2zEa9NoTtO4PezAG8WUbGYujqp4quLY8c7E2gypfUsFeaFr5AVQtLTNITNLX8Ag/inLaUPAN0XGrJR71gbRPiOQUVN4dcX7pqgCz691gPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Ww8rt1dD2z4f3k5Y;
	Fri, 30 Aug 2024 15:28:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4785D1A0E9B;
	Fri, 30 Aug 2024 15:28:40 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WhdNFmxAd_DA--.47391S9;
	Fri, 30 Aug 2024 15:28:40 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@intel.com,
	song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 5/7] md/raid1: don't wait for Faulty rdev in wait_blocked_rdev()
Date: Fri, 30 Aug 2024 15:27:19 +0800
Message-Id: <20240830072721.2112006-6-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WhdNFmxAd_DA--.47391S9
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw1UWr47Cw18GFWUGF1xXwb_yoW8Gw1fpa
	n3uFWSqrWUCw4UXF9FkFy8AFyYqa1UKFWIkrW2yw18Xay3Ar98Jw40vas3JFykAFZIv398
	XF1fW3y8Ca4Y9F7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPUUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Faulty rdev should never be accessed anymore, hence there is no point to
wait for bad block to be acknowledged in this case while handling write
request.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid1.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index aa30c3240c85..f08d7f607d8b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1419,25 +1419,16 @@ static bool wait_blocked_rdev(struct mddev *mddev, struct bio *bio)
 		if (!rdev)
 			continue;
 
-		if (test_bit(Blocked, &rdev->flags)) {
-			if (bio->bi_opf & REQ_NOWAIT)
-				return false;
-
-			mddev_add_trace_msg(rdev->mddev, "raid1 wait rdev %d blocked",
-					    rdev->raid_disk);
-			atomic_inc(&rdev->nr_pending);
-			md_wait_for_blocked_rdev(rdev, rdev->mddev);
-			goto retry;
-		}
-
 		/* don't write here until the bad block is acknowledged */
 		if (test_bit(WriteErrorSeen, &rdev->flags) &&
 		    rdev_has_badblock(rdev, bio->bi_iter.bi_sector,
-				      bio_sectors(bio)) < 0) {
+				      bio_sectors(bio)) < 0)
+			set_bit(BlockedBadBlocks, &rdev->flags);
+
+		if (rdev_blocked(rdev)) {
 			if (bio->bi_opf & REQ_NOWAIT)
 				return false;
 
-			set_bit(BlockedBadBlocks, &rdev->flags);
 			mddev_add_trace_msg(rdev->mddev, "raid1 wait rdev %d blocked",
 					    rdev->raid_disk);
 			atomic_inc(&rdev->nr_pending);
-- 
2.39.2

