Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D696FC0A;
	Fri, 11 Oct 2024 01:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609513; cv=none; b=CP52wwZhFJbzft44geazRJI5pa1OqTj9zBCDI1xdzxxAU0buTN9o305cyPmmHXUDRaUfTaali8yze5Q/2TLfTb9sdzSVdH+w2uWnlQuY0llk5u5UZ2o11LqgFhoO1wmZzMqKRhBmMVoLcOeAOUaUrvj/4wWK6KN+gyQEUE8DL/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609513; c=relaxed/simple;
	bh=jJBUs/Bj7wU8XcO9hUGjCP3aHabh74sFA11gyKy5Nys=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PRMtcxnsL4xJYexTIxKz+LHhORRoHCsj0ucEH5o/cTwBxcPX7YA8xl+nka6lb4pj6FbkuLu63OOsdaaJb2llGulWj6I+S7fqhtau1SL2ALGr0NbgMjW6Ajv5RVZp8n5vMvlGln25r8CJmAPKa+lfVmHBHgjlNuNOtyWKH6NYHU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XPpfJ4XCSz4f3jkM;
	Fri, 11 Oct 2024 09:18:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 757EE1A092F;
	Fri, 11 Oct 2024 09:18:28 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDH+sbefAhnm9MFDw--.55490S9;
	Fri, 11 Oct 2024 09:18:28 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@intel.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 5/7] md/raid1: don't wait for Faulty rdev in wait_blocked_rdev()
Date: Fri, 11 Oct 2024 09:16:28 +0800
Message-Id: <20241011011630.2002803-6-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241011011630.2002803-1-yukuai1@huaweicloud.com>
References: <20241011011630.2002803-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDH+sbefAhnm9MFDw--.55490S9
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw1UWry8ZFyftFy3Gw1rZwb_yoW8Gw1fpa
	n3uFySqrWUCw1UXFnFkFy8AFyYqa1UKayIkrW2y3W8Xay3Ar95Jw40vas3JrykArZIvrZ8
	XF13W3y8Ca45uF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
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
index 1679c1e9b3d5..cd3e94dceabc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1425,25 +1425,16 @@ static bool wait_blocked_rdev(struct mddev *mddev, struct bio *bio)
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

