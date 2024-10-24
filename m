Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CEE1DD0DF;
	Thu, 24 Oct 2024 13:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729775794; cv=none; b=eUYVxBcxQhse5tnn+LQ+swp4FFEGgSaB0+HQ4ttjAHG5WYCIEeNz+lCgUrQE9reg/ytrg2UAi+OiEet8/UvhvH0NyfQ43Uk5T/VtsdTHaM19vsSfPzDkheAmNqnb2jvQpFBaw1KbPeMvwF2Z8cnMzDQfj1VvQ4d0vnn1BuCCdjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729775794; c=relaxed/simple;
	bh=5TCr4+PJXAti6vPQyC8JOEF601OifvacV9cqLUGnbE8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LQr9pKILXzi1eFQIaD0Qi/fvJcJQ7NIsCoCDJglTMDxLPpTYN+lgX/5O2s5NpPenXmjczuYZAL2LU1s5izJG9VhzOGzodSEtdhwfVzJmNFNNmqt+kfOW+3p/LU3ghfutWqZEJpGEJSfgdPfP3Iyh8uc+XlVIQacFbr8oUvvumW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XZ5yP2NzNz4f3m8D;
	Thu, 24 Oct 2024 21:15:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AD8521A07B6;
	Thu, 24 Oct 2024 21:16:09 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCXysaWSBpnPGb6Ew--.10198S8;
	Thu, 24 Oct 2024 21:16:09 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC 4/4] md/md-bitmap: support to build md-bitmap as kernel module
Date: Thu, 24 Oct 2024 21:13:25 +0800
Message-Id: <20241024131325.2250880-5-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCXysaWSBpnPGb6Ew--.10198S8
X-Coremail-Antispam: 1UD129KBjvJXoWxuw4kWw15tw17Kr43WrW7Jwb_yoWfAw4rpF
	4rJ34rCr45Ja9Iqa1UGFWDuFySgr1kKrZrtryfGwsYkFnrJr9xJF48GFWUt3s8GFWfXFsx
	Zw4rKryUCr4UuF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPUUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Now that all implementations are internal, it's sensible to build it as
kernel module now.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/Kconfig     | 15 +++++++
 drivers/md/Makefile    |  4 +-
 drivers/md/md-bitmap.c | 28 +++++++++++-
 drivers/md/md-bitmap.h |  8 +++-
 drivers/md/md.c        | 97 +++++++++++++++++++++++++++++++++++++-----
 drivers/md/md.h        |  1 -
 6 files changed, 135 insertions(+), 18 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 1e9db8e4acdf..452d7292b617 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -37,6 +37,21 @@ config BLK_DEV_MD
 
 	  If unsure, say N.
 
+config MD_BITMAP
+	tristate "RAID bitmap support"
+	default y
+	depends on BLK_DEV_MD
+	help
+	  If you say Y here, support for the write intent bitmap will be
+	  enabled. The bitmap will be used to record the data regions that need
+	  to be resynced after a power failure, preventing a full disk resync.
+	  The bitmap size ranges from 4K to 132K, depending on the array size.
+	  Each bit corresponds to 2 bytes of data and is managed in
+	  self-maintained memory. All bits are protected by a disk-level
+	  spinlock.
+
+	  If unsure, say Y.
+
 config MD_AUTODETECT
 	bool "Autodetect RAID arrays during kernel boot"
 	depends on BLK_DEV_MD=y
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 476a214e4bdc..387670f766b7 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -27,14 +27,14 @@ dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
 dm-verity-y	+= dm-verity-target.o
 dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
 
-md-mod-y	+= md.o md-bitmap.o
+md-mod-y	+= md.o
 raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
 
 # Note: link order is important.  All raid personalities
 # and must come before md.o, as they each initialise
 # themselves, and md.o may use the personalities when it
 # auto-initialised.
-
+obj-$(CONFIG_MD_BITMAP)		+= md-bitmap.o
 obj-$(CONFIG_MD_RAID0)		+= raid0.o
 obj-$(CONFIG_MD_RAID1)		+= raid1.o
 obj-$(CONFIG_MD_RAID10)		+= raid10.o
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index f68eb79e739d..148a479d32c0 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -212,6 +212,8 @@ struct bitmap {
 	int cluster_slot;
 };
 
+static struct workqueue_struct *md_bitmap_wq;
+
 static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			   int chunksize, bool init);
 
@@ -2970,6 +2972,9 @@ static struct attribute_group md_bitmap_group = {
 };
 
 static struct bitmap_operations bitmap_ops = {
+	.version		= 1,
+	.owner			= THIS_MODULE,
+
 	.enabled		= bitmap_enabled,
 	.create			= bitmap_create,
 	.resize			= bitmap_resize,
@@ -3001,7 +3006,26 @@ static struct bitmap_operations bitmap_ops = {
 	.group			= &md_bitmap_group,
 };
 
-void mddev_set_bitmap_ops(struct mddev *mddev)
+static int __init bitmap_init(void)
+{
+	md_bitmap_wq = alloc_workqueue("md_bitmap", WQ_MEM_RECLAIM | WQ_UNBOUND,
+				       0);
+	if (!md_bitmap_wq)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&bitmap_ops.list);
+	register_md_bitmap(&bitmap_ops);
+	return 0;
+}
+
+static void __exit bitmap_exit(void)
 {
-	mddev->bitmap_ops = &bitmap_ops;
+	destroy_workqueue(md_bitmap_wq);
+	unregister_md_bitmap(&bitmap_ops);
 }
