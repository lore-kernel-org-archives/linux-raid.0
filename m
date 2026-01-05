Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D032E2877ED;
	Mon,  5 Jan 2026 11:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767611504; cv=none; b=BIYKxYo3KsvnbIOZiGPd8BXMVVfinc5Bnngmuz4BhsuWX6EuOq33Nkd65DxIrxE4sTQS4QLVxRf/uG06sa41bhJJMin9H3xOD6QTF/WC4AxlzkdB8UFuH9gLPPxHh1DbNMvfoiZZoAURt44KnIdI+zVtY5/4gMYQTepseMFZ9M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767611504; c=relaxed/simple;
	bh=Ql9ZMitRNdYZIklGACeSLdg5l0/XpaNOe77wCQwgCX8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ea2I2CKGE7mj699OhhCAGTRootd0NX2PJIJby+pIkQXD1NldPloMky2SxP2j0o47yo2AQof90IP98q3SdkUar2YDwUJGRPBRjnSu36zsmR1v4tHFJ2ltLVNhIioneGqpOG6Vu8bE2T2JEA88aMrY9f+OA23YfsyAb8YLJ1HEwgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dlBS33cjqzKHMm0;
	Mon,  5 Jan 2026 19:10:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 99A2E40562;
	Mon,  5 Jan 2026 19:11:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBXuPhmnFtp6EHbCg--.50545S10;
	Mon, 05 Jan 2026 19:11:37 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v4 06/12] md: update curr_resync_completed even when MD_RECOVERY_INTR is set
Date: Mon,  5 Jan 2026 19:02:54 +0800
Message-Id: <20260105110300.1442509-7-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260105110300.1442509-1-linan666@huaweicloud.com>
References: <20260105110300.1442509-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXuPhmnFtp6EHbCg--.50545S10
X-Coremail-Antispam: 1UD129KBjvJXoW7AFy7XryDCr4fWw1UKrWxZwb_yoW8XF45p3
	97J3sIkrW8ZFWayF4DXr1rXFyrZ3y7tFW7AFW3W34UAan5Aw17JF1Fg3WUXFWDAr9Yqa1f
	t34rG343Z3W8Gw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQ014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF
	x2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14
	v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY
	67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOPfHDUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

An error sync IO may be done and sub 'recovery_active' while its
error handling work is pending. This work sets 'recovery_disabled'
and MD_RECOVERY_INTR, then later removes the bad disk without Faulty
flag. If 'curr_resync_completed' is updated before the disk is removed,
it could lead to reading from sync-failed regions.

With the previous patch, error IO will set badblocks or mark rdev as
Faulty, sync-failed regions are no longer readable. After waiting for
'recovery_active' to reach 0 (in the previous line), all sync IO has
*completed*, regardless of whether MD_RECOVERY_INTR is set. Thus, the
MD_RECOVERY_INTR check can be removed.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 90e128fc1397..7c3271808e69 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9734,8 +9734,8 @@ void md_do_sync(struct md_thread *thread)
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
 
 	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    mddev->curr_resync >= MD_RESYNC_ACTIVE) {
+		/* All sync IO completes after recovery_active becomes 0 */
 		mddev->curr_resync_completed = mddev->curr_resync;
 		sysfs_notify_dirent_safe(mddev->sysfs_completed);
 	}
-- 
2.39.2

