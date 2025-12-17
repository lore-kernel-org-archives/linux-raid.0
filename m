Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC673328B7D;
	Wed, 17 Dec 2025 12:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765973480; cv=none; b=rLEqCYwiLkGBNcG/aFT5RbvJR+MOZvnd8lwIlJIt0Aw1WmY+pYEP0jxk7t/vXQoIoVymJihqx1YahM5fRmhyef/Tje8zQiyMZn6Tfi2Dh5b2qjz5hhrSe8ERmRzzljMx/umgWg/+uYOmfjGviQg1YdNRTnesHg1jq+ODATCDs+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765973480; c=relaxed/simple;
	bh=vxJQfsEHOgj15WJX57QttQUdcA7U3E5FweBDf6WQcZE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YAkzx2EN1ajcFtvdEobaLIVnTQd/4S0lI4k0365ZIKYJ5p2/t5hfRGBZOgw/FY55kI605Dnaoims6cMKX2iXqyW8cNSDn+8EU7ElYFHpYrkmwyc0LNZkrnY/g3wd3xk2m0culQsqiNlVIftUrMpGUSKZiTNOYygWuOnq5abcVO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dWXh51JqmzKHN3L;
	Wed, 17 Dec 2025 20:11:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4456640590;
	Wed, 17 Dec 2025 20:11:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_fdnUJp6F0JAg--.52527S6;
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
Subject: [PATCH 02/15] md: introduce sync_folio_io for folio support in RAID
Date: Wed, 17 Dec 2025 20:00:00 +0800
Message-Id: <20251217120013.2616531-3-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXd_fdnUJp6F0JAg--.52527S6
X-Coremail-Antispam: 1UD129KBjvJXoWxXw4DXF1xCF4UCF4xJFWfGrg_yoW5Gr1fpa
	40kasxG3y5Zw42gw13JFs7Ca4Sq34IgrWUtryfuayfW3W7KryDKF4UtF1jvF98GF98CF4x
	t34jgay5urn5Wr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmC14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
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
	Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUFD73UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Prepare for folio support in RAID by introducing sync_folio_io(),
matching sync_page_io()'s functionality. Differences are:

- Replace input parameter 'page' with 'folio'
- Replace __bio_add_page() calls with bio_add_folio_nofail()
- Add new parameter 'off' to prepare for adding a folio to bio in segments,
  e.g. in fix_recovery_read_error()

sync_page_io() will be removed once full folio support is complete.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.h |  2 ++
 drivers/md/md.c | 27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index a083f37374d0..410f8a6b75e7 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -920,6 +920,8 @@ void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
 extern int md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		struct page *page, blk_opf_t opf, bool metadata_op);
+extern int sync_folio_io(struct md_rdev *rdev, sector_t sector, int size,
+		int off, struct folio *folio, blk_opf_t opf, bool metadata_op);
 extern void md_do_sync(struct md_thread *thread);
 extern void md_new_event(void);
 extern void md_allow_write(struct mddev *mddev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index cde84c9f05eb..9dfd6f8da5b8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1192,6 +1192,33 @@ int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 }
 EXPORT_SYMBOL_GPL(sync_page_io);
 
+int sync_folio_io(struct md_rdev *rdev, sector_t sector, int size, int off,
+		  struct folio *folio, blk_opf_t opf, bool metadata_op)
+{
+	struct bio bio;
+	struct bio_vec bvec;
+
+	if (metadata_op && rdev->meta_bdev)
+		bio_init(&bio, rdev->meta_bdev, &bvec, 1, opf);
+	else
+		bio_init(&bio, rdev->bdev, &bvec, 1, opf);
+
+	if (metadata_op)
+		bio.bi_iter.bi_sector = sector + rdev->sb_start;
+	else if (rdev->mddev->reshape_position != MaxSector &&
+		 (rdev->mddev->reshape_backwards ==
+		  (sector >= rdev->mddev->reshape_position)))
+		bio.bi_iter.bi_sector = sector + rdev->new_data_offset;
+	else
+		bio.bi_iter.bi_sector = sector + rdev->data_offset;
+	bio_add_folio_nofail(&bio, folio, size, off);
+
+	submit_bio_wait(&bio);
+
+	return !bio.bi_status;
+}
+EXPORT_SYMBOL_GPL(sync_folio_io);
+
 static int read_disk_sb(struct md_rdev *rdev, int size)
 {
 	if (rdev->sb_loaded)
-- 
2.39.2

