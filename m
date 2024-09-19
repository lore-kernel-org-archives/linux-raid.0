Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7902E7345B;
	Thu, 19 Sep 2024 06:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726727608; cv=none; b=FGxxVO+Yv6/Aq2puteI5mrWyVuDljE0OJR8mzJX4wbS5bgwVdF+e7ObSJXdHDDbuoPOYXbmgHQlZLEF0+aab1wlOZ/VkN60S9PkNB54iMxA4uPNRwcbvkcCOPdsdQTqGpWRpq4xy6FFnCpL+czFNAkYWe7FLbiOC/TrDY27xpWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726727608; c=relaxed/simple;
	bh=/qOykdb7Slk9hqgZWIdmfjaTAxzZPv9Pt5wMu3ABVM8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=thoHm7y2jrrQOvLWMxHLnxaf1mU5ywo+d5RMEP3Z4yIjDE0kYzQw0/zcfYiyk4E1RyfExAbUPgGUJpdjnViXpxd/75J3VtcSEmhVQ5G7spBqozFUDRjKPxInFUU/NSzNNa6DleMJ+qTJKRyhHLHFGdWJ6nQ1n9/QnNq/4P5DoU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4X8Qgb2vKqz4f3jJ3;
	Thu, 19 Sep 2024 14:32:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 472871A092F;
	Thu, 19 Sep 2024 14:33:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAnXMipxetm9E31Bg--.40694S4;
	Thu, 19 Sep 2024 14:33:15 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yi.zhang@huawei.com,
	houtao1@huawei.com,
	yangerkun@huawei.com,
	zhangxiaoxu5@huawei.com
Subject: [PATCH] md: ensure child flush IO does not affect origin bio->bi_status
Date: Thu, 19 Sep 2024 14:30:48 +0800
Message-Id: <20240919063048.2887579-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnXMipxetm9E31Bg--.40694S4
X-Coremail-Antispam: 1UD129KBjvJXoW7urWfWFy8uFyfAr47JrW8WFg_yoW8uF48pa
	yfW3Z8J398Ja1IvanxZrZrGa4Yqws7KFWqyFy3C34fZF13CFn8Ka1aq340vF98GF4furZr
	Jw1jyw4UuayUAFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9m14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I
	8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AK
	xVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcV
	AFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8I
	cIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r
	1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUBrWrUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

When a flush is issued to an RAID array, a child flush IO is created and
issued for each member disk in the RAID array. Since commit b75197e86e6d
("md: Remove flush handling"), each child flush IO has been chained with
the original bio. As a result, the failure of any child IO could modify
the bi_status of the original bio, potentially impacting the upper-layer
filesystem.

Fix the issue by preventing child flush IO from altering the original
bio->bi_status as before. However, this design introduces a known
issue: in the event of a power failure, if a flush IO on a member
disk fails, the upper layers may not be informed. This issue is not easy
to fix and will not be addressed for the time being in this issue.

Fixes: b75197e86e6d ("md: Remove flush handling")
Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 179ee4afe937..67108c397c5a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -546,6 +546,26 @@ static int mddev_set_closing_and_sync_blockdev(struct mddev *mddev, int opener_n
 	return 0;
 }
 
+/*
+ * The only difference from bio_chain_endio() is that the current
+ * bi_status of bio does not affect the bi_status of parent.
+ */
+static void md_end_flush(struct bio *bio)
+{
+	struct bio *parent = bio->bi_private;
+
+	/*
+	 * If any flush io error before the power failure,
+	 * disk data may be lost.
+	 */
+	if (bio->bi_status)
+		pr_err("md: %pg flush io error %d\n", bio->bi_bdev,
+			blk_status_to_errno(bio->bi_status));
+
+	bio_put(bio);
+	bio_endio(parent);
+}
+
 bool md_flush_request(struct mddev *mddev, struct bio *bio)
 {
 	struct md_rdev *rdev;
@@ -565,7 +585,9 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
 		new = bio_alloc_bioset(rdev->bdev, 0,
 				       REQ_OP_WRITE | REQ_PREFLUSH, GFP_NOIO,
 				       &mddev->bio_set);
-		bio_chain(new, bio);
+		new->bi_private = bio;
+		new->bi_end_io = md_end_flush;
+		bio_inc_remaining(bio);
 		submit_bio(new);
 	}
 
-- 
2.39.2

