Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DC619DFA5;
	Sat, 15 Feb 2025 09:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739611563; cv=none; b=GI4Ub02ObNIdPsrOaWCqgqsBs1nwJz0w9h5qMNujo4avpC+WlXmj0q3RTUORlvSr/ECcirrfFd4L+rgHHCwFGTsP+0tDO94keO2Xh4Ta1ne/b+GwRr/Uo1UYPSVf7te0Tr9saIZ9KjgLeLf0SllXOoK7WKlevJk3eE4a1GFxRRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739611563; c=relaxed/simple;
	bh=k2Pe7cak/NEJe96mbzLoRLQdj4UrkcdWnPpDQbPVVJ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QgLQQJzE49pZMtW8Ds04sAqPHYHqpzGxye0a9c+dTDjJNyBdKfuW+aJ+zCIZnpBtnPW9UO75iOZcaYLTob8vOTYEGSYS6zK93YcyoYh4YDmEffUEKVADwY+tvCUhWE0NQ+W6nyljOAOJoAN9MQ4zoK7wZATwG27y5Iw+hq5+UoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yw3Rq6zGKz4f3kvh;
	Sat, 15 Feb 2025 17:25:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C7C8A1A06D7;
	Sat, 15 Feb 2025 17:25:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAni1+bXbBn+Q+iDw--.49525S8;
	Sat, 15 Feb 2025 17:25:50 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.15 4/7] md: switch personalities to use md_submodule_head
Date: Sat, 15 Feb 2025 17:22:22 +0800
Message-Id: <20250215092225.2427977-5-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAni1+bXbBn+Q+iDw--.49525S8
X-Coremail-Antispam: 1UD129KBjvAXoW3tFW3CryxJr48KF4UWrWDCFg_yoW8Wr1kXo
	Zag3ZxZ348JF98Ar4ktr4DKrW7X3W3A3WrAa43Wrs5u3W2yFWFkFn7Xws3XFy2qrs8WF18
	ZF18Jr4vyFWrG3y8n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYR7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r126s0DM28Irc
	Ia0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l
	84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJV
	WxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_JF
	0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYcTQUUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Remove the global list 'pers_list', and switch to use md_submodule_head,
which is managed by xarry. Prepare to unify registration and unregistration
for all sub modules.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-linear.c | 15 ++++----
 drivers/md/md.c        | 82 +++++++++++++++++-------------------------
 drivers/md/md.h        |  7 +---
 drivers/md/raid0.c     | 18 ++++++----
 drivers/md/raid1.c     | 22 +++++++-----
 drivers/md/raid10.c    | 22 +++++++-----
 drivers/md/raid5.c     | 70 +++++++++++++++++++++++++-----------
 7 files changed, 130 insertions(+), 106 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 369aed044b40..5d9b08115375 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/blkdev.h>