+
+module_init(bitmap_init);
+module_exit(bitmap_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Bitmap for MD");
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 0c19983453c7..9d1bf3c43125 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -71,6 +71,10 @@ struct md_bitmap_stats {
 };
 
 struct bitmap_operations {
+	int version;
+	struct module *owner;
+	struct list_head list;
+
 	bool (*enabled)(struct mddev *mddev);
 	int (*create)(struct mddev *mddev, int slot);
 	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize);
@@ -110,7 +114,7 @@ struct bitmap_operations {
 	struct attribute_group *group;
 };
 
-/* the bitmap API */
-void mddev_set_bitmap_ops(struct mddev *mddev);
+void register_md_bitmap(struct bitmap_operations *op);
+void unregister_md_bitmap(struct bitmap_operations *op);
 
 #endif
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d16a3d0f2b90..09fac65b83b8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -83,6 +83,9 @@ static const char *action_name[NR_SYNC_ACTIONS] = {
 static LIST_HEAD(pers_list);
 static DEFINE_SPINLOCK(pers_lock);
 
+static LIST_HEAD(bitmap_list);
+static DEFINE_SPINLOCK(bitmap_lock);
+
 static const struct kobj_type md_ktype;
 
 const struct md_cluster_operations *md_cluster_ops;
@@ -100,7 +103,6 @@ static struct workqueue_struct *md_wq;
  * workqueue whith reconfig_mutex grabbed.
  */
 static struct workqueue_struct *md_misc_wq;
-struct workqueue_struct *md_bitmap_wq;
 
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
@@ -630,15 +632,96 @@ static void active_io_release(struct percpu_ref *ref)
 
 static void no_op(struct percpu_ref *r) {}
 
+void register_md_bitmap(struct bitmap_operations *op)
+{
+	pr_info("md: bitmap version %d registered\n", op->version);
+
+	spin_lock(&bitmap_lock);
+	list_add_tail(&op->list, &bitmap_list);
+	spin_unlock(&bitmap_lock);
+}
+EXPORT_SYMBOL_GPL(register_md_bitmap);
+
+void unregister_md_bitmap(struct bitmap_operations *op)
+{
+	pr_info("md: bitmap version %d unregistered\n", op->version);
+
+	spin_lock(&bitmap_lock);
+	list_del_init(&op->list);
+	spin_unlock(&bitmap_lock);
+}
+EXPORT_SYMBOL_GPL(unregister_md_bitmap);
+
+static struct bitmap_operations *__find_bitmap(int version)
+{
+	struct bitmap_operations *op;
+
+	list_for_each_entry(op, &bitmap_list, list)
+		if (op->version == version) {
+			if (try_module_get(op->owner))
+				return op;
+			else
+				return NULL;
+		}
+
+	return NULL;
+}
+
+static struct bitmap_operations *find_bitmap(int version)
+{
+	struct bitmap_operations *op = NULL;
+
+	spin_lock(&bitmap_lock);
+	op = __find_bitmap(version);
+	spin_unlock(&bitmap_lock);
+
+	if (op)
+		return op;
+
+	if (request_module("md-bitmap") != 0)
+		return NULL;
+
+	spin_lock(&bitmap_lock);
+	op = __find_bitmap(version);
+	spin_unlock(&bitmap_lock);
+
+	return op;
+}
+
+/* TODO: support more versions */
+static int mddev_set_bitmap_ops(struct mddev *mddev)
+{
+	struct bitmap_operations *op = find_bitmap(1);
+
+	if (!op)
+		return -ENODEV;
+
+	mddev->bitmap_ops = op;
+	return 0;
+}
+
+static void mddev_clear_bitmap_ops(struct mddev *mddev)
+{
+	module_put(mddev->bitmap_ops->owner);
+	mddev->bitmap_ops = NULL;
+}
+
 int mddev_init(struct mddev *mddev)
 {
+	int ret = mddev_set_bitmap_ops(mddev);
+
+	if (ret)
+		return ret;
 
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
@@ -666,7 +749,6 @@ int mddev_init(struct mddev *mddev)
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
-	mddev_set_bitmap_ops(mddev);
 
 	INIT_WORK(&mddev->sync_work, md_start_sync);
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
@@ -677,6 +759,7 @@ EXPORT_SYMBOL_GPL(mddev_init);
 
 void mddev_destroy(struct mddev *mddev)
 {
+	mddev_clear_bitmap_ops(mddev);
 	percpu_ref_exit(&mddev->active_io);
 	percpu_ref_exit(&mddev->writes_pending);
 }
@@ -9898,11 +9981,6 @@ static int __init md_init(void)
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
@@ -9921,8 +9999,6 @@ static int __init md_init(void)
 err_mdp:
 	unregister_blkdev(MD_MAJOR, "md");
 err_md:
-	destroy_workqueue(md_bitmap_wq);
-err_bitmap_wq:
 	destroy_workqueue(md_misc_wq);
 err_misc_wq:
 	destroy_workqueue(md_wq);
@@ -10229,7 +10305,6 @@ static __exit void md_exit(void)
 	spin_unlock(&all_mddevs_lock);
 
 	destroy_workqueue(md_misc_wq);
-	destroy_workqueue(md_bitmap_wq);
 	destroy_workqueue(md_wq);
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5eaac1d84523..28347fb3af18 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -972,7 +972,6 @@ struct mdu_array_info_s;
 struct mdu_disk_info_s;
 
 extern int mdp_major;
-extern struct workqueue_struct *md_bitmap_wq;
 void md_autostart_arrays(int part);
 int md_set_array_info(struct mddev *mddev, struct mdu_array_info_s *info);
 int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info);
-- 
2.39.2

