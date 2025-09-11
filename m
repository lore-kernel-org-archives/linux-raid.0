Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF49622688C;
	Thu, 11 Sep 2025 02:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757556855; cv=none; b=GYzuVkDdmDfzkKZOatNMSrJCr51cHJ65xXtNmeEGFv27mGsXQlhQ55HGD4Vj0Zutu6TiCXzZayrHdCXhxgBvs1D50+EO1csPRMghhHGreW+jPwnWBPOq6fgWtpY36BhTiyDX545I4MDVfehOqO4JCGZHWZ2L5OK+tq9yMUeUgvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757556855; c=relaxed/simple;
	bh=NYk+J3TxnugVMW8N87nZeLVSpy8PPYUt4pSGRrwVsqI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ADXBKHLmfQrIpi16zEhpEu3crtzNIUGmC/ODu6M7z4PpEF0uxEZj9ug3I5pR/L42hPL6lQRKxzDpHSFV0WXbJmFssZXwSNYrYCi+ecGQOX9G/RBVinNetQfYNdhpElpQ/rZpPBh43PpA4sBpcILeSqgEqISEpBNChsN4zbPJ1+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cMh2D05bkzYQtH7;
	Thu, 11 Sep 2025 10:14:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 817A01A1276;
	Thu, 11 Sep 2025 10:14:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAncIxwMMJonK1mCA--.55496S5;
	Thu, 11 Sep 2025 10:14:10 +0800 (CST)
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
Subject: [PATCH 2/3] md: fix incorrect sync progress update on sync read errors
Date: Thu, 11 Sep 2025 10:04:40 +0800
Message-Id: <20250911020441.2858174-2-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250911020441.2858174-1-linan666@huaweicloud.com>
References: <20250911020441.2858174-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncIxwMMJonK1mCA--.55496S5
X-Coremail-Antispam: 1UD129KBjvJXoWxZw4rZrW5WF43KF4UuF4Uurg_yoW7Gr47p3
	93Jasxtr1UXFWSqFWDJw1DAFZ5ZrWjyFWDtrW3W3yxJw1Syr17GFyYgF1xJrWDA3sYya1F
	q34rJrsxZ3W7Ww7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmm14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2vY
	z4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
	4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4
	kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
	s4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r
	1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWU
	JVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r
	1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1U
	YxBIdaVFxhVjvjDU0xZFpf9x0JUfsqAUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

When a sync read fails and badblocks recording fails (exceeding the 512),
the device is not immediately marked Faulty. Instead, 'recovery_disabled'
is set, and non-In_sync devices are removed later. This preserves array
availability: if users never read the damaged region, the raid remains
available and gains fault tolerance.

However, during the brief window before the device removal,
resync/recovery_offset was incorrectly updated to include the bad sectors.
This could lead to inconsistent data being read from those sectors.

Fix it by:
 - Set MD_RECOVERY_ERROR when bad block recording fails for sync reads.
 - Do not update curr_resync_completed if MD_RECOVERY_ERROR set.
 - Use curr_resync_completed as the final resync progress indicator.

Fixes: 5e5702898e93 ("md/raid10: Handle read errors during recovery better.")
Fixes: 3a9f28a5117e ("md/raid1: improve handling of read failure during recovery.")
Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c     | 48 ++++++++++++++++++---------------------------
 drivers/md/raid10.c |  2 +-
 2 files changed, 20 insertions(+), 30 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0094830126b4..f3abfc140481 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9470,18 +9470,20 @@ void md_do_sync(struct md_thread *thread)
 		     time_after_eq(jiffies, update_time + UPDATE_FREQUENCY) ||
 		     (j - mddev->curr_resync_completed)*2
 		     >= mddev->resync_max - mddev->curr_resync_completed ||
-		     mddev->curr_resync_completed > mddev->resync_max
-			    )) {
+		     mddev->curr_resync_completed > mddev->resync_max)) {
 			/* time to update curr_resync_completed */
 			wait_event(mddev->recovery_wait,
 				   atomic_read(&mddev->recovery_active) == 0);
-			mddev->curr_resync_completed = j;
-			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
-			    j > mddev->resync_offset)
-				mddev->resync_offset = j;
-			update_time = jiffies;
-			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
-			sysfs_notify_dirent_safe(mddev->sysfs_completed);
+
+			if (!test_bit(MD_RECOVERY_ERROR, &mddev->recovery)) {
+				mddev->curr_resync_completed = j;
+				if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
+				    j > mddev->resync_offset)
+					mddev->resync_offset = j;
+				update_time = jiffies;
+				set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
+				sysfs_notify_dirent_safe(mddev->sysfs_completed);
+			}
 		}
 
 		while (j >= mddev->resync_max &&
@@ -9594,7 +9596,7 @@ void md_do_sync(struct md_thread *thread)
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
 
 	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
+	    !test_bit(MD_RECOVERY_ERROR, &mddev->recovery) &&
 	    mddev->curr_resync >= MD_RESYNC_ACTIVE) {
 		mddev->curr_resync_completed = mddev->curr_resync;
 		sysfs_notify_dirent_safe(mddev->sysfs_completed);
@@ -9602,32 +9604,20 @@ void md_do_sync(struct md_thread *thread)
 	mddev->pers->sync_request(mddev, max_sectors, max_sectors, &skipped);
 
 	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
-	    mddev->curr_resync > MD_RESYNC_ACTIVE) {
+	    mddev->curr_resync_completed > MD_RESYNC_ACTIVE) {
+		if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
+			mddev->curr_resync_completed = MaxSector;
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
+			mddev->resync_offset = mddev->curr_resync_completed;
 		} else {
-			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
-				mddev->curr_resync = MaxSector;
 			if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 			    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
 				rcu_read_lock();
 				rdev_for_each_rcu(rdev, mddev)
 					if (mddev->delta_disks >= 0 &&
-					    rdev_needs_recovery(rdev, mddev->curr_resync))
-						rdev->recovery_offset = mddev->curr_resync;
+					    rdev_needs_recovery(rdev, mddev->curr_resync_completed))
+						rdev->recovery_offset = mddev->curr_resync_completed;
 				rcu_read_unlock();
 			}
 		}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 02e1c3db70ca..c3cfbb0347e7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2543,7 +2543,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 
 					conf->mirrors[dw].recovery_disabled
 						= mddev->recovery_disabled;
-					set_bit(MD_RECOVERY_INTR,
+					set_bit(MD_RECOVERY_ERROR,
 						&mddev->recovery);
 					break;
 				}
-- 
2.39.2

