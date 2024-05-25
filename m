Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43683032A;
	Sat, 25 May 2024 11:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716634803; cv=none; b=LnpaR90fTsWbdzbOdss9UkPMeYEx89hZfsGHAfvwr1aOsdCMAfwqCkNu+JA5Y+U3OvRM7HhSh3OHcoOxphSLXVnfZPDec6pGTr8Ze+/3NTZGMLf6/KGijVpu1E3e+2F02o25ITY8qRiF7bS2yPAJVOUp/EtJW2LRzwJOpu3DBxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716634803; c=relaxed/simple;
	bh=LZvXYMiHOVOJ9bHLljR1O/39ahgXrVwf2Tu33KfAIa0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hc2h6Acm9DYqd3dZIknrCW+R76RHCIr+AwJno1yc65jeG5/IozC2i/ovYUk37zTF6ZtXn74DzVBR5JLTrza+TNOJpR10NQokHu2roD86ee9UBkxFyns/RB8NZ43JZMfxcOPkm18xb1277Td/LfeKAbTdIMAi/nw1t3Rmg8FS+78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vmf7M3xfMz4f3jMS;
	Sat, 25 May 2024 18:59:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id A3F091A01B9;
	Sat, 25 May 2024 18:59:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgBHZQ6mxFFm87GJNg--.25077S5;
	Sat, 25 May 2024 18:59:52 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yi.zhang@huawei.com,
	houtao1@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 1/2] md: change the return value type of md_write_start to void
Date: Sun, 26 May 2024 02:52:56 +0800
Message-Id: <20240525185257.3896201-2-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240525185257.3896201-1-linan666@huaweicloud.com>
References: <20240525185257.3896201-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHZQ6mxFFm87GJNg--.25077S5
X-Coremail-Antispam: 1UD129KBjvJXoWxJFy5XFy8Gr18Zw47Kw1Dtrb_yoWrAFy3p3
	92yFy5Zw4jq3y5X3WDCFWDua45Jw1xKrZFyFW7C34rX3ZxWFWDGa15XayFqrn8uas3C3sI
	q3Z0yayUuF1IqFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmG14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2jI8I6cxK62vIxIIY0VWUZVW8XwA2048vs2IY02
	0E87I2jVAFwI0_Jr4l82xGYIkIc2x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2
	F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjx
	v20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2
	jsIEc7CjxVAFwI0_GcCE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcV
	AaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0E
	x4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI
	8F5VA0II8E6IAqYI8I648v4I1lw4CEc2x0rVAKj4xxMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8
	JrUvcSsGvfC2KfnxnUUI43ZEXa7sR_PrcUUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Commit cc27b0c78c79 ("md: fix deadlock between mddev_suspend() and
md_write_start()") aborted md_write_start() with false when mddev is
suspended, which fixed a deadlock if calling mddev_suspend() with
holding reconfig_mutex(). Since mddev_suspend() now includes
lockdep_assert_not_held(), it no longer holds the reconfig_mutex. This
makes previous abort unnecessary. Now, remove unnecessary abort and
change function return value to void.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.h     |  2 +-
 drivers/md/md.c     | 14 ++++----------
 drivers/md/raid1.c  |  3 +--
 drivers/md/raid10.c |  3 +--
 drivers/md/raid5.c  |  3 +--
 5 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index ca085ecad504..487582058f74 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -785,7 +785,7 @@ extern void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **t
 extern void md_wakeup_thread(struct md_thread __rcu *thread);
 extern void md_check_recovery(struct mddev *mddev);
 extern void md_reap_sync_thread(struct mddev *mddev);
-extern bool md_write_start(struct mddev *mddev, struct bio *bi);
+extern void md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 509e5638cea1..14d6e615bcbb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8638,12 +8638,12 @@ EXPORT_SYMBOL(md_done_sync);
  * A return value of 'false' means that the write wasn't recorded
  * and cannot proceed as the array is being suspend.
  */
-bool md_write_start(struct mddev *mddev, struct bio *bi)
+void md_write_start(struct mddev *mddev, struct bio *bi)
 {
 	int did_change = 0;
 
 	if (bio_data_dir(bi) != WRITE)
-		return true;
+		return;
 
 	BUG_ON(mddev->ro == MD_RDONLY);
 	if (mddev->ro == MD_AUTO_READ) {
@@ -8676,15 +8676,9 @@ bool md_write_start(struct mddev *mddev, struct bio *bi)
 	if (did_change)
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	if (!mddev->has_superblocks)
-		return true;
+		return;
 	wait_event(mddev->sb_wait,
-		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
-		   is_md_suspended(mddev));
-	if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
-		percpu_ref_put(&mddev->writes_pending);
-		return false;
-	}
-	return true;
+		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 }
 EXPORT_SYMBOL(md_write_start);
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7b8a71ca66dd..0d80ff471c73 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1687,8 +1687,7 @@ static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
 	if (bio_data_dir(bio) == READ)
 		raid1_read_request(mddev, bio, sectors, NULL);
 	else {
-		if (!md_write_start(mddev,bio))
-			return false;
+		md_write_start(mddev,bio);
 		raid1_write_request(mddev, bio, sectors);
 	}
 	return true;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a4556d2e46bf..f8d7c02c6ed5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1836,8 +1836,7 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 	    && md_flush_request(mddev, bio))
 		return true;
 
-	if (!md_write_start(mddev, bio))
-		return false;
+	md_write_start(mddev, bio);
 
 	if (unlikely(bio_op(bio) == REQ_OP_DISCARD))
 		if (!raid10_handle_discard(mddev, bio))
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2bd1ce9b3922..a84389311dd1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6078,8 +6078,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 		ctx.do_flush = bi->bi_opf & REQ_PREFLUSH;
 	}
 
-	if (!md_write_start(mddev, bi))
-		return false;
+	md_write_start(mddev, bi);
 	/*
 	 * If array is degraded, better not do chunk aligned read because
 	 * later we might have to read it again in order to reconstruct
-- 
2.39.2

