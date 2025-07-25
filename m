Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4843F236431;
	Fri, 25 Jul 2025 03:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753414962; cv=none; b=f7va0Vd9FbIv493BjoJkIbl4cHAfpNUNInQpZqP8qY7nsyvvQrfMy0J4RP4n1REMpceYtKmm2tcCJXp1Ubo7sZ0UAy8pqR1/yzbxp560+Nu2UquQhpmn39qqaUhlD2e0qVVffNt6fPYCb8+ZotrbG1FEzws0phMUhjzyKb8WM1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753414962; c=relaxed/simple;
	bh=0kRtxAUEnPWvxnoOUidxKdQViNPJ4AFXDQ7w9monGPE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VZ0zBQLyU5fj83ryvvJdbdQqij9AignZg8L/VJ8qzsNvxh8if8wA8iCpqqfnSpY+FZwc2Q7ARY1HhkB+2W1UsCE39J4iMaIQL6955dD8PKdrHgOYXyRN3R2QeQYFwDhE1djvdrWj+z8kp7sXrZJBKqBdrrSQ0RKShonVddcl3kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bpDGR1sjszYQv22;
	Fri, 25 Jul 2025 11:42:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id ED7FD1A018D;
	Fri, 25 Jul 2025 11:42:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3QBEr_YJoP+2eBQ--.51659S6;
	Fri, 25 Jul 2025 11:42:37 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH 2/3] md: factor out a helper remove_spare()
Date: Fri, 25 Jul 2025 11:36:04 +0800
Message-Id: <20250725033605.3147379-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250725033605.3147379-1-yukuai1@huaweicloud.com>
References: <20250725033605.3147379-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3QBEr_YJoP+2eBQ--.51659S6
X-Coremail-Antispam: 1UD129KBjvJXoWxCF15Cw4DWry5XrWrKF4DArb_yoWrWF43pa
	1ftFn8Gr4UA3yfJr4UCF4DGa45Kr10qrWvya43ua4xX3W3Cr1qqa4rWFWUAr9YyasY9F45
	Aa18ta15CryIgF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm214x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAVWUtw
	CF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7AKxVWUAVWUtwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVF
	xhVjvjDU0xZFpf9x0JUFoGdUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

If users specify a rdev to remove, remove_and_add_spares() will be
called from sysfs/ioctl path with the parameter 'this' set to the rdev,
factor out a helper remove_spare() to make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 53 +++++++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a0c05b37d087..aea1bf7acf41 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -98,6 +98,7 @@ struct workqueue_struct *md_bitmap_wq;
 
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
+static void remove_spare(struct md_rdev *rdev, bool recovery);
 static void mddev_detach(struct mddev *mddev);
 static void export_rdev(struct md_rdev *rdev, struct mddev *mddev);
 static void md_wakeup_thread_directly(struct md_thread __rcu *thread);
@@ -2976,7 +2977,7 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	} else if (cmd_match(buf, "remove")) {
 		if (rdev->mddev->pers) {
 			clear_bit(Blocked, &rdev->flags);
-			remove_and_add_spares(rdev->mddev, rdev);
+			remove_spare(rdev, false);
 		}
 		if (rdev->raid_disk >= 0)
 			err = -EBUSY;
@@ -3180,7 +3181,7 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		if (rdev->mddev->pers->hot_remove_disk == NULL)
 			return -EINVAL;
 		clear_bit(Blocked, &rdev->flags);
-		remove_and_add_spares(rdev->mddev, rdev);
+		remove_spare(rdev, false);
 		if (rdev->raid_disk >= 0)
 			return -EBUSY;
 		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
@@ -7135,7 +7136,7 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 		goto kick_rdev;
 
 	clear_bit(Blocked, &rdev->flags);
-	remove_and_add_spares(mddev, rdev);
+	remove_spare(rdev, false);
 
 	if (rdev->raid_disk >= 0)
 		goto busy;
@@ -9459,29 +9460,34 @@ static bool md_spares_need_change(struct mddev *mddev)
 	return false;
 }
 
-static bool remove_spares(struct mddev *mddev, struct md_rdev *this)
+static void remove_spare(struct md_rdev *rdev, bool recovery)
 {
-	struct md_rdev *rdev;
-	bool removed = false;
+	struct mddev *mddev = rdev->mddev;
 
-	rdev_for_each(rdev, mddev) {
-		if ((this == NULL || rdev == this) && rdev_removeable(rdev) &&
-		    !mddev->pers->hot_remove_disk(mddev, rdev)) {
-			sysfs_unlink_rdev(mddev, rdev);
-			rdev->saved_raid_disk = rdev->raid_disk;
-			rdev->raid_disk = -1;
-			removed = true;
-		}
-	}
+	/* Mustn't remove devices when resync thread is running */
+	if (!recovery && test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		return;
 
-	if (removed) {
-		if (mddev->kobj.sd)
-			sysfs_notify_dirent_safe(mddev->sysfs_degraded);
+	if (!rdev_removeable(rdev) ||
+	    mddev->pers->hot_remove_disk(mddev, rdev) != 0)
+		return;
 
-		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
-	}
+	sysfs_unlink_rdev(mddev, rdev);
+	rdev->saved_raid_disk = rdev->raid_disk;
+	rdev->raid_disk = -1;
+
+	if (mddev->kobj.sd)
+		sysfs_notify_dirent_safe(mddev->sysfs_degraded);
 
-	return this && removed;
+	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
+}
+
+static void remove_spares(struct mddev *mddev)
+{
+	struct md_rdev *rdev;
+
+	rdev_for_each(rdev, mddev)
+		remove_spare(rdev, true);
 }
 
 static int remove_and_add_spares(struct mddev *mddev,
@@ -9494,8 +9500,7 @@ static int remove_and_add_spares(struct mddev *mddev,
 		/* Mustn't remove devices when resync thread is running */
 		return 0;
 
-	if (remove_spares(mddev, this))
-		return 0;
+	remove_spares(mddev);
 
 	rdev_for_each(rdev, mddev) {
 		if (this && this != rdev)
@@ -9534,7 +9539,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 
 	/* Check if resync is in progress. */
 	if (mddev->recovery_cp < MaxSector) {
-		remove_spares(mddev, NULL);
+		remove_spares(mddev);
 		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 		return true;
-- 
2.39.2

