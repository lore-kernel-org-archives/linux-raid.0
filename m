Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505CF11CAF;
	Thu, 16 Apr 2026 03:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776311431; cv=none; b=RaXgayMmGUACzmgNWaw5oeZpaVPqU0Ezyan/mjm8wwlcpW5SHyuweKdWJ+qx786xpDOz7/pO+s40syCJKC/IPj6yhkd0F+sePbdgTSInbQqXOrBn1Pm7y5ATTS3UQWT48Hb0sXdd/Y+vv4cgUJs6F+WiM+M+8r9SySy9nNIe1rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776311431; c=relaxed/simple;
	bh=R2tyHLp6J2xwUeS9jiR2tmKGSFUduCnm46Hm3uZSVR8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YGeLFYfyky6CjrurdsBTDGZOER6+mklBJlXouspnk0WMsdPRRq36WgfGTe7TlQjvlatAKZBkzOgH7hUCH747em0Z358V2NVpZ6GAK1hrCImIi3sczsPq7mo6O7z9TkoHcllRyaapXX5u1vgjr1lqwgJsWmFVek7Qm8y3a1dVNlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fx3tC70QPzYQtM4;
	Thu, 16 Apr 2026 11:49:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 169CA4058D;
	Thu, 16 Apr 2026 11:50:27 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP3 (Coremail) with SMTP id _Ch0CgCHM72BXOBpn95JAg--.61021S6;
	Thu, 16 Apr 2026 11:50:26 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 2/8] md: introduce sync_folio_io for folio support in RAID
Date: Thu, 16 Apr 2026 11:37:55 +0800
Message-Id: <20260416033801.786415-3-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260416033801.786415-1-linan666@huaweicloud.com>
References: <20260416033801.786415-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCHM72BXOBpn95JAg--.61021S6
X-Coremail-Antispam: 1UD129KBjvJXoWxXw4kKry5Jry7Cr18Cw1rWFg_yoW5XF13pa
	yjka43C3y5WrW7Ww1UXFs7ua4rt34SgrWUtry3u34fXF18KryqkF1UtFyjvFn8GF98Grnr
	t34UKFW5u3Z5JrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmG14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2vY
	z4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvj
	eVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I
	1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8
	JrUvcSsGvfC2KfnxnUUI43ZEXa7VUUZjjDUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Prepare for folio support in RAID by introducing sync_folio_io(),
matching sync_page_io()'s functionality. Differences are:

- Add new parameter 'off' to prepare for adding a folio to bio in segments,
  e.g. in fix_recovery_read_error()
- Change return value to bool
- Replace the checking to 'bio.bi_status == BLK_STS_OK'

sync_page_io() will be removed once full folio support is complete.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.h |  4 +++-
 drivers/md/md.c | 15 +++++++++++----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index ac84289664cd..914b992a073b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -924,8 +924,10 @@ void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
 		       sector_t sector, int size, struct page *page,
 		       unsigned int offset);
 extern int md_super_wait(struct mddev *mddev);
-extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
+extern bool sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		struct page *page, blk_opf_t opf, bool metadata_op);
+extern bool sync_folio_io(struct md_rdev *rdev, sector_t sector, int size,
+		int off, struct folio *folio, blk_opf_t opf, bool metadata_op);
 extern void md_do_sync(struct md_thread *thread);
 extern void md_new_event(void);
 extern void md_allow_write(struct mddev *mddev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d9c9fd2839b3..5e83914d5c14 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1166,8 +1166,8 @@ int md_super_wait(struct mddev *mddev)
 	return 0;
 }
 
-int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
-		 struct page *page, blk_opf_t opf, bool metadata_op)
+bool sync_folio_io(struct md_rdev *rdev, sector_t sector, int size, int off,
+		  struct folio *folio, blk_opf_t opf, bool metadata_op)
 {
 	struct bio bio;
 	struct bio_vec bvec;
@@ -1185,11 +1185,18 @@ int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		bio.bi_iter.bi_sector = sector + rdev->new_data_offset;
 	else
 		bio.bi_iter.bi_sector = sector + rdev->data_offset;
-	__bio_add_page(&bio, page, size, 0);
+	bio_add_folio_nofail(&bio, folio, size, off);
 
 	submit_bio_wait(&bio);
 
-	return !bio.bi_status;
+	return bio.bi_status == BLK_STS_OK;
+}
+EXPORT_SYMBOL_GPL(sync_folio_io);
+
+bool sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
+		 struct page *page, blk_opf_t opf, bool metadata_op)
+{
+	return sync_folio_io(rdev, sector, size, 0, page_folio(page), opf, metadata_op);
 }
 EXPORT_SYMBOL_GPL(sync_page_io);
 
-- 
2.39.2

