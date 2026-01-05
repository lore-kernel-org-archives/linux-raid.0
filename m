Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85F725F96D;
	Mon,  5 Jan 2026 11:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767611503; cv=none; b=DJcrtCtUEO66Evssp6pWqgc2iwn24U1XqtpbPy7PMumYmOD1ZnZm6MFkNNv028inijzkSTs5I6E4DgtNCw2aqov5siJfeT10RZeY09xHExYANGvVAW9jlwn/kL25/5TtxslCChNq34DWJrP3j+qPDIT5+QeAFrpVbtercjX3e3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767611503; c=relaxed/simple;
	bh=c31ynZZaQWgJG+NWGXm+BtjCAm8izmdX0OzwJKunLdo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ay89MnKdGoYgh12KIViesGNtr/wBKXQSVLsl2DlCk2RzExVoAwTZmCV79E6PrltRQ2GTtAVmZLVAqKGM7EtZyn7xv6AR0iyIeRlaPPWKMSQF7ZbAphdYjhElfdVkTXI2aYDvOqh+lkvQ98dIBz+YnIGDeLgxmXZR/uKjMqx87Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dlBRf6s1yzYQtxf;
	Mon,  5 Jan 2026 19:10:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AE01F4058C;
	Mon,  5 Jan 2026 19:11:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBXuPhmnFtp6EHbCg--.50545S11;
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
Subject: [PATCH v4 07/12] md: remove MD_RECOVERY_ERROR handling and simplify resync_offset update
Date: Mon,  5 Jan 2026 19:02:55 +0800
Message-Id: <20260105110300.1442509-8-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBXuPhmnFtp6EHbCg--.50545S11
X-Coremail-Antispam: 1UD129KBjvJXoW7tr4UWrW8Jr4Dtr1UZry5Jwb_yoW8KFWkpa
	yfAFnxXw48ZFW3ZFWqqa4kZayrZr12yFWqkFW3u393JF9Yy3W3GFyj93W7JrWDJ3s7AF4a
	qa4rJFsxZ3W8Ww7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Following previous patch "md: update curr_resync_completed even when
MD_RECOVERY_INTR is set", 'curr_resync_completed' always equals
'curr_resync' for resync, so MD_RECOVERY_ERROR can be removed.

Also, simplify resync_offset update logic.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.h |  2 --
 drivers/md/md.c | 21 ++++-----------------
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8871c88ceef1..698897f20385 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -646,8 +646,6 @@ enum recovery_flags {
 	MD_RECOVERY_FROZEN,
 	/* waiting for pers->start() to finish */
 	MD_RECOVERY_WAIT,
-	/* interrupted because io-error */
-	MD_RECOVERY_ERROR,
 
 	/* flags determines sync action, see details in enum sync_action */
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7c3271808e69..d452a1128da8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9080,7 +9080,6 @@ void md_sync_error(struct mddev *mddev)
 {
 	// stop recovery, signal do_sync ....
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-	set_bit(MD_RECOVERY_ERROR, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 }
 EXPORT_SYMBOL(md_sync_error);
@@ -9743,24 +9742,12 @@ void md_do_sync(struct md_thread *thread)
 
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

