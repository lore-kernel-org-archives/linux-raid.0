Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7469E2F6176;
	Thu,  6 Nov 2025 12:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762430893; cv=none; b=BVVWHpnLxdQ3VSCYB4MFS7+3eUaXPtPTEJxbOrgLHpxffvp1mYeUcLmlEo4Obc3O3uaCKjqlUWLM8OUcAqFC7k7cGIYU0RP2qUOSdjELYV6YvmPTdg/s1fU34Ha0GqrR3dcoKYu2m0sA8NO5UTLxfmcteDNdyWfYFLDSdpLFYak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762430893; c=relaxed/simple;
	bh=jYhguLBaWZEky69DWVjCyUbBwLLlsERIB3mq+blY6Ys=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eVcL0pfkeXzyigy+5XXxQMq6RM11/kIA8O3iQdGwKXWOHaoo76KMj/WroW6C0lvPxssjmq0S5RlZXn3b/4mE1Ggi9TIIUKJI/yyNplpOZ2tp/afwP/PPiCmoDISSlHz7cC0MTzrdnbzHgaK3HwFzQ1qoUqknPOXyGh2aTno9kNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d2LYP3WLLzKHMn1;
	Thu,  6 Nov 2025 20:07:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 301141A106D;
	Thu,  6 Nov 2025 20:08:02 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgCH3UWfjwxpEbabCw--.33933S12;
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
Subject: [PATCH v2 08/11] md: move finish_reshape to md_finish_sync()
Date: Thu,  6 Nov 2025 19:59:32 +0800
Message-Id: <20251106115935.2148714-9-linan666@huaweicloud.com>
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
X-CM-TRANSID:Syh0CgCH3UWfjwxpEbabCw--.33933S12
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww4Duw1DXFy5uw43Aw1fZwb_yoW8tr43pa
	yxtFn8Gr1UJrWaga1UXa4qka4F934xGrZrtFW3C34fJw1a9w1rJF1Y9a4DXFWvya4FyrW5
	Xw45JrWUuF109aUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

finish_reshape implementations of raid10 and raid5 only update mddev
and rdev configurations. Move these operations to md_finish_sync() as
it is more appropriate.

No functional changes.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 76fd9407e022..d97085a7f613 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9338,6 +9338,8 @@ static void md_finish_sync(struct mddev *mddev, enum sync_action action)
 				set_capacity_and_notify(mddev->gendisk,
 							mddev->array_sectors);
 		}
+		if (mddev->pers->finish_reshape)
+			mddev->pers->finish_reshape(mddev);
 		break;
 	/* */
 	case ACTION_CHECK:
@@ -10140,7 +10142,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 {
 	struct md_rdev *rdev;
 	sector_t old_dev_sectors = mddev->dev_sectors;
-	bool is_reshaped = false;
+	bool is_reshaped = test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 
 	/* resync has finished, collect result */
 	md_unregister_thread(mddev, &mddev->sync_thread);
@@ -10156,12 +10158,6 @@ void md_reap_sync_thread(struct mddev *mddev)
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
@@ -10188,8 +10184,9 @@ void md_reap_sync_thread(struct mddev *mddev)
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

