Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0871D63E2;
	Thu, 24 Oct 2024 13:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729775792; cv=none; b=UMORSLENqJyjN0AklDBq9r8NbCjwzcJzvnWZwS8gnjNGomLEmB+DszCtVxvPR31KWoJ5kKWmJ7aKvzRHTTIUcMsEG7X5wStq/LEHLC+jwOVSO7fejAGJBotjOOv3mZyveFxCtdS0cgys6/R6Dc3GqrX3wtv2kErm5hR7TH5Gu38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729775792; c=relaxed/simple;
	bh=zO7RvLBTIs+27nHVUUBcxq6XQclQgiaZKHPEXC0sr1I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EQokvVmPDBqJVPnX6wwZWqsuRqQjaRvjMry5/FWn2daY+cTuiWtDq9l82S8CDA3zSwz3ZK85zuVPcbf6OQ22/d3X0HB8+SkbbQRzcWNsRPXXGvreATMfLcbVarKBrS57RKJ1UyAcoFnJa6h7ONKTJSpkPNVNsBAtRRsvnqe4Ad4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XZ5yN71rCz4f3m86;
	Thu, 24 Oct 2024 21:15:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 59B181A0194;
	Thu, 24 Oct 2024 21:16:09 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCXysaWSBpnPGb6Ew--.10198S7;
	Thu, 24 Oct 2024 21:16:09 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC 3/4] md: export some helpers
Date: Thu, 24 Oct 2024 21:13:24 +0800
Message-Id: <20241024131325.2250880-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241024131325.2250880-1-yukuai1@huaweicloud.com>
References: <20241024131325.2250880-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXysaWSBpnPGb6Ew--.10198S7
X-Coremail-Antispam: 1UD129KBjvJXoWxCF18Wr1kXr4kKrWkWFyDKFg_yoW5Kr47pa
	yIya45Gr45XrWYgwsrAF4kua4agwn7tFZ7try3C34fWFnIgr1DCF1Fq3WYyr98Ca4furnr
	X3W5KFy5uw1xWrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBG14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAVWUtw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU9J5rUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

These helpers are used inside md-bitmap.c, prepare to build it as kernel
module first, and perhaps mark it as deprecated after new lockless
bitmap is introduced.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 15 ++++++---------
 drivers/md/md.h | 10 +++++++++-
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aad9b87cafa0..d16a3d0f2b90 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -252,6 +252,7 @@ void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(mddev_create_serial_pool);
 
 /*
  * Free resource from rdev(s), and destroy serial_info_pool under conditions:
@@ -291,6 +292,7 @@ void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(mddev_destroy_serial_pool);
 
 static struct ctl_table_header *raid_table_header;
 
@@ -972,15 +974,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	atomic_inc(&mddev->pending_writes);
 	submit_bio(bio);
 }
-
-int md_super_wait(struct mddev *mddev)
-{
-	/* wait for all superblock writes that were scheduled to complete */
-	wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
-	if (test_and_clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
-		return -EAGAIN;
-	return 0;
-}
+EXPORT_SYMBOL_GPL(md_super_write);
 
 int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		 struct page *page, blk_opf_t opf, bool metadata_op)
@@ -3793,6 +3787,7 @@ int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale)
 	*res = result * int_pow(10, scale - decimals);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(strict_strtoul_scaled);
 
 static ssize_t
 safe_delay_show(struct mddev *mddev, char *page)
@@ -8556,6 +8551,7 @@ int md_setup_cluster(struct mddev *mddev, int nodes)
 		mddev->safemode_delay = 0;
 	return ret;
 }
+EXPORT_SYMBOL_GPL(md_setup_cluster);
 
 void md_cluster_stop(struct mddev *mddev)
 {
@@ -8564,6 +8560,7 @@ void md_cluster_stop(struct mddev *mddev)
 	md_cluster_ops->leave(mddev);
 	module_put(md_cluster_mod);
 }
+EXPORT_SYMBOL_GPL(md_cluster_stop);
 
 static int is_mddev_idle(struct mddev *mddev, int init)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a53af8818923..5eaac1d84523 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -869,7 +869,6 @@ void md_free_cloned_bio(struct bio *bio);
 extern bool __must_check md_flush_request(struct mddev *mddev, struct bio *bio);
 extern void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 			   sector_t sector, int size, struct page *page);
-extern int md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		struct page *page, blk_opf_t opf, bool metadata_op);
 extern void md_do_sync(struct md_thread *thread);
@@ -994,6 +993,15 @@ static inline bool mddev_is_dm(struct mddev *mddev)
 	return !mddev->gendisk;
 }
 
+static inline int md_super_wait(struct mddev *mddev)
+{
+	/* wait for all superblock writes that were scheduled to complete */
+	wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes) == 0);
+	if (test_and_clear_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags))
+		return -EAGAIN;
+	return 0;
+}
+
 static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bio,
 		sector_t sector)
 {
-- 
2.39.2

