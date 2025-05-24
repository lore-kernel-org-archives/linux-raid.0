Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665721A265E;
	Sat, 24 May 2025 06:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067499; cv=none; b=HQrX7A/iNaQPlTv219vXe7bhseUv5fltMXmR3ZhOIUDdUxXCHacsrcMoe4edsfVoVQ0O8iF9wP7boZRSPEqf/1FQFoWmql4nm7u/0yKh2VA3wLllneKYnEkFBIulo/U8FM/nP1LrZjwhg+ENCm6glmt5E+W5yDbeHiutBTNk/OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067499; c=relaxed/simple;
	bh=5yuC0RFALU4ynBSU7b5EZi4+oIyvCAXeBvL/+24D3Hk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HuQSdL9qMjhP0F8A/Zb+N3DsAWxUFEt0udQr1vExZDUlcDRJulogQ1zTPUUc89v5x6taOEEsv/yXzGl8ghsTblGfaa3V1vJs08dyzrJRvcbNZeiZfJBaexkvS+JRvH7kRiDA02wLqY3BM2AYNztnrYAeZewpWg0et0Na/Ob4qII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4b4Bfc6qP8zKHMZw;
	Sat, 24 May 2025 14:18:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6DBC81A018D;
	Sat, 24 May 2025 14:18:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S12;
	Sat, 24 May 2025 14:18:15 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH 08/23] md/md-bitmap: add a new method skip_sync_blocks() in bitmap_operations
Date: Sat, 24 May 2025 14:13:05 +0800
Message-Id: <20250524061320.370630-9-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250524061320.370630-1-yukuai1@huaweicloud.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S12
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw4rZw15uw4rWr4rXrWrKrg_yoW8Aw1xpa
	97JFy3C3y5Xr4Yq3W7XFyDuFyFv34ktFy7tFy7u34rWr97JrnrGF45Wa4qqa4DGF13AFZx
	Z3W5JrWrZF1Iqr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

This method is used to check if blocks can be skipped before calling
into pers->sync_request(), llbiltmap will use this method to skip
resync for unwritten/clean data blocks, and recovery/check/repair for
unwritten data blocks;

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md-bitmap.h | 1 +
 drivers/md/md.c        | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 2b99ddef7a41..0de14d475ad3 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -98,6 +98,7 @@ struct bitmap_operations {
 	md_bitmap_fn *start_discard;
 	md_bitmap_fn *end_discard;
 
+	sector_t (*skip_sync_blocks)(struct mddev *mddev, sector_t offset);
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index dc4b85f30e13..890c8da43b3b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9362,6 +9362,12 @@ void md_do_sync(struct md_thread *thread)
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			break;
 
+		if (mddev->bitmap_ops && mddev->bitmap_ops->skip_sync_blocks) {
+			sectors = mddev->bitmap_ops->skip_sync_blocks(mddev, j);
+			if (sectors)
+				goto update;
+		}
+
 		sectors = mddev->pers->sync_request(mddev, j, max_sectors,
 						    &skipped);
 		if (sectors == 0) {
@@ -9377,6 +9383,7 @@ void md_do_sync(struct md_thread *thread)
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			break;
 
+update:
 		j += sectors;
 		if (j > max_sectors)
 			/* when skipping, extra large numbers can be returned. */
-- 
2.39.2

