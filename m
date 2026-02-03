Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA2B3783DB;
	Tue,  3 Feb 2026 06:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770099768; cv=none; b=a2hLtzKJN1+jjAyxitLSqFr7L4ujHjOnFwEBmyZuN7AKMCQF2LtDzglNgk8voeFb1l3Vgquh1BBwk1Ml+/CKIoP5udBLL3XTZgievi1o7TxUl8N7VH6DrHScyLfn8wj7Xkj4Ji3+qzcdI78QjbivlLVw4rLdvKSYFNOS5iNbywY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770099768; c=relaxed/simple;
	bh=zxlIu14Ik1sW76tjkzKObQVlNXq145ag6SjJFl5FFzA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q4aS5evTczBDWcRmDUNhPpXzBznIIETBKBmo92GmRmby30aRUi/K+ZoHVIhuark71EJpOo8lcMApqR4E1hzwqKfKwREpA5q7q6PN3fCqF7YZEYwccXEGBfSkQ73VqHDic/kYPEQLqIKkUDsicniLWi5ShutWrReyJ4uR9U/EloY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f4tgd3F0qzKHMYm;
	Tue,  3 Feb 2026 14:22:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BB0C540573;
	Tue,  3 Feb 2026 14:22:42 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBHp_cilIFpIQhbGA--.27054S7;
	Tue, 03 Feb 2026 14:22:42 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com
Cc: xni@redhat.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	houtao1@huawei.com,
	zhengqixing@huawei.com
Subject: [RFC v2 3/5] md: rename mdstat action "recovery" to "recover"
Date: Tue,  3 Feb 2026 14:12:57 +0800
Message-Id: <20260203061259.609206-4-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
References: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHp_cilIFpIQhbGA--.27054S7
X-Coremail-Antispam: 1UD129KBjvJXoW7ArWxGw17JFW3Zw4fCw17ZFb_yoW8WF48pa
	yfAF90krWkJFyfJ3y5Aa4kuFyrGF1Ut347tF9xu3yfJF1ag3WvkFyq9a1DXryDGry0qan8
	Xa4kGr1UAFWYkw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7
	AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UJ
	fHUUUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

Simplify the code in status_resync() that prints the progress of sync
actions.

Also rename the /proc/mdstat action from "recovery" to "recover" to
match the naming used by action_store() and action_show().

Note:
The md-raid-utilities/mdadm test suite will need to be updated to expect
"recover" instead of "recovery" in /proc/mdstat.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7fe02ee21d3e..f319621c6832 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8669,6 +8669,7 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 	sector_t rt, curr_mark_cnt, resync_mark_cnt;
 	int scale, recovery_active;
 	unsigned int per_milli;
+	enum sync_action action;
 
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
 	    test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
@@ -8750,13 +8751,10 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 			seq_printf(seq, ".");
 		seq_printf(seq, "] ");
 	}
+
+	action = md_sync_action(mddev);
 	seq_printf(seq, " %s =%3u.%u%% (%llu/%llu)",
-		   (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)?
-		    "reshape" :
-		    (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)?
-		     "check" :
-		     (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ?
-		      "resync" : "recovery"))),
+		   md_sync_action_name(action),
 		   per_milli/10, per_milli % 10,
 		   (unsigned long long) resync/2,
 		   (unsigned long long) max_sectors/2);
-- 
2.39.2

