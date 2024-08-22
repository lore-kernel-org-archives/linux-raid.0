Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3652236AE0;
	Thu, 22 Aug 2024 02:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295132; cv=none; b=ZyMCFD8EyT6Kqk1xCym1ySVho7KAHLsHz0oZaaB7FZTM5I9SCKQjVqIB24IQX56Zdw4tppPjvmfGDzF/ZqYy9PskaQC7wSXiy5A5v2Iwn1rCXFueceI/OJ0q+bpMJHMlnrVq72wjwzTb5R2gzC2MySykSDjBlLIZFyyMsNzIDvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295132; c=relaxed/simple;
	bh=gLMDiDFlUSpjbuF6ddFhiNo2cUz6hEias8vZAd0XD4s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=arcc2Mb+RNYmuHHaY/nw09GUJvEhosHlallYETyDmQtdvrHb4S80/Q6EC4kDzCF/n/7Pm96cP35xxmc3HmLcVg4eER02M+EDDcByCc+lqX7HcalMdivJoEeNN8St3tK6sv2p4/wNPKv/IqUaVYulHt6sSqHN5xx4jM8SL5G5jYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wq75S4zL1z4f3kny;
	Thu, 22 Aug 2024 10:51:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 61E8F1A1891;
	Thu, 22 Aug 2024 10:52:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S18;
	Thu, 22 Aug 2024 10:52:06 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@linux.intel.com,
	l@damenly.org,
	xni@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 14/41] md/md-bitmap: merge md_bitmap_destroy() into bitmap_operations
Date: Thu, 22 Aug 2024 10:46:51 +0800
Message-Id: <20240822024718.2158259-15-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
References: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S18
X-Coremail-Antispam: 1UD129KBjvJXoWxXrW5ArW5tw4DGw13KryUKFg_yoWrArW5pa
	yxt3Z8Kr1aqrW3Wr4UAFWq9a4FvF1ktr9xKryxWw1rCFn3JrnxWF4rWFyUtw1fW345AFs0
	qw45tr15Xr17WFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VU1zpBDUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  7 ++++---
 drivers/md/md-bitmap.h |  2 +-
 drivers/md/md.c        | 15 ++++++++-------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bac247df6f40..0a276fe052c0 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1853,7 +1853,7 @@ void md_bitmap_wait_behind_writes(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(md_bitmap_wait_behind_writes);
 
-void md_bitmap_destroy(struct mddev *mddev)
+static void bitmap_destroy(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
@@ -2384,7 +2384,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			goto out;
 		}
 
-		md_bitmap_destroy(mddev);
+		bitmap_destroy(mddev);
 		mddev->bitmap_info.offset = 0;
 		if (mddev->bitmap_info.file) {
 			struct file *f = mddev->bitmap_info.file;
@@ -2427,7 +2427,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			rv = bitmap_load(mddev);
 			if (rv) {
 				mddev->bitmap_info.offset = 0;
-				md_bitmap_destroy(mddev);
+				bitmap_destroy(mddev);
 				goto out;
 			}
 		}
@@ -2724,6 +2724,7 @@ const struct attribute_group md_bitmap_group = {
 static struct bitmap_operations bitmap_ops = {
 	.create			= bitmap_create,
 	.load			= bitmap_load,
+	.destroy		= bitmap_destroy,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index f5b04b61d9e9..c8d27b91241b 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -249,6 +249,7 @@ struct md_bitmap_stats {
 struct bitmap_operations {
 	int (*create)(struct mddev *mddev, int slot);
 	int (*load)(struct mddev *mddev);
+	void (*destroy)(struct mddev *mddev);
 };
 
 /* the bitmap API */
@@ -256,7 +257,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
 void md_bitmap_flush(struct mddev *mddev);
-void md_bitmap_destroy(struct mddev *mddev);
 
 void md_bitmap_print_sb(struct bitmap *bitmap);
 void md_bitmap_update_sb(struct bitmap *bitmap);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ff59826aa192..15e830641c0c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6297,7 +6297,7 @@ int md_run(struct mddev *mddev)
 		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
 	module_put(pers->owner);
-	md_bitmap_destroy(mddev);
+	mddev->bitmap_ops->destroy(mddev);
 abort:
 	bioset_exit(&mddev->io_clone_set);
 exit_sync_set:
@@ -6319,7 +6319,7 @@ int do_md_run(struct mddev *mddev)
 
 	err = mddev->bitmap_ops->load(mddev);
 	if (err) {
-		md_bitmap_destroy(mddev);
+		mddev->bitmap_ops->destroy(mddev);
 		goto out;
 	}
 
@@ -6505,7 +6505,8 @@ static void mddev_detach(struct mddev *mddev)
 static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
-	md_bitmap_destroy(mddev);
+
+	mddev->bitmap_ops->destroy(mddev);
 	mddev_detach(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
@@ -7288,11 +7289,11 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 				err = mddev->bitmap_ops->load(mddev);
 
 			if (err) {
-				md_bitmap_destroy(mddev);
+				mddev->bitmap_ops->destroy(mddev);
 				fd = -1;
 			}
 		} else if (fd < 0) {
-			md_bitmap_destroy(mddev);
+			mddev->bitmap_ops->destroy(mddev);
 		}
 	}
 
@@ -7582,7 +7583,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				rv = mddev->bitmap_ops->load(mddev);
 
 			if (rv)
-				md_bitmap_destroy(mddev);
+				mddev->bitmap_ops->destroy(mddev);
 		} else {
 			struct md_bitmap_stats stats;
 
@@ -7609,7 +7610,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				module_put(md_cluster_mod);
 				mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
 			}
-			md_bitmap_destroy(mddev);
+			mddev->bitmap_ops->destroy(mddev);
 			mddev->bitmap_info.offset = 0;
 		}
 	}
-- 
2.39.2

