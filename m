Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8290FC04A6A
	for <linux-raid@archiver.kernel.org>; Thu,  3 Aug 2023 13:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbjHCNeE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Aug 2023 09:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235181AbjHCNdk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Aug 2023 09:33:40 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0200046A0;
        Thu,  3 Aug 2023 06:32:32 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RGqXD16Xwz4f3lVM;
        Thu,  3 Aug 2023 21:32:28 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP4 (Coremail) with SMTP id gCh0CgAHuKtqrMtkWHLlPQ--.49699S9;
        Thu, 03 Aug 2023 21:32:29 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     song@kernel.org, xni@redhat.com
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com,
        yangerkun@huawei.com
Subject: [PATCH -next 05/29] md: use new apis to suspend array for suspend_lo/hi/store()
Date:   Thu,  3 Aug 2023 21:29:06 +0800
Message-Id: <20230803132930.2742286-6-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230803132930.2742286-1-yukuai1@huaweicloud.com>
References: <20230803132930.2742286-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHuKtqrMtkWHLlPQ--.49699S9
X-Coremail-Antispam: 1UD129KBjvJXoWrZFW8ur1UKr15KFyUCr47CFg_yoW8JF15pF
        4xtFWfXr1jyrySqryqqa1vkFy5Jw17KrWqyrZruw1kGa4xJw13Gr15ursYqry09a4fGFn8
        Ja15W3W8ZF48G37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
        kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
        z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
        4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
        3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
        IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4U
        M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20E
        Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267
        AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUqiihUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

Convert to use new apis, the old apis will be removed eventually.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3c98f253b980..e516c5000a00 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5271,15 +5271,10 @@ suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
 	if (new != (sector_t)new)
 		return -EINVAL;
 
-	err = mddev_lock(mddev);
-	if (err)
-		return err;
-
-	mddev_suspend(mddev);
+	__mddev_suspend(mddev);
 	WRITE_ONCE(mddev->suspend_lo, new);
-	mddev_resume(mddev);
+	__mddev_resume(mddev);
 
-	mddev_unlock(mddev);
 	return len;
 }
 static struct md_sysfs_entry md_suspend_lo =
@@ -5304,15 +5299,10 @@ suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
 	if (new != (sector_t)new)
 		return -EINVAL;
 
-	err = mddev_lock(mddev);
-	if (err)
-		return err;
-
-	mddev_suspend(mddev);
+	__mddev_suspend(mddev);
 	WRITE_ONCE(mddev->suspend_hi, new);
-	mddev_resume(mddev);
+	__mddev_resume(mddev);
 
-	mddev_unlock(mddev);
 	return len;
 }
 static struct md_sysfs_entry md_suspend_hi =
-- 
2.39.2

