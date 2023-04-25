Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D685C6FD18
	for <linux-raid@archiver.kernel.org>; Tue, 25 Apr 2023 11:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbjDYLzE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 Apr 2023 07:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbjDYLzA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 Apr 2023 07:55:00 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C484EFC;
        Tue, 25 Apr 2023 04:54:44 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Q5L5X06btz4f3smL;
        Tue, 25 Apr 2023 19:54:40 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP4 (Coremail) with SMTP id gCh0CgBnHbF+v0dkGEZ+IA--.20559S7;
        Tue, 25 Apr 2023 19:54:41 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     logang@deltatee.com, axboe@kernel.dk, song@kernel.org
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, yukuai3@huawei.com,
        yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com
Subject: [PATCH -next v7 3/5] md/bitmap: always wake up md_thread in timeout_store
Date:   Tue, 25 Apr 2023 19:52:54 +0800
Message-Id: <20230425115256.3663932-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230425115256.3663932-1-yukuai1@huaweicloud.com>
References: <20230425115256.3663932-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBnHbF+v0dkGEZ+IA--.20559S7
X-Coremail-Antispam: 1UD129KBjvdXoWrZrW3Wr13ArW7tF4fGr4rZrb_yoWkurcEga
        nYg3s3JrZrCFy3Kw42yw40vryUtF15u3WkWF92grWIvw17K3ykWry0vr1qv3Z7uFZrCryr
        ArW8Wr4UWw1YkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb6AFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWwA2048vs2IY02
        0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
        8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
        xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
        vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
        r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
        v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
        Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
        0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
        JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIx
        AIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbJ73DUUUUU=
        =
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

md_wakeup_thread() can handle the case that pass in md_thread is NULL,
the only difference is that md_wakeup_thread() will be called when
current timeout is 'MAX_SCHEDULE_TIMEOUT', this should not matter
because timeout_store() is not hot path, and the daemon process is
woke up more than demand from other context already.

This patch prepare to factor out a helper to set timeout.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 920bb68156d2..06b980f71a6b 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2475,11 +2475,11 @@ timeout_store(struct mddev *mddev, const char *buf, size_t len)
 		 * the bitmap is all clean and we don't need to
 		 * adjust the timeout right now
 		 */
-		if (mddev->thread->timeout < MAX_SCHEDULE_TIMEOUT) {
+		if (mddev->thread->timeout < MAX_SCHEDULE_TIMEOUT)
 			mddev->thread->timeout = timeout;
-			md_wakeup_thread(mddev->thread);
-		}
 	}
+
+	md_wakeup_thread(mddev->thread);
 	return len;
 }
 
-- 
2.39.2

