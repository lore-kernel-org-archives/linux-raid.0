Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DDB1E47C7;
	Sat, 24 May 2025 06:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067503; cv=none; b=jrCw4p4mlNsQCnqqZxHvXye3F7DIBycEtULYOf0LJ0QJdj9mKWSb4tre26oR70EgvTbmHGVIO9p7B+xSEp8ONvDaVNy1vQ1yoLlnlkhBDLFjtTdhZe8tB5i1xB3lSXPEWzcJDL2Fu4jY/edX3o4uRmaZi7UAIioWlupB9AsfR2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067503; c=relaxed/simple;
	bh=k7JnBaIBLvh65ae499oAtO5YwWOn3daSEnUXUMRBkXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I8Np4yahNc789VK/CTZAHPo1sB1I8tN1uvXZxQ3l/h5Jq3uyimn1sWFWpq3HL8M03o5iIudmMmak/AYFfAEhkePPx9uegB9L36301CWn+ajfpjilb/XHeNjI4F4vEQnDkI4AsS6iaa0WRoYNVFpdyYnQfOP24g3+JBRFqIjQv5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4b4Bf92PsZz4f3jJG;
	Sat, 24 May 2025 14:17:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 77A831A018D;
	Sat, 24 May 2025 14:18:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S18;
	Sat, 24 May 2025 14:18:18 +0800 (CST)
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
Subject: [PATCH 14/23] md/dm-raid: remove max_write_behind setting limit
Date: Sat, 24 May 2025 14:13:11 +0800
Message-Id: <20250524061320.370630-15-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S18
X-Coremail-Antispam: 1UD129KBjvJXoWxWFW5Cr48KF4UZF4xXrWkZwb_yoW5Gr17pr
	W7GrWSkF13JF47Wr15Xw18Za4Yq3srtr9xKFWfu34ruFyUXrn3Xr48ua1Yvr10gFWrJF90
	qF15K34kWFy7GaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The comments said 'vaule in kB', while the value actually means the
number of write_behind IOs. And since md-bitmap will automatically
adjust the value to max COUNTER_MAX / 2, there is no need to fail
early.

Also move some macros that is only used md-bitmap.c.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c   |  6 +-----
 drivers/md/md-bitmap.c | 10 ++++++++++
 drivers/md/md-bitmap.h |  9 ---------
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 088cfe6e0f98..9757c32ea1f5 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1356,11 +1356,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 				return -EINVAL;
 			}
 
-			/*
-			 * In device-mapper, we specify things in sectors, but
-			 * MD records this value in kB
-			 */
-			if (value < 0 || value / 2 > COUNTER_MAX) {
+			if (value < 0) {
 				rs->ti->error = "Max write-behind limit out of range";
 				return -EINVAL;
 			}
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 535bc1888e8c..098e7b6cd187 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -98,9 +98,19 @@
  *
  */
 
+typedef __u16 bitmap_counter_t;
+
 #define PAGE_BITS (PAGE_SIZE << 3)
 #define PAGE_BIT_SHIFT (PAGE_SHIFT + 3)
 
+#define COUNTER_BITS 16
+#define COUNTER_BIT_SHIFT 4
+#define COUNTER_BYTE_SHIFT (COUNTER_BIT_SHIFT - 3)
+
+#define NEEDED_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 1)))
+#define RESYNC_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 2)))
+#define COUNTER_MAX ((bitmap_counter_t) RESYNC_MASK - 1)
+
 #define NEEDED(x) (((bitmap_counter_t) x) & NEEDED_MASK)
 #define RESYNC(x) (((bitmap_counter_t) x) & RESYNC_MASK)
 #define COUNTER(x) (((bitmap_counter_t) x) & COUNTER_MAX)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index d2cdf831ef1a..a9a0f6a8d96d 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -9,15 +9,6 @@
 
 #define BITMAP_MAGIC 0x6d746962
 
-typedef __u16 bitmap_counter_t;
-#define COUNTER_BITS 16
-#define COUNTER_BIT_SHIFT 4
-#define COUNTER_BYTE_SHIFT (COUNTER_BIT_SHIFT - 3)
-
-#define NEEDED_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 1)))
-#define RESYNC_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 2)))
-#define COUNTER_MAX ((bitmap_counter_t) RESYNC_MASK - 1)
-
 /*
  * version 3 is host-endian order, this is deprecated and not used for new
  * array
-- 
2.39.2

