Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF5329DB61;
	Wed, 17 Dec 2025 12:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765973475; cv=none; b=VYula+sjZ02Lp+VOEGdN/CXZ1RDc94HHDz9mq+YrioU/+PZEQC9exrb/dmkzAzy33j8NPZrGFWj3dkhOf+tozl1/hLconjzQrcihJLxB1N4VOkkFU0M6zb+D6gySy70XtMvEVWfA5gxVvF65kvrgviuxd7XhDODEOrHxf9HNJ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765973475; c=relaxed/simple;
	bh=2b5c/j00HnDiVyqQ13d12XMbpabeqX+G9Qgg8I9MUbY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E8xLuzGun8Tp0mIMx2w6WtzgrZ5w4arjWjs3NnfUb7jJlrGZEeFCFniiM/h6dEYxQZNSRT/Is837lBdSIX0d7383MGP4YAiOI+CHTBKGr3Rk+s84wFFEaa2FEgpAtvmCJDRHeOw50HRz1uBUe8ojP/td+RaRNutvjzXRQKxARd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dWXgl3NG2zYQvGF;
	Wed, 17 Dec 2025 20:10:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 511A340575;
	Wed, 17 Dec 2025 20:11:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_fdnUJp6F0JAg--.52527S7;
	Wed, 17 Dec 2025 20:11:10 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xni@redhat.com,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH 03/15] md: use folio for bb_folio
Date: Wed, 17 Dec 2025 20:00:01 +0800
Message-Id: <20251217120013.2616531-4-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251217120013.2616531-1-linan666@huaweicloud.com>
References: <20251217120013.2616531-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXd_fdnUJp6F0JAg--.52527S7
X-Coremail-Antispam: 1UD129KBjvJXoWxWFy8tryfWF17uF4fKrW3ZFb_yoW5ZF4fpa
	ykWasxtr45Jr1jqwsrGFWvkasYv3sxKFW8trWayw13X3W3tw15KF1UtFy7Zr98AF9xAF4k
	Zw4UCrWUu3WIgr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmC14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2Iq
	xVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r
	106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AK
	xVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7
	xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_
	Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUB89NUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Convert bio_page to bio_folio and use it throughout.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.h |  3 ++-
 drivers/md/md.c | 25 +++++++++++++------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 410f8a6b75e7..aa6d9df50fd0 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -144,7 +144,8 @@ struct md_rdev {
 	struct block_device *bdev;	/* block device handle */
 	struct file *bdev_file;		/* Handle from open for bdev */
 
-	struct page	*sb_page, *bb_page;
+	struct page	*sb_page;
+	struct folio	*bb_folio;
 	int		sb_loaded;
 	__u64		sb_events;
 	sector_t	data_offset;	/* start of data in array */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9dfd6f8da5b8..0732bbcdb95d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1073,9 +1073,9 @@ void md_rdev_clear(struct md_rdev *rdev)
 		rdev->sb_start = 0;
 		rdev->sectors = 0;
 	}
-	if (rdev->bb_page) {
-		put_page(rdev->bb_page);
-		rdev->bb_page = NULL;
+	if (rdev->bb_folio) {
+		folio_put(rdev->bb_folio);
+		rdev->bb_folio = NULL;
 	}
 	badblocks_exit(&rdev->badblocks);
 }
@@ -1909,9 +1909,10 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 
 	rdev->desc_nr = le32_to_cpu(sb->dev_number);
 
-	if (!rdev->bb_page) {
-		rdev->bb_page = alloc_page(GFP_KERNEL);
-		if (!rdev->bb_page)
+	if (!rdev->bb_folio) {
+		rdev->bb_folio = folio_alloc(GFP_KERNEL, 0);
+
+		if (!rdev->bb_folio)
 			return -ENOMEM;
 	}
 	if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BAD_BLOCKS) &&
@@ -1930,10 +1931,10 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		if (offset == 0)
 			return -EINVAL;
 		bb_sector = (long long)offset;
-		if (!sync_page_io(rdev, bb_sector, sectors << 9,
-				  rdev->bb_page, REQ_OP_READ, true))
+		if (!sync_folio_io(rdev, bb_sector, sectors << 9, 0,
+				  rdev->bb_folio, REQ_OP_READ, true))
 			return -EIO;
-		bbp = (__le64 *)page_address(rdev->bb_page);
+		bbp = (__le64 *)folio_address(rdev->bb_folio);
 		rdev->badblocks.shift = sb->bblog_shift;
 		for (i = 0 ; i < (sectors << (9-3)) ; i++, bbp++) {
 			u64 bb = le64_to_cpu(*bbp);
@@ -2300,7 +2301,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 		md_error(mddev, rdev);
 	else {
 		struct badblocks *bb = &rdev->badblocks;
-		__le64 *bbp = (__le64 *)page_address(rdev->bb_page);
+		__le64 *bbp = (__le64 *)folio_address(rdev->bb_folio);
 		u64 *p = bb->page;
 		sb->feature_map |= cpu_to_le32(MD_FEATURE_BAD_BLOCKS);
 		if (bb->changed) {
@@ -2953,7 +2954,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 				md_write_metadata(mddev, rdev,
 						  rdev->badblocks.sector,
 						  rdev->badblocks.size << 9,
-						  rdev->bb_page, 0);
+						  folio_page(rdev->bb_folio, 0), 0);
 				rdev->badblocks.size = 0;
 			}
 
@@ -3809,7 +3810,7 @@ int md_rdev_init(struct md_rdev *rdev)
 	rdev->sb_events = 0;
 	rdev->last_read_error = 0;
 	rdev->sb_loaded = 0;
-	rdev->bb_page = NULL;
+	rdev->bb_folio = NULL;
 	atomic_set(&rdev->nr_pending, 0);
 	atomic_set(&rdev->read_errors, 0);
 	atomic_set(&rdev->corrected_errors, 0);
-- 
2.39.2

