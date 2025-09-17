Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6327432D5B9;
	Wed, 17 Sep 2025 09:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758102305; cv=none; b=jIUHA3O0+r1T8kizu+i+n4Ia+H/ued3orNa0K7Fwa6tRHu0Ng4W7lt5y28ehS3EnppYZbfF3f257R0cQ50pg4gNIftOiJ4bD0yJ0qpJ/uT3F/znX3kzqTF3Z++6pcCV85z50ZZWoLPsGvAWJl8MJVtsLkdQaieUkoCig23KLW4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758102305; c=relaxed/simple;
	bh=EdcdBTPdOeEgy/QSJeXDtej1igZrg5A6xFCs5C27UZc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dDvvAlgeetThuhZoOatAG8zvwsbb4/fXI5bnCC87ihjKHcgtIo10FNkFGlNTy+k+d+DsSf8O9Ockh8YoEUxRRguOMVAnjw8gdm7Fz9dp6gcplSwsuna47+6qhj0MI5M4GHRNSHQwtrukwwrGxad/ycQFom2HSw59NWNdCcUY1RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cRYlf30MgzYQvJh;
	Wed, 17 Sep 2025 17:45:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 094211A2DC1;
	Wed, 17 Sep 2025 17:45:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY0Zg8poSuc1Cw--.51298S7;
	Wed, 17 Sep 2025 17:45:00 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH 3/7] md: cleanup MD_RECOVERY_ERROR flag
Date: Wed, 17 Sep 2025 17:35:04 +0800
Message-Id: <20250917093508.456790-4-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250917093508.456790-1-linan666@huaweicloud.com>
References: <20250917093508.456790-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY0Zg8poSuc1Cw--.51298S7
X-Coremail-Antispam: 1UD129KBjvJXoWxJF1ktrWfGrWDZF4xCryDKFg_yoW5Ar1xpa
	93JF9IvryUZFW3ZFWqqa4DJFyrZw1jyFWqyFW3u393JasYyF47GFyYg3W7JrWDt34vyF4Y
	q3s5Jr43ZF18Ww7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUml14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxw
	AKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E
	4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGV
	WUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_
	Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rV
	WUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4U
	JbIYCTnIWIevJa73UjIFyTuYvjfUYmhFUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

The MD_RECOVERY_ERROR flag prevented bad sectors from updating
'resync_offset' when badblocks failed to set during sync errors.
Now that failure to set badblocks definitively marks the disk as
Faulty, this flag is redundant. In both scenarios (successful
badblock marking or disk fault), the bad sectors becomes unreadable
and its handling is considered completed.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.h |  2 --
 drivers/md/md.c | 22 ++++------------------
 2 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index ba567b63afd3..07a22f3772d8 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -644,8 +644,6 @@ enum recovery_flags {
 	MD_RECOVERY_FROZEN,
 	/* waiting for pers->start() to finish */
 	MD_RECOVERY_WAIT,
-	/* interrupted because io-error */
-	MD_RECOVERY_ERROR,
 
 	/* flags determines sync action, see details in enum sync_action */
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 05b6b3145648..c4d765d57af7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8949,7 +8949,6 @@ void md_sync_error(struct mddev *mddev)
 {
 	// stop recovery, signal do_sync ....
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-	set_bit(MD_RECOVERY_ERROR, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 }
 EXPORT_SYMBOL(md_sync_error);
@@ -9598,7 +9597,6 @@ void md_do_sync(struct md_thread *thread)
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
 
 	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    mddev->curr_resync >= MD_RESYNC_ACTIVE) {
 		mddev->curr_resync_completed = mddev->curr_resync;
 		sysfs_notify_dirent_safe(mddev->sysfs_completed);
@@ -9607,24 +9605,12 @@ void md_do_sync(struct md_thread *thread)
 
 	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
 	    mddev->curr_resync > MD_RESYNC_ACTIVE) {
+		if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
+			mddev->curr_resync = MaxSector;
+
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
-				if (mddev->curr_resync >= mddev->resync_offset) {
-					pr_debug("md: checkpointing %s of %s.\n",
-						 desc, mdname(mddev));
-					if (test_bit(MD_RECOVERY_ERROR,
-						&mddev->recovery))
-						mddev->resync_offset =
-							mddev->curr_resync_completed;
-					else
-						mddev->resync_offset =
-							mddev->curr_resync;
-				}
-			} else
-				mddev->resync_offset = MaxSector;
+			mddev->resync_offset = mddev->curr_resync;
 		} else {
-			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
-				mddev->curr_resync = MaxSector;
 			if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 			    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
 				rcu_read_lock();
-- 
2.39.2

