Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D7B19DF66;
	Sat, 15 Feb 2025 09:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739611562; cv=none; b=R1aZWl7KLGnpmDrMsWLzU4uJOtmjMlhJDqtcQR87jattQtUBPVOBmtHejJjLvrIqEQXr6CjFObdCOUORnSbXJTwooG9dlFQkqW9pOu0Z/UuNGCimYjdMWc9uW3xxgOaJuFcRCtwkcN/UCmUzrsCt/Sh2ZeRAdYPkx13vZaam4mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739611562; c=relaxed/simple;
	bh=mEf/5/mWn9TqdX4pKmcnvYDe3r6O80lclM2csFxc2RE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T3tna/pRfxbQXPSElwJbbapKNPPaXwNcQrJ04dhdXQrIFDCL0dV9A/nqhnYXl5S0B8y5iCoc0NL22O1TAgc69+GVCAWGNSbGPhTOO18d3iG2GTvM+hgJg4pDBSKL+85rNwNfjVCsbzFCzeg+Kexvlf76hE2kEOryqoLE6mMMynI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yw3Rx48gxz4f3jqb;
	Sat, 15 Feb 2025 17:25:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B80FA1A1333;
	Sat, 15 Feb 2025 17:25:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAni1+bXbBn+Q+iDw--.49525S5;
	Sat, 15 Feb 2025 17:25:49 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.15 1/7] md: merge common code into find_pers()
Date: Sat, 15 Feb 2025 17:22:19 +0800
Message-Id: <20250215092225.2427977-2-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAni1+bXbBn+Q+iDw--.49525S5
X-Coremail-Antispam: 1UD129KBjvJXoWxXryUWFWxZF45ur15JF17GFg_yoWrtrW3pa
	9ayasxtr48J343twsrJ3WDW3W3Gw1xJrWqvFWfZry3A3Wavr97J3WrWa4rZF9xGa4xArW5
	Zw45K3W5ury3KaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBG14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAVWUtw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUfDGrUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

- pers_lock() are held and released from caller
- try_module_get() is called from caller
- error message from caller

Merge above code into find_pers(), and rename it to get_pers(), also
add a wrapper to module_put() as put_pers().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 68 +++++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 30b3dbbce2d2..37f3a89eba94 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -888,16 +888,37 @@ struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev)
 }
 EXPORT_SYMBOL_GPL(md_find_rdev_rcu);
 
-static struct md_personality *find_pers(int level, char *clevel)
+static struct md_personality *get_pers(int level, char *clevel)
 {
+	struct md_personality *ret = NULL;
 	struct md_personality *pers;
+
+	spin_lock(&pers_lock);
 	list_for_each_entry(pers, &pers_list, list) {
-		if (level != LEVEL_NONE && pers->level == level)
-			return pers;
-		if (strcmp(pers->name, clevel)==0)
-			return pers;
+		if ((level != LEVEL_NONE && pers->level == level) ||
+		    !strcmp(pers->name, clevel)) {
+			if (try_module_get(pers->owner))
+				ret = pers;
+			break;
+		}
 	}
-	return NULL;
+	spin_unlock(&pers_lock);
+
+	if (!ret) {
+		if (level != LEVEL_NONE)
+			pr_warn("md: personality for level %d is not loaded!\n",
+				level);
+		else
+			pr_warn("md: personality for level %s is not loaded!\n",
+				clevel);
+	}
+
+	return ret;
+}
+
+static void put_pers(struct md_personality *pers)
+{
+	module_put(pers->owner);
 }
 
 /* return the offset of the super block in 512byte sectors */
@@ -3931,24 +3952,20 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 
 	if (request_module("md-%s", clevel) != 0)
 		request_module("md-level-%s", clevel);
-	spin_lock(&pers_lock);
-	pers = find_pers(level, clevel);
-	if (!pers || !try_module_get(pers->owner)) {
-		spin_unlock(&pers_lock);
-		pr_warn("md: personality %s not loaded\n", clevel);
+	pers = get_pers(level, clevel);
+	if (!pers) {
 		rv = -EINVAL;
 		goto out_unlock;
 	}
-	spin_unlock(&pers_lock);
 
 	if (pers == mddev->pers) {
 		/* Nothing to do! */
-		module_put(pers->owner);
+		put_pers(pers);
 		rv = len;
 		goto out_unlock;
 	}
 	if (!pers->takeover) {
-		module_put(pers->owner);
+		put_pers(pers);
 		pr_warn("md: %s: %s does not support personality takeover\n",
 			mdname(mddev), clevel);
 		rv = -EINVAL;
@@ -3969,7 +3986,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->raid_disks -= mddev->delta_disks;
 		mddev->delta_disks = 0;
 		mddev->reshape_backwards = 0;
-		module_put(pers->owner);
+		put_pers(pers);
 		pr_warn("md: %s: %s would not accept array\n",
 			mdname(mddev), clevel);
 		rv = PTR_ERR(priv);
@@ -4026,7 +4043,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 			mddev->to_remove = &md_redundancy_group;
 	}
 
-	module_put(oldpers->owner);
+	put_pers(oldpers);
 
 	rdev_for_each(rdev, mddev) {
 		if (rdev->raid_disk < 0)
@@ -6096,20 +6113,11 @@ int md_run(struct mddev *mddev)
 			goto exit_sync_set;
 	}
 
-	spin_lock(&pers_lock);
-	pers = find_pers(mddev->level, mddev->clevel);
-	if (!pers || !try_module_get(pers->owner)) {
-		spin_unlock(&pers_lock);
-		if (mddev->level != LEVEL_NONE)
-			pr_warn("md: personality for level %d is not loaded!\n",
-				mddev->level);
-		else
-			pr_warn("md: personality for level %s is not loaded!\n",
-				mddev->clevel);
+	pers = get_pers(mddev->level, mddev->clevel);
+	if (!pers) {
 		err = -EINVAL;
 		goto abort;
 	}
-	spin_unlock(&pers_lock);
 	if (mddev->level != pers->level) {
 		mddev->level = pers->level;
 		mddev->new_level = pers->level;
@@ -6119,7 +6127,7 @@ int md_run(struct mddev *mddev)
 	if (mddev->reshape_position != MaxSector &&
 	    pers->start_reshape == NULL) {
 		/* This personality cannot handle reshaping... */
-		module_put(pers->owner);
+		put_pers(pers);
 		err = -EINVAL;
 		goto abort;
 	}
@@ -6246,7 +6254,7 @@ int md_run(struct mddev *mddev)
 	if (mddev->private)
 		pers->free(mddev, mddev->private);
 	mddev->private = NULL;
-	module_put(pers->owner);
+	put_pers(pers);
 	mddev->bitmap_ops->destroy(mddev);
 abort:
 	bioset_exit(&mddev->io_clone_set);
@@ -6467,7 +6475,7 @@ static void __md_stop(struct mddev *mddev)
 	mddev->private = NULL;
 	if (pers->sync_request && mddev->to_remove == NULL)
 		mddev->to_remove = &md_redundancy_group;
-	module_put(pers->owner);
+	put_pers(pers);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 
 	bioset_exit(&mddev->bio_set);
-- 
2.39.2

