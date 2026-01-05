Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E0E2ED151;
	Mon,  5 Jan 2026 11:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767611503; cv=none; b=XEEweJnH5YjBGKTDrDcpObwd1t+xYH1ktBmKyNPbtVePd9q3YpNHjZG2qyG6vAjR23iRIq1Mfa9AB2AUxkV5v5pIdk3Jd/sslMXfwB3yx1Dsx6MMku4uPuKgyviQ3MbsEGDkJRwpj1AudB5whbqzzIvcYeA4VbP/HdY2nWs68yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767611503; c=relaxed/simple;
	bh=uFLBZ61fdvFMU0ss77HHouDEFsodlqcmWMkZg/ZxZi4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JSL7VkOwY/96Qp3o3sFs96fVYqS4MW+jIkLGvVhBYMhmU80hibb23jH2HWIo5GyBBhpqt8Nk4nJCJTrhaX/nG5C70KAnn7mc4DfzYWvCdCfLpAbaIqzaxiG+Hs089qdlLY62J2ifwBeZN0QPPFbpiVMFd4huMJhhAKIymndeaUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dlBS35D2bzKHMnt;
	Mon,  5 Jan 2026 19:10:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D1DD740578;
	Mon,  5 Jan 2026 19:11:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBXuPhmnFtp6EHbCg--.50545S13;
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
Subject: [PATCH v4 09/12] md: move finish_reshape to md_finish_sync()
Date: Mon,  5 Jan 2026 19:02:57 +0800
Message-Id: <20260105110300.1442509-10-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBXuPhmnFtp6EHbCg--.50545S13
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww4Duw4rCF47Cw47Kr1rJFb_yoW8tF45p3
	yIyF98GryUJrZxXa1UXa4qka4F934xKrWDtFW3C34fJw1agr4rJF1Y9a4UXFWvy34FyrW5
	Xw45JFW8uF1I9aUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

finish_reshape implementations of raid10 and raid5 only update mddev
and rdev configurations. Move these operations to md_finish_sync() as
it is more appropriate.

No functional changes.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7090a514b02b..29a931404dbf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9469,6 +9469,8 @@ static void md_finish_sync(struct mddev *mddev, enum sync_action action)
 				set_capacity_and_notify(mddev->gendisk,
 							mddev->array_sectors);
 		}
+		if (mddev->pers->finish_reshape)
+			mddev->pers->finish_reshape(mddev);
 		break;
 	/* */
 	case ACTION_CHECK:
@@ -10306,7 +10308,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 {
 	struct md_rdev *rdev;
 	sector_t old_dev_sectors = mddev->dev_sectors;
-	bool is_reshaped = false;
+	bool is_reshaped = test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 
 	/* resync has finished, collect result */
 	md_unregister_thread(mddev, &mddev->sync_thread);
@@ -10322,12 +10324,6 @@ void md_reap_sync_thread(struct mddev *mddev)
 			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 		}
 	}
-	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-	    mddev->pers->finish_reshape) {
-		mddev->pers->finish_reshape(mddev);
-		if (mddev_is_clustered(mddev))
-			is_reshaped = true;
-	}
 
 	/* If array is no-longer degraded, then any saved_raid_disk
 	 * information must be scrapped.
@@ -10354,8 +10350,9 @@ void md_reap_sync_thread(struct mddev *mddev)
 	 * be changed by md_update_sb, and MD_RECOVERY_RESHAPE is cleared,
 	 * so it is time to update size across cluster.
 	 */
-	if (mddev_is_clustered(mddev) && is_reshaped
-				      && !test_bit(MD_CLOSING, &mddev->flags))
+	if (mddev_is_clustered(mddev) && is_reshaped &&
+	    mddev->pers->finish_reshape &&
+	    !test_bit(MD_CLOSING, &mddev->flags))
 		mddev->cluster_ops->update_size(mddev, old_dev_sectors);
 	/* flag recovery needed just to double check */
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-- 
2.39.2

