Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F6C12BF25;
	Mon, 26 Aug 2024 07:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658594; cv=none; b=p0fKqyUf0MoCMRe27BqE7FSGeOIsJ1n7Z5xhPUvdEC31X+gxenSgqPkCCrD/Xojop+ANjbCGMo2CpqkxA3azHju4V6pYFYWPtdGBFJk9KHYt8EIJ6GQAHnfurzmLmkx97vrLr6o7/6x1rBNCRlcLnlBam6PbTeyjZDINn9o5hXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658594; c=relaxed/simple;
	bh=J6v9P0EU3M+frZynsCXcWjh9GnMMBPDmFp13MhC+qWQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XFnl0dQUWMOmBaMrasvOJgMGXIc4DOwEdlo5kObCKHBwfv++KBEOttjE5u6x9Dm+TyzFvkBncy03uUjpbWXw7bHK/oFrQLNuZwAnB/D1VtVyG47C1QSFfTECD78KN034trZ6/ehztKiZ/yp/iqUY+ytZe3TcASeqmkbpTFEWRdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsjW70sYfz4f3jZ1;
	Mon, 26 Aug 2024 15:49:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F34A91A018D;
	Mon, 26 Aug 2024 15:49:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S5;
	Mon, 26 Aug 2024 15:49:48 +0800 (CST)
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
Subject: [PATCH md-6.12 v2 01/42] md/raid1: use md_bitmap_wait_behind_writes() in raid1_read_request()
Date: Mon, 26 Aug 2024 15:44:11 +0800
Message-Id: <20240826074452.1490072-2-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S5
X-Coremail-Antispam: 1UD129KBjvJXoW7tF4rtF1fCr4UZrWDXF48Crg_yoW8uFykpa
	1qqF98urW5JFW7Xr1DAFWkCFy3t3WDKFZrtryfG34ruFy2vF98WF4rKayUGwn8Ca1fAF4Y
	v3WFyryDuF1FqFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBG14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtVW8Zw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUqkskUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Use the existed helper instead of open coding it to make the code cleaner.
There are no functional changes, and also avoid dereferencing bitmap
directly to prepare inventing a new bitmap.

Noted that this patch also export md_bitmap_wait_behind_writes(), which
is necessary for now, and the exported api will be removed in following
patches to convert bitmap apis into ops.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 1 +
 drivers/md/raid1.c     | 7 ++-----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 08232d8dc815..08743dcc70f1 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1851,6 +1851,7 @@ void md_bitmap_wait_behind_writes(struct mddev *mddev)
 			   atomic_read(&bitmap->behind_writes) == 0);
 	}
 }
+EXPORT_SYMBOL_GPL(md_bitmap_wait_behind_writes);
 
 void md_bitmap_destroy(struct mddev *mddev)
 {
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7acfe7c9dc8d..81fc100e7830 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1311,7 +1311,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	struct r1conf *conf = mddev->private;
 	struct raid1_info *mirror;
 	struct bio *read_bio;
-	struct bitmap *bitmap = mddev->bitmap;
 	const enum req_op op = bio_op(bio);
 	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	int max_sectors;
@@ -1377,15 +1376,13 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 				    (unsigned long long)r1_bio->sector,
 				    mirror->rdev->bdev);
 
-	if (test_bit(WriteMostly, &mirror->rdev->flags) &&
-	    bitmap) {
+	if (test_bit(WriteMostly, &mirror->rdev->flags)) {
 		/*
 		 * Reading from a write-mostly device must take care not to
 		 * over-take any writes that are 'behind'
 		 */
 		mddev_add_trace_msg(mddev, "raid1 wait behind writes");
-		wait_event(bitmap->behind_wait,
-			   atomic_read(&bitmap->behind_writes) == 0);
+		md_bitmap_wait_behind_writes(mddev);
 	}
 
 	if (max_sectors < bio_sectors(bio)) {
-- 
2.39.2

