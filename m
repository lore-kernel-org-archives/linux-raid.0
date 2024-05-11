Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6826623DE;
	Sat, 11 May 2024 07:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715411617; cv=none; b=NhYBy96+pd7ssC3i6GwsVsHCy6AGK60M4xE9MCLZ7yQ/G0pUIkGsq+9HQEFNmNYehzSibIOG8plXtUqLwRU9vYovxDTP9LH5C0eqJbkWJCo9W6xZ6BEJpCCHjv483Gk5LuYDeeLDSWHfpzWYOsXx0ykD+DGb79zRQS7yUTHoP8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715411617; c=relaxed/simple;
	bh=W02rN6+dmjgQHK0sw+P6S03XnBULSaYsnfI6rN3LyVg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rQ+2LPNzyv2vvypcW7CwNSdfGYEBznDlqtkEy3aZ+2Q3GRd+yuFFFhYDZd0Np/BIDGTMRqen69RRujuBAF71hSr4qmY/4QeUlzHOIdx0K2U99hiJaGe/tmew0oqW1GqTLHpWR5MRDxJeRMrM39X+YYmKp5Vf6rDANv2adBfzFCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Vbxmh1NHtz4f3jZ8;
	Sat, 11 May 2024 15:13:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 942C81A016E;
	Sat, 11 May 2024 15:13:29 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgAX5g6XGj9mhzZnMQ--.38080S4;
	Sat, 11 May 2024 15:13:29 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.10] md: remove parameter check_seq for stop_sync_thread()
Date: Sat, 11 May 2024 15:03:17 +0800
Message-Id: <20240511070317.3008687-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX5g6XGj9mhzZnMQ--.38080S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGF1ftw18tFW5Cw45GrWDXFb_yoWrJr4rpr
	WfXF98Ar4UArWfZrW7Ka4DZay5Zrn2qa4DtFy3u3yfJ3Z3trsrGFyY93WUAFykGa4rX3Zx
	AayrJF43Za4xGr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Caller will always set MD_RECOVERY_FROZEN if check_seq is true, and
always clear MD_RECOVERY_FROZEN if check_seq is false, hence replace
the parameter with test_bit() to make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 95b0f9642137..d94899621cbf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4945,15 +4945,10 @@ action_show(struct mddev *mddev, char *page)
  * @locked:	if set, reconfig_mutex will still be held after this function
  *		return; if not set, reconfig_mutex will be released after this
  *		function return.
- * @check_seq:	if set, only wait for curent running sync_thread to stop, noted
- *		that new sync_thread can still start.
  */
-static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
+static void stop_sync_thread(struct mddev *mddev, bool locked)
 {
-	int sync_seq;
-
-	if (check_seq)
-		sync_seq = atomic_read(&mddev->sync_seq);
+	int sync_seq = atomic_read(&mddev->sync_seq);
 
 	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
 		if (!locked)
@@ -4974,7 +4969,8 @@ static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
 
 	wait_event(resync_wait,
 		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-		   (check_seq && sync_seq != atomic_read(&mddev->sync_seq)));
+		   (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery) &&
+		    sync_seq != atomic_read(&mddev->sync_seq)));
 
 	if (locked)
 		mddev_lock_nointr(mddev);
@@ -4985,7 +4981,7 @@ void md_idle_sync_thread(struct mddev *mddev)
 	lockdep_assert_held(&mddev->reconfig_mutex);
 
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	stop_sync_thread(mddev, true, true);
+	stop_sync_thread(mddev, true);
 }
 EXPORT_SYMBOL_GPL(md_idle_sync_thread);
 
@@ -4994,7 +4990,7 @@ void md_frozen_sync_thread(struct mddev *mddev)
 	lockdep_assert_held(&mddev->reconfig_mutex);
 
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	stop_sync_thread(mddev, true, false);
+	stop_sync_thread(mddev, true);
 }
 EXPORT_SYMBOL_GPL(md_frozen_sync_thread);
 
@@ -5019,7 +5015,7 @@ static void idle_sync_thread(struct mddev *mddev)
 		return;
 	}
 
-	stop_sync_thread(mddev, false, true);
+	stop_sync_thread(mddev, false);
 	mutex_unlock(&mddev->sync_mutex);
 }
 
@@ -5033,7 +5029,7 @@ static void frozen_sync_thread(struct mddev *mddev)
 		return;
 	}
 
-	stop_sync_thread(mddev, false, false);
+	stop_sync_thread(mddev, false);
 	mutex_unlock(&mddev->sync_mutex);
 }
 
@@ -6529,7 +6525,7 @@ void md_stop_writes(struct mddev *mddev)
 {
 	mddev_lock_nointr(mddev);
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	stop_sync_thread(mddev, true, false);
+	stop_sync_thread(mddev, true);
 	__md_stop_writes(mddev);
 	mddev_unlock(mddev);
 }
@@ -6597,7 +6593,7 @@ static int md_set_readonly(struct mddev *mddev)
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	}
 
-	stop_sync_thread(mddev, false, false);
+	stop_sync_thread(mddev, false);
 	wait_event(mddev->sb_wait,
 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 	mddev_lock_nointr(mddev);
@@ -6643,7 +6639,7 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	}
 
-	stop_sync_thread(mddev, true, false);
+	stop_sync_thread(mddev, true);
 
 	if (mddev->sysfs_active ||
 	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-- 
2.39.2

