Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4331922F16E;
	Fri, 25 Jul 2025 03:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753414962; cv=none; b=iDE79asoQFr5dX6g7fnnDG8DwSssJDZx6YW1sWhQibRDdE3xOJyCCq3qzstveKAieC2Cw+5LMdCdBfc8aLjkKpTUMh8bd96CuHX5DVbcrH1BXC9cN78IXAxQkDk4eOUeYnl5ael9fgMzpPuH73YAD/+pfV7TB/i09LvZI51rcRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753414962; c=relaxed/simple;
	bh=KsadSjeTXuC0tvA9XZtW9NEyqKfUsGTFSnPcwTZFjmk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LwxczkwWxM5AuxsnFQ5V93YxiyuYcIfWDw1+ah8fvVve0sTJIGM4b/0rEpNP5YtTXFJ8ZOFDWWtpJ1iRio7VeAJBesBCmcReLr+EOxtNl0O3C8be6jEXj8MOlTWipGLAYygOLVbeOl76rP3upqUwIYDNlB/7BWRofdw/KX8/oic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bpDGR3vRnzKHLxX;
	Fri, 25 Jul 2025 11:42:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4FD681A0F86;
	Fri, 25 Jul 2025 11:42:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3QBEr_YJoP+2eBQ--.51659S7;
	Fri, 25 Jul 2025 11:42:38 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH 3/3] md: factor out a helper add_spare()
Date: Fri, 25 Jul 2025 11:36:05 +0800
Message-Id: <20250725033605.3147379-4-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgB3QBEr_YJoP+2eBQ--.51659S7
X-Coremail-Antispam: 1UD129KBjvJXoWxXr4rtFW7CF13Cr48Xw1xuFg_yoWrGryDpa
	1ft3W5Gr4UArWfua1DWFyDGa43Gw18WrZ7try3ua4fAwnIkr1kK3WrXFyUAry5Aa9Y9F43
	Aw4Utr4UCr18KF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm214x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
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
	xhVjvjDU0xZFpf9x0JU9J5rUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

md-cluster will call remove_and_add_spares() to activate spare, factor out
a helper add_spare() to do this directly and make code cleaner.

Also remove the parameter 'this' for remove_and_add_spares(), since all
callers pass in NULL now.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 64 +++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aea1bf7acf41..841effe742cf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -96,8 +96,6 @@ static struct workqueue_struct *md_wq;
 static struct workqueue_struct *md_misc_wq;
 struct workqueue_struct *md_bitmap_wq;
 
-static int remove_and_add_spares(struct mddev *mddev,
-				 struct md_rdev *this);
 static void remove_spare(struct md_rdev *rdev, bool recovery);
 static void mddev_detach(struct mddev *mddev);
 static void export_rdev(struct md_rdev *rdev, struct mddev *mddev);
@@ -9490,36 +9488,44 @@ static void remove_spares(struct mddev *mddev)
 		remove_spare(rdev, true);
 }
 
-static int remove_and_add_spares(struct mddev *mddev,
-				 struct md_rdev *this)
+static bool add_spare(struct md_rdev *rdev, bool recovery)
+{
+	struct mddev *mddev = rdev->mddev;
+	bool spare;
+
+	/* Mustn't add devices when resync thread is running */
+	if (!recovery && test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		return false;
+
+	spare = rdev_is_spare(rdev);
+	if (!rdev_addable(rdev))
+		return spare;
+
+	if (!test_bit(Journal, &rdev->flags))
+		rdev->recovery_offset = 0;
+
+	if (mddev->pers->hot_add_disk(mddev, rdev) != 0)
+		return spare;
+
+	/* failure here is OK */
+	sysfs_link_rdev(mddev, rdev);
+	if (!test_bit(Journal, &rdev->flags))
+		spare = true;
+
+	md_new_event();
+	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
+	return spare;
+}
+
+static int remove_and_add_spares(struct mddev *mddev)
 {
 	struct md_rdev *rdev;
 	int spares = 0;
 
-	if (this && test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
-		/* Mustn't remove devices when resync thread is running */
-		return 0;
-
 	remove_spares(mddev);
-
-	rdev_for_each(rdev, mddev) {
-		if (this && this != rdev)
-			continue;
-		if (rdev_is_spare(rdev))
+	rdev_for_each(rdev, mddev)
+		if (add_spare(rdev, true))
 			spares++;
-		if (!rdev_addable(rdev))
-			continue;
-		if (!test_bit(Journal, &rdev->flags))
-			rdev->recovery_offset = 0;
-		if (mddev->pers->hot_add_disk(mddev, rdev) == 0) {
-			/* failure here is OK */
-			sysfs_link_rdev(mddev, rdev);
-			if (!test_bit(Journal, &rdev->flags))
-				spares++;
-			md_new_event();
-			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
-		}
-	}
 
 	return spares;
 }
@@ -9550,7 +9556,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 	 * also removed and re-added, to allow the personality to fail the
 	 * re-add.
 	 */
-	*spares = remove_and_add_spares(mddev, NULL);
+	*spares = remove_and_add_spares(mddev);
 	if (*spares) {
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
@@ -9595,7 +9601,7 @@ static void md_start_sync(struct work_struct *ws)
 		 * As we only add devices that are already in-sync, we can
 		 * activate the spares immediately.
 		 */
-		remove_and_add_spares(mddev, NULL);
+		remove_and_add_spares(mddev);
 		goto not_running;
 	}
 
@@ -10118,7 +10124,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 					rdev2->saved_raid_disk = -1;
 				else
 					rdev2->saved_raid_disk = role;
-				ret = remove_and_add_spares(mddev, rdev2);
+				ret = add_spare(rdev2, false);
 				pr_info("Activated spare: %pg\n",
 					rdev2->bdev);
 				/* wakeup mddev->thread here, so array could
-- 
2.39.2

