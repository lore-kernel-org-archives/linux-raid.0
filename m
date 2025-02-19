Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CC71F4170;
	Wed, 19 Feb 2025 08:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954331; cv=none; b=iygcP9kh0kBeLvOPaAzFRnSa/uRb3eG7hjKkfztEHLB83HTYFhrnvSYzaStn+v8lWN0MkzN83SwaYatNSQjr6f+ap7H1BTbfvV6/5BEMo73NIqaD0JjEMtNYVqGv+wEsfZBhPaDq7T/w/4sIvqrgYDrLsYG+4XRH8aisM/h2yqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954331; c=relaxed/simple;
	bh=Mujj3ajX1kDm+W2RzmPnaKHpaHN2mJ8/XC9kXRGES+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EaMTZPu7mJHitGxw+lEitt/+8/FMtc83SjEzk9Cnj9mSPp6YNa358EvEMYYCZn/NBYvhje4u+IVbmLyq+nAMGc9Ov+PhEkAKkPB5GuwqcqGtGgJWeb62r1/slQY9mAMfU11s1GjAQmizTbXG7i9Kj0CpuqmDbs2jdKbfT/D9fMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YyVCh46Vmz4f3jtD;
	Wed, 19 Feb 2025 16:38:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D4BAF1A0F86;
	Wed, 19 Feb 2025 16:38:40 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBXvGCImLVn4yQeEQ--.36560S15;
	Wed, 19 Feb 2025 16:38:40 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.15 v4 11/11] md/md-bitmap: introduce CONFIG_MD_BITMAP
Date: Wed, 19 Feb 2025 16:34:56 +0800
Message-Id: <20250219083456.941760-12-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250219083456.941760-1-yukuai1@huaweicloud.com>
References: <20250219083456.941760-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXvGCImLVn4yQeEQ--.36560S15
X-Coremail-Antispam: 1UD129KBjvJXoWxKF4rWw4fury3Cw1ftF4UXFb_yoWfXrWfpF
	W8XF13Cr45tFW3XayUJa4q9F1Yqr1ktr9rtryfGwn5CF9xXr98JF4rWFyUtrykGFyxZFsx
	Za1rGFW7CF1jqF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYcTQUUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Now that all implementations are internal, it's sensible to add a config
option for md-bitmap, and it's a good way for isolation.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/Kconfig     | 18 ++++++++++++++++++
 drivers/md/Makefile    |  3 ++-
 drivers/md/md-bitmap.c | 23 +++++++++++++++++++++--
 drivers/md/md-bitmap.h | 17 +++++++++++++++--
 drivers/md/md.c        | 40 ++++++++++++++++++++++++++++------------
 drivers/md/md.h        |  3 +--
 6 files changed, 85 insertions(+), 19 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 0b1870a09e1f..0da07182494c 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -37,6 +37,21 @@ config BLK_DEV_MD
 
 	  If unsure, say N.
 
+config MD_BITMAP
+	bool "MD RAID bitmap support"
+	default y
+	depends on BLK_DEV_MD
+	help
+	  If you say Y here, support for the write intent bitmap will be
+	  enabled. The bitmap can be used to optimize resync speed after power
+	  failure or readding a disk, limiting it to recorded dirty sectors in
+	  bitmap.
+
+	  This feature can be added to existing MD array or MD array can be
+	  created with bitmap via mdadm(8).
+
+	  If unsure, say Y.
+
 config MD_AUTODETECT
 	bool "Autodetect RAID arrays during kernel boot"
 	depends on BLK_DEV_MD=y
@@ -54,6 +69,7 @@ config MD_AUTODETECT
 config MD_BITMAP_FILE
 	bool "MD bitmap file support (deprecated)"
 	default y
+	depends on MD_BITMAP
 	help
 	  If you say Y here, support for write intent bitmaps in files on an
 	  external file system is enabled.  This is an alternative to the internal
@@ -174,6 +190,7 @@ config MD_RAID456
 
 config MD_CLUSTER
 	tristate "Cluster Support for MD"
+	select MD_BITMAP
 	depends on BLK_DEV_MD
 	depends on DLM
 	default n
