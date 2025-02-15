Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B261A23A8;
	Sat, 15 Feb 2025 09:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739611563; cv=none; b=d5BwTAXjPsPtoiAyWF5aYXBe3SeIb+HrecgVtIatatd3RVPh9d/mKF+xROZja9Dn9YbtbU/FMFrGaPaOjy7lOyxe15bK79WV87fQHdqTyCni+EZpIcVypEZObLG2Ed19Z5OkRpHO85pS2vF8SE7VReBclhn/hVgyPaiJZJ7j9iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739611563; c=relaxed/simple;
	bh=/Yd6LGK/voyZCkC/3RwOpE9q0HSaaXjvFUz/GVKwcf8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ClvdprGOCULxG5BLX7a4upyc+t651/EnyP2/87rtmq6gkmBB6CyZH6BcSA9jIrWxRjImghMVq+vStTaqlYpsQZnWbqhQR7z+Z76PHvfIpDaUqZdB9IP8R4v2kUcmlRGoXmWBdeo/b9MsxI5nprH6ynF6TebdTO4RSlQeFzU/qdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yw3Rs09H8z4f3kvM;
	Sat, 15 Feb 2025 17:25:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D4F001A06D7;
	Sat, 15 Feb 2025 17:25:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAni1+bXbBn+Q+iDw--.49525S11;
	Sat, 15 Feb 2025 17:25:51 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.15 7/7] md: switch md-cluster to use md_submodle_head
Date: Sat, 15 Feb 2025 17:22:25 +0800
Message-Id: <20250215092225.2427977-8-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAni1+bXbBn+Q+iDw--.49525S11
X-Coremail-Antispam: 1UD129KBjvJXoW3JFWfZr1UuF13JrW7CrW8tFb_yoW7Xr4kpF
	WSg345Jr1UJrWDWa1UGFyDZFy5Kw1xG3yUt34fJ3sagFnrWrW8JFs8Jr95Ar98Gay3JrnF
	q3WrK3WDu3s5Ar7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYcTQUUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

To make code cleaner, and prepare to add kconfig for bitmap.

Also remove the unsed global variables pers_lock, md_cluster_ops and
md_cluster_mod, and exported symbols register_md_cluster_operations(),
unregister_md_cluster_operations() and md_cluster_ops.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-cluster.c | 14 ++++++++++----
 drivers/md/md-cluster.h |  3 ---
 drivers/md/md.c         | 41 ++++++-----------------------------------
 drivers/md/md.h         |  2 +-
 4 files changed, 17 insertions(+), 43 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 6fd436a1d373..94221d964d4f 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1612,7 +1612,14 @@ static int gather_bitmaps(struct md_rdev *rdev)
 	return err;
 }
 
-static const struct md_cluster_operations cluster_ops = {
+static struct md_cluster_operations cluster_ops = {
+	.head = {
+		.type	= MD_CLUSTER,
+		.id	= ID_CLUSTER,
+		.name	= "cluster",
+		.owner	= THIS_MODULE,
+	},
+
 	.join   = join,
 	.leave  = leave,
 	.slot_number = slot_number,
@@ -1642,13 +1649,12 @@ static int __init cluster_init(void)
 {
 	pr_warn("md-cluster: support raid1 and raid10 (limited support)\n");
 	pr_info("Registering Cluster MD functions\n");
-	register_md_cluster_operations(&cluster_ops, THIS_MODULE);
-	return 0;
+	return register_md_submodule(&cluster_ops.head);
 }
 
 static void cluster_exit(void)
 {
-	unregister_md_cluster_operations();
+	unregister_md_submodule(&cluster_ops.head);
 }
 
 module_init(cluster_init);
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index 4e842af11fb4..8fb06d853173 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -37,9 +37,6 @@ struct md_cluster_operations {
 	void (*update_size)(struct mddev *mddev, sector_t old_dev_sectors);
 };
 
-extern int register_md_cluster_operations(const struct md_cluster_operations *ops,
-		struct module *module);
-extern int unregister_md_cluster_operations(void);
 extern int md_setup_cluster(struct mddev *mddev, int nodes);
 extern void md_cluster_stop(struct mddev *mddev);
 extern void md_reload_sb(struct mddev *mddev, int raid_disk);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d94c9aa8c3aa..4d93cc1aaabc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -81,13 +81,8 @@ static const char *action_name[NR_SYNC_ACTIONS] = {
 
 static DEFINE_XARRAY(md_submodule);
 
-static DEFINE_SPINLOCK(pers_lock);
-
 static const struct kobj_type md_ktype;
 
-static const struct md_cluster_operations *md_cluster_ops;
-static struct module *md_cluster_mod;
-
 static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 static struct workqueue_struct *md_wq;
 
@@ -7452,11 +7447,12 @@ static int update_raid_disks(struct mddev *mddev, int raid_disks)
 
 static int get_cluster_ops(struct mddev *mddev)
 {
-	spin_lock(&pers_lock);
-	mddev->cluster_ops = md_cluster_ops;
-	if (mddev->cluster_ops && !try_module_get(md_cluster_mod))
+	xa_lock(&md_submodule);
+	mddev->cluster_ops = xa_load(&md_submodule, ID_CLUSTER);
+	if (mddev->cluster_ops &&
+	    !try_module_get(mddev->cluster_ops->head.owner))
 		mddev->cluster_ops = NULL;
-	spin_unlock(&pers_lock);
+	xa_unlock(&md_submodule);
 
 	return mddev->cluster_ops == NULL ? -ENOENT : 0;
 }
@@ -7467,7 +7463,7 @@ static void put_cluster_ops(struct mddev *mddev)
 		return;
 
 	mddev->cluster_ops->leave(mddev);
-	module_put(md_cluster_mod);
+	module_put(mddev->cluster_ops->head.owner);
 	mddev->cluster_ops = NULL;
 }
 
@@ -8559,31 +8555,6 @@ void unregister_md_submodule(struct md_submodule_head *msh)
 }
 EXPORT_SYMBOL_GPL(unregister_md_submodule);
 
-int register_md_cluster_operations(const struct md_cluster_operations *ops,
-				   struct module *module)
-{
-	int ret = 0;
-	spin_lock(&pers_lock);
-	if (md_cluster_ops != NULL)
-		ret = -EALREADY;
-	else {
-		md_cluster_ops = ops;
-		md_cluster_mod = module;
-	}
-	spin_unlock(&pers_lock);
-	return ret;
-}
-EXPORT_SYMBOL(register_md_cluster_operations);
-
-int unregister_md_cluster_operations(void)
-{
-	spin_lock(&pers_lock);
-	md_cluster_ops = NULL;
-	spin_unlock(&pers_lock);
-	return 0;
-}
-EXPORT_SYMBOL(unregister_md_cluster_operations);
-
 int md_setup_cluster(struct mddev *mddev, int nodes)
 {
 	int ret = get_cluster_ops(mddev);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 873f33e2a1f6..dd6a28f5d8e6 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -603,7 +603,7 @@ struct mddev {
 	mempool_t *serial_info_pool;
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
 	struct md_cluster_info		*cluster_info;
-	const struct md_cluster_operations *cluster_ops;
+	struct md_cluster_operations *cluster_ops;
 	unsigned int			good_device_nr;	/* good device num within cluster raid */
 	unsigned int			noio_flag; /* for memalloc scope API */
 
-- 
2.39.2

