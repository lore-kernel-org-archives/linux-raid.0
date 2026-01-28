Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CEF33ADA4;
	Wed, 28 Jan 2026 08:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769587584; cv=none; b=f0H7HKWhO1iI0F81ksq9VLkN+CH792q62m84/41xVrQFQMQAArn2Olkd77pX2GsdbIQ33uktcAe//2Hrb8aFHLBFAzW9MZ5p44q/ns5GiHDUYR638M5ic4jwdSQOUZNj+m8KcjjOkJEP3YUvW70tUvbIGT7MDkzZPHFQfYef8NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769587584; c=relaxed/simple;
	bh=SdcuBczE9qsYacUWY9nQj3tapNX9F04YrXw7xwOJ9L8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k161oajkiZ/NFhG6i6jsvPa/PMJ1/IeSXZRn/6RzMKEtZXXE872b1roO7TjjPzTaGhIFkEjl4FbRkiJjr4q+tgZYNQMialUsa435Si1SKVqZzhh8rtuSuldF1y+lGxokCiwgRcl4JPbWBdHmuhjMo/lKHxOngH+hktsd/ew12P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f1FG16tnlzKHMl0;
	Wed, 28 Jan 2026 16:06:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2A79040592;
	Wed, 28 Jan 2026 16:06:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvd1w3lpPgyWFQ--.43207S6;
	Wed, 28 Jan 2026 16:06:13 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: xni@redhat.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 02/14] md: introduce sync_folio_io for folio support in RAID
Date: Wed, 28 Jan 2026 15:56:56 +0800
Message-Id: <20260128075708.2259525-3-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260128075708.2259525-1-linan666@huaweicloud.com>
References: <20260128075708.2259525-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBnFvd1w3lpPgyWFQ--.43207S6
X-Coremail-Antispam: 1UD129KBjvJXoWxXw4DXF1xCF4UCF4xJFWfGrg_yoW5Gr1fpa
	4jkF9xG3y5Zw42gw13JFs7Ca4Sq34IgrWUtryfuayfW3W7KryDKF45tF1jvF98GF98CF4x
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
index 5df2220b1bd1..b8c8a16cf037 100644
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