@@ -392,6 +409,7 @@ config DM_RAID
        select MD_RAID1
        select MD_RAID10
        select MD_RAID456
+       select MD_BITMAP
        select BLK_DEV_MD
 	help
 	 A dm target that supports RAID1, RAID10, RAID4, RAID5 and RAID6 mappings
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 87bdfc9fe14c..811731840a5c 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -27,7 +27,7 @@ dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
 dm-verity-y	+= dm-verity-target.o
 dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
 
-md-mod-y	+= md.o md-bitmap.o
+md-mod-y	+= md.o
 raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
 linear-y       += md-linear.o
 
@@ -38,6 +38,7 @@ linear-y       += md-linear.o
 
 obj-$(CONFIG_MD_LINEAR)		+= linear.o
 obj-$(CONFIG_MD_RAID0)		+= raid0.o
+obj-$(CONFIG_MD_BITMAP)		+= md-bitmap.o
 obj-$(CONFIG_MD_RAID1)		+= raid1.o
 obj-$(CONFIG_MD_RAID10)		+= raid10.o
 obj-$(CONFIG_MD_RAID456)	+= raid456.o
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index e4d337c1f197..9f2678962f8d 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -214,6 +214,8 @@ struct bitmap {
 	int cluster_slot;
 };
 
+static struct workqueue_struct *md_bitmap_wq;
+
 static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			   int chunksize, bool init);
 
