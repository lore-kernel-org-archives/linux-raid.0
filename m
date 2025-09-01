Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669EA22422F;
	Mon,  1 Sep 2025 03:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756697410; cv=none; b=ShaGEKIqvhMoUfnKp++Lp2eyJVy7V93fM5wxzbvkBgDWABmMVUVXGh0wbYdKLCfVaXC1O4AAFVaHkJ1Kfnz2y9lue75I2RT+yJdK1pUgklPRuo2FXcMOK6MnHXtmXDoAK1vN+o9s/rU/+7kOCJpz8z79itkZIR5ilgr+QcEZxIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756697410; c=relaxed/simple;
	bh=4jgV2BsLdJuzptAziNB3Q9wZwwDNkQI7BZyBzJt/i5g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZULT8XwZRNYVepWWkuL5F8eMkXKzX09MAqfBut/jVtCdcg+lAsM5rt/FIO/Tbiy33FsKkZNwlrGWrdd/gErMrJ8opwcFaKUnoQGPyiI/j2hCE8g7KsFMCgf/H1W5mXL+HaPCSaWc65VmXcuga64r8ExnnSKV/dWZtuoGj0MCv2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cFZBP08LCzKHMtP;
	Mon,  1 Sep 2025 11:30:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CDF951A018D;
	Mon,  1 Sep 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDnMY46E7VoKIf0Aw--.56526S4;
	Mon, 01 Sep 2025 11:30:04 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	pmenzel@molgen.mpg.de,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2] md: prevent incorrect update of resync/recovery offset
Date: Mon,  1 Sep 2025 11:21:12 +0800
Message-Id: <20250901032112.4110355-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnMY46E7VoKIf0Aw--.56526S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr48Gw1rGr15Jry5Ww15Jwb_yoWDKrc_ua
	1xZF97Jr9xGF9rWr1aqr43ZrW3tF4DXr48Xw1ftw1ayFn7t3ZF93Wqk3WrZw1rG3yxWrn0
	q34vv34a9w429jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbT8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I
	8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AK
	xVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcV
	AFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8I
	cIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r
	4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU5g4SUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

In md_do_sync(), when md_sync_action returns ACTION_FROZEN, subsequent
call to md_sync_position() will return MaxSector. This causes
'curr_resync' (and later 'recovery_offset') to be set to MaxSector too,
which incorrectly signals that recovery/resync has completed, even though
disk data has not actually been updated.

To fix this issue, skip updating any offset values when the sync action
is FROZEN. The same holds true for IDLE.

Fixes: 7d9f107a4e94 ("md: use new helpers in md_do_sync()")
Signed-off-by: Li Nan <linan122@huawei.com>
---
v2: fix typo.

 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e78f80d39271..6828a569e819 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9397,6 +9397,9 @@ void md_do_sync(struct md_thread *thread)
 	}
 
 	action = md_sync_action(mddev);
+	if (action == ACTION_FROZEN || action == ACTION_IDLE)
+		goto skip;
+
 	desc = md_sync_action_name(action);
 	mddev->last_sync_action = action;
 
-- 
2.39.2

