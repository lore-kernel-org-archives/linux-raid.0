Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDDA1E5711;
	Sat, 24 May 2025 06:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067504; cv=none; b=MOLjeJWTTvuIll8LcNgDLxwhEYcCZrXqI1ZRTT5P9TdVnGXc9zB9qEHMWDHSomlbzAHvtdfrdVhUVDT8WJSEG/b44gxeOzgv57cGVsS0Mk/1bTMKWLnZo3gAxjPZ9zTAMCQFgsb7jCLhmgsKpjZChzxNUs1f4kjXFE92KRB5a+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067504; c=relaxed/simple;
	bh=o8zqeosfdRUrjMknHUDsgW0jqq1gEF4Dv7+TYluWojk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=K4PJnmmGNi56jBWZC9z0YbVpXAMEff4odFu9pj0+TYacIV/aHB5g/bjA6DHp7FTxGH9r2sDCrdxOKsaGOEZkRs9AcaFokJUB7lhzYCUy5cOTRjAS8LYnIueunX/3pqhT+n3ltrfySdYo/zhGxrQYoFRtoEhM1jh+ul0PIB+Y/Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4b4Bf65SgJz4f3jMQ;
	Sat, 24 May 2025 14:17:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 690C71A140E;
	Sat, 24 May 2025 14:18:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S16;
	Sat, 24 May 2025 14:18:17 +0800 (CST)
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
Subject: [PATCH 12/23] md/md-bitmap: add macros for lockless bitmap
Date: Sat, 24 May 2025 14:13:09 +0800
Message-Id: <20250524061320.370630-13-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S16
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF13JFy8trW5AFyftw1DZFb_yoW8uFyDpF
	92qr9akr13JFsrXr18Ja47ua45J3s2yrZxKryku3yrCFyYvrW3Ary8W3W7J34kWF1fJFZI
	gF15K3s5W3srurJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Also move other values to md-bitmap.h and update comments.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  9 ---------
 drivers/md/md-bitmap.h | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 17d41a7b30ce..689d5dba9328 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -36,15 +36,6 @@
 #include "md-bitmap.h"
 #include "md-cluster.h"
 
-#define BITMAP_MAJOR_LO 3
-/* version 4 insists the bitmap is in little-endian order
- * with version 3, it is host-endian which is non-portable
- * Version 5 is currently set only for clustered devices
- */
-#define BITMAP_MAJOR_HI 4
-#define BITMAP_MAJOR_CLUSTERED 5
-#define	BITMAP_MAJOR_HOSTENDIAN 3
-
 /*
  * in-memory bitmap:
  *
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index f2d79c8a23b7..d2cdf831ef1a 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -18,10 +18,27 @@ typedef __u16 bitmap_counter_t;
 #define RESYNC_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 2)))
 #define COUNTER_MAX ((bitmap_counter_t) RESYNC_MASK - 1)
 
+/*
+ * version 3 is host-endian order, this is deprecated and not used for new
+ * array
+ */
+#define BITMAP_MAJOR_LO		3
+#define BITMAP_MAJOR_HOSTENDIAN	3
+/* version 4 is little-endian order, the default value */
+#define BITMAP_MAJOR_HI		4
+/* version 5 is only used for cluster */
+#define BITMAP_MAJOR_CLUSTERED	5
+/* version 6 is only used for lockless bitmap */
+#define BITMAP_MAJOR_LOCKLESS	6
+
+#define BITMAP_SB_SIZE 1024
 /* use these for bitmap->flags and bitmap->sb->state bit-fields */
 enum bitmap_state {
 	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
 	BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
+	BITMAP_FIRST_USE   = 3, /* llbitmap is just created */
+	BITMAP_CLEAN       = 4, /* llbitmap is created with assume_clean */
+	BITMAP_DAEMON_BUSY = 5, /* llbitmap daemon is not finished after daemon_sleep */
 	BITMAP_HOSTENDIAN  =15,
 };
 
-- 
2.39.2

