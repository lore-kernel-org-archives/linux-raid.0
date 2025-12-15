Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713E231B10D;
	Mon, 15 Dec 2025 03:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765768550; cv=none; b=C1yMpaiJUBW3FlbJbxUTMMVOxHb1TTXgJrNSVgwMuHY4AXJhJ7WmGMJIFHLVmh8n2eaXGz9E1Lh0zZWvUQdu1XlN/KqDkJqVzn5lr7wWG4E850poy6Wtfm23cv+flzMTE+/JY4/eKPuUBpzeush54SybOHAGhZuTJ2yMjDxYYzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765768550; c=relaxed/simple;
	bh=DITdeuSDgcX/8EY6fDxXYdTjR4ZgDX/mlTbPqKaMZsA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H6qPATnqk/1ZX1/wQeF9WNe81aZnnAIN1oM8CE9UHAJLFFA1WTBJD1x2AsHxor3Wa0+P+LCQcxUkwWZSfhDugRI9uPEeGsPwu3PHdCH/0gnAS7zWnbiyAGn+AyWu3SVyhv963qp/fQvOHW0ARZVYY1iHi+B7y9YNNdWbYmRhoB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dV4tn1DLQzYQtny;
	Mon, 15 Dec 2025 11:15:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 075F91A06DC;
	Mon, 15 Dec 2025 11:15:36 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_dUfT9p8AnuAA--.53622S12;
	Mon, 15 Dec 2025 11:15:35 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 08/13] md: remove MD_RECOVERY_ERROR handling and simplify resync_offset update
Date: Mon, 15 Dec 2025 11:04:39 +0800
Message-Id: <20251215030444.1318434-9-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251215030444.1318434-1-linan666@huaweicloud.com>
References: <20251215030444.1318434-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXd_dUfT9p8AnuAA--.53622S12
X-Coremail-Antispam: 1UD129KBjvJXoW7tr4UWrW8Jr4Dtr1UCF1UGFg_yoW8KF1rpa
	93AFnxXw4UZFW3ZrWqqFykZayrZr12yrWqkFW3u393JF9ay3W7GFy293W7JFWDJ3s7AF4a
	qa4rJFsxZ3WxWw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHa14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOPfHDU
	UUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Following previous patch "md: update curr_resync_completed even when
MD_RECOVERY_INTR is set", 'curr_resync_completed' always equals
'curr_resync' for resync, so MD_RECOVERY_ERROR can be removed.

Also, simplify resync_offset update logic.

Signed-off-by: Li Nan <linan122@huawei.com>
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
index cda434d8fe8c..29a34594c765 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9041,7 +9041,6 @@ void md_sync_error(struct mddev *mddev)
 {
 	// stop recovery, signal do_sync ....
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-	set_bit(MD_RECOVERY_ERROR, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 }
 EXPORT_SYMBOL(md_sync_error);
@@ -9704,24 +9703,12 @@ void md_do_sync(struct md_thread *thread)
 
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