@@ -2965,6 +2967,12 @@ static struct attribute_group md_bitmap_group = {
 };
 
 static struct bitmap_operations bitmap_ops = {
+	.head = {
+		.type	= MD_BITMAP,
+		.id	= ID_BITMAP,
+		.name	= "bitmap",
+	},
+
 	.enabled		= bitmap_enabled,
 	.create			= bitmap_create,
 	.resize			= bitmap_resize,
@@ -2999,7 +3007,18 @@ static struct bitmap_operations bitmap_ops = {
 	.group			= &md_bitmap_group,
 };
 
-void mddev_set_bitmap_ops(struct mddev *mddev)
+int md_bitmap_init(void)
+{
+	md_bitmap_wq = alloc_workqueue("md_bitmap", WQ_MEM_RECLAIM | WQ_UNBOUND,
+				       0);
+	if (!md_bitmap_wq)
+		return -ENOMEM;
+
+	return register_md_submodule(&bitmap_ops.head);
+}
+
+void md_bitmap_exit(void)
 {
-	mddev->bitmap_ops = &bitmap_ops;
+	destroy_workqueue(md_bitmap_wq);
+	unregister_md_submodule(&bitmap_ops.head);
 }
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index fefa00bc438e..d3d50629af91 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -71,6 +71,8 @@ struct md_bitmap_stats {
 };
 
 struct bitmap_operations {
+	struct md_submodule_head head;
+
 	bool (*enabled)(void *data);
 	int (*create)(struct mddev *mddev, int slot);
 	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize);
@@ -114,8 +116,6 @@ struct bitmap_operations {
 };
 
 /* the bitmap API */
-void mddev_set_bitmap_ops(struct mddev *mddev);
-
 static inline bool md_bitmap_registered(struct mddev *mddev)
 {
 	return mddev->bitmap_ops != NULL;
@@ -156,4 +156,17 @@ static inline void md_bitmap_end_sync(struct mddev *mddev, sector_t offset,
 	mddev->bitmap_ops->end_sync(mddev, offset, blocks);
 }
 
+#ifdef CONFIG_MD_BITMAP
+int md_bitmap_init(void);
+void md_bitmap_exit(void);
+#else
+static inline int md_bitmap_init(void)
+{
+	return 0;
+}
+static inline void md_bitmap_exit(void)
+{
+}
+#endif
+
 #endif
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 512012f31554..d23f120be01b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -94,7 +94,6 @@ static struct workqueue_struct *md_wq;
  * workqueue whith reconfig_mutex grabbed.
  */
 static struct workqueue_struct *md_misc_wq;
-struct workqueue_struct *md_bitmap_wq;
 
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
@@ -644,15 +643,34 @@ static void active_io_release(struct percpu_ref *ref)
 
 static void no_op(struct percpu_ref *r) {}
 
+static void mddev_set_bitmap_ops(struct mddev *mddev, enum md_submodule_id id)
+{
+	xa_lock(&md_submodule);
+	mddev->bitmap_ops = xa_load(&md_submodule, id);
+	xa_unlock(&md_submodule);
+	if (!mddev->bitmap_ops)
+		pr_warn_once("md: can't find bitmap id %d\n", id);
+}
+
+static void mddev_clear_bitmap_ops(struct mddev *mddev)
+{
+	mddev->bitmap_ops = NULL;
+}
+
 int mddev_init(struct mddev *mddev)
 {
+	/* TODO: support more versions */
+	mddev_set_bitmap_ops(mddev, ID_BITMAP);
 
 	if (percpu_ref_init(&mddev->active_io, active_io_release,
-			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
+		mddev_clear_bitmap_ops(mddev);
 		return -ENOMEM;
+	}
 
 	if (percpu_ref_init(&mddev->writes_pending, no_op,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
+		mddev_clear_bitmap_ops(mddev);
 		percpu_ref_exit(&mddev->active_io);
 		return -ENOMEM;
 	}
@@ -680,7 +698,6 @@ int mddev_init(struct mddev *mddev)
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
-	mddev_set_bitmap_ops(mddev);
 
 	INIT_WORK(&mddev->sync_work, md_start_sync);
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
@@ -691,6 +708,7 @@ EXPORT_SYMBOL_GPL(mddev_init);
 
 void mddev_destroy(struct mddev *mddev)
 {
+	mddev_clear_bitmap_ops(mddev);
 	percpu_ref_exit(&mddev->active_io);
 	percpu_ref_exit(&mddev->writes_pending);
 }
@@ -9968,8 +9986,12 @@ static void md_geninit(void)
 
 static int __init md_init(void)
 {
-	int ret = -ENOMEM;
+	int ret = md_bitmap_init();
 
+	if (ret)
+		return ret;
+
+	ret = -ENOMEM;
 	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
 	if (!md_wq)
 		goto err_wq;
@@ -9978,11 +10000,6 @@ static int __init md_init(void)
 	if (!md_misc_wq)
 		goto err_misc_wq;
 
-	md_bitmap_wq = alloc_workqueue("md_bitmap", WQ_MEM_RECLAIM | WQ_UNBOUND,
-				       0);
-	if (!md_bitmap_wq)
-		goto err_bitmap_wq;
-
 	ret = __register_blkdev(MD_MAJOR, "md", md_probe);
 	if (ret < 0)
 		goto err_md;
@@ -10001,12 +10018,11 @@ static int __init md_init(void)
 err_mdp:
 	unregister_blkdev(MD_MAJOR, "md");
 err_md:
-	destroy_workqueue(md_bitmap_wq);
-err_bitmap_wq:
 	destroy_workqueue(md_misc_wq);
 err_misc_wq:
 	destroy_workqueue(md_wq);
 err_wq:
+	md_bitmap_exit();
 	return ret;
 }
 
@@ -10309,8 +10325,8 @@ static __exit void md_exit(void)
 	spin_unlock(&all_mddevs_lock);
 
 	destroy_workqueue(md_misc_wq);
-	destroy_workqueue(md_bitmap_wq);
 	destroy_workqueue(md_wq);
+	md_bitmap_exit();
 }
 
 subsys_initcall(md_init);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 87893bd41f28..254bbab6f443 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -38,7 +38,7 @@ enum md_submodule_id {
 	ID_RAID6	= 6,
 	ID_RAID10	= 10,
 	ID_CLUSTER,
-	ID_BITMAP,	/* TODO */
+	ID_BITMAP,
 	ID_LLBITMAP,	/* TODO */
 };
 
@@ -998,7 +998,6 @@ struct mdu_array_info_s;
 struct mdu_disk_info_s;
 
 extern int mdp_major;
-extern struct workqueue_struct *md_bitmap_wq;
 void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
-- 
2.39.2

