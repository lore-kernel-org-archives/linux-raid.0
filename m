Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6858A19D8BE;
	Sat, 15 Feb 2025 09:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739611560; cv=none; b=G1UCdyKxOyMboG63W+WghDENhLRnYZQE/g4C3m32IYtYkuCnAyg9y9teZ3u/i9+0WGeaayCf76yPT2DCBxS1pXKRkFJjnz5Onsyb4h5aKJUrI3tardq+ToHHRZh8yfIVR0jLOs/Ti+InXd2+gX7ekUpch4NntjbOdrZL/XhUV/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739611560; c=relaxed/simple;
	bh=kcvOgn+mw0xs8yYFjhK666hJBX4uW9SzKE/d5UQGLM0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f5U+2c3jH6ipS87aLut69ZlcdA6/VzcNFZmaevl2JFumu8DAamjROglkowLnoKMLs2D9oEU9PsHJtNicGDMp2V3ohB7QTQ+vQGvyT6FAUnN7AxMOrwI/jZB6Mo5d8eW2mhvGmDH/KMtfHqajaoBoeshisF7pgcmxmOGS+bDnXNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Yw3Rr4ZQZz4f3jY3;
	Sat, 15 Feb 2025 17:25:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 19EAB1A06D7;
	Sat, 15 Feb 2025 17:25:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAni1+bXbBn+Q+iDw--.49525S6;
	Sat, 15 Feb 2025 17:25:49 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.15 2/7] md: only include md-cluster.h if necessary
Date: Sat, 15 Feb 2025 17:22:20 +0800
Message-Id: <20250215092225.2427977-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
References: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAni1+bXbBn+Q+iDw--.49525S6
X-Coremail-Antispam: 1UD129KBjvJXoWxXF43Jr48ZFy3Xry5Ar45trb_yoWrGrWUpa
	1q934rC3y5JrWUWw1DAFyDua45Ka4kKrWvkryxC39avF9IgFWDJFs8KFZ8Ar1DGFW3JFnI
	q3WUKa98urn5XrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBG14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAVWUtw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUFoGdUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

md-cluster is only supportted by raid1 and raid10, there is no need to
include md-cluster.h for other personalities.

Also move APIs that is only used in md-cluster.c from md.h to
md-cluster.h.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  | 2 ++
 drivers/md/md-cluster.h | 7 +++++++
 drivers/md/md.h         | 7 -------
 drivers/md/raid1.c      | 1 +
 drivers/md/raid10.c     | 1 +
 5 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 23c09d22fcdb..71aa7dc80e26 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -29,8 +29,10 @@
 #include <linux/buffer_head.h>
 #include <linux/seq_file.h>
 #include <trace/events/block.h>
+
 #include "md.h"
 #include "md-bitmap.h"
+#include "md-cluster.h"
 
 #define BITMAP_MAJOR_LO 3
 /* version 4 insists the bitmap is in little-endian order
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index 470bf18ffde5..6c7aad00f5da 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -35,4 +35,11 @@ struct md_cluster_operations {
 	void (*update_size)(struct mddev *mddev, sector_t old_dev_sectors);
 };
 
+extern int register_md_cluster_operations(const struct md_cluster_operations *ops,
+		struct module *module);
+extern int unregister_md_cluster_operations(void);
+extern int md_setup_cluster(struct mddev *mddev, int nodes);
+extern void md_cluster_stop(struct mddev *mddev);
+extern void md_reload_sb(struct mddev *mddev, int raid_disk);
+
 #endif /* _MD_CLUSTER_H */
diff --git a/drivers/md/md.h b/drivers/md/md.h
index def808064ad8..c9bc70e6d5b4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -19,7 +19,6 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <trace/events/block.h>
-#include "md-cluster.h"
 
 #define MaxSector (~(sector_t)0)
 
@@ -845,11 +844,6 @@ static inline void safe_put_page(struct page *p)
 
 extern int register_md_personality(struct md_personality *p);
 extern int unregister_md_personality(struct md_personality *p);
-extern int register_md_cluster_operations(const struct md_cluster_operations *ops,
-		struct module *module);
-extern int unregister_md_cluster_operations(void);
-extern int md_setup_cluster(struct mddev *mddev, int nodes);
-extern void md_cluster_stop(struct mddev *mddev);
 extern struct md_thread *md_register_thread(
 	void (*run)(struct md_thread *thread),
 	struct mddev *mddev,
@@ -906,7 +900,6 @@ extern void md_idle_sync_thread(struct mddev *mddev);
 extern void md_frozen_sync_thread(struct mddev *mddev);
 extern void md_unfrozen_sync_thread(struct mddev *mddev);
 
-extern void md_reload_sb(struct mddev *mddev, int raid_disk);
 extern void md_update_sb(struct mddev *mddev, int force);
 extern void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev);
 extern void mddev_destroy_serial_pool(struct mddev *mddev,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9d57a88dbd26..e55db07e43d4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -36,6 +36,7 @@
 #include "md.h"
 #include "raid1.h"
 #include "md-bitmap.h"
+#include "md-cluster.h"
 
 #define UNSUPPORTED_MDDEV_FLAGS		\
 	((1L << MD_HAS_JOURNAL) |	\
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index efe93b979167..3df39b2399b2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -24,6 +24,7 @@
 #include "raid10.h"
 #include "raid0.h"
 #include "md-bitmap.h"
+#include "md-cluster.h"
 
 /*
  * RAID10 provides a combination of RAID0 and RAID1 functionality.
-- 
2.39.2

