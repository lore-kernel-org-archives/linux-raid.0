Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865A2312809;
	Wed, 31 Dec 2025 07:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767165506; cv=none; b=dE7+UwvZrlqYDb1QDqD3IRMtbcua22YEHYn4FYimCUUirqb/e5k6EL3nky+ExTq/Laa8p3KTzGiIKqKLLziRzId/8fS+YEi26HnrKjWCn8bW3y/y2NLUWfsdA/U4vrhQdrJsTAdwpLD6kEl2G7qlFPFRHfyfXSongRyvclPpKO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767165506; c=relaxed/simple;
	bh=wD8FHpHqkX5jNbiYy0DINKIaJwKn7zGymIepGLy+GOs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o9S9/lMYhN9jp5cSUJSg+6EL2dm1+oihZFY4y7HAU/+FW8K5VSc1iLZSyJ10p9TjnsA8SgfqbB0dK33ZjEkkmFyL4zatB3Nfl2U0PJIJUyrzTBrieh7IOLf3BN1LkijMhDZjLwOs0Fo/FU6v8jfEAkIdlH0TYZET7KSgbP+fl+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dh1Vv3Q97zYQtpK;
	Wed, 31 Dec 2025 15:17:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 82C9E4056C;
	Wed, 31 Dec 2025 15:18:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgCX+PgvzlRpTtVyCA--.62349S6;
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
Subject: [RFC PATCH 2/5] md: clear stale sync flags when frozen before sync starts
Date: Wed, 31 Dec 2025 15:09:49 +0800
Message-Id: <20251231070952.1233903-3-zhengqixing@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgCX+PgvzlRpTtVyCA--.62349S6
X-Coremail-Antispam: 1UD129KBjvdXoW7GFyfCF43GF4ftr4fCw17ZFb_yoWDXwcEkF
	WUA34xWr409FWjgr1qv3WYgry5JFn3WF17WF4Sv3yrZasrur1xGrnYy3W5uw4UZws0kr9x
	K3yDG3W3trs7KjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbf8YFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r15M2
	8IrcIa0xkI8VCY1x0267AKxVW8JVW5JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
	4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY
	6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU82LvtUUUUU==
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

In md_check_recovery(), add clearing of all sync flags when sync is not
running. This fixes the issue where a sync operation is requested, then
'frozen' is executed before MD_RECOVERY_RUNNING is set, leaving stale
operation flags that cause subsequent operations to fail with EBUSY.

Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ccaa2e6fe079..52e09a9a9288 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10336,6 +10336,9 @@ void md_check_recovery(struct mddev *mddev)
 			queue_work(md_misc_wq, &mddev->sync_work);
 		} else {
 			clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+			clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+			clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
+			clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 			wake_up(&resync_wait);
 		}
 
-- 
2.39.2

