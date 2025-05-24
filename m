Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96FA1BEF9B;
	Sat, 24 May 2025 06:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067501; cv=none; b=HXnXZ057GboltiyCjgQvpQOyrZzOl5CEf7mILQbF9GUgJeOs3sbtq7ACvUKVZRMOEnARYrkjNnhvxD7Fg2LXlcU55TRYg6RBD+Hz7W9HbzO6KB8/aoZyJVK8ZB9dODcQW07Y0fs2fxlKbSQ1XiZn/50DRGmv5kUboh/e49o7P8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067501; c=relaxed/simple;
	bh=Th/CEyM4KEyKE/6ZBKIUh23R76RNEYT9+OxSiv1M754=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EbOekGnP18jXwz437y9ym0dcByP3Wn2hTvWk7/nwExgVbQ9SY7fJgpMKxaJC+9UgzAwfy6eapjcXU+fRgoIRdTFK7SP8ZY9LerlIB8grK5S5hXO1VN8bJyvghuwUsyDbHDMn3xS1jU3zz2LIjnqB14YB+T8/aK/NolOmsDgbr/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4b4Bf55tCLz4f3jXK;
	Sat, 24 May 2025 14:17:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id ED6B11A0359;
	Sat, 24 May 2025 14:18:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S11;
	Sat, 24 May 2025 14:18:14 +0800 (CST)
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
Subject: [PATCH 07/23] md/md-bitmap: delay registration of bitmap_ops until creating bitmap
Date: Sat, 24 May 2025 14:13:04 +0800
Message-Id: <20250524061320.370630-8-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S11
X-Coremail-Antispam: 1UD129KBjvJXoW3Jr4DGr47tr48KF4ftF45GFg_yoWxCr4rp3
	yft3Z5Kr4rXrZIqw47JFyq9F1rXrn7tr9xtryxXw15Grn3JrnxJF4rWF1Dtr18J348ZFs8
	Zw45Jr48Gr13uF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjfUOyIUUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Currently bitmap_ops is registered while allocating mddev, this is fine
