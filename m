Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747B832A3C6;
	Thu,  6 Nov 2025 12:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762430893; cv=none; b=rlXs5FXlD+H1MjmjWkdJRoSGmcdMC0NNM8gKWgah4PR42VBDavYq3egjae6QvMOw+7AwUpQC/7clKYpefIZci4Sd9RdmQSyGF2Z0RWliflrBTjpqER3Mb71v0LIsOHTgADV+NM94t7tC8945pMCCTU5USeFUyEqyC3DEyBKOvEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762430893; c=relaxed/simple;
	bh=SlLECH3/lEwEV2GdbCXNnDqy6izCDYPydTuc7r+jMF8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VHLGbf8m1UbpqzjjLfQ0ha2vGvJ1dmBZMRQNfaJsfdJxART3pZLL7X0SR13xuc1O3nJsihb9kPrZjb7n5TgCMIq9jRSMLVgk8iHIUvw9eh2nQuyBR620tfdS85n55UJHx/KWg9JzTA9/SYC1G7Uolw77/NoAoLULJG+Z41zhYYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d2LYP29jZzKHMmN;
	Thu,  6 Nov 2025 20:07:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 0013F1A0B2E;
	Thu,  6 Nov 2025 20:08:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgCH3UWfjwxpEbabCw--.33933S10;
	Thu, 06 Nov 2025 20:08:01 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xni@redhat.com,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 06/11] md: remove MD_RECOVERY_ERROR handling and simplify resync_offset update
Date: Thu,  6 Nov 2025 19:59:30 +0800
Message-Id: <20251106115935.2148714-7-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251106115935.2148714-1-linan666@huaweicloud.com>
References: <20251106115935.2148714-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCH3UWfjwxpEbabCw--.33933S10
X-Coremail-Antispam: 1UD129KBjvJXoWxWw1kGr4DCw13AF17Kry5twb_yoW5CFWkpa
	97AFnxtrW8AFW3ZayqqrykAFWrZw4jkFWqyFW3u397AFnYyF17GFyj93W7JFWqy3sYva1a
	q34rGF43ZF18Ww7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWU
	tVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQeOt
	UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

When sync IO failed and setting badblock also failed, unsynced disk
might be kicked via setting 'recovery_disable' without Faulty flag.
MD_RECOVERY_ERROR was set in md_sync_error() to prevent updating
'resync_offset', avoiding reading the failed sync sectors.

Previous patch ensures disk is marked Faulty when badblock setting fails.
Remove MD_RECOVERY_ERROR handling as it's no longer needed - failed sync
sectors are unreadable either via badblock or Faulty disk.

Simplify resync_offset update logic.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.h |  2 --
 drivers/md/md.c | 23 +++++------------------
 2 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 18621dba09a9..c5b5377e9049 100644
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
index 2bdbb5b0e9e1..71988d8f5154 100644
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
@@ -9603,8 +9602,8 @@ void md_do_sync(struct md_thread *thread)
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
 
 	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    mddev->curr_resync >= MD_RESYNC_ACTIVE) {
+		/* All sync IO completes after recovery_active becomes 0 */
 		mddev->curr_resync_completed = mddev->curr_resync;
 		sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	}
@@ -9612,24 +9611,12 @@ void md_do_sync(struct md_thread *thread)
 
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

