Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F54831281E;
	Wed, 31 Dec 2025 07:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767165507; cv=none; b=d4JqW5nUuh9HuFJQSzogf5hgj5fAWXsdU4XH9iAL8Y3mTSrTWLmzZed0WNGLq22x5zImYICQcuVL5tUNKUI+kz+ZBN/sOmCaiWB8pLvZnW3H7+zJS6CLLE5xEL0p63Hzh0UTr2NgTtmbILkA/e1x7UzjcD93oEtJrQmor6w9FMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767165507; c=relaxed/simple;
	bh=kuTuoLRmx5kcg7dEJWeHlNg35pF688C2AAva8VDTaqM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NoBU1f0JCdoxZj/0VJFZ62Y6vC0orQXPZ/R3lMEzTjg1ihDDIfUiJwWIluT9cCqd8VAWmoBjt6t7NaFwHEFPoQBzdT/fsubgBsXNbHPmQKZqbEQhD8tGgL3H8DMf9ibaOr4GMDEnd7NtcF479GlsZ1qEGIRODq1YmC+WpIgskFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dh1Vv46k1zYQtpK;
	Wed, 31 Dec 2025 15:17:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9CB1940576;
	Wed, 31 Dec 2025 15:18:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgCX+PgvzlRpTtVyCA--.62349S7;
	Wed, 31 Dec 2025 15:18:17 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	houtao1@huawei.com,
	zhengqixing@huawei.com,
	linan122@h-partners.com
Subject: [RFC PATCH 3/5] md: simplify sync action print in status_resync
Date: Wed, 31 Dec 2025 15:09:50 +0800
Message-Id: <20251231070952.1233903-4-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCX+PgvzlRpTtVyCA--.62349S7
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF43Wr1rCr43JFyfuFWrAFb_yoW8Wr1kpF
	WfAF98urWkJFyfJ3y7t348ZFWrGF1Ut347AF9xu3y5ZF1Sgas5KFyq9a1UXryDGr9Yqan8
	Xa4kGw45uFyjkw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBjb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07Upc_-UUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

No functional change, just code cleanup to make it easier to add new
sync actions later.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 52e09a9a9288..9eeab5258189 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8684,6 +8684,8 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 	sector_t rt, curr_mark_cnt, resync_mark_cnt;
 	int scale, recovery_active;
 	unsigned int per_milli;
+	enum sync_action action;
+	const char *sync_action_name;
 
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
 	    test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
@@ -8765,13 +8767,13 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 			seq_printf(seq, ".");
 		seq_printf(seq, "] ");
 	}
-	seq_printf(seq, " %s =%3u.%u%% (%llu/%llu)",
-		   (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)?
-		    "reshape" :
-		    (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)?
-		     "check" :
-		     (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ?
-		      "resync" : "recovery"))),
+
+	action = md_sync_action(mddev);
+	if (action == ACTION_RECOVER)
+		sync_action_name = "recovery";
+	else
+		sync_action_name = md_sync_action_name(action);
+	seq_printf(seq, " %s =%3u.%u%% (%llu/%llu)", sync_action_name,
 		   per_milli/10, per_milli % 10,
 		   (unsigned long long) resync/2,
 		   (unsigned long long) max_sectors/2);
-- 
2.39.2