when there is only one bitmap_ops, however, after introduing a new
bitmap_ops, user space need a time window to choose which bitmap_ops to
use while creating new array.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 86 +++++++++++++++++++++++++++++++------------------
 1 file changed, 55 insertions(+), 31 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4eb0c6effd5b..dc4b85f30e13 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -674,39 +674,50 @@ static void no_op(struct percpu_ref *r) {}
 
 static bool mddev_set_bitmap_ops(struct mddev *mddev)
 {
+	struct bitmap_operations *old = mddev->bitmap_ops;
+	struct md_submodule_head *head;
+
+	if (mddev->bitmap_id == ID_BITMAP_NONE ||
+	    (old && old->head.id == mddev->bitmap_id))
+		return true;
+
 	xa_lock(&md_submodule);
-	mddev->bitmap_ops = xa_load(&md_submodule, mddev->bitmap_id);
+	head = xa_load(&md_submodule, mddev->bitmap_id);
 	xa_unlock(&md_submodule);
 
-	if (!mddev->bitmap_ops) {
-		pr_warn_once("md: can't find bitmap id %d\n", mddev->bitmap_id);
+	if (WARN_ON_ONCE(!head || head->type != MD_BITMAP)) {
+		pr_err("md: can't find bitmap id %d\n", mddev->bitmap_id);
 		return false;
 	}
 
+	if (old && old->group)
+		sysfs_remove_group(&mddev->kobj, old->group);
+
+	mddev->bitmap_ops = (void *)head;
+	if (mddev->bitmap_ops && mddev->bitmap_ops->group &&
+	    sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
+		pr_warn("md: cannot register extra bitmap attributes for %s\n",
+			mdname(mddev));
+
 	return true;
 }
 
 static void mddev_clear_bitmap_ops(struct mddev *mddev)
 {
+	if (mddev->bitmap_ops && mddev->bitmap_ops->group)
+		sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
+
 	mddev->bitmap_ops = NULL;
 }
 
 int mddev_init(struct mddev *mddev)
 {
-	mddev->bitmap_id = ID_BITMAP;
-
-	if (!mddev_set_bitmap_ops(mddev))
-		return -EINVAL;
-
 	if (percpu_ref_init(&mddev->active_io, active_io_release,
-			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
-		mddev_clear_bitmap_ops(mddev);
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
 		return -ENOMEM;
-	}
 
 	if (percpu_ref_init(&mddev->writes_pending, no_op,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
-		mddev_clear_bitmap_ops(mddev);
 		percpu_ref_exit(&mddev->active_io);
 		return -ENOMEM;
 	}
@@ -734,6 +745,7 @@ int mddev_init(struct mddev *mddev)
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
+	mddev->bitmap_id = ID_BITMAP;
 
 	INIT_WORK(&mddev->sync_work, md_start_sync);
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
@@ -744,7 +756,6 @@ EXPORT_SYMBOL_GPL(mddev_init);
 
 void mddev_destroy(struct mddev *mddev)
 {
-	mddev_clear_bitmap_ops(mddev);
 	percpu_ref_exit(&mddev->active_io);
 	percpu_ref_exit(&mddev->writes_pending);
 }
@@ -6093,11 +6104,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		return ERR_PTR(error);
 	}
 
-	if (md_bitmap_registered(mddev) && mddev->bitmap_ops->group)
-		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
-			pr_warn("md: cannot register extra bitmap attributes for %s\n",
-				mdname(mddev));
-
 	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
@@ -6173,6 +6179,26 @@ static void md_safemode_timeout(struct timer_list *t)
 
 static int start_dirty_degraded;
 
+static int md_bitmap_create(struct mddev *mddev)
+{
+	if (mddev->bitmap_id == ID_BITMAP_NONE)
+		return -EINVAL;
+
+	if (!mddev_set_bitmap_ops(mddev))
+		return -ENOENT;
+
+	return mddev->bitmap_ops->create(mddev);
+}
+
+static void md_bitmap_destroy(struct mddev *mddev)
+{
+	if (!md_bitmap_registered(mddev))
+		return;
+
+	mddev->bitmap_ops->destroy(mddev);
+	mddev_clear_bitmap_ops(mddev);
+}
+
 int md_run(struct mddev *mddev)
 {
 	int err;
@@ -6337,9 +6363,9 @@ int md_run(struct mddev *mddev)
 			(unsigned long long)pers->size(mddev, 0, 0) / 2);
 		err = -EINVAL;
 	}
-	if (err == 0 && pers->sync_request && md_bitmap_registered(mddev) &&
+	if (err == 0 && pers->sync_request &&
 	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
-		err = mddev->bitmap_ops->create(mddev);
+		err = md_bitmap_create(mddev);
 		if (err)
 			pr_warn("%s: failed to create bitmap (%d)\n",
 				mdname(mddev), err);
@@ -6412,8 +6438,7 @@ int md_run(struct mddev *mddev)
 		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
 	put_pers(pers);
-	if (md_bitmap_registered(mddev))
-		mddev->bitmap_ops->destroy(mddev);
+	md_bitmap_destroy(mddev);
 abort:
 	bioset_exit(&mddev->io_clone_set);
 exit_sync_set:
@@ -6436,7 +6461,7 @@ int do_md_run(struct mddev *mddev)
 	if (md_bitmap_registered(mddev)) {
 		err = mddev->bitmap_ops->load(mddev);
 		if (err) {
-			mddev->bitmap_ops->destroy(mddev);
+			md_bitmap_destroy(mddev);
 			goto out;
 		}
 	}
@@ -6627,8 +6652,7 @@ static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
 
-	if (md_bitmap_registered(mddev))
-		mddev->bitmap_ops->destroy(mddev);
+	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
@@ -7408,16 +7432,16 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 	err = 0;
 	if (mddev->pers) {
 		if (fd >= 0) {
-			err = mddev->bitmap_ops->create(mddev);
+			err = md_bitmap_create(mddev);
 			if (!err)
 				err = mddev->bitmap_ops->load(mddev);
 
 			if (err) {
-				mddev->bitmap_ops->destroy(mddev);
+				md_bitmap_destroy(mddev);
 				fd = -1;
 			}
 		} else if (fd < 0) {
-			mddev->bitmap_ops->destroy(mddev);
+			md_bitmap_destroy(mddev);
 		}
 	}
 
@@ -7732,12 +7756,12 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				mddev->bitmap_info.default_offset;
 			mddev->bitmap_info.space =
 				mddev->bitmap_info.default_space;
-			rv = mddev->bitmap_ops->create(mddev);
+			rv = md_bitmap_create(mddev);
 			if (!rv)
 				rv = mddev->bitmap_ops->load(mddev);
 
 			if (rv)
-				mddev->bitmap_ops->destroy(mddev);
+				md_bitmap_destroy(mddev);
 		} else {
 			struct md_bitmap_stats stats;
 
@@ -7763,7 +7787,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				put_cluster_ops(mddev);
 				mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
 			}
-			mddev->bitmap_ops->destroy(mddev);
+			md_bitmap_destroy(mddev);
 			mddev->bitmap_info.offset = 0;
 		}
 	}
-- 
2.39.2