-#include <linux/raid/md_u.h>
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -320,9 +319,13 @@ static void linear_quiesce(struct mddev *mddev, int state)
 }
 
 static struct md_personality linear_personality = {
-	.name		= "linear",
-	.level		= LEVEL_LINEAR,
-	.owner		= THIS_MODULE,
+	.head = {
+		.type	= MD_PERSONALITY,
+		.id	= ID_LINEAR,
+		.name	= "linear",
+		.owner	= THIS_MODULE,
+	},
+
 	.make_request	= linear_make_request,
 	.run		= linear_run,
 	.free		= linear_free,
@@ -335,12 +338,12 @@ static struct md_personality linear_personality = {
 
 static int __init linear_init(void)
 {
-	return register_md_personality(&linear_personality);
+	return register_md_submodule(&linear_personality.head);
 }
 
 static void linear_exit(void)
 {
-	unregister_md_personality(&linear_personality);
+	unregister_md_submodule(&linear_personality.head);
 }
 
 module_init(linear_init);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6b83039a3dcc..498ae11e3f6e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -81,8 +81,6 @@ static const char *action_name[NR_SYNC_ACTIONS] = {
 
 static DEFINE_XARRAY(md_submodule);
 
-/* pers_list is a list of registered personalities protected by pers_lock. */
-static LIST_HEAD(pers_list);
 static DEFINE_SPINLOCK(pers_lock);
 
 static const struct kobj_type md_ktype;
@@ -893,18 +891,21 @@ EXPORT_SYMBOL_GPL(md_find_rdev_rcu);
 static struct md_personality *get_pers(int level, char *clevel)
 {
 	struct md_personality *ret = NULL;
-	struct md_personality *pers;
+	struct md_submodule_head *head;
+	unsigned long i;
 
-	spin_lock(&pers_lock);
-	list_for_each_entry(pers, &pers_list, list) {
-		if ((level != LEVEL_NONE && pers->level == level) ||
-		    !strcmp(pers->name, clevel)) {
-			if (try_module_get(pers->owner))
-				ret = pers;
+	xa_lock(&md_submodule);
+	xa_for_each(&md_submodule, i, head) {
+		if (head->type != MD_PERSONALITY)
+			continue;
+		if ((level != LEVEL_NONE && head->id == level) ||
+		    !strcmp(head->name, clevel)) {
+			if (try_module_get(head->owner))
+				ret = (void *)head;
 			break;
 		}
 	}
-	spin_unlock(&pers_lock);
+	xa_unlock(&md_submodule);
 
 	if (!ret) {
 		if (level != LEVEL_NONE)
@@ -920,7 +921,7 @@ static struct md_personality *get_pers(int level, char *clevel)
 
 static void put_pers(struct md_personality *pers)
 {
-	module_put(pers->owner);
+	module_put(pers->head.owner);
 }
 
 /* return the offset of the super block in 512byte sectors */
@@ -1203,7 +1204,7 @@ int md_check_no_bitmap(struct mddev *mddev)
 	if (!mddev->bitmap_info.file && !mddev->bitmap_info.offset)
 		return 0;
 	pr_warn("%s: bitmaps are not supported for %s\n",
-		mdname(mddev), mddev->pers->name);
+		mdname(mddev), mddev->pers->head.name);
 	return 1;
 }
 EXPORT_SYMBOL(md_check_no_bitmap);
@@ -3883,7 +3884,7 @@ level_show(struct mddev *mddev, char *page)
 	spin_lock(&mddev->lock);
 	p = mddev->pers;
 	if (p)
-		ret = sprintf(page, "%s\n", p->name);
+		ret = sprintf(page, "%s\n", p->head.name);
 	else if (mddev->clevel[0])
 		ret = sprintf(page, "%s\n", mddev->clevel);
 	else if (mddev->level != LEVEL_NONE)
@@ -3940,7 +3941,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	rv = -EINVAL;
 	if (!mddev->pers->quiesce) {
 		pr_warn("md: %s: %s does not support online personality change\n",
-			mdname(mddev), mddev->pers->name);
+			mdname(mddev), mddev->pers->head.name);
 		goto out_unlock;
 	}
 
@@ -4003,7 +4004,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	oldpriv = mddev->private;
 	mddev->pers = pers;
 	mddev->private = priv;
-	strscpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
+	strscpy(mddev->clevel, pers->head.name, sizeof(mddev->clevel));
 	mddev->level = mddev->new_level;
 	mddev->layout = mddev->new_layout;
 	mddev->chunk_sectors = mddev->new_chunk_sectors;
@@ -5603,7 +5604,7 @@ __ATTR(fail_last_dev, S_IRUGO | S_IWUSR, fail_last_dev_show,
 
 static ssize_t serialize_policy_show(struct mddev *mddev, char *page)
 {
-	if (mddev->pers == NULL || (mddev->pers->level != 1))
+	if (mddev->pers == NULL || (mddev->pers->head.id != ID_RAID1))
 		return sprintf(page, "n/a\n");
 	else
 		return sprintf(page, "%d\n", mddev->serialize_policy);
@@ -5629,7 +5630,7 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
 	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
-	if (mddev->pers == NULL || (mddev->pers->level != 1)) {
+	if (mddev->pers == NULL || (mddev->pers->head.id != ID_RAID1)) {
 		pr_err("md: serialize_policy is only effective for raid1\n");
 		err = -EINVAL;
 		goto unlock;
@@ -6120,11 +6121,11 @@ int md_run(struct mddev *mddev)
 		err = -EINVAL;
 		goto abort;
 	}
-	if (mddev->level != pers->level) {
-		mddev->level = pers->level;
-		mddev->new_level = pers->level;
+	if (mddev->level != pers->head.id) {
+		mddev->level = pers->head.id;
+		mddev->new_level = pers->head.id;
 	}
-	strscpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
+	strscpy(mddev->clevel, pers->head.name, sizeof(mddev->clevel));
 
 	if (mddev->reshape_position != MaxSector &&
 	    pers->start_reshape == NULL) {
@@ -8134,7 +8135,8 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 		return;
 	mddev->pers->error_handler(mddev, rdev);
 
-	if (mddev->pers->level == 0 || mddev->pers->level == LEVEL_LINEAR)
+	if (mddev->pers->head.id == ID_RAID0 ||
+	    mddev->pers->head.id == ID_LINEAR)
 		return;
 
 	if (mddev->degraded && !test_bit(MD_BROKEN, &mddev->flags))
@@ -8172,14 +8174,17 @@ static void status_unused(struct seq_file *seq)
 
 static void status_personalities(struct seq_file *seq)
 {
-	struct md_personality *pers;
+	struct md_submodule_head *head;
+	unsigned long i;
 
 	seq_puts(seq, "Personalities : ");
-	spin_lock(&pers_lock);
-	list_for_each_entry(pers, &pers_list, list)
-		seq_printf(seq, "[%s] ", pers->name);
 
-	spin_unlock(&pers_lock);
+	xa_lock(&md_submodule);
+	xa_for_each(&md_submodule, i, head)
+		if (head->type == MD_PERSONALITY)
+			seq_printf(seq, "[%s] ", head->name);
+	xa_unlock(&md_submodule);
+
 	seq_puts(seq, "\n");
 }
 
@@ -8402,7 +8407,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 				seq_printf(seq, " (read-only)");
 			if (mddev->ro == MD_AUTO_READ)
 				seq_printf(seq, " (auto-read-only)");
-			seq_printf(seq, " %s", mddev->pers->name);
+			seq_printf(seq, " %s", mddev->pers->head.name);
 		} else {
 			seq_printf(seq, "inactive");
 		}
@@ -8536,27 +8541,6 @@ void unregister_md_submodule(struct md_submodule_head *msh)
 }
 EXPORT_SYMBOL_GPL(unregister_md_submodule);
 
-int register_md_personality(struct md_personality *p)
-{
-	pr_debug("md: %s personality registered for level %d\n",
-		 p->name, p->level);
-	spin_lock(&pers_lock);
-	list_add_tail(&p->list, &pers_list);
-	spin_unlock(&pers_lock);
-	return 0;
-}
-EXPORT_SYMBOL(register_md_personality);
-
-int unregister_md_personality(struct md_personality *p)
-{
-	pr_debug("md: %s personality unregistered\n", p->name);
-	spin_lock(&pers_lock);
-	list_del_init(&p->list);
-	spin_unlock(&pers_lock);
-	return 0;
-}
-EXPORT_SYMBOL(unregister_md_personality);
-
 int register_md_cluster_operations(const struct md_cluster_operations *ops,
 				   struct module *module)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4807fa0d0362..f9e0f0d390f1 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -726,10 +726,7 @@ static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
 struct md_personality
 {
 	struct md_submodule_head head;
-	char *name;
-	int level;
-	struct list_head list;
-	struct module *owner;
+
 	bool __must_check (*make_request)(struct mddev *mddev, struct bio *bio);
 	/*
 	 * start up works that do NOT require md_thread. tasks that
@@ -873,8 +870,6 @@ static inline void safe_put_page(struct page *p)
 int register_md_submodule(struct md_submodule_head *msh);
 void unregister_md_submodule(struct md_submodule_head *msh);
 
-extern int register_md_personality(struct md_personality *p);
-extern int unregister_md_personality(struct md_personality *p);
 extern struct md_thread *md_register_thread(
 	void (*run)(struct md_thread *thread),
 	struct mddev *mddev,
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 8fc9339b00c7..2aec92e6e0a9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -811,9 +811,13 @@ static void raid0_quiesce(struct mddev *mddev, int quiesce)
 
 static struct md_personality raid0_personality=
 {
-	.name		= "raid0",
-	.level		= 0,
-	.owner		= THIS_MODULE,
+	.head = {
+		.type	= MD_PERSONALITY,
+		.id	= ID_RAID0,
+		.name	= "raid0",
+		.owner	= THIS_MODULE,
+	},
+
 	.make_request	= raid0_make_request,
 	.run		= raid0_run,
 	.free		= raid0_free,
@@ -824,14 +828,14 @@ static struct md_personality raid0_personality=
 	.error_handler	= raid0_error,
 };
 
-static int __init raid0_init (void)
+static int __init raid0_init(void)
 {
-	return register_md_personality (&raid0_personality);
+	return register_md_submodule(&raid0_personality.head);
 }
 
-static void raid0_exit (void)
+static void __exit raid0_exit(void)
 {
-	unregister_md_personality (&raid0_personality);
+	unregister_md_submodule(&raid0_personality.head);
 }
 
 module_init(raid0_init);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e55db07e43d4..c4bfd190c698 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3494,9 +3494,13 @@ static void *raid1_takeover(struct mddev *mddev)
 
 static struct md_personality raid1_personality =
 {
-	.name		= "raid1",
-	.level		= 1,
-	.owner		= THIS_MODULE,
+	.head = {
+		.type	= MD_PERSONALITY,
+		.id	= ID_RAID1,
+		.name	= "raid1",
+		.owner	= THIS_MODULE,
+	},
+
 	.make_request	= raid1_make_request,
 	.run		= raid1_run,
 	.free		= raid1_free,
@@ -3513,18 +3517,18 @@ static struct md_personality raid1_personality =
 	.takeover	= raid1_takeover,
 };
 
-static int __init raid_init(void)
+static int __init raid1_init(void)
 {
-	return register_md_personality(&raid1_personality);
+	return register_md_submodule(&raid1_personality.head);
 }
 
-static void raid_exit(void)
+static void __exit raid1_exit(void)
 {
-	unregister_md_personality(&raid1_personality);
+	unregister_md_submodule(&raid1_personality.head);
 }
 
-module_init(raid_init);
-module_exit(raid_exit);
+module_init(raid1_init);
+module_exit(raid1_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("RAID1 (mirroring) personality for MD");
 MODULE_ALIAS("md-personality-3"); /* RAID1 */
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3df39b2399b2..5823329841ba 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -5126,9 +5126,13 @@ static void raid10_finish_reshape(struct mddev *mddev)
 
 static struct md_personality raid10_personality =
 {
-	.name		= "raid10",
-	.level		= 10,
-	.owner		= THIS_MODULE,
+	.head = {
+		.type	= MD_PERSONALITY,
+		.id	= ID_RAID10,
+		.name	= "raid10",
+		.owner	= THIS_MODULE,
+	},
+
 	.make_request	= raid10_make_request,
 	.run		= raid10_run,
 	.free		= raid10_free,
@@ -5148,18 +5152,18 @@ static struct md_personality raid10_personality =
 	.update_reshape_pos = raid10_update_reshape_pos,
 };
 
-static int __init raid_init(void)
+static int __init raid10_init(void)
 {
-	return register_md_personality(&raid10_personality);
+	return register_md_submodule(&raid10_personality.head);
 }
 
-static void raid_exit(void)
+static void __exit raid10_exit(void)
 {
-	unregister_md_personality(&raid10_personality);
+	unregister_md_submodule(&raid10_personality.head);
 }
 
-module_init(raid_init);
-module_exit(raid_exit);
+module_init(raid10_init);
+module_exit(raid10_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("RAID10 (striped mirror) personality for MD");
 MODULE_ALIAS("md-personality-9"); /* RAID10 */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5c79429acc64..d73a775b16c5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8954,9 +8954,13 @@ static void raid5_prepare_suspend(struct mddev *mddev)
 
 static struct md_personality raid6_personality =
 {
-	.name		= "raid6",
-	.level		= 6,
-	.owner		= THIS_MODULE,
+	.head = {
+		.type	= MD_PERSONALITY,
+		.id	= ID_RAID6,
+		.name	= "raid6",
+		.owner	= THIS_MODULE,
+	},
+
 	.make_request	= raid5_make_request,
 	.run		= raid5_run,
 	.start		= raid5_start,
@@ -8980,9 +8984,13 @@ static struct md_personality raid6_personality =
 };
 static struct md_personality raid5_personality =
 {
-	.name		= "raid5",
-	.level		= 5,
-	.owner		= THIS_MODULE,
+	.head = {
+		.type	= MD_PERSONALITY,
+		.id	= ID_RAID5,
+		.name	= "raid5",
+		.owner	= THIS_MODULE,
+	},
+
 	.make_request	= raid5_make_request,
 	.run		= raid5_run,
 	.start		= raid5_start,
@@ -9007,9 +9015,13 @@ static struct md_personality raid5_personality =
 
 static struct md_personality raid4_personality =
 {
-	.name		= "raid4",
-	.level		= 4,
-	.owner		= THIS_MODULE,
+	.head = {
+		.type	= MD_PERSONALITY,
+		.id	= ID_RAID4,
+		.name	= "raid4",
+		.owner	= THIS_MODULE,
+	},
+
 	.make_request	= raid5_make_request,
 	.run		= raid5_run,
 	.start		= raid5_start,
@@ -9045,21 +9057,39 @@ static int __init raid5_init(void)
 				      "md/raid5:prepare",
 				      raid456_cpu_up_prepare,
 				      raid456_cpu_dead);
-	if (ret) {
-		destroy_workqueue(raid5_wq);
-		return ret;
-	}
-	register_md_personality(&raid6_personality);
-	register_md_personality(&raid5_personality);
-	register_md_personality(&raid4_personality);
+	if (ret)
+		goto err_destroy_wq;
+
+	ret = register_md_submodule(&raid6_personality.head);
+	if (ret)
+		goto err_cpuhp_remove;
+
+	ret = register_md_submodule(&raid5_personality.head);
+	if (ret)
+		goto err_unregister_raid6;
+
+	ret = register_md_submodule(&raid4_personality.head);
+	if (ret)
+		goto err_unregister_raid5;
+
 	return 0;
+
+err_unregister_raid5:
+	unregister_md_submodule(&raid5_personality.head);
+err_unregister_raid6:
+	unregister_md_submodule(&raid6_personality.head);
+err_cpuhp_remove:
+	cpuhp_remove_multi_state(CPUHP_MD_RAID5_PREPARE);
+err_destroy_wq:
+	destroy_workqueue(raid5_wq);
+	return ret;
 }
 
-static void raid5_exit(void)
+static void __exit raid5_exit(void)
 {
-	unregister_md_personality(&raid6_personality);
-	unregister_md_personality(&raid5_personality);
-	unregister_md_personality(&raid4_personality);
+	unregister_md_submodule(&raid6_personality.head);
+	unregister_md_submodule(&raid5_personality.head);
+	unregister_md_submodule(&raid4_personality.head);
 	cpuhp_remove_multi_state(CPUHP_MD_RAID5_PREPARE);
 	destroy_workqueue(raid5_wq);
 }
-- 
2.39.2

